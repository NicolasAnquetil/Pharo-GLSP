"
I am an operation handler of the TaskList example: I apply my operation (see #operationKind) to the task list of the session.
"
Class {
	#name : 'GLSPTaskListApplyLabelEditHandler',
	#superclass : 'GLSPOperationHandler',
	#category : 'GLSP-Example-TaskList-Handlers',
	#package : 'GLSP-Example-TaskList',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPTaskListApplyLabelEditHandler >> execute: anApplyLabelEditOperation in: aClientSession [
	"The label is a child of the node of the task: find the task through the GModel"

	| label |
	label := aClientSession modelState root elementAt: anApplyLabelEditOperation labelId.
	label ifNil: [ ^ self ].
	(aClientSession modelState sourceModel taskAt: label parent id) ifNotNil: [ :task | task name: anApplyLabelEditOperation text ]
]

{ #category : 'handling' }
GLSPTaskListApplyLabelEditHandler >> operationKind [

	^ GLSPApplyLabelEditOperation kind
]
