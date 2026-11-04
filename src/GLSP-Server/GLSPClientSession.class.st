"
I am a client session: the server side of one diagram opened by a client. I know my diagram module, the action kinds the client handles, and I dispatch the actions received for me.
"
Class {
	#name : 'GLSPClientSession',
	#superclass : 'Object',
	#instVars : [
		'id',
		'diagramModule',
		'clientActionKinds',
		'server',
		'modelState',
		'actionHandlers',
		'commandStack'
	],
	#category : 'GLSP-Server-Core',
	#package : 'GLSP-Server',
	#tag : 'Core'
}

{ #category : 'dispatching' }
GLSPClientSession >> actionHandlers [

	^ actionHandlers ifNil: [ actionHandlers := diagramModule createActionHandlers ]
]

{ #category : 'accessing' }
GLSPClientSession >> clientActionKinds [

	^ clientActionKinds
]

{ #category : 'accessing' }
GLSPClientSession >> clientActionKinds: aCollection [

	clientActionKinds := aCollection ifNil: [ #(  ) ]
]

{ #category : 'model' }
GLSPClientSession >> commandStack [

	^ commandStack ifNil: [ commandStack := GLSPCommandStack new ]
]

{ #category : 'accessing' }
GLSPClientSession >> diagramModule [

	^ diagramModule
]

{ #category : 'accessing' }
GLSPClientSession >> diagramModule: aDiagramModule [

	diagramModule := aDiagramModule
]

{ #category : 'accessing' }
GLSPClientSession >> diagramType [

	^ diagramModule diagramType
]

{ #category : 'dispatching' }
GLSPClientSession >> dispatch: anAction [
	"Dispatch an action produced on the server side: to the server handlers taking it, to the client otherwise"

	| handlers |
	handlers := self handlersFor: anAction.
	handlers ifEmpty: [ ^ self sendToClient: anAction ].
	handlers do: [ :handler | self execute: handler on: anAction ]
]

{ #category : 'initialization' }
GLSPClientSession >> dispose [
	"Release the resources of the session"

	
]

{ #category : 'dispatching' }
GLSPClientSession >> execute: anActionHandler on: anAction [

	(anActionHandler execute: anAction in: self) do: [ :result |
			result isResponseAction ifTrue: [ result respondTo: anAction ].
			self dispatch: result ]
]

{ #category : 'dispatching' }
GLSPClientSession >> handlersFor: anAction [

	^ self actionHandlers select: [ :each | each handles: anAction ]
]

{ #category : 'accessing' }
GLSPClientSession >> id [

	^ id
]

{ #category : 'accessing' }
GLSPClientSession >> id: aString [

	id := aString
]

{ #category : 'model' }
GLSPClientSession >> isDirty [

	^ self commandStack isDirty
]

{ #category : 'dispatching' }
GLSPClientSession >> modelState [

	^ modelState ifNil: [ modelState := GLSPModelState new ]
]

{ #category : 'dispatching' }
GLSPClientSession >> process: anAction [
	"Handle an action received from the client. Actions no server handler takes are ignored"

	(self handlersFor: anAction) do: [ :handler | self execute: handler on: anAction ]
]

{ #category : 'dispatching' }
GLSPClientSession >> sendToClient: anAction [

	server sendAction: anAction toClient: id
]

{ #category : 'accessing' }
GLSPClientSession >> server [

	^ server
]

{ #category : 'accessing' }
GLSPClientSession >> server: aServer [

	server := aServer
]

{ #category : 'model' }
GLSPClientSession >> submitModel: aReason [
	"Rebuild the GModel after a change of the source model, and answer the actions telling the client"

	self updateGModel.
	^ {
		  (GLSPUpdateModelAction newRoot: self modelState root).
		  (GLSPSetDirtyStateAction isDirty: self isDirty reason: aReason) }
]

{ #category : 'dispatching' }
GLSPClientSession >> updateGModel [
	"Rebuild the GModel from the source model"

	self modelState root: (diagramModule gmodelFactory createGModel: self modelState)
]
