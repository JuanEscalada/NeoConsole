"
NeoConsoleStdio offers a command line interface to a Pharo image over Stdio.

  $ ./pharo Pharo.image NeoConsoleStdio run

End with quit or an empty line.

Security warning: this service opens up your image for access to those with access to your local network (i.e. those logged in to your machine), without any further authenication, allowing them to do absolutely anything. Think and make sure that you know what you are doing.
"
Class {
	#name : #NeoConsoleStdio,
	#superclass : #Object,
	#category : #'Neo-Console-Core-Consoles'
}

{ #category : #public }
NeoConsoleStdio class >> run [
	^ self new run
]

{ #category : #public }
NeoConsoleStdio >> run [
	NeoConsoleIOStreamsManager new
		executeRequestResponseLoopOn: FileStream stdin binary
		and: Stdio stdout
]
