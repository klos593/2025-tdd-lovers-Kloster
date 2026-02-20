Class {
	#name : 'NitroCardTest',
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
		'sideToRoll',
		'someDices',
		'aLoadedDice',
		'aCardManager',
		'aNitroCard',
		'aNitroCardProbabilisticEvent',
		'aNullCard',
		'aGameBuilder',
		'aGame'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
NitroCardTest >> setUp [

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

	sideToRoll := #( 1 1 1 1 1 30 ) asOrderedCollection.
	someDices := OrderedCollection new.
	aLoadedDice := LoadedDice toRoll: sideToRoll.
	someDices add: aLoadedDice.
	

	aNullCard := NullCard new.

]

{ #category : 'asserting' }
NitroCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: anErrorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]

{ #category : 'tests' }
NitroCardTest >> testWhenAShipPlaysANitroCardAndAfterOneTurnPlaysAnotherOneThenTheRolledNumberIsIncreasedCorrectlyAndEachCardLastsThreeTurns [

	| expectedPosition |
	aCardManager := ProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                for: aNitroCard
		                                with: aProbabilityOfOne.
	aCardManager add: aNitroCardProbabilisticEvent.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
	aGame := aGameBuilder build.

	aGame
		play: aNitroCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlueShip.
	aGame nextTurnPlay.
	aGame nextTurnPass.
	aGame
		play: aNitroCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlueShip.
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
NitroCardTest >> testWhenAShipPlaysANitroCardThenAfterThreeTurnsTheBonusIsNoLongerActive [

	| expectedPosition |
	aCardManager := ProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                for: aNitroCard
		                                with: aProbabilityOfOne.
	aCardManager add: aNitroCardProbabilisticEvent.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
	aGame := aGameBuilder build.

	aGame
		play: aNitroCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlueShip.
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
NitroCardTest >> testWhenAShipPlaysANitroCardThenItsrolledNumberOfTheAffectedShipIsIncreasedByThree [

	| expectedPosition |
	aCardManager := ProbablisiticEventsManager new.
	aNitroCard := NitroCard new.
	aNitroCardProbabilisticEvent := ProbabilisticEvent
		                                for: aNitroCard
		                                with: aProbabilityOfOne.
	aCardManager add: aNitroCardProbabilisticEvent.

	aGameBuilder := GameBuilder new.
	aGameBuilder setShips: someShips.
	aGameBuilder setRewards: aRewardManager.
	aGameBuilder setBoard: aBoard.
	aGameBuilder setDices: someDices.
	aGameBuilder setAvailableCards: aCardManager.
	aGame := aGameBuilder build.

	aGame
		play: aNitroCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlueShip.
	aGame nextTurnPlay.

	expectedPosition := Position at: 4 in: 1.

	self assert: (aBlueShip currentPositionEquals: expectedPosition)
]

{ #category : 'tests' }
NitroCardTest >> testWhenAShipTriesToPlayANitroCardThatIsNotInItsHandThenInvalid [

	| anOverloadCard anOverloadCardProbabilisticEvent |
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

	| aSetCardManager anAccelerationCard anAccelerationCardProbabilisticEvent expectedCards |
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
