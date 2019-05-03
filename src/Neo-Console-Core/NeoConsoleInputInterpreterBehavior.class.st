"
NeoConsole interpreter template.

Subclass this class with your interpreter to be able to use it with NeoConsole.
"
Class {
	#name : #NeoConsoleInputInterpreterBehavior,
	#superclass : #Object,
	#category : #'Neo-Console-Core-Behavior'
}

{ #category : #accessing }
NeoConsoleInputInterpreterBehavior >> commandClass [
	self subclassResponsibility
]

{ #category : #accessing }
NeoConsoleInputInterpreterBehavior >> commandForLine: line [
	line isEmptyOrNil
		ifTrue: [ ^ self quitCommandClass new ].
	^ (self commandClass forLine: line) new
]

{ #category : #accessing }
NeoConsoleInputInterpreterBehavior >> consolePrompt [
	self subclassResponsibility
]

{ #category : #accessing }
NeoConsoleInputInterpreterBehavior >> quitCommandClass [
	self subclassResponsibility
]

{ #category : #accessing }
NeoConsoleInputInterpreterBehavior >> startUpText [
	self subclassResponsibility
]
