"
I activate, on the client, the creation tool of the elements of type elementTypeId (used in palette items).
"
Class {
	#name : 'GLSPTriggerNodeCreationAction',
	#superclass : 'GLSPAction',
	#instVars : [
		'elementTypeId',
		'args'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'instance creation' }
GLSPTriggerNodeCreationAction class >> elementTypeId: aString [

	^ self new
		  elementTypeId: aString;
		  yourself
]

{ #category : 'accessing' }
GLSPTriggerNodeCreationAction class >> kind [
	^ 'triggerNodeCreation'
]

{ #category : 'accessing' }
GLSPTriggerNodeCreationAction >> args [
	^ args
]

{ #category : 'accessing' }
GLSPTriggerNodeCreationAction >> args: anObject [
	args := anObject
]

{ #category : 'accessing' }
GLSPTriggerNodeCreationAction >> elementTypeId [
	^ elementTypeId
]

{ #category : 'accessing' }
GLSPTriggerNodeCreationAction >> elementTypeId: anObject [
	elementTypeId := anObject
]
