# Project Preservaction

[Table Of Contents](preservaction-toc.md)

## Regular Action Replay Cheats

The **Action Replay** cheat format for the SNES (Super Nintendo Entertainment System) is a structured hexadecimal code that allows users to modify specific memory addresses during gameplay. This enables cheats such as infinite health, unlimited ammo, or unlocking items. The cheat format consists of two main components:

### Single-Line Codes

An Action Replay code on the SNES is typically structured as follows:

```
XXXXXX:YY
```

Where:
- **`XXXXXX`** – A 6-digit hexadecimal memory address that specifies where in the SNES’s RAM the value will be modified.
- **`YY`** – A 2-digit hexadecimal value to be written to that address.

**Examples**

Here are some typical SNES Action Replay codes:

- **Infinite Lives**: `7E1490:09`
  - Sets the player’s life count to `09`.
  
- **Max Health**: `7E0C28:63`
  - Sets the player’s health to 99 (hexadecimal `63`).

- **Unlimited Ammo**: `7E0B4C:FF`
  - Sets the player’s ammunition to 255 (hexadecimal `FF`).

### Multi-Line Codes

Multi-line Action Replay codes are used to modify multiple memory addresses simultaneously. Each line targets a different address, allowing for more complex cheats:

```
XXXXXX:YY
XXXXXX:YY
```

Where:
- **`XXXXXX`** – A 6-digit hexadecimal memory address that specifies where in the SNES’s RAM the value will be modified.
- **`YY`** – A 2-digit hexadecimal value to be written to that address.

**Example**

```
7E0C28:63
7E0C29:00
```

- **Infinite Lives**: Line #1
  - Sets the player’s life count to `09`.
  
- **Zero Damage**: Line #2
  - Sets the player’s damage to 0 (hexadecimal `00`).

### How It Works

When an Action Replay code is active, the device (or emulator) monitors the game’s memory in real-time. Each time the game accesses the specified memory address (`XXXXXX`), the Action Replay device intercepts and forces the specified value (`YY`) to overwrite the data at that address.

For example: The game accesses memory at `0x7E0C28`. If the code `7E0C28:63` is active, the Action Replay ignores the real memory and responds with `0x63` (99 in decimal, which could set maximum health or another stat in the game).

> **Common Prefixes:** `7E` or `7F` – These prefixes are for addresses in the SNES WRAM (Work RAM), where dynamic game variables such as health, lives, inventory, and position are often stored.

## Special Deadcode Cheats

`DEADC0DE` cheats for the Action Replay are a unique and powerful class of cheats that are neither well-documented nor widely known. Until now. These cheats stand apart from standard Action Replay codes due to their potential to significantly alter gameplay in complex ways beyond simple memory modifications.

Due to the depth, potential, and complexity of this cheats, they merit their own[`DEADC0DE` chapter](preservaction-ui-deadc0de.md). This dedicated section will also cover the story behind the reverse engineering of deadcode cheats.

## Game Genie

The **Game Genie** is a cheat device for the SNES that operates differently from the **Action Replay**. While both devices are used to modify game data to enable cheats, they do so in distinct ways and have unique code formats:

Game Genie codes work by intercepting game code instructions from the cartridge ROM before they reach the console, allowing modification of hardcoded values, such as lives, power-ups, or enemy strength. 

Unlike Action Replay codes, which directly specify memory addresses and values, Game Genie codes use an encryption algorithm to obscure the actual memory address and value. This encryption was designed to prevent players from easily discovering and modifying memory addresses without using the Game Genie device, adding a layer of security and control over the cheat codes.

### Code Format

A typical SNES Game Genie code consists of 8 characters, following this format:

```
XXXX-YYYY
```

Where (from the user’s perspective):

- `XXXX` specifies the address offset within the game’s ROM (Read-Only Memory).
- `YYYY` defines the value to be substituted at that address.

In reality, the code-value pair isn’t very different from the Action Replay’s format. After decoding, the decrypted code also consists of an `XXXXXX` memory address and a `YY` value (both in hex).

### Code Converter

The **MK III** model of the Action Replay device includes a feature that can convert up to 5 Game Genie codes into Action Replay format. In this case it works like a Game Genie and modifies the game's ROM.
