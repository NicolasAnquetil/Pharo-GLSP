"
I execute operations of one kind (#operationKind) by changing the source model of the session. I do not have to care about undo/redo: the framework records the source model around my execution (see GLSPRecordingCommand) and then rebuilds and sends the GModel.

Subclasses implement #operationKind and #execute:in:.
"
Class {
	#name : 'GLSPOperationHandler',
	#superclass : 'Object',
	#category : 'GLSP-Server-Handlers',
	#package : 'GLSP-Server',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPOperationHandler >> execute: anOperation in: aClientSession [
	"Change the source model of aClientSession according to anOperation"

	self subclassResponsibility
]

{ #category : 'error handling' }
GLSPOperationHandler >> handles: anOperation [

	^ anOperation kind = self operationKind
]

{ #category : 'handling' }
GLSPOperationHandler >> operationKind [

	^ self subclassResponsibility
]
