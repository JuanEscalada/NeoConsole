"
NeoConsoleIOStreamsManager defines the Input and Output stream management behavior common to both NeoConsoleStdio and NeoConsoleTelnetServer.

It simply acts as a way of keeping common behavior unified and manageable.
"
Class {
	#name : #NeoConsoleIOStreamsManager,
	#superclass : #Object,
	#instVars : [
		'flush'
	],
	#category : #'Neo-Console-Core-Behavior'
}

{ #category : #protocol }
NeoConsoleIOStreamsManager >> executeRequestResponseLoopOn: anInputStream and: anOutputStream [
	| in out command executeResult |
	in := ZnCharacterReadStream on: anInputStream.
	out := ZnCharacterWriteStream on: anOutputStream.
	self
		writeOutput: 'Neo Console ' , SystemVersion current asString
		to: out.
	[ out nextPutAll: 'pharo> '.
	flush
		ifTrue: [ out flush ].
	command := self readInputFrom: in.
	executeResult := [ command execute ]
		on: Error
		do:
			[ :exception | command printString , ' failed with ' , exception printString ].
	self writeOutput: command result to: out.
	executeResult notNil ] whileTrue
]

{ #category : #accessing }
NeoConsoleIOStreamsManager >> flush [
	^ flush ifNil: [ false ]
]

{ #category : #accessing }
NeoConsoleIOStreamsManager >> flush: aBoolean [
	flush := aBoolean
]

{ #category : #protocol }
NeoConsoleIOStreamsManager >> readInputFrom: stream [
	| input lineReader line commandClass |
	lineReader := ZnFastLineReader on: stream.
	line := [ lineReader nextLine trimBoth ]
		on: ConnectionClosed , ConnectionTimedOut
		do: [ nil ].
	line isEmptyOrNil
		ifTrue: [ ^ NeoConsoleQuitCommand new ].
	commandClass := NeoConsoleCommand forLine: line.
	commandClass isSingleLine
		ifTrue: [ ^ commandClass new
				on: line;
				yourself ].
	input := String new writeStream.
	input
		nextPutAll: line;
		cr.
	[ line := [ lineReader nextLine trimBoth ]
		on: ConnectionClosed , ConnectionTimedOut
		do: [ '' ].
	input
		nextPutAll: line;
		cr.
	line isEmpty ] whileFalse.
	^ commandClass new
		on: input contents;
		yourself
]

{ #category : #protocol }
NeoConsoleIOStreamsManager >> writeOutput: string to: stream [
	string lines
		do: [ :each | stream nextPutAll: each ]
		separatedBy: [ stream lf ].
	stream lf.
	flush
		ifTrue: [ stream flush ]
]
