"
I remove names from the test source model.
"
Class {
	#name : 'GLSPTestDeleteHandler',
	#superclass : 'GLSPOperationHandler',
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'handling' }
GLSPTestDeleteHandler >> execute: anOperation in: aClientSession [

	aClientSession modelState sourceModel removeAll: anOperation elementIds
]

{ #category : 'handling' }
GLSPTestDeleteHandler >> operationKind [

	^ GLSPDeleteElementOperation kind
]
