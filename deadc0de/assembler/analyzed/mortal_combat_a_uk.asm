; DEADC0DE-Cheat, Action Replay MK2 only
; Version A, Full Blood During Combat
; Begin with this code
; Try code version B if this code did not work
80E6        bra $7FE8        ; Branch Always: Jump to the address $7FE8 relative to the current program counter.
9B          txy              ; Transfer X to Y: Copy the value in the X register to the Y register.
08          php              ; Push Processor Status to Stack: Save the current processor status onto the stack.
08          php              ; Push Processor Status to Stack: Save the current processor status onto the stack again.
C230        rep #$30         ; Reset Processor Flags: Set 16-bit accumulator and index register modes.
A20000      ldx #$0000       ; Load X Register with Immediate Value: Load the value $0000 into the X register.
A91600      lda #$0016       ; Load Accumulator with Immediate Value: Load $0016 into the accumulator.
9F301480    sta $801430,X    ; Store Accumulator: Store the accumulator value into absolute indexed address $801430,X.
E8          inx              ; Increment X Register: Add 1 to the X register.
E8          inx              ; Increment X Register: Add 1 to the X register again.
E00800      cpx #$0008       ; Compare X Register: Compare X with the immediate value $0008.
D0F2        bne $800A        ; Branch if Not Equal: If the comparison result is not zero, jump to $800A.
28          plp              ; Pull Processor Status from Stack: Restore processor status from the stack.
08          php              ; Push Processor Status to Stack: Save the processor status onto the stack.
E220        sep #$20         ; Set Processor Flags: Set the processor to 8-bit accumulator mode (index unchanged).
9C2121      stz $2121        ; Store Zero: Write zero to absolute address $2121.
5CA1E680    jmp $80E6A1      ; Jump: Jump to absolute long address $80E6A1.
00                           ; Incomplete or padding opcode, possibly intentional for alignment.