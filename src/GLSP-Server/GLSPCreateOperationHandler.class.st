"
I execute creation operations (createNode or createEdge) for some element types (#elementTypeIds). #label is the name of the creation tool shown in the tool palette.
"
Class {
	#name : 'GLSPCreateOperationHandler',
	#superclass : 'GLSPOperationHandler',
	#category : 'GLSP-Server-Handlers',
	#package : 'GLSP-Server',
	#tag : 'Handlers'
}

{ #category : 'handling' }
GLSPCreateOperationHandler >> elementTypeIds [
	"The types of the elements I create"

	^ self subclassResponsibility
]

{ #category : 'error handling' }
GLSPCreateOperationHandler >> handles: anOperation [

	^ (super handles: anOperation) and: [ self elementTypeIds includes: anOperation elementTypeId ]
]

{ #category : 'handling' }
GLSPCreateOperationHandler >> isNodeCreation [

	^ self operationKind = GLSPCreateNodeOperation kind
]

{ #category : 'handling' }
GLSPCreateOperationHandler >> label [
	"The name of my creation tool in the tool palette"

	^ self elementTypeIds first
]

{ #category : 'handling' }
GLSPCreateOperationHandler >> sourceElementTypeIds [
	"For edge creation: the types of the elements my edges may start from (nil: any)"

	^ nil
]

{ #category : 'handling' }
GLSPCreateOperationHandler >> targetElementTypeIds [
	"For edge creation: the types of the elements my edges may end at (nil: any)"

	^ nil
]

{ #category : 'handling' }
GLSPCreateOperationHandler >> triggerActionFor: anElementTypeId [
	"The action activating my creation tool on the client"

	^ self isNodeCreation
		  ifTrue: [ GLSPTriggerNodeCreationAction elementTypeId: anElementTypeId ]
		  ifFalse: [ GLSPTriggerEdgeCreationAction elementTypeId: anElementTypeId ]
]
