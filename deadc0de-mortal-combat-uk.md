# MORTAL COMBAT DEADCODES (UK VERSION)

> (ACTION REPLAY II ONLY)

## Full Blood During Combat (A)

### Input

```hex
DEADCODE
80E69B08
08C230A2
0000A916
009F3014
80E8E8E0
0800D0F2
2808E220
9C21215C
A1E68000
```

> XXXXXXXX can be replaced by one or more of the following codes

### Analysis

```assembler
; 80 E6             ; Opcode and operand for BRA instruction
    BRA $-26               ; 80 E6: BRA (Branch Always) with relative offset -26
                           ; Opcode 80: BRA
                           ; Operand E6: Offset -26 (0xE6 in two's complement is -26)
                           ; Branches back 26 bytes from the next instruction

; 9B                ; Opcode for TXY
    TXY                      ; 9B: TXY (Transfer X to Y)
                             ; Transfers the contents of X register to Y register

; 08                ; Opcode for PHP
    PHP                      ; 08: PHP (Push Processor Status)
                             ; Pushes the processor status register onto the stack

; 08                ; Opcode for PHP
    PHP                      ; 08: PHP (Push Processor Status)
                             ; Pushes the processor status register onto the stack again

; C2 30             ; Opcode and operand for REP #imm8
    REP #$30                ; C2 30: REP #$30
                             ; Opcode C2: REP (Reset Processor Status Bits)
                             ; Operand 30: Bits to reset (bits 4 and 5)
                             ; Sets accumulator and index registers to 16-bit mode

; A2 00 00          ; Opcode and operand for LDX #imm16
    LDX #$0000               ; A2 00 00: LDX Immediate 16-bit
                             ; Opcode A2: LDX Immediate
                             ; Operand 00 00: Loads X register with $0000

; A9 16 00          ; Opcode and operand for LDA #imm16
    LDA #$0016               ; A9 16 00: LDA Immediate 16-bit
                             ; Opcode A9: LDA Immediate
                             ; Operand 16 00: Loads accumulator with $0016

; 9F 30 14 80       ; Opcode and address for STA Absolute Long,X
    STA $801430,X            ; 9F 30 14 80: STA Absolute Long,X
                             ; Opcode 9F: STA Absolute Long,X
                             ; Address: 30 14 80 (little-endian), which is $801430
                             ; Stores accumulator at address $801430 + X

; 80 E8             ; Opcode and operand for BRA instruction
    BRA $-24               ; 80 E8: BRA (Branch Always) with relative offset -24
                             ; Operand E8: Offset -24 (0xE8 in two's complement is -24)
                             ; Branches back 24 bytes from the next instruction

; E8                ; Opcode for INX
    INX                      ; E8: INX (Increment X Register)
                             ; Increments X by 1

; E0 08 00          ; Opcode and operand for CPX #imm16
    CPX #$0008               ; E0 08 00: CPX Immediate 16-bit
                             ; Opcode E0: CPX Immediate
                             ; Operand 08 00: Compares X with $0008

; D0 F2             ; Opcode and operand for BNE
    BNE $-14               ; D0 F2: BNE (Branch if Not Equal) with relative offset -14
                             ; Operand F2: Offset -14 (0xF2 in two's complement is -14)
                             ; Branches if zero flag is clear (X ≠ $0008)

; 28                ; Opcode for PLP
    PLP                      ; 28: PLP (Pull Processor Status)
                             ; Restores the processor status from the stack

; 08                ; Opcode for PHP
    PHP                      ; 08: PHP (Push Processor Status)
                             ; Pushes the processor status register onto the stack

; E2 20             ; Opcode and operand for SEP #imm8
    SEP #$20                ; E2 20: SEP #$20
                             ; Opcode E2: SEP (Set Processor Status Bits)
                             ; Operand 20: Bits to set (bit 5)
                             ; Sets accumulator to 8-bit mode

; 9C 21 21          ; Opcode and address for STZ Absolute
    STZ $2121                ; 9C 21 21: STZ Absolute
                             ; Opcode 9C: STZ Absolute
                             ; Address: 21 21 (little-endian), which is $2121
                             ; Stores zero to address $2121

; 5C A1 E6 80       ; Opcode and address for JML instruction
    JML $80E6A1             ; 5C A1 E6 80: JML Absolute Long
                             ; Opcode 5C: JML (Jump Long)
                             ; Address: A1 E6 80 (little-endian), which is $80E6A1
                             ; Jumps to the address $80E6A1

; 00                ; Opcode for BRK
    BRK                      ; 00: BRK (Break)
                             ; Causes a software interrupt or breakpoint
```

## Full Blood During Combat (B)

> Use this code if the previous code did not work

### Input

```hex
80E6CF08
08C230A2
0000A916
009F6A14
80E8E8E0
0800D0F2
2808E220
9C21215C
9C21215C
```

