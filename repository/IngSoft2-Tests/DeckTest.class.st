Class {
	#name : 'DeckTest',
	#superclass : 'TestCase',
	#instVars : [
		'aState'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
DeckTest >> setUp [
	super setUp.

	aState := HasCardsState new.
]

{ #category : 'asserting' }
DeckTest >> should: anErrorBlock raise: anErrorClass withMessageText: anErrorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]

{ #category : 'tests' }
DeckTest >> testWhenADeckDoesNotHaveEnoughCardsToGiveTheInitialCardsToEachShipThenInvalid [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aLeakCard aLeakCardProbabilisticEvent aCancellationCard aCancellationCardProbabilisticEvent aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager |
	
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                  for: aCardSquare
		                                  with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := ProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aLeakCard
		                                    with: aProbabilityOfOne.
	aCancellationCard := CancellationCard new.
	aCancellationCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aCancellationCard
		                                    with: aProbabilityOfOne.
	aDeckDistributionManager add: aCancellationCardProbabilisticEvent.
	aDeckDistributionManager add: aLeakCardProbabilisticEvent.
	
	aDeckLength := 3.
	aDeckDistribution := aDeckDistributionManager generateFor: aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	
	self
		should: [ aGame := aGameBuilder build.]
		raise: Error
		withMessageText: 'The Deck does not have enough cards to start the game'
]

{ #category : 'tests' }
DeckTest >> testWhenADeckIsCreatedWithLessThanOneCardThenInvalid [

	| aLength aDeckDistribution aLeakCard aLeakCardProbabilisticEvent aProbabilityOfOne |
	
	aLength := 0.
	aProbabilityOfOne := 1.
	aDeckDistribution := ProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aLeakCard
		                                    with: aProbabilityOfOne.
	aDeckDistribution add: aLeakCardProbabilisticEvent.
		
	self
		should: [ Deck of: aLength distributedBy: aDeckDistribution with: aState]
		raise: Error
		withMessageText: 'A deck must have at least one card'
]

{ #category : 'tests' }
DeckTest >> testWhenALeakCardIsCancelledByACancellationCardThenBothGoToTheDiscardPile [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager expectedDiscardPile aCancelltaionCard aCancelltaionCardProbabilisticEvent aLeakCard aLeakCardProbabilisticEvent |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                               for: aLeakCard
		                               with: aProbabilityOfOne.
	aCancelltaionCard := CancellationCard new.
	aCancelltaionCardProbabilisticEvent := ProbabilisticEvent
		                                       for: aCancelltaionCard
		                                       with: aProbabilityOfOne.
	aDeckDistributionManager add: aCancelltaionCardProbabilisticEvent.
	aDeckDistributionManager add: aLeakCardProbabilisticEvent.

	aDeckLength := 10.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedDiscardPile := OrderedCollection new.
	expectedDiscardPile add: aLeakCard.
	expectedDiscardPile add: aCancelltaionCard.

	aGame
		play: aLeakCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame
		play: aCancelltaionCard
		by: aBlueShip
		affecting: aLeakCard
		and: aBlueShip.

	self assert: aGame discardPile equals: expectedDiscardPile
]

{ #category : 'tests' }
DeckTest >> testWhenALeakCardIsNoLongerActiveBecauseTheAffectedShipRanOutOfFuelThenItGoesToTheDiscardPile [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager expectedDiscardPile aLeakCard aLeakCardProbabilisticEvent |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                               for: aLeakCard
		                               with: aProbabilityOfOne.

	aDeckDistributionManager add: aLeakCardProbabilisticEvent.

	aDeckLength := 10.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedDiscardPile := OrderedCollection new.
	expectedDiscardPile add: aLeakCard.

	aGame
		play: aLeakCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.

	self assert: aGame discardPile equals: expectedDiscardPile
]

{ #category : 'tests' }
DeckTest >> testWhenANitroCardIsPlayedThenItGoesToTheDiscardPile [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager aNitroCard aNitroCardProbabilisticEvent expectedDiscardPile |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                for: aNitroCard
		                                with: aProbabilityOfOne.
	aDeckDistributionManager add: aNitroCardProbabilisticEvent.

	aDeckLength := 10.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution  with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedDiscardPile := OrderedCollection new.
	expectedDiscardPile add: aNitroCard.

	aGame play: aNitroCard by: aBlueShip affecting: aNullCard and: aBlackShip.

	self assert: aGame discardPile equals: expectedDiscardPile
]

{ #category : 'tests' }
DeckTest >> testWhenARedoCardIsPlayedThenItGoesToTheDiscardPile [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager aNitroCard aNitroCardProbabilisticEvent expectedDiscardPile aRedoCard aRedoCardProbabilisticEvent |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                for: aNitroCard
		                                with: aProbabilityOfOne.
	aRedoCard := RedoCard new.
	aRedoCardProbabilisticEvent := ProbabilisticEvent
		                                for: aRedoCard
		                                with: aProbabilityOfOne.
	aDeckDistributionManager add: aRedoCardProbabilisticEvent.
	aDeckDistributionManager add: aNitroCardProbabilisticEvent.

	aDeckLength := 10.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedDiscardPile := OrderedCollection new.
	expectedDiscardPile add: aNitroCard.
	expectedDiscardPile add: aRedoCard .

	aGame play: aNitroCard by: aBlueShip affecting: aNullCard and: aBlackShip.
	aGame play: aRedoCard by: aBlueShip affecting: aNullCard and: aBlackShip.

	self assert: aGame discardPile equals: expectedDiscardPile
]

{ #category : 'tests' }
DeckTest >> testWhenARepeatCardIsPlayedThenItGoesToTheDiscardPile [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager expectedDiscardPile aRepeatCard aRepeatCardProbabilisticEvent |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	aRepeatCard := RepeatCard new.
	aRepeatCardProbabilisticEvent := ProbabilisticEvent
		                                 for: aRepeatCard
		                                 with: aProbabilityOfOne.
	aDeckDistributionManager add: aRepeatCardProbabilisticEvent.

	aDeckLength := 10.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedDiscardPile := OrderedCollection new.
	expectedDiscardPile add: aRepeatCard.

	aGame nextTurnPlay.
	aGame
		play: aRepeatCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.

	self assert: aGame discardPile equals: expectedDiscardPile
]

{ #category : 'tests' }
DeckTest >> testWhenAShipLandsOnACardSquareThenItGetsACardFromTheDeck [

	| expectedDeckCards aDeck aDeckDistribution expectedShipCards aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aLeakCard aLeakCardProbabilisticEvent aCancellationCard aCancellationCardProbabilisticEvent aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager |
	
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                  for: aCardSquare
		                                  with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aLeakCard
		                                    with: aProbabilityOfOne.
	aCancellationCard := CancellationCard new.
	aCancellationCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aCancellationCard
		                                    with: aProbabilityOfOne.
	aDeckDistributionManager add: aCancellationCardProbabilisticEvent.
	aDeckDistributionManager add: aLeakCardProbabilisticEvent.
	
	aDeckLength := 10.
	aDeckDistribution := aDeckDistributionManager generateFor: aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.
	
	expectedDeckCards := OrderedCollection new.
	expectedDeckCards add: aLeakCard.
	expectedDeckCards add: aCancellationCard.
	expectedDeckCards add: aLeakCard.
	expectedDeckCards add: aCancellationCard.
	expectedDeckCards add: aLeakCard.
	
	expectedShipCards := OrderedCollection new.
	expectedShipCards add: aCancellationCard.
	expectedShipCards add: aLeakCard.
	expectedShipCards add: aCancellationCard.
	
	aGame nextTurnPlay.
	
	self assert: (aDeck availableCardsEquals: expectedDeckCards).
	self assert: (aBlueShip cards) equals: expectedShipCards
]

{ #category : 'tests' }
DeckTest >> testWhenAnAccelerationCardIsCancelledByACancellationCardThenBothGoToTheDiscardPile [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager expectedDiscardPile anAccelerationCard anAccelerationCardProbabilisticEvent aCancelltaionCard aCancelltaionCardProbabilisticEvent |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	anAccelerationCard := AccelerationCard new.
	anAccelerationCardProbabilisticEvent := ProbabilisticEvent
		                                        for: anAccelerationCard
		                                        with: aProbabilityOfOne.
	aCancelltaionCard := CancellationCard new.
	aCancelltaionCardProbabilisticEvent := ProbabilisticEvent
		                                       for: aCancelltaionCard
		                                       with: aProbabilityOfOne.
	aDeckDistributionManager add: aCancelltaionCardProbabilisticEvent.
	aDeckDistributionManager add: anAccelerationCardProbabilisticEvent.

	aDeckLength := 10.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedDiscardPile := OrderedCollection new.
	expectedDiscardPile add: anAccelerationCard.
	expectedDiscardPile add: aCancelltaionCard.

	aGame
		play: anAccelerationCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame
		play: aCancelltaionCard
		by: aBlueShip
		affecting: anAccelerationCard 
		and: aBlueShip.

	self assert: aGame discardPile equals: expectedDiscardPile
]

{ #category : 'tests' }
DeckTest >> testWhenAnAllyCardIsCancelledByACancellationCardThenBothGoToTheDiscardPile [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager expectedDiscardPile aCancelltaionCard aCancelltaionCardProbabilisticEvent anAllyCard anAllyCardProbabilisticEvent |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	anAllyCard := AllyCard new.
	anAllyCardProbabilisticEvent := ProbabilisticEvent
		                                for: anAllyCard
		                                with: aProbabilityOfOne.
	aCancelltaionCard := CancellationCard new.
	aCancelltaionCardProbabilisticEvent := ProbabilisticEvent
		                                       for: aCancelltaionCard
		                                       with: aProbabilityOfOne.
	aDeckDistributionManager add: aCancelltaionCardProbabilisticEvent.
	aDeckDistributionManager add: anAllyCardProbabilisticEvent.

	aDeckLength := 10.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedDiscardPile := OrderedCollection new.
	expectedDiscardPile add: anAllyCard.
	expectedDiscardPile add: aCancelltaionCard.

	aGame
		play: anAllyCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame
		play: aCancelltaionCard
		by: aBlueShip
		affecting: anAllyCard
		and: aBlueShip.

	self assert: aGame discardPile equals: expectedDiscardPile
]

{ #category : 'tests' }
DeckTest >> testWhenAnOverloadCardIsCancelledByACancellationCardThenBothGoToTheDiscardPile [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager expectedDiscardPile aCancelltaionCard aCancelltaionCardProbabilisticEvent anOverloadCard anOverloadCardProbabilisticEvent |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	anOverloadCard := OverloadCard new.
	anOverloadCardProbabilisticEvent := ProbabilisticEvent
		                                    for: anOverloadCard
		                                    with: aProbabilityOfOne.
	aCancelltaionCard := CancellationCard new.
	aCancelltaionCardProbabilisticEvent := ProbabilisticEvent
		                                       for: aCancelltaionCard
		                                       with: aProbabilityOfOne.
	aDeckDistributionManager add: aCancelltaionCardProbabilisticEvent.
	aDeckDistributionManager add: anOverloadCardProbabilisticEvent.

	aDeckLength := 10.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedDiscardPile := OrderedCollection new.
	expectedDiscardPile add: anOverloadCard.
	expectedDiscardPile add: aCancelltaionCard.

	aGame
		play: anOverloadCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame
		play: aCancelltaionCard
		by: aBlueShip
		affecting: anOverloadCard
		and: aBlueShip.

	self assert: aGame discardPile equals: expectedDiscardPile
]

{ #category : 'tests' }
DeckTest >> testWhenMultipleLeakCardsAreNoLongerActiveBecauseTheAffectedShipRanOutOfFuelThenTheyGoToTheDiscardPile [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager expectedDiscardPile aLeakCard aLeakCardProbabilisticEvent |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                               for: aLeakCard
		                               with: aProbabilityOfOne.

	aDeckDistributionManager add: aLeakCardProbabilisticEvent.

	aDeckLength := 10.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedDiscardPile := OrderedCollection new.
	expectedDiscardPile add: aLeakCard.
	expectedDiscardPile add: aLeakCard.

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

	self assert: aGame discardPile equals: expectedDiscardPile
]

{ #category : 'tests' }
DeckTest >> testWhenTheDeckAndTheDiscardPileAreEmptyAndAShipLandsOnACardSquareThenItGetsNothing [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager aNitroCard aNitroCardProbabilisticEvent expectedShipCards |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                for: aNitroCard
		                                with: aProbabilityOfOne.
	aDeckDistributionManager add: aNitroCardProbabilisticEvent.

	aDeckLength := 4.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck
		         of: aDeckLength
		         distributedBy: aDeckDistribution
		         with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedShipCards := OrderedCollection new.
	expectedShipCards add: aNitroCard.
	expectedShipCards add: aNitroCard.

	aGame nextTurnPlay.

	self assert: (aBlueShip cards) equals: expectedShipCards 
]

{ #category : 'tests' }
DeckTest >> testWhenTheDeckIsEmptiedThenTheDiscardPileIsShuffledAndTheDeckIsRefilled [

	| expectedDeckCards aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager aNitroCard aNitroCardProbabilisticEvent |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                for: aNitroCard
		                                with: aProbabilityOfOne.
	aDeckDistributionManager add: aNitroCardProbabilisticEvent.

	aDeckLength := 5.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedDeckCards := OrderedCollection new.
	expectedDeckCards add: aNitroCard.

	aGame
		play: aNitroCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame nextTurnPlay.

	self assert: (aGame deckAvailableCardsEquals: expectedDeckCards)
]

{ #category : 'tests' }
DeckTest >> testWhenTheDeckIsRefilledThenTheDiscardPileIsEmptied [

	| expectedDeckCards aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager aNitroCard aNitroCardProbabilisticEvent |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                for: aNitroCard
		                                with: aProbabilityOfOne.
	aDeckDistributionManager add: aNitroCardProbabilisticEvent.

	aDeckLength := 5.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedDeckCards := OrderedCollection new.

	aGame
		play: aNitroCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame nextTurnPlay.

	self assert: (aGame discardPileEquals: expectedDeckCards)
]

{ #category : 'tests' }
DeckTest >> testWhenTheDeckIsRefilledThenTheNextShipThatGetsACardsIsGivenTheCorrectCard [

	| aDeck aDeckDistribution aBlueShip aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aBoard sideToRoll someDices aLoadedDice aNullCard aGameBuilder aGame aCardSquare aCardSquareProbabilisticEvent aBoardDistribution aDeckLength aDeckDistributionManager aNitroCard aNitroCardProbabilisticEvent expectedShipCards |
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
	aCardSquare := CardSquare new.
	aCardSquareProbabilisticEvent := ProbabilisticEvent
		                                 for: aCardSquare
		                                 with: aProbabilityOfOne.
	aDistributionManager add: aCardSquareProbabilisticEvent.
	aBoardDistribution := aDistributionManager generateFor: fortySquares.
	aBoard := Board
		          with: fortySquares
		          and: aWormHole
		          distributedBy: aBoardDistribution.

	sideToRoll := #( 1 1 1 1 1 1 30) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aDeckDistributionManager := SetProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                for: aNitroCard
		                                with: aProbabilityOfOne.
	aDeckDistributionManager add: aNitroCardProbabilisticEvent.

	aDeckLength := 5.
	aDeckDistribution := aDeckDistributionManager generateFor:
		                     aDeckLength.
	aDeck := Deck
		         of: aDeckLength
		         distributedBy: aDeckDistribution
		         with: aState.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedShipCards := OrderedCollection new.
	expectedShipCards add: aNitroCard.
	expectedShipCards add: aNitroCard.
	expectedShipCards add: aNitroCard.

	aGame
		play: aNitroCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.

	self assert: aBlueShip cards equals: expectedShipCards
]
