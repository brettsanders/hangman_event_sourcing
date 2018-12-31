Commands and Events in system
Will store as JSON with following structure
There will be Commands and Types
Only 1 Stream for now

{
  username: <Username>,
  game: SecureRandom.uuid,
  type: "COMMAND" | "EVENT",
  who: "SYSTEM" | <Actor>,
  when: Time.now,
  what: {
    <Data>
  }
}