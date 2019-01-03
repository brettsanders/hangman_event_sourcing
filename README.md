
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

Notes:

In course of working on this app, here's some things I've been thinking about ...

1. Cannot go BACK in a pub/sub architecture. Can only replay forwards and re-pubish the events
2. An "Event" is just a shared piece of data (I like FACT more than event).
    A difference from Messages in OO is that the Fact lives on its own. It's not a part of an Object.
3. View Model makes less sense w/out a DB. If re-calculating the aggregate each time it essentially is the View Model for that Entity.
    However, View Models are more clear (to me) when realize they do not need to map 1:1 to entitites.
    In this way, a View Model doesn't depend on a DB at all. It's just the "current state" of something that needs easy reading.
4. The MVC architecture helps some to keep a 1 way data flow. I noticed that without Rails, before I had a GameManager, my logic in the Subscribers.
5. A subscriber can be a View. Makes me think of Events being pushed to Widgets. So, a widget on a Dashboard may be thought of as a Subscriber to events.
    My GameRenderer is a subscriber.
6. The aggregate_root may be a confusing concept unless is actually an aggregate.

- - - - - - - - - - - - - - - - - - - - - - - - -

Attempt to create simple Event Sourced system without any frameworks

Idea will be to keep record of the events for the games with abilty to rebuild the system

Events will be kept in a plain text file

I'll try using "Event Storming" to come up with what

The Process Manager will come in to score the Game and assign Points

scoring:
Game
GamePoints
UserPoints
LeaderBoard

ProcessManagers:
GameScorer