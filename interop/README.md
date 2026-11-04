# Interoperability check with the official Eclipse GLSP client library

1. In the Pharo image:
       launcher := (GLSPSocketLauncher serverFactory: [
           GLSPServer new registerDiagramModule: GLSPTaskListDiagramModule new; yourself ])
               startOnPort: 5007; yourself.
2. Install the client library (note: vscode-jsonrpc must be the version @eclipse-glsp/protocol is built with):
       npm install --ignore-scripts @eclipse-glsp/protocol vscode-jsonrpc@8.2.0
3. Run: `node client.js <path-to>/node_modules /absolute/path/to/example.tasklist`
4. `launcher stop`
