# DEADC0DE Learnings

[Dead Code Overview](preservaction-deadc0de.md)

## Preparation

If you want to try disassembling yourself:

1. Clone the [Dispel Github-Repository](https://github.com/pelrun/Dispel) to get a disassembler.
2. Check if you can apply the [Special Edition Patch](src/dispel-special-edition.patch) to the repository using `git apply --check dispel-special-edition.patch`.
3. If everything is fine, apply the [Special Edition Patch](src/dispel-special-edition.patch) to the repository using `git apply dispel-special-edition.patch`.
4. Compile Dispel using `make`.
5. Test if it runs correctly (it should display instructions) using `./dispel`
6. Convert hex dumps to binary files using `xxd -r -p deadcode.hex deadcode.bin`.
7. You can now use Dispel to disassemble dead codes using `./dispel -A deadcode.bin > deadcode.asm`

## Similarities

- Every Dead Code begins with `DEADCODE`. That is obviously the Magic Number.
- It often ends with `BRK`, after which a jump (`JML`) is executed. Occasionally, multiple `BRK`s are used in succession, suggesting that it is repurposed as a filler opcode. The question is whether a final `BRK` is even necessary, as it is sometimes missing.
- `NOP` is used within cheat options as padding or a filler opcode, so to speak, to maintain the visual structure of 8-byte hex blocks.

### Blockwise Processing

Every Dead Code section (or "line") seems to need to be 4 bytes long and is otherwise filled with opcode 00 (`brk`). `brk` officially *can* have a operand, but must not. Because of this the disassembler struggles in interpreting the following sequence:

```hex
80827800
8F004200
```

It recognizes the `8F` from the second line as a operator belonging to the previous `brk` - but that's obviously wrong. Instead of:

```hex
80 8278
008F
0042
00
```

It should be read as:

```hex
80 8278
00
8F 004200
```

To accurately disassemble the binary code from the hex dumps, we needed to tweak the disassembler. It had to handle code fragments and process breaks without an operand. Check out the "Preparation" section above to see how it's done.

### Maximum Dead Code Length

In the available dead codes, between `40` and `60` opcodes are used. This does not provide any conclusions about a maximum length for dead codes. However, since no other cheats besides opcodes are allowed,

- the entire maximum number of cheats (`100`) is theoretically available.
- Subtracting the magic word leaves `99`.
- Each cheat line is 8 ASCII bytes in length, totaling `792` bytes. The Action Replay's RAM is 32KB, that should work out.
- This could accommodate an average of `264` opcodes with operands.

### Maximum Option Length

Optional cheats that can be placed within a dead code frame are, at least in known examples, always 2x8 bytes. However, I doubt that this limit is necessary, because multiple options can be used in succession. Including the dead code frame, the number of 8-byte code blocks is known as either even or odd.

### Injection Timing

The interesting question, of course, is when the dead codes are injected. I currently assume this happens at the same time the regular cheats would normally be applied. Just a guess, but I think (source 2 in mind) every standard cheat from Action Replay gets converted into a dead code first. That's probably why it doesn't make any difference.

Available sources (1, 2) suggest that the Action Replay taps into the `VINT` interrupt, executes cheats, and then resumes the ROM execution (for other ar versions of other consoles, though). `VINT` refers to the Vertical Interrupt or Vertical Blank Interrupt (`V-Blank`) on the SNES. This Non-Maskable Interrupt (`NMI`) is triggered by the SNES's Picture Processing Unit (`PPU`) at the end of each frame when the CRT monitor's beam returns from the bottom to the top. This allows changes to be made without causing visible graphical glitches, like screen flickering.

> Credits/Source
    (1) [Pro Action Replay reverse-engineering notes](https://gendev.spritesmind.net/forum/viewtopic.php?t=813)
    (2) [How the ... Action Replay ... work](src/par.txt)

### Learnings

- Endless loops slow down everything (including action replay ui) but do not block
- Graphical settings can be later overwritten by original cart (time of execution)
- Its unclear, if the complete instruction set of the snes processor is supported or just a subset

## Validation

Next, we need to verify the collected insights, wild guesses, and speculations. To do this, we’ll simply generate our own dead code. To make testing easier, we’ll build one that should work for every game, using standard functions of the SNES:

1. We wait until the Select button on Controller 1 is pressed.
2. As long as the button is held down, the screen goes black, and we put the processor into a loop.
3. When the button is released, the screen should be displayed again.
