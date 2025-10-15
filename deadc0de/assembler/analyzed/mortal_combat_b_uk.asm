; Action Replay DEADC0DE Cheat
;   - Address-Hook: 0x80E6CF
;   - Length: 8 DWORDs (32 bytes)
;
80/E6CF:    08          php             ; Push processor status onto stack.
80/E6D0:    C230        rep #$30        ; Clear processor status bits present in 0b00110000.
80/E6D2:    A20000      ldx #$0000      ; Load X register with '0'.
80/E6D5:    A91600      lda #$0016      ; Load accumulator with value from '22'.
80/E6D8:    9F6A1480    sta $80146A,X   ; Store accumulator at 0x80146A.
80/E6DC:    E8          inx             ; Increment X register.
80/E6DD:    E8          inx             ; Increment X register.
80/E6DE:    E00800      cpx #$0008      ; Compare X register with '8'.
80/E6E1:    D0F2        bne $E6D5       ; Branch to 80/E6D5 if not equal.
80/E6E3:    28          plp             ; Pull processor status from stack.
80/E6E4:    08          php             ; Push processor status onto stack.
80/E6E5:    E220        sep #$20        ; Set processor status bits present in 0b00100000.
80/E6E7:    9C2121      stz $2121       ; Store zero at CGADD - CGRAM Address.
80/E6EA:    5C9C2121    jmp $21219C     ; Jump to 21/219C.
80/E6EE:	5C
