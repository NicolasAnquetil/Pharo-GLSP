"
I am an action whose kind is not known by the server. I keep the JSON I was created from, so that I can be forwarded as is.
"
Class {
	#name : 'GLSPUnknownAction',
	#superclass : 'GLSPAction',
	#instVars : [
		'json'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'serialization' }
GLSPUnknownAction >> asJRPCJSON [

	^ json
]

{ #category : 'serialization' }
GLSPUnknownAction >> fromJSON: aDictionary [

	json := aDictionary
]

{ #category : 'accessing' }
GLSPUnknownAction >> json [

	^ json
]

{ #category : 'accessing' }
GLSPUnknownAction >> kind [

	^ json at: 'kind' ifAbsent: [ nil ]
]