### Analysis

```assembler
; 80 E6             ; Opcode and operand for BRA instruction
    BRA $-26               ; 80 E6: BRA (Branch Always) with relative offset -26
                           ; Opcode 80: BRA (Branch Always)
                           ; Operand E6: Relative offset (-26 in two's complement)
                           ; Branches back 26 bytes from the next instruction

; CF 08 C2 30       ; Opcode and address for CMP Absolute Long
    CMP $30C208           ; CF 08 C2 30: CMP Absolute Long
                           ; Opcode CF: CMP (Compare Accumulator) Absolute Long
                           ; Address: 08 C2 30 (little-endian), which is $30C208
                           ; Compares the accumulator with the value at memory address $30C208

; A2 00 00          ; Opcode and operand for LDX #imm16
    LDX #$0000             ; A2 00 00: LDX Immediate 16-bit
                           ; Opcode A2: LDX Immediate
                           ; Operand 00 00: Loads X register with $0000

; A9 16 00          ; Opcode and operand for LDA #imm16
    LDA #$0016             ; A9 16 00: LDA Immediate 16-bit
                           ; Opcode A9: LDA Immediate
                           ; Operand 16 00: Loads accumulator with $0016

; 9F 6A 14 80       ; Opcode and address for STA Absolute Long,X
    STA $80146A,X          ; 9F 6A 14 80: STA Absolute Long,X
                           ; Opcode 9F: STA Absolute Long,X
                           ; Address: 6A 14 80 (little-endian), which is $80146A
                           ; Stores accumulator at address $80146A plus X register

; E8                ; Opcode for INX
    INX                    ; E8: INX (Increment X Register)
                           ; Increments X register by 1

; E8                ; Opcode for INX
    INX                    ; E8: INX (Increment X Register)
                           ; Increments X register by 1 again

; E0 08 00          ; Opcode and operand for CPX #imm16
    CPX #$0008             ; E0 08 00: CPX Immediate 16-bit
                           ; Opcode E0: CPX Immediate
                           ; Operand 08 00: Compares X register with $0008

; D0 F2             ; Opcode and operand for BNE
    BNE $-14               ; D0 F2: BNE (Branch if Not Equal) with relative offset -14
                           ; Operand F2: Offset -14 (in two's complement)
                           ; Branches back 14 bytes if zero flag is clear (X ≠ $0008)

; 28                ; Opcode for PLP
    PLP                    ; 28: PLP (Pull Processor Status)
                           ; Restores the processor status from the stack

; 08                ; Opcode for PHP
    PHP                    ; 08: PHP (Push Processor Status)
                           ; Pushes the processor status register onto the stack

; E2 20             ; Opcode and operand for SEP #imm8
    SEP #$20               ; E2 20: SEP #$20
                           ; Opcode E2: SEP (Set Processor Status Bits)
                           ; Operand 20: Sets bit 5 (sets accumulator to 8-bit mode)

; 9C 21 21          ; Opcode and address for STZ Absolute
    STZ $2121              ; 9C 21 21: STZ Absolute
                           ; Opcode 9C: STZ (Store Zero) Absolute
                           ; Address: 21 21 (little-endian), which is $2121
                           ; Stores zero to memory address $2121

; 5C 9C 21 21       ; Opcode and address for JML instruction
    JML $219C21            ; 5C 9C 21 21: JML Absolute Long
                           ; Opcode 5C: JML (Jump Long)
                           ; Address: 9C 21 21 (little-endian), which is $219C21
                           ; Jumps to the long address $219C21

; 9C 21 21          ; Opcode and address for STZ Absolute
    STZ $2121              ; 9C 21 21: STZ Absolute
                           ; Stores zero to memory address $2121 again
                           
; 5C                ; Opcode for JML
                           ; 5C: JML (Jump Long)
                           ; **Missing operand bytes for JML instruction**
```

## Level Skip

> Level skip - when select is pressed your player moves to the next stage.

### Input

```hex
DEADCODE
OOFEE40E
08C23048
5ADAE230
AF194200
2920F01D
AF42007E
C90BF015
A9FD8F71
047EA9FE
8F72047E
AF42007E
1A8F4200
7EC230FA
7A68285C
EAFE8000
```

### Analysis

