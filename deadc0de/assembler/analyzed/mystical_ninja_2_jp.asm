; Action Replay DEADC0DE Cheat
;   - Address-Hook: 0x8087B4
;   - Length: Dynamic (until EOF)
;
80/87B4:    E230        sep #$30        ; Set processor status bits present in 0b00110000.
80/87B6:    EA          nop             ; No operation.
80/87B7:    EA          nop             ; No operation.
80/87B8:    A902        lda #$02        ; Load accumulator with value from '2'.
80/87BA:    8F60047E    sta $7E0460     ; Store accumulator at Work RAM (WRAM) (at 7E/0460).
80/87BE:    EA          nop             ; No operation.
80/87BF:    EA          nop             ; No operation.
80/87C0:    A906        lda #$06        ; Load accumulator with value from '6'.
80/87C2:    8F46047E    sta $7E0446     ; Store accumulator at Work RAM (WRAM) (at 7E/0446).
80/87C6:    EA          nop             ; No operation.
80/87C7:    EA          nop             ; No operation.
80/87C8:    A909        lda #$09        ; Load accumulator with value from '9'.
80/87CA:    8F75047E    sta $7E0475     ; Store accumulator at Work RAM (WRAM) (at 7E/0475).
80/87CE:    EA          nop             ; No operation.
80/87CF:    EA          nop             ; No operation.
80/87D0:    A909        lda #$09        ; Load accumulator with value from '9'.
80/87D2:    8F98047E    sta $7E0498     ; Store accumulator at Work RAM (WRAM) (at 7E/0498).
80/87D6:    EA          nop             ; No operation.
80/87D7:    EA          nop             ; No operation.
80/87D8:    A999        lda #$99        ; Load accumulator with value from '153'.
80/87DA:    8FAE007E    sta $7E00AE     ; Store accumulator at Work RAM (WRAM) (at 7E/00AE).
80/87DE:    EA          nop             ; No operation.
80/87DF:    EA          nop             ; No operation.
80/87E0:    A900        lda #$00        ; Load accumulator with value from '0'.
80/87E2:    7EEAEA      ror $EAEA,X     ; Rotate right on 0xEAEA.
80/87E5:    C210        rep #$10        ; Clear processor status bits present in 0b00010000.
80/87E7:    5CB88780    jmp $8087B8     ; Jump to 80/87B8.
80/87EB:    00          brk             ; brk.
80/87EC:    00          brk             ; brk.
