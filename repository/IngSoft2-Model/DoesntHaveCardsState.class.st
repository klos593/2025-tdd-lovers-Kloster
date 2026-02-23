"
This class represents a state
"
Class {
	#name : 'DoesntHaveCardsState',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'action' }
DoesntHaveCardsState >> deal: anAmountOfCards to: aShip from: availableCards [
	
	^ self
]

{ #category : 'action' }
DoesntHaveCardsState >> refillFrom: aDiscardPile having: someCards in: aGame [

	| shuffledPile |
	shuffledPile := aDiscardPile shuffle.
	aGame emptyDiscardPile.
	^ shuffledPile
]
