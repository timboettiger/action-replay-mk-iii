; Action Replay DEADC0DE Cheat
;   - Address-Hook: 0x00FEE4
;   - Length: 14 DWORDs (56 bytes)
;
00/FEE4:    08          php             ; Push processor status onto stack.
00/FEE5:    C230        rep #$30        ; Clear processor status bits present in 0b00110000.
00/FEE7:    48          pha             ; Push accumulator onto stack.
00/FEE8:    5A          phy             ; Push Y register onto stack.
00/FEE9:    DA          phx             ; Push X register onto stack.
00/FEEA:    E230        sep #$30        ; Set processor status bits present in 0b00110000.
00/FEEC:    AF194200    lda $004219     ; Load accumulator with value from 0x004219.
00/FEF0:    2920        and #$20        ; Logical AND with '32'.
00/FEF2:    F01D        beq $FF11       ; Branch to 00/FF11 if equal.
00/FEF4:    AF42007E    lda $7E0042     ; Load accumulator with value from Work RAM (WRAM) (at 7E/0042).
00/FEF8:    C90B        cmp #$0B        ; Compare accumulator with '11'.
00/FEFA:    F015        beq $FF11       ; Branch to 00/FF11 if equal.
00/FEFC:    A9FD        lda #$FD        ; Load accumulator with value from '253'.
00/FEFE:    8F71047E    sta $7E0471     ; Store accumulator at Work RAM (WRAM) (at 7E/0471).
00/FF02:    A9FE        lda #$FE        ; Load accumulator with value from '254'.
00/FF04:    8F72047E    sta $7E0472     ; Store accumulator at Work RAM (WRAM) (at 7E/0472).
00/FF08:    AF42007E    lda $7E0042     ; Load accumulator with value from Work RAM (WRAM) (at 7E/0042).
00/FF0C:    1A          inc A           ; Increment value at A.
00/FF0D:    8F42007E    sta $7E0042     ; Store accumulator at Work RAM (WRAM) (at 7E/0042).
00/FF11:    C230        rep #$30        ; Clear processor status bits present in 0b00110000.
00/FF13:    FA          plx             ; Pull X register from stack.
00/FF14:    7A          ply             ; Pull Y register from stack.
00/FF15:    68          pla             ; Pull accumulator from stack.
00/FF16:    28          plp             ; Pull processor status from stack.
00/FF17:    5CEAFE80    jmp $80FEEA     ; Jump to 80/FEEA.
00/FF1B:    00          brk             ; brk.
