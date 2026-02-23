"
This class reresents a nitro card.
"
Class {
	#name : 'NitroCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
NitroCard >> applyEffectPlayedBy: aPlayingShip affecting: anAffectedCard and: anAffectedShip in: aGame [

	anAffectedShip applyNitroCard.
	aGame lastPlayedCard: self.
]

{ #category : 'playing' }
NitroCard >> bePlayedBy: aPlayingShip affecting: anAffectedCard and: anAffectedShip in: aGame [

	self
		applyEffectPlayedBy: aPlayingShip
		affecting: anAffectedCard
		and: anAffectedShip
		in: aGame.
	aPlayingShip remove: self.
	aGame discard: (self asOrderedCollection).
]

{ #category : 'comparing' }
NitroCard >> compare: aShip and: anotherShip [

	^ false
]
