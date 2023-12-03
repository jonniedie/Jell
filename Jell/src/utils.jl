"""
    extract_ast(m::Module, filename::AbstractString;
        prettify = true,
        expand_macros = true,
    )
    extract_ast(filename::AbstractString; kwargs...)

Extract the abstract syntax tree of a julia file.
"""
function extract_ast(m::Module, filename::AbstractString;
                        prettify = true,
                        expand_macros = true,
                    )
    code = read(filename, String)
    ast = Meta.parse("begin $code end")
    if expand_macros
        ast = macroexpand(m, ast)
    end
    if prettify
        ast = MacroTools.prettify(ast)
    end
    return ast
end
extract_ast(f::AbstractString; kwargs...) = extract_ast(Main, f; kwargs...)
