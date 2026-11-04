"
I am a transport over binary streams (socket, stdio...) using the framing of vscode-jsonrpc (the one of LSP): each message is preceded by a 'Content-Length: <bytes>' header and an empty line. #next reads one incoming message (nil at end of stream), #send: writes one.
"
Class {
	#name : 'GLSPStreamTransport',
	#superclass : 'GLSPTransport',
	#instVars : [
		'inStream',
		'outStream',
		'waitForever'
	],
	#category : 'GLSP-Server-Transport',
	#package : 'GLSP-Server',
	#tag : 'Transport'
}

{ #category : 'instance creation' }
GLSPStreamTransport class >> in: aReadStream out: aWriteStream [

	^ self new
		  setIn: aReadStream out: aWriteStream;
		  yourself
]

{ #category : 'transport' }
GLSPStreamTransport >> close [

	inStream ifNotNil: [ :stream |
			[ stream close ]
				on: Error
				do: [ :e | e return: nil ] ].
	outStream ifNotNil: [ :stream |
			[ stream close ]
				on: Error
				do: [ :e | e return: nil ] ]
]

{ #category : 'transport' }
GLSPStreamTransport >> next [
	"Read the next framed message and answer its content (a String), or nil at the end of the input"

	| line length |
	[
		line := self readHeaderLine.
		line ifNil: [ ^ nil ].
		line isEmpty ] whileFalse: [
		(line asLowercase beginsWith: 'content-length:') ifTrue: [ length := (line copyAfter: $:) trimBoth asInteger ] ].
	length ifNil: [ ^ self next "no header: skip the empty line" ].
	^ (self readBytes: length) utf8Decoded
]

{ #category : 'transport' }
GLSPStreamTransport >> nextByte [
	"Answer the next input byte, or nil at the end of the input (stream end or connection closed by the peer)"

	| byte |
	byte := [ inStream next ]
		        on: ConnectionTimedOut , ConnectionClosed
		        do: [ :e |
				        (e isKindOf: ConnectionClosed) ifTrue: [ e return: nil ].
				        waitForever == true
					        ifTrue: [ e retry ]
					        ifFalse: [ e pass ] ].
	byte ifNil: [ ^ nil ].
	^ byte isCharacter
		  ifTrue: [ byte asInteger ]
		  ifFalse: [ byte ]
]

{ #category : 'transport' }
GLSPStreamTransport >> readBytes: anInteger [

	| bytes |
	bytes := ByteArray new: anInteger.
	1 to: anInteger do: [ :index | bytes at: index put: (self nextByte ifNil: [ GLSPServerError signal: 'Truncated message' ]) ].
	^ bytes
]

{ #category : 'transport' }
GLSPStreamTransport >> readHeaderLine [
	"Answer the next header line without its CR LF, or nil at the end of the input"

	| line byte |
	line := WriteStream on: String new.
	[
		byte := self nextByte.
		byte ifNil: [ ^ line contents ifEmpty: [ nil ] ].
		byte = 10 ] whileFalse: [ byte = 13 ifFalse: [ line nextPut: (Character value: byte) ] ].
	^ line contents
]

{ #category : 'transport' }
GLSPStreamTransport >> send: aJSONString [

	| body |
	body := aJSONString utf8Encoded.
	outStream
		nextPutAll: ('Content-Length: ' , body size printString , String crlf , String crlf) asByteArray;
		nextPutAll: body;
		flush
]

{ #category : 'transport' }
GLSPStreamTransport >> setIn: aReadStream out: aWriteStream [

	inStream := aReadStream.
	outStream := aWriteStream
]

{ #category : 'transport' }
GLSPStreamTransport >> waitForever: aBoolean [
	"When true (server side), read timeouts are retried: a server waits for its client as long as needed"

	waitForever := aBoolean
]
