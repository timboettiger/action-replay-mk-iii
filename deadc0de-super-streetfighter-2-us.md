# SUPER STREETFIGHTER II DEADCODES (US VERSION)

> (ACTION REPLAY II ONLY)

[Dead Code Overview](preservaction-deadc0de.md)


## Downloads

- [Hexdump](deadc0de/hexdumps/super_streetfighter_2_us.hex)
- [Binary](deadc0de/binaries/super_streetfighter_2_us.hex)
- [Assambler (Plain)](deadc0de/assembler/plain/super_streetfighter_2_us.hex)
- [Assambler (Annotated)](deadc0de/assembler/analyzed/super_streetfighter_2_us.hex)

## Next Stage

> Player 1 moves on to the next battle when the select button is pressed

### Input

```hex
DEADCODE
C0025C09
ADA800C9
0020D00A
E230A9FF
8F71077E
C230AD1A
42AA5C60
02C00000
```

### Analysis

```assembler
; C0 02          ; Opcode and operand for CPY Immediate
    CPY #$02              ; C0 02: CPY Immediate with value $02
                          ; Opcode C0: CPY (Compare Y Register) Immediate
                          ; Operand 02: Compares the Y register with the immediate value $02
                          ; Sets the processor flags based on the result of the comparison

; 5C 09 C0 02    ; Opcode and address for JML instruction
    JML $02C009           ; 5C 09 C0 02: JML (Jump Long) to address $02C009
                          ; Opcode 5C: JML (Jump Long)
                          ; Address: 09 C0 02 (little-endian), which is $02C009
                          ; Jumps to the long address $02C009, transferring control there

; AD A8 00       ; Opcode and address for LDA Absolute
    LDA $00A8             ; AD A8 00: LDA Absolute to address $00A8
                          ; Opcode AD: LDA (Load Accumulator) Absolute
                          ; Address A8 00 (little-endian), which is $00A8
                          ; Loads the accumulator with the value stored at memory address $00A8

; C9 00          ; Opcode and operand for CMP Immediate
    CMP #$00              ; C9 00: CMP Immediate with value $00
                          ; Opcode C9: CMP (Compare Accumulator) Immediate
                          ; Operand 00: Compares the accumulator with the immediate value $00
                          ; Sets the processor flags based on the result

; 20 D0 0A       ; Opcode and address for JSR Absolute
    JSR $0AD0             ; 20 D0 0A: JSR (Jump to Subroutine) to address $0AD0
                          ; Opcode 20: JSR (Jump to Subroutine) Absolute
                          ; Address D0 0A (little-endian), which is $0AD0
                          ; Jumps to subroutine at address $0AD0 and pushes the return address onto the stack

; E2 30          ; Opcode and operand for SEP instruction
    SEP #$30              ; E2 30: SEP (Set Processor Status Bits)
                          ; Opcode E2: SEP
                          ; Operand 30: Sets bits 4 and 5, switching accumulator and index registers to 8-bit mode

; A9 FF          ; Opcode and operand for LDA Immediate
    LDA #$FF              ; A9 FF: LDA Immediate with value $FF
                          ; Opcode A9: LDA Immediate
                          ; Operand FF: Loads the value $FF into the accumulator

; 8F 71 07 7E    ; Opcode and address for STA Absolute Long
    STA $7E0771           ; 8F 71 07 7E: STA Absolute Long to address $7E0771
                          ; Opcode 8F: STA (Store Accumulator) Absolute Long
                          ; Address 71 07 7E (little-endian), which is $7E0771
                          ; Stores the accumulator value ($FF) to memory address $7E0771

; C2 30          ; Opcode and operand for REP instruction
    REP #$30              ; C2 30: REP (Reset Processor Status Bits)
                          ; Opcode C2: REP
                          ; Operand 30: Resets bits 4 and 5, setting accumulator and index registers to 16-bit mode

; AD 1A 42       ; Opcode and address for LDA Absolute
    LDA $421A             ; AD 1A 42: LDA Absolute to address $421A
                          ; Opcode AD: LDA (Load Accumulator) Absolute
                          ; Address 1A 42 (little-endian), which is $421A
                          ; Loads the accumulator with the value stored at memory address $421A

; AA             ; Opcode for TAX instruction
    TAX                   ; AA: TAX (Transfer Accumulator to X Register)
                          ; Opcode AA: TAX
                          ; Transfers the value in the accumulator to the X register

; 5C 60 02 C0    ; Opcode and address for JML instruction
    JML $C00260           ; 5C 60 02 C0: JML (Jump Long) to address $C00260
                          ; Opcode 5C: JML (Jump Long)
                          ; Address: 60 02 C0 (little-endian), which is $C00260
                          ; Jumps to the long address $C00260 to continue execution

; 00 00          ; Opcode for BRK instruction
    BRK                   ; 00 00: BRK (Break)
                          ; Opcode 00: BRK (Break)
                          ; Causes a software interrupt or breakpoint, often used to end a subroutine or handle an interrupt
```