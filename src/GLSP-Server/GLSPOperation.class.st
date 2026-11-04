"
I am an operation: an action modifying the model. In JSON, operations carry the discriminator isOperation: true. Operations are executed as commands on the command stack of the session (so they can be undone), by an operation handler.
"
Class {
	#name : 'GLSPOperation',
	#superclass : 'GLSPAction',
	#category : 'GLSP-Server-Operations',
	#package : 'GLSP-Server',
	#tag : 'Operations'
}

{ #category : 'serialization' }
GLSPOperation >> asJRPCJSON [

	^ super asJRPCJSON
		  at: 'isOperation' put: true;
		  yourself
]

{ #category : 'testing' }
GLSPOperation >> isOperation [

	^ true
]
