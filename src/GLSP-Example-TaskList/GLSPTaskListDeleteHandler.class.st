"
I am an operation handler of the TaskList example: I apply my operation (see #operationKind) to the task list of the session.
"
Class {
	#name : 'GLSPTaskListDeleteHandler',
	#superclass : 'GLSPOperationHandler',
	#category : 'GLSP-Example-TaskList-Handlers',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPTaskListDeleteHandler >> execute: aDeleteElementOperation in: aClientSession [

	| taskList |
	taskList := aClientSession modelState sourceModel.
	aDeleteElementOperation elementIds do: [ :each | taskList removeElementAt: each ]
]

{ #category : 'handling' }
GLSPTaskListDeleteHandler >> operationKind [

	^ GLSPDeleteElementOperation kind
]
