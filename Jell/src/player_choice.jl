struct PlayerChoice
    choice_pairs::Vector{Pair{String, FunctionWrapper{Nothing, Tuple{}}}}
end
function PlayerChoice(choices::Vector)
    filter!(choice -> choice isa Pair{<:AbstractString, <:Function}, choices)
    # In case the inputs aren't wrapped in a FunctionWrapper already
    choices = map(choices) do choice
        str, fn = choice
        # We need to make sure the function actually returns nothing
        fn_nothing = function ()
            fn()
            nothing
        end
        String(str) => FunctionWrapper{Nothing, Tuple{}}(fn_nothing)
    end
    return PlayerChoice(choices)
end

function choose_expand(things)
    @assert things isa Expr && things.head in (:vcat, :vect, :block)
    things = postwalk(things) do thing
        if thing isa Expr && thing.head == :call && thing.args[1] == :(=>)
            thing.args[2] = :($(thing.args[2]))
            expr = thing.args[3]
            if !(expr isa Expr && expr.head == :function)
                thing.args[3] = :(
                    function ()
                        $expr
                        nothing
                    end
                )
            end
        end
        thing
    end
    things = map(things.args) do thing
        if thing isa String
            thing = :($thing => Returns(nothing))
        end
        thing
    end
    things = esc(Expr(:vcat, things...))
    return :(PlayerChoice($things))
end

macro choose(things)
    choose_expand(things)
end
