# DEADC0DE Learnings

[Dead Code Overview](preservaction-deadc0de.md)

## Similarities

- Every Dead Code begins with `DEADCODE`. That is obviously the Magic Number.
- It often ends with `BRK`, after which a jump (`JML`) is executed. Occasionally, multiple `BRK`s are used in succession, suggesting that it is repurposed as a filler opcode. The question is whether a final `BRK` is even necessary, as it is sometimes missing.
- `NOP` is used within cheat options as padding or a filler opcode, so to speak, to maintain the visual structure of 8-byte hex blocks.

### Maximum Dead Code Length

In the available dead codes, between `40` and `60` opcodes are used. This does not provide any conclusions about a maximum length for dead codes. However, since no other cheats besides opcodes are allowed,

- the entire maximum number of cheats (`255`) is theoretically available.
- Subtracting the magic word leaves `254`.
- Each cheat is 8 ASCII bytes in length, totaling 2032 bytes.
- This could accommodate an average of 677 opcodes.

### Maximum Option Length

Optional cheats that can be placed within a dead code frame are, at least in known examples, always 2x8 bytes. However, I doubt that this limit is necessary, because multiple options can be used in succession. Including the dead code frame, the number of 8-byte code blocks is known as either even or odd.


### Learnings

- Endless loops slow down everything (including action replay ui) but do not block 
- Graphical settings can be overwritten by original cart (time of execution)
- Its inclear, when the dead code will be executed
- Its unclear, if the complete instruction set of the snes processor is supported or just a subset

## Design Patterns

### Timing and Synchronization with NOP

Inserting NOP commands to create delays, align code, or fill space without performing any operation.

```assembler
; Load a value into accumulator, prepare for a delay
LDA #$05          ; Load 8-bit value

; Apply multiple NOPs to create a delay
NOP               ; No operation
NOP               ; No operation
NOP               ; No operation

; Store the result in a memory address
STA $7E005C       ; Store Accumulator at address $7E005C (e.g., for infinite ammo)
```

### Register Initialization and Manipulation

Loading specific values into registers (like A, X, and Y) and using STA to store values at specific memory addresses.

```assembler
; Load the maximum health value into the accumulator
LDA #$63          ; Load immediate value 99 (e.g., max health)

; Store accumulator at the health memory address
STA $7E0010       ; Store Accumulator at address $7E0010 (health value)

; Initialize X register with zero
LDX #$0000        ; Load X with zero

; Store X register at another address, e.g., ammunition counter
STX $7E0050       ; Store X register at address $7E0050
```

### Conditional Logic and Loops

Using CPX, BNE, and BRA to create a loop structure with relative branching only.

```assembler
; Initialize X register to a starting value (e.g., lives)
LDX #$05          ; Set X register to 5 (starting number of lives)

; Loop: Decrement X until it reaches 1
CPX #$01          ; Compare X with 1
BEQ $04           ; If X equals 1, branch forward 4 bytes to refill lives

DEX               ; Decrement X register by 1
BRA $FA           ; Branch back 6 bytes to re-check X (loop)

; Code to refill lives
LDX #$05          ; Reset X register to 5 (refill lives)
```

### Polling and Checking Controller Input

This code reads select button state from Controller 1 ($4019) handles button presses inline (`JML`).

[Controller Button Bitmask](https://www.raphnet.net/divers/retro_challenge_2019_03/qsnesdoc.html)

```assembler
; Load the value at memory address $004219 (button states controller 1) into the accumulator
LDA $004219

; Mask the accumulator with #$20 (isolating bit 5)
AND #$20

; If the result is zero (bit 5 is not set), skip the next instruction         
BEQ $+5

; Jump to address $80FEEA if bit 5 is set (Select button pressed)
JML $80FEEA

; No Operation - does nothing, placeholder to maintain alignment
NOP
```

## Validation

Next, we need to verify the collected insights, wild guesses, and speculations. To do this, we’ll simply generate our own dead code. To make testing easier, we’ll build one that should work for every game, using standard functions of the SNES:

1. We wait until the Select button on Controller 1 is pressed.
2. As long as the button is held down, the screen goes black, and we put the processor into a loop.
3. When the button is released, the screen should be displayed again.

### Round #1

These are the corresponding instructions: 

```assembler
LDA $004219        ; Load value from $004219 into the accumulator
AND #$20           ; Mask to isolate bit 5 (Select button)
BEQ +18            ; If bit 5 is not set, skip the blanking and waiting loop (jump 18 bytes ahead)

; Enable forced blank if Select is pressed
LDA #$80           ; Load forced blank flag (bit 7 set) to blank the screen
STA $2100          ; Write to $2100 to enable forced blank (screen goes black)

; Wait loop to keep screen blank until $004219 is no longer 1
LDA $004219        ; Continuously load the value from $004219
CMP #$01           ; Compare with 1 to see if it’s still set
BEQ -5             ; Loop back 5 bytes if $004219 still equals 1

; Restore display when Select is released
LDA #$0F           ; Load max brightness (bit 7 cleared, full brightness)
STA $2100          ; Write to $2100 to disable forced blank and restore screen

; Continue normal execution
NOP                ; Placeholder for further instructions
```

And here is our personal dead code: 

```hex
AF194200
2920F012
A9808D00
21AF1942
00C901F0
FBA90F8D
0021EAEA
```

To make it a bit more secure and ensure that the game continues normally, we first save important registers, wrap our dead code around them, and also add the magic number:

```hex
DEADC0DE
0848DA5A
AF194200
2920F012
A9808D00
21AF1942
00C901F0
FBA90F8D
0021EAEA
6828FA7A
```

### Round #2

Removing preservation and restoration: 

```assembler
BRK
PHP
REP #$30
PHA
PHY
PHX
SEP #$30

LDA $004219        ; Load value from $004219 into the accumulator
AND #$20           ; Mask to isolate bit 5 (Select button)
BEQ +18            ; If bit 5 is not set (Select is pressed), skip the blanking and waiting loop

; Enable forced blank if Select is pressed
LDA #$80           ; Load forced blank flag (bit 7 set) to blank the screen
STA $2100          ; Write to $2100 to enable forced blank (screen goes black)

; Wait loop to keep screen blank until Select is released
LDA $004219        ; Continuously load value from $004219
AND #$20           ; Mask to isolate bit 5 (Select button)
BNE -6             ; Loop back 6 bytes if bit 5 is still set (Select button is still pressed)

; Restore display when Select is released
LDA #$0F           ; Load max brightness (bit 7 cleared, full brightness)
STA $2100          ; Write to $2100 to disable forced blank and restore screen

NOP                ; Placeholder for further instructions
```

```hex
DEADC0DE
AD194229
20F012A9
808D0021
AD194229
20D0FAA9
0F8D0021
EAEAEAEA
```

### Round #3

Once agein: Much more simple.

```hex
A9808D00
2180FBEA

00A9808D
002180FE

00A9008D
00210000
```
