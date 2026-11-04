"
I am an operation handler of the TaskList example: I apply my operation (see #operationKind) to the task list of the session.
"
Class {
	#name : 'GLSPTaskListReconnectEdgeHandler',
	#superclass : 'GLSPOperationHandler',
	#category : 'GLSP-Example-TaskList-Handlers',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPTaskListReconnectEdgeHandler >> execute: aReconnectEdgeOperation in: aClientSession [

	(aClientSession modelState sourceModel transitionAt: aReconnectEdgeOperation edgeElementId) ifNotNil: [ :transition |
			transition
				sourceTaskId: aReconnectEdgeOperation sourceElementId;
				targetTaskId: aReconnectEdgeOperation targetElementId ]
]

{ #category : 'handling' }
GLSPTaskListReconnectEdgeHandler >> operationKind [

	^ GLSPReconnectEdgeOperation kind
]
