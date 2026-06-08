# Project Preservaction

[Table Of Contents](preservaction-toc.md)

## Pro Action Replay MK3: ROM Reverse Engineering

This document analyses the 128 KB EPROM image `Pro Action Replay MK3 (Europe) (Unl).sfc` byte by byte, based on the disassembly in [rom/](rom/). It complements [preservaction-pcb.md](preservaction-pcb.md) (hardware) and [preservaction-prologue-epilogue.md](preservaction-prologue-epilogue.md) (cheat format) by adding a full software perspective.

> **Disassembly source:** [rom/Pro Action Replay MK3 (Europe) (Unl).asm](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm) (58,346 lines, 65C816).

---

### 1. Cartridge Header

The vector area of bank `$80` contains two readable ASCII strings:

| Address    | Bytes                                          | Meaning               |
|------------|------------------------------------------------|-----------------------|
| `$80:FFB0` | `31 39 2F 37 2F 39 35`                         | **"19/7/95"**         |
| `$80:FFC0` | `44 41 4D 4F 4E 20 42 41 52 57 49 4E 20 39 35` | **"DAMON BARWIN 95"** |

The regular SNES cartridge header (Map Mode, ROM Size, SRAM Size, etc.) is **not filled in** for this unlicensed device. The SNES CPU starts directly via the reset vector, with no header validation.

#### 1.1 Who is Damon Barwin?

**Damon Barwin** was a hardware engineer at **Datel Electronics Ltd.** (Stoke-on-Trent, UK), the company behind the Action Replay product line. An independent source from 1999 confirms his role as a Datel hardware designer in the context of another well-known Datel product:

> *"I was able to open up a MegaMem cartridge (made by Datel) to see how they had been able to bypass Nintendo's logo. They used a PIC12C508 to toggle memory banks on power up. **Damon Barwin and Alex Edge from Datel created the original device.**"*
>
> Ken Kaarvik, *Ken's Gameboy and PIC Projects Page*, last updated 1999-07-14.
> See [docs/oocities-kkaarvik-gameboy.html](docs/oocities-kkaarvik-gameboy.html) for the archived copy of the oocities source.

The MegaMem was a Game Boy adapter that bypassed Nintendo's boot logo check. It used the same conceptual design approach as the later PAR MK3 SNES adapter: an inline microcontroller that switches memory banks at boot time. The fact that the codename **"DAMON BARWIN 95"** appears in the MK3 ROM header strongly suggests Barwin was involved with the MK3 as well (at least with the EU release dated 19 July 1995), either as hardware designer, ROM author, or lead engineer.

This information is valuable because Datel published almost no internal documentation. The codename in the header is one of the few verifiable pieces of evidence of authorship.

**Backup sources in this repository:**
- [docs/oocities-kkaarvik-gameboy.html](docs/oocities-kkaarvik-gameboy.html): rendered HTML content with the quote (original path: `https://www.oocities.org/kkaarvik/gameboy.html`).
- [docs/oocities-kkaarvik-gameboy.html.tmp](docs/oocities-kkaarvik-gameboy.html.tmp): geocities archive wrapper variant (original path: `https://www.oocities.org/kkaarvik/gameboy.html.tmp`).

---

### 2. Interrupt Vector Table (`$80:FFE0`-`$80:FFFF`)

| Vector        | Address | Value   | Handler                                 |
|---------------|---------|---------|-----------------------------------------|
| Native COP    | `$FFE4` | `$FDAA` | (likely unused, `FD AA` filler pattern) |
| Native BRK    | `$FFE6` | `$AAFD` | **IRQ/BRK** at `$80:AAFD`               |
| Native ABORT  | `$FFE8` | `$FFFF` | unused                                  |
| Native NMI    | `$FFEA` | `$905B` | **Main ROM NMI** at `$80:905B`          |
| Native IRQ    | `$FFEE` | `$FFFF` | unused                                  |
| Emul COP      | `$FFF4` | `$FFFF` | unused                                  |
| Emul ABORT    | `$FFF8` | `$FFFF` | unused                                  |
| Emul NMI      | `$FFFA` | `$FFFF` | unused                                  |
| **Emul RESET**| `$FFFC` | `$8000` | **Boot entry** at `$80:8000`            |
| Emul IRQ/BRK  | `$FFFE` | `$FFFF` | unused                                  |

The SNES always starts in emulation mode, so it jumps to `$80:8000`. The "PAR NMI" (active during cheat mode) does **not** sit in the vector table. Instead the Replay hardware injects it dynamically into the running game's NMI chain via code slots 5 and 6 (see section 8.2).

---

### 3. ROM Layout (LoROM, 4 x 32 KB)

```
+--------------------------------------------------------------+
| Bank $80 ($8000-$FFFF)   12,884 disassembly lines            |
|   $8000-$8FFF  Boot, init, main loop                         |
|   $9000-$9FFF  NMI handler, cheat slot programmer, trampoline|
|   $A000-$AFFF  Game launch, PAR NMI, IRQ handler             |
|   $B000-$BFFF  Utility cluster (joypad, render, strings)     |
|   $C000-$D2FF  Menu strings (ASCII)                          |
|   $FFB0-$FFFF  Header strings plus vectors                   |
+--------------------------------------------------------------+
| Bank $81 ($8000-$FFFF)   13,598 lines                        |
|   Tile data and font glyphs (16 KB pre-rendered VRAM upload) |
+--------------------------------------------------------------+
| Bank $82 ($8000-$FFFF)   15,480 lines                        |
|   Tile data and cheat database strings                       |
+--------------------------------------------------------------+
| Bank $83 ($8000-$FFFF)   16,384 lines                        |
|   Cheat database and padding ($30 30 30 30 ...)              |
+--------------------------------------------------------------+
```

Banks `$00`-`$3F` and `$80`-`$BF` mirror to the same data, as is typical for LoROM (A23 mirror). The ROM can be addressed under either bank set, which the trampoline (section 7) exploits.

---

### 4. Standard SNES Initialisation (`$80:8000`-`$80:8124`)

Textbook reset sequence, documented in phases.

#### 4.1 CPU and register setup ([lines 1 to 24](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:1))

```asm
80/8000: sei                       ; interrupts off
80/8001: sep #$20 / sep #$10       ; 8-bit A/X/Y
80/8005-802C: stz $4200-$420C      ; clear all CPU registers
                                   ; (NMI, HVIRQ, DMA, HDMA, timer)
80/802C-8035: stz $2140-$2143      ; APU communication ports
80/8038: lda #$80 / sta $2100      ; force blank (PPU off, screen black)
80/803D: clc / xce                 ; native mode (65C816 active)
```

#### 4.2 Direct page and stack ([lines 28 to 34](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:28))

```asm
80/8045: lda #$0000 / pha / plb    ; data bank = $00
80/804A: lda #$6100 / tcd          ; direct page = $6100  (MK3-specific)
80/804E: lda #$60FF / tcs          ; stack top  = $60FF   (MK3-specific)
```

> **Important.** Direct page and stack sit in the range `$6100` and `$60FF`, not in the usual `$0000`-`$00FF`. This is the **internal Replay SRAM** (HY62256A, 32 KB), addressed via banks `$00/02/04/06:$6000-$7FFF`. All zero-page references in the code (`$94`, `$1B`, and so on) actually map to `$6194`, `$611B`, etc., that is, the adapter's own SRAM, **not** SNES WRAM.

#### 4.3 Full PPU clear ([lines 39 to 94](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:39))

Every register from `$2101`-`$2133` is explicitly set to 0, with double writes for 16-bit registers like `$210D`, `$210E`, `$2111`, and `$2112`.

#### 4.4 First Replay IO accesses ([lines 98 and 121](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:98))

```asm
80/8107: sta $206000               ; Control C = 0 (BIOS/PAR NMI mode)
80/8121: lda #$01 / sta $4200      ; enable NMI generation
```

At this point the SNES is ready and the cheat hardware is in management mode.

---

### 5. Magic-Word Warm and Cold Boot Detection

Starting at `$80:8124`, the code checks whether the **magic word `$ABCD`** is set at direct-page address `$94` (physically `$00:6194` in Replay SRAM):

```asm
80/8126: lda $94 / cmp #$ABCD
80/812B: beq $8140                ; magic present: warm boot
                                  ; otherwise: cold init via $BBDE/$BA61
```

This check happens **four times** at strategic points ([lines 112, 122, 173, 237](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:112)) to choose between paths. The magic word itself is only written at the end of initialisation, at [`$80:9668`](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:2665):

```asm
80/9668: lda #$ABCD / sta $94
```

**Effect:**

| Situation                             | `$94`     | Behaviour                           |
|---------------------------------------|-----------|-------------------------------------|
| First-ever boot                       | not $ABCD | Full SRAM init / splash screen      |
| Switch Bottom-Mid-Bottom (RAM intact) | $ABCD     | Warm boot, straight to main menu    |
| SRAM corruption                       | not $ABCD | Cold boot path, all user data reset |

As a side effect this also serves as an **implicit hardware test**. An emulator without proper 32 KB SRAM at the Replay mapping cannot persist the word, while a real MK3 keeps it intact even across brief power interruptions (CMOS SRAM with backup).

---

### 6. PAL/NTSC Detection

The only hardware sense point of the SNES itself is at [`$80:8226`](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:222):

```asm
80/8226: lda $213F                 ; PPU status (NTSC/PAL plus slow-CPU flag)
80/8229: and #$10                  ; bit 4: 1=PAL, 0=NTSC
80/822B: sta $34                   ; raw bit pattern ($00 or $10)
80/822D: beq $8236
80/822F: lda #$01 / sta $44        ; $44 = PAL flag
80/8236: lda #$00 / sta $44        ; $44 = NTSC flag
```

The result is stored twice:
- `$34` (DP), the raw bit pattern, used in the NMI handler to choose the **frame counter modulo** (`$3B` = 59 for NTSC, `$31` = 49 for PAL, see section 8.1).
- `$44` (DP), a boolean flag translated at **game launch** into Control A bits 6 to 7 (`$80` for PAL, `$40` for NTSC, see section 7).

---

### 7. Menu to Game Transition: The RAM Trampoline (`$80:96A0`)

This is the most critical code location in the entire ROM. When the user selects "Start Game" in the menu, the Replay ROM has to remove itself from the address space and map in the game cartridge instead, all while its own code is still executing.

```asm
80/9698: lda #$00 / sta $4200      ; NMI off
80/969D: lda #$00 / sta $10001C    ; Control A cleared
80/96A3: sta $206000               ; Control C = 0 (keep BIOS mode active)
80/96A7: lda $44 / cmp #$00        ; PAL or NTSC?
80/96AB: beq $96B5
80/96AD: lda #$80 / sta $10001C    ;   force PAL (bits 6-7 = 10b)
80/96B3: bra $96BB
80/96B5: lda #$40 / sta $10001C    ;   force NTSC (bits 6-7 = 01b)
80/96BB: rep #$10                  ; 16-bit index
80/96BF: ldx #$0000                ; --- trampoline copy loop (4 KB) ---
80/96C2: lda $0096D4,X             ;   read from ROM ...
80/96C6: sta $001000,X             ;   ... write to SNES WRAM ($7E:1000)
80/96CA: inx
80/96CB: cpx #$1000
80/96CE: bne $96C2
80/96D0: jmp $001000               ; *** jump into the RAM copy ***

; --- from here code runs from WRAM; ROM may now disappear ---
80/96D4: rep #$20
80/96D6: lda #$0000 / tcd          ; direct page back to $0000 (standard)
80/96DA: pha / plb                 ; data bank back to $00
80/96DC: sep #$30                  ; 8-bit
80/96DE: lda #$80 / sta $2100      ; force blank
80/96E3: lda #$01 / sta $10003C    ; Control B = 1 ("game is starting")
                                   ; (Datel IC removes Replay ROM,
                                   ; maps game cart into $80-$BF)
80/96E9: sec / xce                 ; emulation mode (game expects this)
80/96EB: jmp ($FFFC)               ; *** read game cart reset vector ***
                                   ; and jump there
```

The trampoline is deliberately copied with **4 KB** length (`cpx #$1000`), even though only about 30 bytes are actually code. The most likely reasons are to avoid cache aliasing or bus race conditions, or simply to reserve room for a larger sequence in future revisions.

