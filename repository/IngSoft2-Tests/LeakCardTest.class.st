Class {
	#name : 'LeakCardTest',
	#superclass : 'TestCase',
	#instVars : [
		'aBlueShip',
		'aBlackShip',
		'someShips',
		'aProbabilityOfOne',
		'aRewardManager',
		'zeroReward',
		'zeroRewardRewardProbabilisticEvent',
		'fortySquares',
		'aWormHole',
		'aDistributionManager',
		'aPlainSquare',
		'aPlainSquareProbabilisticEvent',
		'aDistribution',
		'aBoard',
		'aNullCard',
		'aLeakCard',
		'aLeakCardProbabilisticEvent',
		'aCancellationCard',
		'aCancellationCardProbabilisticEvent',
		'aGameBuilder',
		'aDeckLength',
		'anOverloadCard',
		'anOverloadCardProbabilisticEvent',
		'aState'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
LeakCardTest >> setUp [
	super setUp.

	aBlueShip := Ship called: 'BlueShip'.
	aBlackShip := Ship called: 'BlackShip'.
	someShips := OrderedCollection new.
	someShips add: aBlueShip.
	someShips add: aBlackShip.

	aProbabilityOfOne := 1.
	aRewardManager := ProbablisiticEventsManager new.
	zeroReward := FuelDecreaseReward of: 0.
	zeroRewardRewardProbabilisticEvent := ProbabilisticEvent
		                                      for: zeroReward
		                                      with: aProbabilityOfOne.
	aRewardManager add: zeroRewardRewardProbabilisticEvent.

	fortySquares := 40.
	aWormHole := WormHole between: 38 and: 39.
	aDistributionManager := ProbablisiticEventsManager new.
	aPlainSquare := PlainSquare new.
	aPlainSquareProbabilisticEvent := ProbabilisticEvent
		                                  for: aPlainSquare
		                                  with: aProbabilityOfOne.
	aDistributionManager add: aPlainSquareProbabilisticEvent.
	aDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aDistribution.
		
	aNullCard := NullCard new.
		
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                               for: aLeakCard
		                               with: aProbabilityOfOne.
	aCancellationCard := CancellationCard new.
	aCancellationCardProbabilisticEvent := ProbabilisticEvent
		                                       for: aCancellationCard
		                                       with: aProbabilityOfOne.
	anOverloadCard := OverloadCard new.
	anOverloadCardProbabilisticEvent := ProbabilisticEvent
		                                    for: anOverloadCard
		                                    with: aProbabilityOfOne.	
		
	aDeckLength := 10.
	aState := HasCardsState new.
		
	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
]

{ #category : 'asserting' }
LeakCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: anErrorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]

{ #category : 'tests' }
LeakCardTest >> testWhenAShipPlaysACancellationCardAffectingAnotherShipWithMultipleLeakCardsActiveThenOnlyTheRightCardIsCancelled [

	| aCardManager someDices aGame sideToRoll aLoadedDice expectedCards expectedFuel aDeckDistribution aDeck |
	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aCardManager := SetProbablisiticEventsManager new.
	aCardManager add: aCancellationCardProbabilisticEvent.
	aCardManager add: aLeakCardProbabilisticEvent.

	aDeckDistribution := aCardManager generateFor: aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState .

	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedCards := OrderedCollection new.
	expectedCards add: aLeakCard.

	expectedFuel := Fuel with: 0 upTo: 2 in: HasFuelState new.

	aGame
		play: aLeakCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame nextTurnPass.
	aGame
		play: aLeakCard
		by: aBlackShip
		affecting: aNullCard
		and: aBlackShip.
	aGame
		play: aCancellationCard
		by: aBlueShip
		affecting: aLeakCard
		and: aBlackShip.
	aGame nextTurnPlay.


	self assert: (aBlackShip fuelEquals: expectedFuel)
]

{ #category : 'tests' }
LeakCardTest >> testWhenAShipPlaysALeakCardAndTheAffectedShipRunsOutOfFuelThenTheCardIsNoLongerActive [

	| sideToRoll someDices aLoadedDice aCardManager aDeckDistribution aDeck aGame expectedCards expectedFuel |
	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.


	aCardManager := ProbablisiticEventsManager new.
	aCardManager add: aLeakCardProbabilisticEvent.
	aDeckDistribution := aCardManager generateFor: aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedCards := OrderedCollection new.
	expectedCards add: aLeakCard.

	expectedFuel := Fuel with: 1 upTo: 2 in: HasFuelState new.

	aGame
		play: aLeakCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.

	self assert: (aBlackShip fuelEquals: expectedFuel)
]

{ #category : 'tests' }
LeakCardTest >> testWhenAShipPlaysALeakCardThenItIsNotLongerInItsHand [

	| sideToRoll someDices aLoadedDice aCardManager aDeckDistribution aDeck aGame expectedCards |
	sideToRoll := #( 1 1 1 1 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aCardManager := ProbablisiticEventsManager new.
	aCardManager add: aLeakCardProbabilisticEvent.
	aDeckDistribution := aCardManager generateFor: aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedCards := OrderedCollection new.
	expectedCards add: aLeakCard.

	aGame
		play: aLeakCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.

	self assert: aBlueShip cards equals: expectedCards
]

{ #category : 'tests' }
LeakCardTest >> testWhenAShipPlaysALeakCardThenItsFuelConsuptionIsDoubled [

	| sideToRoll someDices aLoadedDice aCardManager aDeckDistribution aDeck aGame expectedCards expectedFuel |
	sideToRoll := #( 1 1 1 1 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.


	aCardManager := ProbablisiticEventsManager new.
	aCardManager add: aLeakCardProbabilisticEvent.
	aDeckDistribution := aCardManager generateFor: aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedCards := OrderedCollection new.
	expectedCards add: aLeakCard.

	expectedFuel := Fuel with: 58 upTo: 60 in: HasFuelState new.

	aGame
		play: aLeakCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame nextTurnPlay.
	aGame nextTurnPlay.

	self assert: (aBlackShip fuelEquals: expectedFuel)
]

{ #category : 'tests' }
LeakCardTest >> testWhenAShipPlaysMultipleLeakCardsAndTheAffectedShipRunsOutOfFuelThenTheCardsAreNoLongerActive [

	| sideToRoll someDices aLoadedDice aCardManager aDeckDistribution aDeck aGame expectedCards expectedFuel |
	sideToRoll := #( 1 1 2 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aCardManager := ProbablisiticEventsManager new.
	aCardManager add: aLeakCardProbabilisticEvent.
	aDeckDistribution := aCardManager generateFor: aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedCards := OrderedCollection new.
	expectedCards add: aLeakCard.

	expectedFuel := Fuel with: 3 upTo: 4 in: HasFuelState new.

	aGame
		play: aLeakCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame
		play: aLeakCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.

	self assert: (aBlackShip fuelEquals: expectedFuel)
]

{ #category : 'tests' }
LeakCardTest >> testWhenAShipPlaysMultipleLeakCardsThenAffectedShipFuelConsuptionIsIncrementedAccordingly [

	| sideToRoll someDices aLoadedDice aCardManager aDeckDistribution aDeck aGame expectedCards expectedFuel |
	sideToRoll := #( 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aCardManager := ProbablisiticEventsManager new.
	aCardManager add: aLeakCardProbabilisticEvent.
	aDeckDistribution := aCardManager generateFor: aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedCards := OrderedCollection new.
	expectedCards add: aLeakCard.

	expectedFuel := Fuel with: 56 upTo: 60 in: HasFuelState new.

	aGame
		play: aLeakCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame
		play: aLeakCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame nextTurnPass.
	aGame nextTurnPlay.

	self assert: (aBlackShip fuelEquals: expectedFuel)
]

{ #category : 'tests' }
LeakCardTest >> testWhenAShipTriesToPlayALeakCardThatIsNotInItsHandThenInvalid [

	| sideToRoll someDices aLoadedDice aCardManager aDeckDistribution aDeck aGame |
	sideToRoll := #( 1 1 1 1 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aCardManager := ProbablisiticEventsManager new.
	aCardManager add: anOverloadCardProbabilisticEvent.
	aDeckDistribution := aCardManager generateFor: aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.


	self
		should: [
			aGame
				play: aLeakCard
				by: aBlueShip
				affecting: aNullCard
				and: aBlackShip ]
		raise: Error
		withMessageText: 'The ship does not have that card on its hand.'
]

{ #category : 'tests' }
LeakCardTest >> testWhenAShipTriesToPlayALeakCardWhenItIsNotItsTurnThenInvalid [

	| sideToRoll someDices aLoadedDice aCardManager aDeckDistribution aDeck aGame |
	sideToRoll := #( 1 1 1 1 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aCardManager := ProbablisiticEventsManager new.
	aCardManager add: aLeakCardProbabilisticEvent.
	aDeckDistribution := aCardManager generateFor: aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	self
		should: [
			aGame
				play: aLeakCard
				by: aBlackShip
				affecting: aNullCard
				and: aBlackShip ]
		raise: Error
		withMessageText:
		'A permanent card cannot be played when it is not your turn.'
]
