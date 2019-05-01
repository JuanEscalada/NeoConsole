"
Example interpreter which only responds to the evaluation of pharo code
"
Class {
	#name : #NeoConsoleEvalInterpreter,
	#superclass : #NeoConsoleInputInterpreterBehavior,
	#category : #'Neo-Console-Core-Behavior'
}

{ #category : #accessing }
NeoConsoleEvalInterpreter >> commandClass [
	^ NeoConsoleEvalCommand
]

{ #category : #accessing }
NeoConsoleEvalInterpreter >> consolePrompt [
	^ 'st> '
]

{ #category : #accessing }
NeoConsoleEvalInterpreter >> quitCommandClass [
	^ NeoConsoleQuitCommand
]

{ #category : #accessing }
NeoConsoleEvalInterpreter >> startUpText [
	^ 'NeoConsole Example Smalltalk REPL. '
]
