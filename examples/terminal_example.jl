using JellTerminal
using Crayons.Box: DEFAULT_FG, ITALICS, BOLD

# Define characters
alice = Character(name="Alice", color=:light_magenta)
bob = Character(name="Bob", color=:light_blue)
narrator = Narrator()

# Define scenes
lets_eat() = begin
    bob: "What do you want to eat?"
    alice: @choose [
        "Froot Loops!" => begin
            bob: "Yeah, sounds good."
            narrator: "They ate Froot Loops™ and were satisfied." end
        "Infinite loops!" => lets_eat() ] end

## Run the story
narrator: """
    We open with Alice and Bob.
    They are people."""
alice: "Hey, Bob."
bob: "Hey, Alice."
alice: @choose [
    "Are you hungry?" => begin
        bob: "Yeah, a little bit."
        alice: "Okay, let's eat."
        lets_eat() end
    "I'm hungry. Let's eat." => lets_eat()
    "I'm not really that hungry." => begin
        bob: "Why would you even say that?"
        alice: "..."
        bob: "Seriously though. I never said anything about eating."
        bob: "..."
        alice: "..."
        narrator: "..." end
    "[Walk away.]" => nothing ]