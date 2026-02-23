"
This class represents a state
"
Class {
	#name : 'HasCardsState',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'action' }
HasCardsState >> deal: anAmountOfCards to: aShip from: availableCards [
	
	aShip addCards: (availableCards removeFirst: anAmountOfCards).
	^ self updateFor: availableCards size
]

{ #category : 'updating' }
HasCardsState >> refillFrom: aDiscardPile having: someCards in: aGame [

	^ someCards
]

{ #category : 'updating' }
HasCardsState >> updateFor: anAmountOfCards [

	anAmountOfCards < 1 ifTrue: [ ^ DoesntHaveCardsState new ]
]
