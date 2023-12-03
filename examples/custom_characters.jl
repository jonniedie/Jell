using Jell

# Define a new custom character type. For this example, the character we want
# to keep track of the word count of the character, so 
@kwdef mutable struct Character <: AbstractCharacter
    name::String
    word_count::Int = 0
    name_style::Symbol = :default
    dialogue_style::Symbol = :default
end

Jell.nameof(c::Character) = c.name

Jell.name_style(c::Character) = c.name_style

Jell.dialogue_style(c::Character) = c.dialogue_style

function Jell.show_dialogue(c::Character, str)
    c.word_count += length(split(str, ' '))
    print_dialogue_to_terminal(c, str; time_delay = 0.01)
end

# Declare the characters
alice = Character(name="Alice", name_style=:yellow)
bob = Character(name="Bob", name_style=:light_magenta)

# Run the script
alice: "Hey Bob. I wanted to try something."
bob: "Yeah? What's that?"
alice: "I want you to count how many words I say."
bob: "Including the ones you've already said?"
alice: "No, just the ones starting after this sentence."
bob: "Okay, I'll try."

# Set a variable to capture the words Alice has said until this point
not_included_count = alice.word_count

alice: "Did you start counting?"
bob: "Yep."
alice: "How many have I said so far?"
bob: "You've said $(alice.word_count - not_included_count) words."
alice: "That sounds about right."
bob: "Make that $(alice.word_count - not_included_count)."