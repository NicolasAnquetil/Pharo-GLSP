"
I am the envelope of an action exchanged through the `process` JSON-RPC notification: the action and the id of the client session it belongs to.
"
Class {
	#name : 'GLSPActionMessage',
	#superclass : 'Object',
	#instVars : [
		'clientId',
		'action'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'instance creation' }
GLSPActionMessage class >> clientId: aString action: anAction [

	^ self new
		  clientId: aString;
		  action: anAction;
		  yourself
]

{ #category : 'instance creation' }
GLSPActionMessage class >> fromJSON: aDictionary [

	^ self
		  clientId: (aDictionary at: 'clientId' ifAbsent: [ nil ])
		  action: (GLSPAction fromJSON: (aDictionary at: 'action'))
]

{ #category : 'accessing' }
GLSPActionMessage >> action [

	^ action
]

{ #category : 'accessing' }
GLSPActionMessage >> action: anAction [

	action := anAction
]

{ #category : 'serialization' }
GLSPActionMessage >> asJRPCJSON [

	^ Dictionary new
		  at: 'clientId' put: clientId;
		  at: 'action' put: action asJRPCJSON;
		  yourself
]

{ #category : 'accessing' }
GLSPActionMessage >> clientId [

	^ clientId
]

{ #category : 'accessing' }
GLSPActionMessage >> clientId: aString [

	clientId := aString
]
