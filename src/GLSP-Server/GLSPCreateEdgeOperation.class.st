"
I create an edge of type elementTypeId from sourceElementId to targetElementId.
"
Class {
	#name : 'GLSPCreateEdgeOperation',
	#superclass : 'GLSPCreateOperation',
	#instVars : [
		'sourceElementId',
		'targetElementId'
	],
	#category : 'GLSP-Server-Operations',
	#package : 'GLSP-Server',
	#tag : 'Operations'
}

{ #category : 'accessing' }
GLSPCreateEdgeOperation class >> kind [
	^ 'createEdge'
]

{ #category : 'accessing' }
GLSPCreateEdgeOperation >> sourceElementId [
	^ sourceElementId
]

{ #category : 'accessing' }
GLSPCreateEdgeOperation >> sourceElementId: anObject [
	sourceElementId := anObject
]

{ #category : 'accessing' }
GLSPCreateEdgeOperation >> targetElementId [
	^ targetElementId
]

{ #category : 'accessing' }
GLSPCreateEdgeOperation >> targetElementId: anObject [
	targetElementId := anObject
]
