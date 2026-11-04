"
Sent by the server with the type hints of the diagram.
"
Class {
	#name : 'GLSPSetTypeHintsAction',
	#superclass : 'GLSPResponseAction',
	#instVars : [
		'shapeHints',
		'edgeHints'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPSetTypeHintsAction class >> kind [
	^ 'setTypeHints'
]

{ #category : 'accessing' }
GLSPSetTypeHintsAction >> edgeHints [
	^ edgeHints
]

{ #category : 'accessing' }
GLSPSetTypeHintsAction >> edgeHints: anObject [
	edgeHints := anObject
]

{ #category : 'accessing' }
GLSPSetTypeHintsAction >> shapeHints [
	^ shapeHints
]

{ #category : 'accessing' }
GLSPSetTypeHintsAction >> shapeHints: anObject [
	shapeHints := anObject
]
