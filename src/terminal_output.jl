function request_continue()
    t = TTYTerminal("", stdin, stdout, stderr)
    printstyled("\n\n[Press Enter to continue]"; color=:light_black)
    readline()
    Terminals.cmove_line_up(t)
    Terminals.clear_line(t)
    Terminals.cmove_line_up(t)
    Terminals.clear_line(t)
end

function slow_print(str::String; time_delay = 0.0, style = :default)
    for char in str
        printstyled(char; color = style)
        sleep(time_delay)
    end
end
function slow_print(cw::CrayonWrapper; kwargs...)
    for str in cw.v
        slow_print(cw.c, str; kwargs...)
    end
end
function slow_print(crayon::Crayon, str::String; time_delay = 0.0, kwargs...)
    for char in str
        print(crayon, char)
        sleep(time_delay)
    end
end
function slow_print(crayon::Crayon, cw::CrayonWrapper; kwargs...)
    for str in cw.v
        slow_print(cw.c * crayon, str; kwargs...)
    end
end

function print_name_to_terminal(c::AbstractCharacter)
    println()
    if should_show_name(c)
        printstyled(nameof(c); color = name_style(c))
        printstyled(": "; color = dialogue_style(c))
    end
end

function print_dialogue_to_terminal(c::AbstractCharacter, str; kwargs...)
    print_name_to_terminal(c)
    slow_print(str; style = dialogue_style(c), kwargs...)
    request_continue()
    return nothing
end

function request_terminal_choice(c::AbstractCharacter, choices::Vector{String})
    print_name_to_terminal(c)
    println()
    # TODO: Make this work better for multi-line responses
    return request(RadioMenu(choices; scroll_wrap = true, cursor = '▷'))
end
