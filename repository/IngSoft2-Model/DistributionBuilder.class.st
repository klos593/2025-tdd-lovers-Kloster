"
This class represents a distribution builder
"
Class {
	#name : 'DistributionBuilder',
	#superclass : 'Object',
	#instVars : [
		'probabilityEvents'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'adding' }
DistributionBuilder >> add: anEvent [

	probabilityEvents add: anEvent
]

{ #category : 'building' }
DistributionBuilder >> buildFor: aLength [

	| generatedSquares |
	generatedSquares := (0 to: aLength - 1) collect: [ :aNumber |
		                    (probabilityEvents atRandomWeighting: [
			                     :aProbabilisticEvent |
			                     aProbabilisticEvent probability ]) event ].
	^ generatedSquares asOrderedCollection
]

{ #category : 'initialization' }
DistributionBuilder >> initialize [

	probabilityEvents := OrderedCollection new
]
