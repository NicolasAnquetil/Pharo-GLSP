"
I test the editing support a client asks for when it opens a diagram: type hints (requestTypeHints) and the tool palette (requestContextActions with the 'tool-palette' context).
"
Class {
	#name : 'GLSPToolingTest',
	#superclass : 'GLSPServerTestCase',
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'tests' }
GLSPToolingTest >> testOtherContextsAnswerNoActions [

	self openModel.
	self process:
		'{"kind":"requestContextActions","contextId":"command-palette","editorContext":{"selectedElementIds":[]},"requestId":"r4"}'.
	self assert: (transport actionsOfKind: 'setContextActions') first actions isEmpty
]

{ #category : 'tests' }
GLSPToolingTest >> testRequestTypeHints [

	| hints shapeHint |
	self openModel.
	self process: '{"kind":"requestTypeHints","requestId":"r2"}'.
	hints := (transport actionsOfKind: 'setTypeHints') first.
	self assert: hints responseId equals: 'r2'.
	self assert: hints shapeHints size equals: 1.
	shapeHint := hints shapeHints first.
	self assert: (shapeHint at: 'elementTypeId') equals: 'node'.
	self assert: (shapeHint at: 'deletable').
	self assert: (shapeHint at: 'repositionable').
	self assert: (shapeHint at: 'resizable').
	self deny: (shapeHint at: 'reparentable').
	self assert: hints edgeHints isEmpty
]

{ #category : 'tests' }
GLSPToolingTest >> testServerAnnouncesTooling [

	| kinds |
	kinds := GLSPTestDiagramModule new handledActionKinds.
	self assert: (kinds includes: 'requestTypeHints').
	self assert: (kinds includes: 'requestContextActions')
]

{ #category : 'tests' }
GLSPToolingTest >> testToolPalette [

	| answer groups nodeItem |
	self openModel.
	self process:
		'{"kind":"requestContextActions","contextId":"tool-palette","editorContext":{"selectedElementIds":[]},"requestId":"r3"}'.
	answer := (transport actionsOfKind: 'setContextActions') first.
	self assert: answer responseId equals: 'r3'.
	groups := answer actions.
	self assert: (groups collect: [ :each | each at: 'label' ]) asArray equals: #( 'Nodes' ).
	nodeItem := (groups first at: 'children') first.
	self assert: (nodeItem at: 'label') equals: 'node'.
	self assert: (nodeItem includesKey: 'sortString').
	self assert: (nodeItem includesKey: 'id').
	self
		assert: (nodeItem at: 'actions') first
		equals: (Dictionary newFromPairs: #( 'kind' 'triggerNodeCreation' 'elementTypeId' 'node' ))
]
