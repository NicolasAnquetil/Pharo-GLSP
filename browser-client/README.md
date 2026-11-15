# browser-client

Experimental, minimal browser client (official `@eclipse-glsp/client` 2.8.0) for two Pharo GLSP diagrams,
each served by its own Pharo GLSP server. Read-only: pan, zoom, selection and, in the DSM, hover.

- the architectural map (`archmap-diagram`, `GLSPArchitecturalMapDiagramModule` in `MooseIDE-ArchitecturalMap`, tag `GLSP`)
- the DSM (`dsm-diagram`, `GLSPDSMDiagramModule` in `MooseIDE-DSM`, tag `GLSP`): a matrix whose cell
  (column X, row Y) gives the number of dependencies from X to Y, colored as in the Moose DSM browser
  (diagonal, dependency, cycle); hover a cell for its details. Hovering a cell of a cycle sends the
  custom action `dsmHoverCell` to Pharo, which answers with the model where all the cells of that SCC
  are red instead of pink, until the mouse leaves them

These two diagram modules are not part of this repository: they are in MooseIDE (for now in the
`development` branch of [NicolasAnquetil/Midas](https://github.com/NicolasAnquetil/Midas)). Another
diagram needs its views in `src/di.config.tsx` and an entry in `src/app.ts` and `server.js`.

The Pharo GLSP server only speaks TCP (`Content-Length` framing) and a browser only speaks WebSocket,
so `server.js` also bridges each browser WebSocket to its own TCP connection to the Pharo server.

## Run

1. In the Pharo image, start the server(s) of the diagram(s) to show:

       launcher := GLSPArchitecturalMapDiagramModule
           serve: MooseModel root allModels first allModelPackages
           onPort: 5007.
       dsmLauncher := GLSPDSMDiagramModule
           serve: MooseModel root allModels first allModelPackages
           onPort: 5008.

2. Here: `npm install` (once), then `node server.js` (builds `dist/` with esbuild and serves it).
   Arguments: `node server.js [httpPort=8080] [glspHost=127.0.0.1] [glspPort=5007] [dsmPort=5008]`.
3. Open http://localhost:8080/ for the architectural map, http://localhost:8080/?diagram=dsm for the DSM —
   reload the page after restarting a Pharo server.
4. `launcher stop` (and `dsmLauncher stop`) in the image.

`node test-bridge.js` (or `node test-bridge.js ws://localhost:8080/dsm`) checks the bridge and the Pharo server
without a browser (prints what it received).

## Files

- `src/app.ts` — picks the diagram (`?diagram=dsm`), connects over WebSocket and loads it (read-only edit mode)
- `src/di.config.tsx` — views: `archmap-node` (rounded rectangle), `archmap-dependency`
  (polyline with arrowhead), `label` (centered in its node, since the server does no text layout)
- `src/di.config.tsx` — DSM views: `dsm-cell` (rectangle in the color sent by the server, tooltip),
  `dsm-row-header` / `dsm-column-header` (row names right-aligned, column names written upwards);
  `DsmHoverMouseListener` sends `{kind: 'dsmHoverCell', cellId}` when the cell under the mouse changes
  (no `cellId` when it leaves the cells)
- `index.html` — styles; GLSP's `.sprotty text` rule (centered, 8pt) is overridden for the DSM names
- `server.js` — esbuild build, static HTTP server, WebSocket ⇄ TCP bridge (`/archmap` → 5007, `/dsm` → 5008)
