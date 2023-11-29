# Jell

A malleable narrative scripting language for building interactive stories and games.

### What sets Jell apart?
Most narrative scripting languages contain a small set of programming constructs (variables, conditional statements, jumps/gotos) to allow some additional user control. Jell takes user configurability to the extreme by embedding itself in a full, feature-rich programming language (Julia!). Every Jell script is valid Julia code. All valid Julia code can be inserted in a Jell script.

### Jell's design philosophy
- **Write naturally**. Just because your script needs to be read by a computer doesn't mean it needs to look like code. Jell syntax matches pretty closely to how you'd naturally write a script.
- **Mold it to your use**. It's intimidating to start using a new tool not knowing whether it's missing features you might later need. If you start a project with Jell, you can rest easy knowing that any missing features can be easily tacked on in the future.
- **Use anywhere**. While Jell can run as a standalone narrative engine (via JellTerminal), it can also be used in other game engines. Jell scripts can call compiled C functions and can themselves be compiled into C code and included in any project.

### FAQ
```julia
# Bring the tools we need into scope
using JellTerminal

# Define some characters
Q = Character(name="Questioner")
A = Character(name="Answerer")

# FAQ
Q: "What does the language look like?"
A: "You're lookin' at it, bud."

Q: "How do I implement player choice for branching narratives?"
A: @choose [
    "Like this." => begin
        Q: "The code just had a weird `begin` thing. What's that about?"
        A: "It delimits a block of multiple lines to run."
        Q: "So I'm guessing there's going to be an `end` to close it out?"
        A: "Yup."
        end
    "Who knows, man." => Q: "I was hoping you did."
    ]

Q: "In that last example, how would one write an option that did nothing if chosen?"
A: "There are two ways of doing it, but my favorite is to..."
A: @choose [
    "...put a `nothing` after the arrow thing." => nothing
    "...omit the arrow thing altogether."
    ]

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
A: iseven(2) ? "Yep." : "Nope."

Q: "What about variables? Can I define and use variables?"
some_variable = "Yes"
A: "$some_variable you can, $(Q.name)"

Q: "Let's say there are some lines I want to reuse, how would I do that?"
A: "First we'd have to define the block of lines we want to reuse..."

named_scene() = begin
    A: "This line will be run as soon as someone calls back to `named_scene`."
    Q: "Can `named_scene`... call itself?"
    A: @choose [
        "I don't know, let's find out." => named_scene()
        "C'mon. We already broke a math." => begin
            Q: @choose [
                "I fear nothing." => named_scene()
                "Yeah, you're right."
                ]
            A: "Good thinking."
            end
        ]
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

Q: "Why isn't this written Python?"
A: "Because I didn't want to write it in Python."
Q: "But I don't want to use anything that isn't Python."
A: "Okay."

Q: "Why'd you choose the name 'Jell'?"
A: @choose [
    "I wanted Julia's (thereby, Jell's) `.jl` file extension to make sense."
    """Because I wanted people to think of it less as a rigid structure that
        they have to fit their story around and more like a malleable substance
        that can be shaped to their needs."""
    """Because I was writing a game/story that takes place in an alternate
        history where computers are built from gooey, biological substances
        (hence, Jell) and can be trained to match desired input/output behavior
        rather than being built from silicon and programmed with discrete
        logic. Basically, what would computing look like if we had started from
        the point of modern machine learning? What does scalability mean when
        your hardware can grow by itself?""" => begin
        Q: @choose [
            "That sounds weird." => A: "Hopefully!"
            "Huh, that sounds interesting." => begin
                A: """Thanks! It's also about unsustainable corporate growth
                    and consolidation and, like, people and society and..."""
                Q: "Honestly, I was just trying to be polite."
                A: "Oh."
                end
            ]
        Q: "So couldn't you have used an existing tool for that?"
        A: """I probably could have. But there was a lot of custom stuff around
                skill checks that I wanted to be written alongside the
                narrative text and that didn't really work well with any tool I
                could find. I felt like I was going to have to bend my ideas to
                fit the tools rather than using the tools to fit to my
                ideas."""
        end
    ]

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

A: @choice [
    "You think that's long?" => infinite_loop_baby!()
    "I thought about doing something right there, but nevermind."
    ]
```