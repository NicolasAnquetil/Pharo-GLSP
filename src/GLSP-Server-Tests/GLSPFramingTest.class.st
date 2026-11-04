"
I test the Content-Length framing of GLSPStreamTransport and the serving loop of a server on streams.
"
Class {
	#name : 'GLSPFramingTest',
	#superclass : 'TestCase',
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'tests' }
GLSPFramingTest >> frame: aString [

	^ ByteArray streamContents: [ :stream |
			  stream
				  nextPutAll: (GLSPStreamTransport new headerFor: aString utf8Encoded);
				  nextPutAll: aString utf8Encoded ]
]

{ #category : 'tests' }
GLSPFramingTest >> testReadFramedMessages [

	| bytes transport |
	bytes := ByteArray streamContents: [ :stream |
			         stream nextPutAll: (self frame: '{"id":1}').
			         stream nextPutAll: (String streamContents: [ :header |
						          header << 'Content-Length: 8' << String crlf << 'Content-Type: application/vscode-jsonrpc; charset=utf-8'
						          << String crlf << String crlf ]) asByteArray.
			         stream nextPutAll: '{"id":2}' asByteArray.
			         stream nextPutAll: (self frame: '{"t":"é"}') ].
	transport := GLSPStreamTransport in: (ReadStream on: bytes) out: nil.
	self assert: transport next equals: '{"id":1}'.
	self assert: transport next equals: '{"id":2}'.
	self assert: transport next equals: '{"t":"é"}'.
	self assert: transport next isNil
]

{ #category : 'tests' }
GLSPFramingTest >> testSendFramesWithTheByteLength [

	| out |
	out := WriteStream on: ByteArray new.
	(GLSPStreamTransport in: nil out: out) send: '{"a":"é"}'.
	self assert: out contents equals: (self frame: '{"a":"é"}').
	self assert: (out contents asString beginsWith: 'Content-Length: 10')
]

{ #category : 'tests' }
GLSPFramingTest >> testServeStreamsAnswersRequests [

	| in out server answers reader message |
	in := ReadStream on:
		      (self frame: '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"applicationId":"t","protocolVersion":"1.0.0"}}')
		      , (self frame: '{"jsonrpc":"2.0","method":"shutdown"}').
	out := WriteStream on: ByteArray new.
	server := GLSPServer new.
	server registerDiagramModule: GLSPTestDiagramModule new.
	server serveTransport: (GLSPStreamTransport in: in out: out).
	reader := GLSPStreamTransport in: (ReadStream on: out contents) out: nil.
	answers := OrderedCollection new.
	[ (message := reader next) isNil ] whileFalse: [ answers add: (STONJSON fromString: message) ].
	self assert: answers size equals: 1.
	self assert: ((answers first at: 'result') at: 'protocolVersion') equals: '1.0.0'
]