> After `jmp ($FFFC)` the Replay ROM is no longer visible in the address space. Only the Datel IC with its code slots keeps watching the bus and injects cheats at the registered addresses.

---

### 8. Interrupt Handlers

#### 8.1 Standard NMI (`$80:905B`), runs in menu mode

```asm
80/905B: sei / phx / phy / pha / php
80/9060: jsr $BBEF                 ; audio/sub-IO update
80/9063: sep #$30
80/9065: lda $31 / clc / adc #$01
80/906A: sta $31                   ; $31++ (frame counter LSB)
80/906C: lda $34 / bne $9078       ; PAL?
80/9070: lda $31 / cmp #$3B        ;   NTSC: roll at 59 (60 frames/s)
80/9074: bne $9089
80/9076: bra $907E
80/9078: lda $31 / cmp #$31        ;   PAL: roll at 49 (50 frames/s)
80/907C: bne $9089
80/907E: lda #$00 / sta $31        ; reset LSB
80/9082: lda $30 / inc A / sta $30 ; $30++ (seconds counter)
80/9089: sep #$20
80/908B: lda $F6 / beq $90AC       ; scroll-enable flag?
80/908F:   ; (if yes:) increment scroll position $F4/$F5
80/9098:   sta $2111 / sta $2111   ;   BG2 H-scroll (double write, 16 bits)
80/90A2:   sta $2112 / sta $2112   ;   BG2 V-scroll
80/90AC: plp / pla / ply / plx / cli / rti
```

A classic **60 Hz tick** with a seconds accumulator and optional background scrolling for animated menu effects (for example, the splash screen star background).

#### 8.2 PAR NMI (`$80:AE12`), runs in cheat mode

This handler is **not** reached via the vector table. The Datel IC injects it dynamically into the NMI chain of the running game via code slots 5 and 6. According to the PCB documentation, slots 5 and 6 are permanently reserved for the NMI hook.

**Entry point.** Slot 5/6 are programmed with the constant `#$AE12` (see [`$80:912B`](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm)), so the redirected NMI vector points at `$00:AE12`, not `$AE20`. The first eight instructions are a full register save before the actual handler logic kicks in:

```asm
80/AE12: nop                          ; alignment after the preceding rts at $AE11
80/AE13: php                          ; save processor status
80/AE14: rep #$20 / rep #$10          ; switch to 16-bit A / X / Y
80/AE18: pha / phy / phx              ; save A, Y, X (16-bit)
80/AE1B: sep #$20 / sep #$10          ; back to 8-bit
80/AE1F: phd                          ; save direct page register
80/AE20: phb                          ; save data bank register
80/AE21: rep #$20 / lda #$6100 / tcd  ; DP back to MK3 SRAM
80/AE27: sep #$20
80/AE29: lda #$00 / sta $206000       ; Control C = 0 (BIOS execution on)
80/AE2F: lda #$40 / sta $007000       ; signal latch in Replay SRAM
80/AE35: lda #$00 / sta $008000       ; Control D = 0 (NMI entry ACK)
80/AE3B: lda $1B / bne $AE99          ; joypad flag check (manual read at $AE45)
80/AE3F: jsr $7033                    ; *** run cheat patch list ***
80/AE42: jmp $7167                    ; *** return via SRAM trampoline ***
```

`$7033` and `$7167` live in the **Replay SRAM**, not in ROM. They are dispatched on the cheat-engine side: the trampoline at `$7167` either falls through into the input-decode loop at `$80:AE99`, or jumps to the per-frame engine at `$80:AECC -> $715F` (SRAM) which in turn re-enters the ROM at `$80:AFD0` for the LED update and NMI-exit. Starting at `$AE45` there is a **manual joypad read** via `$4016` and `$4017` (16-bit shift through `ror $4F` and `ror $51`), because auto-joypad is not guaranteed to be available during a PAR NMI. The decoded pad word then drives the trainer combos and LED engine -- see section 20 for the full decode table and the runtime behaviour.

**Handler footprint.** Even though `$AE12`-`$AE42` is the visible entry, the full set of ROM bytes the PAR-NMI execution may fetch -- directly or via SRAM-trampoline re-entry -- spans **`$80:AE12`-`$80:B3F6`** (1509 bytes). The breakdown:

| Range           | Role                                                               |
|-----------------|--------------------------------------------------------------------|
| `$AE12`-`$AE42` | NMI entry, register save, control writes, cheat-patch dispatch     |
| `$AE43`-`$AE98` | Manual joypad read (16-bit shift via `$4016`/`$4017`)              |
| `$AE99`-`$AECE` | Combo decoder (table-driven dispatch)                              |
| `$AECF`-`$AF4F` | Combo handlers (Select + R / L / Start / X / Y / A / B / Up / Down)|
| `$AF50`-`$AFCE` | Trainer-activate path (Select + R follow-up)                       |
| `$AFD0`-`$B083` | Per-frame LED engine (see §20.3)                                   |
| `$B083`-`$B09D` | NMI exit, restores stack, jump into game's real NMI                |
| `$B0A0`-`$B17A` | Cheat-apply / compare-mode dispatch                                |
| `$B189`-`$B2B0` | SRAM candidate iteration helpers                                   |
| `$B2B1`-`$B2F8` | Clear-trainer (Sel + Start follow-up)                              |
| `$B2F9`-`$B35E` | WRAM snapshot (Sel + X follow-up: copies WRAM into candidate area) |
| `$B35F`-`$B3F6` | Trainer-count-and-blink-mode: walks the candidate area (see §20.3) |

`$80:B3F7` already starts the next, unrelated routine (force-blank, game-launch helper). An emulator BIOS gate that switches in the MK3 BIOS only during the PAR-NMI therefore needs to expose **exactly `$AE12`-`$B3F6`** (or, page-aligned, `$AE00`-`$B3FF`).

#### 8.3 IRQ/BRK Handler (`$80:AAFD`)

```asm
80/AAFD: php / rep #$20 / pha / phx / phy
80/AB03: jsr $B9DD                 ; menu buffer init
80/AB06: jsr $BA09                 ; joypad/input refresh
80/AB09: sep #$20 / lda #$01 / sta $21
80/AB0B: rep #$20
80/AB11: lda #$0A02 / jsr $B913    ; render at row 10, col 2
80/AB17: lda #$AB6D / sta $EA      ; string pointer to "FATAL ERROR"
80/AB1C: lda #$0000 / sta $EC
80/AB21: jsr $BC07                 ; print string
80/AB24: lda #$0615 / jsr $B913    ; position (6, 21)
80/AB2A: lda #$AB79 / sta $EA      ; string pointer to "PRESS RESET"
80/AB34: jsr $BC07
80/AB44: lda #$030A / jsr $BC23    ; draw border/frame
80/AB4E: jsr $B855
80/AB51: nop / jmp $AB51           ; hang loop
```

Following strings:

```
$80:AB55  "A REG"           (value of A is inserted here)
$80:AB5B  "X REG"
$80:AB61  "Y REG"
$80:AB66  "P REG"
$80:AB6D  "FATAL "
$80:AB79  "PRESS RESET TO ..."
```

This is a **debug crash screen**. Whenever the game triggers a BRK or an IRQ fires, the ROM catches it and shows a blue-screen-equivalent with register contents. In normal operation it is never reached.

---

### 9. MK3-Specific IO Registers: Full Map

Every documented MK3 IO address, with all hits found in the disassembly:

| Address             | Function                      | R  | W   | Code locations |
|---------------------|-------------------------------|----|-----|----------------|
| `$100000`-`$100003` | Code Slot 0 (DTA/LSB/MID/MSB) | no | yes | `$92CB-$92E0` (slot programmer) |
| `$100004`-`$100017` | Code Slots 1 to 5             | no | yes | same routine, X-indexed |
| `$100018`-`$10001B` | Code Slot 6 (always NMI.MSB)  | no | yes | same routine, X-indexed |
| `$10001C`           | **Control A**                 | no | yes | `$96A0`, `$A57B`, `$A59C`, `$ACB1`, `$ACCA` |
| `$10003C`           | **Control B**                 | no | yes | `$96E5` (exactly once) |
| `$086000`           | **LEDs**                      | no | yes | `$8107` (off), `$8150`/`$815C` (init pattern 01/02), `$9533-954E` (test sequence 03/02/01/00), `$AA82-AF49` |
| `$206000`           | **Control C**                 | no | yes | `$8107` (boot), `$96A3` (pre-launch), `$AE2B` (PAR-NMI entry, writes `$00`), `$B08B` (PAR-NMI exit, writes `$01`) |
| `$008000`           | **Control D**                 | no | yes | `$AE37` (exactly once, in PAR NMI) |

#### 9.1 Control A (`$10001C`): all observed values

| Value | Bits set        | Effect                    | Location                  |
|-------|-----------------|---------------------------|---------------------------|
| `$00` | none            | Clear / BIOS mode         | `$96A0`, `$A59C`, `$ACCA` |
| `$10` | Bit 4           | Game ROM (BIOS temp. off) | `$ACB1`                   |
| `$40` | Bits 6-7 = `01` | Force NTSC                | `$96B5`                   |
| `$80` | Bits 6-7 = `10` | Force PAL                 | `$96AD`                   |

#### 9.2 LED Patterns on `$086000`

| Value | Bit 0 | Bit 1 | Meaning                             |
|-------|-------|-------|-------------------------------------|
| `$00` | off   | off   | both off (default, or game running) |
| `$01` | on    | off   | "Init phase 1 complete"             |
| `$02` | off   | on    | "Init phase 2 complete"             |
| `$03` | on    | on    | Test pattern (LED self-check)       |

The sequence at [`$9531-954E`](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:2531) is a **walking LED animation** (03, 02, 01, 00) with `jsr $BBDE` as delay. It is a classic "we are alive" indicator at boot time.

> **These patterns are boot-only.** During gameplay the LEDs are *not* driven
> from `$086000` directly -- the PAR NMI forces bit0 of every runtime write to 0
> and modulates a blink from direct-page state in MK3 SRAM instead. See section
> 20.3 for the runtime LED engine.

#### 9.3 Hardware Switch: No Software Sense

A **notable result** of the disassembly analysis is that there are **zero reads** of any MK3-specific IO register. The ROM has no software way to query the position of the 3-way switch.

This is consistent with the PCB architecture (see [preservaction-pcb.md](preservaction-pcb.md)): the **74HC4066 quad bilateral switch** combined with the **HC74A dual D flip-flop** decides **at the electrical level** which of the three chips (EPROM, Datel IC, or none) gets access to the cartridge bus:

| Switch | Who is on the bus?     | What logic runs?                      |
|--------|------------------------|---------------------------------------|
| Top    | Datel IC (cheats)      | **Game ROM** with live patches via IC |
| Middle | nothing (pass-through) | **Game ROM**, unmodified              |
| Bottom | EPROM (Replay ROM)     | **This ROM** (menu)                   |

If this ROM is running at all, the switch must be in the "Bottom" position by definition. The question "which HW state is active" cannot be answered in software, because the question is resolved by the fact that the appropriate software was loaded in the first place.

---

### 10. Cheat Code Pipeline

#### 10.1 Input staging in SRAM

A single cheat code line is buffered in the DP area:

| DP address | Bytes | Content            |
|------------|-------|--------------------|
| `$77`      | 1     | MSB (bank byte)    |
| `$78`      | 1     | MID (address high) |
| `$79`      | 1     | LSB (address low)  |
| `$7A`      | 1     | DTA (value/data)   |

These 4 bytes correspond exactly to one PAR3 code word (no PAR2 bit-15 hack).

#### 10.2 Slot programmer (`$80:92BC`)

```asm
80/92BC: rep #$10
80/92BE: and #$00FF              ; A = slot number (0 to 6)
80/92C1: asl A / asl A           ; x4 (each slot is 4 bytes)
80/92C3: ldx #$0000 / tax        ; X = slot offset
80/92C7: sep #$20
80/92C9: lda $7A / sta $100000,X ; DTA to Slot.DTA
80/92CF: inx
80/92D0: lda $79 / sta $100000,X ; LSB to Slot.LSB
80/92D6: inx
80/92D7: lda $78 / sta $100000,X ; MID to Slot.MID
80/92DD: inx
80/92DE: lda $77 / sta $100000,X ; MSB to Slot.MSB
80/92E4: plp / pla / rts
```

