Class {
	#name : 'NitroCardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
NitroCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: anErrorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]

{ #category : 'tests' }
NitroCardTest >> testWhenAShipPlaysANitroCardAffectingItselfThenAfterThreeTurnsTheBonusIsNoLongerActive [

	| aBlueShip expectedPosition aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent twentySquares aWormHole aDistributionManager aPlainSquare aPlainSquareProbabilisticEvent aDistribution aBoard sideToRoll someDices aLoadedDice aCardManager aNitroCard aNitroCardProbabilisticEvent aNullCard aGameBuilder aGame |
	
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
	
	twentySquares := 20.
	aWormHole := WormHole between: 18 and: 19.
	aDistributionManager := ProbablisiticEventsManager new.
	aPlainSquare := PlainSquare new.
	aPlainSquareProbabilisticEvent := ProbabilisticEvent
		                                  for: aPlainSquare
		                                  with: aProbabilityOfOne.
	aDistributionManager add: aPlainSquareProbabilisticEvent.
	aDistribution := aDistributionManager generateFor: twentySquares.
	aBoard := Board
		          with: twentySquares
		          and: aWormHole
		          distributedBy: aDistribution.

	sideToRoll := #( 1 1 1 1 20 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.
	
	aCardManager := ProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aNitroCard 
		                                    with: aProbabilityOfOne.
	aCardManager add: aNitroCardProbabilisticEvent.

	aNullCard := NullCard new.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
	aGame := aGameBuilder build.
	
	aGame play: aNitroCard by: aBlueShip affecting: aNullCard and: aBlueShip.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	
	expectedPosition := Position at: 13 in: 1.
	
	self assert: (aBlueShip currentPositionEquals: expectedPosition)
]

{ #category : 'tests' }
NitroCardTest >> testWhenAShipPlaysANitroCardAffectingItselfThenItsrolledNumberIsIncreasedByThree [

	| aBlueShip expectedPosition aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent twentySquares aWormHole aDistributionManager aPlainSquare aPlainSquareProbabilisticEvent aDistribution aBoard sideToRoll someDices aLoadedDice aCardManager aNitroCard aNitroCardProbabilisticEvent aNullCard aGameBuilder aGame |
	
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
	
	twentySquares := 20.
	aWormHole := WormHole between: 18 and: 19.
	aDistributionManager := ProbablisiticEventsManager new.
	aPlainSquare := PlainSquare new.
	aPlainSquareProbabilisticEvent := ProbabilisticEvent
		                                  for: aPlainSquare
		                                  with: aProbabilityOfOne.
	aDistributionManager add: aPlainSquareProbabilisticEvent.
	aDistribution := aDistributionManager generateFor: twentySquares.
	aBoard := Board
		          with: twentySquares
		          and: aWormHole
		          distributedBy: aDistribution.

	sideToRoll := #( 1 5 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.
	
	aCardManager := ProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aNitroCard 
		                                    with: aProbabilityOfOne.
	aCardManager add: aNitroCardProbabilisticEvent.

	aNullCard := NullCard new.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
	aGame := aGameBuilder build.
	
	aGame play: aNitroCard by: aBlueShip affecting: aNullCard and: aBlueShip.
	aGame nextTurnPlay.
	
	expectedPosition := Position at: 4 in: 1.
	
	self assert: (aBlueShip currentPositionEquals: expectedPosition)
]

{ #category : 'tests' }
NitroCardTest >> testWhenAShipPlaysANitroCardAndAfterOneTurnPlaysAnotherOneBothAffectingItselfThenTheRolledNumberIsIncreasedCorrectlyAndEachCardLastsThreeTurns [

	| aBlueShip expectedPosition aBlackShip someShips aProbabilityOfOne aRewardManager zeroReward zeroRewardRewardProbabilisticEvent twentySquares aWormHole aDistributionManager aPlainSquare aPlainSquareProbabilisticEvent aDistribution aBoard sideToRoll someDices aLoadedDice aCardManager aNitroCard aNitroCardProbabilisticEvent aNullCard aGameBuilder aGame |
	
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
	
	twentySquares := 40.
	aWormHole := WormHole between: 38 and: 39.
	aDistributionManager := ProbablisiticEventsManager new.
	aPlainSquare := PlainSquare new.
	aPlainSquareProbabilisticEvent := ProbabilisticEvent
		                                  for: aPlainSquare
		                                  with: aProbabilityOfOne.
	aDistributionManager add: aPlainSquareProbabilisticEvent.
	aDistribution := aDistributionManager generateFor: twentySquares.
	aBoard := Board
		          with: twentySquares
		          and: aWormHole
		          distributedBy: aDistribution.

	sideToRoll := #( 1 1 1 1 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.
	
	aCardManager := ProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                    for: aNitroCard 
		                                    with: aProbabilityOfOne.
	aCardManager add: aNitroCardProbabilisticEvent.

	aNullCard := NullCard new.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
	aGame := aGameBuilder build.
	
	aGame play: aNitroCard by: aBlueShip affecting: aNullCard and: aBlueShip.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame play: aNitroCard by: aBlueShip affecting: aNullCard and: aBlueShip.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame nextTurnPlay.
	
	expectedPosition := Position at: 23 in: 1.
	
	self assert: (aBlueShip currentPositionEquals: expectedPosition)
]

{ #category : 'tests' }
NitroCardTest >> testWhenAShipsPlaysANitroCardThatIsNotInItsHandThenInvalid [
| aGame sideToRoll aLoadedDice aBoard someDices aDistribution twentySquares aWormHole aBlueShip aBlackShip aDistributionManager aPlainSquare aProbabilityOfOne aPlainSquareProbabilisticEvent aRewardManager zeroReward zeroRewardRewardProbabilisticEvent aCardManager someShips aGameBuilder aNullCard aNitroCard anOverloadCard anOverloadCardProbabilisticEvent |

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
	
	twentySquares := 20.
	aWormHole := WormHole between: 18 and: 19.
	aDistributionManager := ProbablisiticEventsManager new.
	aPlainSquare := PlainSquare new.
	aPlainSquareProbabilisticEvent := ProbabilisticEvent
		                                  for: aPlainSquare
		                                  with: aProbabilityOfOne.
	aDistributionManager add: aPlainSquareProbabilisticEvent.
	aDistribution := aDistributionManager generateFor: twentySquares.
	aBoard := Board
		          with: twentySquares
		          and: aWormHole
		          distributedBy: aDistribution.

	sideToRoll := #( 10 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.
	
	aCardManager := ProbablisiticEventsManager new.
	anOverloadCard := OverloadCard new.
	anOverloadCardProbabilisticEvent := ProbabilisticEvent
		                                    for: anOverloadCard 
		                                    with: aProbabilityOfOne.
	aCardManager add: anOverloadCardProbabilisticEvent.


	aNitroCard := NitroCard new.
	aNullCard := NullCard new.

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
				play: aNitroCard
				by: aBlueShip
				affecting: aNullCard
				and: aBlackShip ]
		raise: Error
		withMessageText: 'The ship does not have that card on its hand.'
]

{ #category : 'tests' }
NitroCardTest >> testWhenAShipsPlaysANitroCardThenItsNoLongerInItsHand [

	| aGame sideToRoll aLoadedDice aBoard someDices aDistribution expectedCards anAccelerationCard anAccelerationCardProbabilisticEvent aSetCardManager twentySquares aWormHole aBlueShip aBlackShip aDistributionManager aPlainSquare aProbabilityOfOne aPlainSquareProbabilisticEvent aRewardManager zeroReward zeroRewardRewardProbabilisticEvent someShips aGameBuilder aNullCard aNitroCard aNitroCardProbabilisticEvent |
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

	twentySquares := 20.
	aWormHole := WormHole between: 18 and: 19.
	aDistributionManager := ProbablisiticEventsManager new.
	aPlainSquare := PlainSquare new.
	aPlainSquareProbabilisticEvent := ProbabilisticEvent
		                                  for: aPlainSquare
		                                  with: aProbabilityOfOne.
	aDistributionManager add: aPlainSquareProbabilisticEvent.
	aDistribution := aDistributionManager generateFor: twentySquares.
	aBoard := Board
		          with: twentySquares
		          and: aWormHole
		          distributedBy: aDistribution.

	sideToRoll := #( 10 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.

	aSetCardManager := SetProbablisiticEventsManager new.
	anAccelerationCard := AccelerationCard new.
	anAccelerationCardProbabilisticEvent := ProbabilisticEvent
		                                        for: anAccelerationCard
		                                        with: aProbabilityOfOne.
	aSetCardManager add: anAccelerationCardProbabilisticEvent.

	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                for: aNitroCard
		                                with: aProbabilityOfOne.
	aSetCardManager add: aNitroCardProbabilisticEvent.
	
	aNullCard := NullCard new.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aSetCardManager.
	aGame := aGameBuilder build.

	expectedCards := OrderedCollection new.
	expectedCards add: anAccelerationCard.

	aGame
		play: aNitroCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.

	self assert: aBlueShip cards equals: expectedCards
]
