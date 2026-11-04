"
I create a node for each name of the test source model.
"
Class {
	#name : 'GLSPTestGModelFactory',
	#superclass : 'GLSPGModelFactory',
	#category : 'GLSP-Server-Tests',
	#package : 'GLSP-Server-Tests'
}

{ #category : 'creation' }
GLSPTestGModelFactory >> createGModel: aModelState [

	| root |
	root := GLSPGModelRoot new
		        id: 'root';
		        yourself.
	aModelState sourceModel do: [ :name |
			root add: (GLSPGNode new
					 id: name;
					 position: 0 @ 0;
					 size: 10 @ 10;
					 yourself) ].
	^ root
]
