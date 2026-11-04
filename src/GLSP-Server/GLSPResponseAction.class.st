"
I am an action answering a request action. My `responseId` is the `requestId` of the request.
"
Class {
	#name : 'GLSPResponseAction',
	#superclass : 'GLSPAction',
	#instVars : [
		'responseId'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'testing' }
GLSPResponseAction >> isResponse [

	^ responseId isEmptyOrNil not
]

{ #category : 'testing' }
GLSPResponseAction >> isResponseAction [

	^ true
]

{ #category : 'responding' }
GLSPResponseAction >> respondTo: anAction [

	anAction isRequest ifTrue: [ responseId := anAction requestId ]
]

{ #category : 'accessing' }
GLSPResponseAction >> responseId [

	^ responseId
]

{ #category : 'accessing' }
GLSPResponseAction >> responseId: aString [

	responseId := aString
]
