"
Sent by the client to request the model of a diagram. `options` usually contain the `sourceUri` of the source model and the `diagramType`.

Answered by a `GLSPSetModelAction`.
"
Class {
	#name : 'GLSPRequestModelAction',
	#superclass : 'GLSPRequestAction',
	#instVars : [
		'options'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPRequestModelAction class >> kind [

	^ 'requestModel'
]

{ #category : 'accessing' }
GLSPRequestModelAction >> diagramType [

	^ self options at: 'diagramType' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
GLSPRequestModelAction >> options [

	^ options ifNil: [ options := Dictionary new ]
]

{ #category : 'accessing' }
GLSPRequestModelAction >> options: aDictionary [

	options := aDictionary
]

{ #category : 'accessing' }
GLSPRequestModelAction >> sourceUri [

	^ self options at: 'sourceUri' ifAbsent: [ nil ]
]
