module Jell

using FunctionWrappers: FunctionWrapper
using MacroTools: postwalk

export @choose, AbstractCharacter, PlayerChoice, show_dialogue

struct PlayerChoice
    choice_pairs::Vector{Pair{String, FunctionWrapper{Nothing, Tuple{}}}}
end
function PlayerChoice(choices::Vector{Pair{<:AbstractString, <:Function}})
    # In case the inputs aren't wrapped in a FunctionWrapper already
    return map(choices) do choice
        str, fn = choice
        # We need to make sure the function actually returns nothing
        fn_nothing = function ()
            fn()
            nothing
        end
        String(str) => FunctionWrapper{Nothing, Tuple{}}(fn_nothing)
    end
end

macro choose(things)
    @assert things isa Expr && things.head == :vcat
    things = postwalk(things) do thing
        if thing isa Expr && thing.head == :call && thing.args[1] == :(=>)
            thing.args[2] = :(String($(thing.args[2])))
            thing.args[3] = :(
                function ()
                    $(thing.args[3])
                    nothing
                end
            )
        end
        thing
    end
    things = map(things.args) do thing
        if thing isa String
            thing = :($thing => Returns(nothing))
        end
        thing
    end
    things = Expr(:vcat, things...)
    return esc(:(PlayerChoice($things)))
end

abstract type AbstractCharacter end

function show_dialogue(c::AbstractCharacter, s)
    @error """
        No method for `show_dialogue(::$(typeof(c)), ::Any)` implemented.
        Please make one.
        """
end
function show_dialogue(c::AbstractCharacter, choices::PlayerChoice)
    @error """
        No method for `show_dialogue(::$(typeof(c)), ::PlayerChoice)` implemented.
        Please make one.
        """
end

Base.:(:)(c::AbstractCharacter, ::Nothing) = nothing
Base.:(:)(c::AbstractCharacter, s) = show_dialogue(c, s)


end
