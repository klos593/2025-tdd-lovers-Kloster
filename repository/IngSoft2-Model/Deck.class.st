"
This class represents a Deck
"
Class {
	#name : 'Deck',
	#superclass : 'Object',
	#instVars : [
		'availableCards',
		'length',
		'deckState'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'validation' }
Deck class >> lengthIsValid: aLength [

	aLength < 1 ifTrue: [ Error signal: 'A deck must have at least one card' ]
]

{ #category : 'as yet unclassified' }
Deck class >> of: aLength distributedBy: aDistribution with: aState [

	self lengthIsValid: aLength.
	^ self new initializeOf: aLength distributedBy: aDistribution with: aState.
]

{ #category : 'testing' }
Deck >> availableCardsEquals: someCards [ 
	
	^ availableCards = someCards. 
]

{ #category : 'action' }
Deck >> deal: anAmountOfCards to: aShip [ 
	
	| updatedState |
	updatedState := deckState deal: anAmountOfCards to: aShip from: availableCards.
	^ self class of: length distributedBy: availableCards with: updatedState.
]

{ #category : 'testing' }
Deck >> hasEnoughCardsFor: someShips givingEach: someCards [

	length < (someShips * someCards) ifTrue: [ ^ false ].
	^ true
]

{ #category : 'initialization' }
Deck >> initializeOf: aLength distributedBy: aDistribution with: aState [
	
	length := aLength.
	availableCards := aDistribution.
	deckState := aState
]

{ #category : 'action' }
Deck >> refillFrom: aDiscardPile in: aGame [

	| updatedAvailableCards updatedState |
	updatedAvailableCards := deckState refillFrom: aDiscardPile having: availableCards in: aGame.
	updatedState := HasCardsState new.
	^ self class of: length distributedBy: updatedAvailableCards with: updatedState.
]
