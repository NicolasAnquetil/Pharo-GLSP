// Build the browser client, serve it over HTTP, and bridge each browser WebSocket to its own TCP
// connection to the Pharo GLSP server (GLSPSocketLauncher).
//   WebSocket side: one JSON-RPC message per text frame (GLSP browser client)
//   TCP side:       'Content-Length: <bytes>\r\n\r\n<json>' framing (vscode-jsonrpc / LSP)
// Each diagram has its own Pharo GLSP server: the WebSocket path tells which one
//   /archmap -> glspPort (architectural map), /dsm -> dsmPort (DSM)
// Usage: node server.js [httpPort=8080] [glspHost=127.0.0.1] [glspPort=5007] [dsmPort=5008]
const http = require('http');
const net = require('net');
const fs = require('fs');
const path = require('path');
const esbuild = require('esbuild');
const { WebSocketServer } = require('ws');

const httpPort = Number(process.argv[2] || 8080);
const glspHost = process.argv[3] || '127.0.0.1';
const glspPort = Number(process.argv[4] || 5007);
const dsmPort = Number(process.argv[5] || 5008);
const portsByPath = { '/archmap': glspPort, '/dsm': dsmPort };
const dist = path.join(__dirname, 'dist');

async function build() {
    await esbuild.build({
        entryPoints: [path.join(__dirname, 'src', 'app.ts')],
        bundle: true,
        outfile: path.join(dist, 'bundle.js'),
        platform: 'browser',
        format: 'iife',
        sourcemap: true,
        tsconfig: path.join(__dirname, 'tsconfig.json'),
        loader: { '.ttf': 'file', '.woff': 'file', '.woff2': 'file', '.svg': 'file' },
        define: { 'process.env.NODE_ENV': '"production"' },
        logLevel: 'warning'
    });
    fs.copyFileSync(path.join(__dirname, 'index.html'), path.join(dist, 'index.html'));
}

const contentTypes = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.map': 'application/json', '.ttf': 'font/ttf' };

function serveStatic(req, res) {
    const name = decodeURIComponent(new URL(req.url, 'http://x').pathname);
    const file = path.join(dist, name === '/' ? 'index.html' : name);
    if (!file.startsWith(dist) || !fs.existsSync(file) || fs.statSync(file).isDirectory()) {
        res.writeHead(404).end('not found');
        return;
    }
    // no-store: the bundle is rebuilt at each start, never let the browser serve a stale copy
    res.writeHead(200, { 'Content-Type': contentTypes[path.extname(file)] || 'application/octet-stream', 'Cache-Control': 'no-store' });
    fs.createReadStream(file).pipe(res);
}

/** Feed it TCP chunks, it calls onMessage with each complete framed message body */
function contentLengthReader(onMessage) {
    let buffer = Buffer.alloc(0);
    return chunk => {
        buffer = Buffer.concat([buffer, chunk]);
        for (;;) {
            const headerEnd = buffer.indexOf('\r\n\r\n');
            if (headerEnd < 0) return;
            const match = /Content-Length:\s*(\d+)/i.exec(buffer.subarray(0, headerEnd).toString('ascii'));
            if (!match) throw new Error('missing Content-Length header');
            const start = headerEnd + 4;
            const end = start + Number(match[1]);
            if (buffer.length < end) return;
            onMessage(buffer.subarray(start, end).toString('utf8'));
            buffer = buffer.subarray(end);
        }
    };
}

function bridge(ws, glspPort) {
    const tcp = net.connect(glspPort, glspHost);
    const pending = [];
    let connected = false;
    const send = json => {
        const body = Buffer.from(json, 'utf8');
        tcp.write(`Content-Length: ${body.length}\r\n\r\n`);
        tcp.write(body);
    };
    tcp.on('connect', () => {
        connected = true;
        pending.splice(0).forEach(send);
        console.log('bridge: connected to GLSP server ' + glspHost + ':' + glspPort);
    });
    tcp.on('data', contentLengthReader(json => ws.send(json)));
    tcp.on('error', e => { console.error('bridge: TCP error ' + e.message); ws.close(); });
    tcp.on('close', () => ws.close());
    ws.on('message', data => {
        const json = data.toString('utf8');
        connected ? send(json) : pending.push(json);
    });
    ws.on('close', () => tcp.end());
}

build().then(() => {
    const server = http.createServer(serveStatic);
    const wss = new WebSocketServer({ noServer: true });
    server.on('upgrade', (req, socket, head) => {
        const port = portsByPath[new URL(req.url, 'http://x').pathname];
        if (!port) { socket.destroy(); return; }
        wss.handleUpgrade(req, socket, head, ws => bridge(ws, port));
    });
    server.listen(httpPort, () => {
        console.log(`Open http://localhost:${httpPort}/  (architectural map, bridged to GLSP server ${glspHost}:${glspPort})`);
        console.log(`  or http://localhost:${httpPort}/?diagram=dsm  (DSM, bridged to GLSP server ${glspHost}:${dsmPort})`);
    });
}).catch(e => { console.error(e); process.exit(1); });
