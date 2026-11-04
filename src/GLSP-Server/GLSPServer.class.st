"
I am a GLSP (Graphical Language Server Protocol) server.

Like the Pharo Language Server (PLSAbstractServer) I am a JRPCServer whose JSON-RPC methods are declared with <jrpc: #method> pragmas:
- initialize: handshake, answers the protocol version and the action kinds the server handles per diagram type;
- initializeClientSession / disposeClientSession: lifecycle of a client session (one per open diagram);
- process: notification carrying an action message, dispatched to the client session;
- shutdown: notification, disposes every session.

Each diagram type is described by a GLSPDiagramModule registered with #registerDiagramModule:.
Messages to the client go through my transport (see GLSPTransport), the single output point (#sendMessage:).
"
Class {
	#name : 'GLSPServer',
	#superclass : 'JRPCServer',
	#instVars : [
		'transport',
		'diagramModules',
		'sessions',
		'initialized',
		'outputMutex',
		'clientApplicationId'
	],
	#category : 'GLSP-Server-Core',
	#package : 'GLSP-Server',
	#tag : 'Core'
}

{ #category : 'initialization' }
GLSPServer >> addHandlersFromPragmas [
	"Register the methods tagged with <jrpc: #methodName> of my class and of its superclasses up to GLSPServer (JRPC only looks at the class of the receiver)"

	(self class withAllSuperclasses copyUpTo: GLSPServer superclass) do: [ :aClass |
			(Pragma allNamed: #jrpc: in: aClass) do: [ :pragma |
					(self messageProcessor handlers anySatisfy: [ :each | each methodName = pragma arguments first ]) ifFalse: [
							self addHandler: (JRPCMessageSendHandler new
									 receiver: self;
									 methodName: pragma arguments first;
									 messageSelector: pragma methodSelector;
									 yourself) ] ] ]
]

{ #category : 'accessing' }
GLSPServer >> applicationId [

	^ clientApplicationId
]

{ #category : 'accessing' }
GLSPServer >> diagramModules [

	^ diagramModules
]

{ #category : 'glsp - lifecycle' }
GLSPServer >> disposeClientSession: clientSessionId args: args [

	<jrpc: #disposeClientSession>
	self ensureInitialized.
	(sessions removeKey: clientSessionId ifAbsent: [ nil ]) ifNotNil: [ :session | session dispose ].
	^ nil
]

{ #category : 'accessing' }
GLSPServer >> ensureInitialized [

	initialized ifFalse: [ GLSPServerError signal: 'The GLSP server is not initialized' ]
]

{ #category : 'serving' }
GLSPServer >> handleMessage: aJSONString [
	"Handle one incoming JSON-RPC message and write the response, if any"

	| answer |
	answer := self handleJSON: aJSONString.
	answer isEmptyOrNil ifFalse: [ self sendRaw: answer ]
]

{ #category : 'initialization' }
GLSPServer >> initialize [

	super initialize.
	diagramModules := Dictionary new.
	sessions := Dictionary new.
	initialized := false.
	outputMutex := Mutex new.
	transport := GLSPRecordingTransport new.
	self addHandlersFromPragmas
]

{ #category : 'glsp - lifecycle' }
GLSPServer >> initializeApplicationId: applicationId protocolVersion: protocolVersion args: args [
	"The first request of a client: the handshake.
	Note: JRPC maps the JSON params onto the argument names, they must be the names of the protocol"

	<jrpc: #initialize>
	clientApplicationId := applicationId.
	initialized := true.
	^ Dictionary new
		  at: 'protocolVersion' put: self protocolVersion;
		  at: 'serverActions' put: self serverActions;
		  yourself
]

{ #category : 'glsp - lifecycle' }
GLSPServer >> initializeClientSession: clientSessionId diagramType: diagramType clientActionKinds: clientActionKinds args: args [
	"Create the session of a diagram opened by the client"

	<jrpc: #initializeClientSession>
	| module |
	self ensureInitialized.
	(sessions includesKey: clientSessionId) ifTrue: [
		GLSPServerError signal: 'A client session already exists with id ' , clientSessionId printString ].
	module := diagramModules at: diagramType ifAbsent: [ GLSPServerError signal: 'Unknown diagram type: ' , diagramType printString ].
	sessions at: clientSessionId put: (module createClientSession: clientSessionId server: self clientActionKinds: clientActionKinds).
	^ nil
]

{ #category : 'accessing' }
GLSPServer >> isInitialized [

	^ initialized
]

{ #category : 'glsp - actions' }
GLSPServer >> process: clientId action: action [
	"Notification carrying an action message from the client"

	<jrpc: #process>
	sessions
		at: clientId
		ifPresent: [ :session | session process: (GLSPAction fromJSON: action) ]
		ifAbsent: [ "no such session: nothing to answer to a notification" ]
]

{ #category : 'accessing' }
GLSPServer >> protocolVersion [

	^ '1.0.0'
]

{ #category : 'accessing' }
GLSPServer >> registerDiagramModule: aDiagramModule [

	diagramModules at: aDiagramModule diagramType put: aDiagramModule.
	^ aDiagramModule
]

{ #category : 'glsp - actions' }
GLSPServer >> sendAction: anAction toClient: aClientId [

	self sendNotification: 'process' params: (GLSPActionMessage clientId: aClientId action: anAction)
]

{ #category : 'messaging' }
GLSPServer >> sendMessage: aJRPCObject [
	"Write one JSON-RPC message (response, notification or request) to the client"

	self sendRaw: (STONJSON toString: aJRPCObject asJRPCJSON)
]

{ #category : 'messaging' }
GLSPServer >> sendNotification: aMethodName params: params [

	self sendMessage: ((JRPCNotificationObject method: aMethodName)
			 params: params;
			 yourself)
]

{ #category : 'messaging' }
GLSPServer >> sendRaw: aJSONString [
	"Single output point: write one JSON-RPC message to the client, never interleaved with another one"

	outputMutex critical: [ transport send: aJSONString ]
]

{ #category : 'serving' }
GLSPServer >> serveTransport: aTransport [
	"Read and handle the messages of aTransport, one after the other (GLSP actions must keep their order), until its end"

	| message |
	transport := aTransport.
	[ (message := aTransport next) notNil ] whileTrue: [ self handleMessage: message ]
]

{ #category : 'accessing' }
GLSPServer >> serverActions [
	"For each diagram type, the action kinds the server handles"

	| result |
	result := Dictionary new.
	diagramModules keysAndValuesDo: [ :type :module | result at: type put: module handledActionKinds asArray ].
	^ result
]

{ #category : 'accessing' }
GLSPServer >> sessionAt: anId [

	^ sessions at: anId ifAbsent: [ GLSPServerError signal: 'Unknown client session: ' , anId printString ]
]

{ #category : 'accessing' }
GLSPServer >> sessions [

	^ sessions
]

{ #category : 'glsp - lifecycle' }
GLSPServer >> shutdown [
	"Notification: the client is going away"

	<jrpc: #shutdown>
	sessions do: [ :each | each dispose ].
	sessions removeAll.
	initialized := false
]

{ #category : 'accessing' }
GLSPServer >> transport [

	^ transport
]

{ #category : 'accessing' }
GLSPServer >> transport: aTransport [

	transport := aTransport
]
