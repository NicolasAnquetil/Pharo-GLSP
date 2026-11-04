"
I am a creation operation handler of the TaskList example (task: createNode of type 'task'; transition: createEdge of type 'transition').
"
Class {
	#name : 'GLSPTaskListCreateTaskHandler',
	#superclass : 'GLSPCreateOperationHandler',
	#category : 'GLSP-Example-TaskList-Handlers',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPTaskListCreateTaskHandler >> elementTypeIds [

	^ #( 'task' )
]

{ #category : 'handling' }
GLSPTaskListCreateTaskHandler >> execute: aCreateNodeOperation in: aClientSession [

	| taskList |
	taskList := aClientSession modelState sourceModel.
	taskList addTask: (GLSPTaskListTask new
			 id: taskList newId;
			 name: 'New Task ' , (taskList tasks size + 1) printString;
			 position: (aCreateNodeOperation location ifNil: [ 0 @ 0 ]);
			 size: GLSPTaskListTask defaultSize;
			 yourself)
]

{ #category : 'handling' }
GLSPTaskListCreateTaskHandler >> label [

	^ 'Task'
]

{ #category : 'handling' }
GLSPTaskListCreateTaskHandler >> operationKind [

	^ GLSPCreateNodeOperation kind
]
