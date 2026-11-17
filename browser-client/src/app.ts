import 'reflect-metadata';
import '@vscode/codicons/dist/codicon.css';
import '@eclipse-glsp/client/css/glsp-sprotty.css';

import { BaseJsonrpcGLSPClient, DiagramLoader, EditMode, GLSPClient, GLSPWebSocketProvider } from '@eclipse-glsp/client';
import { MessageConnection } from 'vscode-jsonrpc';
import { createContainer } from './di.config';

// ?diagram=dsm shows the DSM; the architectural map otherwise. Both are served by the same Pharo GLSP server (see server.js)
// editMode: what the user can then do with each element is told by the server (type hints): in the
// architectural map, only move the nodes
const diagrams: { [name: string]: { type: string; title: string; editMode: string } } = {
    archmap: { type: 'archmap-diagram', title: 'Architectural map (GLSP)', editMode: EditMode.EDITABLE },
    dsm: { type: 'dsm-diagram', title: 'DSM (GLSP)', editMode: EditMode.READONLY }
};
const diagramName = new URLSearchParams(window.location.search).get('diagram') === 'dsm' ? 'dsm' : 'archmap';
const diagramType = diagrams[diagramName].type;
document.title = diagrams[diagramName].title;
const clientId = 'sprotty'; // id of the <div> the diagram is rendered in
const webSocketUrl = `ws://${window.location.host}/glsp`;

let glspClient: GLSPClient;

async function initialize(connectionProvider: MessageConnection, isReconnecting = false): Promise<void> {
    glspClient = new BaseJsonrpcGLSPClient({ id: 'archmap', connectionProvider });
    const container = createContainer({
        clientId,
        diagramType,
        glspClientProvider: async () => glspClient,
        // ignored by the Pharo server, which serves the model it was started with
        sourceUri: `${diagramName}://model`,
        editMode: diagrams[diagramName].editMode
    });
    const diagramLoader = container.get(DiagramLoader);
    await diagramLoader.load({ requestModelOptions: { isReconnecting } });
}

async function reconnect(connectionProvider: MessageConnection): Promise<void> {
    glspClient.stop();
    initialize(connectionProvider, true);
}

new GLSPWebSocketProvider(webSocketUrl).listen({ onConnection: initialize, onReconnect: reconnect, logger: console });
