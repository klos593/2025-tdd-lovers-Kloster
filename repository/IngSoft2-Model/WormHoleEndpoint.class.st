Class {
	#name : 'WormHoleEndpoint',
	#superclass : 'Object',
	#instVars : [
		'position'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
WormHoleEndpoint class >> at: aPosition [

	^ self new initializeAt: aPosition
]

{ #category : 'comparing' }
WormHoleEndpoint >> = aPosition [

	^ position = aPosition
]

{ #category : 'comparing' }
WormHoleEndpoint >> > aLength [

	^ position > aLength
]

{ #category : 'accessing' }
WormHoleEndpoint >> initializeAt: aPosition [

	position := aPosition
]

{ #category : 'validation' }
WormHoleEndpoint >> validateMagnitudeWith: aMaximumRoll and: aBoardLenght [

	^ true
]
