"
I am a source model storage for source models kept in JSON files designated by file:// URIs. Subclasses convert between JSON and the source model with #sourceModelFromJSON: and #jsonFromSourceModel:.
"
Class {
	#name : 'GLSPFileSourceModelStorage',
	#superclass : 'GLSPSourceModelStorage',
	#category : 'GLSP-Server-Model',
	#package : 'GLSP-Server',
	#tag : 'Model'
}

{ #category : 'persistence' }
GLSPFileSourceModelStorage >> fileFor: anUri [

	anUri ifNil: [ GLSPServerError signal: 'No source uri given' ].
	^ (ZnUrl fromString: anUri) asFileReference
]

{ #category : 'persistence' }
GLSPFileSourceModelStorage >> jsonFromSourceModel: aSourceModel [

	^ self subclassResponsibility
]

{ #category : 'persistence' }
GLSPFileSourceModelStorage >> loadSourceModel: aModelState [

	| file |
	file := self fileFor: aModelState sourceUri.
	file exists ifFalse: [ GLSPServerError signal: 'No such file: ' , file fullName ].
	aModelState sourceModel: (self sourceModelFromJSON: (STONJSON fromString: file contents))
]

{ #category : 'persistence' }
GLSPFileSourceModelStorage >> saveSourceModel: aModelState to: anUri [

	| file |
	file := self fileFor: anUri.
	file ensureDelete.
	file writeStreamDo: [ :stream |
		stream nextPutAll: (STONJSON toStringPretty: (self jsonFromSourceModel: aModelState sourceModel)) ]
]

{ #category : 'persistence' }
GLSPFileSourceModelStorage >> sourceModelFromJSON: aJSONObject [

	^ self subclassResponsibility
]
