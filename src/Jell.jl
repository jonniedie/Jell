module Jell

using Crayons: Crayon, CrayonWrapper
using FunctionWrappers: FunctionWrapper
using MacroTools: MacroTools, postwalk
using REPL
using REPL.TerminalMenus
using REPL.Terminals

include("utils.jl")
export extract_ast

include("player_choice.jl")
export @choose, PlayerChoice

include("character_interface.jl")
export AbstractCharacter, AbstractNarrator
export show_dialogue, name_style, dialogue_style, should_show_name

include("terminal_output.jl")
export print_dialogue_to_terminal, request_terminal_choice, request_continue

include("basic_character_types.jl")
export BasicCharacter, BasicNarrator

end
