"
I am an in-memory transport recording the messages a server sends. Useful in tests and to embed a server in the image.
"
Class {
	#name : 'GLSPRecordingTransport',
	#superclass : 'GLSPTransport',
	#instVars : [
		'sent'
	],
	#category : 'GLSP-Server-Transport',
	#package : 'GLSP-Server',
	#tag : 'Transport'
}

{ #category : 'accessing' }
GLSPRecordingTransport >> actionMessages [
	"The action messages sent through the 'process' notification"

	^ (self notificationsNamed: 'process') collect: [ :each | GLSPActionMessage fromJSON: (each at: 'params') ]
]

{ #category : 'accessing' }
GLSPRecordingTransport >> actions [

	^ self actionMessages collect: [ :each | each action ]
]

{ #category : 'accessing' }
GLSPRecordingTransport >> actionsOfKind: aKind [

	^ self actions select: [ :each | each kind = aKind ]
]

{ #category : 'accessing' }
GLSPRecordingTransport >> initialize [

	super initialize.
	sent := OrderedCollection new
]

{ #category : 'accessing' }
GLSPRecordingTransport >> messages [
	"The sent messages, decoded as JSON"

	^ sent collect: [ :each | STONJSON fromString: each ]
]

{ #category : 'accessing' }
GLSPRecordingTransport >> notificationsNamed: aMethodName [

	^ self messages select: [ :each | (each at: 'method' ifAbsent: [ nil ]) = aMethodName ]
]

{ #category : 'accessing' }
GLSPRecordingTransport >> reset [

	sent removeAll
]

{ #category : 'accessing' }
GLSPRecordingTransport >> send: aJSONString [

	sent add: aJSONString
]

{ #category : 'accessing' }
GLSPRecordingTransport >> sent [

	^ sent
]
