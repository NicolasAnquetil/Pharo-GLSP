"
I set the text of the label labelId (direct label edition).
"
Class {
	#name : 'GLSPApplyLabelEditOperation',
	#superclass : 'GLSPOperation',
	#instVars : [
		'labelId',
		'text'
	],
	#category : 'GLSP-Server-Operations',
	#package : 'GLSP-Server',
	#tag : 'Operations'
}

{ #category : 'accessing' }
GLSPApplyLabelEditOperation class >> kind [
	^ 'applyLabelEdit'
]

{ #category : 'accessing' }
GLSPApplyLabelEditOperation >> labelId [
	^ labelId
]

{ #category : 'accessing' }
GLSPApplyLabelEditOperation >> labelId: anObject [
	labelId := anObject
]

{ #category : 'accessing' }
GLSPApplyLabelEditOperation >> text [
	^ text
]

{ #category : 'accessing' }
GLSPApplyLabelEditOperation >> text: anObject [
	text := anObject
]
