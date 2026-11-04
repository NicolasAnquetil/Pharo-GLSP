"
Sent by the server to tell the client whether the model has unsaved changes. `reason` is e.g. 'operation', 'undo', 'redo', 'save'.
"
Class {
	#name : 'GLSPSetDirtyStateAction',
	#superclass : 'GLSPAction',
	#instVars : [
		'isDirty',
		'reason'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'instance creation' }
GLSPSetDirtyStateAction class >> isDirty: aBoolean reason: aString [

	^ self new
		  isDirty: aBoolean;
		  reason: aString;
		  yourself
]

{ #category : 'accessing' }
GLSPSetDirtyStateAction class >> kind [

	^ 'setDirtyState'
]

{ #category : 'accessing' }
GLSPSetDirtyStateAction >> isDirty [

	^ isDirty
]

{ #category : 'accessing' }
GLSPSetDirtyStateAction >> isDirty: aBoolean [

	isDirty := aBoolean
]

{ #category : 'accessing' }
GLSPSetDirtyStateAction >> reason [

	^ reason
]

{ #category : 'accessing' }
GLSPSetDirtyStateAction >> reason: aString [

	reason := aString
]
