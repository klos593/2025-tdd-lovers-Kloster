"
This class represents a Null Card

"
Class {
	#name : 'NullCard',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
NullCard >> bePlayedBy: aPlayingShip for: anAllyShip in: aGame [

	Error signal: 'A Redo card can not be played when there are no played cards yet.'
]
