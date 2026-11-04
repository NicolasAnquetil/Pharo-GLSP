# Pharo GLSP — TDD progress log

Each iteration: red test(s) → minimal implementation → green → refactor.

## Step 0 — Groundwork
- Image: Pharo 14 (64 bit), JRPC + NeoJSON + STON already loaded.
- Reference: badetitou/Pharo-LanguageServer (PLS). Its architecture is reused here:
  `JRPCServer` subclass, `<jrpc: #method>` pragma handlers, `Content-Length` framing,
  a single mutex-protected `sendMessage:` write path, `sendNotification:params:`.
- Decision: do not load PLS itself (pulls Spec-Gtk, LLMAPI, MCP and a different JRPC fork);
  build a standalone GLSP stack on the same JRPC foundation.

## Step 1 — GModel (graphical model) ✅ 7 tests
- Red: `GLSPGModelTest` (7 tests: node/edge/label/root JSON, cssClasses, parent/lookup, removal, custom types).
- Green: `GLSPGModelElement` (id, type, children, parent, cssClasses, args) and subclasses
  `GLSPGModelRoot` (graph, revision), `GLSPGShapeElement` (position, size, layout) →
  `GLSPGNode`, `GLSPGLabel`, `GLSPGCompartment`, `GLSPGPort`; `GLSPGEdge` (sourceId, targetId, routingPoints).
- Workflow: Tonel files on disk are the source of truth, loaded with `TonelReader … snapshot install`.

> From step 3 on (user request): code is written directly in the image through the Pharo MCP
> server (`class_create` / `method_compile`). The packages are committed with Iceberg under `src/`.

## Step 2 — Actions & ActionMessage ✅ 7 tests (14 total)
- `GLSPAction class >> fromJSON:` picks the subclass by `kind`; unknown kinds → `GLSPUnknownAction` (keeps raw JSON).
- Reflective (de)serialization over instance variables; `GLSPRequestAction` (requestId), `GLSPResponseAction` (responseId, `respondTo:`).
- `GLSPRequestModelAction`, `GLSPSetModelAction`, `GLSPSetDirtyStateAction`, `GLSPActionMessage` {clientId, action}.

## Step 3 — JSON-RPC lifecycle ✅ 8 tests (22 total)
- Protocol checked against eclipse-glsp/glsp-client `protocol` package: `initialize`, `initializeClientSession`,
  `disposeClientSession` (requests), `process`, `shutdown` (notifications), protocolVersion `1.0.0`.
- `GLSPServer` (JRPCServer subclass, `<jrpc:>` handlers collected over the hierarchy), `GLSPDiagramModule`,
  `GLSPClientSession`, `GLSPTransport` / `GLSPRecordingTransport`, `GLSPServerError`.
- Lesson: JRPC binds named params to *argument names* → handler arguments use the protocol names.

## Step 4 — Action dispatch, requestModel → setModel ✅ 6 tests (28 total)
- Refactor: `GLSPServerTestCase` (client-side helpers) extracted from the lifecycle test.
- `GLSPModelState`, `GLSPSourceModelStorage`, `GLSPGModelFactory`, `GLSPActionHandler`, `GLSPRequestModelActionHandler`.
- Session dispatch: produced action → server handler if any, else sent to client; response actions get the `responseId`.

## Step 5 — Operations, undo/redo, save ✅ 12 tests (40 total)
- Operations (`isOperation: true`): createNode, createEdge, deleteElement, changeBounds, applyLabelEdit,
  reconnectEdge, changeRoutingPoints; actions updateModel, saveModel, glspUndo, glspRedo.
- `GLSPOperationHandler` / `GLSPCreateOperationHandler` (elementTypeIds) only change the source model.
- `GLSPRecordingCommand` snapshots the source model (veryDeepCopy) before/after → generic undo/redo
  (same idea as GLSP-node's JSON recording command). `GLSPCommandStack` with save point → dirty state.
- Core handlers: `GLSPOperationActionHandler`, `GLSPUndoRedoActionHandler`, `GLSPSaveModelActionHandler`.
- After each change: `updateModel` (revision+1) + `setDirtyState` (reason operation/undo/redo/save).

## Step 6 — TaskList example language ✅ 12 tests (52 total)
- Packages `GLSP-Example-TaskList` / `-Tests`; the language of the official GLSP templates.
- Source model: `GLSPTaskList`, `GLSPTaskListTask`, `GLSPTaskListTransition` (plain objects, JSON in/out).
- Framework addition: `GLSPFileSourceModelStorage` (file:// URIs ↔ JSON files); `GLSPTaskListSourceModelStorage`.
- `GLSPTaskListGModelFactory`: task → node type 'task' + label '<id>_label'; transition → edge type 'transition'.
- Handlers: create task / transition, delete (cascades to transitions), change bounds, label edit (rename), reconnect.

## Step 7 — Type hints & tool palette ✅ 6 tests (58 total)
- requestTypeHints → setTypeHints (`GLSPShapeTypeHint`, `GLSPEdgeTypeHint`), requestContextActions →
  setContextActions (`GLSPPaletteItem` with triggerNodeCreation / triggerEdgeCreation); other contexts answer
  an empty list so client requests always resolve.
- Defaults derived from the module's create handlers (overridable: `shapeTypeHints`, `edgeTypeHints`,
  `contextActionsFor:editorContext:in:`); `GLSPProtocolObject` = reflective JSON data object.

## Step 8 — Wire transport (Content-Length framing, TCP) ✅ 7 tests (65 total)
- `GLSPStreamTransport`: vscode-jsonrpc/LSP framing (`Content-Length` in *bytes*, UTF-8, extra headers ignored).
- `GLSPServer >> serveTransport:` sequential read/handle loop (GLSP actions must keep their order);
  `sendRaw:` = single mutex-protected output point for responses and notifications.
- `GLSPSocketLauncher` (like the Java `SocketServerLauncher`): one `GLSPServer` per TCP connection, created by a
  factory block; port 0 = ephemeral port.
- Bugs found by the tests: no `waitForAcceptFor:ifTimedOut:` in Pharo 14; read-timeout retry must be server-side only
  (`waitForever:`), otherwise a broken client test hangs instead of failing.

## Step 9 — Interoperability with the official Eclipse GLSP client ✅
- `@eclipse-glsp/protocol` 2.8.0 `BaseJsonrpcGLSPClient` + vscode-jsonrpc 8.2.0 over TCP against
  `GLSPSocketLauncher` (TaskList module): start, initializeServer, initializeClientSession, requestModel→setModel,
  requestTypeHints, createNode→updateModel+setDirtyState, applyLabelEdit, saveModel (file written), dispose, shutdown.
  Script: `interop/client.js`.
- Bug found: a client disconnecting raised an unhandled `ConnectionClosed` in the server process (debugger opened,
  process leaked) — regression in `nextByte` from step 8. Red test `testServerEndsWhenTheClientDisconnects`, fixed. ✅ 66 tests.

## Status
- 66 tests green (`GLSP-Server-Tests`, `GLSP-Example-TaskList-Tests`).
- Not implemented yet (candidates for next iterations): client-side layout (requestBounds/computedBounds),
  validation markers (requestMarkers/setMarkers), popups (requestPopupModel), navigation, clipboard,
  edit validation, server-side auto layout, WebSocket transport, stdio launcher, Metacello baseline.
