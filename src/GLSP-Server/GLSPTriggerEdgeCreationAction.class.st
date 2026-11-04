"
I activate, on the client, the creation tool of the elements of type elementTypeId (used in palette items).
"
Class {
	#name : 'GLSPTriggerEdgeCreationAction',
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
GLSPTriggerEdgeCreationAction class >> elementTypeId: aString [

	^ self new
		  elementTypeId: aString;
		  yourself
]

{ #category : 'accessing' }
GLSPTriggerEdgeCreationAction class >> kind [
	^ 'triggerEdgeCreation'
]

{ #category : 'accessing' }
GLSPTriggerEdgeCreationAction >> args [
	^ args
]

{ #category : 'accessing' }
GLSPTriggerEdgeCreationAction >> args: anObject [
	args := anObject
]

{ #category : 'accessing' }
GLSPTriggerEdgeCreationAction >> elementTypeId [
	^ elementTypeId
]

{ #category : 'accessing' }
GLSPTriggerEdgeCreationAction >> elementTypeId: anObject [
	elementTypeId := anObject
]
