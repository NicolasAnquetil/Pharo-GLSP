"
I test the GModel elements (the graphical model of GLSP) and their JSON form.
"
Class {
	#name : 'GLSPGModelTest',
	#superclass : 'TestCase',
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'tests' }
GLSPGModelTest >> testCssClassesOnlyWhenPresent [

	| node |
	node := GLSPGNode new id: 'n1'; yourself.
	self deny: (node asJRPCJSON includesKey: 'cssClasses').
	node addCssClass: 'task'.
	self assert: (node asJRPCJSON at: 'cssClasses') equals: #( 'task' )
]

{ #category : 'tests' }
GLSPGModelTest >> testLabelAsJSON [

	| json |
	json := (GLSPGLabel new id: 'l1'; text: 'Hello'; yourself) asJRPCJSON.
	self assert: (json at: 'type') equals: 'label'.
	self assert: (json at: 'text') equals: 'Hello'
]

{ #category : 'tests' }
GLSPGModelTest >> testNodeAsJSON [

	| json |
	json := (GLSPGNode new
		         id: 'n1';
		         position: 10 @ 20;
		         size: 100 @ 50;
		         yourself) asJRPCJSON.
	self assert: (json at: 'id') equals: 'n1'.
	self assert: (json at: 'type') equals: 'node'.
	self assert: (json at: 'position') equals: (Dictionary newFromPairs: #( 'x' 10 'y' 20 )).
	self assert: (json at: 'size') equals: (Dictionary newFromPairs: #( 'width' 100 'height' 50 )).
	self assert: (json at: 'children') equals: #(  )
]

{ #category : 'tests' }
GLSPGModelTest >> testParentAndLookupById [

	| root node label |
	root := GLSPGModelRoot new id: 'root'; yourself.
	node := GLSPGNode new id: 'n1'; yourself.
	label := GLSPGLabel new id: 'n1_label'; text: 'x'; yourself.
	node add: label.
	root add: node.
	self assert: label parent equals: node.
	self assert: label root equals: root.
	self assert: (root elementAt: 'n1_label') equals: label.
	self assert: (root elementAt: 'nope') isNil
]

{ #category : 'tests' }
GLSPGModelTest >> testRemoveChild [

	| root node |
	root := GLSPGModelRoot new id: 'root'; yourself.
	node := GLSPGNode new id: 'n1'; yourself.
	root add: node.
	root remove: node.
	self assert: root children isEmpty.
	self assert: node parent isNil
]

{ #category : 'tests' }
GLSPGModelTest >> testRootWithChildrenAsJSON [

	| root json |
	root := GLSPGModelRoot new
		        id: 'root';
		        revision: 3;
		        yourself.
	root add: (GLSPGNode new id: 'n1'; yourself).
	root add: (GLSPGEdge new
			 id: 'e1';
			 sourceId: 'n1';
			 targetId: 'n2';
			 yourself).
	json := root asJRPCJSON.
	self assert: (json at: 'type') equals: 'graph'.
	self assert: (json at: 'revision') equals: 3.
	self assert: (json at: 'children') size equals: 2.
	self assert: (((json at: 'children') at: 2) at: 'sourceId') equals: 'n1'.
	self assert: (((json at: 'children') at: 2) at: 'type') equals: 'edge'.
	self assert: (((json at: 'children') at: 2) at: 'routingPoints') equals: #(  )
]

{ #category : 'tests' }
GLSPGModelTest >> testTypeCanBeOverridden [

	self
		assert: ((GLSPGNode new type: 'node:task'; yourself) asJRPCJSON at: 'type')
		equals: 'node:task'
]