Only 19 bytes of code, programming **one** cheat into **one** of the 7 slots of the Datel IC. Called 15 times in total: once per active slot at game launch, plus during the "Code Add" flow in the menu.

#### 10.3 Cheat list in SRAM at `$7E:6300` and onward

The NMI handler uses a pointer to `$6300`:

```asm
80/90B7: lda #$6300 / sta $C2          ; pointer LSW
80/90BC: lda #$0000 / sta $C4          ; pointer MSB
80/90C1: ldx #$0064                    ; 100 entries
80/90C7: sep #$20
80/90C9: lda #$7E / sta [$C2],Y        ; byte 0: bank
80/90CD: iny / lda #$00 / sta [$C2],Y  ; byte 1: addr low
       ... (7 zero bytes total per entry)
```

This points to a **cheat slot array** with **100 entries of 7 bytes** starting at `$7E:6300`:

```
Offset  Meaning
  0    Bank byte (preset to $7E for WRAM)
  1    Address Low
  2    Address Mid  (or compare byte for PAR2 style)
  3    Address High
  4    Value
  5    Flags? / compare mask?
  6    Hit counter? / active flag?
```

100 x 7 = 700 bytes (`$7E:6300`-`$7E:65B3`). This size matches the slot count documented in the UI (see [preservaction-ui-cheats.md](preservaction-ui-cheats.md)).

#### 10.4 DEADC0DE detection while iterating (`$80:9320`)

When walking the cheat list, the code checks at [`$80:9320`](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:2320):

```asm
80/9320: lda [$C2],Y             ; 16-bit read
80/9322: cmp #$ADDE              ; LE bytes of $DEAD?
80/9325: bne $9340               ; no: regular entry
80/9327: ldy #$0002
80/932A: lda [$C2],Y
80/932C: cmp #$DEC0              ; LE bytes of $C0DE?
80/932F: bne $9340
80/9331: ; DEADC0DE confirmed!
80/9333: ldy #$000A
80/9336: lda [$C2],Y             ; length byte at offset +10
80/9338: inc A
80/9339: clc / adc $4D / sta $4D ; skip slot counter forward
80/933E: bra $935D
```

When the first 4 bytes of a slot entry are `DE AD C0 DE` (little-endian: `ADDE DEC0`), the iterator jumps to the length byte at offset +10 and skips that many follow-up slots. This is exactly the mechanism that embeds DEADC0DEs inside the regular cheat table without consuming multiple slot positions; they are **inline-expanded**.

---

### 11. Reading the Game ROM via Control-A Bit-4 Toggle

Two routines use the **trick of briefly hiding the Replay ROM** in order to read from the game cartridge.

#### 11.1 Read cartridge header ([`$80:A578`](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:4612))

```asm
80/A578: jsr $10A9                ; setup
80/A57B: sta $10001C              ; Control A = $10 (bit 4 set)
                                  ; BIOS off, GAME ROM on
80/A581: lda #$02 / sta $619F
80/A586: ldx #$0000 / ldy #$003F  ; 63 bytes (= header size)
80/A58E: lda $00FFC0,X            ; read from game cart header
80/A592: sta $006A00,X            ; copy into Replay SRAM
80/A596: inx / dey / bne $A58E
80/A59A: lda #$00 / sta $10001C   ; Control A = 0 (BIOS ROM back on)
80/A5A0: rtl
```

The game knows its own header at `$00:FFC0`. The Replay ROM reads the **same** region after stepping aside for 63 read cycles. This code must live in a ROM area that is **not** mirrored into `$80`-`$BF`, otherwise it would read from nothing. That is why it is deliberately short and contains no jump tables.

#### 11.2 Full 32 KB snapshot into WRAM ([`$80:ACAF`](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:5444))

```asm
80/ACAF: lda #$10 / sta $10001C   ; Game ROM on
80/ACB5: ldy #$0000 / ldx #$0000
80/ACBB: lda [$C2],Y              ; long pointer to game ROM
80/ACBD: sta $7F8000,X            ; to SNES extended WRAM
80/ACC1: inx / iny
80/ACC3: cpy #$8000
80/ACC6: bne $ACBB                ; 32 KB copy loop
80/ACC8: lda #$00 / sta $10001C   ; Game ROM off, BIOS back on
80/ACCE: rtl
```

This is the **Code Finder snapshot**: a complete 32 KB bank from the game cartridge is copied into upper WRAM so the trainer can do before/after comparisons (for example, "find values that changed from 50 to 49"). Afterwards the cartridge is hidden again and the menu code resumes normally from the Replay ROM.

---

### 12. Joypad Subsystem

Three routines handle input:

| Address    | Task                                            |
|------------|-------------------------------------------------|
| `$80:B9DD` | Cursor/menu buffer init and render background   |
| `$80:BA09` | Auto-joypad wrapper and normalises the result   |
| `$80:BA61` | **Synchronous auto-joypad read** with wait loop |

The BA61 routine ([line 7095](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:7095)):

```asm
80/BA67: lda $4212               ; auto-joypad status
80/BA6A: and #$01
80/BA6C: bne $BA67               ; wait until auto-joypad is done
80/BA6E: stz $4016               ; strobe latch
80/BA71: lda $4218 / sta $1B     ; Pad1 low
80/BA76: lda $4219 / sta $1C     ; Pad1 high
80/BA7B: lda $421A / cmp #$FF    ; Pad2 low ($FF = not connected)
80/BA80: beq $BA8D
80/BA82: ora $1B / sta $1B       ; OR-combine with Pad1
80/BA86: lda $421B / ora $1C / sta $1C
```

Note that Pads 1 and 2 are **OR-combined**, so both players can drive the menu at the same time. Very user-friendly for two-person cheat entry.

---

### 13. Subroutine Cluster `$B9DD-$BFFF`

The most frequent JSR targets form a utility block at the end of bank `$80`:

| Address | Calls | Function                               |
|---------|-------|----------------------------------------|
| `$B913` | 74x   | Position cursor (col, row in 16-bit A) |
| `$BBDE` | 52x   | VBlank wait / frame sync               |
| `$BC07` | 33x   | Print string (pointer in `$EA`/`$EC`)  |
| `$B9DD` | 30x   | Render buffer clear                    |
| `$BA09` | 30x   | Joypad refresh                         |
| `$BC6A` | 29x   | Character output (8-bit A)             |
| `$BE42` | 23x   | Hex number print                       |
| `$B855` | 22x   | DMA flush (VRAM upload)                |
| `$BE32` | 15x   | Decimal number print                   |
| `$92B8` | 15x   | **Cheat slot programmer**              |
| `$BC23` | 10x   | Box/border draw                        |
| `$A984` | 10x   | Menu dispatcher? (TODO: verify)        |
| `$BA61` | 9x    | Sync joypad read                       |
| `$B704` | 8x    | Palette update                         |

The `$4xxx` targets in the statistics (`$4F43`, `$4843`, and so on) are ASCII characters from the data section (`"OC"`, `"HC"`, ...) that the disassembler mistook for JSR opcodes. They are **not** real subroutines.

---

### 14. Replay SRAM Map (32 KB HY62256A)

Addressable via `$00/02/04/06:6000-7FFF` (LoROM banks with SRAM line connected):

```
$6000-$60FF   Direct page plus stack (init phase, then moved)
$6100-$61FF   Active direct page    (TCD target at boot)
$6200-$69FF   Render buffer / menu tilemap (2 KB)
$6A00-$6A3F   Game cart header copy (63 bytes, written by $A578)
$6A40-$62FF   (reserved / unknown)
$6300-$65B3   Cheat slot array (100 x 7 bytes = 700 B)
$65B4-$6FFF   User data (notes, history, mappings)
$7000         Latch signal from PAR NMI ($AE2F writes $40)
$7033-$71FF   PAR NMI trampoline (generated by Code Finder)
$7200-$7FFF   further SRAM usage (PAR NMI stack?)
```

> The exact bytes from `$65B4` and from `$7200` would have to be confirmed with a live RAM watch on real hardware. From the ROM code alone they can only be classified as "written, purpose unclear".

---

### 15. Notable Quirks

1. **Stack in SRAM, not WRAM.** Atypical for SNES software, but necessary because in cheat mode the WRAM must be available for the game.

2. **Direct page in SRAM.** Same reasoning. The entire "working memory" of the Replay ROM lives inside the adapter itself.

3. **No standard cartridge header.** The ROM works only because the SNES CPU just executes the reset vector, without any header validation.

4. **Double writes for 16-bit PPU registers.** Consistently applied (`sta $210D / sta $210D`), showing very disciplined coding.

5. **OR-combined controllers.** Pad1 and Pad2 jointly drive the menu.

6. **4 KB trampoline for 30 bytes of code.** Defensive programming against bus race conditions during hardware mapping changes.

7. **Crash screen with register dump.** Very advanced debug infrastructure for a 1995 unlicensed product. Datel really did invest in engineering here.

8. **Build date 19/7/95 burned into the ROM.** Likely the mastering tag of the final EU revision.

---

### 16. Open Questions and Observation Gaps

- **`$008000` Control D.** Written as `$00` in the PAR NMI. The exact semantics (ACK vs. reset vs. latch) cannot be derived from the code alone; only the fact that it is written **exactly once** and **only there**.
- **`$007000`.** Written as `$40` in the PAR NMI. Appears to lie in the SRAM area, possibly a "cheat tick flag" for the next handoff to the Datel IC.
- **Banks `$81`, `$82`, `$83`.** Pure data content (tiles, strings, cheat database). The breakdown by language, region, or game-database section has not been mapped in detail.
- **Cold-start boot paths.** The init functions `$BBDE`, `$BA61`, `$B3F7`, `$B56D`, `$B679` were only identified by name. A function-by-function analysis is still outstanding.
- **Localised UI strings.** Bank `$82` contains a lot of ASCII (`"DEVICES"`, `"MEMORY"`, `"OPTIONS"`, and so on). A full extraction of the menu strings would help understand the UI structure.

---

### 17. Verification Notes

All code locations are cited as `Bank:Address` and can be looked up in the disassembly with `grep -n "^80/XXXX:"`. For example:

```bash
grep -n "^80/96A0:" "rom/Pro Action Replay MK3 (Europe) (Unl).asm"
```

The IO addresses were verified with two independent search runs (write and read patterns). The **absence** of reads is therefore not an oversight but a fact of the disassembly.

---

### 18. Emulator Patches

The original ROM is **by design not runnable without MK3 hardware**. It expects:

1. a standard-conforming SNES cartridge header (completely missing, all fields `$FF`).
2. 32 KB of Replay SRAM at `$00/02/04/06:$6000-$7FFF` (a non-standard mapping that no emulator supports natively).
3. an inserted game cartridge whose header at `$00:FFC0` can be read via the Control-A bit-4 toggle.

To make the ROM boot in standard emulators (bsnes, SNES9x, Mesen-S, ...) and to allow navigating the UI, an IPS patch is provided in the same folder:

[rom/Pro Action Replay MK3 (Europe) (Unl) [emulator-friendly].ips](rom/Pro%20Action%20Replay%20MK3%20%28Europe%29%20%28Unl%29%20%5Bemulator-friendly%5D.ips)

It changes **60 bytes** at **50 locations** of the original ROM. The patched variant is available as [Pro Action Replay MK3 (Europe) (Unl) [headered].sfc](rom/Pro%20Action%20Replay%20MK3%20%28Europe%29%20%28Unl%29%20%5Bheadered%5D.sfc).

| File              | Size      | MD5                                |
|-------------------|-----------|------------------------------------|
| Original `.sfc`   | 131,072 B | `e04ac2e71b840f0e1a35c9afde75e5ce` |
| Patched `.sfc`    | 131,072 B | `1d497cef520945329d546dd9fd6c85f5` |
| IPS patch         | 318 B     | `71a7293851c18f96d8678e3ac33432fc` |

#### 18.1 Overview of All Changes

