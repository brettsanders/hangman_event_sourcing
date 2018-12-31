
The key feature of the Event Sourcing is
1. Recording the Ledger of the Events
2. Ability to go Forwards/Back

The Pub/Sub is needed for De-coupling of the Code
However, that is not the key feature of Event Sourcing

Also, there are almost Infinite Ways can actually implement this
As Greg Young explains, this has been around forever ... idea of Ledgers

So, I am trying approach of
1. what is my ledger?
2. ability to view the state of the Game at any point in that event history

From there, I will worry about the Code structure
(vs Code structure and utilities to the Events)

- - - - - - - - - - - - - - - - - - - - - - - - -

Attempt to create simple Event Sourced system without any frameworks

Idea will be to keep record of the events for the games with abilty to rebuild the system

Events will be kept in a plain text file

I'll try using "Event Storming" to come up with what

The Process Manager will come in to score the Game and assign Points

Aggregates:
Game
GamePoints
UserPoints
LeaderBoard

ProcessManagers:
GameScorer