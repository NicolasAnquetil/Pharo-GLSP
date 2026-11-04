"
I am an operation creating an element of type elementTypeId.
"
Class {
	#name : 'GLSPCreateOperation',
	#superclass : 'GLSPOperation',
	#instVars : [
		'elementTypeId',
		'args'
	],
	#category : 'GLSP-Server-Operations',
	#package : 'GLSP-Server',
	#tag : 'Operations'
}

{ #category : 'accessing' }
GLSPCreateOperation >> args [
	^ args
]

{ #category : 'accessing' }
GLSPCreateOperation >> args: anObject [
	args := anObject
]

{ #category : 'accessing' }
GLSPCreateOperation >> elementTypeId [
	^ elementTypeId
]

{ #category : 'accessing' }
GLSPCreateOperation >> elementTypeId: anObject [
	elementTypeId := anObject
]