| #      | Offset       | Bank:Addr  | Bytes         | Intention                                   |
|--------|--------------|------------|---------------|---------------------------------------------|
| **A**  | `$004C`      | `$80:804C` | `61`-`00`     | Direct page to standard WRAM                |
| **B**  | `$0050`      | `$80:8050` | `60`-`01`     | Stack pointer to standard WRAM              |
| **C**  | `$0273`      | `$80:8273` | `F0`-`80`     | Bypass cart detect                          |
| **D1** | `$7FD5`      | `$80:FFD5` | `FF`-`20`     | Map Mode = LoROM                            |
| **D2** | `$7FD6`      | `$80:FFD6` | `FF`-`00`     | ROM Type = ROM only                         |
| **D3** | `$7FD7`      | `$80:FFD7` | `FF`-`07`     | ROM Size = 128 KB (2^7)                     |
| **D4** | `$7FD8`      | `$80:FFD8` | `FF`-`05`     | SRAM Size = 32 KB (2^5)                     |
| **D5** | `$7FD9`      | `$80:FFD9` | `FF`-`02`     | Region = Europe                             |
| **D6** | `$7FDA`      | `$80:FFDA` | `FF`-`33`     | Maker code                                  |
| **D7** | `$7FDB`      | `$80:FFDB` | `FF`-`00`     | Version                                     |
| **E1** | `$7FDC-7FDD` | `$80:FFDC` | `FFFF`-`2BA7` | Checksum complement                         |
| **E2** | `$7FDE-7FDF` | `$80:FFDE` | `FFFF`-`D458` | Checksum                                    |
| **G1** | `$1F18`      | `$80:9F18` | `61`-`00`     | Indirect jump fix                           |
| **G2** | `$309F`      | `$80:B09F` | `61`-`00`     | Indirect jump fix                           |
| **G3** | `$30B8`      | `$80:B0B8` | `61`-`00`     | Indirect jump fix                           |
| **G4** | `$3127`      | `$80:B127` | `61`-`00`     | Indirect jump fix                           |
| **G5** | `$1DF0`      | `$80:9DF0` | `61`-`00`     | Menu-item selection dispatcher jump fix     |
| **J1** | `$41A0`      | `$80:C1A0` | `61`-`00`     | Toggle-item SRAM-var fix                    |
| **J2** | `$41E1`      | `$80:C1E1` | `61`-`00`     | Toggle-item SRAM-var fix                    |
| **J3** | `$422C`      | `$80:C22C` | `61`-`00`     | Toggle-item SRAM-var fix                    |
| **J4** | `$425B`      | `$80:C25B` | `61`-`00`     | Toggle-item SRAM-var fix: BACKGROUND ON/OFF |
| **J5** | `$4276`      | `$80:C276` | `61`-`00`     | Toggle-item SRAM-var fix: TRAINER KEY       |
| **K1-18** | 18 sites  | bank 80    | see 18.7      | Relocate cheat-list base address. Required for preset cheat pickup to work. |

These produce 13 IPS records:

```
Offset $00004C  Length  1  Data 00                       (Patch A)
Offset $000050  Length  1  Data 01                       (Patch B)
Offset $000273  Length  1  Data 80                       (Patch C)
Offset $001F18  Length  1  Data 00                       (Patch G1)
Offset $00309F  Length  1  Data 00                       (Patch G2)
Offset $0030B8  Length  1  Data 00                       (Patch G3)
Offset $003127  Length  1  Data 00                       (Patch G4)
Offset $0041A0  Length  1  Data 00                       (Patch J1)
Offset $0041E1  Length  1  Data 00                       (Patch J2)
Offset $00422C  Length  1  Data 00                       (Patch J3)
Offset $00425B  Length  1  Data 00                       (Patch J4)
Offset $004276  Length  1  Data 00                       (Patch J5)
Offset $001DF0  Length  1  Data 00                       (Patch G5)
Offset $007FD5  Length 11  Data 20 00 07 05 02 33 00 ?? ?? ?? ??   (D+E, see 18.8 for current values)

... plus 36 single-byte K records (18 sites x 2 bytes each: `$63 -> $02` and `$00 -> $7E`), listed in section 18.7.
```

#### 18.2 Patch A: Direct Page to WRAM (`$80:804C: 61 to 00`)

**Original:**
```asm
80/804A: A9 00 61    lda #$6100      ; direct page to MK3 SRAM $00:6100
80/804D: 5B          tcd
```

**Patched:**
```asm
80/804A: A9 00 00    lda #$0000      ; direct page to SNES WRAM $00:0000
80/804D: 5B          tcd
```

**Why.** On real hardware, bank `$00:$6000-$7FFF` is the 32 KB SRAM chip inside the Replay adapter. In an emulator that does not provide this special mapping, it is open bus. All zero-page variables (`$94`, `$1B`, `$F0`, ...) would write into nothing.

By redirecting to `$0000`, all DP variables land in the standard WRAM area (banks `$7E:$0000-$00FF`), which every emulator emulates correctly.

**Side effect.** The **warm-boot magic word `$ABCD`** at `$94` (section 5) no longer persists. WRAM is random after reset, so the check at [`$80:8126`](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:112) fails every time, and the ROM always takes the cold-init path. Irrelevant for pure UI exploration in an emulator.

#### 18.3 Patch B: Stack Pointer to WRAM (`$80:8050: 60 to 01`)

**Original:**
```asm
80/804E: A9 FF 60    lda #$60FF      ; stack top to MK3 SRAM $00:60FF
80/8051: 1B          tcs
```

**Patched:**
```asm
80/804E: A9 FF 01    lda #$01FF      ; stack top to SNES WRAM $00:01FF
80/8051: 1B          tcs
```

**Why.** Same reason as patch A. Without this fix, the first `rts` of any subroutine reads its return address from open bus and the CPU jumps into nowhere, leaving the screen black.

`$01FF` is the standard SNES stack location (typical after reset, since the 65C816 stack always lives in bank `$00` and usually starts at `$01FF`).

#### 18.4 Patch C: Bypass Cart Detect (`$80:8273: F0 to 80`)

**Original:**
```asm
80/8266: 20 96 A4    jsr $A496       ; init SRAM tables
80/8269: 20 B2 90    jsr $90B2       ; init cheat list
80/826C: 20 E1 A4    jsr $A4E1       ; cartridge detect routine
80/826F: E2 20       sep #$20
80/8271: A5 7E       lda $7E         ; cart-valid flag
80/8273: F0 25       beq $829A       ; if 0: main menu, otherwise:
80/8275: ...                         ; "NO CARTRIDGE FOUND" + endless hang
```

**Patched:**
```asm
80/8273: 80 25       bra $829A       ; always jump to main menu
```

**Why.** The cart-detect routine `$A4E1` copies a 42-byte trampoline from `$00:A577`-`$7E:8000` (WRAM) and calls it via `jsr $7E8000`. The trampoline sets Control A bit 4 (map in game ROM), reads 63 bytes from the cartridge header at `$00:FFC0`, and writes them to `$00:6A00` (SRAM).

In an emulator Control A has no effect. The read address `$00:FFC0` therefore returns the Replay ROM itself, and the write area `$00:6A00` is open bus. The subsequent validation at [`$80:A541`](rom/Pro%20Action%20Replay%20MK3%20(Europe)%20(Unl).asm:4595) reads the reset vector of the assumed game cart. That value is undefined (open bus), happens to match `$0000`, and the code sets `$7E = $01` ("no cartridge").

Instead of simulating a full cart header (which would require redirecting the write target and placing a fake header at an unused ROM location), we patch the **branch immediately after the check** from `beq` (`$F0`) to `bra` (`$80`). The offset byte (`$25`) stays unchanged, since both opcodes use the same 1-byte relative jump.

**Effect.** The ROM enters the main menu regardless of the cart-detect result. The UI is fully usable for cheat input, trainer configuration, code lists, and options.

**What still does not work:**
- "Start Game" / "Activate Game Cartridge": jumps to the reset vector of the non-existent game cart, ending in an endless loop.
- Live cheat application: requires the Datel IC, which is not emulated.
- Hex display of the game header: shows garbage (`$FF` bytes or bus residue).

#### 18.5 Patches D1 to D7: Reconstruct the Cartridge Header

**Original.** Bytes `$FFD5-$FFDB` are all `$FF`, so there is no valid SNES header.

**Patched:**

| Offset  | Value | Field     | Meaning                                            |
|---------|-------|-----------|----------------------------------------------------|
| `$FFD5` | `$20` | Map Mode  | LoROM (slow ROM)                                   |
| `$FFD6` | `$00` | ROM Type  | ROM only, no co-processor                          |
| `$FFD7` | `$07` | ROM Size  | 2^7 KB = 128 KB, matches the file                  |
| `$FFD8` | `$05` | SRAM Size | 2^5 KB = 32 KB                                     |
| `$FFD9` | `$02` | Region    | Europe (PAL)                                       |
| `$FFDA` | `$33` | Maker     | Datel licensee code (freely chosen, not validated) |
| `$FFDB` | `$00` | Version   | 1.00                                               |

**Why.** Strict emulators like **bsnes** and **higan** refuse to load ROMs without a valid header. Tolerant emulators like **SNES9x** guess heuristically and usually map incorrectly. With correct values every emulator recognises the ROM as LoROM/PAL/128KB/32KB SRAM and maps it correctly into the address space.

#### 18.6 Patches G1 to G5: Repair Indirect Jumps Broken by Patch A

After patch A redirects the direct page from `$6100`-`$0000`, four indirect jumps that were carefully designed to dereference DP-region pointers no longer work. They are hardcoded to read their jump target from `$00:61xx` (the original DP location on real hardware), while the preceding `sta $XX` now writes to `$00:00xx` (the new DP location). The pointer is written to one place and read from another, so the jump goes to an open-bus garbage address. The first time the CPU lands on a `$00` byte at that random destination, it executes a BRK, which jumps to the crash handler at `$AAFD` and renders the **"ITS TIME TO CLEAN THE EDGE CONNECTOR ON ACTION REPLAY"** screen.

The fix is precise: change the high byte of each affected indirect-jump operand from `$61`-`$00`, so the jump reads from the new DP location that `sta` actually wrote to. One byte per patch, four bytes total.

**The four affected sites:**

| #  | Address    | Original      | Patched       | Preceding store |
|----|------------|---------------|---------------|-----------------------------------------------------------------------|
| G1 | `$80:9F16` | `jmp ($614D)` | `jmp ($004D)` | `$80:9F14: sta $4D` (menu render dispatcher: table jump by item type) |
| G2 | `$80:B09D` | `jmp ($6180)` | `jmp ($0080)` | (DP `$80` set elsewhere; return-from-call chain that tail-jumps via a stored pointer) |
| G3 | `$80:B0B6` | `jmp ($614D)` | `jmp ($004D)` | `$80:B0B2: sta $4D` (menu-item handler dispatcher) |
| G4 | `$80:B125` | `jmp ($61B6)` | `jmp ($00B6)` | `$80:B123: sta $B6` (menu-item subhandler dispatcher) |
| G5 | `$80:9DEE` | `jmp [$61C2]` (long-indirect, opcode `$DC`) | `jmp [$00C2]` | `$80:9D84..$9D8D: lda [$47],Y / sta $C2..$C4` (loads the 4-byte handler pointer of the currently selected menu item, then long-indirect jumps to it). This is the per-click handler dispatch. Without G5, every menu selection crashes immediately to the BRK handler with "ITS TIME TO CLEAN THE EDGE CONNECTOR". |

**Example (patch G1 at `$80:9F0F`):**

Original:
```asm
80/9F0F: lda #$9F19    ; base address of jump table
80/9F12: adc $4D       ; add precomputed index
80/9F14: sta $4D       ; store pointer at DP $4D
                       ; on real HW: writes to $00:614D (DP=$6100)
                       ; with patch A: writes to $00:004D (DP=$0000)
80/9F16: jmp ($614D)   ; read pointer from hardcoded $00:614D
                       ; on real HW: matches the sta target (good)
                       ; with patch A: reads from open-bus (bad)
```

Patched:
```asm
80/9F16: jmp ($004D)   ; reads from $00:004D, matching the sta target
```

**Why not just silence the BRK handler?**

An earlier revision of these patches simply rewrote the first byte of the BRK handler at `$80:AAFD` from `php` (`$08`) to `rti` (`$40`), so every BRK would return immediately. That worked for the crash screen but caused an endless reboot loop, because the CPU returned from the BRK to the byte immediately following it, which was usually another invalid instruction or another `$00`. The "EDGE CONNECTOR" screen never appeared, but the ROM kept resetting itself.

