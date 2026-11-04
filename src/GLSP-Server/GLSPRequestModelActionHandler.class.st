"
I handle requestModel: I load the source model, create the GModel and answer it in a setModel action.
"
Class {
	#name : 'GLSPRequestModelActionHandler',
	#superclass : 'GLSPActionHandler',
	#category : 'GLSP-Server-Handlers',
	#package : 'GLSP-Server',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPRequestModelActionHandler >> execute: aRequestModelAction in: aClientSession [

	| state |
	state := aClientSession modelState.
	state clientOptions: aRequestModelAction options.
	aClientSession diagramModule sourceModelStorage loadSourceModel: state.
	aClientSession updateGModel.
	^ { (GLSPSetModelAction newRoot: state root) }
]

{ #category : 'handling' }
GLSPRequestModelActionHandler >> handledActionKinds [

	^ { GLSPRequestModelAction kind }
]
