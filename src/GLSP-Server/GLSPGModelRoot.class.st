"
I am the root of a GModel tree. My `revision` increases each time the model changes, so the client can detect stale updates.
"
Class {
	#name : 'GLSPGModelRoot',
	#superclass : 'GLSPGModelElement',
	#instVars : [
		'revision'
	],
	#category : 'GLSP-Server-GModel',
	#package : 'GLSP-Server',
	#tag : 'GModel'
}

{ #category : 'defaults' }
GLSPGModelRoot class >> defaultType [

	^ 'graph'
]

{ #category : 'serialization' }
GLSPGModelRoot >> addPropertiesTo: aDictionary [

	revision ifNotNil: [ aDictionary at: 'revision' put: revision ]
]

{ #category : 'accessing' }
GLSPGModelRoot >> revision [

	^ revision
]

{ #category : 'accessing' }
GLSPGModelRoot >> revision: anInteger [

	revision := anInteger
]
