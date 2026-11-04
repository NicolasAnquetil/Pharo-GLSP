"
Sent by the client to get the actions available in a context (contextId: 'tool-palette', 'context-menu', 'command-palette'...). Answered by setContextActions.
"
Class {
	#name : 'GLSPRequestContextActions',
	#superclass : 'GLSPRequestAction',
	#instVars : [
		'contextId',
		'editorContext'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPRequestContextActions class >> kind [
	^ 'requestContextActions'
]

{ #category : 'accessing' }
GLSPRequestContextActions >> contextId [
	^ contextId
]

{ #category : 'accessing' }
GLSPRequestContextActions >> contextId: anObject [
	contextId := anObject
]

{ #category : 'accessing' }
GLSPRequestContextActions >> editorContext [
	^ editorContext
]

{ #category : 'accessing' }
GLSPRequestContextActions >> editorContext: anObject [
	editorContext := anObject
]
