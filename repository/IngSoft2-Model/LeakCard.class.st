"
This class represents a Leak card
"
Class {
	#name : 'LeakCard',
	#superclass : 'Card',
	#instVars : [
		'affectedShip'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
LeakCard >> applyEffectPlayedBy: aPlayingShip affecting: anAffectedCard and: anAffectedShip in: aGame [

	aGame validateNextPlayer: aPlayingShip.
	affectedShip := anAffectedShip.
	anAffectedShip applyLeak: self.
	aGame lastPlayedCard: self.
	aGame addActiveCard: self
]

{ #category : 'operations' }
LeakCard >> applyTo: aDistance [ 
	
	^ aDistance * 2.
]

{ #category : 'playing' }
LeakCard >> bePlayedBy: aPlayingShip affecting: anAffectedCard and: anAffectedShip in: aGame [

	self
		applyEffectPlayedBy: aPlayingShip
		affecting: anAffectedCard
		and: anAffectedShip
		in: aGame.
	aPlayingShip remove: self
]

{ #category : 'cancelling' }
LeakCard >> cancelEffectIn: aGame [
	
	affectedShip removeLeakCard: self.
	affectedShip := NullShip new.
]

{ #category : 'comparing' }
LeakCard >> compare: aShip and: anotherShip [

	^ false
]

{ #category : 'initialization' }
LeakCard >> initialize [ 

	affectedShip := NullShip new.
]