The precise fix above eliminates the root cause: no BRK ever fires in the first place. The native BRK vector at `$80:AAFD` remains intact, so any genuinely unexpected BRK that may still happen in some other code path is properly reported instead of being silently swallowed.

#### 18.7 Patches K1 to K18: Relocate Cheat List to Free WRAM Region

This is the working replacement for the rolled-back H series. The cheat list is moved out of `$00:6300` (MK3 SRAM on real hardware) and out of `$7E:6300` (which collides with the render buffer in WRAM) to a free WRAM region at `$7E:0200-$04B3`. With the relocation, preset cheat pickup works in the emulator.

**The conflict that drove this.** On real MK3 hardware, the cheat list is at `$00:6300` (Replay SRAM) and the render buffer is at `$7E:6200-$69FF` (SNES WRAM). They share the lower 16 bits of address space but live in different banks, so they coexist without collision. The render-buffer-init routine at `$80:B9DD` aggressively fills `$7E:6200-$69FF` with the background tile-ID from DP `$F0` (usually `$2E`) every time a screen is repainted; on real hardware this never touches the SRAM cheat list.

With patch A in effect, all naive attempts to redirect the cheat-list pointer from bank `$00` to bank `$7E` (the rolled-back H patches) put the cheat list **inside** the render buffer at `$7E:6300`. The first call to `$B9DD` then wiped the cheat list to all `$2E`, which is exactly the garbage pattern the user observed.

The K patches solve this by relocating both ends of the pointer:

```asm
; Original (real MK3 HW):
lda #$6300     ; address LSW
sta $XX        ; pointer setup
lda #$0000     ; bank = $00 (MK3 SRAM)
sta $XX+2

; Patched (emulator):
lda #$0200     ; address LSW changed
sta $XX        ; (unchanged)
lda #$007E     ; bank = $7E (free WRAM, away from render buffer)
sta $XX+2      ; (unchanged)
```

Two bytes per site: one to flip `$63`-`$02` in the address MSB, one to flip `$00`-`$7E` in the bank LSB. Because both `$6300` and `$0200` have LSB `$00`, the address LSB byte requires no change.

**All 18 sites:**

| #   | File offsets     | Code Addr  | DPreg | Original target | New target |
|-----|------------------|------------|-------|-----------------|------------|
| K1  | `$059E`, `$05A2` | `$80:859C` | `$BA` | `$00:6300`      | `$7E:0200` |
| K2  | `$063B`, `$063F` | `$80:8639` | `$C6` | `$00:6300`      | `$7E:0200` |
| K3  | `$0701`, `$0705` | `$80:86FF` | `$C6` | `$00:6300`      | `$7E:0200` |
| K4  | `$08BF`, `$08C3` | `$80:88BD` | `$C6` | `$00:6300`      | `$7E:0200` |
| K5  | `$09C0`, `$09C4` | `$80:89BE` | `$C6` | `$00:6300`      | `$7E:0200` |
| K6  | `$0AB5`, `$0AB9` | `$80:8AB3` | `$C6` | `$00:6300`      | `$7E:0200` (slot list renderer) |
| K7  | `$10B9`, `$10BD` | `$80:90B7` | `$C2` | `$00:6300`      | `$7E:0200` (boot-time init) |
| K8  | `$12FA`, `$12FE` | `$80:92F8` | `$C2` | `$00:6300`      | `$7E:0200` |
| K9  | `$1556`, `$155A` | `$80:9554` | `$C6` | `$00:6300`      | `$7E:0200` |
| K10 | `$1771`, `$1775` | `$80:976F` | `$C2` | `$00:6300`      | `$7E:0200` |
| K11 | `$18E2`, `$18E6` | `$80:98E0` | `$C2` | `$00:6300`      | `$7E:0200` |
| K12 | `$193C`, `$1940` | `$80:993A` | `$C2` | `$00:6300`      | `$7E:0200` |
| K13 | `$199D`, `$19A1` | `$80:999B` | `$C2` | `$00:6300`      | `$7E:0200` |
| K14 | `$1ABB`, `$1ABF` | `$80:9AB9` | `$C6` | `$00:6300`      | `$7E:0200` (dup-check) |
| K15 | `$21FB`, `$21FF` | `$80:A1F9` | `$C2` | `$00:6300`      | `$7E:0200` |
| K16 | `$2252`, `$2256` | `$80:A250` | `$C2` | `$00:6300`      | `$7E:0200` |
| K17 | `$2313`, `$2317` | `$80:A311` | `$C2` | `$00:6300`      | `$7E:0200` |
| K18 | `$23C6`, `$23CA` | `$80:A3C4` | `$C2` | `$00:6300`      | `$7E:0200` |

**Final WRAM layout in the patched emulator session:**

```
$7E:0000-$00FF  Direct page (from patch A)
$7E:0100-$01FF  Stack       (from patch B)
$7E:0200-$04B3  Cheat list  (100 entries x 7 bytes, from K patches)
$7E:04B4-$5FFF  Free WRAM
$7E:6200-$69FF  Render buffer (B9DD fill area, untouched)
$7E:6A00-$71FF  Render buffer 2 (BA09 fill area)
```

The cheat list now lives in a region that no other routine writes to. Init at `$80:90B2` (patched via K7) populates it with the default `7E 00 00 00 00 00 00` pattern at boot. The slot-list renderer (K6) reads from the same address. Apply, duplicate-check, and all other 18 cheat-list-touching routines are consistent.

**What still does not work after K patches.** The K patches only cover the `$6300` (cheat list) region. Other SRAM regions (`$6600` render data, `$6A00` cart header buffer, `$7000` preset tables, `$7800` code-finder snapshots) remain at their original `$00:xxxx` addresses, which are open bus in an emulator. Features that depend on those regions (live cheat application via the Datel IC, code finder, header read for cartridge identification) still do not work. Those would require a similar relocation effort per region plus careful collision analysis with the render buffer, well beyond the IPS-patch scope.

#### 18.7.1 Attempted twice and reverted: H (long-pointer bank redirects) and I (long-form direct access redirects)

Two patch series targeting the SRAM-data layer were tried and both abandoned. They are documented here as cautionary lessons; neither is part of the current IPS.

**Patch H (35 sites): redirect long-pointer bank from `$00`-`$7E`.**

When the user picks a cheat from a preset list and asks to apply it to a code slot, the ROM stores the resulting 4-byte cheat into the cheat-list array at `$00:6300` on real MK3 hardware. It uses long-pointer addressing for this, with a setup like `lda #$6300 / sta $C2 / lda #$0000 / sta $C4`, then accesses the data via `sta [$C2],Y` and reads it back later via `lda [$C2],Y`.

With patch A in effect, the same problem as section 18.6 appears at a different layer: the bank byte written into the long pointer is `$00`, but `$00:6300` is open bus in the emulator. Writes vanish, subsequent reads return garbage, and the cheat never appears in the code-slot view. Other SRAM-resident data structures (render buffers, code-finder snapshots, miscellaneous tables) have the same problem.

The fix is the same shape used for the G and J patches: change one byte per setup site to redirect the long pointer to bank `$7E` (WRAM), where the same offsets resolve to actual memory in every emulator.

**Pattern matched and patched:**

```asm
; Original (one of 35 occurrences)
lda #$HHLL     ; HH is in $60..$7F (SRAM page)
sta $XX        ; pointer low+mid into DP
lda #$0000     ; bank byte
sta $XX+2      ; -> bank = $00 (MK3 SRAM on real HW, open bus in emulator)

; Patched (one byte change to the LSB of `lda #$0000`)
lda #$007E     ; bank byte $7E
sta $XX+2      ; -> bank = $7E (WRAM, real memory in any emulator)
```

The 35 patched sites cover setups for cheat-list pointers (`$6300`), render data (`$6600`), header copy (`$6A00`), preset tables (`$7000`), and code-finder snapshots (`$7800`). Each site changes one byte: the LSB of the `lda #$0000` instruction at the patched offset, from `$00`-`$7E`. The matching `sta $XX+2` then writes `$7E` as the bank byte of the long pointer.

**Test result.** With H applied, the cheat-pickup screen renders with worse garbage than without it (random tile IDs at the top, scrambled slot list). The cheat-pickup function still does not actually apply a cheat from the preset list. So H makes a different layer visibly worse and fixes nothing meaningful in the live session. The patches were rolled back a second time.

**Hypothesis on why H makes things worse.** The ROM has at least two parallel paths into the SRAM region: long-pointer accesses (which H redirects to WRAM `$7E:6300`) and direct 3-byte/long-form absolute accesses (which H does not touch). After H, writes via long pointers land at `$7E:6300`, but reads through the absolute path go to `$00:6300` (open bus). Pre-H, both paths consistently hit open bus; the renderer reads stable "no-data" values like `$FF`. Post-H, the two paths diverge: the renderer reads from an unrelated WRAM region that the ROM never wrote to, getting whatever garbage happens to be there from earlier WRAM use. Visible quality drops.

**Lesson.** Mirroring half of a memory-access pattern across two banks is worse than leaving both halves consistently broken.

**Patch I (24 sites): redirect 4-byte long-form direct accesses to MK3 SRAM.** Targets things like `sta $00:708E` and `lda $00:6A00,X`. Most patched sites were on dead code paths in an emulator context. No observable improvement. Rolled back.

**Net result.** Neither H nor I is in the current IPS. The preset cheat pickup remains broken in the emulator.

**The architectural reason H is fundamentally unsuitable.** On real MK3 hardware, the cheat list lives at `$00:6300-$65B3` in the MK3 SRAM. The SNES WRAM at `$7E:6200-$69FF` is used as the render-buffer (a tile-map staging area filled with tile-IDs that DMA into VRAM). These two regions overlap at offset `$6300-$65B3`, but they sit in **different banks** (`$00` vs `$7E`) so they do not collide on hardware.

Patch A redirects direct-page accesses to WRAM, but the cheat-list address pattern was still `$6300` (offset only). The H patches add bank `$7E` to those pointers, intending to fix the cheat-list-storage path. But this lands the cheat list at exactly `$7E:6300-$65B3`, which is **inside the render buffer**. The routine `$80:B9DD`, called at the start of the cheat-input dialog, fills `$7E:6200-$69FF` with the background tile-ID from DP `$F0` (typically `$2E`), wiping the freshly-initialised cheat list to all `$2E` bytes. The slot-list renderer then reads back those `$2E` bytes and displays `2E2E2E2E` for almost every slot, with occasional fragments of other tile data peeking through.

To fix preset cheat pickup in an emulator, the cheat list would need to be relocated to a WRAM region that does not overlap the render buffer (for example `$7E:0200-$04B3`). That requires patching not only the bank byte but also the lower 16 bits of every pointer setup, plus matching changes to any direct 3-byte or long-form absolute accesses. Each H-pattern site becomes a 3-byte change instead of 1-byte, and any 3-byte absolute access (DBR-relative) cannot be redirected without changing the DBR (which would break PPU register access). This is beyond what IPS-only patching can achieve cleanly.

The bsnes BML manifest approach (declaring the MK3-style SRAM mapping at `$00/02/04/06:6000-7FFF`) would preserve the original `$00` bank for the cheat list, sidestepping the conflict entirely. That remains the recommended path for full emulator support.

#### 18.7.1 Patches J1 to J5: Repair Toggle-Item SRAM-Variable References

This is the real fix for the menu freeze on items like `SPEED`, `USA/JAP`, `BOX TYPE`, `BACKGROUND ON/OFF`, and `TRAINER KEY`. The root cause is a direct consequence of patch A and a structural shortcut Datel took in the original ROM.

**The shortcut.** On real hardware the direct page sits at `$6100` (patch A moved it to `$0000`). Datel relied on a clever overlap: a DP-relative access like `lda $44` resolves to `$00:6144`, and an absolute access like `lda $6144` resolves to the **same** address. Both code paths read and write the same byte, because DP=`$6100` makes the two address spaces coincide on the MK3 SRAM region.

The toggle-item handlers were written using DP-relative accesses (`sta $44` etc.), while the menu definitions store the variable's address as an **absolute** 2-byte word (e.g. `$6144`). On real hardware both end up at the same memory cell. With patch A, the DP-relative access goes to WRAM `$00:0044`, while the absolute `$6144` goes to open bus in bank `$00`. The handler writes one place, the renderer reads another, and the choice index returned from open bus is garbage. For items with only 2-3 choices this happens to look ok; for `SPEED` (4 choices) the out-of-range index sends the renderer through an invalid jump target and the CPU hangs.

