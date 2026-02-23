"
This Class represents a Card Square

"
Class {
	#name : 'CardSquare',
	#superclass : 'Square',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'effect' }
CardSquare >> applyOn: aShip and: aPosition in: aGame [

	| oneCard |
	oneCard := 1.
	aGame deal: oneCard to: aShip.
	^ aPosition.
]

{ #category : 'effect' }
CardSquare >> repeatEffectFor: aShip on: aPosition in: aGame [

	^ self applyOn: aShip and: aPosition in: aGame
]
