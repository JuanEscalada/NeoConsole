"
NeoConsoleStdio offers a command line interface to a Pharo image over Stdio.

  $ ./pharo Pharo.image NeoConsoleStdio run

End with quit or an empty line.

Security warning: this service opens up your image for access to those with access to your local network (i.e. those logged in to your machine), without any further authenication, allowing them to do absolutely anything. Think and make sure that you know what you are doing.
"
Class {
	#name : #NeoConsoleStdio,
	#superclass : #Object,
	#instVars : [
		'inputInterpreter'
	],
	#category : #'Neo-Console-Core-Consoles'
}

{ #category : #public }
NeoConsoleStdio class >> run [
	^ self new run
]

{ #category : #public }
NeoConsoleStdio >> inputInterpreter [
	^ inputInterpreter
		ifNil: [ self inputInterpreter: NeoConsoleInputInterpreter new ]
]

{ #category : #public }
NeoConsoleStdio >> inputInterpreter: anInputInterpreter [
	^ inputInterpreter := anInputInterpreter
]

{ #category : #public }
NeoConsoleStdio >> run [
	NeoConsoleIOStreamsManager new
		inputInterpreter: self inputInterpreter;
		executeRequestResponseLoopOn: FileStream stdin binary
			and: Stdio stdout
]
