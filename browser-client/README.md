# browser-client

Experimental, minimal browser client (official `@eclipse-glsp/client` 2.8.0) for two Pharo GLSP diagrams,
both served by one Pharo GLSP server (one port). Read-only: pan, zoom, selection and, in the DSM, hover.

- the architectural map (`archmap-diagram`, `GLSPArchitecturalMapDiagramModule` in `MooseIDE-ArchitecturalMap`, tag `GLSP`)
- the DSM (`dsm-diagram`, `GLSPDSMDiagramModule` in `MooseIDE-DSM`, tag `GLSP`): a matrix whose cell
  (column X, row Y) gives the number of dependencies from X to Y, colored as in the Moose DSM browser
  (diagonal, dependency, cycle); hover a cell for its details. Hovering a cell sends the custom action
  `dsmHoverCell` to Pharo, which answers with the model where the column and the row of that cell are
  outlined with a thick border (two standard `node:rectangle` with the class `dsm-hovered-line`) and, for a
  cell of a cycle, all the cells of its SCC are red instead of pink (class `dsm-highlighted`), until the mouse
  leaves them. The server sends no color, only CSS classes: the look is in `index.html`

These two diagram modules are not part of this repository: they are in MooseIDE (for now in the
`development` branch of [NicolasAnquetil/Midas](https://github.com/NicolasAnquetil/Midas)), subclasses of
`GLSPMooseDiagramModule` (`MooseIDE-Visualization`, tag `GLSP`). Another diagram needs its views in
`src/di.config.tsx` and an entry in `src/app.ts`.

The Pharo GLSP server only speaks TCP (`Content-Length` framing) and a browser only speaks WebSocket,
so `server.js` also bridges each browser WebSocket to its own TCP connection to the Pharo server.

## Run

1. In the Pharo image, start the GLSP server of both diagrams:

       entities := MooseModel root allModels first allModelPackages.
       launcher := GLSPMooseDiagramModule
           serveAll: { GLSPArchitecturalMapDiagramModule on: entities. GLSPDSMDiagramModule on: entities }
           onPort: 5007.

   (one diagram alone: `GLSPDSMDiagramModule serve: entities onPort: 5007`)

2. Here: `npm install` (once), then `node server.js` (builds `dist/` with esbuild and serves it).
   Arguments: `node server.js [httpPort=8080] [glspHost=127.0.0.1] [glspPort=5007]`.
3. Open http://localhost:8080/ for the architectural map, http://localhost:8080/?diagram=dsm for the DSM —
   reload the page after restarting the Pharo server.
4. `launcher stop` in the image.

`node test-bridge.js` (or `node test-bridge.js dsm`) checks the bridge and the Pharo server
without a browser (prints what it received).

## Files

- `src/app.ts` — picks the diagram (`?diagram=dsm`), connects over WebSocket and loads it (read-only edit mode)
- `src/di.config.tsx` — views: `archmap-node` (rounded rectangle), `archmap-dependency`
  (polyline with arrowhead), `label` (centered in its node, since the server does no text layout)
- `src/di.config.tsx` — DSM views: `dsm-cell` (rectangle colored from its CSS classes, tooltip),
  `dsm-row-header` / `dsm-column-header` (row names right-aligned, column names written upwards);
  `DsmHoverMouseListener` sends `{kind: 'dsmHoverCell', cellId}` when the cell under the mouse changes
  (no `cellId` when it leaves the cells)
- `index.html` — styles (the DSM colors, the outlines of the hovered column and row); GLSP's `.sprotty text` rule (centered, 8pt) is overridden for the DSM names
- `server.js` — esbuild build, static HTTP server, WebSocket ⇄ TCP bridge (`/glsp` → 5007)