```assembler
; 00 FE E4 0E       ; Opcodes for BRK and INC Absolute,X
    BRK                     ; 00: BRK (Break)
                            ; Causes a software interrupt or breakpoint

    INC $0EE4,X             ; FE E4 0E: INC Absolute,X
                            ; Opcode FE: INC Absolute,X
                            ; Address E4 0E (little-endian) is $0EE4
                            ; Increments the value at address $0EE4 plus X register

; 08                ; Opcode for PHP
    PHP                     ; 08: PHP (Push Processor Status)
                            ; Pushes the processor status register onto the stack

; C2 30             ; Opcode and operand for REP #imm8
    REP #$30                ; C2 30: REP #$30
                            ; Opcode C2: REP (Reset Processor Status Bits)
                            ; Operand 30: Resets bits 4 and 5 (sets accumulator and index to 16-bit mode)

; 48                ; Opcode for PHA
    PHA                     ; 48: PHA (Push Accumulator)
                            ; Pushes the accumulator onto the stack

; 5A                ; Opcode for PHY
    PHY                     ; 5A: PHY (Push Y Register)
                            ; Pushes the Y register onto the stack

; DA                ; Opcode for PHX
    PHX                     ; DA: PHX (Push X Register)
                            ; Pushes the X register onto the stack

; E2 30             ; Opcode and operand for SEP #imm8
    SEP #$30                ; E2 30: SEP #$30
                            ; Opcode E2: SEP (Set Processor Status Bits)
                            ; Operand 30: Sets bits 4 and 5 (sets accumulator and index to 8-bit mode)

; AF 19 42 00       ; Opcode and address for LDA Absolute Long
    LDA $004219             ; AF 19 42 00: LDA Absolute Long
                            ; Opcode AF: LDA Absolute Long
                            ; Address: 19 42 00 (little-endian), which is $004219
                            ; Loads accumulator with value at address $004219

; 29 20             ; Opcode and operand for AND #imm8
    AND #$20                ; 29 20: AND Immediate
                            ; Opcode 29: AND Immediate
                            ; Operand 20: ANDs accumulator with $20

; F0 1D             ; Opcode and operand for BEQ
    BEQ $+29                ; F0 1D: BEQ (Branch if Equal)
                            ; Operand 1D: Branches ahead 29 bytes if zero flag is set

; AF 42 00 7E       ; Opcode and address for LDA Absolute Long
    LDA $7E0042             ; AF 42 00 7E: LDA Absolute Long
                            ; Loads accumulator with value at address $7E0042

; C9 0B             ; Opcode and operand for CMP #imm8
    CMP #$0B                ; C9 0B: CMP Immediate
                            ; Compares accumulator with $0B

; F0 15             ; Opcode and operand for BEQ
    BEQ $+21                ; F0 15: BEQ (Branch if Equal)
                            ; Branches ahead 21 bytes if zero flag is set

; A9 FD             ; Opcode and operand for LDA #imm8
    LDA #$FD                ; A9 FD: LDA Immediate
                            ; Loads accumulator with $FD

; 8F 71 04 7E       ; Opcode and address for STA Absolute Long
    STA $7E0471             ; 8F 71 04 7E: STA Absolute Long
                            ; Stores accumulator at address $7E0471

; A9 FE             ; Opcode and operand for LDA #imm8
    LDA #$FE                ; A9 FE: LDA Immediate
                            ; Loads accumulator with $FE

; 8F 72 04 7E       ; Opcode and address for STA Absolute Long
    STA $7E0472             ; 8F 72 04 7E: STA Absolute Long
                            ; Stores accumulator at address $7E0472

; AF 42 00 7E       ; Opcode and address for LDA Absolute Long
    LDA $7E0042             ; AF 42 00 7E: LDA Absolute Long
                            ; Loads accumulator with value at address $7E0042

; 1A                ; Opcode for INC A
    INC A                   ; 1A: INC A
                            ; Increments the accumulator by 1

; 8F 42 00 7E       ; Opcode and address for STA Absolute Long
    STA $7E0042             ; 8F 42 00 7E: STA Absolute Long
                            ; Stores accumulator at address $7E0042

; C2 30             ; Opcode and operand for REP #imm8
    REP #$30                ; C2 30: REP #$30
                            ; Resets bits 4 and 5 (sets accumulator and index to 16-bit mode)

; FA                ; Opcode for PLX
    PLX                     ; FA: PLX (Pull X Register)
                            ; Pulls the X register from the stack

; 7A                ; Opcode for PLY
    PLY                     ; 7A: PLY (Pull Y Register)
                            ; Pulls the Y register from the stack

; 68                ; Opcode for PLA
    PLA                     ; 68: PLA (Pull Accumulator)
                            ; Pulls the accumulator from the stack

; 28                ; Opcode for PLP
    PLP                     ; 28: PLP (Pull Processor Status)
                            ; Restores the processor status from the stack

; 5C EA FE 80       ; Opcode and address for JML instruction
    JML $80FEEA             ; 5C EA FE 80: JML Absolute Long
                            ; Opcode 5C: JML (Jump Long)
                            ; Address: EA FE 80 (little-endian), which is $80FEEA
                            ; Jumps to the long address $80FEEA

; 00                ; Opcode for BRK
    BRK                     ; 00: BRK (Break)
                            ; Causes a software interrupt or breakpoint
```

