"
I test a GLSP server end to end over a real TCP socket, as an external client would use it.
"
Class {
	#name : 'GLSPSocketTest',
	#superclass : 'TestCase',
	#instVars : [
		'launcher',
		'clients'
	],
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'running' }
GLSPSocketTest >> connect [
	"Answer a client transport connected to the launcher"

	| socket stream transport |
	socket := Socket newTCP.
	socket connectTo: (NetNameResolver addressForName: '127.0.0.1') port: launcher port.
	stream := SocketStream on: socket.
	stream
		binary;
		timeout: 5.
	transport := GLSPStreamTransport in: stream out: stream.
	clients add: transport.
	^ transport
]

{ #category : 'running' }
GLSPSocketTest >> receiveOn: aTransport [

	^ STONJSON fromString: aTransport next
]

{ #category : 'running' }
GLSPSocketTest >> send: aJSONString on: aTransport [

	aTransport send: aJSONString
]

{ #category : 'running' }
GLSPSocketTest >> setUp [

	super setUp.
	clients := OrderedCollection new.
	launcher := GLSPSocketLauncher serverFactory: [
			            GLSPServer new
				            registerDiagramModule: GLSPTestDiagramModule new;
				            yourself ].
	launcher startOnPort: 0
]

{ #category : 'running' }
GLSPSocketTest >> tearDown [

	clients do: [ :each | each close ].
	launcher stop.
	super tearDown
]

{ #category : 'tests' }
GLSPSocketTest >> testEachConnectionHasItsOwnServer [

	| first second |
	first := self connect.
	second := self connect.
	{
		first.
		second } do: [ :client |
			client send: '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"applicationId":"e2e","protocolVersion":"1.0.0"}}'.
			self receiveOn: client.
			client send:
				'{"jsonrpc":"2.0","id":2,"method":"initializeClientSession","params":{"clientSessionId":"s1","diagramType":"test-diagram","clientActionKinds":[]}}'.
			self deny: ((self receiveOn: client) includesKey: 'error') ].
	self assert: launcher connections size equals: 2
]

{ #category : 'tests' }
GLSPSocketTest >> testEndToEndOverTCP [

	| client answer notification |
	client := self connect.
	client send: '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"applicationId":"e2e","protocolVersion":"1.0.0"}}'.
	answer := self receiveOn: client.
	self assert: (answer at: 'id') equals: 1.
	self assert: ((answer at: 'result') at: 'protocolVersion') equals: '1.0.0'.
	client send:
		'{"jsonrpc":"2.0","id":2,"method":"initializeClientSession","params":{"clientSessionId":"s1","diagramType":"test-diagram","clientActionKinds":["setModel"]}}'.
	answer := self receiveOn: client.
	self assert: (answer at: 'id') equals: 2.
	self deny: (answer includesKey: 'error').
	client send:
		'{"jsonrpc":"2.0","method":"process","params":{"clientId":"s1","action":{"kind":"requestModel","options":{"sourceUri":"test://model"},"requestId":"r1"}}}'.
	notification := self receiveOn: client.
	self assert: (notification at: 'method') equals: 'process'.
	self assert: ((notification at: 'params') at: 'clientId') equals: 's1'.
	self assert: (((notification at: 'params') at: 'action') at: 'kind') equals: 'setModel'.
	self assert: (((notification at: 'params') at: 'action') at: 'responseId') equals: 'r1'
]

{ #category : 'tests' }
GLSPSocketTest >> testMalformedMessageAnswersAnError [

	| client answer |
	client := self connect.
	client send: '{not json'.
	answer := self receiveOn: client.
	self assert: (answer includesKey: 'error')
]

{ #category : 'tests' }
GLSPSocketTest >> testServerEndsWhenTheClientDisconnects [
	"Regression: a client closing its socket made the server process fail on ConnectionClosed (and open a debugger)"

	| client deadline |
	client := self connect.
	client send: '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"applicationId":"e2e","protocolVersion":"1.0.0"}}'.
	self receiveOn: client.
	self assert: launcher connections size equals: 1.
	client close.
	deadline := Time millisecondClockValue + 3000.
	[ launcher connections notEmpty and: [ Time millisecondClockValue < deadline ] ] whileTrue: [ (Delay forMilliseconds: 20) wait ].
	self assert: launcher connections isEmpty.
	self deny: (Process allInstances anySatisfy: [ :each |
			 each name notNil and: [ (each name beginsWith: 'GLSP connection') and: [ each isTerminated not ] ] ])
]

{ #category : 'tests' }
GLSPSocketTest >> testStopClosesTheListener [

	| port |
	port := launcher port.
	launcher stop.
	self deny: launcher isRunning.
	self
		should: [ Socket newTCP connectTo: (NetNameResolver addressForName: '127.0.0.1') port: port waitForConnectionFor: 1 ]
		raise: NetworkError
]
