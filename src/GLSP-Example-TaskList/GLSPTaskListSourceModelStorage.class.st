"
I read and write .tasklist JSON files.
"
Class {
	#name : 'GLSPTaskListSourceModelStorage',
	#superclass : 'GLSPFileSourceModelStorage',
	#category : 'GLSP-Example-TaskList-Server',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Server'
}

{ #category : 'converting' }
GLSPTaskListSourceModelStorage >> jsonFromSourceModel: aTaskList [

	^ aTaskList asJSON
]

{ #category : 'converting' }
GLSPTaskListSourceModelStorage >> sourceModelFromJSON: aJSONObject [

	^ GLSPTaskList fromJSON: aJSONObject
]
