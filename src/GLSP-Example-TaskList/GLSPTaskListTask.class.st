"
I am a task of a task list: a name, and the position and size of my node in the diagram.
"
Class {
	#name : 'GLSPTaskListTask',
	#superclass : 'Object',
	#instVars : [
		'id',
		'name',
		'position',
		'size'
	],
	#category : 'GLSP-Example-TaskList-Model',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Model'
}

{ #category : 'instance creation' }
GLSPTaskListTask class >> defaultSize [

	^ 120 @ 40
]

{ #category : 'instance creation' }
GLSPTaskListTask class >> fromJSON: aDictionary [

	^ self new
		  id: (aDictionary at: 'id');
		  name: (aDictionary at: 'name' ifAbsent: [ '' ]);
		  position: ((GLSPAction pointFromJSON: (aDictionary at: 'position' ifAbsent: [ nil ])) ifNil: [ 0 @ 0 ]);
		  size: ((GLSPAction dimensionFromJSON: (aDictionary at: 'size' ifAbsent: [ nil ])) ifNil: [ self defaultSize ]);
		  yourself
]

{ #category : 'serialization' }
GLSPTaskListTask >> asJSON [

	^ Dictionary new
		  at: 'id' put: id;
		  at: 'name' put: name;
		  at: 'position' put: position asGLSPPointJSON;
		  at: 'size' put: size asGLSPDimensionJSON;
		  yourself
]

{ #category : 'accessing' }
GLSPTaskListTask >> id [
	^ id
]

{ #category : 'accessing' }
GLSPTaskListTask >> id: anObject [
	id := anObject
]

{ #category : 'accessing' }
GLSPTaskListTask >> name [
	^ name
]

{ #category : 'accessing' }
GLSPTaskListTask >> name: anObject [
	name := anObject
]

{ #category : 'accessing' }
GLSPTaskListTask >> position [
	^ position
]

{ #category : 'accessing' }
GLSPTaskListTask >> position: anObject [
	position := anObject
]

{ #category : 'accessing' }
GLSPTaskListTask >> size [
	^ size
]

{ #category : 'accessing' }
GLSPTaskListTask >> size: anObject [
	size := anObject
]
