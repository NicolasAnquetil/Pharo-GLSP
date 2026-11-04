"
I move and/or resize elements. newBounds is a list of {elementId, newPosition {x,y}, newSize {width,height}}; #elementBoundsDo: iterates on them with Points.
"
Class {
	#name : 'GLSPChangeBoundsOperation',
	#superclass : 'GLSPOperation',
	#instVars : [
		'newBounds'
	],
	#category : 'GLSP-Server-Operations',
	#package : 'GLSP-Server',
	#tag : 'Operations'
}

{ #category : 'accessing' }
GLSPChangeBoundsOperation class >> kind [
	^ 'changeBounds'
]

{ #category : 'enumerating' }
GLSPChangeBoundsOperation >> elementBoundsDo: aBlock [
	"Evaluate aBlock with the element id, its new position and its new size (Points, possibly nil)"

	newBounds do: [ :each |
			aBlock
				value: (each at: 'elementId')
				value: (self class pointFromJSON: (each at: 'newPosition' ifAbsent: [ nil ]))
				value: (self class dimensionFromJSON: (each at: 'newSize' ifAbsent: [ nil ])) ]
]

{ #category : 'accessing' }
GLSPChangeBoundsOperation >> newBounds [
	^ newBounds
]

{ #category : 'accessing' }
GLSPChangeBoundsOperation >> newBounds: anObject [
	newBounds := anObject
]
