module JellTerminal

using Crayons: Crayon, CrayonWrapper, Box
using Jell
using REPL
using REPL.TerminalMenus
using REPL.Terminals

export @choose, Character, Narrator, show_dialogue

@kwdef struct TerminalPrinter
    color::Symbol = :default
    sleep_time::Float64 = 0.0
end

@kwdef struct NamePrinter
    name::String
    color::Symbol = :default
end

struct NoNamePrinter end

@kwdef struct DialoguePrinter
    color::Symbol = :default
    sleep_time::Float64 = 0.0
end

abstract type TerminalCharacter <: AbstractCharacter end

@kwdef struct Character <: TerminalCharacter
    name::String
    color::Symbol = :default
end

struct Narrator <: TerminalCharacter end

function request_continue()
    # t = TTYTerminal("", stdin, stdout, stderr)
    # printstyled("\n\n[Press Enter to continue]"; color=:light_black)
    # readline()
    # Terminals.cmove_line_up(t)
    # Terminals.clear_line(t)
    # Terminals.cmove_line_up(t)
    # Terminals.clear_line(t)
    println()
    sleep(1)
end

function slow_print(str::String; timer = 0.02, kwargs...)
    for char in str
        printstyled(char; kwargs...)
        sleep(timer)
    end
end
function slow_print(cw::CrayonWrapper; kwargs...)
    for str in cw.v
        slow_print(cw.c, str; kwargs...)
    end
end
function slow_print(crayon::Crayon, str::String; timer = 0.02)
    for char in str
        print(crayon, char)
        sleep(timer)
    end
end
function slow_print(crayon::Crayon, cw::CrayonWrapper; kwargs...)
    print(crayon, cw)
end

function Jell.show_dialogue(c::Character, player_choice::PlayerChoice)
    println()
    printstyled(c.name; c.color)
    println(": ")
    choices = first.(player_choice.choice_pairs)
    results = last.(player_choice.choice_pairs)
    choice = request(RadioMenu(choices; scroll_wrap = true, cursor = '▷'))
    return results[choice]()
end
function Jell.show_dialogue(c::Character, s)
    println()
    printstyled(c.name; c.color)
    print(": ")
    slow_print(s)
    request_continue()
    return nothing
end
function Jell.show_dialogue(c::Narrator, s)
    println()
    slow_print(s; color = :italic)
    request_continue()
    return nothing
end

end
