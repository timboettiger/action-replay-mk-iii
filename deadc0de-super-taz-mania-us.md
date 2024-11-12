# TAZ-MANIA DEADCODES (US VERSION)

> (ACTION REPLAY II ONLY)

[Dead Code Overview](preservaction-deadc0de.md)

## Unlimited Time, Attempts, Energy

### Input

```hex
DEADCODE
9A898700
08E220EA
XXXXXXXX
XXXXXXXX
XXXXXXXX
XXXXXXXX
28A5B225
AA5C8B89
9A000000
```

> XXXXXXXX can be replaced by one or more of the following codes

**Unlimited energy:**
```hex
A9108F96
007EEAEA
```

**You only need to collect 1 Kiwi:**
```hex
A9018F2E
707EEAEA
```

**Unlimited time:**
```hex
A9308F98
007EEAEA
```

**Unlimited continues:**
```hex
A9058F20
707EEAEA
```

**Slow motion when running forward:**
```hex
A9068F8A
007EEAEA
```

**Extra Continues every time you gain more points:**
```hex
A9028F22
707EEAEA
```

**The timer runs down at about double the speed:**
```hex
A9008F24
707EEAEA
```

**Timer runs backwards:**
```hex
A9028F2A
707EEAEA
```

### Analysis

```assembler
; 9A             ; Opcode for TXS instruction
    TXS                   ; 9A: TXS (Transfer X Register to Stack Pointer)
                          ; Opcode 9A: TXS
                          ; Transfers the current value in the X register to the Stack Pointer, effectively setting the stack location

; 89 87 00       ; Opcode and operand for BIT Immediate
    BIT #$0087            ; 89 87 00: BIT Immediate with value $0087
                          ; Opcode 89: BIT (Test Bits) Immediate
                          ; Operand 87 00: Performs a bitwise AND between the Accumulator and $0087, setting flags based on the result

; 08             ; Opcode for PHP instruction
    PHP                   ; 08: PHP (Push Processor Status)
                          ; Opcode 08: PHP
                          ; Pushes the Processor Status Register onto the stack, saving the current processor state

; E2 20          ; Opcode and operand for SEP instruction
    SEP #$20              ; E2 20: SEP (Set Processor Status Bits)
                          ; Opcode E2: SEP
                          ; Operand 20: Sets bit 5, switching the accumulator to 8-bit mode

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)
                          ; Does nothing; used for timing or code alignment

; **Dynamic Code Options (Optional, can be included or omitted)**

; **Option 1: Unlimited Energy**
; A9 10          ; Opcode and operand for LDA Immediate
    LDA #$10              ; A9 10: LDA Immediate with value $10
                          ; Opcode A9: LDA Immediate
                          ; Operand 10: Loads the value $10 into the accumulator, representing unlimited energy

; 8F 96 00 7E    ; Opcode and address for STA Absolute Long
    STA $7E0096           ; 8F 96 00 7E: STA Absolute Long to address $7E0096
                          ; Opcode 8F: STA (Store Accumulator) Absolute Long
                          ; Address: 96 00 7E (little-endian), which is $7E0096
                          ; Stores the accumulator value ($10) to address $7E0096

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **Option 2: Only Need to Collect 1 Kiwi**
; A9 01          ; Opcode and operand for LDA Immediate
    LDA #$01              ; A9 01: LDA Immediate with value $01
                          ; Opcode A9: LDA Immediate
                          ; Operand 01: Loads the value $01 into the accumulator, requiring only 1 Kiwi to collect

; 8F 2E 70 7E    ; Opcode and address for STA Absolute Long
    STA $7E702E           ; 8F 2E 70 7E: STA Absolute Long to address $7E702E
                          ; Opcode 8F: STA (Store Accumulator) Absolute Long
                          ; Address: 2E 70 7E (little-endian), which is $7E702E
                          ; Stores the accumulator value ($01) to address $7E702E

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **Option 3: Unlimited Time**
; A9 30          ; Opcode and operand for LDA Immediate
    LDA #$30              ; A9 30: LDA Immediate with value $30
                          ; Opcode A9: LDA Immediate
                          ; Operand 30: Loads the value $30 into the accumulator, representing unlimited time

; 8F 98 00 7E    ; Opcode and address for STA Absolute Long
    STA $7E0098           ; 8F 98 00 7E: STA Absolute Long to address $7E0098
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 98 00 7E (little-endian), which is $7E0098
                          ; Stores the accumulator value ($30) to address $7E0098

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **Option 4: Unlimited Continues**
; A9 05          ; Opcode and operand for LDA Immediate
    LDA #$05              ; A9 05: LDA Immediate with value $05
                          ; Opcode A9: LDA Immediate
                          ; Operand 05: Loads the value $05 into the accumulator, representing unlimited continues

; 8F 20 70 7E    ; Opcode and address for STA Absolute Long
    STA $7E7020           ; 8F 20 70 7E: STA Absolute Long to address $7E7020
                          ; Opcode 8F: STA (Store Accumulator) Absolute Long
                          ; Address: 20 70 7E (little-endian), which is $7E7020
                          ; Stores the accumulator value ($05) to address $7E7020

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **Option 5: Slow Motion When Running Forward**
; A9 06          ; Opcode and operand for LDA Immediate
    LDA #$06              ; A9 06: LDA Immediate with value $06
                          ; Opcode A9: LDA Immediate
                          ; Operand 06: Loads the value $06 into the accumulator, enabling slow motion while running forward

; 8F 8A 70 7E    ; Opcode and address for STA Absolute Long
    STA $7E708A           ; 8F 8A 70 7E: STA Absolute Long to address $7E708A
                          ; Opcode 8F: STA (Store Accumulator) Absolute Long
                          ; Address: 8A 70 7E (little-endian), which is $7E708A
                          ; Stores the accumulator value ($06) to address $7E708A

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **Option 6: Extra Continues Every Time You Gain More Points**
; A9 02          ; Opcode and operand for LDA Immediate
    LDA #$02              ; A9 02: LDA Immediate with value $02
                          ; Opcode A9: LDA Immediate
                          ; Operand 02: Loads the value $02 into the accumulator, granting extra continues upon scoring more points

; 8F 22 70 7E    ; Opcode and address for STA Absolute Long
    STA $7E7022           ; 8F 22 70 7E: STA Absolute Long to address $7E7022
                          ; Opcode 8F: STA (Store Accumulator) Absolute Long
                          ; Address: 22 70 7E (little-endian), which is $7E7022
                          ; Stores the accumulator value ($02) to address $7E7022

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **Option 7: Timer Runs Down at Double Speed**
; A9 00          ; Opcode and operand for LDA Immediate
    LDA #$00              ; A9 00: LDA Immediate with value $00
                          ; Opcode A9: LDA Immediate
                          ; Operand 00: Loads the value $00 into the accumulator, doubling timer speed

; 8F 24 70 7E    ; Opcode and address for STA Absolute Long
    STA $7E7024           ; 8F 24 70 7E: STA Absolute Long to address $7E7024
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 24 70 7E (little-endian), which is $7E7024
                          ; Stores the accumulator value ($00) to address $7E7024

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **Option 8: Timer Runs Backwards**
; A9 02          ; Opcode and operand for LDA Immediate
    LDA #$02              ; A9 02: LDA Immediate with value $02
                          ; Opcode A9: LDA Immediate
                          ; Operand 02: Loads the value $02 into the accumulator, making the timer run backwards

; 8F 2A 70 7E    ; Opcode and address for STA Absolute Long
    STA $7E702A           ; 8F 2A 70 7E: STA Absolute Long to address $7E702A
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 2A 70 7E (little-endian), which is $7E702A
                          ; Stores the accumulator value ($02) to address $7E702A

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **End of Dynamic Code Options**

; 28             ; Opcode for PLP instruction
    PLP                   ; 28: PLP (Pull Processor Status)
                          ; Opcode 28: PLP
                          ; Pulls the Processor Status Register from the stack, restoring the previous processor state

; A5 B2          ; Opcode and operand for LDA Direct Page
    LDA $B2               ; A5 B2: LDA Direct Page with address $B2
                          ; Opcode A5: LDA (Load Accumulator) Direct Page
                          ; Address B2: Loads the accumulator with the value stored at direct page address $B2

; 25 AA          ; Opcode and operand for AND Direct Page
    AND $AA               ; 25 AA: AND Direct Page with address $AA
                          ; Opcode 25: AND (Logical AND) Direct Page
                          ; Address AA: Performs a bitwise AND between the accumulator and the value at direct page address $AA

; 5C 8B 89 9A    ; Opcode and address for JML instruction
    JML $9A898B           ; 5C 8B 89 9A: JML (Jump Long) to address $9A898B
                          ; Opcode 5C: JML (Jump Long)
                          ; Address: 8B 89 9A (little-endian), which is $9A898B
                          ; Jumps to the long address $9A898B to continue execution

; 00 00          ; Opcode for BRK instruction
    BRK                   ; 00 00: BRK (Break)
                          ; Opcode 00: BRK (Break)
                          ; Causes a software interrupt or breakpoint, often used to end a subroutine or handle an interrupt
```