**The fix.** Change every embedded SRAM-variable address in the menu definitions from `$61xx`-`$00xx`. With patch A in effect, DP `$XX` now resolves to `$00:00XX`, which is the WRAM mirror in bank `$00`. The absolute access from the renderer then reads from the exact same physical byte the handler wrote to. One byte per patch, five sites total.

**The five toggle items:**

| #  | Offset  | Item Addr  | SRAM-var        | Hover text                               |
|----|---------|------------|-----------------|------------------------------------------|
| J1 | `$41A0` | `$80:C190` | `$6144`-`$0044` | "TOGGLES BETWEEN PAL AND NTSC" (USA/JAP) |
| J2 | `$41E1` | `$80:C1D1` | `$6146`-`$0046` | "CHOOSE SPEED OF SLOW MOTION"            |
| J3 | `$422C` | `$80:C21C` | `$61F1`-`$00F1` | "BOX TYPE SELECTION"                     |
| J4 | `$425B` | `$80:C24B` | `$61F6`-`$00F6` | "MOVING BACKGROUND ON/OFF"               |
| J5 | `$4276` | `$80:C266` | `$61F2`-`$00F2` | "TOGGLES TRAINER KEY"                    |

**Confirming the design hypothesis with J4.** The background-toggle handler at `$80:836D` is just four instructions: `sep #$20 / lda $F6 / eor #$01 / sta $F6 / jmp $831F`. It toggles bit 0 of DP `$F6`. With patch A, DP `$F6` is `$00:00F6` in WRAM. Without patch J4, the menu definition told the renderer to read `$00:61F6` (open bus) to find the current state, so the visible choice label never matched what the handler had written. With patch J4 the renderer reads `$00:00F6` and sees exactly what the handler wrote.

**Toggle-item format (newly identified):** mystery byte 6 of a menu item is set to `$02` when the item cycles through choices. The layout is:

```
+00..01  next pointer (16-bit, $0000 = end of list)
+02      size byte (item-length related)
+03..06  flags: 08 0E 01 02 for toggle items
+07..0A  handler long-pointer (4 bytes: addr24 + 00)
+0B..0E  hover-text long-pointer (4 bytes)
+0F..10  SRAM-variable address (2 bytes, current value pointer)  <-- J patches this
+11..    array of choice labels (4 bytes each: addr16 + 00 00)
+end     terminator: 00 00
```

This format was reverse-engineered from the hex layout of `$80:C190`, `$80:C1D1`, `$80:C21C`, `$80:C24B`, `$80:C266`, then cross-validated against the lengths between adjacent items.


#### 18.8 Patches E1/E2: Checksum and Complement

**Original.** `$FFDC-$FFDF` = `FF FF FF FF` (invalid checksum pair).

**Patched.** Recalculated on each patch run:

```
Checksum    = sum(all 131072 ROM bytes) mod $10000
Complement  = Checksum XOR $FFFF
```

The final values depend on every other patch, because the ROM bytes themselves enter the sum. Current values:

```
$FFDC-$FFDD  =  A7 2B   (complement, little-endian = $2BA7)
$FFDE-$FFDF  =  58 D4   (checksum,   little-endian = $D458)
```

Verification of the invariant `Complement = Checksum XOR $FFFF`:
`$D458 XOR $FFFF = $2BA7`, which matches the complement.

**Why.** Even tolerant emulators often check the checksum and either show a warning ("ROM corrupted") or refuse to start. A correct checksum avoids this.

#### 18.9 Applying the IPS Patch

With any common IPS tool:

```bash
# Using Floating IPS (flips, https://www.smwcentral.net/?p=section&a=details&id=11474)
flips --apply "Pro Action Replay MK3 (Europe) (Unl) [emulator-friendly].ips" \
              "Pro Action Replay MK3 (Europe) (Unl).sfc" \
              "Pro Action Replay MK3 (Europe) (Unl) [headered].sfc"

# Or as a Python one-liner (run inside the rom/ folder)
python3 -c "
import pathlib
d = bytearray(pathlib.Path('Pro Action Replay MK3 (Europe) (Unl).sfc').read_bytes())
ips = pathlib.Path('Pro Action Replay MK3 (Europe) (Unl) [emulator-friendly].ips').read_bytes()
i = 5
while ips[i:i+3] != b'EOF':
    off = (ips[i]<<16)|(ips[i+1]<<8)|ips[i+2]; i += 3
    n = (ips[i]<<8)|ips[i+1]; i += 2
    for k in range(n): d[off+k] = ips[i+k]
    i += n
pathlib.Path('Pro Action Replay MK3 (Europe) (Unl) [headered].sfc').write_bytes(d)
"
```

#### 18.10 What the Patches Do *Not* Solve

This is a **look-at-the-UI hack**, not a full emulator mod. Functionally:

| Feature                           | Status             |
|-----------------------------------|--------------------|
| Splash screen, boot, main menu    | works              |
| Cheat code input, editor          | works              |
| Trainer configuration             | works              |
| Game selection lists              | works              |
| Options menu                      | works              |
| Persistence of user data (SRAM)   | does not work (*)  |
| Warm-boot via magic word          | does not work (**) |
| "Start Game" / game launch        | does not work (*)  |
| Live cheat engine during gameplay | does not work (**) |

*)  no (emulated) game cartridge in the address space
**) requires the Datel IC, or emulation

Full emulation has been released with support of openFPGA for Analogue Pocket and SD2SNES for FXPAK PRO flash cartridges.

---

### 19. ROM-to-PCB Communication Protocol

This section consolidates how the EPROM ROM communicates with the rest of the Action Replay MK3 PCB: the Datel custom IC (LZ95G72), the 32 KB SRAM (HY62256A), the LEDs, the 74HC4066 bilateral switch, and the cartridge bus itself. It draws on the per-register details in section 9 and the cheat-pipeline details in section 10, and adds the protocol-level perspective: who initiates what, in which sequence, and why.

#### 19.1 The Communication Surface

The ROM is one of three actors on the cartridge bus:

```
+---------------------+         +-------------------+         +------------------+
|  SNES 65C816 CPU    |   bus   |  Action Replay    |   bus   |  Game cartridge  |
|  (drives address    | <-----> |  MK3 PCB          | <-----> |  (when inserted) |
|   and control)      |         |                   |         |                  |
+---------------------+         +-------------------+         +------------------+
                                      internal:
              +-------+               +-------+               +------------+
              | EPROM |<------------->| Datel |<------------->|    SRAM    |
              | (ROM) |         +---->|  IC   |-----+         | (HY62256A) |
              +-------+         |     +-------+     |         +------------+
                                |    +---------+    |
                                |    | switch  |    |
                                -----| (3-way) |    |
                                     +---------+    |
                                      +-------+     |
                                      | LEDs  |<----+
                                      +-------+
```

The ROM (this file) is what runs while the 3-way switch is in the "Bottom" position. Its communication targets are:

1. **The Datel IC** via a small set of memory-mapped IO registers.
2. **The internal SRAM** as direct memory (32 KB at `$00/02/04/06:$6000-$7FFF`).
3. **The LEDs** via a dedicated register.
4. **The cartridge bus** indirectly, by asking the Datel IC to swap which chip is mapped into the SNES address space.

The ROM never reads any MK3-specific IO register back. Verified twice in section 9.3: every access to `$086000`, `$206000`, `$10001C`, `$10003C`, `$008000`, and the code-slot region is a write, never a read. The communication is therefore strictly outbound from the ROM's point of view, with the exception of the shared SRAM, which is both written and read.

#### 19.2 The IO Register Map (Protocol View)

Section 9 catalogues every access. This subsection groups them by purpose:

| Register                | Direction       | Purpose | Who reads it? |
|-------------------------|-----------------|---------|---------------|
| `$100000-$10001B`       | ROM writes      | Programs cheat code slots 0 to 6 (4 bytes per slot: DTA, LSB, MID, MSB) | Datel IC (when CPU later reads the hooked game-cart address) |
| `$10001C` (Control A)   | ROM writes      | Bit 4: temporarily map game-cart ROM in place of MK3 ROM. Bits 6-7: force video region | Datel IC bus switcher |
| `$10003C` (Control B)   | ROM writes once | Signals "game is starting"; tells the Datel IC to drop the MK3 ROM permanently and let the game run | Datel IC bus switcher |
| `$206000` (Control C)   | ROM writes      | Bit 0: which side currently owns the cart bus (0 = BIOS/PAR-NMI handler, 1 = game). Written `$00` on PAR-NMI entry (`$AE2B`) and `$01` on PAR-NMI exit (`$B08B`) -- the rising edge to `$01` is the explicit "hand the bus back to the game" signal | Datel IC, used by NMI dispatcher |
| `$008000` (Control D)   | ROM writes once | Acknowledges entry to the PAR-NMI handler. Semantics not fully nailed down | Datel IC NMI logic |
| `$086000` (LEDs)        | ROM writes      | Bits 0-1: front-panel LEDs | LED driver (electrically, no read-back) |
| `$00:6000-$7FFF` (SRAM) | both ways       | All persistent state: cheat list, code-finder snapshots, user data | both the ROM and the Datel IC (PAR-NMI handler reads it as code) |

#### 19.3 Boot Time Communication Sequence

The first 124 cycles of the ROM execution touch the PCB in a specific order. From section 4 and section 9:

```
$80:8000   normal SNES init, no MK3 communication yet
$80:8107   sta $206000                 ; Control C = 0 -> "I am in BIOS mode"
                                       ; tells Datel IC to keep code slots disabled
$80:8121   sta $4200 = $01             ; enable NMI generation on PPU side
$80:8124   <magic word check>          ; cold vs warm boot
                                       ; uses SRAM at $00:6194 ($94 via DP=$6100)
$80:8150   sta $086000 = $01           ; LED bit 0 on  ("Init phase 1 done")
$80:815C   sta $086000 = $02           ; LED bit 1 on  ("Init phase 2 done")
$80:8226   lda $213F                   ; sense SNES region (PAL/NTSC)
$80:9531   sta $086000 = $03,02,01,00  ; walking LED self-check
                                       ; with jsr $BBDE (VBlank wait) between
```

Until this point the Datel IC has been told "BIOS mode" and the LEDs have flashed; no cheat slots have been programmed yet.

#### 19.4 Programming a Cheat Code: The Slot Protocol

Cheat codes flow from user input through SRAM and finally into Datel-IC registers. Section 10.2 documents the slot programmer at `$80:92BC`. The protocol per cheat:

1. The user enters a 4-byte code into the DP staging area (`$77`-`$7A`: MSB, MID, LSB, DTA).
2. Code calls `jsr $92B8` with A holding the slot number (0 to 6).
3. The programmer multiplies slot by 4 to get the byte offset, then issues four `sta $100000,X` long-form writes:
   - byte 0 (offset = slot*4 + 0): DTA (the data byte the IC will inject)
   - byte 1 (offset = slot*4 + 1): LSB of the hook address
   - byte 2 (offset = slot*4 + 2): MID of the hook address
   - byte 3 (offset = slot*4 + 3): MSB of the hook address

After this point the Datel IC's address comparator holds the hook address for that slot. When the CPU later asks for a byte at the matching address, the IC tri-states the cartridge ROM and drives the DTA byte onto the data bus instead. This is the bus-interception mechanism documented in [action_replay_bus_interception.md](action_replay_bus_interception.md).

**Slot reservations.** Code slots 5 and 6 are reserved by the Datel IC for hooking the game's NMI vector. The ROM always programs them, even when no NMI cheats are active, because the PAR-NMI execution (section 8.2) needs the hook in place to gain control during gameplay. This leaves a maximum of five user-controllable hardware patches (slots 0 to 4) plus any number of WRAM cheats applied from the PAR-NMI handler.

#### 19.5 Game Launch: Handing Control to the Datel IC

The most intricate piece of ROM-to-PCB choreography happens when the user selects "Start Game". Section 7 documents the trampoline; here the focus is on the protocol:

