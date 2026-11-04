"
Sent by the client to get the type hints of the diagram. Answered by setTypeHints.
"
Class {
	#name : 'GLSPRequestTypeHintsAction',
	#superclass : 'GLSPRequestAction',
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPRequestTypeHintsAction class >> kind [
	^ 'requestTypeHints'
]
