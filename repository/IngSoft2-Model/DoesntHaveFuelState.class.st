"
This class represents a state

"
Class {
	#name : 'DoesntHaveFuelState',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'borrowing' }
DoesntHaveFuelState >> amountOfFuelNeededBy: someFuel [

	^ someFuel amountNeeded
]

{ #category : 'penalty' }
DoesntHaveFuelState >> applyPenaltyTo: aShip thatStartedFrom: aPosition in: aGame [

	aShip penalizeAndReturnTo: aPosition.
	aShip removeLeakCardsIn: aGame
]

{ #category : 'borrowing' }
DoesntHaveFuelState >> borrowBy: aShip [

	aShip borrowFuelFromAllies
]
