"
This class represents a modifier
"
Class {
	#name : 'Modifier',
	#superclass : 'Object',
	#instVars : [
		'magnitude',
		'turnsLeft'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Modifier class >> of: aMAgnitude for: someTurns [

	^ self new initializeOf: aMAgnitude for: someTurns
]

{ #category : 'initialization' }
Modifier >> initializeOf: aMagnitude for: someTurns [ 
	
	magnitude := aMagnitude.
	turnsLeft := someTurns.
]

{ #category : 'performing' }
Modifier >> use [

	turnsLeft > 0 ifTrue: [
		turnsLeft := turnsLeft - 1.
		^ magnitude ].
	^ 0
]
