"
I build the GModel (the graphical model sent to the client) from the source model of a model state. Subclass me for a concrete diagram language.
"
Class {
	#name : 'GLSPGModelFactory',
	#superclass : 'Object',
	#category : 'GLSP-Server-Model',
	#package : 'GLSP-Server',
	#tag : 'Model'
}

{ #category : 'creation' }
GLSPGModelFactory >> createGModel: aModelState [
	"Answer a GLSPGModelRoot representing the source model of aModelState"

	^ self subclassResponsibility
]
