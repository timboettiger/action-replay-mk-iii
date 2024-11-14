# WOLFENSTEIN 3D DEADCODES

> (ACTION REPLAY II ONLY)

[Dead Code Overview](preservaction-deadc0de.md)


## Downloads

- [Hexdump](deadc0de/hexdumps/wolfenstein_3d.hex)
- [Binary](deadc0de/binaries/wolfenstein_3d.hex)
- [Assambler (Plain)](deadc0de/assembler/plain/wolfenstein_3d.hex)
- [Assambler (Annotated)](deadc0de/assembler/analyzed/wolfenstein_3d.hex)

## Unlimited Shots, Attempts, Keys

### Input

```hex
DEADCODE
00FD1500
4808E230
XXXXXXXX
XXXXXXXX
XXXXXXXX
XXXXXXXX
2868AF11
42005C15
FDC00000
```

> XXXXXXXX can be replaced by one or more of the following codes

**Unlimited shots:**
```hex
A90D8F57
897EEAEA
```

**Unlimited energy:**
```hex
A9638F55
897EEAEA
```

**Infinite lives:**
```hex
A9048F53
897EEAEA
```

**Always have both keys:**
```hex
A9038F5F
897EEAEA
```

### Analysis

```assembler
; 00 FD          ; Opcode for BRK instruction
    BRK                   ; 00 FD: BRK (Break)
                          ; Opcode 00: BRK (Break)
                          ; Causes a software interrupt or breakpoint, often used to end a subroutine or handle an interrupt

; 15 00          ; Opcode for ORA Direct Page,X
    ORA $00,X            ; 15 00: ORA (Logical Inclusive OR) with Direct Page,X
                          ; Opcode 15: ORA Direct Page,X
                          ; Operand 00: Combines the accumulator with the value at Zero Page address $00 offset by X

; 48             ; Opcode for PHA instruction
    PHA                   ; 48: PHA (Push Accumulator)
                          ; Opcode 48: PHA
                          ; Pushes the accumulator onto the stack, saving its current value

; 08             ; Opcode for PHP instruction
    PHP                   ; 08: PHP (Push Processor Status)
                          ; Opcode 08: PHP
                          ; Pushes the Processor Status Register onto the stack, saving the current processor state

; E2 30          ; Opcode and operand for SEP instruction
    SEP #$30              ; E2 30: SEP (Set Processor Status Bits)
                          ; Opcode E2: SEP
                          ; Operand 30: Sets bits 4 and 5, switching accumulator and index registers to 8-bit mode

; **Dynamic Code Options (Optional, can be included or omitted)**

; **Option 1: Unlimited Shots**
; A9 0D          ; Opcode and operand for LDA Immediate
    LDA #$0D              ; A9 0D: LDA Immediate with value $0D
                          ; Opcode A9: LDA Immediate
                          ; Operand 0D: Loads the value $0D into the accumulator, providing unlimited shots

; 8F 57 89 7E    ; Opcode and address for STA Absolute Long
    STA $7E8957           ; 8F 57 89 7E: STA Absolute Long to address $7E8957
                          ; Opcode 8F: STA (Store Accumulator) Absolute Long
                          ; Address: 57 89 7E (little-endian), which is $7E8957
                          ; Stores the accumulator value ($0D) to address $7E8957

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **Option 2: Unlimited Energy**
; A9 63          ; Opcode and operand for LDA Immediate
    LDA #$63              ; A9 63: LDA Immediate with value $63
                          ; Opcode A9: LDA Immediate
                          ; Operand 63: Loads the value $63 into the accumulator, representing unlimited energy

; 8F 55 89 7E    ; Opcode and address for STA Absolute Long
    STA $7E8955           ; 8F 55 89 7E: STA Absolute Long to address $7E8955
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 55 89 7E (little-endian), which is $7E8955
                          ; Stores the accumulator value ($63) to address $7E8955

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **Option 3: Infinite Lives**
; A9 04          ; Opcode and operand for LDA Immediate
    LDA #$04              ; A9 04: LDA Immediate with value $04
                          ; Opcode A9: LDA Immediate
                          ; Operand 04: Loads the value $04 into the accumulator, representing infinite lives

; 8F 53 89 7E    ; Opcode and address for STA Absolute Long
    STA $7E8953           ; 8F 53 89 7E: STA Absolute Long to address $7E8953
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 53 89 7E (little-endian), which is $7E8953
                          ; Stores the accumulator value ($04) to address $7E8953

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **Option 4: Always Have Both Keys**
; A9 03          ; Opcode and operand for LDA Immediate
    LDA #$03              ; A9 03: LDA Immediate with value $03
                          ; Opcode A9: LDA Immediate
                          ; Operand 03: Loads the value $03 into the accumulator, indicating possession of both keys

; 8F 5F 89 7E    ; Opcode and address for STA Absolute Long
    STA $7E895F           ; 8F 5F 89 7E: STA Absolute Long to address $7E895F
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 5F 89 7E (little-endian), which is $7E895F
                          ; Stores the accumulator value ($03) to address $7E895F

; EA EA          ; Opcodes for NOP
    NOP                   ; EA: NOP (No Operation)
    NOP                   ; EA: NOP (No Operation)

; **End of Dynamic Code Options**

; 28             ; Opcode for PLP instruction
    PLP                   ; 28: PLP (Pull Processor Status)
                          ; Opcode 28: PLP
                          ; Pulls the Processor Status Register from the stack, restoring the previous processor state

; 68             ; Opcode for PLA instruction
    PLA                   ; 68: PLA (Pull Accumulator)
                          ; Opcode 68: PLA
                          ; Pulls the top value from the stack into the accumulator, restoring its previous value

; AF 11 42 00    ; Opcode and address for LDA Absolute Long
    LDA $004211           ; AF 11 42 00: LDA Absolute Long from address $004211
                          ; Opcode AF: LDA (Load Accumulator) Absolute Long
                          ; Address: 11 42 00 (little-endian), which is $004211
                          ; Loads the accumulator with the value stored at memory address $004211

; 5C 15 FD C0    ; Opcode and address for JML instruction
    JML $C0FD15           ; 5C 15 FD C0: JML (Jump Long) to address $C0FD15
                          ; Opcode 5C: JML (Jump Long)
                          ; Address: 15 FD C0 (little-endian), which is $C0FD15
                          ; Jumps to the long address $C0FD15 to continue execution

; 00 00          ; Opcode for BRK instruction
    BRK                   ; 00 00: BRK (Break)
                          ; Opcode 00: BRK (Break)
                          ; Causes a software interrupt or breakpoint, often used to end a subroutine or handle an interrupt
```