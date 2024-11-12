# MYSTICAL NINJA 2 DEADCODES (JP VERSION)

> (ACTION REPLAY II ONLY)

[Dead Code Overview](preservaction-deadc0de.md)

## Maximum/Unlimited Equipment, Level Skip

### Input

```hex
DEADCODE
8087B400
E230EAEA
XXXXXXXX
XXXXXXXX
XXXXXXXX
XXXXXXXX
C2105CB8
87800000
```

> XXXXXXXX can be replaced by one or more of the following codes

**Always have full magic batton:**
```hex
A9028F60
047EEAEA
```

**Unlimited energy:**
```hex
A9068F46
047EEAEA
```

**Unlimited coins:**
```hex
A9098F75
047EEAEA
```

**Infinite lives:**
```hex
A9098F98
047EEAEA
```

**Unlimited time:**
```hex
A9998FAE
007EEAEA
```

**Level select:**

> Warning: Use a blank save game as this will keep adding to the level!

> Hint: Replace XX with desired level

```hex
A9XX8F92
007EEAEA
```

### Analysis

```assembler
; 80 87          ; Opcode and operand for BRA instruction
    BRA $-121             ; 80 87: BRA (Branch Always) with relative offset -121
                          ; Opcode 80: BRA (Branch Always)
                          ; Operand 87: Relative offset (0x87 in two's complement is -121)
                          ; Branches back 121 bytes from the next instruction

; B4 00          ; Opcode for LDY Zero Page,X
    LDY $00,X             ; B4 00: LDY Zero Page,X
                          ; Opcode B4: LDY Zero Page,X
                          ; Address 00: Loads Y register with the value from Zero Page address $00 offset by X register

; E2 30          ; Opcode and operand for REP instruction
    REP #$30              ; E2 30: REP #$30 (Reset Processor Status Bits)
                          ; Opcode E2: REP
                          ; Operand 30: Resets bits 4 and 5
                          ; Sets Accumulator and Index Registers to 16-bit mode

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)
                          ; Does nothing; used for timing or code alignment

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Dynamic Code Options (Optional, can be included or omitted)**

; **Option 1: Always Have Full Magic Batton**
; A9 02          ; Opcode and operand for LDA Immediate
    LDA #$02              ; A9 02: LDA Immediate with value $02
                          ; Opcode A9: LDA Immediate
                          ; Operand 02: Loads the value $02 into the accumulator, representing full magic batton

; 8F 60 04 7E    ; Opcode and address for STA Absolute Long
    STA $7E0460           ; 8F 60 04 7E: STA Absolute Long to address $7E0460
                          ; Opcode 8F: STA (Store Accumulator) Absolute Long
                          ; Address: 60 04 7E (little-endian), which is $7E0460
                          ; Stores the accumulator value ($02) to address $7E0460

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 2: Unlimited Energy**
; A9 06          ; Opcode and operand for LDA Immediate
    LDA #$06              ; A9 06: LDA Immediate with value $06
                          ; Opcode A9: LDA Immediate
                          ; Operand 06: Loads the value $06 into the accumulator, representing unlimited energy

; 8F 46 04 7E    ; Opcode and address for STA Absolute Long
    STA $7E0446           ; 8F 46 04 7E: STA Absolute Long to address $7E0446
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 46 04 7E (little-endian), which is $7E0446
                          ; Stores the accumulator value ($06) to address $7E0446

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 3: Unlimited Coins**
; A9 09          ; Opcode and operand for LDA Immediate
    LDA #$09              ; A9 09: LDA Immediate with value $09
                          ; Opcode A9: LDA Immediate
                          ; Operand 09: Loads the value $09 into the accumulator, representing unlimited coins

; 8F 75 04 7E    ; Opcode and address for STA Absolute Long
    STA $7E0475           ; 8F 75 04 7E: STA Absolute Long to address $7E0475
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 75 04 7E (little-endian), which is $7E0475
                          ; Stores the accumulator value ($09) to address $7E0475

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 4: Infinite Lives**
; A9 09          ; Opcode and operand for LDA Immediate
    LDA #$09              ; A9 09: LDA Immediate with value $09
                          ; Opcode A9: LDA Immediate
                          ; Operand 09: Loads the value $09 into the accumulator, representing infinite lives

; 8F 98 04 7E    ; Opcode and address for STA Absolute Long
    STA $7E0498           ; 8F 98 04 7E: STA Absolute Long to address $7E0498
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 98 04 7E (little-endian), which is $7E0498
                          ; Stores the accumulator value ($09) to address $7E0498

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 5: Unlimited Time**
; A9 99          ; Opcode and operand for LDA Immediate
    LDA #$99              ; A9 99: LDA Immediate with value $99
                          ; Opcode A9: LDA Immediate
                          ; Operand 99: Loads the value $99 into the accumulator, representing unlimited time

; 8F AE 00 7E    ; Opcode and address for STA Absolute Long
    STA $7E00AE           ; 8F AE 00 7E: STA Absolute Long to address $7E00AE
                          ; Opcode 8F: STA Absolute Long
                          ; Address: AE 00 7E (little-endian), which is $7E00AE
                          ; Stores the accumulator value ($99) to address $7E00AE

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 6: Level Select**
; A9 XX          ; Opcode and operand for LDA Immediate (replace XX with desired level)
    LDA #$XX              ; A9 XX: LDA Immediate with variable value $XX
                          ; Opcode A9: LDA Immediate
                          ; Operand XX: Loads the value $XX into the accumulator for level selection

; 8F 92 00 7E    ; Opcode and address for STA Absolute Long
    STA $7E0092           ; 8F 92 00 7E: STA Absolute Long to address $7E0092
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 92 00 7E (little-endian), which is $7E0092
                          ; Stores the accumulator value ($XX) to address $7E0092

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **End of Dynamic Code Options**

; C2 10          ; Opcode and operand for REP instruction
    REP #$10              ; C2 10: REP #$10
                          ; Opcode C2: REP (Reset Processor Status Bits)
                          ; Operand 10: Resets bit 4, setting the Index Register to 16-bit mode

; 5C B8 87 80    ; Opcode and address for JML instruction
    JML $8087B8           ; 5C B8 87 80: JML (Jump Long) to address $8087B8
                          ; Opcode 5C: JML (Jump Long)
                          ; Address: B8 87 80 (little-endian), which is $8087B8
                          ; Jumps to the address $8087B8 to continue execution

; 87 80 00 00    ; Opcode and address for STA Direct Page
    STA $0080             ; 87 80: STA Direct Page
                          ; Opcode 87: STA (Store Accumulator) Direct Page
                          ; Address 80: Stores the accumulator value to direct page address $0080

; 00             ; Opcode for BRK
    BRK                   ; 00: BRK (Break)
                          ; Causes a software interrupt or breakpoint, often used to trigger debugging or end a subroutine
```