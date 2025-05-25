"
This class represent a player
"
Class {
	#name : 'Ship',
	#superclass : 'Object',
	#instVars : [
		'position',
		'name',
		'fuel'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'creation' }
Ship class >> called: aName [

	^ self new initializeCalled: aName
]

{ #category : 'update' }
Ship >> consumeFuel: squaresTraveled [
	
	self hasEnoughFuelToTravel: squaresTraveled.
	fuel := fuel - squaresTraveled
]

{ #category : 'accessing' }
Ship >> currentPosition [

	^ position
]

{ #category : 'accessing' }
Ship >> currentSquare [

	^ position currentSquare
]

{ #category : 'accessing' }
Ship >> details [

	^ name , ': ' , position asString
]

{ #category : 'accessing' }
Ship >> fuel: aFuelQuantity [

	fuel := aFuelQuantity
]

{ #category : 'accessing' }
Ship >> fuelLeft [

	^ fuel
]

{ #category : 'testing' }
Ship >> hasEnoughFuelToTravel: squaresToTravel [

	fuel < squaresToTravel ifTrue: [
		Error signal: 'Ship does not have enough fuel to move.' ]
]

{ #category : 'initialization' }
Ship >> initializeCalled: aName [

	name := aName.
	position := Position at: 0 in: 1.
	fuel := 0.
]

{ #category : 'update' }
Ship >> move: aRolledNumber [

	position := position addSquare: aRolledNumber
]

{ #category : 'update' }
Ship >> moveTo: aPosition [

	position := aPosition
]

{ #category : 'accessing' }
Ship >> name [
	^ name
]
