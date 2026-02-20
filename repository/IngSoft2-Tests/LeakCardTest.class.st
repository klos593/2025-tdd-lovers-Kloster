Class {
	#name : 'LeakCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

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

	| aCardManager aProbabilityOfOne aGameBuilder someShips aRewardManager aBoard someDices aGame aBlueShip aNullCard aBlackShip zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aPlainSquare aPlainSquareProbabilisticEvent aDistribution sideToRoll aLoadedDice aLeakCard expectedCards aLeakCardProbabilisticEvent expectedFuel aCancellationCard aCancellationCardProbabilisticEvent |
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

	sideToRoll := #( 1 1 1) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aCardManager := SetProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aLeakCard
		                                    with: aProbabilityOfOne.
	aCancellationCard := CancellationCard new.
	aCancellationCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aCancellationCard
		                                    with: aProbabilityOfOne.
	aCardManager add: aCancellationCardProbabilisticEvent.
	aCardManager add: aLeakCardProbabilisticEvent.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
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

	| aCardManager aProbabilityOfOne aGameBuilder someShips aRewardManager aBoard someDices aGame aBlueShip aNullCard aBlackShip zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aPlainSquare aPlainSquareProbabilisticEvent aDistribution sideToRoll aLoadedDice aLeakCard expectedCards aLeakCardProbabilisticEvent expectedFuel |
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

	sideToRoll := #( 1 1 1) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aCardManager := ProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aLeakCard
		                                    with: aProbabilityOfOne.
	aCardManager add: aLeakCardProbabilisticEvent.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
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

	| aCardManager aProbabilityOfOne aGameBuilder someShips aRewardManager aBoard someDices aGame aBlueShip aNullCard aBlackShip zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aPlainSquare aPlainSquareProbabilisticEvent aDistribution sideToRoll aLoadedDice aLeakCard expectedCards aLeakCardProbabilisticEvent |
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

	sideToRoll := #( 1 1 1 1 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aCardManager := ProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aLeakCard
		                                    with: aProbabilityOfOne.
	aCardManager add: aLeakCardProbabilisticEvent.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
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

	| aCardManager aProbabilityOfOne aGameBuilder someShips aRewardManager aBoard someDices aGame aBlueShip aNullCard aBlackShip zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aPlainSquare aPlainSquareProbabilisticEvent aDistribution sideToRoll aLoadedDice aLeakCard expectedCards aLeakCardProbabilisticEvent expectedFuel |
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

	sideToRoll := #( 1 1 1 1 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aCardManager := ProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aLeakCard
		                                    with: aProbabilityOfOne.
	aCardManager add: aLeakCardProbabilisticEvent.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
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

	| aCardManager aProbabilityOfOne aGameBuilder someShips aRewardManager aBoard someDices aGame aBlueShip aNullCard aBlackShip zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aPlainSquare aPlainSquareProbabilisticEvent aDistribution sideToRoll aLoadedDice aLeakCard expectedCards aLeakCardProbabilisticEvent expectedFuel |
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

	sideToRoll := #( 1 1 2 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aCardManager := ProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                               for: aLeakCard
		                               with: aProbabilityOfOne.
	aCardManager add: aLeakCardProbabilisticEvent.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
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

	| aCardManager aProbabilityOfOne aGameBuilder someShips aRewardManager aBoard someDices aGame aBlueShip aNullCard aBlackShip zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aPlainSquare aPlainSquareProbabilisticEvent aDistribution sideToRoll aLoadedDice aLeakCard expectedCards aLeakCardProbabilisticEvent expectedFuel |
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

	sideToRoll := #( 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aCardManager := ProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                               for: aLeakCard
		                               with: aProbabilityOfOne.
	aCardManager add: aLeakCardProbabilisticEvent.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
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

	| anOverloadCard anOverloadCardProbabilisticEvent aCardManager aProbabilityOfOne aGameBuilder someShips aRewardManager aBoard someDices aGame aBlueShip aNullCard aBlackShip zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aPlainSquare aPlainSquareProbabilisticEvent aDistribution sideToRoll aLoadedDice aLeakCard |
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

	sideToRoll := #( 1 1 1 1 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aCardManager := ProbablisiticEventsManager new.
	anOverloadCard := OverloadCard new.
	anOverloadCardProbabilisticEvent := ProbabilisticEvent
		                                    for: anOverloadCard
		                                    with: aProbabilityOfOne.
	aCardManager add: anOverloadCardProbabilisticEvent.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
	aGame := aGameBuilder build.
	
	aLeakCard := LeakCard new.

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

	| aCardManager aProbabilityOfOne aGameBuilder someShips aRewardManager aBoard someDices aGame aBlueShip aNullCard aBlackShip zeroReward zeroRewardRewardProbabilisticEvent fortySquares aWormHole aDistributionManager aPlainSquare aPlainSquareProbabilisticEvent aDistribution sideToRoll aLoadedDice aLeakCard aLeakCardProbabilisticEvent |
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

	sideToRoll := #( 1 1 1 1 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aNullCard := NullCard new.

	aCardManager := ProbablisiticEventsManager new.
	aLeakCard := LeakCard new.
	aLeakCardProbabilisticEvent := ProbabilisticEvent
		                               for: aLeakCard
		                               with: aProbabilityOfOne.
	aCardManager add: aLeakCardProbabilisticEvent.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
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
