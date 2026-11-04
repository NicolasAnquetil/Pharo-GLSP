"
Sent by the client to redo the last undone operation.
"
Class {
	#name : 'GLSPRedoAction',
	#superclass : 'GLSPAction',
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPRedoAction class >> kind [
	^ 'glspRedo'
]
