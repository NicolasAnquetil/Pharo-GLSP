"
I am an action expecting an answer: the response action will carry my `requestId` as its `responseId`.
"
Class {
	#name : 'GLSPRequestAction',
	#superclass : 'GLSPAction',
	#instVars : [
		'requestId'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'testing' }
GLSPRequestAction >> isRequest [

	^ requestId isEmptyOrNil not
]

{ #category : 'accessing' }
GLSPRequestAction >> requestId [

	^ requestId
]

{ #category : 'accessing' }
GLSPRequestAction >> requestId: aString [

	requestId := aString
]
