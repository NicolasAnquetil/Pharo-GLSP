"
I am a creation operation handler of the TaskList example (task: createNode of type 'task'; transition: createEdge of type 'transition').
"
Class {
	#name : 'GLSPTaskListCreateTransitionHandler',
	#superclass : 'GLSPCreateOperationHandler',
	#category : 'GLSP-Example-TaskList-Handlers',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPTaskListCreateTransitionHandler >> elementTypeIds [

	^ #( 'transition' )
]

{ #category : 'handling' }
GLSPTaskListCreateTransitionHandler >> execute: aCreateEdgeOperation in: aClientSession [

	| taskList |
	taskList := aClientSession modelState sourceModel.
	taskList addTransition: (GLSPTaskListTransition new
			 id: taskList newId;
			 sourceTaskId: aCreateEdgeOperation sourceElementId;
			 targetTaskId: aCreateEdgeOperation targetElementId;
			 yourself)
]

{ #category : 'handling' }
GLSPTaskListCreateTransitionHandler >> label [

	^ 'Transition'
]

{ #category : 'handling' }
GLSPTaskListCreateTransitionHandler >> operationKind [

	^ GLSPCreateEdgeOperation kind
]

{ #category : 'handling' }
GLSPTaskListCreateTransitionHandler >> sourceElementTypeIds [

	^ #( 'task' )
]

{ #category : 'handling' }
GLSPTaskListCreateTransitionHandler >> targetElementTypeIds [

	^ #( 'task' )
]
