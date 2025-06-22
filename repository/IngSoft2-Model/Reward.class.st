Class {
	#name : 'Reward',
	#superclass : 'Object',
	#instVars : [
		'magnitude'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Reward class >> of: aMagnitude [

	^ self new initializeOf: aMagnitude
]

{ #category : 'operations' }
Reward >> applyTo: aShip [

	aShip addFuel: magnitude
]

{ #category : 'initialization' }
Reward >> initializeOf: aMagnitude [

	magnitude := aMagnitude
]
