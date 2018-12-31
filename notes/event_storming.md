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

{
  username: "brett",
  game_id: "fa1e26bd-baec-432d-a27b-65c0c9ecd05c",
  type: "EVENT",
  who: "USER",
  when: "2018-12-31 12:34:53 -0500",
  what: {
    action: "GUESS",
    letter: "A"
  }
}