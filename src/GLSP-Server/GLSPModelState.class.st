"
I hold the state of the model of a client session: the options given by the client (sourceUri, diagramType...), the source model (the semantic model, whatever object the diagram language uses), the current GModel root and its revision, and whether there are unsaved changes.
"
Class {
	#name : 'GLSPModelState',
	#superclass : 'Object',
	#instVars : [
		'clientOptions',
		'sourceModel',
		'root',
		'revision'
	],
	#category : 'GLSP-Server-Model',
	#package : 'GLSP-Server',
	#tag : 'Model'
}

{ #category : 'accessing' }
GLSPModelState >> clientOptions [

	^ clientOptions
]

{ #category : 'accessing' }
GLSPModelState >> clientOptions: aDictionary [

	clientOptions := aDictionary ifNil: [ Dictionary new ]
]

{ #category : 'accessing' }
GLSPModelState >> initialize [
	super initialize.
	clientOptions := Dictionary new.
	revision := 0
]

{ #category : 'accessing' }
GLSPModelState >> revision [

	^ revision
]

{ #category : 'accessing' }
GLSPModelState >> root [

	^ root
]

{ #category : 'accessing' }
GLSPModelState >> root: aGModelRoot [
	"Install a new GModel: it gets the next revision"

	revision := revision + 1.
	root := aGModelRoot.
	root revision: revision
]

{ #category : 'accessing' }
GLSPModelState >> sourceModel [

	^ sourceModel
]

{ #category : 'accessing' }
GLSPModelState >> sourceModel: anObject [

	sourceModel := anObject
]

{ #category : 'accessing' }
GLSPModelState >> sourceUri [

	^ clientOptions at: 'sourceUri' ifAbsent: [ nil ]
]
