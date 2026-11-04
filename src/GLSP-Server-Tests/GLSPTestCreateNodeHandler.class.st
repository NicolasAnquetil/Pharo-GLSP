"
I add a name 'n<size+1>' to the test source model.
"
Class {
	#name : 'GLSPTestCreateNodeHandler',
	#superclass : 'GLSPCreateOperationHandler',
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'handling' }
GLSPTestCreateNodeHandler >> elementTypeIds [

	^ #( 'node' )
]

{ #category : 'handling' }
GLSPTestCreateNodeHandler >> execute: anOperation in: aClientSession [

	| names |
	names := aClientSession modelState sourceModel.
	names add: 'n' , (names size + 1) printString
]

{ #category : 'handling' }
GLSPTestCreateNodeHandler >> operationKind [

	^ GLSPCreateNodeOperation kind
]
