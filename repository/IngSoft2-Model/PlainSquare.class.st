"
This class represents a plain square
"
Class {
	#name : 'PlainSquare',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
PlainSquare >> applyOn: aShip and: aPosition in: aGame [

	^ aPosition
]

{ #category : 'as yet unclassified' }
PlainSquare >> assigned: aCollection [

	^ true
]
