"
I am the diagram module of the TaskList example language ('tasklist-diagram'), the language of the official GLSP server templates: tasks (nodes with an editable name) connected by transitions (edges), stored in a JSON .tasklist file.
"
Class {
	#name : 'GLSPTaskListDiagramModule',
	#superclass : 'GLSPDiagramModule',
	#category : 'GLSP-Example-TaskList-Server',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Server'
}

{ #category : 'accessing' }
GLSPTaskListDiagramModule >> createOperationHandlers [

	^ {
		  GLSPTaskListCreateTaskHandler new.
		  GLSPTaskListCreateTransitionHandler new.
		  GLSPTaskListDeleteHandler new.
		  GLSPTaskListChangeBoundsHandler new.
		  GLSPTaskListApplyLabelEditHandler new.
		  GLSPTaskListReconnectEdgeHandler new }
]

{ #category : 'accessing' }
GLSPTaskListDiagramModule >> diagramType [

	^ 'tasklist-diagram'
]

{ #category : 'accessing' }
GLSPTaskListDiagramModule >> gmodelFactory [

	^ GLSPTaskListGModelFactory new
]

{ #category : 'accessing' }
GLSPTaskListDiagramModule >> sourceModelStorage [

	^ GLSPTaskListSourceModelStorage new
]
