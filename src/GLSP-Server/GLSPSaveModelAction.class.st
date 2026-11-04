"
Sent by the client to save the source model, to fileUri if given, to the source uri otherwise.
"
Class {
	#name : 'GLSPSaveModelAction',
	#superclass : 'GLSPAction',
	#instVars : [
		'fileUri'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPSaveModelAction class >> kind [
	^ 'saveModel'
]

{ #category : 'accessing' }
GLSPSaveModelAction >> fileUri [
	^ fileUri
]

{ #category : 'accessing' }
GLSPSaveModelAction >> fileUri: anObject [
	fileUri := anObject
]
