"
I launch GLSP servers on a TCP port (like the SocketServerLauncher of the Java GLSP server). Each accepted connection gets its own GLSPServer, created by my serverFactory (a block), served in its own process with the Content-Length framing.

	launcher := GLSPSocketLauncher serverFactory: [ GLSPServer new registerDiagramModule: GLSPTaskListDiagramModule new; yourself ].
	launcher startOnPort: 5007.
	...
	launcher stop
"
Class {
	#name : 'GLSPSocketLauncher',
	#superclass : 'Object',
	#instVars : [
		'serverFactory',
		'port',
		'listener',
		'acceptProcess',
		'connections',
		'running'
	],
	#category : 'GLSP-Server-Transport',
	#package : 'GLSP-Server',
	#tag : 'Transport'
}

{ #category : 'instance creation' }
GLSPSocketLauncher class >> serverFactory: aBlock [

	^ self new
		  serverFactory: aBlock;
		  yourself
]

{ #category : 'running' }
GLSPSocketLauncher >> acceptLoop [

	[ running ] whileTrue: [ (listener waitForAcceptFor: 1) ifNotNil: [ :socket | self serve: socket ] ]
]

{ #category : 'running' }
GLSPSocketLauncher >> connections [
	"The servers of the connected clients"

	^ connections
]

{ #category : 'initialization' }
GLSPSocketLauncher >> initialize [

	super initialize.
	connections := OrderedCollection new.
	running := false
]

{ #category : 'running' }
GLSPSocketLauncher >> isRunning [

	^ running
]

{ #category : 'running' }
GLSPSocketLauncher >> port [

	^ port
]

{ #category : 'running' }
GLSPSocketLauncher >> serve: aSocket [
	"Serve one client connection with a new server, in its own process"

	| stream server transport |
	stream := SocketStream on: aSocket.
	stream binary.
	transport := GLSPStreamTransport in: stream out: stream.
	transport waitForever: true.
	server := serverFactory value.
	connections add: server.
	[
		[ server serveTransport: transport ] ensure: [
				connections remove: server ifAbsent: [ ].
				server shutdown.
				transport close ] ] forkAt: Processor lowIOPriority named: 'GLSP connection ' , aSocket remoteAddress printString
]

{ #category : 'running' }
GLSPSocketLauncher >> serverFactory: aBlock [

	serverFactory := aBlock
]

{ #category : 'running' }
GLSPSocketLauncher >> startOnPort: aPortNumber [
	"Listen on aPortNumber (0: any free port, see #port afterwards)"

	listener := Socket newTCP.
	listener listenOn: aPortNumber backlogSize: 10.
	port := listener port.
	running := true.
	acceptProcess := [ self acceptLoop ] forkAt: Processor lowIOPriority named: 'GLSP accept loop on port ' , port printString
]

{ #category : 'running' }
GLSPSocketLauncher >> stop [

	running := false.
	acceptProcess ifNotNil: [ :process | process terminate ].
	listener ifNotNil: [ :socket | socket closeAndDestroy ].
	connections copy do: [ :each | each transport close ]
]
