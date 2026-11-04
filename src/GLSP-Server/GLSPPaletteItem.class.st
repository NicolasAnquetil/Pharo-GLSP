"
I am an entry of the tool palette: a group (with children) or a tool (with the actions triggered when it is selected, e.g. triggerNodeCreation).
"
Class {
	#name : 'GLSPPaletteItem',
	#superclass : 'GLSPProtocolObject',
	#instVars : [
		'id',
		'label',
		'sortString',
		'icon',
		'actions',
		'children'
	],
	#category : 'GLSP-Server-Protocol',
	#package : 'GLSP-Server',
	#tag : 'Protocol'
}

{ #category : 'accessing' }
GLSPPaletteItem >> actions [
	^ actions
]

{ #category : 'accessing' }
GLSPPaletteItem >> actions: anObject [
	actions := anObject
]

{ #category : 'accessing' }
GLSPPaletteItem >> children [
	^ children
]

{ #category : 'accessing' }
GLSPPaletteItem >> children: anObject [
	children := anObject
]

{ #category : 'accessing' }
GLSPPaletteItem >> icon [
	^ icon
]

{ #category : 'accessing' }
GLSPPaletteItem >> icon: anObject [
	icon := anObject
]

{ #category : 'accessing' }
GLSPPaletteItem >> id [
	^ id
]

{ #category : 'accessing' }
GLSPPaletteItem >> id: anObject [
	id := anObject
]

{ #category : 'accessing' }
GLSPPaletteItem >> label [
	^ label
]

{ #category : 'accessing' }
GLSPPaletteItem >> label: anObject [
	label := anObject
]

{ #category : 'accessing' }
GLSPPaletteItem >> sortString [
	^ sortString
]

{ #category : 'accessing' }
GLSPPaletteItem >> sortString: anObject [
	sortString := anObject
]
