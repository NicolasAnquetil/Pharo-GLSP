"
I answer a tooling request of the client (type hints, context actions such as the tool palette) with what the diagram module provides.
"
Class {
	#name : 'GLSPRequestContextActionsHandler',
	#superclass : 'GLSPActionHandler',
	#category : 'GLSP-Server-Handlers',
	#package : 'GLSP-Server',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPRequestContextActionsHandler >> execute: aRequestContextActions in: aClientSession [
	"Always answer, even with no action, so that the request of the client is resolved"

	^ { (GLSPSetContextActions new
		   actions: (aClientSession diagramModule
				    contextActionsFor: aRequestContextActions contextId
				    editorContext: aRequestContextActions editorContext
				    in: aClientSession);
		   yourself) }
]

{ #category : 'handling' }
GLSPRequestContextActionsHandler >> handledActionKinds [

	^ { GLSPRequestContextActions kind }
]
