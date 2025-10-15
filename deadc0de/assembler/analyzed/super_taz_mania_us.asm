; Action Replay DEADC0DE Cheat
;   - Address-Hook: 0x9A8987
;   - Length: Dynamic (until EOF)
;
9A/8987:    08          php             ; Push processor status onto stack.
9A/8988:    E220        sep #$20        ; Set processor status bits present in 0b00100000.
9A/898A:    EA          nop             ; No operation.
9A/898B:    A910        lda #$10        ; Load accumulator with value from '16'.
9A/898D:    8F96007E    sta $7E0096     ; Store accumulator at Work RAM (WRAM) (at 7E/0096).
9A/8991:    EA          nop             ; No operation.
9A/8992:    EA          nop             ; No operation.
9A/8993:    A901        lda #$01        ; Load accumulator with value from '1'.
9A/8995:    8F2E707E    sta $7E702E     ; Store accumulator at Work RAM (WRAM) (at 7E/702E).
9A/8999:    EA          nop             ; No operation.
9A/899A:    EA          nop             ; No operation.
9A/899B:    A930        lda #$30        ; Load accumulator with value from '48'.
9A/899D:    8F98007E    sta $7E0098     ; Store accumulator at Work RAM (WRAM) (at 7E/0098).
9A/89A1:    EA          nop             ; No operation.
9A/89A2:    EA          nop             ; No operation.
9A/89A3:    A905        lda #$05        ; Load accumulator with value from '5'.
9A/89A5:    8F20707E    sta $7E7020     ; Store accumulator at Work RAM (WRAM) (at 7E/7020).
9A/89A9:    EA          nop             ; No operation.
9A/89AA:    EA          nop             ; No operation.
9A/89AB:    A906        lda #$06        ; Load accumulator with value from '6'.
9A/89AD:    8F8A007E    sta $7E008A     ; Store accumulator at Work RAM (WRAM) (at 7E/008A).
9A/89B1:    EA          nop             ; No operation.
9A/89B2:    EA          nop             ; No operation.
9A/89B3:    A902        lda #$02        ; Load accumulator with value from '2'.
9A/89B5:    8F22707E    sta $7E7022     ; Store accumulator at Work RAM (WRAM) (at 7E/7022).
9A/89B9:    EA          nop             ; No operation.
9A/89BA:    EA          nop             ; No operation.
9A/89BB:    A900        lda #$00        ; Load accumulator with value from '0'.
9A/89BD:    8F24707E    sta $7E7024     ; Store accumulator at Work RAM (WRAM) (at 7E/7024).
9A/89C1:    EA          nop             ; No operation.
9A/89C2:    EA          nop             ; No operation.
9A/89C3:    A902        lda #$02        ; Load accumulator with value from '2'.
9A/89C5:    8F2A707E    sta $7E702A     ; Store accumulator at Work RAM (WRAM) (at 7E/702A).
9A/89C9:    EA          nop             ; No operation.
9A/89CA:    EA          nop             ; No operation.
9A/89CB:    28          plp             ; Pull processor status from stack.
9A/89CC:    A5B2        lda $B2         ; Load accumulator with value from 0xB2.
9A/89CE:    25AA        and $AA         ; Logical AND with 0xAA.
9A/89D0:    5C8B899A    jmp $9A898B     ; Jump to 9A/898B.
9A/89D4:    00          brk             ; brk.
9A/89D5:    00          brk             ; brk.
9A/89D6:    00          brk             ; brk.
