# Jell

A malleable narrative scripting language for building interactive stories and games.

### What sets Jell apart?
Most narrative scripting languages contain a small set of programming constructs (variables, conditional statements, jumps/gotos) to allow some additional user control. Jell takes user configurability to the extreme by embedding itself in a full, feature-rich programming language (Julia!). Every Jell script is valid Julia code. All valid Julia code can be inserted in a Jell script.

Also unlike most narrative scripting languages, Jell evaluates eagerly line-by-line instead of building up an abstract syntax tree for later evaluation. This is useful in combination with the Julia REPL, as you can manually step through and evaluate sections of your script. User choice branches of course aren't executed eagerly, but we use closures for the lazy evaluation instead of `eval`ing the AST.

### Jell's design philosophy
- **Write naturally**. Just because your script needs to be read by a computer doesn't mean it needs to look like code. Jell syntax matches pretty closely to how you'd naturally write a script.
- **Mold it to your use**. It's intimidating to start using a new tool not knowing whether it's missing features you might later need. If you start a project with Jell, you can rest easy knowing that any missing features can be easily tacked on in the future.
- **Borrow liberally, give freely**. The first working implementation of Jell was written in less than an hour because it was built on top of the work of other open-source authors who did all of the hard work. The Julia comminity hosts a wealth of free, open-source packages that can–and should!–be used to extend functionality in your Jell project. And if you write something that you think other people might find useful, slap on an open-source license and tell others about it!
- **Use anywhere**. While Jell can run as a standalone narrative engine (via JellTerminal), it can also be used in other game engines. Jell scripts can call compiled C functions and can themselves be compiled into C code and included in any project.

