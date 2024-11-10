# Project Preservaction

[Table Of Contents](preservaction-ui-toc.md)

## `DEADC0DE`

Different from the regular cheatcodes you find DEADC0DES for the Action Replay beginning from MK II. They look very unusual, but a quick google research shows: Nothing. The only thing you find about it in the Action Replay manuals, besides the deadcodes, is the following text:

> It is important to note that the codes should be in the correct order and no spaces between them. Deadcodes are the only situation where this is important. It is important that you enter the first line ‘DEADC0DE' as well as the rest. You can enter only one deadcode per game.

Another hint gives us the packaging of MK III:

> NEW - 'DEAD CODE' GENERATOR: "Dead Codes" are super cheats which effictively enables you to re-write whole sections of the game giving total control. No other product features "Dead Codes".

Sounds good, right? But where is the generator? How to write dead codes? Nobody knows.

### A nerdy flavor

The term "DEADC0DE" itself is a bit of a nerd joke: In a hex editor, it immediately catches the eye because it's not written as an ASCII byte sequence (8 bits per character) but in hex (4 bits per character). At the same time, the term fits perfectly with cheats: it sounds somewhat mysterious, dangerous, and overall pretty cool!

Confusingly, the term DEADC0DE or "dead code" has nothing to do with cheats at all. It refers to outdated program code that is no longer called and is essentially orphaned or dead. Typically, when refactoring a codebase, dead code should be removed.

### Reverse Engineering

During the reverse engineering of the Action Replay ROM code, I initially couldn't parse the deadcode blocks because they didn't match the rest of the byte sequence or structure. So what do deadcodes do? Let's summarize:

1. The sequence ‘DEADC0DE' appears before each deadcode and must not be omitted: this is reminiscent of a magic number often used in binary formats to perform typing.
2. The entire hex sequence must be entered: the deadcode is to be considered as a whole.
3. No spaces or separators may be inserted between the hex blocks: the parser is quite strict and doesn't accept any other symbols between the hex blocks, or perhaps an interpreter gets thrown off.
4. The order must be strictly followed. If the order is important, two things are true: first, it involves a certain logic, and second, apparently no validation takes place (or is impossible).

That validation isn't feasible could also be because there are extremely few commonalities between different deadcode sequences. The only constant that keeps recurring is the magic number: ‘DEADC0DE'.

### That's logical!

The matter of logic is further supported by the description of the deadcode itself: "Level skip - When select is pressed your player moves to the next stage"... WHEN = condition, after which the commands tied to the condition would typically be defined.

How do you incorporate logic into this sequence of memory addresses, registers, and so on? After all, things are only being written or overwritten. ‘DEADC0DE' thus initiates a certain mode, that's clear. Let's assume it's the "logic mode." The first thing that came to mind was a kind of simple scripting language:

1. Magic number to switch into logic mode
2. A combination of memory address and value (as usual XXXXXX:YY), except that nothing is written but monitored.
3. If the defined memory address contains the value, it switches back to write mode, and the remaining address-value combinations are executed.

For a small logic, that could suffice, and it would definitely be feasible. So I looked at the address-value combinations: which memory areas are being addressed? Well, then it got really wild! It was a mix of WRAM, I/O registers, expanded RAM, ROM, and HiROM. Completely jumbled; at least for me, there was no logic, sequence pattern, or anything to see. Everything very random, even if querying I/O registers would fit the condition "button pressed." Can a cartridge even read these registers or interrupts? Strange.

### What if?

Let's take a look at the initial mentoned description by Datel itself: "It enables you to rewrite whole sections of the game". In other words it have to be scripting of some kind. What if Action Replay DEADC0DE is a binary code sequence encoded in hex? Now everything make sense:

1. Structure of the Data:
   - The data is formatted in a way typical of machine or assembly code. They consist of hexadecimal numbers that could represent sequential instructions and operands.
   - The combination of 8-digit hexadecimal numbers suggests that these could be opcode sequences, where certain bytes represent commands and others represent operands.

2. Known SNES Opcode Patterns:
   - The SNES uses the `65C816` CPU, which is an extension of the 65C02 processor and supports 16-bit operations.
   - Some of the hex values of dead codes actually correspond to known opcodes for this CPU. For example:
     - `08` corresponds to `PHP` (Push Processor Status onto Stack).
     - `C2 30` corresponds to `REP #$30` (Reset Processor Status Bits).
     - `48` corresponds to `PHA` (Push Accumulator onto Stack).
     - `5A` corresponds to `PHY` (Push Y Register onto Stack).
     - `DA` corresponds to `PHX` (Push X Register onto Stack).
     - `E2 30` corresponds to `SEP #$30` (Set Processor Status Bits).
     - `AF` is an opcode for `LDA` (Load Accumulator) with long addressing.
     - `29` corresponds to `AND` (Logical AND with Accumulator).
     - `F0` corresponds to `BEQ` (Branch if Equal).
     - `1A` corresponds to `INC A` (Increment Accumulator).
     - `68` corresponds to `PLA` (Pull Accumulator from Stack).
     - `28` corresponds to `PLP` (Pull Processor Status from Stack).
     - `5C` corresponds to `JML` (Jump Long).
   - These matches suggest that the data could represent assembly instructions.

3. Sequence and Logic:
   - The order of opcodes and operands forms a logical sequence of commands typical of a subroutine or patch.
   - It begins with saving the processor state (e.g., `PHP`, `PHA`, `PHX`, `PHY`) and ends with restoring it (`PLA`, `PLX`, `PLY`, `PLP`), which is typical for a subroutine structure.

4. Known Patterns:
   - Many SNES cheats modify the program code directly to achieve certain effects, such as adding items, changing status values, or activating debug modes.
   - The use of commands like `LDA`, `STA`, `INC`, and conditional jumps (`BEQ`, `BNE`) is typical for such cheats. But is executed by the cheat device.

5. Memory Addresses:
   - Addresses like `$7E0000` to `$7FFFFF` are the WRAM (Work RAM) in the SNES, used by the game to store variables and status values.
   - Writing to these areas can have direct effects on the game state, which is common in cheats.

### Conclusion

How crazy is that!? So deadcodes are nothing more than code injection! Unbelievable, right? What would be unthinkable with today's game consoles - considering the complexity of operating systems and data and cybersecurity - was entirely negligible in the case of the Super Nintendo: no operating system, no internet access, no permanent storage...

By the way, that's the reason why I enjoy working with retro hardware so much: there are always surprises, things you would never have expected. You can do things with these devices that would be cool today but unthinkable - because they're dangerous. And it's another reason why the Action Replay is the coolest accessory for the SNES: Game Genie & Co. will never come out of its shadow.

Thus, the next phase is initiated: as part of the Preservaction project, I will investigate all known deadcodes and, of course, venture one or two experiments :smile: