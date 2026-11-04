"
I test the GLSP actions: parsing them from JSON according to their kind and serializing them back.
"
Class {
	#name : 'GLSPActionTest',
	#superclass : 'TestCase',
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'helpers' }
GLSPActionTest >> json: aString [

	^ STONJSON fromString: aString
]

{ #category : 'tests' }
GLSPActionTest >> testActionMessageFromJSON [

	| message |
	message := GLSPActionMessage fromJSON: (self json:
		            '{"clientId":"c1","action":{"kind":"requestModel","options":{"sourceUri":"file:///a.tasklist"},"requestId":"r1"}}').
	self assert: message clientId equals: 'c1'.
	self assert: message action class equals: GLSPRequestModelAction
]

{ #category : 'tests' }
GLSPActionTest >> testActionMessageToJSON [

	| json |
	json := (GLSPActionMessage
		         clientId: 'c1'
		         action: (GLSPSetDirtyStateAction new isDirty: true; reason: 'operation'; yourself))
		        asJRPCJSON.
	self assert: (json at: 'clientId') equals: 'c1'.
	self assert: ((json at: 'action') at: 'kind') equals: 'setDirtyState'.
	self assert: ((json at: 'action') at: 'isDirty') equals: true.
	self assert: ((json at: 'action') at: 'reason') equals: 'operation'
]

{ #category : 'tests' }
GLSPActionTest >> testNilPropertiesAreNotSerialized [

	| json |
	json := GLSPSetDirtyStateAction new isDirty: false; yourself.
	self deny: (json asJRPCJSON includesKey: 'reason')
]

{ #category : 'tests' }
GLSPActionTest >> testParseRequestModelAction [

	| action |
	action := GLSPAction fromJSON: (self json:
		           '{"kind":"requestModel","options":{"sourceUri":"file:///a.tasklist","diagramType":"tasklist-diagram"},"requestId":"r1"}').
	self assert: action class equals: GLSPRequestModelAction.
	self assert: action requestId equals: 'r1'.
	self assert: action sourceUri equals: 'file:///a.tasklist'.
	self assert: action isRequest
]

{ #category : 'tests' }
GLSPActionTest >> testParseUnknownActionKeepsItsJSON [

	| action |
	action := GLSPAction fromJSON: (self json: '{"kind":"somethingNew","foo":42}').
	self assert: action class equals: GLSPUnknownAction.
	self assert: action kind equals: 'somethingNew'.
	self assert: action asJRPCJSON equals: (self json: '{"kind":"somethingNew","foo":42}')
]

{ #category : 'tests' }
GLSPActionTest >> testResponseCarriesRequestId [

	| request response |
	request := GLSPAction fromJSON: (self json: '{"kind":"requestModel","options":{},"requestId":"r7"}').
	response := GLSPSetModelAction new newRoot: (GLSPGModelRoot new id: 'root'; yourself); yourself.
	response respondTo: request.
	self assert: (response asJRPCJSON at: 'responseId') equals: 'r7'.
	self assert: ((response asJRPCJSON at: 'newRoot') at: 'id') equals: 'root'.
	self assert: (response asJRPCJSON at: 'kind') equals: 'setModel'
]

{ #category : 'tests' }
GLSPActionTest >> testResponseToNonRequestHasEmptyResponseId [

	| response |
	response := GLSPSetModelAction new newRoot: (GLSPGModelRoot new id: 'root'; yourself); yourself.
	response respondTo: (GLSPAction fromJSON: (self json: '{"kind":"requestModel","options":{}}')).
	self assert: (response asJRPCJSON at: 'responseId' ifAbsent: [ '' ]) equals: ''
]
