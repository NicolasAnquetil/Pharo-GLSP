"
I load the source model of a model state (from its sourceUri) and save it. Subclass me for a concrete diagram language.
"
Class {
	#name : 'GLSPSourceModelStorage',
	#superclass : 'Object',
	#category : 'GLSP-Server-Model',
	#package : 'GLSP-Server',
	#tag : 'Model'
}

{ #category : 'persistence' }
GLSPSourceModelStorage >> loadSourceModel: aModelState [
	"Set the source model of aModelState, read from its sourceUri"

	self subclassResponsibility
]

{ #category : 'persistence' }
GLSPSourceModelStorage >> saveSourceModel: aModelState to: anUri [
	"Write the source model of aModelState to anUri"

	self subclassResponsibility
]
