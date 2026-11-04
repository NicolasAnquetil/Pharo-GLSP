"
I am the source model storage of the test diagram: the source model is a list of node names, always #('a' 'b') when loaded.
"
Class {
	#name : 'GLSPTestSourceModelStorage',
	#superclass : 'GLSPSourceModelStorage',
	#instVars : [
		'savedUri'
	],
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'persistence' }
GLSPTestSourceModelStorage >> loadSourceModel: aModelState [

	aModelState sourceModel: #( 'a' 'b' ) asOrderedCollection
]

{ #category : 'persistence' }
GLSPTestSourceModelStorage >> saveSourceModel: aModelState to: anUri [
	savedUri := anUri
]

{ #category : 'accessing' }
GLSPTestSourceModelStorage >> savedUri [
	^ savedUri
]
