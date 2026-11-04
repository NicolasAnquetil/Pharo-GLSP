"
I handle saveModel: I save the source model with the source model storage and tell the client the model is not dirty anymore.
"
Class {
	#name : 'GLSPSaveModelActionHandler',
	#superclass : 'GLSPActionHandler',
	#category : 'GLSP-Server-Handlers',
	#package : 'GLSP-Server',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPSaveModelActionHandler >> execute: aSaveModelAction in: aClientSession [

	| state |
	state := aClientSession modelState.
	aClientSession diagramModule sourceModelStorage saveSourceModel: state to: (aSaveModelAction fileUri ifNil: [ state sourceUri ]).
	aClientSession commandStack saveIsDone.
	^ { (GLSPSetDirtyStateAction isDirty: false reason: 'save') }
]

{ #category : 'handling' }
GLSPSaveModelActionHandler >> handledActionKinds [

	^ { GLSPSaveModelAction kind }
]
