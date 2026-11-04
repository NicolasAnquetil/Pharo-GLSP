"
I am the abstract superclass of the tests talking to a GLSP server as a client would: through handleJSON:. What the server sends is recorded by a GLSPRecordingTransport.
"
Class {
	#name : 'GLSPServerTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'server',
		'transport',
		'nextId'
	],
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'testing' }
GLSPServerTestCase class >> isAbstract [
	^ self = GLSPServerTestCase
]

{ #category : 'helpers' }
GLSPServerTestCase >> diagramType [

	^ 'test-diagram'
]

{ #category : 'running' }
GLSPServerTestCase >> initializeServer [

	^ self request: 'initialize' params: (Dictionary new
			   at: 'applicationId' put: 'test-app';
			   at: 'protocolVersion' put: '1.0.0';
			   yourself)
]

{ #category : 'helpers' }
GLSPServerTestCase >> initializeSession: aSessionId [

	^ self request: 'initializeClientSession' params: (Dictionary new
			   at: 'clientSessionId' put: aSessionId;
			   at: 'diagramType' put: self diagramType;
			   at: 'clientActionKinds' put: #( 'setModel' 'updateModel' );
			   yourself)
]

{ #category : 'helpers' }
GLSPServerTestCase >> lastDirtyState [

	^ (transport actionsOfKind: 'setDirtyState') last
]

{ #category : 'helpers' }
GLSPServerTestCase >> openModel [

	self openSession.
	self requestModel.
	transport reset
]

{ #category : 'helpers' }
GLSPServerTestCase >> openSession [
	"Initialize the server and the session 's1', and forget what was sent so far"

	self initializeServer.
	self initializeSession: 's1'.
	transport reset.
	^ server sessionAt: 's1'
]

{ #category : 'helpers' }
GLSPServerTestCase >> process: anActionJSONString [

	^ self process: anActionJSONString clientId: 's1'
]

{ #category : 'helpers' }
GLSPServerTestCase >> process: anActionJSONString clientId: aClientId [
	"Send an action to the server through the 'process' notification"

	^ server handleJSON: (String streamContents: [ :stream |
			   stream << '{"jsonrpc":"2.0","method":"process","params":{"clientId":"' << aClientId << '","action":' << anActionJSONString
			   << '}}' ])
]

{ #category : 'running' }
GLSPServerTestCase >> request: aMethod params: aDictionary [
	"Send a JSON-RPC request to the server as a client would, and answer the decoded response"

	| request |
	nextId := nextId + 1.
	request := Dictionary new
		           at: 'jsonrpc' put: '2.0';
		           at: 'id' put: nextId;
		           at: 'method' put: aMethod;
		           yourself.
	aDictionary ifNotNil: [ request at: 'params' put: aDictionary ].
	^ STONJSON fromString: (server handleJSON: (STONJSON toString: request))
]

{ #category : 'helpers' }
GLSPServerTestCase >> requestModel [

	^ self process: (STONJSON toString: (Dictionary new
				    at: 'kind' put: 'requestModel';
				    at: 'requestId' put: 'r1';
				    at: 'options' put: (Dictionary new
						     at: 'sourceUri' put: self sourceUri;
						     at: 'diagramType' put: self diagramType;
						     yourself);
				    yourself))
]

{ #category : 'helpers' }
GLSPServerTestCase >> sentKinds [

	^ transport actions collect: [ :each | each kind ] as: Array
]

{ #category : 'helpers' }
GLSPServerTestCase >> session [
	^ server sessionAt: 's1'
]

{ #category : 'running' }
GLSPServerTestCase >> setUp [

	super setUp.
	nextId := 0.
	transport := GLSPRecordingTransport new.
	server := GLSPServer new.
	server transport: transport.
	server registerDiagramModule: GLSPTestDiagramModule new
]

{ #category : 'helpers' }
GLSPServerTestCase >> sourceUri [

	^ 'test://model'
]
