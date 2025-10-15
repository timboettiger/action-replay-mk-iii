; Action Replay DEADC0DE Cheat
;   - Address-Hook: 0x80E69B
;   - Length: 8 DWORDs (32 bytes)
;
80/E69B:    08          php             ; Push processor status onto stack.
80/E69C:    C230        rep #$30        ; Clear processor status bits present in 0b00110000.
80/E69E:    A20000      ldx #$0000      ; Load X register with '0'.
80/E6A1:    A91600      lda #$0016      ; Load accumulator with value from '22'.
80/E6A4:    9F301480    sta $801430,X   ; Store accumulator at 0x801430.
80/E6A8:    E8          inx             ; Increment X register.
80/E6A9:    E8          inx             ; Increment X register.
80/E6AA:    E00800      cpx #$0008      ; Compare X register with '8'.
80/E6AD:    D0F2        bne $E6A1       ; Branch to 80/E6A1 if not equal.
80/E6AF:    28          plp             ; Pull processor status from stack.
80/E6B0:    08          php             ; Push processor status onto stack.
80/E6B1:    E220        sep #$20        ; Set processor status bits present in 0b00100000.
80/E6B3:    9C2121      stz $2121       ; Store zero at CGADD - CGRAM Address.
80/E6B6:    5CA1E680    jmp $80E6A1     ; Jump to 80/E6A1.
80/E6BA:    00          brk             ; brk.
