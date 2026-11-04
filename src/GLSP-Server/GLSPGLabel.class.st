"
I am a label: an element displaying a `text`. Labels are typically the targets of direct label edition.
"
Class {
	#name : 'GLSPGLabel',
	#superclass : 'GLSPGShapeElement',
	#instVars : [
		'text'
	],
	#category : 'GLSP-Server-GModel',
	#package : 'GLSP-Server',
	#tag : 'GModel'
}

{ #category : 'defaults' }
GLSPGLabel class >> defaultType [

	^ 'label'
]

{ #category : 'serialization' }
GLSPGLabel >> addPropertiesTo: aDictionary [

	super addPropertiesTo: aDictionary.
	aDictionary at: 'text' put: self text
]

{ #category : 'accessing' }
GLSPGLabel >> text [

	^ text ifNil: [ '' ]
]

{ #category : 'accessing' }
GLSPGLabel >> text: aString [

	text := aString
]
