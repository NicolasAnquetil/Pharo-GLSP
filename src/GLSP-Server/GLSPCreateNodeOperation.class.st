"
I create a node of type elementTypeId at location (a Point, optional) in the container containerId (optional).
"
Class {
	#name : 'GLSPCreateNodeOperation',
	#superclass : 'GLSPCreateOperation',
	#instVars : [
		'location',
		'containerId'
	],
	#category : 'GLSP-Server-Operations',
	#package : 'GLSP-Server',
	#tag : 'Operations'
}

{ #category : 'accessing' }
GLSPCreateNodeOperation class >> kind [
	^ 'createNode'
]

{ #category : 'accessing' }
GLSPCreateNodeOperation >> containerId [
	^ containerId
]

{ #category : 'accessing' }
GLSPCreateNodeOperation >> containerId: anObject [
	containerId := anObject
]

{ #category : 'serialization' }
GLSPCreateNodeOperation >> fromJSON: aDictionary [

	super fromJSON: aDictionary.
	location := self class pointFromJSON: location
]

{ #category : 'accessing' }
GLSPCreateNodeOperation >> location [
	^ location
]

{ #category : 'accessing' }
GLSPCreateNodeOperation >> location: anObject [
	location := anObject
]
