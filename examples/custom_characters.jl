# To run this example, activate and instantiate the `examples` folder's
# environment. We'll use the SpelledOut package to spell out numbers as words
# instead of just printing the number.
using Jell
using SpelledOut

# Define a new custom character type. For this example, the character we want
# to keep track of the word count of the character.
@kwdef mutable struct CustomCharacter <: AbstractCharacter
    name::String
    word_count::Int = 0
    name_style::Symbol = :default
end

# Overload these functions to define how CustomCharacters work
Jell.nameof(c::CustomCharacter) = c.name

Jell.name_style(c::CustomCharacter) = c.name_style

function Jell.show_dialogue(c::CustomCharacter, str)
    c.word_count += length(split(str, ' '))
    print_dialogue_to_terminal(c, str; time_delay = 0.01)
end

# Declare the characters
alice = CustomCharacter(name="Alice", name_style=:yellow)
bob = CustomCharacter(name="Bob", name_style=:blue)

# Run the script
alice: "Hey, I wanted to try something."
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
bob: "You've said $(spelled_out(alice.word_count - not_included_count)) words."
alice: "That sounds about right."
bob: "Make that $(spelled_out(alice.word_count - not_included_count))."
