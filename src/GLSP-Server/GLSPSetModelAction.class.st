"
Sent by the server to give the client a complete new model (`newRoot`), answering a `GLSPRequestModelAction`.
"
Class {
	#name : 'GLSPSetModelAction',
	#superclass : 'GLSPResponseAction',
	#instVars : [
		'newRoot'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPSetModelAction class >> kind [

	^ 'setModel'
]

{ #category : 'instance creation' }
GLSPSetModelAction class >> newRoot: aGModelRoot [

	^ self new
		  newRoot: aGModelRoot;
		  yourself
]

{ #category : 'accessing' }
GLSPSetModelAction >> newRoot [

	^ newRoot
]

{ #category : 'accessing' }
GLSPSetModelAction >> newRoot: aGModelRoot [

	newRoot := aGModelRoot
]
