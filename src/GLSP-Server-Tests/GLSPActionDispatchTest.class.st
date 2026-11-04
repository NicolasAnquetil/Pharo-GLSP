"
I test the processing of action messages: dispatch to the action handlers of the session, response actions, and sending of the resulting actions to the client.
"
Class {
	#name : 'GLSPActionDispatchTest',
	#superclass : 'GLSPServerTestCase',
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'tests' }
GLSPActionDispatchTest >> testProcessForAnUnknownSessionSendsNothing [

	self openSession.
	self process: '{"kind":"requestModel","options":{},"requestId":"r1"}' clientId: 'nope'.
	self assert: transport sent isEmpty
]

{ #category : 'tests' }
GLSPActionDispatchTest >> testProcessIsANotification [

	self openSession.
	self assert: self requestModel isEmptyOrNil.
	self assert: (transport messages allSatisfy: [ :each | (each includesKey: 'id') not ])
]

{ #category : 'tests' }
GLSPActionDispatchTest >> testRequestModelAnswersSetModel [

	| setModels |
	self openSession.
	self requestModel.
	setModels := transport actionsOfKind: 'setModel'.
	self assert: setModels size equals: 1.
	self assert: setModels first responseId equals: 'r1'.
	self assert: ((setModels first newRoot at: 'children') collect: [ :each | each at: 'id' ]) asArray equals: #( 'a' 'b' ).
	self assert: transport actionMessages first clientId equals: 's1'
]

{ #category : 'tests' }
GLSPActionDispatchTest >> testRequestModelFillsTheModelState [

	| session |
	session := self openSession.
	self requestModel.
	self assert: session modelState sourceUri equals: 'test://model'.
	self assert: session modelState sourceModel asArray equals: #( 'a' 'b' ).
	self assert: session modelState root class equals: GLSPGModelRoot.
	self assert: (session modelState root elementAt: 'b') notNil
]

{ #category : 'tests' }
GLSPActionDispatchTest >> testServerActionsAnnounceRequestModel [

	| result |
	result := self initializeServer at: 'result'.
	self assert: (((result at: 'serverActions') at: 'test-diagram') includes: 'requestModel')
]

{ #category : 'tests' }
GLSPActionDispatchTest >> testUnhandledActionFromTheClientIsIgnored [

	self openSession.
	self process: '{"kind":"somethingUnknown"}'.
	self assert: transport sent isEmpty
]
