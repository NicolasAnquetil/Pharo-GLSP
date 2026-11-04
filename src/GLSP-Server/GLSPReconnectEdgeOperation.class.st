"
I change the source and/or target of the edge edgeElementId.
"
Class {
	#name : 'GLSPReconnectEdgeOperation',
	#superclass : 'GLSPOperation',
	#instVars : [
		'edgeElementId',
		'sourceElementId',
		'targetElementId'
	],
	#category : 'GLSP-Server-Operations',
	#package : 'GLSP-Server',
	#tag : 'Operations'
}

{ #category : 'accessing' }
GLSPReconnectEdgeOperation class >> kind [
	^ 'reconnectEdge'
]

{ #category : 'accessing' }
GLSPReconnectEdgeOperation >> edgeElementId [
	^ edgeElementId
]

{ #category : 'accessing' }
GLSPReconnectEdgeOperation >> edgeElementId: anObject [
	edgeElementId := anObject
]

{ #category : 'accessing' }
GLSPReconnectEdgeOperation >> sourceElementId [
	^ sourceElementId
]

{ #category : 'accessing' }
GLSPReconnectEdgeOperation >> sourceElementId: anObject [
	sourceElementId := anObject
]

{ #category : 'accessing' }
GLSPReconnectEdgeOperation >> targetElementId [
	^ targetElementId
]

{ #category : 'accessing' }
GLSPReconnectEdgeOperation >> targetElementId: anObject [
	targetElementId := anObject
]
