"
I am the undo/redo stack of a client session. I am dirty when the last executed command is not the one at the last save.
"
Class {
	#name : 'GLSPCommandStack',
	#superclass : 'Object',
	#instVars : [
		'undoStack',
		'redoStack',
		'savePoint'
	],
	#category : 'GLSP-Server-Commands',
	#package : 'GLSP-Server',
	#tag : 'Commands'
}

{ #category : 'executing' }
GLSPCommandStack >> canRedo [

	^ redoStack notEmpty
]

{ #category : 'executing' }
GLSPCommandStack >> canUndo [

	^ undoStack notEmpty
]

{ #category : 'executing' }
GLSPCommandStack >> execute: aCommand [

	aCommand execute.
	undoStack addLast: aCommand.
	redoStack removeAll
]

{ #category : 'executing' }
GLSPCommandStack >> flush [

	undoStack removeAll.
	redoStack removeAll.
	savePoint := nil
]

{ #category : 'executing' }
GLSPCommandStack >> initialize [

	super initialize.
	undoStack := OrderedCollection new.
	redoStack := OrderedCollection new
]

{ #category : 'executing' }
GLSPCommandStack >> isDirty [

	^ (undoStack ifEmpty: [ nil ] ifNotEmpty: [ undoStack last ]) ~~ savePoint
]

{ #category : 'executing' }
GLSPCommandStack >> redo [

	| command |
	command := redoStack removeLast.
	command redo.
	undoStack addLast: command
]

{ #category : 'executing' }
GLSPCommandStack >> saveIsDone [

	savePoint := undoStack ifEmpty: [ nil ] ifNotEmpty: [ undoStack last ]
]

{ #category : 'executing' }
GLSPCommandStack >> undo [

	| command |
	command := undoStack removeLast.
	command undo.
	redoStack addLast: command
]