```
1. Disable NMI generation              sta $4200 = $00
2. Clear Control A                     sta $10001C = $00
3. Clear Control C (still BIOS mode)   sta $206000 = $00
4. Set video region in Control A       sta $10001C = $40 (NTSC) or $80 (PAL)
5. Copy 4 KB of trampoline to WRAM     ldx ... lda $0096D4,X / sta $001000,X
6. Jump into WRAM                      jmp $001000
   --- code is now in WRAM, ROM may safely vanish ---
7. Force Blank (PPU off)               sta $2100 = $80
8. Tell Datel IC: game is starting     sta $10003C = $01    *** Control B ***
   --- the Datel IC now removes MK3 ROM from the address
       space and routes the game cartridge through ---
9. Switch CPU to Emulation mode        sec / xce
10. Read the game cart's reset vector  jmp ($FFFC)
```

The critical handshake is step 8 (`sta $10003C = $01`). This is the **only** write the ROM ever does to Control B, and it is permanent for the rest of the session. From this moment the Datel IC is in "game mode": the cartridge bus carries the game ROM, the MK3 EPROM is silent, the Datel IC quietly compares every address against its seven code slots, and the PAR-NMI hook is the only path back into MK3 code.

#### 19.6 PAR-NMI: The Datel IC Calling Back into ROM-Resident Logic

When the game's NMI fires, the Datel IC redirects it through slots 5 and 6 to a handler at `$80:AE12` (section 8.2). This is the only routine in the MK3 ROM that runs *during* the game. Its full protocol communication, from entry to exit:

```
Entry (registers saved at $AE12-$AE1F, then):
1. Set DP back to MK3 SRAM             lda #$6100 / tcd          ($AE21)
2. Control C = 0                       sta $206000 = $00         ($AE29)
   ("I'm running BIOS-side code now, hold the bus on the MK3 side")
3. Latch signal to internal SRAM       sta $007000 = $40         ($AE2F)
   (purpose unclear; possibly a "PAR-NMI tick" flag for the Datel IC)
4. Control D = 0                       sta $008000 = $00         ($AE35)
   (acknowledges entry to the NMI; the IC may use this to release a hold line)
5. Run cheat patch list from SRAM      jsr $7033                 ($AE3F, SRAM)
6. Hand off to dispatcher in SRAM      jmp $7167                 ($AE42, SRAM)
   (SRAM trampoline; may run the combo decoder at $80:AE99 or the
    per-frame engine at $80:AECC -> $715F -> $80:AFD0)

Exit (after per-frame engine completes at $B083):
7. Mirror $61FE to HW LED reg          sta $086000               ($B085)
8. Control C = 1                       sta $206000 = $01         ($B08B)
   ("PAR-NMI done, hand the bus back to the game ROM")
9. Restore stack                       plb / pld / plx / ply / pla / plp
10. Resume game's NMI handler          jmp ($6180)               ($B09D)
   ($6180 in MK3 SRAM holds the game's original NMI vector,
    captured by the bus interception)
```

The handler reads input via manual joypad polling (`$4016`/`$4017`) at `$AE45+`, bypassing auto-joypad, because auto-joypad timing isn't guaranteed during a redirected NMI. The full ROM footprint the PAR-NMI may fetch -- counting the SRAM-trampoline re-entries -- is `$80:AE12`-`$80:B3F6`; see §8.2 for the per-range breakdown.

#### 19.7 LED Signalling Conventions

`$086000` has two meaningful bits: bit 0 (left LED) and bit 1 (right LED). The ROM writes the following values at specific lifecycle moments:

| Value | Pattern  | When written                         | Meaning                                     |
|-------|----------|--------------------------------------|---------------------------------------------|
| `$03` | both on  | `$80:9531` (walking self-check)      | "starting LED test"                         |
| `$02` | right on | `$80:953C` / `$80:815C`              | "init phase 2 complete" / step in animation |
| `$01` | left on  | `$80:9545` / `$80:8150`              | "init phase 1 complete" / step in animation |
| `$00` | both off | `$80:954E` / `$80:8107` / `$80:82A7` | "operational" / boot reset                  |

The walking sequence at boot (`03 -> 02 -> 01 -> 00`, with VBlank waits in between) functions as a visible heartbeat: a user sees both LEDs flash briefly and settle to off when the ROM is ready. If the system hangs in boot, the LEDs freeze in whatever state the last write left them, giving a primitive but useful diagnostic signal.

The LEDs are **write-only** to the ROM. There is no software way to confirm a particular LED state actually lit; the bus simply commits the byte and the LED driver takes it from there.

#### 19.8 What Is *Not* Communicated

The PCB design intentionally hides several things from the ROM:

- **The 3-way switch position.** Decided electrically by the 74HC4066 / HC74A combination. The ROM cannot read it, only infer it (if the ROM is running at all, the switch is in "Bottom").
- **Read-back of any IO register.** The Datel IC does not expose any of its write-only registers as readable. The ROM cannot verify whether a Control register actually took effect; it just writes and trusts.
- **The Datel IC's internal state.** No status byte, no slot enable flags, no last-hit indicator. All state that crosses the boundary lives in SRAM, which is shared memory rather than a protocol.
- **The cartridge contents** beyond the small windows enabled by Control A bit 4 (see sections 11.1 and 11.2). Even during a 32 KB snapshot, the ROM has to bracket the read with explicit "open and close" writes to Control A.

This minimalism is what makes the protocol reverse-engineerable: the surface area is small (8 distinct registers), every interaction is a one-way write, and the side effects are mostly visible at the cartridge bus level.

#### 19.9 Protocol Summary

For a future emulator that wants to support MK3 ROMs running natively:

1. **Memory map:** mirror 32 KB of SRAM into banks `$00/$02/$04/$06` at `$6000-$7FFF`. Allow the same physical SRAM to be read and written via these mirrors and via `$7E:6000-$7FFF` when the data bank allows.
2. **Code slot registers:** accept writes to `$100000-$10001B` and store them as seven 4-byte entries. On every CPU instruction fetch, compare the fetch address against the seven hook addresses; on a match, return the stored DTA byte instead of the cartridge byte.
3. **Control A (`$10001C`):** bit 4 toggles between "MK3 ROM in bank `$80-$BF`" and "game cart ROM in bank `$80-$BF`". Bits 6-7 force the PPU's reported region.
4. **Control B (`$10003C`):** writing `$01` permanently switches to game-mode mapping.
5. **Control C (`$206000`):** bit 0 tells the Datel IC which side currently owns the cart bus. The ROM writes `$00` on PAR-NMI entry (`$AE2B`) and `$01` on PAR-NMI exit (`$B08B`); the emulator should mirror the MK3 BIOS into `$xx:AE12-$B3F6` (and gate cheat-slot intercepts off) while Control C is `0`, and revert to the game ROM when Control C goes `1`. Boot-time writes `$00` from `$8107` / `$96A3` keep BIOS-mode active until Control B latches game-mode.
6. **Control D (`$008000`):** ack/latch for PAR-NMI entry; writing `$00` enters the cycle.
7. **LEDs (`$086000`):** bits 0 and 1 drive the two front-panel LEDs *only* during boot patterns and the manual Select+Up/Down toggle path. The runtime per-frame engine masks bit 0 of every write, so emulators must instead snoop `$00:61FE` for the live blink (see §20.3 and §20.4).
8. **PAR-NMI:** when bit 4 of Control A is `1` and Control B has been written, the NMI signal from the SNES PPU is redirected through code slots 5 and 6 to the handler at `$80:AE12` (slots program the constant `#$AE12`). The full ROM footprint the handler may fetch -- including SRAM-trampoline re-entries into the per-frame engine and trainer-count routine -- is `$80:AE12-$80:B3F6`. An emulator that maps only the entry page (`$AE00-$AFFF`) will see the PAR-NMI start but the LED 2 / trainer compute will read garbage from the game ROM.

Implementing this surface in a cycle-accurate emulator should be enough to run the entire MK3 ROM, including game launch and live cheat application.

---

### 20. Live Gameplay: The Trainer and the Runtime LED Engine

