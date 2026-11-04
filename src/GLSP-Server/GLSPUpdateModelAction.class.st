"
Sent by the server to replace the model of the client by newRoot after a change (the client computes the differences and may animate them).
"
Class {
	#name : 'GLSPUpdateModelAction',
	#superclass : 'GLSPAction',
	#instVars : [
		'newRoot',
		'animate'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPUpdateModelAction class >> kind [
	^ 'updateModel'
]

{ #category : 'instance creation' }
GLSPUpdateModelAction class >> newRoot: aGModelRoot [

	^ self new
		  newRoot: aGModelRoot;
		  yourself
]

{ #category : 'accessing' }
GLSPUpdateModelAction >> animate [
	^ animate
]

{ #category : 'accessing' }
GLSPUpdateModelAction >> animate: anObject [
	animate := anObject
]

{ #category : 'accessing' }
GLSPUpdateModelAction >> newRoot [
	^ newRoot
]

{ #category : 'accessing' }
GLSPUpdateModelAction >> newRoot: anObject [
	newRoot := anObject
]
