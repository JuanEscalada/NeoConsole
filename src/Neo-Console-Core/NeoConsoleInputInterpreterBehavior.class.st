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
NeoConsoleInputInterpreterBehavior >> commandForLine: line [
	line isEmptyOrNil
		ifTrue: [ ^ self getQuitCommand ].
	^ self getCommandForLine: line
]

{ #category : #accessing }
NeoConsoleInputInterpreterBehavior >> consolePrompt [
	self subclassResponsibility
]

{ #category : #accessing }
NeoConsoleInputInterpreterBehavior >> getCommandForLine: line [
	self subclassResponsibility
]

{ #category : #accessing }
NeoConsoleInputInterpreterBehavior >> getQuitCommand [
	self subclassResponsibility
]

{ #category : #accessing }
NeoConsoleInputInterpreterBehavior >> startUpText [
	self subclassResponsibility
]
