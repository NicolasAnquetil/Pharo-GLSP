"
Sent by the client to undo the last operation.
"
Class {
	#name : 'GLSPUndoAction',
	#superclass : 'GLSPAction',
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPUndoAction class >> kind [
	^ 'glspUndo'
]
