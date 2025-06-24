"
This class represents a Redo Card
"
Class {
	#name : 'RedoCard',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
RedoCard >> bePlayedBy: aPlayingShip for: aTargetShip in: aGame [ 
	
	aGame playLastCardBy: aPlayingShip for: aTargetShip. 
]
