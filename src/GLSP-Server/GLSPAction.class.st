"
I am a GLSP action: the unit of communication between a GLSP client and server (sent inside an `GLSPActionMessage`).

Each concrete action class answers its `kind` on the class side; `GLSPAction class >> fromJSON:` instantiates the class matching the `kind` of a JSON object (or a `GLSPUnknownAction`).

By default my JSON properties are my instance variables: `fromJSON:` sets them from the JSON object and `asJRPCJSON` writes the non nil ones. Subclasses convert values that are not plain JSON (Points, GModel elements…) by overriding `fromJSON:`.
"
Class {
	#name : 'GLSPAction',
	#superclass : 'Object',
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'instance creation' }
GLSPAction class >> classForKind: aString [

	^ self allSubclasses
		  detect: [ :each | each kind = aString ]
		  ifNone: [ GLSPUnknownAction ]
]

{ #category : 'converting' }
GLSPAction class >> dimensionFromJSON: aDictionary [
	"{width, height} -> a Point (nil stays nil)"

	aDictionary ifNil: [ ^ nil ].
	^ (aDictionary at: 'width') @ (aDictionary at: 'height')
]

{ #category : 'instance creation' }
GLSPAction class >> fromJSON: aDictionary [

	^ (self classForKind: (aDictionary at: 'kind' ifAbsent: [ nil ])) new
		  fromJSON: aDictionary;
		  yourself
]

{ #category : 'accessing' }
GLSPAction class >> kind [
	"The kind of the action in the GLSP protocol. Abstract classes answer nil"

	^ nil
]

{ #category : 'converting' }
GLSPAction class >> pointFromJSON: aDictionary [
	"{x, y} -> a Point (nil stays nil)"

	aDictionary ifNil: [ ^ nil ].
	^ (aDictionary at: 'x') @ (aDictionary at: 'y')
]

{ #category : 'converting' }
GLSPAction class >> toJSON: anObject [
	"Convert anObject (a property value) to plain JSON objects"

	anObject isString ifTrue: [ ^ anObject ].
	anObject isDictionary ifTrue: [
			^ anObject associations inject: Dictionary new into: [ :dict :each |
					  dict at: each key put: (self toJSON: each value).
					  dict ] ].
	anObject isCollection ifTrue: [ ^ anObject collect: [ :each | self toJSON: each ] as: Array ].
	(anObject isKindOf: Point) ifTrue: [ ^ anObject asGLSPPointJSON ].
	^ anObject asJRPCJSON
]

{ #category : 'serialization' }
GLSPAction >> asJRPCJSON [

	| json |
	json := Dictionary new.
	json at: 'kind' put: self kind.
	self jsonPropertyNames do: [ :each |
		(self instVarNamed: each) ifNotNil: [ :value |
			json at: each put: (self class toJSON: value) ] ].
	^ json
]

{ #category : 'serialization' }
GLSPAction >> fromJSON: aDictionary [

	self jsonPropertyNames do: [ :each |
		aDictionary
			at: each
			ifPresent: [ :value | self instVarNamed: each put: value ] ]
]

{ #category : 'testing' }
GLSPAction >> isOperation [

	^ false
]

{ #category : 'testing' }
GLSPAction >> isRequest [

	^ false
]

{ #category : 'testing' }
GLSPAction >> isResponse [

	^ false
]

{ #category : 'testing' }
GLSPAction >> isResponseAction [
	"Whether I am an action that can answer a request (my class), whatever my responseId"

	^ false
]

{ #category : 'serialization' }
GLSPAction >> jsonPropertyNames [

	^ self class allInstVarNames
]

{ #category : 'accessing' }
GLSPAction >> kind [

	^ self class kind
]

{ #category : 'printing' }
GLSPAction >> printOn: aStream [

	super printOn: aStream.
	aStream << '(' << self kind asString << ')'
]
