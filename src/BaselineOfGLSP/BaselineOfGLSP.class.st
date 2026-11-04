"
I load the Pharo implementation of the Graphical Language Server Protocol (GLSP).

Metacello new
	baseline: 'GLSP';
	repository: 'github://NicolasAnquetil/Pharo-GLSP:main/src';
	load.

Groups: 'Core' (the server framework), 'Example' (the TaskList language), 'Tests', 'default' (everything).
"
Class {
	#name : 'BaselineOfGLSP',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGLSP',
	#package : 'BaselineOfGLSP'
}

{ #category : 'baselines' }
BaselineOfGLSP >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec baseline: 'JRPC' with: [
					spec
						repository: 'github://Evref-BL/JRPC:v4.0.1/src';
						loads: #( 'Server-Deployment' ) ].
			spec
				package: 'GLSP-Server' with: [ spec requires: #( 'JRPC' ) ];
				package: 'GLSP-Server-Tests' with: [ spec requires: #( 'GLSP-Server' ) ];
				package: 'GLSP-Example-TaskList' with: [ spec requires: #( 'GLSP-Server' ) ];
				package: 'GLSP-Example-TaskList-Tests' with: [ spec requires: #( 'GLSP-Example-TaskList' 'GLSP-Server-Tests' ) ].
			spec
				group: 'Core' with: #( 'GLSP-Server' );
				group: 'Example' with: #( 'GLSP-Example-TaskList' );
				group: 'Tests' with: #( 'GLSP-Server-Tests' 'GLSP-Example-TaskList-Tests' );
				group: 'default' with: #( 'Core' 'Example' 'Tests' ) ]
]
