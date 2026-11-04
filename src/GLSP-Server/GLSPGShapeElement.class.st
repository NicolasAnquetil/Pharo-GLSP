"
I am a GModel element with a bounds: a `position` (a Point, relative to my parent) and a `size` (a Point, width @ height). Both are serialized only when set.
"
Class {
	#name : 'GLSPGShapeElement',
	#superclass : 'GLSPGModelElement',
	#instVars : [
		'position',
		'size',
		'layout'
	],
	#category : 'GLSP-Server-GModel',
	#package : 'GLSP-Server',
	#tag : 'GModel'
}

{ #category : 'serialization' }
GLSPGShapeElement >> addPropertiesTo: aDictionary [

	position ifNotNil: [ aDictionary at: 'position' put: position asGLSPPointJSON ].
	size ifNotNil: [ aDictionary at: 'size' put: size asGLSPDimensionJSON ].
	layout ifNotNil: [ aDictionary at: 'layout' put: layout ]
]

{ #category : 'accessing' }
GLSPGShapeElement >> layout [

	^ layout
]

{ #category : 'accessing' }
GLSPGShapeElement >> layout: aString [
	"e.g. 'vbox', 'hbox', 'freeform'"

	layout := aString
]

{ #category : 'accessing' }
GLSPGShapeElement >> position [

	^ position
]

{ #category : 'accessing' }
GLSPGShapeElement >> position: aPoint [

	position := aPoint
]

{ #category : 'accessing' }
GLSPGShapeElement >> size [

	^ size
]

{ #category : 'accessing' }
GLSPGShapeElement >> size: aPoint [

	size := aPoint
]
