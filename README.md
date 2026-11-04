# Pharo-GLSP

A [Graphical Language Server Protocol](https://eclipse.dev/glsp/) (GLSP) server implemented in [Pharo](https://pharo.org).

GLSP is to diagram editors what LSP is to text editors: the server owns the model and the editing logic,
a generic web client (Eclipse Theia, VS Code, Eclipse IDE) renders the diagram. The design follows the
[Pharo Language Server](https://github.com/badetitou/Pharo-LanguageServer) (a `JRPCServer` with `<jrpc:>` handlers,
`Content-Length` framing) and the official Java/Node GLSP servers (diagram modules, action and operation handlers,
command stack).

Protocol version `1.0.0`; checked against the official `@eclipse-glsp/protocol` 2.8.0 client (see `interop/`).

## Installation

```smalltalk
Metacello new
	baseline: 'GLSP';
	repository: 'github://NicolasAnquetil/Pharo-GLSP:main/src';
	load.
```

Groups: `Core`, `Example` (the TaskList language), `Tests`, `default` (everything).

## Running a server

```smalltalk
launcher := (GLSPSocketLauncher serverFactory: [
	GLSPServer new registerDiagramModule: GLSPTaskListDiagramModule new; yourself ])
		startOnPort: 5007; yourself.
"... connect a GLSP client to port 5007 ..."
launcher stop.
```

Each TCP connection gets its own `GLSPServer`. The server needs no graphical backend.

## What is supported

- JSON-RPC lifecycle: `initialize`, `initializeClientSession`, `disposeClientSession`, `process`, `shutdown`
- Model: `requestModel` → `setModel`, `updateModel` with revisions
- Operations: `createNode`, `createEdge`, `deleteElement`, `changeBounds`, `applyLabelEdit`, `reconnectEdge`, `changeRoutingPoints`
- `glspUndo` / `glspRedo` (generic, by recording the source model), `saveModel`, `setDirtyState`
- `requestTypeHints` → `setTypeHints`, tool palette (`requestContextActions` with `tool-palette`)

Not yet: client-side layout (`requestBounds`), validation markers, popups, navigation, clipboard,
WebSocket/stdio transports.

## Writing a diagram language

Subclass `GLSPDiagramModule` and provide `diagramType`, a `GLSPSourceModelStorage` (e.g. a
`GLSPFileSourceModelStorage` subclass), a `GLSPGModelFactory` and operation handlers
(`GLSPOperationHandler` / `GLSPCreateOperationHandler`). See the `GLSP-Example-TaskList` package.

## Development history

Built test-first; see [PROGRESS.md](PROGRESS.md) for the step-by-step log (66 tests).
