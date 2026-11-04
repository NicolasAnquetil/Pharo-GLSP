"
I change the routing points of edges. newRoutingPoints is a list of {elementId, newRoutingPoints [{x,y}...]}.
"
Class {
	#name : 'GLSPChangeRoutingPointsOperation',
	#superclass : 'GLSPOperation',
	#instVars : [
		'newRoutingPoints'
	],
	#category : 'GLSP-Server-Operations',
	#package : 'GLSP-Server',
	#tag : 'Operations'
}

{ #category : 'accessing' }
GLSPChangeRoutingPointsOperation class >> kind [
	^ 'changeRoutingPoints'
]

{ #category : 'accessing' }
GLSPChangeRoutingPointsOperation >> newRoutingPoints [
	^ newRoutingPoints
]

{ #category : 'accessing' }
GLSPChangeRoutingPointsOperation >> newRoutingPoints: anObject [
	newRoutingPoints := anObject
]

{ #category : 'enumerating' }
GLSPChangeRoutingPointsOperation >> routingPointsDo: aBlock [
	"Evaluate aBlock with the edge id and its new routing points (a collection of Points)"

	newRoutingPoints do: [ :each |
			aBlock
				value: (each at: 'elementId')
				value: ((each at: 'newRoutingPoints' ifAbsent: [ #(  ) ]) collect: [ :point | self class pointFromJSON: point ]) ]
]
