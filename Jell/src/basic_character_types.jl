abstract type AbstractBasicCharacter <: AbstractCharacter end

@kwdef struct BasicCharacter <: AbstractBasicCharacter
    name::String
    color::Symbol = :default
end

struct BasicNarrator <: AbstractBasicCharacter end

# Interface
Base.nameof(c::BasicCharacter) = c.name
Base.nameof(n::BasicNarrator) = "Narrator"

# We're using `Jell.[whatever]` here as an example for other implementations.
# It's not strictly necessary, since we're working in the same module.
Jell.name_style(c::BasicCharacter) = c.color

Jell.dialogue_style(n::BasicNarrator) = :italic

Jell.should_show_name(n::BasicNarrator) = false
