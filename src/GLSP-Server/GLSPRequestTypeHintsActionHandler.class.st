"
I answer a tooling request of the client (type hints, context actions such as the tool palette) with what the diagram module provides.
"
Class {
	#name : 'GLSPRequestTypeHintsActionHandler',
	#superclass : 'GLSPActionHandler',
	#category : 'GLSP-Server-Handlers',
	#package : 'GLSP-Server',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPRequestTypeHintsActionHandler >> execute: anAction in: aClientSession [

	| module |
	module := aClientSession diagramModule.
	^ { (GLSPSetTypeHintsAction new
		   shapeHints: module shapeTypeHints;
		   edgeHints: module edgeTypeHints;
		   yourself) }
]

{ #category : 'handling' }
GLSPRequestTypeHintsActionHandler >> handledActionKinds [

	^ { GLSPRequestTypeHintsAction kind }
]
