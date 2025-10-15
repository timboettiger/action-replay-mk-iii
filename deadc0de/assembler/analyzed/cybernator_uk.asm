; Action Replay DEADC0DE Cheat
;   - Address-Hook: 0x808278
;   - Length: Dynamic (until EOF)
;
80/8278:    8F004200    sta $004200     ; Store accumulator at 0x004200.
80/827C:    A9038F      lda #$8F03      ; Load accumulator with value from '36611'.
80/827F:    6600        ror $00         ; Rotate right on 0x00.
80/8281:    7EEAEA      ror $EAEA,X     ; Rotate right on 0xEAEA.
80/8284:    A9068F      lda #$8F06      ; Load accumulator with value from '36614'.
80/8287:    5C007EEA    jmp $EA7E00     ; Jump to EA/7E00.
80/828B:    EA          nop             ; No operation.
80/828C:    A9038F      lda #$8F03      ; Load accumulator with value from '36611'.
80/828F:    6A          ror A           ; Rotate right on A.
80/8290:    00          brk             ; brk.
80/8291:    7EEAEA      ror $EAEA,X     ; Rotate right on 0xEAEA.
80/8294:    A9198F      lda #$8F19      ; Load accumulator with value from '36633'.
80/8297:    60          rts             ; Return from subroutine.
80/8298:    00          brk             ; brk.
80/8299:    7EEAEA      ror $EAEA,X     ; Rotate right on 0xEAEA.
80/829C:    A9038F      lda #$8F03      ; Load accumulator with value from '36611'.
80/829F:    68          pla             ; Pull accumulator from stack.
80/82A0:    00          brk             ; brk.
80/82A1:    7EEAEA      ror $EAEA,X     ; Rotate right on 0xEAEA.
80/82A4:    A9078F      lda #$8F07      ; Load accumulator with value from '36615'.
80/82A7:    5E007E      lsr $7E00,X     ; Logical shift right on 0x7E00.
80/82AA:    EA          nop             ; No operation.
80/82AB:    EA          nop             ; No operation.
80/82AC:    A9038F      lda #$8F03      ; Load accumulator with value from '36611'.
80/82AF:    6C007E      jmp ($7E00)     ; Jump to 80/7E00.
80/82B2:    EA          nop             ; No operation.
80/82B3:    EA          nop             ; No operation.
80/82B4:    A9B08F      lda #$8FB0      ; Load accumulator with value from '36784'.
80/82B7:    CA          dex             ; Decrement X register.
80/82B8:    147E        trb $7E         ; Test and reset bits at 0x7E.
80/82BA:    EA          nop             ; No operation.
80/82BB:    EA          nop             ; No operation.
80/82BC:    5C7C8280    jmp $80827C     ; Jump to 80/827C.
