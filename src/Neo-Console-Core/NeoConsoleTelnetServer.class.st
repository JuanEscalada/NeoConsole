"
NeoConsoleTelnetServer offers a command line interface to a Pharo image over a network connection.

Inspect:

  NeoConsoleTelnetServer new start.

In a terminal do:

  $ telnet localhost 4999

End with quit or an empty line.

Security warning: this service opens up your image for access to those with access to your local network (i.e. those logged in to your machine), without any further authenication, allowing them to do absolutely anything. Think and make sure that you know what you are doing.
"
Class {
	#name : #NeoConsoleTelnetServer,
	#superclass : #NeoConsoleBehavior,
	#instVars : [
		'port',
		'process',
		'serverSocket',
		'stream',
		'socket'
	],
	#category : #'Neo-Console-Core-Consoles'
}

{ #category : #public }
NeoConsoleTelnetServer class >> startOn: port [
	"self startOn: 4999"
	
	^ self new
		port: port;
		start
]

{ #category : #protocol }
NeoConsoleTelnetServer >> closeSocketStream [
	^ [ stream close ]
		on: Exception
		do: [ :signal |  ]
]

{ #category : #protocol }
NeoConsoleTelnetServer >> flush [
	^ true
]

{ #category : #private }
NeoConsoleTelnetServer >> initializeServerSocket [
	serverSocket := Socket newTCP.
	serverSocket setOption: 'TCP_NODELAY' value: 1.
	serverSocket 
		listenOn: self port 
		backlogSize: 10 
		interface: NetNameResolver loopBackAddress.
	serverSocket isValid
		ifFalse: [ self error: 'Cannot create socket on port ' , self port printString ]
]

{ #category : #protocol }
NeoConsoleTelnetServer >> initializeSocketAndStreamRelatedTo: listeningSocket onFailure: block [
	"We wait up to acceptWaitTimeout seconds for an incoming connection.
	If we get one we wrap it in a SocketStream and run the console loop on it"

	socket := listeningSocket waitForAcceptFor: 300.
	socket ifNil: block.
	stream := self socketStreamOn: socket
]

{ #category : #protocol }
NeoConsoleTelnetServer >> inputStream [
	^ stream
]

{ #category : #testing }
NeoConsoleTelnetServer >> isRunning [
	"Return true when I am running"
	
	^ process notNil and: [ serverSocket notNil ]
]

{ #category : #protocol }
NeoConsoleTelnetServer >> listenLoop [
	"We create a listening Socket, then wait for a connection.
	After each connection we also check that the listening Socket is still valid 
	- if not we just make a recursive call to this method to start over."

	self initializeServerSocket.
	[ [ 
		serverSocket isValid 
			ifFalse: [
				"will trigger #ifCurtailed: block and destroy socket"
				^ self listenLoop ].
		self serveConnectionsOn: serverSocket ] repeat ]

		ifCurtailed: [ self releaseServerSocket ]
]

{ #category : #protocol }
NeoConsoleTelnetServer >> outputStream [
	^ stream
]

{ #category : #accessing }
NeoConsoleTelnetServer >> port [
	^ port ifNil: [ port := 4999 ]
]

{ #category : #accessing }
NeoConsoleTelnetServer >> port: integer [
	port := integer
]

{ #category : #printing }
NeoConsoleTelnetServer >> printOn: stream [
	super printOn: stream.
	stream << $(.
	self isRunning ifTrue: [ stream << #running; space; << self port ].
	stream << $)
]

{ #category : #private }
NeoConsoleTelnetServer >> releaseServerSocket [
	(Delay forMilliseconds: 10) wait.
	serverSocket destroy.
	serverSocket := nil
]

{ #category : #protocol }
NeoConsoleTelnetServer >> serveConnectionsOn: listeningSocket [
	self
		initializeSocketAndStreamRelatedTo: listeningSocket
		onFailure: [ ^ self ].
	[ [ [ self run ]
		ensure: [ self closeSocketStream ] ]
		ifCurtailed: [ socket destroy ] ]
		forkAt: Processor lowIOPriority
		named: self workerProcessName
]

{ #category : #accessing }
NeoConsoleTelnetServer >> serverProcessName [
	^ self class name asString , ' port ' , self port asString
]

{ #category : #private }
NeoConsoleTelnetServer >> socketStreamOn: aSocket [
	^ (ZdcSocketStream on: aSocket)
		binary;
		shouldSignal: true;
		autoFlush: false;
		timeout: 60;
		yourself
]

{ #category : #public }
NeoConsoleTelnetServer >> start [
	self stop.
	process := [ [ self listenLoop ] repeat ] 
					forkAt: Processor highIOPriority 
					named: self serverProcessName
]

{ #category : #public }
NeoConsoleTelnetServer >> stop [
	self isRunning
		ifFalse: [ ^ self ].
	process terminate.
	process := nil
]

{ #category : #accessing }
NeoConsoleTelnetServer >> workerProcessName [
	^ self serverProcessName, ' Connection Handler'
]
