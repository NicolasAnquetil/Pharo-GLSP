// Check the bridge + Pharo server without a browser: speak GLSP JSON-RPC over the WebSocket
// and print the model received. Usage: node test-bridge.js [ws://localhost:8080/archmap | ws://localhost:8080/dsm]
const WebSocket = require('ws');

const url = process.argv[2] || 'ws://localhost:8080/archmap';
const diagramType = url.endsWith('/dsm') ? 'dsm-diagram' : 'archmap-diagram';
const ws = new WebSocket(url);
let nextId = 1;
const pending = new Map();
const request = (method, params) => new Promise(resolve => {
    const id = nextId++;
    pending.set(id, resolve);
    ws.send(JSON.stringify({ jsonrpc: '2.0', id, method, params }));
});
const timer = setTimeout(() => { console.error('✘ timeout'); process.exit(1); }, 10000);

ws.on('message', data => {
    const msg = JSON.parse(data.toString());
    if (msg.id !== undefined && pending.has(msg.id)) {
        pending.get(msg.id)(msg.result ?? msg.error);
        pending.delete(msg.id);
    } else if (msg.method === 'process' && msg.params.action.kind === 'setModel') {
        const children = msg.params.action.newRoot.children;
        if (diagramType === 'dsm-diagram') {
            const count = type => children.filter(c => c.type === type).length;
            console.log(`✔ setModel: ${count('dsm-column-header')} columns, ${count('dsm-row-header')} rows, ${count('dsm-cell')} cells`);
            children.filter(c => c.type === 'dsm-row-header').forEach(n => console.log(`    row ${n.children[0].text}`));
            children.filter(c => c.type === 'dsm-cell' && c.children[0].text !== '').slice(0, 5)
                .forEach(c => console.log(`    ${c.args.title}  [${c.cssClasses}]`));
        } else {
            const nodes = children.filter(c => c.type === 'archmap-node');
            const edges = children.filter(c => c.type === 'archmap-dependency');
            console.log(`✔ setModel: ${nodes.length} nodes, ${edges.length} edges`);
            nodes.forEach(n => console.log(`    ${n.id} ${n.children[0].text} @ ${n.position.x},${n.position.y}`));
        }
        clearTimeout(timer);
        ws.close();
    }
});

ws.on('open', async () => {
    const init = await request('initialize', { applicationId: 'test-bridge', protocolVersion: '1.0.0' });
    console.log('✔ initialize: protocol ' + init.protocolVersion + ', diagram types ' + Object.keys(init.serverActions));
    await request('initializeClientSession', {
        clientSessionId: 's1', diagramType, clientActionKinds: ['setModel', 'updateModel']
    });
    console.log('✔ initializeClientSession');
    ws.send(JSON.stringify({
        jsonrpc: '2.0', method: 'process',
        params: { clientId: 's1', action: { kind: 'requestModel', requestId: 'r1', options: { sourceUri: 'test://model', diagramType } } }
    }));
});
