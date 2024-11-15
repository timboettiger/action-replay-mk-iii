; DEADC0DE-Cheat, Action Replay MK2 only
; Version B, Full Blood During Combat
; Try this code if the previous code (Version A) did not work
80E6        bra $7FE8        ; Branch Always: Jump to the address $7FE8 relative to the current program counter.
CF0808C2    cmp $C20808      ; Compare Accumulator with memory at absolute long address $C20808.
30A2        bmi $7FAA        ; Branch if Minus: Jump to $7FAA if the result of the previous operation sets the negative flag.
00          brk              ; Break: Generates a software interrupt.
00          brk              ; Break: Generates a software interrupt.
A91600      lda #$0016       ; Load Accumulator with Immediate Value: Load $0016 into the accumulator.
9F6A1480    sta $80146A,X    ; Store Accumulator: Store the accumulator value into absolute indexed address $80146A,X.
E8          inx              ; Increment X Register: Add 1 to the X register.
E8          inx              ; Increment X Register: Add 1 to the X register again.
E00800      cpx #$0008       ; Compare X Register: Compare X with the immediate value $0008.
D0F2        bne $800A        ; Branch if Not Equal: If the comparison result is not zero, jump to $800A.
28          plp              ; Pull Processor Status from Stack: Restore processor status from the stack.
08          php              ; Push Processor Status to Stack: Save processor status onto the stack.
E220        sep #$20         ; Set Processor Flags: Set the processor to 8-bit accumulator mode (index unchanged).
9C2121      stz $2121        ; Store Zero: Write zero to absolute address $2121.
5C9C2121    jmp $21219C      ; Jump: Jump to absolute long address $21219C.
5C                           ; Incomplete or padding opcode, possibly intentional for alignment.