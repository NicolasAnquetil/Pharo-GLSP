"
I test operations (model edition): their JSON form, their execution by operation handlers, the resulting updateModel / setDirtyState actions, undo / redo through the command stack, and saving.
"
Class {
	#name : 'GLSPOperationTest',
	#superclass : 'GLSPServerTestCase',
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'helpers' }
GLSPOperationTest >> createNode [

	self process: '{"kind":"createNode","isOperation":true,"elementTypeId":"node","location":{"x":5,"y":7}}'
]

{ #category : 'helpers' }
GLSPOperationTest >> deleteA [

	self process: '{"kind":"deleteElement","isOperation":true,"elementIds":["a"]}'
]

{ #category : 'helpers' }
GLSPOperationTest >> redo [

	self process: '{"kind":"glspRedo"}'
]

{ #category : 'helpers' }
GLSPOperationTest >> sourceModel [

	^ (server sessionAt: 's1') modelState sourceModel asArray
]

{ #category : 'tests' }
GLSPOperationTest >> testCreateNodeOperationReadsLocationAsAPoint [

	| operation |
	operation := GLSPAction fromJSON: (STONJSON fromString:
			              '{"kind":"createNode","isOperation":true,"elementTypeId":"node","location":{"x":5,"y":7},"containerId":"root"}').
	self assert: operation class equals: GLSPCreateNodeOperation.
	self assert: operation location equals: 5 @ 7.
	self assert: operation elementTypeId equals: 'node'.
	self assert: operation containerId equals: 'root'.
	self assert: (operation asJRPCJSON at: 'location') equals: (Dictionary newFromPairs: #( 'x' 5 'y' 7 ))
]

{ #category : 'tests' }
GLSPOperationTest >> testDeleteElement [

	self openModel.
	self deleteA.
	self assert: self sourceModel equals: #( 'b' )
]

{ #category : 'tests' }
GLSPOperationTest >> testNewOperationClearsTheRedoStack [

	self openModel.
	self createNode.
	self undo.
	self deleteA.
	transport reset.
	self redo.
	self assert: transport sent isEmpty.
	self assert: self sourceModel equals: #( 'b' )
]

{ #category : 'tests' }
GLSPOperationTest >> testOperationJSON [

	| operation |
	operation := GLSPAction fromJSON: (STONJSON fromString: '{"kind":"deleteElement","isOperation":true,"elementIds":["a"]}').
	self assert: operation class equals: GLSPDeleteElementOperation.
	self assert: operation isOperation.
	self assert: operation elementIds asArray equals: #( 'a' ).
	self assert: (operation asJRPCJSON at: 'isOperation').
	self assert: (operation asJRPCJSON at: 'kind') equals: 'deleteElement'
]

{ #category : 'tests' }
GLSPOperationTest >> testOperationUpdatesTheModel [

	| update |
	self openModel.
	self createNode.
	self assert: self sourceModel equals: #( 'a' 'b' 'n3' ).
	self assert: self sentKinds equals: #( 'updateModel' 'setDirtyState' ).
	update := (transport actionsOfKind: 'updateModel') first.
	self assert: (update newRoot at: 'children') size equals: 3.
	self assert: (update newRoot at: 'revision') equals: 2.
	self assert: self lastDirtyState isDirty.
	self assert: self lastDirtyState reason equals: 'operation'
]

{ #category : 'tests' }
GLSPOperationTest >> testOperationWithoutHandlerIsIgnored [

	self openModel.
	self process: '{"kind":"applyLabelEdit","isOperation":true,"labelId":"l","text":"t"}'.
	self assert: transport sent isEmpty
]

{ #category : 'tests' }
GLSPOperationTest >> testRedo [

	self openModel.
	self createNode.
	self deleteA.
	self undo.
	self undo.
	self redo.
	self assert: self sourceModel equals: #( 'a' 'b' 'n3' ).
	self assert: self lastDirtyState isDirty.
	self assert: self lastDirtyState reason equals: 'redo'
]

{ #category : 'tests' }
GLSPOperationTest >> testSaveModel [

	self openModel.
	self createNode.
	self process: '{"kind":"saveModel"}'.
	self deny: self lastDirtyState isDirty.
	self assert: self lastDirtyState reason equals: 'save'.
	self assert: (server sessionAt: 's1') diagramModule sourceModelStorage savedUri equals: 'test://model'
]

{ #category : 'tests' }
GLSPOperationTest >> testServerActionsIncludeOperationsUndoRedoAndSave [

	| kinds |
	kinds := GLSPTestDiagramModule new handledActionKinds.
	#( 'createNode' 'deleteElement' 'glspUndo' 'glspRedo' 'saveModel' ) do: [ :each | self assert: (kinds includes: each) ]
]

{ #category : 'tests' }
GLSPOperationTest >> testUndoAfterSaveIsDirtyAgain [

	self openModel.
	self createNode.
	self process: '{"kind":"saveModel"}'.
	self undo.
	self assert: self lastDirtyState isDirty
]

{ #category : 'tests' }
GLSPOperationTest >> testUndoRestoresTheSourceModel [

	self openModel.
	self createNode.
	self undo.
	self assert: self sourceModel equals: #( 'a' 'b' ).
	self assert: ((transport actionsOfKind: 'updateModel') last newRoot at: 'children') size equals: 2.
	self deny: self lastDirtyState isDirty.
	self assert: self lastDirtyState reason equals: 'undo'
]

{ #category : 'tests' }
GLSPOperationTest >> testUndoWithNothingToUndoSendsNothing [

	self openModel.
	self undo.
	self assert: transport sent isEmpty
]

{ #category : 'helpers' }
GLSPOperationTest >> undo [

	self process: '{"kind":"glspUndo"}'
]
