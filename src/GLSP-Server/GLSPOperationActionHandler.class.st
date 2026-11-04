"
I handle the operations: I find the operation handler of an operation, execute it as a recording command on the command stack of the session, and answer the model update (updateModel + setDirtyState).
"
Class {
	#name : 'GLSPOperationActionHandler',
	#superclass : 'GLSPActionHandler',
	#instVars : [
		'operationHandlers'
	],
	#category : 'GLSP-Server-Handlers',
	#package : 'GLSP-Server',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPOperationActionHandler >> execute: anOperation in: aClientSession [

	| handler |
	handler := self operationHandlers detect: [ :each | each handles: anOperation ].
	aClientSession commandStack execute:
		(GLSPRecordingCommand modelState: aClientSession modelState block: [ handler execute: anOperation in: aClientSession ]).
	^ aClientSession submitModel: 'operation'
]

{ #category : 'handling' }
GLSPOperationActionHandler >> handledActionKinds [

	^ (self operationHandlers collect: [ :each | each operationKind ]) asSet asArray
]

{ #category : 'handling' }
GLSPOperationActionHandler >> handles: anAction [

	^ anAction isOperation and: [ self operationHandlers anySatisfy: [ :each | each handles: anAction ] ]
]

{ #category : 'handling' }
GLSPOperationActionHandler >> operationHandlers [

	^ operationHandlers ifNil: [ #(  ) ]
]

{ #category : 'handling' }
GLSPOperationActionHandler >> operationHandlers: aCollection [

	operationHandlers := aCollection
]
