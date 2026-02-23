"
This class represents a Redo Card
"
Class {
	#name : 'RedoCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
RedoCard >> applyEffectPlayedBy: aPlayingShip affecting: anAffectedCard and: anAffectedShip in: aGame [

	aGame
		playLastCardBy: aPlayingShip
		affecting: anAffectedCard
		and: anAffectedShip.
]

{ #category : 'playing' }
RedoCard >> bePlayedBy: aPlayingShip affecting: anAffectedCard and: aTargetShip in: aGame [

	self
		applyEffectPlayedBy: aPlayingShip
		affecting: anAffectedCard
		and: aTargetShip
		in: aGame.
	aPlayingShip remove: self.
	aGame discard: (self asOrderedCollection).
]

{ #category : 'comparing' }
RedoCard >> compare: aShip and: anotherShip [

	^ false
]
