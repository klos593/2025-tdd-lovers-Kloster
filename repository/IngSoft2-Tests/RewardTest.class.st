Class {
	#name : 'RewardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
RewardTest >> testBanana [

	| fiveSquares aWormHole aGame sideToRoll aBlueShip aBlackShip aLoadedDice aBoard someShips someDices oneLap expectedFuelLeft aDistributionBuilder aFuelQuantity aPlainSquare aProbability aPlainSquareProbabilisticEvent aDistribution aRewardBuilder plusOneReward plusOneRewardProbabilisticEvent |
	fiveSquares := 5.
	sideToRoll := 1.
	oneLap := 1.

	expectedFuelLeft := 2.

	aWormHole := WormHole between: 0 and: 3.
	aBlueShip := Ship called: 'BlueShip'.
	aBlackShip := Ship called: 'BlackShip'.
	aLoadedDice := LoadedDice toRoll: sideToRoll.

	aDistributionBuilder := DistributionBuilder new.
	aPlainSquare := PlainSquare new.
	aProbability := 1.
	aPlainSquareProbabilisticEvent := ProbabilisticEvent
		                                  for: aPlainSquare
		                                  with: aProbability.
	aDistributionBuilder add: aPlainSquareProbabilisticEvent.
	aDistribution := aDistributionBuilder buildFor: fiveSquares.

	aRewardBuilder := DistributionBuilder new.
	plusOneReward := Reward of: 1.

	plusOneRewardProbabilisticEvent := ProbabilisticEvent
		                                   for: plusOneReward
		                                   with: 1.
		
	aRewardBuilder add: plusOneRewardProbabilisticEvent.


	aBoard := Board
		          with: fiveSquares
		          and: aWormHole
		          distributedBy: aDistribution.

	someShips := OrderedCollection new.
	someDices := OrderedCollection new.
	someShips add: aBlueShip.
	someShips add: aBlackShip.
	someDices add: aLoadedDice.

	aFuelQuantity := (someDices sum: [ :aDice | aDice rollMaximum ]) * 2.

	aGame := Game
		         with: aBoard
		         for: oneLap
		         and: someShips
		         and: someDices
		         and: aFuelQuantity
		         and: aRewardBuilder.

	aGame nextTurnPlay.

	self assert: (aBlueShip fuelEquals: expectedFuelLeft)
]
