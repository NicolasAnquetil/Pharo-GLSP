"
Sent by the server with the labeled actions (e.g. palette items) of a context.
"
Class {
	#name : 'GLSPSetContextActions',
	#superclass : 'GLSPResponseAction',
	#instVars : [
		'actions',
		'args'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPSetContextActions class >> kind [
	^ 'setContextActions'
]

{ #category : 'accessing' }
GLSPSetContextActions >> actions [
	^ actions
]

{ #category : 'accessing' }
GLSPSetContextActions >> actions: anObject [
	actions := anObject
]

{ #category : 'accessing' }
GLSPSetContextActions >> args [
	^ args
]

{ #category : 'accessing' }
GLSPSetContextActions >> args: anObject [
	args := anObject
]
