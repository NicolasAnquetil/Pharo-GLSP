"
I am the root of the GModel, the graphical model a GLSP server sends to its clients.

A GModel is a tree of elements. Each element has an `id` (unique in the tree), a `type` (used by the client to choose how to render it, e.g. 'node', 'node:task', 'edge'), `children`, optional `cssClasses` and optional `args` (free properties).

`asJRPCJSON` answers the JSON form defined by the GLSP protocol; subclasses add their own properties in `addPropertiesTo:`.
"
Class {
	#name : 'GLSPGModelElement',
	#superclass : 'Object',
	#instVars : [
		'id',
		'type',
		'children',
		'parent',
		'cssClasses',
		'args'
	],
	#category : 'GLSP-Server-GModel',
	#package : 'GLSP-Server',
	#tag : 'GModel'
}

{ #category : 'defaults' }
GLSPGModelElement class >> defaultType [

	^ self subclassResponsibility
]

{ #category : 'hierarchy' }
GLSPGModelElement >> add: anElement [

	children add: anElement.
	anElement parent: self.
	^ anElement
]

{ #category : 'hierarchy' }
GLSPGModelElement >> addAll: aCollection [

	aCollection do: [ :each | self add: each ].
	^ aCollection
]

{ #category : 'accessing' }
GLSPGModelElement >> addCssClass: aString [

	(self cssClasses includes: aString) ifFalse: [ self cssClasses add: aString ]
]

{ #category : 'serialization' }
GLSPGModelElement >> addPropertiesTo: aDictionary [
	"Hook for subclasses to add their own JSON properties"

	
]

{ #category : 'hierarchy' }
GLSPGModelElement >> allElementsDo: aBlock [

	aBlock value: self.
	children do: [ :each | each allElementsDo: aBlock ]
]

{ #category : 'accessing' }
GLSPGModelElement >> args [

	^ args ifNil: [ args := Dictionary new ]
]

{ #category : 'accessing' }
GLSPGModelElement >> argsAt: aKey put: aValue [

	^ self args at: aKey put: aValue
]

{ #category : 'serialization' }
GLSPGModelElement >> asJRPCJSON [

	| json |
	json := Dictionary new.
	json
		at: 'id' put: id;
		at: 'type' put: self type;
		at: 'children' put: (children collect: [ :each | each asJRPCJSON ] as: Array).
	(cssClasses isNil or: [ cssClasses isEmpty ]) ifFalse: [ json at: 'cssClasses' put: cssClasses asArray ].
	(args isNil or: [ args isEmpty ]) ifFalse: [ json at: 'args' put: args asJRPCJSON ].
	self addPropertiesTo: json.
	^ json
]

{ #category : 'accessing' }
GLSPGModelElement >> children [

	^ children
]

{ #category : 'accessing' }
GLSPGModelElement >> cssClasses [

	^ cssClasses ifNil: [ cssClasses := OrderedCollection new ]
]

{ #category : 'hierarchy' }
GLSPGModelElement >> elementAt: anId [
	"Answer the element of my subtree with the given id, or nil"

	self allElementsDo: [ :each | each id = anId ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : 'accessing' }
GLSPGModelElement >> id [

	^ id
]

{ #category : 'accessing' }
GLSPGModelElement >> id: aString [

	id := aString
]

{ #category : 'initialization' }
GLSPGModelElement >> initialize [

	super initialize.
	children := OrderedCollection new
]

{ #category : 'accessing' }
GLSPGModelElement >> parent [

	^ parent
]

{ #category : 'accessing' }
GLSPGModelElement >> parent: anElement [

	parent := anElement
]

{ #category : 'printing' }
GLSPGModelElement >> printOn: aStream [

	super printOn: aStream.
	aStream << '(' << self type asString << ' ' << id asString << ')'
]

{ #category : 'hierarchy' }
GLSPGModelElement >> remove: anElement [

	children remove: anElement.
	anElement parent: nil.
	^ anElement
]

{ #category : 'hierarchy' }
GLSPGModelElement >> root [

	^ parent ifNil: [ self ] ifNotNil: [ parent root ]
]

{ #category : 'accessing' }
GLSPGModelElement >> type [

	^ type ifNil: [ self class defaultType ]
]

{ #category : 'accessing' }
GLSPGModelElement >> type: aString [

	type := aString
]
