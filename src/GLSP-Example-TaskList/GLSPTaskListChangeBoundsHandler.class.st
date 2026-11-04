"
I am an operation handler of the TaskList example: I apply my operation (see #operationKind) to the task list of the session.
"
Class {
	#name : 'GLSPTaskListChangeBoundsHandler',
	#superclass : 'GLSPOperationHandler',
	#category : 'GLSP-Example-TaskList-Handlers',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPTaskListChangeBoundsHandler >> execute: aChangeBoundsOperation in: aClientSession [

	| taskList |
	taskList := aClientSession modelState sourceModel.
	aChangeBoundsOperation elementBoundsDo: [ :elementId :newPosition :newSize |
			(taskList taskAt: elementId) ifNotNil: [ :task |
					newPosition ifNotNil: [ task position: newPosition ].
					newSize ifNotNil: [ task size: newSize ] ] ]
]

{ #category : 'handling' }
GLSPTaskListChangeBoundsHandler >> operationKind [

	^ GLSPChangeBoundsOperation kind
]
