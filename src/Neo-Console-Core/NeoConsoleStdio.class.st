"
NeoConsoleStdio offers a command line interface to a Pharo image over Stdio.

  $ ./pharo Pharo.image NeoConsoleStdio run

End with quit or an empty line.

Security warning: this service opens up your image for access to those with access to your local network (i.e. those logged in to your machine), without any further authenication, allowing them to do absolutely anything. Think and make sure that you know what you are doing.
"
Class {
	#name : #NeoConsoleStdio,
	#superclass : #NeoConsoleBehavior,
	#category : #'Neo-Console-Core-Consoles'
}

{ #category : #public }
NeoConsoleStdio >> flush [
	^ false
]

{ #category : #public }
NeoConsoleStdio >> inputStream [
	^ FileStream stdin binary
]

{ #category : #public }
NeoConsoleStdio >> outputStream [
	^ Stdio stdout
]

{ #category : #public }
NeoConsoleStdio >> start [
	self run
]
