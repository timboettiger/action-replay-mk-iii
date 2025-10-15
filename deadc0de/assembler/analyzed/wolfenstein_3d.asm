; Action Replay DEADC0DE Cheat
;   - Address-Hook: 0x00FD15
;   - Length: Dynamic (until EOF)
;
00/FD15:    48          pha             ; Push accumulator onto stack.
00/FD16:    08          php             ; Push processor status onto stack.
00/FD17:    E230        sep #$30        ; Set processor status bits present in 0b00110000.
00/FD19:    A90D        lda #$0D        ; Load accumulator with value from '13'.
00/FD1B:    8F57897E    sta $7E8957     ; Store accumulator at Work RAM (WRAM) (at 7E/8957).
00/FD1F:    EA          nop             ; No operation.
00/FD20:    EA          nop             ; No operation.
00/FD21:    A963        lda #$63        ; Load accumulator with value from '99'.
00/FD23:    8F55897E    sta $7E8955     ; Store accumulator at Work RAM (WRAM) (at 7E/8955).
00/FD27:    EA          nop             ; No operation.
00/FD28:    EA          nop             ; No operation.
00/FD29:    A904        lda #$04        ; Load accumulator with value from '4'.
00/FD2B:    8F53897E    sta $7E8953     ; Store accumulator at Work RAM (WRAM) (at 7E/8953).
00/FD2F:    EA          nop             ; No operation.
00/FD30:    EA          nop             ; No operation.
00/FD31:    A903        lda #$03        ; Load accumulator with value from '3'.
00/FD33:    8F5F897E    sta $7E895F     ; Store accumulator at Work RAM (WRAM) (at 7E/895F).
00/FD37:    EA          nop             ; No operation.
00/FD38:    EA          nop             ; No operation.
00/FD39:    28          plp             ; Pull processor status from stack.
00/FD3A:    68          pla             ; Pull accumulator from stack.
00/FD3B:    AF114200    lda $004211     ; Load accumulator with value from 0x004211.
00/FD3F:    5C15FDC0    jmp $C0FD15     ; Jump to C0/FD15.
00/FD43:    00          brk             ; brk.
00/FD44:    00          brk             ; brk.
