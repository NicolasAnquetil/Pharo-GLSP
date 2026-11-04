"
I am an edge connecting the element `sourceId` to the element `targetId`. `routingPoints` are the intermediate points (Points) the edge goes through.
"
Class {
	#name : 'GLSPGEdge',
	#superclass : 'GLSPGModelElement',
	#instVars : [
		'sourceId',
		'targetId',
		'routingPoints'
	],
	#category : 'GLSP-Server-GModel',
	#package : 'GLSP-Server',
	#tag : 'GModel'
}

{ #category : 'defaults' }
GLSPGEdge class >> defaultType [

	^ 'edge'
]

{ #category : 'serialization' }
GLSPGEdge >> addPropertiesTo: aDictionary [

	aDictionary
		at: 'sourceId' put: sourceId;
		at: 'targetId' put: targetId;
		at: 'routingPoints' put: (self routingPoints collect: [ :each | each asGLSPPointJSON ]) asArray
]

{ #category : 'accessing' }
GLSPGEdge >> routingPoints [

	^ routingPoints ifNil: [ routingPoints := OrderedCollection new ]
]

{ #category : 'accessing' }
GLSPGEdge >> routingPoints: aCollectionOfPoints [

	routingPoints := aCollectionOfPoints asOrderedCollection
]

{ #category : 'accessing' }
GLSPGEdge >> sourceId [

	^ sourceId
]

{ #category : 'accessing' }
GLSPGEdge >> sourceId: aString [

	sourceId := aString
]

{ #category : 'accessing' }
GLSPGEdge >> targetId [

	^ targetId
]

{ #category : 'accessing' }
GLSPGEdge >> targetId: aString [

	targetId := aString
]
