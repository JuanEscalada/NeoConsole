"
NeoConsoleIOStreamsManager defines the Input and Output stream management behavior common to both NeoConsoleStdio and NeoConsoleTelnetServer.

It simply acts as a way of keeping common behavior unified and manageable.
"
Class {
	#name : #NeoConsoleIOStreamsManager,
	#superclass : #Object,
	#instVars : [
		'flush',
		'inputInterpreter'
	],
	#category : #'Neo-Console-Core-Behavior'
}

{ #category : #private }
NeoConsoleIOStreamsManager >> basicRequestResponseLoopOn: aReadStream and: aWriteStream [
	| executionResult command |
	[ self
		writeSingleLineOutput: self inputInterpreter consolePrompt
		to: aWriteStream.
	command := self readInputFrom: aReadStream.
	executionResult := [ command execute ]
		on: Error
		do:
			[ :exception | command printString , ' failed with ' , exception printString ].
	self writeOutput: command result to: aWriteStream.
	executionResult notNil ] whileTrue
]

{ #category : #protocol }
NeoConsoleIOStreamsManager >> executeRequestResponseLoopOn: anInputStream and: anOutputStream [
	self
		writeStartUpInfoAndExecuteLoopOn: (ZnCharacterReadStream on: anInputStream)
		and: (ZnCharacterWriteStream on: anOutputStream)
]

{ #category : #accessing }
NeoConsoleIOStreamsManager >> flush [
	^ flush ifNil: [ false ]
]

{ #category : #accessing }
NeoConsoleIOStreamsManager >> flush: aBoolean [
	flush := aBoolean
]

{ #category : #accessing }
NeoConsoleIOStreamsManager >> inputInterpreter [
	^ inputInterpreter
]

{ #category : #accessing }
NeoConsoleIOStreamsManager >> inputInterpreter: anInputInterpreter [
	^ inputInterpreter := anInputInterpreter
]

{ #category : #private }
NeoConsoleIOStreamsManager >> readInputFrom: stream [
	| input lineReader line commandClass |
	lineReader := ZnFastLineReader on: stream.
	line := self readLineUsing: lineReader.
	commandClass := self inputInterpreter commandClassForLine: line.
	commandClass isQuitCommand
		ifTrue: [ ^ commandClass new ].
	input := String new writeStream.
	input nextPutAll: line.
	commandClass isMultiLine
		ifTrue: [ input cr.
			[ line := self readLineUsing: lineReader.
			input
				nextPutAll: line;
				cr.
			line isEmpty ] whileFalse ].
	^ commandClass new
		on: input contents;
		yourself
]

{ #category : #private }
NeoConsoleIOStreamsManager >> readLineUsing: lineReader [
	^ [ lineReader nextLine trimBoth ]
		on: ConnectionClosed , ConnectionTimedOut
		do: [ '' ]
]

{ #category : #private }
NeoConsoleIOStreamsManager >> writeOutput: string to: stream [
	string lines
		do: [ :each | stream nextPutAll: each ]
		separatedBy: [ stream lf ].
	stream lf.
	self flush
		ifTrue: [ stream flush ]
]

{ #category : #private }
NeoConsoleIOStreamsManager >> writeSingleLineOutput: string to: stream [
	stream nextPutAll: string.
	self flush
		ifTrue: [ stream flush ]
]

{ #category : #protocol }
NeoConsoleIOStreamsManager >> writeStartUpInfoAndExecuteLoopOn: aReadStream and: aWriteStream [
	self writeOutput: self inputInterpreter startUpText to: aWriteStream.
	self basicRequestResponseLoopOn: aReadStream and: aWriteStream
]
