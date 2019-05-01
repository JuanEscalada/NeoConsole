"
.
"
Class {
	#name : #NeoConsoleBehavior,
	#superclass : #Object,
	#instVars : [
		'inputInterpreter'
	],
	#category : #'Neo-Console-Core-Consoles'
}

{ #category : #public }
NeoConsoleBehavior class >> start [
	^ self new start
]

{ #category : #public }
NeoConsoleBehavior >> flush [
	self subclassResponsibility
]

{ #category : #public }
NeoConsoleBehavior >> inputInterpreter [
	^ inputInterpreter
		ifNil: [ self inputInterpreter: NeoConsoleInputInterpreter new ]
]

{ #category : #public }
NeoConsoleBehavior >> inputInterpreter: anInputInterpreter [
	^ inputInterpreter := anInputInterpreter
]

{ #category : #public }
NeoConsoleBehavior >> inputStream [
	self subclassResponsibility
]

{ #category : #public }
NeoConsoleBehavior >> outputStream [
	self subclassResponsibility
]

{ #category : #public }
NeoConsoleBehavior >> run [
	NeoConsoleIOStreamsManager new
		inputInterpreter: self inputInterpreter;
		flush: self flush;
		executeRequestResponseLoopOn: self inputStream
			and: self outputStream
]

{ #category : #public }
NeoConsoleBehavior >> start [
	self subclassResponsibility
]
