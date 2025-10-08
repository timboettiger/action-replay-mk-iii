# Project Preservaction

[Table Of Contents](preservaction-toc.md)

## Action Replay Cheatcode Types

The **Action Replay** cheat format for the SNES (Super Nintendo Entertainment System) is a structured hexadecimal code that allows users to modify specific memory addresses during gameplay. This enables cheats such as infinite health, unlimited ammo, or unlocking items. The cheat format consists of two main components:

### Single-Line Codes

An Action Replay code on the SNES is typically structured as follows:

```
XXXXXX:YY
```

Where:
- **`XXXXXX`** is a 6-digit hexadecimal memory address that specifies where in the SNES's RAM the value will be modified.
- **`YY`** is a 2-digit hexadecimal value to be written to that address.

**Examples**

Here are some typical SNES Action Replay codes:

- `7E1490:09` **Infinite Lives**: Sets the player's life count to `09`.
- `7E0C28:63` **Max Health**: Sets the player's health to 99 (hexadecimal `63`).
- `7E0B4C:FF` **Unlimited Ammo**: Sets the player's ammunition to 255 (hexadecimal `FF`).

### Multi-Line Codes

Multi-line Action Replay codes are used to modify multiple memory addresses simultaneously. Each line targets a different address, allowing for more complex cheats:

```
XXXXXX:YY
XXXXXX:YY
```

Where:
- **`XXXXXX`** is 6-digit hexadecimal memory address that specifies where in the SNES's RAM the value will be modified.
- **`YY`** is 2-digit hexadecimal value to be written to that address.

**Example**

```
7E0C28:63
7E0C29:00
```

1. Line **Infinite Lives**: Sets the player's life count to `09`.
2. Line **Zero Damage**: Sets the player's damage to 0 (hexadecimal `00`).

### Deadcode Cheats

`DEADC0DE` cheats for the Action Replay are a unique and powerful class of cheats that are neither well-documented nor widely known — until now. These cheats stand apart from standard Action Replay codes due to their potential to significantly alter gameplay in complex ways beyond simple memory modifications.

Simple disassembly of the first blocks following `DEADC0DE` translate into strange or seemingly nonsensical instructions. The key is: They are not part of the actual code to be executed but rather serve as a setup or hook mechanism and contain a length information as well.

#### Code Format

**Header Structure**

The header format is fixed and always begins with the magic word `DEADC0DE`, followed by a structured `DWORD` (4-byte) block that contains a hook address to jump into the cheat code (this activates the execution of the cheat code), and a length byte that indicates how many `DWORD` blocks follow:

```
  ______________________ Signature DWORD
 /  /  /  /
DE AD CO DE
9A 89 87 00
 \  \  \  \_____________ Length Byte (00 indicates variable length cheat code)
  \  \  \_______________ Lo Memory Address Byte
   \  \_________________ Hi Memory Address Byte
    \___________________ Bank Address Byte
```

**Prologue Structure**

Prologue saves CPU state (A and P), sets 8-bit mode.

```
48 08 E2 30
 \  \  \__\_____________ Opcode SEP #$30 - Set Processor Status bits 0x30
  \  \__________________ Opcode PHP - Push Processor Status (P register / flags) onto the stack
   \____________________ Opcode PHA - Push Accumulator (A) onto the stack
```

`SEP #$30` sets M = 1 and X = 1, than means it switches A (accumulator) and index registers (X, Y) to 8-bit mode. This is common in SNES IRQ or hook routines to ensure consistent data width.

**Cheat Code Block**

This overwrites the existing value at $7E:7024 with 00, replacing whatever was there before.

```
A9 00 8F 24
 \  \  \  \_____________ Low Address Byte - Part of the STA instruction
  \  \  \_______________ Opcode STA - Store A to WRAM address $7E:7024
   \__\_________________ Opcode LDA #$00 - Load immediate 0 into A.
70 7E EA EA
 \  \  \__\_____________ Opcode NOP - Padding (Ignored)
  \  \__________________ Bank Address Byte - Part of the STA instruction
   \____________________ High Address Byte - Part of the STA instruction
```

**Epilog Structure**

Epilog restores CPU state/mode, acknowledges IRQ, and jumps back to $C0:FD15.

```
28 68 AF 11
 \  \  \  \_____________ Low Address Byte - Part of the LDA instruction
  \  \  \_______________ Opcode LDA - Load A from address
   \  \_________________ Opcode PLA - Pull (Restore) Accumulator
    \___________________ Opcode PLP - Pull (Restore) Processor Status
42 00 5C 15
 \  \  \  \_____________ Low Address Byte - Part of the JML instruction
  \  \  \_______________ Opcode JML - Long Jump to address
   \  \_________________ Bank Address Byte - Part of the LDA instruction
    \___________________ High Address Byte - Part of the LDA instruction
FD C0 00 00
 \  \  \__\_____________ Opcode NOP - Padding (Ignored)
  \  \__________________ Bank Address Byte - Part of the JML instruction
   \____________________ High Address Byte - Part of the JML instruction
```

#### Fixed-Length Deadcode Cheats

Fixed-Length `DEADC0DE` cheats: The last byte of the address line is greater than `00`, followed by the exact number of `DWORD` blocks defined by that last address-line byte.

#### Variable-Length Deadcode Cheats

Variable-Length `DEADC0DE` cheats: The last byte of the address line is `00`, followed by an undefined number of `DWORD` Cheat Code Blocks.

These cheats have a clear structure:
1. Header (always 8 bytes)
2. Prologue
3. `n` Cheat Code Blocks (mostly 8 bytes)
4. Epilog

The **Prologue** prepares the CPU state in the way required by the Cheat Code Blocks, while the **Epilogue** restores it to the state expected by the game. The **Cheat Code Blocks** contain the actual (mostly simple) cheat logic, but they can vary in both length and complexity.

## Game Genie

The **Game Genie** is a cheat device for the SNES that operates differently from the **Action Replay**. While both devices are used to modify game data to enable cheats, they do so in distinct ways and have unique code formats:

Game Genie codes work by intercepting game code instructions from the cartridge ROM before they reach the console, allowing modification of hardcoded values, such as lives, power-ups, or enemy strength.

Unlike Action Replay codes, which directly specify memory addresses and values, Game Genie codes use an encryption algorithm to obscure the actual memory address and value. This encryption was designed to prevent players from easily discovering and modifying memory addresses without using the Game Genie device, adding a layer of security and control over the cheat codes.

### Code Format

A typical SNES Game Genie code consists of 8 characters, following this format:

```
XXXX-YYYY
```

Where (from the user's perspective):

- `XXXX` specifies the address offset within the game's ROM (Read-Only Memory).
- `YYYY` defines the value to be substituted at that address.

In reality, the code-value pair isn't very different from the Action Replay's format. After decoding, the decrypted code also consists of an `XXXXXX` memory address and a `YY` value (both in hex).

### Code Converter

The **MK3** model of the Action Replay device includes a feature that can convert up to 5 Game Genie codes into Action Replay format. In this case it works like a Game Genie and modifies the game's ROM.
