"
I am a transition from a task to another one.
"
Class {
	#name : 'GLSPTaskListTransition',
	#superclass : 'Object',
	#instVars : [
		'id',
		'sourceTaskId',
		'targetTaskId'
	],
	#category : 'GLSP-Example-TaskList-Model',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Model'
}

{ #category : 'instance creation' }
GLSPTaskListTransition class >> fromJSON: aDictionary [

	^ self new
		  id: (aDictionary at: 'id');
		  sourceTaskId: (aDictionary at: 'sourceTaskId');
		  targetTaskId: (aDictionary at: 'targetTaskId');
		  yourself
]

{ #category : 'serialization' }
GLSPTaskListTransition >> asJSON [

	^ Dictionary new
		  at: 'id' put: id;
		  at: 'sourceTaskId' put: sourceTaskId;
		  at: 'targetTaskId' put: targetTaskId;
		  yourself
]

{ #category : 'serialization' }
GLSPTaskListTransition >> connects: aTaskId [

	^ sourceTaskId = aTaskId or: [ targetTaskId = aTaskId ]
]

{ #category : 'accessing' }
GLSPTaskListTransition >> id [
	^ id
]

{ #category : 'accessing' }
GLSPTaskListTransition >> id: anObject [
	id := anObject
]

{ #category : 'accessing' }
GLSPTaskListTransition >> sourceTaskId [
	^ sourceTaskId
]

{ #category : 'accessing' }
GLSPTaskListTransition >> sourceTaskId: anObject [
	sourceTaskId := anObject
]

{ #category : 'accessing' }
GLSPTaskListTransition >> targetTaskId [
	^ targetTaskId
]

{ #category : 'accessing' }
GLSPTaskListTransition >> targetTaskId: anObject [
	targetTaskId := anObject
]
