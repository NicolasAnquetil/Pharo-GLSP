"
I test the TaskList example diagram through the GLSP server, with a .tasklist file in the temporary directory.
"
Class {
	#name : 'GLSPTaskListServerTest',
	#superclass : 'GLSPServerTestCase',
	#instVars : [
		'file'
	],
	#category : 'GLSP-Example-TaskList-Tests',
	#package : 'GLSP-Example-TaskList-Tests'
}

{ #category : 'helpers' }
GLSPTaskListServerTest >> child: anId of: aJSON [

	^ (aJSON at: 'children') detect: [ :each | (each at: 'id') = anId ] ifNone: [ nil ]
]

{ #category : 'helpers' }
GLSPTaskListServerTest >> diagramType [

	^ 'tasklist-diagram'
]

{ #category : 'running' }
GLSPTaskListServerTest >> initialFileContents [

	^ '{"id":"tasklist","tasks":[
		{"id":"task1","name":"Push","position":{"x":10,"y":20},"size":{"width":80,"height":30}},
		{"id":"task2","name":"Pull","position":{"x":200,"y":20}}],
	"transitions":[{"id":"transition1","sourceTaskId":"task1","targetTaskId":"task2"}]}'
]

{ #category : 'helpers' }
GLSPTaskListServerTest >> lastRoot [
	"The GModel last sent to the client (setModel or updateModel), as JSON"

	^ (transport actions select: [ :each | #( 'setModel' 'updateModel' ) includes: each kind ]) last newRoot
]

{ #category : 'helpers' }
GLSPTaskListServerTest >> savedFile [

	^ STONJSON fromString: file contents
]

{ #category : 'running' }
GLSPTaskListServerTest >> setUp [

	super setUp.
	server registerDiagramModule: GLSPTaskListDiagramModule new.
	file := FileReference newTempFilePrefix: 'glsp-' suffix: '.tasklist'.
	file writeStreamDo: [ :stream | stream nextPutAll: self initialFileContents ]
]

{ #category : 'helpers' }
GLSPTaskListServerTest >> sourceUri [

	^ file asZnUrl printString
]

{ #category : 'helpers' }
GLSPTaskListServerTest >> taskList [

	^ self session modelState sourceModel
]

{ #category : 'running' }
GLSPTaskListServerTest >> tearDown [

	file ifNotNil: [ file ensureDelete ].
	super tearDown
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testApplyLabelEditRenamesTheTask [

	self openModel.
	self process: '{"kind":"applyLabelEdit","isOperation":true,"labelId":"task1_label","text":"Commit"}'.
	self assert: (self taskList taskAt: 'task1') name equals: 'Commit'.
	self assert: ((self child: 'task1_label' of: (self child: 'task1' of: self lastRoot)) at: 'text') equals: 'Commit'
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testChangeBounds [

	| task |
	self openModel.
	self process:
		'{"kind":"changeBounds","isOperation":true,"newBounds":[{"elementId":"task1","newPosition":{"x":50,"y":60},"newSize":{"width":120,"height":40}}]}'.
	task := self taskList taskAt: 'task1'.
	self assert: task position equals: 50 @ 60.
	self assert: task size equals: 120 @ 40
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testCreateTask [

	| task |
	self openModel.
	self process: '{"kind":"createNode","isOperation":true,"elementTypeId":"task","location":{"x":30,"y":40}}'.
	self assert: self taskList tasks size equals: 3.
	task := self taskList tasks last.
	self assert: task position equals: 30 @ 40.
	self assert: task name equals: 'New Task 3'.
	self assert: (self lastRoot at: 'children') size equals: 4
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testCreateTransition [

	| transition |
	self openModel.
	self process:
		'{"kind":"createEdge","isOperation":true,"elementTypeId":"transition","sourceElementId":"task2","targetElementId":"task1"}'.
	self assert: self taskList transitions size equals: 2.
	transition := self taskList transitions last.
	self assert: transition sourceTaskId equals: 'task2'.
	self assert: transition targetTaskId equals: 'task1'
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testDeleteTaskDeletesItsTransitions [

	self openModel.
	self process: '{"kind":"deleteElement","isOperation":true,"elementIds":["task1"]}'.
	self assert: (self taskList tasks collect: [ :each | each id ] as: Array) equals: #( 'task2' ).
	self assert: self taskList transitions isEmpty
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testDeleteTransition [

	self openModel.
	self process: '{"kind":"deleteElement","isOperation":true,"elementIds":["transition1"]}'.
	self assert: self taskList tasks size equals: 2.
	self assert: self taskList transitions isEmpty
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testReconnectTransition [

	self openModel.
	self process:
		'{"kind":"reconnectEdge","isOperation":true,"edgeElementId":"transition1","sourceElementId":"task2","targetElementId":"task2"}'.
	self assert: (self taskList transitionAt: 'transition1') sourceTaskId equals: 'task2'
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testRequestModelLoadsTheFile [

	| root task1 label edge |
	self openSession.
	self requestModel.
	root := self lastRoot.
	self assert: (root at: 'children') size equals: 3.
	task1 := self child: 'task1' of: root.
	self assert: (task1 at: 'type') equals: 'task'.
	self assert: (task1 at: 'position') equals: (Dictionary newFromPairs: #( 'x' 10 'y' 20 )).
	self assert: (task1 at: 'size') equals: (Dictionary newFromPairs: #( 'width' 80 'height' 30 )).
	label := self child: 'task1_label' of: task1.
	self assert: (label at: 'text') equals: 'Push'.
	edge := self child: 'transition1' of: root.
	self assert: (edge at: 'type') equals: 'transition'.
	self assert: (edge at: 'sourceId') equals: 'task1'.
	self assert: (edge at: 'targetId') equals: 'task2'
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testSaveWritesTheFile [

	| saved |
	self openModel.
	self process: '{"kind":"applyLabelEdit","isOperation":true,"labelId":"task1_label","text":"Commit"}'.
	self process: '{"kind":"saveModel"}'.
	saved := self savedFile.
	self assert: ((saved at: 'tasks') first at: 'name') equals: 'Commit'.
	self assert: ((saved at: 'tasks') first at: 'position') equals: (Dictionary newFromPairs: #( 'x' 10 'y' 20 )).
	self assert: ((saved at: 'transitions') first at: 'targetTaskId') equals: 'task2'.
	self deny: self lastDirtyState isDirty
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testServerAnnouncesTheTaskListOperations [

	| kinds |
	kinds := ((self initializeServer at: 'result') at: 'serverActions') at: 'tasklist-diagram'.
	#( 'requestModel' 'createNode' 'createEdge' 'deleteElement' 'changeBounds' 'applyLabelEdit' 'reconnectEdge' 'saveModel'
	   'glspUndo' 'glspRedo' ) do: [ :each | self assert: (kinds includes: each) description: each ]
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testTaskWithoutSizeGetsADefaultSize [

	self openModel.
	self assert: (self taskList taskAt: 'task2') size equals: GLSPTaskListTask defaultSize
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testToolPalette [

	| groups |
	self openModel.
	self process:
		'{"kind":"requestContextActions","contextId":"tool-palette","editorContext":{"selectedElementIds":[]},"requestId":"r3"}'.
	groups := (transport actionsOfKind: 'setContextActions') first actions.
	self assert: (groups collect: [ :each | each at: 'label' ] as: Array) equals: #( 'Nodes' 'Edges' ).
	self assert: (((groups second at: 'children') first at: 'actions') first at: 'kind') equals: 'triggerEdgeCreation'.
	self assert: ((groups second at: 'children') first at: 'label') equals: 'Transition'
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testTypeHints [

	| hints edgeHint |
	self openModel.
	self process: '{"kind":"requestTypeHints","requestId":"r2"}'.
	hints := (transport actionsOfKind: 'setTypeHints') first.
	self assert: (hints shapeHints collect: [ :each | each at: 'elementTypeId' ] as: Array) equals: #( 'task' ).
	edgeHint := hints edgeHints first.
	self assert: (edgeHint at: 'elementTypeId') equals: 'transition'.
	self assert: (edgeHint at: 'sourceElementTypeIds') equals: #( 'task' ).
	self assert: (edgeHint at: 'targetElementTypeIds') equals: #( 'task' )
]

{ #category : 'tests' }
GLSPTaskListServerTest >> testUndoCreateTask [

	self openModel.
	self process: '{"kind":"createNode","isOperation":true,"elementTypeId":"task","location":{"x":30,"y":40}}'.
	self process: '{"kind":"glspUndo"}'.
	self assert: self taskList tasks size equals: 2
]
