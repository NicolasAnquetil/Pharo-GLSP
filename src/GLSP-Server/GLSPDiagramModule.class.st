"
I describe one diagram type of a GLSP server (the equivalent of a DiagramModule in the Java/Node GLSP servers): its diagramType, the action handlers and operation handlers of its sessions, how the source model is loaded and saved, and how it is turned into a GModel.

Subclass me for a concrete diagram language.
"
Class {
	#name : 'GLSPDiagramModule',
	#superclass : 'Object',
	#category : 'GLSP-Server-Core',
	#package : 'GLSP-Server',
	#tag : 'Core'
}

{ #category : 'tooling' }
GLSPDiagramModule >> contextActionsFor: aContextId editorContext: anEditorContext in: aClientSession [
	"The labeled actions of a context. Override to provide context menus, command palette..."

	aContextId = 'tool-palette' ifTrue: [ ^ self toolPaletteItems ].
	^ #(  )
]

{ #category : 'tooling' }
GLSPDiagramModule >> createActionHandlers [
	"The action handlers of a session. Subclasses add theirs to the standard ones"

	^ OrderedCollection new
		  add: GLSPRequestModelActionHandler new;
		  add: (GLSPOperationActionHandler new
				   operationHandlers: self createOperationHandlers;
				   yourself);
		  add: GLSPUndoRedoActionHandler new;
		  add: GLSPSaveModelActionHandler new;
		  add: GLSPRequestTypeHintsActionHandler new;
		  add: GLSPRequestContextActionsHandler new;
		  yourself
]

{ #category : 'accessing' }
GLSPDiagramModule >> createClientSession: anId server: aServer clientActionKinds: aCollection [

	^ GLSPClientSession new
		  id: anId;
		  diagramModule: self;
		  server: aServer;
		  clientActionKinds: aCollection;
		  yourself
]

{ #category : 'tooling' }
GLSPDiagramModule >> createHandlers [

	^ self createOperationHandlers select: [ :each | each isKindOf: GLSPCreateOperationHandler ]
]

{ #category : 'accessing' }
GLSPDiagramModule >> createOperationHandlers [
	"The operation handlers of my diagrams"

	^ #(  )
]

{ #category : 'accessing' }
GLSPDiagramModule >> diagramType [
	"The diagram type of my diagrams, e.g. 'tasklist-diagram'"

	^ self subclassResponsibility
]

{ #category : 'tooling' }
GLSPDiagramModule >> edgeCreateHandlers [

	^ self createHandlers reject: [ :each | each isNodeCreation ]
]

{ #category : 'tooling' }
GLSPDiagramModule >> edgeTypeHints [
	"By default every created edge type can be deleted and routed"

	^ self edgeCreateHandlers
		  flatCollect: [ :handler |
				  handler elementTypeIds collect: [ :type |
						  GLSPEdgeTypeHint new
							  elementTypeId: type;
							  repositionable: false;
							  deletable: true;
							  routable: true;
							  sourceElementTypeIds: handler sourceElementTypeIds;
							  targetElementTypeIds: handler targetElementTypeIds;
							  yourself ] ]
		  as: Array
]

{ #category : 'accessing' }
GLSPDiagramModule >> gmodelFactory [
	"The GLSPGModelFactory turning my source models into GModels"

	^ self subclassResponsibility
]

{ #category : 'accessing' }
GLSPDiagramModule >> handledActionKinds [
	"The action kinds the server handles for my diagrams, announced in the initialize result"

	^ (self createActionHandlers flatCollect: [ :each | each handledActionKinds ]) asSet asArray sort
]

{ #category : 'tooling' }
GLSPDiagramModule >> nodeCreateHandlers [

	^ self createHandlers select: [ :each | each isNodeCreation ]
]

{ #category : 'tooling' }
GLSPDiagramModule >> shapeTypeHints [
	"By default every created node type can be moved, resized and deleted, but not reparented"

	^ self nodeCreateHandlers
		  flatCollect: [ :handler |
				  handler elementTypeIds collect: [ :type |
						  GLSPShapeTypeHint new
							  elementTypeId: type;
							  repositionable: true;
							  deletable: true;
							  resizable: true;
							  reparentable: false;
							  yourself ] ]
		  as: Array
]

{ #category : 'accessing' }
GLSPDiagramModule >> sourceModelStorage [
	"The GLSPSourceModelStorage loading and saving my source models"

	^ self subclassResponsibility
]

{ #category : 'tooling' }
GLSPDiagramModule >> toolPaletteItems [
	"A 'Nodes' group and an 'Edges' group with a tool for each created element type"

	| groups counter itemsFor |
	counter := 0.
	itemsFor := [ :handlers |
		            handlers
			            flatCollect: [ :handler |
					            handler elementTypeIds collect: [ :type |
							            counter := counter + 1.
							            GLSPPaletteItem new
								            id: ('palette-item{1}' format: { counter });
								            label: handler label;
								            sortString: handler label first asString;
								            actions: { (handler triggerActionFor: type) };
								            yourself ] ]
			            as: Array ].
	groups := OrderedCollection new.
	{
		('node-group' -> ('Nodes' -> self nodeCreateHandlers)).
		('edge-group' -> ('Edges' -> self edgeCreateHandlers)) } doWithIndex: [ :spec :index |
			spec value value ifNotEmpty: [ :handlers |
					groups add: (GLSPPaletteItem new
							 id: spec key;
							 label: spec value key;
							 sortString: index printString;
							 actions: #(  );
							 children: (itemsFor value: handlers);
							 yourself) ] ].
	^ groups asArray
]
