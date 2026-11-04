"
I execute a block changing the source model of a model state, and record snapshots of the source model before and after (like the JSON recording command of GLSP node). Undo and redo restore these snapshots, so operation handlers do not have to write undo code.
"
Class {
	#name : 'GLSPRecordingCommand',
	#superclass : 'GLSPCommand',
	#instVars : [
		'modelState',
		'block',
		'before',
		'after'
	],
	#category : 'GLSP-Server-Commands',
	#package : 'GLSP-Server',
	#tag : 'Commands'
}

{ #category : 'instance creation' }
GLSPRecordingCommand class >> modelState: aModelState block: aBlock [

	^ self new
		  setModelState: aModelState block: aBlock;
		  yourself
]

{ #category : 'executing' }
GLSPRecordingCommand >> execute [

	before := modelState sourceModel veryDeepCopy.
	block value.
	after := modelState sourceModel veryDeepCopy
]

{ #category : 'executing' }
GLSPRecordingCommand >> redo [

	modelState sourceModel: after veryDeepCopy
]

{ #category : 'executing' }
GLSPRecordingCommand >> setModelState: aModelState block: aBlock [

	modelState := aModelState.
	block := aBlock
]

{ #category : 'executing' }
GLSPRecordingCommand >> undo [

	modelState sourceModel: before veryDeepCopy
]
