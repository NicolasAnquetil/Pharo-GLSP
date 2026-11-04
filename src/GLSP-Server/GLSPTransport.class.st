"
I am the abstract transport a GLSP server writes its JSON-RPC messages to. #send: takes one JSON string (a complete JSON-RPC message).
"
Class {
	#name : 'GLSPTransport',
	#superclass : 'Object',
	#category : 'GLSP-Server-Transport',
	#package : 'GLSP-Server',
	#tag : 'Transport'
}

{ #category : 'sending' }
GLSPTransport >> close [
	"Release the resources of the transport"

	
]

{ #category : 'sending' }
GLSPTransport >> send: aJSONString [
	"Write one complete JSON-RPC message to the client"

	self subclassResponsibility
]
