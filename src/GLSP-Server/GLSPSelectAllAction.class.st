"
The user selected (select: true) or deselected (false) all the elements (standard GLSP action allSelected, e.g. Ctrl/Cmd+A). The client sends it to the server when the server handles it (see its serverActions).
"
Class {
	#name : 'GLSPSelectAllAction',
	#superclass : 'GLSPAction',
	#instVars : [
		'select'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPSelectAllAction class >> kind [

	^ 'allSelected'
]

{ #category : 'accessing' }
GLSPSelectAllAction >> select [
	"true: select all the elements, false: deselect them all"

	^ select ifNil: [ true ]
]

{ #category : 'accessing' }
GLSPSelectAllAction >> select: aBoolean [

	select := aBoolean
]
