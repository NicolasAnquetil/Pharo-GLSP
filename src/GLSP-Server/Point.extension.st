Extension { #name : 'Point' }

{ #category : '*GLSP-Server' }
Point >> asGLSPDimensionJSON [

	^ Dictionary new
		  at: 'width' put: x;
		  at: 'height' put: y;
		  yourself
]

{ #category : '*GLSP-Server' }
Point >> asGLSPPointJSON [

	^ Dictionary new
		  at: 'x' put: x;
		  at: 'y' put: y;
		  yourself
]
