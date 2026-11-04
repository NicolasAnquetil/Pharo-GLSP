"
I am the source model of the TaskList example: tasks and transitions between them. I am read from and written to the JSON of a .tasklist file (#fromJSON: / #asJSON).
"
Class {
	#name : 'GLSPTaskList',
	#superclass : 'Object',
	#instVars : [
		'id',
		'tasks',
		'transitions'
	],
	#category : 'GLSP-Example-TaskList-Model',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Model'
}

{ #category : 'instance creation' }
GLSPTaskList class >> fromJSON: aDictionary [

	^ self new
		  id: (aDictionary at: 'id' ifAbsent: [ 'tasklist' ]);
		  tasks:
			  ((aDictionary at: 'tasks' ifAbsent: [ #(  ) ]) collect: [ :each | GLSPTaskListTask fromJSON: each ]) asOrderedCollection;
		  transitions: ((aDictionary at: 'transitions' ifAbsent: [ #(  ) ]) collect: [ :each | GLSPTaskListTransition fromJSON: each ])
				  asOrderedCollection;
		  yourself
]

{ #category : 'accessing' }
GLSPTaskList >> addTask: aTask [

	^ tasks add: aTask
]

{ #category : 'accessing' }
GLSPTaskList >> addTransition: aTransition [

	^ transitions add: aTransition
]

{ #category : 'accessing' }
GLSPTaskList >> asJSON [

	^ Dictionary new
		  at: 'id' put: id;
		  at: 'tasks' put: (tasks collect: [ :each | each asJSON ]) asArray;
		  at: 'transitions' put: (transitions collect: [ :each | each asJSON ]) asArray;
		  yourself
]

{ #category : 'accessing' }
GLSPTaskList >> id [
	^ id
]

{ #category : 'accessing' }
GLSPTaskList >> id: anObject [
	id := anObject
]

{ #category : 'accessing' }
GLSPTaskList >> initialize [

	super initialize.
	id := 'tasklist'.
	tasks := OrderedCollection new.
	transitions := OrderedCollection new
]

{ #category : 'accessing' }
GLSPTaskList >> newId [

	^ UUID new asString
]

{ #category : 'accessing' }
GLSPTaskList >> removeElementAt: anId [
	"Remove the task or transition anId. Removing a task removes its transitions"

	tasks removeAllSuchThat: [ :each | each id = anId ].
	transitions removeAllSuchThat: [ :each | each id = anId or: [ each connects: anId ] ]
]

{ #category : 'accessing' }
GLSPTaskList >> taskAt: anId [

	^ tasks detect: [ :each | each id = anId ] ifNone: [ nil ]
]

{ #category : 'accessing' }
GLSPTaskList >> tasks [
	^ tasks
]

{ #category : 'accessing' }
GLSPTaskList >> tasks: anObject [
	tasks := anObject
]

{ #category : 'accessing' }
GLSPTaskList >> transitionAt: anId [

	^ transitions detect: [ :each | each id = anId ] ifNone: [ nil ]
]

{ #category : 'accessing' }
GLSPTaskList >> transitions [
	^ transitions
]

{ #category : 'accessing' }
GLSPTaskList >> transitions: anObject [
	transitions := anObject
]
