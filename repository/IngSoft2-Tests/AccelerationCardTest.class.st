Class {
	#name : 'AccelerationCardTest',
	#superclass : 'TestCase',
	#instVars : [
		'fiveSquares',
		'aBlueShip',
		'aBlackShip',
		'aDistributionManager',
		'aPlainSquare',
		'aProbabilityOfOne',
		'aPlainSquareProbabilisticEvent',
		'aRewardManager',
		'zeroReward',
		'zeroRewardRewardProbabilisticEvent',
		'anAccelerationCard',
		'anAccelerationCardProbabilisticEvent',
		'anAllyCard',
		'anAllyCardProbabilisticEvent',
		'someShips',
		'someDices',
		'aGameBuilder',
		'aNullCard',
		'sideToRoll',
		'aLoadedDice',
		'aWormHole',
		'aDistribution',
		'aBoard',
		'aDeckDistributionManager',
		'aDeckLength',
		'aDeckDistribution',
		'aDeck',
		'aState'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
AccelerationCardTest >> setUp [

	super setUp.

	fiveSquares := 5.

	sideToRoll := #( 1 ) asOrderedCollection.
	aLoadedDice := LoadedDice toRoll: sideToRoll.

	aBlueShip := Ship called: 'BlueShip'.
	aBlackShip := Ship called: 'BlackShip'.

	aWormHole := WormHole between: 3 and: 4.

	aDistributionManager := ProbablisiticEventsManager new.

	aPlainSquare := PlainSquare new.
	aProbabilityOfOne := 1.
	aPlainSquareProbabilisticEvent := ProbabilisticEvent
		                                  for: aPlainSquare
		                                  with: aProbabilityOfOne.
	aDistributionManager add: aPlainSquareProbabilisticEvent.

	aDistribution := aDistributionManager generateFor: fiveSquares.

	aBoard := Board
		          with: fiveSquares
		          and: aWormHole
		          distributedBy: aDistribution.

	aRewardManager := ProbablisiticEventsManager new.
	zeroReward := FuelDecreaseReward of: 0.
	zeroRewardRewardProbabilisticEvent := ProbabilisticEvent
		                                      for: zeroReward
		                                      with: aProbabilityOfOne.
	aRewardManager add: zeroRewardRewardProbabilisticEvent.



	anAccelerationCard := AccelerationCard new.
	anAccelerationCardProbabilisticEvent := ProbabilisticEvent
		                                        for: anAccelerationCard
		                                        with: aProbabilityOfOne.

	anAllyCard := AllyCard new.
	anAllyCardProbabilisticEvent := ProbabilisticEvent
		                                for: anAllyCard
		                                with: aProbabilityOfOne.

	someShips := OrderedCollection new.
	someDices := OrderedCollection new.
	someShips add: aBlueShip.
	someShips add: aBlackShip.
	someDices add: aLoadedDice.

	aGameBuilder := GameBuilder new.

	aGameBuilder setBoard: aBoard.
	aGameBuilder setShips: someShips.
	aGameBuilder setDices: someDices.
	aGameBuilder setRewards: aRewardManager.

	aNullCard := NullCard new.
	
	aDeckDistributionManager := ProbablisiticEventsManager new.
	aDeckDistributionManager add: anAccelerationCardProbabilisticEvent.
	aDeckLength := 10.
	aDeckDistribution := aDeckDistributionManager generateFor: aDeckLength.
	aState := HasCardsState new.
	aDeck := Deck of: aDeckLength distributedBy: aDeckDistribution with: aState.
	
]

{ #category : 'asserting' }
AccelerationCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: anErrorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]

{ #category : 'tests' }
AccelerationCardTest >> testWhenAShipPlaysAnAccelerationCardThenAllRolledNumbersAreIncreasedByOne [

	| aGame expectedPosition expectedFuel |
	expectedPosition := Position at: 2 in: 1.
	expectedFuel := Fuel with: 0 upTo: 2 in: HasFuelState new.

	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	aGame
		play: anAccelerationCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.
	aGame nextTurnPlay.
	aGame nextTurnPlay.

	self assert: (aBlueShip currentPositionEquals: expectedPosition).
	self assert: (aBlueShip fuelEquals: expectedFuel).
	self assert: (aBlackShip currentPositionEquals: expectedPosition).
	self assert: (aBlackShip fuelEquals: expectedFuel)
]

{ #category : 'tests' }
AccelerationCardTest >> testWhenAShipPlaysAnAccelerationCardThenItIsNoLongerInItsHand [

	| aGame expectedCards |

	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	expectedCards := OrderedCollection new.
	expectedCards add: anAccelerationCard.

	aGame
		play: anAccelerationCard
		by: aBlueShip
		affecting: aNullCard
		and: aBlackShip.

	self assert: aBlueShip cards equals: expectedCards
]

{ #category : 'tests' }
AccelerationCardTest >> testWhenAShipTriesToPlayAnAccelerationCardThatIsNotInItsHandThenInvalid [

	| aGame aSetCardManager aSetDeckDistribution aSetDeck |
	aSetCardManager := ProbablisiticEventsManager new.
	aSetCardManager add: anAllyCardProbabilisticEvent.
	aSetDeckDistribution := aSetCardManager generateFor: aDeckLength.
	aSetDeck := Deck of: aDeckLength distributedBy: aSetDeckDistribution with: aState.

	aGameBuilder setDeck: aSetDeck.
	aGame := aGameBuilder build.
	self
		should: [
			aGame
				play: anAccelerationCard
				by: aBlueShip
				affecting: aNullCard
				and: aBlackShip ]
		raise: Error
		withMessageText: 'The ship does not have that card on its hand.'
]

{ #category : 'tests' }
AccelerationCardTest >> testWhenAShipTriesToPlayAnAccelerationCardWhenItIsNotItsTurnThenInvalid [

	| aGame |
	aGameBuilder setDeck: aDeck.
	aGame := aGameBuilder build.

	self
		should: [
			aGame
				play: anAccelerationCard
				by: aBlackShip
				affecting: aNullCard
				and: aBlueShip ]
		raise: Error
		withMessageText:
		'A permanent card cannot be played when it is not your turn.'
]
