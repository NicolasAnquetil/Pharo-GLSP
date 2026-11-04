"
I am an undoable change of the model, executed through a GLSPCommandStack.
"
Class {
	#name : 'GLSPCommand',
	#superclass : 'Object',
	#category : 'GLSP-Server-Commands',
	#package : 'GLSP-Server',
	#tag : 'Commands'
}

{ #category : 'executing' }
GLSPCommand >> execute [

	self subclassResponsibility
]

{ #category : 'executing' }
GLSPCommand >> redo [

	self execute
]

{ #category : 'executing' }
GLSPCommand >> undo [

	self subclassResponsibility
]
