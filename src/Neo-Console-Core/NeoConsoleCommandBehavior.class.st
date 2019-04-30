Class {
	#name : #NeoConsoleCommandBehavior,
	#superclass : #Object,
	#category : #'Neo-Console-Core-Commands'
}

{ #category : #accessing }
NeoConsoleCommandBehavior class >> forLine: aString [
	self subclassResponsibility
]

{ #category : #testing }
NeoConsoleCommandBehavior class >> isMultiLine [
	^ self isSingleLine not
]

{ #category : #accessing }
NeoConsoleCommandBehavior class >> isQuitCommand [
	self subclassResponsibility
]

{ #category : #accessing }
NeoConsoleCommandBehavior class >> isSingleLine [
	self subclassResponsibility
]
