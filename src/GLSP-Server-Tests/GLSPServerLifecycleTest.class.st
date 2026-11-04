"
I test the JSON-RPC lifecycle of a GLSP server: initialize, initializeClientSession, disposeClientSession, shutdown. I talk to the server through handleJSON:, as a client would, and record what the server sends in a GLSPRecordingTransport.
"
Class {
	#name : 'GLSPServerLifecycleTest',
	#superclass : 'GLSPServerTestCase',
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'tests' }
GLSPServerLifecycleTest >> testDisposeClientSession [

	self initializeServer.
	self initializeSession: 's1'.
	self request: 'disposeClientSession' params: (Dictionary new
			 at: 'clientSessionId' put: 's1';
			 yourself).
	self assert: server sessions isEmpty
]

{ #category : 'tests' }
GLSPServerLifecycleTest >> testInitializeAnswersProtocolVersionAndServerActions [

	| result |
	result := self initializeServer at: 'result'.
	self assert: (result at: 'protocolVersion') equals: '1.0.0'.
	self assert: ((result at: 'serverActions') at: 'test-diagram') equals: GLSPTestDiagramModule new handledActionKinds asArray.
	self assert: server isInitialized
]

{ #category : 'tests' }
GLSPServerLifecycleTest >> testInitializeClientSessionCreatesASession [

	| response session |
	self initializeServer.
	response := self initializeSession: 's1'.
	self deny: (response includesKey: 'error').
	session := server sessionAt: 's1'.
	self assert: session id equals: 's1'.
	self assert: session diagramType equals: 'test-diagram'.
	self assert: session clientActionKinds asArray equals: #( 'setModel' 'updateModel' )
]

{ #category : 'tests' }
GLSPServerLifecycleTest >> testInitializeClientSessionTwiceIsAnError [

	self initializeServer.
	self initializeSession: 's1'.
	self assert: ((self initializeSession: 's1') includesKey: 'error')
]

{ #category : 'tests' }
GLSPServerLifecycleTest >> testInitializeClientSessionWithUnknownDiagramTypeIsAnError [

	| response |
	self initializeServer.
	response := self request: 'initializeClientSession' params: (Dictionary new
			             at: 'clientSessionId' put: 's1';
			             at: 'diagramType' put: 'unknown';
			             at: 'clientActionKinds' put: #(  );
			             yourself).
	self assert: (response includesKey: 'error').
	self assert: server sessions isEmpty
]

{ #category : 'tests' }
GLSPServerLifecycleTest >> testRequestBeforeInitializeIsAnError [

	| response |
	response := self initializeSession: 's1'.
	self assert: (response includesKey: 'error').
	self assert: server sessions isEmpty
]

{ #category : 'tests' }
GLSPServerLifecycleTest >> testRequestsAcceptAnArgsParameter [

	| response |
	response := self request: 'initialize' params: (Dictionary new
			             at: 'applicationId' put: 'test-app';
			             at: 'protocolVersion' put: '1.0.0';
			             at: 'args' put: Dictionary new;
			             yourself).
	self deny: (response includesKey: 'error')
]

{ #category : 'tests' }
GLSPServerLifecycleTest >> testShutdownDisposesAllSessions [

	self initializeServer.
	self initializeSession: 's1'.
	self initializeSession: 's2'.
	server handleJSON: '{"jsonrpc":"2.0","method":"shutdown"}'.
	self assert: server sessions isEmpty.
	self deny: server isInitialized
]
