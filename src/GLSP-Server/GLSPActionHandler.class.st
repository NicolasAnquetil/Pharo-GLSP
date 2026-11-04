"
I handle actions of some kinds (#handledActionKinds) for a client session. #execute:in: answers the actions resulting from the handling (to be dispatched in turn: to the server handlers if any, to the client otherwise).
"
Class {
	#name : 'GLSPActionHandler',
	#superclass : 'Object',
	#category : 'GLSP-Server-Handlers',
	#package : 'GLSP-Server',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPActionHandler >> execute: anAction in: aClientSession [
	"Handle anAction and answer the resulting actions"

	^ self subclassResponsibility
]

{ #category : 'handling' }
GLSPActionHandler >> handledActionKinds [

	^ self subclassResponsibility
]

{ #category : 'handling' }
GLSPActionHandler >> handles: anAction [

	^ self handledActionKinds includes: anAction kind
]
