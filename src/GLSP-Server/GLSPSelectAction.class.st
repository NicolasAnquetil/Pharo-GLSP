"
The user selected and deselected elements (standard GLSP action elementSelected). The client sends it to the server when the server handles it (see its serverActions).
"
Class {
	#name : 'GLSPSelectAction',
	#superclass : 'GLSPAction',
	#instVars : [
		'selectedElementsIDs',
		'deselectedElementsIDs',
		'deselectAll'
	],
	#category : 'GLSP-Server-Actions',
	#package : 'GLSP-Server',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GLSPSelectAction class >> kind [

	^ 'elementSelected'
]

{ #category : 'accessing' }
GLSPSelectAction >> deselectAll [
	"Whether all the selected elements are first deselected"

	^ deselectAll ifNil: [ false ]
]

{ #category : 'accessing' }
GLSPSelectAction >> deselectAll: aBoolean [

	deselectAll := aBoolean
]

{ #category : 'accessing' }
GLSPSelectAction >> deselectedElementsIDs [
	"The ids of the elements to mark as not selected"

	^ deselectedElementsIDs ifNil: [ #(  ) ]
]

{ #category : 'accessing' }
GLSPSelectAction >> deselectedElementsIDs: aCollection [

	deselectedElementsIDs := aCollection
]

{ #category : 'accessing' }
GLSPSelectAction >> selectedElementsIDs [
	"The ids of the elements to mark as selected"

	^ selectedElementsIDs ifNil: [ #(  ) ]
]

{ #category : 'accessing' }
GLSPSelectAction >> selectedElementsIDs: aCollection [

	selectedElementsIDs := aCollection
]
