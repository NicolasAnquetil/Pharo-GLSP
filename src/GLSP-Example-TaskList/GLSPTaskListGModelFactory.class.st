"
I turn a task list into a GModel: a node of type 'task' (with a label '<id>_label' showing its name) for each task, an edge of type 'transition' for each transition.
"
Class {
	#name : 'GLSPTaskListGModelFactory',
	#superclass : 'GLSPGModelFactory',
	#category : 'GLSP-Example-TaskList-Server',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Server'
}

{ #category : 'creation' }
GLSPTaskListGModelFactory >> createGModel: aModelState [

	| taskList root |
	taskList := aModelState sourceModel.
	root := GLSPGModelRoot new
		        id: taskList id;
		        yourself.
	taskList tasks do: [ :each | root add: (self nodeFor: each) ].
	taskList transitions do: [ :each | root add: (self edgeFor: each) ].
	^ root
]

{ #category : 'creation' }
GLSPTaskListGModelFactory >> edgeFor: aTransition [

	^ GLSPGEdge new
		  id: aTransition id;
		  type: 'transition';
		  sourceId: aTransition sourceTaskId;
		  targetId: aTransition targetTaskId;
		  yourself
]

{ #category : 'creation' }
GLSPTaskListGModelFactory >> nodeFor: aTask [

	| node |
	node := GLSPGNode new
		        id: aTask id;
		        type: 'task';
		        position: aTask position;
		        size: aTask size;
		        layout: 'hbox';
		        yourself.
	node addCssClass: 'tasklist-node'.
	node add: (GLSPGLabel new
			 id: aTask id , '_label';
			 text: aTask name;
			 yourself).
	^ node
]
