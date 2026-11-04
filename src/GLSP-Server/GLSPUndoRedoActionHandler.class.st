"
I handle glspUndo and glspRedo with the command stack of the session.
"
Class {
	#name : 'GLSPUndoRedoActionHandler',
	#superclass : 'GLSPActionHandler',
	#category : 'GLSP-Server-Handlers',
	#package : 'GLSP-Server',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPUndoRedoActionHandler >> execute: anAction in: aClientSession [

	| stack |
	stack := aClientSession commandStack.
	anAction kind = GLSPUndoAction kind
		ifTrue: [
				stack canUndo ifFalse: [ ^ #(  ) ].
				stack undo.
				^ aClientSession submitModel: 'undo' ]
		ifFalse: [
				stack canRedo ifFalse: [ ^ #(  ) ].
				stack redo.
				^ aClientSession submitModel: 'redo' ]
]

{ #category : 'handling' }
GLSPUndoRedoActionHandler >> handledActionKinds [

	^ {
		  GLSPUndoAction kind.
		  GLSPRedoAction kind }
]
