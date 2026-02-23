"
""This class represents a Game""
"
Class {
	#name : 'Game',
	#superclass : 'Object',
	#instVars : [
		'board',
		'ships',
		'dices',
		'finished',
		'winner',
		'laps',
		'rewards',
		'lastEffect',
		'lastPlayedCard',
		'activePermanentCards',
		'raceGoal',
		'deck',
		'discardPile'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'creation' }
Game class >> assignCardsTo: someShips from: aDeck [

	| finalUpdatedDeck |
	finalUpdatedDeck := someShips
		                    inject: aDeck
		                    into: [ :updatedDeck :aShip |
		                    updatedDeck deal: 2 to: aShip ].
	^ finalUpdatedDeck
]

{ #category : 'creation' }
Game class >> fuel: someShips with: aFuelQuantity [

	someShips do: [ :aShip | aShip fuel: aFuelQuantity ]
]

{ #category : 'validation' }
Game class >> hasDices: someDices [

	someDices size < 1 ifTrue: [
		Error signal: 'The Game needs at least one dice to start.' ]
]

{ #category : 'validation' }
Game class >> hasLaps: someLaps [

	someLaps < 1 ifTrue: [
		Error signal: 'The Game needs at least one lap to start.' ]
]

{ #category : 'validation' }
Game class >> hasShips: someShips [

	someShips size < 2 ifTrue: [
		Error signal: 'The Game needs at least two ship to start.' ]
]

{ #category : 'accessing' }
Game class >> maximumRoll: someDices [

	^ someDices sum: [ :aDice | aDice rollMaximum ]
]

{ #category : 'as yet unclassified' }
Game class >> validateEnoughCardsIn: aDeck for: someShips [

	(aDeck hasEnoughCardsFor: someShips size givingEach: 2) ifFalse: [
		Error signal:
			'The Deck does not have enough cards to start the game' ]
]

{ #category : 'validation' }
Game class >> validateSquaresFrom: aBoard with: someDices [

	aBoard validateSquaresWith: (self maximumRoll: someDices)
]

{ #category : 'creation' }
Game class >> with: aBoard for: someLaps and: someShips and: someDices and: aFuelQuantity and: aRewardManager and: aDeck [

	| anUpdatedDeck |
	self hasDices: someDices.
	self hasShips: someShips.
	self hasLaps: someLaps.
	self fuel: someShips with: aFuelQuantity.
	self validateEnoughCardsIn: aDeck for: someShips.
	anUpdatedDeck := self assignCardsTo: someShips from: aDeck.
	self validateSquaresFrom: aBoard with: someDices.
	^ self new
		  initializeWith: aBoard
		  for: someLaps
		  and: someShips
		  and: someDices
		  and: aRewardManager
			and: anUpdatedDeck
]

{ #category : 'accessing' }
Game >> addActiveCard: aCard [

	activePermanentCards add: aCard
]

{ #category : 'action' }
Game >> applyLastEffectTo: aShip [

	| shipInitialPosition shipPositionAfterEffect |
	shipInitialPosition := aShip currentPosition.

	shipPositionAfterEffect := lastEffect
		                           repeatEffectFor: aShip
		                           on: shipInitialPosition
		                           in: self.

	aShip performMovementFrom: shipInitialPosition to: shipPositionAfterEffect on: board in: self
]

{ #category : 'action' }
Game >> applyRewardTo: aShip for: aRolledNumber [

	aRolledNumber = self maximumRoll ifTrue: [
		rewards generateOne applyTo: aShip ]
]

{ #category : 'action' }
Game >> applyRollModifier: aPenalty [

	ships do: [ :aShip | aShip applyRollModifier: aPenalty ]
]

{ #category : 'action' }
Game >> calculateDistanceBetween: aPosition and: anotherPosition [

	^ board calculateDistanceBetween: aPosition and: anotherPosition
]

{ #category : 'validation' }
Game >> canStillPlay [

	finished ifTrue: [ Error signal: 'The game has finished.' ]
]

{ #category : 'action' }
Game >> deal: anAmountOfCards to: aShip [

	deck := deck deal: anAmountOfCards to: aShip.
	deck := deck refillFrom: discardPile in: self.
]

{ #category : 'validation' }
Game >> deckAvailableCardsEquals: someCards [

	^ deck availableCardsEquals: someCards.
]

{ #category : 'action' }
Game >> discard: someCards [ 
	
	someCards do: [ :aCard | discardPile add: aCard].
	deck := deck refillFrom: discardPile in: self
]

{ #category : 'accessing' }
Game >> discardPile [
	
	^ discardPile.
]

{ #category : 'action' }
Game >> discardPileEquals: someCards [ 
	
	^ someCards = discardPile.
]

{ #category : 'action' }
Game >> emptyDiscardPile [

	discardPile := OrderedCollection new.
]

{ #category : 'changing state' }
Game >> finish [

	finished := true
]

{ #category : 'action' }
Game >> goBackFourSquares: aShip from: aPosition [ 
	
	^ board goBackFourSquares: aShip from: aPosition 
]

{ #category : 'validation' }
Game >> hasFinished [

	^ finished
]

{ #category : 'initialization' }
Game >> initializeWith: aBoard for: someLaps and: someShips and: someDices and: aRewardManager and: aDeck [

	board := aBoard.
	ships := someShips.
	dices := someDices.
	laps := someLaps.
	finished := false.
	rewards := aRewardManager.
	deck := aDeck.
	lastEffect := PlainSquare new.
	winner := NullShip new.
	lastPlayedCard := NullCard new.
	raceGoal := Position at: 0 in: someLaps.
	activePermanentCards := OrderedCollection new.
	discardPile := OrderedCollection new.
]

{ #category : 'action' }
Game >> jump: squaresToJump from: aPosition [ 
	
	^ board jump: squaresToJump from: aPosition 
]

{ #category : 'accessing' }
Game >> lastEffect: anEffect [

	lastEffect := anEffect
]

{ #category : 'accessing' }
Game >> lastPlayedCard: aCard [

	lastPlayedCard := aCard
]

{ #category : 'accessing' }
Game >> maximumRoll [

	^ dices sum: [ :aDice | aDice rollMaximum ]
]

{ #category : 'action' }
Game >> move: aShip backwardsBy: aMagnitude [

	^ aShip moveBackwards: aMagnitude in: board in: self.
]

{ #category : 'action' }
Game >> move: aShip with: rolledNumber [

	self applyRewardTo: aShip for: rolledNumber.
	aShip playTurnWith: rolledNumber on: board in: self.
	aShip currentPosition > raceGoal ifFalse: [ ^ self ].
	self finish.
	winner := aShip
]

{ #category : 'action' }
Game >> moveShipsBackwards: aMagnitude [

	ships do: [ :aShip | aShip moveBackwards: aMagnitude in: board in: self ]
]

{ #category : 'action' }
Game >> moveShipsToSquareZero [
	
	ships do: [ :aShip | aShip moveTo: (aShip currentPosition adjustSquare: 0) ]
]

{ #category : 'action' }
Game >> nextTurnPass [

	| shipToMove |
	self canStillPlay.
	shipToMove := ships removeFirst.
	shipToMove restoreFuel.
	ships add: shipToMove.
]

{ #category : 'action' }
Game >> nextTurnPlay [

	| shipToMove rolledNumber |
	self canStillPlay.
	shipToMove := ships removeFirst.
	rolledNumber := self rollDices.
	self move: shipToMove with: rolledNumber.
	ships add: shipToMove
]

{ #category : 'action' }
Game >> play: aPlayedCard by: aPlayingShip affecting: anAffectedCard and: anAfectedShip [

	aPlayingShip validateCard: aPlayedCard.

	aPlayedCard
		bePlayedBy: aPlayingShip
		affecting: anAffectedCard
		and: anAfectedShip
		in: self
]

{ #category : 'action' }
Game >> playLastCardBy: aPlayingShip affecting: anAffectedCard and: aTargetShip [

	lastPlayedCard
		applyEffectPlayedBy: aPlayingShip
		affecting: anAffectedCard
		and: aTargetShip
		in: self.
]

{ #category : 'printing' }
Game >> printBoard [

	| positions results winnerShip sortedPositions |
	winnerShip := 'Winner: ' , winner name , String cr.
	sortedPositions := ships sorted: [ :aShip |
		                   board
			                   calculateDistanceBetween: (Position at: 0 in: 1)
			                   and: aShip currentPosition ] descending.
	positions := String cr join:
		             (sortedPositions collect: [ :aShip | aShip details ]).

	results := winnerShip , positions.
	^ results
]

{ #category : 'removing' }
Game >> remove: anAffectedCard playedBy: aShip [

	self validateIsActive: anAffectedCard.
	activePermanentCards remove: anAffectedCard.
	anAffectedCard cancelEffectIn: self.
	self discard: (anAffectedCard asOrderedCollection).
]

{ #category : 'action' }
Game >> rollDices [

	| rolledNumber |
	rolledNumber := dices sumNumbers: [ :aDice | aDice roll ].

	^ rolledNumber
]

{ #category : 'validation' }
Game >> validateIsActive: aCard [

	(activePermanentCards includes: aCard) ifFalse: [
		Error signal: 'The card is not active.' ]
]

{ #category : 'validation' }
Game >> validateNextPlayer: aShip [

	((ships at: 1) equals: aShip) ifFalse: [
		Error signal:
			'A permanent card cannot be played when it is not your turn.' ]
]