Sections 1 to 19 map the menu-side ROM. The two subsystems that actually run
*while a game is playing* -- the **Trainer** (Datel's "Code Finder") and the
**runtime LED signalling** -- live almost entirely inside the PAR NMI handler
(`$80:AE20`, section 8.2) and the SRAM trampoline it calls. This section
reconstructs both. Findings are tagged as **static** (from the ROM disassembly)
or **HW-verified** (confirmed on real hardware via an sd2snes / FX Pak Pro port
of the MK3 core).

#### 20.1 PAR-NMI Input Decode (`$80:AE99`)

After the manual joypad read, the handler matches the pad word in `$61:1B`
against a fixed combo table. That word is `$51 eor $4F` (controller 2 XOR
controller 1, built at `$AE84`); with a single controller it reduces to
controller 1. It uses the standard SNES serial bit order:

| Bit    | 0 | 1 | 2      | 3     | 4  | 5    | 6    | 7     | 8 | 9 | 10 | 11 |
|--------|---|---|--------|-------|----|------|------|-------|---|---|----|----|
| Button | B | Y | Select | Start | Up | Down | Left | Right | A | X | L  | R  |

The compare chain at `$AE9D-$AECC`:

| `$1B`   | Buttons        | Branch  | Effect                                                         |
|---------|----------------|---------|----------------------------------------------------------------|
| `$0204` | Select + X     | `$AEE3` | `$61AE = 0`, `jmp $72A7` -- **start / "same value as before"** |
| `$0006` | Select + Y     | `$AEF7` | `$61AE = 1`, `jmp $72A7` -- **"value lower"**                  |
| `$0104` | Select + A     | `$AF01` | `$61AE = 2`, `jmp $72A7` -- **"value higher"**                 |
| `$0005` | Select + B     | `$AEED` | `$61AE = 3`, `jmp $72A7` -- **"absolutely different"**         |
| `$0804` | Select + R     | `$AECF` | `jsr $74E7`, `jmp $713E` -- **activate found parameter**       |
| `$000C` | Select + Start | `$AEE0` | `jmp $749F` -- **clear trainer**                               |
| `$0014` | Select + Up    | `$AF0B` | toggle `$619B`, run LED update                                 |
| `$0024` | Select + Down  | `$AF2D` | toggle `$619C`, run LED update                                 |
| `$0404` | Select + L     | `$AED5` | toggle `$61F3`                                                 |
| else    | --             | `$715F` | normal per-frame update (no valid combo held)                  |

**(static)** The first six rows map **exactly** onto the trainer key
combinations printed in the manual (Select + X / Y / A / B / R, and Select +
Start to clear). This confirms that the four search directions are encoded as a
single byte `$61AE` (0 = same, 1 = lower, 2 = higher, 3 = different) handed to
the comparison scan at `$72A7`. `Select` is hard-wired in this decode path; the
manual's option to switch the trainer button to `Start` presumably patches these
compare constants or selects an alternate table -- that path was not traced.

#### 20.2 The Trainer: A Relative-Value Search

**(static + manual)** The trainer is a classic **relative (comparison) memory
search** -- it never needs the absolute value, only how it changed:

1. **Start** (Select + X, mode 0): the scan walks SNES work RAM and records the
   current value of every candidate address. The pointer is set up at `$80:A496`
   (`$61:82/84 = $7E:0000`, 16-bit counter in `$61:9F`); the scan itself runs
   from the SRAM trampoline at `$72A7`.
2. **Narrow**: the player changes the value in-game (e.g. loses a life), then
   states the *relation* via Select + Y / A / X / B. The scan re-reads WRAM and
   keeps only the addresses whose change matches `$61AE`.
3. **Repeat** until a single address survives.
4. **Activate** (Select + R -> `$74E7`): the surviving address is written into a
   cheat slot and frozen, exactly like a hand-entered code.

Because the handler runs as the game's NMI (via the slot-5/6 vector hook), it
has full WRAM visibility every frame -- that is what makes an in-game scan
possible at all. The candidate set is held in the SRAM region classified as
"user data / further usage" in section 14; its exact byte layout still needs a
live RAM watch to pin down.

> **Trainer compatibility.** The manual notes the trainer works only with a
> minority of games. A title that relocates or double-buffers the tracked value
> never converges, and LED 2 then stays **solid on** rather than narrowing to a
> blink (because `$61CA` keeps reading back as `$0000`, which the runtime engine
> at `$80:B3E2` interprets as "no surviving candidate" and translates to mode
> `$61FD = 3 = solid on`; see §20.3). A solid LED 2 after Select + X is therefore
> *not* proof of a broken hook -- it can simply be an incompatible game.

#### 20.3 The Runtime LED Engine

The earlier LED notes (sections 9.2 / 19.7) describe only the boot-time patterns
written directly to `$086000`. *During gameplay* the LEDs are driven from
direct-page state in MK3 SRAM and modulated into a blink:

| DP      | Role                                                                           |
|---------|--------------------------------------------------------------------------------|
| `$619B` | LED 1 (left) blink phase, toggled `eor #$01` by Select+Up                      |
| `$619C` | LED 2 (right) blink phase, toggled `eor #$01` by Select+Down                   |
| `$61FB` | per-frame counter, increments 0..`$20`, wraps at `$21 -> $00` (see `$80:AFD0`) |
| `$61FC` | LED 1 mode code: 0=off, 1=fast blink, 2=slow blink, 3=toggle every frame       |
| `$61FD` | LED 2 mode code: 0=off, 1=fast blink, 2=slow blink, 3=solid on                 |
| `$61FE` | **live LED output** (bit0 = LED 1 (group), bit1 = LED 2 (trainer)              |
| `$61CA` | running candidate count, written by the count-walker at `$80:B35F`             |
| `$61CD` | previous candidate count (`$61CA` snapshot from the prior NMI tick)            |
| `$61CC` | stability counter for the slow-blink decision (`$61CA == $CD`)                 |

**The runtime engine lives in ROM, not SRAM.** Earlier drafts of this section
attributed the per-frame LED build to an SRAM trampoline at `$715F` and treated
it as opaque. A closer pass on the disassembly shows the build is actually
ROM-resident at `$80:AFD0`-`$B083`; only the dispatch is in SRAM (the trampoline
at `$715F` is the entry point that the combo decoder jumps to from `$80:AECC`).
Walking it gives the four blink modes and their meaning explicitly.

**(static)** The visible LED build at `$AF13-AF49` is the **Select+Up/Down**
manual-toggle path, not the per-frame engine: it clears the target bit of
`$61FC`, ORs in the blink phase, then copies a masked value to the hardware
register. This is a side path for debugging / manual override:

```asm
80/AF13: lda $FC / and #$FE       ; LED 1: clear bit0 ...
80/AF19: lda $9B / ... / sta $FC  ;        ... OR in blink phase
80/AF20: lda $FE / and #$FE       ; shadow: force bit0 = 0
80/AF24: sta $FE / sta $086000    ; commit to HW LED register
80/AF35: lda $FC / and #$FD       ; LED 2: clear bit1, OR in $9C (same pattern)
80/AF43: lda $FE / and #$FE / sta $086000
```

**The per-frame engine (`$80:AFD0`-`$B083`).** Every NMI tick the engine
increments `$61FB`, then dispatches on `$61FC` (LED 1) and `$61FD` (LED 2):

```asm
80/AFD0: lda $FB / inc A / sta $FB
80/AFD5: cmp #$21 / bne $AFDB / stz $FB   ; wrap counter 0..$20

80/AFDB: lda $FC / cmp #$01 / beq $B00E                     ; LED 1 mode dispatch
80/AFE1:         cmp #$02 / beq $AFF5
80/AFE5:         cmp #$03 / beq $AFEB
80/AFE9:         bra  $B02B                                 ; mode 0 -> no LED 1 update

80/AFEB: lda $FE    / and #$FE / eor #$01 / sta $FE         ; mode 3: toggle bit0 every frame
80/AFF5: lda $FB    / cmp #$20 / bne $B02B                  ; mode 2 (slow): act only at $FB == $20
80/AFFB:   lda $FE  / and #$01 / eor #$01 / sta $AE         ;   compute new bit0
80/B003:   lda $FE  / and #$FE / clc / adc $AE / sta $FE
80/B00E: lda $FB    / cmp #$10 / beq $B018                  ; mode 1 (fast): act at $FB == $10 or $20
80/B014:   cmp #$20 / bne $B02B
80/B018:   ... same as slow but twice per cycle ...

80/B02B: lda $FD / cmp #$01 / beq $B066                     ; LED 2 mode dispatch -- same structure
80/B033:         cmp #$02  / beq $B04D
80/B037:         cmp #$03  / beq $B043
80/B03B:           lda $FE / and #$FD / sta $FE             ; mode 0 -> clear bit1 (LED 2 off)
80/B043:           lda $FE / and #$FD / eor #$02 / sta $FE  ; mode 3 -> force bit1 = 1 (SOLID ON)
80/B04D:           ... mode 2 (slow): toggle bit1 at $FB == $20 ...
80/B066:           ... mode 1 (fast): toggle bit1 at $FB == $10 or $20 ...

80/B083: lda $FE / sta $086000                              ; mirror to HW reg ($086000 bit0 always 0)
80/B089: lda #$01 / sta $206000                             ; Control C = 1 -> "BIOS execution done, hand back to game"
80/B08F: ... pop stack ... / jmp ($6180)                    ; resume the game's original NMI handler
```

**Mode mapping (`$61FC` / `$61FD`).**

| Code | LED 1 (`$61FC`)                                              | LED 2 (`$61FD`)                             |
|------|--------------------------------------------------------------|---------------------------------------------|
| `0`  | off (bit0 cleared on next frame in the `bra $B02B` default)  | off (bit1 cleared at `$B03B`)               |
| `1`  | fast blink (toggles at `$10` and `$20` -- ≈ 1.8 Hz at 60 Hz) | fast blink (same cadence)                   |
| `2`  | slow blink (toggles only at `$20` -- ≈ 0.9 Hz)               | slow blink (same cadence)                   |
| `3`  | toggle bit0 every single frame (≈ 30 Hz; visually steady)    | **solid on** (bit1 forced to 1 every frame) |

**Where the modes come from.** `$61FC` (LED 1) is driven by the active-cheat-group
state (groups A/B/both/none → modes 1/2/3/0 respectively). `$61FD` (LED 2) is
computed at `$80:B35F`-`$B3F6` from the trainer candidate count `$61CA`:

```asm
80/B35F: rep #$20
80/B361: lda #$7800 / sta $C2           ; pointer into the candidate area
80/B366: lda #$0000 / sta $C4
80/B36B: lda #$0000 / sta $CA           ; reset count
80/B370: lda [$C2] / cmp #$0000 / beq $B3A2  ; empty slot -> done
80/B377:   inc $CA                      ; non-empty -> count++
80/B37F:   advance $C2 by 4, wrap to next bank up to $7FF0
80/B3A0:   bra $B370

; convergence / stability decision
80/B3A4: lda $CA
80/B3A6:   cmp #$0000 / beq $B3C5       ;   count == 0  -> reset $CC, fall through
80/B3AB:   cmp #$01F4 / bcs $B3C5       ;   count >= 500 (almost everything) -> reset $CC, fall through
80/B3B0:   cmp $CD     / bne $B3C5      ;   count changed since last frame -> reset $CC, fall through
80/B3B6:   inc $CC                      ;   count stable -> bump stability
80/B3BF:   cmp #$04 / bcc $B3CB
80/B3C3:     bra $B3F0                  ;   stable for 4+ frames -> mode 2 (slow blink)
80/B3C5: stz $CC                        ;   not stable -> reset

; final mode code
80/B3CB: lda $CA / sta $CD              ; remember count for next frame
80/B3D1:   cmp #$0000 / beq $B3E2       ;   count == 0 -> mode 3 (solid on)
80/B3D6:   cmp #$0001 / beq $B3E9       ;   count == 1 -> mode 1 (fast blink) -- "found it"
80/B3DB:                                ;   else        -> mode 0 (off)
80/B3DD: lda #$00 / sta $FD / rts
80/B3E2: lda #$03 / sta $FD / rts       ; solid on
80/B3E9: lda #$01 / sta $FD / rts       ; fast blink
80/B3F0: lda #$02 / sta $FD / rts       ; slow blink (only reached via the stability branch)
```

So the actual LED 2 grammar is richer than the manual suggests:

| `$61CA` (candidate count)      | `$61FD` | LED 2 behaviour                                                           |
|--------------------------------|---------|---------------------------------------------------------------------------|
| `0`                            | `3`     | **solid on** -- "trainer armed but no candidates (or convergence failed)" |
| `1`                            | `1`     | fast blink -- "exactly one candidate, the value found"                    |
| 2 to 499, stable for ≥4 frames | `2`     | slow blink -- "actively narrowing, count steady"                          |
| 2 to 499, changing             | `0`     | off -- "scan still moving, wait for it to settle"                         |
| ≥500                           | `0`     | off -- "essentially every address still a candidate (initial scan)"       |

The decisive detail for emulators: **every** one of the twelve `$086000` writes
in the ROM either loads a boot constant (`$00`-`$03`) or loads `$61FE` with bit0
forced to 0 (`and #$FE`). So at runtime `$086000` bit0 is *always* 0 -- the
hardware LED register is **not** the live group-LED source. The live blink lives
in `$61FE`, written by the per-frame engine above.

LED meanings, cross-referenced with the manual and the disassembly:

| LED   | Position | Meaning                | Possible runtime states                                  |
|-------|----------|------------------------|----------------------------------------------------------|
| LED 1 | left     | active cheat **group** | off = none, fast = group A, slow = group B, solid = both |
| LED 2 | right    | **trainer** state      | off = inactive, slow = narrowing (stable count), fast = one found, **solid = no candidates** (initial or failed convergence) |

#### 20.4 Verified on Real Hardware

**(HW-verified)** Ported into an sd2snes / FX Pak Pro FPGA core and the
openFPGA / Analogue Pocket port, four findings were confirmed against the static
analysis above:

- **The NMI vector hook is real and fires every frame.** Counting fetches of
  `$00:FFEA` while a wrapped game runs shows a steady ~60 Hz -- the slot-5/6
  redirect (section 8.2) genuinely re-points the game's NMI at the handler. This
  is the MK3's foundational mechanism: without it, no cheat, trainer, or LED
  logic would run during gameplay.
- **The NMI vector points at `$80:AE12`, not `$AE20`.** Slots 5/6 are programmed
  with the constant `#$AE12` (see `$80:912B`); the handler then does its
  full 16-bit register save (`php`/`pha`/`phy`/`phx`/`phd`) before reaching the
  `phb` at `$AE20` that earlier drafts of this document used as the entry
  marker.
- **The LEDs live at `$00:61FE` -- both bits, not just bit 0.** Snooping
  `$00:61FE` on the bus reproduces the authentic blink for *both* LEDs: bit 0 is
  the group LED (fast = A, slow = B, solid = both, off = none), bit 1 is the
  trainer LED (off / slow / fast / **solid on**, mapped from `$61FD` as per
  §20.3). `$086000` bit 0 stays 0 throughout, exactly as the masking at
  `$AF20-$AF49` and `$B003-$B07F` predicts. Any emulator or clone that mirrors
  only `$086000` will show a dead group LED and a frozen trainer LED -- it must
  snoop `$00:61FE` instead.
- **The BIOS must remain mapped through the PAR-NMI's full footprint, not just
  the `$AE12` entry.** The Datel IC takes over the cartridge bus the moment the
  CPU fetches the NMI vector at `$00:FFEA/FFEB` and holds it until the handler
  writes `Control C = 1` at `$80:B08B`. During that window every CPU fetch in
  `$80:AE12`-`$80:B3F6` (LoROM-mirrored at `$00:AE12`-`$B3F6`) must come from
  the MK3 BIOS, not the wrapped game ROM. The openFPGA port initially mapped
  only `$AE00-$AFFF` and observed the symptom verbatim: LED 1 blinked correctly
  (per-frame engine entry at `$AFD0` falls inside `$AE00-$AFFF` and gets as far
  as the LED 1 branch at `$AFEB-$AFF3`, still inside the window), but LED 2
  froze on -- the LED 2 branch at `$B043` is *outside* `$AFFF` and so the CPU
  read game ROM there, executed garbage instead of `eor #$02`, and the trainer
  count routine at `$B35F` never updated `$61FD`. Widening the window to the
  full `$AE12-$B3F6` (or, page-aligned, `$AE00-$B3FF`) lets the LED 2 update
  run and the trainer behaves as documented.
