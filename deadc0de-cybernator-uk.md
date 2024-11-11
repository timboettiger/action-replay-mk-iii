# CYBERNATOR DEADCODES (UK VERSION)

> (ACTION REPLAY II ONLY)

## Maximum/Unlimited Equipment

### Input

```hex
DEADCODE
80827800
8F004200
XXXXXXXX
XXXXXXXX
XXXXXXXX
XXXXXXXX
5C7C8280
```

> XXXXXXXX can be replaced by one or more of the following codes

**Maximum Vulcans:**
```hex
A9038F66
007EEAEA
```

**Unlimited Vulcans:**
```hex
A9068F5C
007EEAEA
```

**Maximum Missiles:**
```hex
A9038F6A
007EEAEA
```

**Unlimited Missiles:**
```hex
A919BF60
007EEAEA
```

**Maximum Laser:**
```hex
A9038F68
007EEAEA
```

**Unlimited Laser:**
```hex
A9078F5E
007EEAEA
```

**Maximum punch:**
```hex
A9038F6C
007EEAEA
```

**Unlimited energy:**
```hex
A9B08FCA
147EEAEA
```

### Analysis

```assembler
; 80 82          ; Opcode and operand for BRA instruction
    BRA $-126             ; 80 82: BRA (Branch Always) with relative offset -126
                          ; Opcode 80: BRA (Branch Always)
                          ; Operand 82: Relative offset (0x82 in two's complement is -126)
                          ; Branches back 126 bytes from the next instruction

; 78             ; Opcode for SEI
    SEI                   ; 78: SEI (Set Interrupt Disable)
                          ; Disables all interrupts until cleared

; 00             ; Opcode for BRK
    BRK                   ; 00: BRK (Break)
                          ; Causes a software interrupt or breakpoint

; 8F 00 42 00    ; Opcode and address for STA Absolute Long
    STA $004200           ; 8F 00 42 00: STA Absolute Long to address $004200
                          ; Opcode 8F: STA (Store Accumulator) Absolute Long
                          ; Address: 00 42 00 (little-endian format)
                          ; Stores the accumulator value to memory address $004200

; **Dynamic Code Options (Optional, can be omitted or replaced)**
; The following code blocks are optional and can be included or left out.

; 80 82          ; Opcode and operand for BRA instruction
    BRA $-126             ; 80 82: BRA (Branch Always) with relative offset -126
                          ; Opcode 80: BRA (Branch Always)
                          ; Operand 82: Relative offset (0x82 in two's complement is -126)
                          ; Branches back 126 bytes from the next instruction

; 78             ; Opcode for SEI
    SEI                   ; 78: SEI (Set Interrupt Disable)
                          ; Disables all interrupts until cleared

; 00             ; Opcode for BRK
    BRK                   ; 00: BRK (Break)
                          ; Causes a software interrupt or breakpoint

; 8F 00 42 00    ; Opcode and address for STA Absolute Long
    STA $004200           ; 8F 00 42 00: STA Absolute Long to address $004200
                          ; Opcode 8F: STA (Store Accumulator) Absolute Long
                          ; Address: 00 42 00 (little-endian format)
                          ; Stores the accumulator value to memory address $004200

; **Dynamic Code Options (Optional, can be included or omitted)**
; The following code blocks are optional and can be included or left out.

; **Option 1: Maximum Vulcans**
; A9 03          ; Opcode and operand for LDA Immediate
    LDA #$03              ; A9 03: LDA Immediate with value $03
                          ; Opcode A9: LDA Immediate
                          ; Operand 03: Loads the value $03 into the accumulator

; 8F 66 00 7E    ; Opcode and address for STA Absolute Long
    STA $7E0066           ; 8F 66 00 7E: STA Absolute Long to address $7E0066
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 66 00 7E (little-endian), which is $7E0066
                          ; Stores the accumulator value ($03) to address $7E0066

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)
                          ; Does nothing; used for timing or code alignment

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 2: Unlimited Vulcans**
; A9 06          ; Opcode and operand for LDA Immediate
    LDA #$06              ; A9 06: LDA Immediate with value $06
                          ; Opcode A9: LDA Immediate
                          ; Operand 06: Loads the value $06 into the accumulator

; 8F 5C 00 7E    ; Opcode and address for STA Absolute Long
    STA $7E005C           ; 8F 5C 00 7E: STA Absolute Long to address $7E005C
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 5C 00 7E (little-endian), which is $7E005C
                          ; Stores the accumulator value ($06) to address $7E005C

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 3: Maximum Missiles**
; A9 03          ; Opcode and operand for LDA Immediate
    LDA #$03              ; A9 03: LDA Immediate with value $03
                          ; Opcode A9: LDA Immediate
                          ; Operand 03: Loads the value $03 into the accumulator

; 8F 6A 00 7E    ; Opcode and address for STA Absolute Long
    STA $7E006A           ; 8F 6A 00 7E: STA Absolute Long to address $7E006A
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 6A 00 7E (little-endian), which is $7E006A
                          ; Stores the accumulator value ($03) to address $7E006A

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 4: Unlimited Missiles**
; A9 19          ; Opcode and operand for LDA Immediate
    LDA #$19              ; A9 19: LDA Immediate with value $19
                          ; Opcode A9: LDA Immediate
                          ; Operand 19: Loads the value $19 into the accumulator

; 8F 60 00 7E    ; Opcode and address for STA Absolute Long
    STA $7E0060           ; 8F 60 00 7E: STA Absolute Long to address $7E0060
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 60 00 7E (little-endian), which is $7E0060
                          ; Stores the accumulator value ($19) to address $7E0060

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 5: Maximum Laser**
; A9 03          ; Opcode and operand for LDA Immediate
    LDA #$03              ; A9 03: LDA Immediate with value $03
                          ; Opcode A9: LDA Immediate
                          ; Operand 03: Loads the value $03 into the accumulator

; 8F 68 00 7E    ; Opcode and address for STA Absolute Long
    STA $7E0068           ; 8F 68 00 7E: STA Absolute Long to address $7E0068
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 68 00 7E (little-endian), which is $7E0068
                          ; Stores the accumulator value ($03) to address $7E0068

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 6: Unlimited Laser**
; A9 07          ; Opcode and operand for LDA Immediate
    LDA #$07              ; A9 07: LDA Immediate with value $07
                          ; Opcode A9: LDA Immediate
                          ; Operand 07: Loads the value $07 into the accumulator

; 8F 5E 00 7E    ; Opcode and address for STA Absolute Long
    STA $7E005E           ; 8F 5E 00 7E: STA Absolute Long to address $7E005E
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 5E 00 7E (little-endian), which is $7E005E
                          ; Stores the accumulator value ($07) to address $7E005E

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 7: Maximum Punch**
; A9 03          ; Opcode and operand for LDA Immediate
    LDA #$03              ; A9 03: LDA Immediate with value $03
                          ; Opcode A9: LDA Immediate
                          ; Operand 03: Loads the value $03 into the accumulator

; 8F 6C 00 7E    ; Opcode and address for STA Absolute Long
    STA $7E006C           ; 8F 6C 00 7E: STA Absolute Long to address $7E006C
                          ; Opcode 8F: STA Absolute Long
                          ; Address: 6C 00 7E (little-endian), which is $7E006C
                          ; Stores the accumulator value ($03) to address $7E006C

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **Option 8: Unlimited Energy**
; A9 B0          ; Opcode and operand for LDA Immediate
    LDA #$B0              ; A9 B0: LDA Immediate with value $B0
                          ; Opcode A9: LDA Immediate
                          ; Operand B0: Loads the value $B0 into the accumulator

; 8F CA 14 7E    ; Opcode and address for STA Absolute Long
    STA $7E14CA           ; 8F CA 14 7E: STA Absolute Long to address $7E14CA
                          ; Opcode 8F: STA Absolute Long
                          ; Address: CA 14 7E (little-endian), which is $7E14CA
                          ; Stores the accumulator value ($B0) to address $7E14CA

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; EA             ; Opcode for NOP
    NOP                   ; EA: NOP (No Operation)

; **End of Dynamic Code Options**

; 5C 7C 82 80    ; Opcode and address for JML instruction
    JML $80827C           ; 5C 7C 82 80: JML (Jump Long) to address $80827C
                          ; Opcode 5C: JML (Jump to Long Address)
                          ; Address: 7C 82 80 (little-endian), which is $80827C
                          ; Jumps to the address $80827C to continue execution
```