"
I am a minimal diagram module used by the tests, for the diagram type 'test-diagram'.
"
Class {
	#name : 'GLSPTestDiagramModule',
	#superclass : 'GLSPDiagramModule',
	#instVars : [
		'storage'
	],
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'accessing' }
GLSPTestDiagramModule >> createOperationHandlers [

	^ {
		  GLSPTestCreateNodeHandler new.
		  GLSPTestDeleteHandler new }
]

{ #category : 'accessing' }
GLSPTestDiagramModule >> diagramType [

	^ 'test-diagram'
]

{ #category : 'accessing' }
GLSPTestDiagramModule >> gmodelFactory [

	^ GLSPTestGModelFactory new
]

{ #category : 'accessing' }
GLSPTestDiagramModule >> sourceModelStorage [

	^ storage ifNil: [ storage := GLSPTestSourceModelStorage new ]
]
