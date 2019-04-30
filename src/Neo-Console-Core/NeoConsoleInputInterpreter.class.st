"
NeoConsole default behavior.

It defines the commands and prompts for the console.

It's reified so it can be replaced with custom interpreters made by the user.
"
Class {
	#name : #NeoConsoleInputInterpreter,
	#superclass : #NeoConsoleInputInterpreterBehavior,
	#category : #'Neo-Console-Core-Behavior'
}

{ #category : #accessing }
NeoConsoleInputInterpreter >> commandClass [
	^ NeoConsoleCommand
]

{ #category : #accessing }
NeoConsoleInputInterpreter >> consolePrompt [
	^ 'pharo> '
]

{ #category : #accessing }
NeoConsoleInputInterpreter >> quitCommandClass [
	^ NeoConsoleQuitCommand
]

{ #category : #accessing }
NeoConsoleInputInterpreter >> startUpText [
	^ 'Neo Console ' , SystemVersion current asString
]
