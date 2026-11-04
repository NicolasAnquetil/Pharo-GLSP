"
I am a plain data object of the GLSP protocol (type hints, palette items...). My JSON form is made of my non nil instance variables.
"
Class {
	#name : 'GLSPProtocolObject',
	#superclass : 'Object',
	#category : 'GLSP-Server-Protocol',
	#package : 'GLSP-Server',
	#tag : 'Protocol'
}

{ #category : 'serialization' }
GLSPProtocolObject >> asJRPCJSON [

	| json |
	json := Dictionary new.
	self class allInstVarNames do: [ :each |
		(self instVarNamed: each) ifNotNil: [ :value | json at: each put: (GLSPAction toJSON: value) ] ].
	^ json
]
