# STARFOX/STARWING DEADCODES (UK VERSION)

> (ACTION REPLAY II ONLY)

[Dead Code Overview](preservaction-deadc0de.md)


## Downloads

- [Hexdump](deadc0de/hexdumps/starfox_uk.hex)
- [Binary](deadc0de/binaries/starfox_uk.hex)
- [Assambler (Plain)](deadc0de/assembler/plain/starfox_uk.hex)
- [Assambler (Annotated)](deadc0de/assembler/analyzed/starfox_uk.hex)

## Infinite/Unlimited Energy/Bombs

> This is for infinite energy and unlimited Nova bombs

### Input

```hex
DEADCODE
02FC7A06
08E220A9
288D9603
A9058DAD
15286468
64695C7E
FC020000
```

### Analysis

```assembler
; 02 FC           ; Opcode and operand for COP instruction
    COP $FC               ; 02 FC: COP (Coprocessor Enable) with immediate vector $FC
                          ; Opcode 02: COP (Coprocessor Enable)
                          ; Operand FC: Specifies the vector to be used when a coprocessor interrupt occurs
                          ; This triggers a software interrupt

; 7A             ; Opcode for PLY instruction
    PLY                   ; 7A: PLY (Pull Y Register)
                          ; Opcode 7A: PLY
                          ; Pulls the Y Register from the stack, restoring its previous value

; 06             ; Opcode for ASL Direct Page
    ASL $06               ; 06: ASL (Arithmetic Shift Left) Direct Page
                          ; Opcode 06: ASL (Arithmetic Shift Left)
                          ; Address 06: Shifts the value at direct page address $06 one bit to the left, effectively multiplying it by 2

; 08             ; Opcode for PHP instruction
    PHP                   ; 08: PHP (Push Processor Status)
                          ; Opcode 08: PHP
                          ; Pushes the Processor Status Register onto the stack, saving the current processor state

; E2 20          ; Opcode and operand for SEP instruction
    SEP #$20              ; E2 20: SEP (Set Processor Status Bits)
                          ; Opcode E2: SEP
                          ; Operand 20: Sets bit 5, switching the accumulator to 8-bit mode

; A9 28          ; Opcode and operand for LDA Immediate
    LDA #$28              ; A9 28: LDA Immediate with value $28
                          ; Opcode A9: LDA Immediate
                          ; Operand 28: Loads the value $28 into the accumulator

; 8D 96 03       ; Opcode and address for STA Absolute
    STA $0396             ; 8D 96 03: STA Absolute to address $0396
                          ; Opcode 8D: STA (Store Accumulator) Absolute
                          ; Address 96 03 (little-endian), which is $0396
                          ; Stores the accumulator value ($28) to memory address $0396

; A9 05          ; Opcode and operand for LDA Immediate
    LDA #$05              ; A9 05: LDA Immediate with value $05
                          ; Opcode A9: LDA Immediate
                          ; Operand 05: Loads the value $05 into the accumulator

; 8D AD 15       ; Opcode and address for STA Absolute
    STA $15AD             ; 8D AD 15: STA Absolute to address $15AD
                          ; Opcode 8D: STA (Store Accumulator) Absolute
                          ; Address AD 15 (little-endian), which is $15AD
                          ; Stores the accumulator value ($05) to memory address $15AD

; 28             ; Opcode for PLP instruction
    PLP                   ; 28: PLP (Pull Processor Status)
                          ; Opcode 28: PLP
                          ; Pulls the Processor Status Register from the stack, restoring the previous processor state

; 64 68          ; Opcode and address for STZ Direct Page
    STZ $68               ; 64 68: STZ (Store Zero) Direct Page
                          ; Opcode 64: STZ (Store Zero) Direct Page
                          ; Address 68: Stores zero to direct page address $68, effectively clearing it

; 64 69          ; Opcode and address for STZ Direct Page
    STZ $69               ; 64 69: STZ (Store Zero) Direct Page
                          ; Opcode 64: STZ (Store Zero) Direct Page
                          ; Address 69: Stores zero to direct page address $69, effectively clearing it

; 5C 7E FC 02    ; Opcode and address for JML instruction
    JML $02FC7E           ; 5C 7E FC 02: JML (Jump Long) to address $02FC7E
                          ; Opcode 5C: JML (Jump to Long Address)
                          ; Address: 7E FC 02 (little-endian), which is $02FC7E
                          ; Jumps to the long address $02FC7E, transferring control there

; 00 00          ; Opcode for BRK instruction
    BRK                   ; 00 00: BRK (Break)
                          ; Opcode 00: BRK (Break)
                          ; Causes a software interrupt or breakpoint, often used to signal the end of a subroutine or handle an interrupt
```