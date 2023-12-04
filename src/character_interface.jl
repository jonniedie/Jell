abstract type AbstractCharacter end

# The following can be implemented for an AbstractCharacter
"""
    show_dialogue(c::AbstractCharacter, s::Any)
    show_dialogue(c::AbstractCharacter, ::Nothing)


"""
show_dialogue(c::AbstractCharacter, s::Any) = print_dialogue_to_terminal(c, s)
show_dialogue(c::AbstractCharacter, ::Nothing) = nothing

"""
    request_choice(c::AbstractCharacter, choices::Vector{String})

Request a choice to players from the outputs of a
```julia
character: @choose begin
    ...
end
```
type of call. Should return the chosen index. Defaults to a running a terminal
menu.
"""
function request_choice(c::AbstractCharacter, choices::Vector{String})
    return request_terminal_choice(c, choices)
end

"""
dialogue_style(c::AbstractCharacter)::Symbol

Returns the printing style as a of the dialogue spoken by a character. May take
any of the following values:
    :normal, :italic, :default, :bold, :black, :blink, :blue, :cyan, :green,
    :hidden, :light_black, :light_blue, :light_cyan, :light_green
    :light_magenta, :light_red, :light_white, :light_yellow, :magenta,
    :nothing, :red, :reverse, :underline, :white, or :yellow

The default is :default.
"""
dialogue_style(::AbstractCharacter) = :default

"""
    nameof(c::AbstractCharacter)

Return the name of a character. Defaults to "[unnamed character]".
"""
Base.nameof(c::AbstractCharacter) = "[unnamed character]"

"""
    name_style(c::AbstractCharacter)::Symbol

Returns the printing style as a of the name of the character. May take any of
the following values (from `Base.printstyled`'s `color` keyword argument):
    :normal, :italic, :default, :bold, :black, :blink, :blue, :cyan, :green,
    :hidden, :light_black, :light_blue, :light_cyan, :light_green
    :light_magenta, :light_red, :light_white, :light_yellow, :magenta,
    :nothing, :red, :reverse, :underline, :white, or :yellow

The default is :normal, (not :default, confusingly).
"""
name_style(::AbstractCharacter) = :normal

"""
    should_show_name(c::AbstractCharacter)::Bool

Should the character's name be printed when `show_dialogue` is called? This is
useful for narrators, where often it is not desired to print a character name.
Defaults to `true`.
"""
should_show_name(::AbstractCharacter) = true

# This doesn't need to be implemented, it's just syntactic sugar
Base.:(:)(c::AbstractCharacter, s::Any) = show_dialogue(c, s)
function Base.:(:)(c::AbstractCharacter, choice::PlayerChoice)
    choices = first.(choice.choice_pairs)
    results = last.(choice.choice_pairs)
    i_chosen = request_choice(c, choices)
    return results[i_chosen]()
end
