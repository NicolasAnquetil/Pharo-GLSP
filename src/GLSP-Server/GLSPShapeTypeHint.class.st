"
I tell the client what it may do with the shapes (nodes) of type elementTypeId.
"
Class {
	#name : 'GLSPShapeTypeHint',
	#superclass : 'GLSPProtocolObject',
	#instVars : [
		'elementTypeId',
		'repositionable',
		'deletable',
		'resizable',
		'reparentable',
		'containableElementTypeIds'
	],
	#category : 'GLSP-Server-Protocol',
	#package : 'GLSP-Server',
	#tag : 'Protocol'
}

{ #category : 'accessing' }
GLSPShapeTypeHint >> containableElementTypeIds [
	^ containableElementTypeIds
]

{ #category : 'accessing' }
GLSPShapeTypeHint >> containableElementTypeIds: anObject [
	containableElementTypeIds := anObject
]

{ #category : 'accessing' }
GLSPShapeTypeHint >> deletable [
	^ deletable
]

{ #category : 'accessing' }
GLSPShapeTypeHint >> deletable: anObject [
	deletable := anObject
]

{ #category : 'accessing' }
GLSPShapeTypeHint >> elementTypeId [
	^ elementTypeId
]

{ #category : 'accessing' }
GLSPShapeTypeHint >> elementTypeId: anObject [
	elementTypeId := anObject
]

{ #category : 'accessing' }
GLSPShapeTypeHint >> reparentable [
	^ reparentable
]

{ #category : 'accessing' }
GLSPShapeTypeHint >> reparentable: anObject [
	reparentable := anObject
]

{ #category : 'accessing' }
GLSPShapeTypeHint >> repositionable [
	^ repositionable
]

{ #category : 'accessing' }
GLSPShapeTypeHint >> repositionable: anObject [
	repositionable := anObject
]

{ #category : 'accessing' }
GLSPShapeTypeHint >> resizable [
	^ resizable
]

{ #category : 'accessing' }
GLSPShapeTypeHint >> resizable: anObject [
	resizable := anObject
]
