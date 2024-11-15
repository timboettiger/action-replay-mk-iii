; DEADC0DE-Cheat, Action Replay MK2 only
; START Header-Block
00/8000: 8082        bra $7F84        ; Branch Always: Jump to the address $7F84 relative to the current program counter.
00/8002: 78          sei              ; Set Interrupt Disable: Disable all maskable interrupts.
00/8003: 008F        brk $8F          ; Break: Generates a software interrupt with vector lookup; the parameter $8F is typically ignored.
00/8005: 0042        brk $42          ; Break: Generates a software interrupt with vector lookup; the parameter $42 is typically ignored.
00/8007: 00.         brk              ; Break: Generates a software interrupt
; END Header-Block

00/8008: A9038F      lda lda #$8F03   ; Load Accumulator with Immediate Value: Load the value $8F03 into the accumulator.
00/800B: 6600        ror $00          ; Rotate Right: Rotate the value at address $00 one bit to the right.
00/800D: 7EEAEA      ror $EAEA,X      ; Rotate Right: Rotate the value at $EAEA + X one bit to the right.

00/8010: A9068F      lda #$8F06       ; Load Accumulator with Immediate Value: Load the value $8F06 into the accumulator.
00/8013: 5C007EEA    jmp $EA7E00      ; Jump: Jump to absolute long address $EA7E00.
00/8017: EA          nop              ; No Operation: Perform no operation.
00/8018: A9038F      lda #$8F03       ; Load Accumulator with Immediate Value: Load the value $8F03 into the accumulator.
00/801B: 6A          ror A            ; Rotate Right Accumulator: Rotate the accumulator one bit to the right.
00/801C: 007E        brk $7E          ; Break: Generates a software interrupt with vector lookup; the parameter $7E is typically ignored.
00/801E: EA          nop              ; No Operation: Perform no operation.
00/801F: EA          nop              ; No Operation: Perform no operation.

00/8020: A919BF      lda #$BF19       ; Load Accumulator with Immediate Value: Load the value $BF19 into the accumulator.
00/8023: 60          rts              ; Return from Subroutine: Return to the address stored on the stack.
00/8024: 007E        brk $7E          ; Break: Generates a software interrupt with vector lookup; the parameter $7E is typically ignored.
00/8026: EA          nop              ; No Operation: Perform no operation.
00/8027: EA          nop              ; No Operation: Perform no operation.

00/8028: A9038F      lda #$8F03       ; Load Accumulator with Immediate Value: Load the value $8F03 into the accumulator.
00/802B: 68          pla              ; Pull Accumulator from Stack: Restore the accumulator value from the stack.
00/802C: 007E        brk $7E          ; Break: Generates a software interrupt with vector lookup; the parameter $7E is typically ignored.
00/802E: EA          nop              ; No Operation: Perform no operation.
00/802F: EA          nop              ; No Operation: Perform no operation.

00/8030: A9078F      lda #$8F07       ; Load Accumulator with Immediate Value: Load the value $8F07 into the accumulator.
00/8033: 5E007E      lsr $7E00,X      ; Logical Shift Right: Shift the value at $7E00 + X one bit to the right.
00/8036: EA          nop              ; No Operation: Perform no operation.
00/8037: EA          nop              ; No Operation: Perform no operation.

00/8038: A9038F      lda #$8F03       ; Load Accumulator with Immediate Value: Load the value $8F03 into the accumulator.
00/803B: 6C007E      jmp ($7E00)      ; Jump Indirect: Jump to the address stored at $7E00.
00/803E: EA          nop              ; No Operation: Perform no operation.
00/803F: EA          nop              ; No Operation: Perform no operation.

00/8040: A9B08F      lda #$8FB0       ; Load Accumulator with Immediate Value: Load the value $8FB0 into the accumulator.
00/8043: CA          dex              ; Decrement X Register: Subtract 1 from the X register.
00/8044: 147E        trb $7E          ; Test and Reset Bits: Reset bits in memory at $7E where corresponding accumulator bits are 1.
00/8046: EA          nop              ; No Operation: Perform no operation.
00/8047: EA          nop              ; No Operation: Perform no operation.

; START Footer-Block
00/8048: 5C7C8280    jmp $80827C      ; Jump: Jump to absolute long address $80827C.
; END Footer-Block