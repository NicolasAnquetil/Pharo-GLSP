// Drive the Pharo GLSP server with the official Eclipse GLSP client library.
const path = require('path');
const net = require('net');
const fs = require('fs');
const modules = process.argv[2];
const req = require('module').createRequire(path.join(modules, '..', 'resolver.js'));
const { BaseJsonrpcGLSPClient, RequestModelAction, CreateNodeOperation, ApplyLabelEditOperation,
        SaveModelAction, RequestTypeHintsAction } = req('@eclipse-glsp/protocol');
const { createMessageConnection, SocketMessageReader, SocketMessageWriter } = req('vscode-jsonrpc/node');

const file = process.argv[3];
const step = (msg) => console.log('✔ ' + msg);
function waitFor(client, kind, test = () => true) {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error('timeout waiting for ' + kind)), 5000);
    const d = client.onActionMessage(m => { if (m.action.kind === kind && test(m.action)) { clearTimeout(timer); d.dispose(); resolve(m.action); } }, 'session-1');
  });
}

(async () => {
  const socket = net.connect(5007, '127.0.0.1');
  await new Promise(r => socket.on('connect', r));
  const connection = createMessageConnection(new SocketMessageReader(socket), new SocketMessageWriter(socket));
  const client = new BaseJsonrpcGLSPClient({ id: 'pharo-interop', connectionProvider: connection });
  await client.start();
  step('client started, state = ' + client.currentState);

  const init = await client.initializeServer({ applicationId: 'interop', protocolVersion: '1.0.0' });
  step('initializeServer -> protocolVersion ' + init.protocolVersion + ', server actions: ' + init.serverActions['tasklist-diagram'].join(' '));

  await client.initializeClientSession({ clientSessionId: 'session-1', diagramType: 'tasklist-diagram', clientActionKinds: ['setModel', 'updateModel', 'setDirtyState', 'setTypeHints'] });
  step('initializeClientSession');

  let waiting = waitFor(client, 'setModel');
  client.sendActionMessage({ clientId: 'session-1', action: RequestModelAction.create({ options: { sourceUri: 'file://' + file, diagramType: 'tasklist-diagram' }, requestId: 'req-1' }) });
  let setModel = await waiting;
  step('requestModel -> setModel revision ' + setModel.newRoot.revision + ', children ' + setModel.newRoot.children.map(c => c.type + ':' + c.id).join(', ') + ', responseId ' + setModel.responseId);

  waiting = waitFor(client, 'setTypeHints');
  client.sendActionMessage({ clientId: 'session-1', action: RequestTypeHintsAction.create({ requestId: 'req-2' }) });
  const hints = await waiting;
  step('requestTypeHints -> shapes ' + hints.shapeHints.map(h => h.elementTypeId) + ', edges ' + hints.edgeHints.map(h => h.elementTypeId));

  waiting = waitFor(client, 'updateModel');
  const dirty = waitFor(client, 'setDirtyState');
  client.sendActionMessage({ clientId: 'session-1', action: CreateNodeOperation.create('task', { location: { x: 50, y: 150 } }) });
  const update = await waiting;
  step('createNode -> updateModel revision ' + update.newRoot.revision + ', ' + update.newRoot.children.length + ' children; dirty = ' + (await dirty).isDirty);

  waiting = waitFor(client, 'updateModel');
  client.sendActionMessage({ clientId: 'session-1', action: ApplyLabelEditOperation.create({ labelId: 'task1_label', text: 'Push (edited from Node)' }) });
  const renamed = await waiting;
  step('applyLabelEdit -> label text "' + renamed.newRoot.children.find(c => c.id === 'task1').children[0].text + '"');

  const saved = waitFor(client, 'setDirtyState', a => a.reason === 'save');
  client.sendActionMessage({ clientId: 'session-1', action: SaveModelAction.create() });
  step('saveModel -> dirty = ' + (await saved).isDirty + ', reason ' + 'save');
  const onDisk = JSON.parse(fs.readFileSync(file, 'utf8'));
  step('file on disk: ' + onDisk.tasks.length + ' tasks, first named "' + onDisk.tasks[0].name + '"');

  await client.disposeClientSession({ clientSessionId: 'session-1' });
  step('disposeClientSession');
  await client.shutdownServer();
  await client.stop();
  step('shutdown + stop');
  socket.destroy();
})().catch(e => { console.error('✘ ' + e.stack); process.exit(1); });