## Installation
1. Install [juliaup](https://github.com/JuliaLang/juliaup). This will install the Julia language and set it up for your machine. Alternatively, you can [download Julia directly](https://julialang.org/downloads/) and set things up manually.
2. Add Jell to your project environment.
    1. Open a terminal in the top-level folder of your project (can be any type of project, even an empty folder) and enter the command `julia` to start a Julia REPL session.
    2. Enter into Pkg mode of the REPL by typing `]`. You should see the `julia>` prompt change to `(@1.xx) pkg>`.
    3. Activate the project environment by entering `activate .` (note the `.`). You should see the prompt change to the folder name.
    4. Enter `add https://github.com/jonniedie/Jell`

## Usage
### Writing Jell Scripts
Jell scripts have the file extension `.jl` and consist of three sections:
1. Package import statements. For simple, standalone projects, this will probably just be the single line
    ```julia
    using Jell
    ```
2. Character definition. For complex projects, you'll likely want to define your own custom character type, but for simple projects (such as those that just print to the terminal), you can use the exported `BasicCharacter` and `BasicNarrator` types.
    ```julia
    tony = BasicCharacter(name="Tony the Talker")
    ```
3. Script. Basic dialog in scripts is entered naturally like:
    ```julia
    tony: "Hey, I'm talkin' here."
    ```
For more complex things like branching dialog, see the FAQ below.

### Defining Custom Character Types
`BasicCharacter` is useful for prototyping, but you'll probably want more functionality than just terminal printing. For this, you can make a type that subtypes `AbstractCharacter` and extend methods for any of the following functions:
```julia
show_dialogue(character::YourCharacterType, dialog::String) :: Nothing

request_choice(character::YourCharacterType, choices::Vector{String}) :: Int

dialogue_style(character::YourCharacterType) :: Symbol

nameof(character::YourCharacterType) :: String

name_style(character::YourCharacterType) :: Symbol

should_show_name(character::YourCharacterType) :: Bool
```
For the details of each function, read [the docstrings](src/character_interface.jl). For a worked example, see [this one](examples/custom_characters.jl).

### Running Jell Scripts in the Terminal
To run a Jell script all at once, open a terminal at your project folder and enter the command
```
julia --project=. path/to/your/script.jl
```
You can also open a persistant Julia REPL session with `julia --project=.` so you can run individual or groups of lines without having to run the whole script.

### Using Jell Scripts in a Game Engine
Big TODO on documenting this one.

## FAQ
```julia
# 1. Package import statements
using Jell

# 2. Character definition
Q = BasicCharacter(name="Q", color=:light_blue)
A = BasicCharacter(name="A", color=:light_magenta)

# 3. Script
Q: "What does the language look like?"
A: "You're lookin' at it, bud."

Q: "How do I implement player choice for branching narratives?"
A: @choose begin
    "Like this." => begin
        Q: "The code just had a weird `begin` thing. What's that about?"
        A: "It delimits a block of multiple lines to run."
        Q: "So I'm guessing there's going to be an `end` to close it out?"
        A: "Yup."
    end
    "Who knows, man." => Q: "I was hoping you did."
end

Q: "In that last example, how would one write an option that did nothing if chosen?"
A: @choose begin
    "Put a `nothing` after the arrow thing." => nothing
    "Put an empty `begin end` block after the arrow thing." => begin end
end

Q: "Are conditional statements supported?"
if iseven(2)
    A: "Yes."
    Q: "Okay, cool."
else
    A: "No, and we might have just broken math."
    Q: "I think you mean 'maths'."
    A: "I was hoping it would just be one of them."
end

Q: "Are conditionals allowed in a character response?"
A:  if iseven(2)
        "Still yes."
    else
        "Still no. And the math is still broken."
    end
Q: "Is there a... less bulky way to do that?"
A: (iseven(2) ? "Yep." : "Nope.")

Q: "What about variables? Can I define and use variables?"
some_variable = "Yes"
A: "$some_variable you can, $(Q.name)"

Q: "Let's say there are some lines I want to reuse, how would I do that?"
A: "First we'd have to define the block of lines we want to reuse..."

named_scene() = begin
    A: "This line will be run as soon as someone calls back to `named_scene`."
    Q: "Can `named_scene`... call itself?"
    A: @choose begin
        "I don't know, let's find out." => named_scene()
        "C'mon. We already broke a math." => begin
            Q: @choose begin
                "I fear nothing." => named_scene()
                "Yeah, you're right." => A: "Good thinking."
            end
        end
    end
end
    
A: "...then we'd have to call back to it."
named_scene()

Q: "Can a block be called before it's defined?"
try
    another_named_scene()
catch
    A: "I guess not"
end

another_named_scene() = begin
    Q: "Did this work?"
    A: "No, it didn't. Scenes have to be defined before they're called"
    Q: "Then how are we here?"
    A: "We may have just broken a different math."
end

Q: "What if I really want to call a named block that hasn't been defined yet?"
scene_that_holds_scenes() = begin
    what_about_this_time()

    what_about_this_time() = begin
        A: """You can if both the call site and the definition are wrapped in
            named scene. You can then just call that outer named scene right   
            after it's defined"""
        Q: """What if I just wrap my entire script in a `main() = begin ... end
            block?"""
        A: """If this is behavior you're going to want, that's probably a good
            idea. The only downside is that you won't be able to step through your code
            line-by-line in the Julia REPL."""
        Q: @choose begin
            "That's fine. I don't even know what that is." => A: "Fair enough."
            "Ah bummer." => nothing
        end
    end
end
scene_that_holds_scenes()

Q: """I often want to write a choice branch that returns back to itself. How can I do
    that?"""
A: """Make the choice a named scene and call back to it within the scene. Don't forget
    to call the named scene after creating it so it actually runs."""
returning_scene() = begin
    A: @choose begin
        "Like this." => returning_scene()
        "Just make sure there's an exit." => nothing
    end
end
returning_scene()

Q: "These 'named scenes' look and act an awful lot like function definitions."
A: "Shhhh. Don't tell anybody."
Q: """Why not just use the normal Julia `function your_function() ... end` syntax
    instead of `your_function() = begin ... end`?"""
A: """Because I don't really want this to read as code. Someone who just wants to write
    a branching narrative shouldn't have to know or care what a function is. Plus the
    `your_function() = begin ... end` makes it a lot easier to visually scan down the
    beginning of each line of the script to see where named scenes are defined."""

Q: "Why isn't this written Python?"
A: "Because I didn't want to write it in Python."
Q: "But I don't want to use anything that isn't Python."
A: "How did you make it this far, then?"
Q: "Like, in this document, or in life?"
A: "..."

Q: """If this is an interactive FAQ, shouldn't all of the `@choose`s be on my
    dialog, not yours? And shouldn't the choices be questions I want to ask?"""
A: @choose begin
    "Well... yes but, like, this seemed more natural as I was writing it." => nothing
    """I mean, none of this really makes sense as an interactive FAQ, though. Much of
        the important information isn't actually in the dialog and would therefore not
        get printed while running this.""" => nothing
end

Q: "Why'd you choose the name 'Jell'?"
A: @choose begin
    "I wanted Julia's (thereby, Jell's) `.jl` file extension to make sense." => nothing
    """Because I wanted people to think of it less as a rigid structure that
        they have to fit their story around and more like a malleable substance
        that can be shaped to their needs.""" => nothing
    """Because I was writing a game/story that takes place in an alternate
        history where computers are built from gooey, biological substances
        (hence, Jell) and can be trained to match desired input/output behavior
        rather than being built from silicon and programmed with discrete
        logic. Basically, what would computing look like if we had started from
        the point of modern machine learning? What does scalability mean when
        your hardware can grow by itself?""" => begin
        Q: @choose begin
            "That sounds weird." => A: "Hopefully!"
            "Huh, that sounds interesting." => begin
                A: """Thanks! It's also about unsustainable corporate growth
                    and consolidation and, like, people and society and..."""
                Q: "Honestly, I was just trying to be polite."
                A: "Oh."
            end
        end
        Q: "So couldn't you have used an existing tool for that?"
        A: """I probably could have. But there was a lot of custom stuff around
                skill checks that I wanted to be written alongside the
                narrative text and that didn't really work well with any tool I
                could find. I felt like I was going to have to bend my ideas to
                fit the tools rather than using the tools to fit to my
                ideas."""
    end
end

Q: "You've used triple quotes in the code a few times. What's that about?"
A: """Triple quotes are like single quotes, except you can make a new line and
        indent for code readability without the indentation showing up in your
        dialogue."""

Q: "This is feeling pretty long for an FAQ section."

infinite_loop_baby!() = begin
    A: "It would be even longer if I put us into an... INFINITE LOOP, BABY!"
    Q: "Please don't. We've already broken enough maths today."
    A: "Actually math is pretty good at infinity."
    Q: "I'm tired. I've had a long day."
    infinite_loop_baby!()
end

A: @choose begin
    "You think that's long?" => infinite_loop_baby!()
    "I thought about doing something right there, but nevermind."
end
```
