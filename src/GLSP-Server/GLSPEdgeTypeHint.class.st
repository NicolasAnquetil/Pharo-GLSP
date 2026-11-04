"
I tell the client what it may do with the edges of type elementTypeId, and which element types they may connect.
"
Class {
	#name : 'GLSPEdgeTypeHint',
	#superclass : 'GLSPProtocolObject',
	#instVars : [
		'elementTypeId',
		'repositionable',
		'deletable',
		'routable',
		'sourceElementTypeIds',
		'targetElementTypeIds'
	],
	#category : 'GLSP-Server-Protocol',
	#package : 'GLSP-Server',
	#tag : 'Protocol'
}

{ #category : 'accessing' }
GLSPEdgeTypeHint >> deletable [
	^ deletable
]

{ #category : 'accessing' }
GLSPEdgeTypeHint >> deletable: anObject [
	deletable := anObject
]

{ #category : 'accessing' }
GLSPEdgeTypeHint >> elementTypeId [
	^ elementTypeId
]

{ #category : 'accessing' }
GLSPEdgeTypeHint >> elementTypeId: anObject [
	elementTypeId := anObject
]

{ #category : 'accessing' }
GLSPEdgeTypeHint >> repositionable [
	^ repositionable
]

{ #category : 'accessing' }
GLSPEdgeTypeHint >> repositionable: anObject [
	repositionable := anObject
]

{ #category : 'accessing' }
GLSPEdgeTypeHint >> routable [
	^ routable
]

{ #category : 'accessing' }
GLSPEdgeTypeHint >> routable: anObject [
	routable := anObject
]

{ #category : 'accessing' }
GLSPEdgeTypeHint >> sourceElementTypeIds [
	^ sourceElementTypeIds
]

{ #category : 'accessing' }
GLSPEdgeTypeHint >> sourceElementTypeIds: anObject [
	sourceElementTypeIds := anObject
]

{ #category : 'accessing' }
GLSPEdgeTypeHint >> targetElementTypeIds [
	^ targetElementTypeIds
]

{ #category : 'accessing' }
GLSPEdgeTypeHint >> targetElementTypeIds: anObject [
	targetElementTypeIds := anObject
]
