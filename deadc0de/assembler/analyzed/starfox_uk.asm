; Action Replay DEADC0DE Cheat
;   - Address-Hook: 0x02FC7A
;   - Length: 6 DWORDs (24 bytes)
;
02/FC7A:    08          php             ; Push processor status onto stack.
02/FC7B:    E220        sep #$20        ; Set processor status bits present in 0b00100000.
02/FC7D:    A928        lda #$28        ; Load accumulator with value from '40'.
02/FC7F:    8D9603      sta $0396       ; Store accumulator at 0x0396.
02/FC82:    A905        lda #$05        ; Load accumulator with value from '5'.
02/FC84:    8DAD15      sta $15AD       ; Store accumulator at 0x15AD.
02/FC87:    28          plp             ; Pull processor status from stack.
02/FC88:    6468        stz $68         ; Store zero at 0x68.
02/FC8A:    6469        stz $69         ; Store zero at 0x69.
02/FC8C:    5C7EFC02    jmp $02FC7E     ; Jump to 02/FC7E.
02/FC90:    00          brk             ; brk.
02/FC91:    00          brk             ; brk.
