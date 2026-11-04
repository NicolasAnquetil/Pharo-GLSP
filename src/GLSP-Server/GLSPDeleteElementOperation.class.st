"
I delete the elements of ids elementIds.
"
Class {
	#name : 'GLSPDeleteElementOperation',
	#superclass : 'GLSPOperation',
	#instVars : [
		'elementIds'
	],
	#category : 'GLSP-Server-Operations',
	#package : 'GLSP-Server',
	#tag : 'Operations'
}

{ #category : 'accessing' }
GLSPDeleteElementOperation class >> kind [
	^ 'deleteElement'
]

{ #category : 'accessing' }
GLSPDeleteElementOperation >> elementIds [
	^ elementIds
]

{ #category : 'accessing' }
GLSPDeleteElementOperation >> elementIds: anObject [
	elementIds := anObject
]
