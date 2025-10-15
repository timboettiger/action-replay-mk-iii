; Action Replay DEADC0DE Cheat
;   - Address-Hook: 0xC0025C
;   - Length: 7 DWORDs (28 bytes)
;
C0/025C:    ADA800      lda $00A8       ; Load accumulator with value from 0x00A8.
C0/025F:    C90020      cmp #$2000      ; Compare accumulator with '8192'.
C0/0262:    D00A        bne $026E       ; Branch to C0/026E if not equal.
C0/0264:    E230        sep #$30        ; Set processor status bits present in 0b00110000.
C0/0266:    A9FF        lda #$FF        ; Load accumulator with value from '255'.
C0/0268:    8F71077E    sta $7E0771     ; Store accumulator at Work RAM (WRAM) (at 7E/0771).
C0/026C:    C230        rep #$30        ; Clear processor status bits present in 0b00110000.
C0/026E:    AD1A42      lda $421A       ; Load accumulator with value from JOY2L - Joypad 2 Data (Low).
C0/0271:    AA          tax             ; Transfer accumulator to X register.
C0/0272:    5C6002C0    jmp $C00260     ; Jump to C0/0260.
C0/0276:    00          brk             ; brk.
C0/0277:    00          brk             ; brk.
