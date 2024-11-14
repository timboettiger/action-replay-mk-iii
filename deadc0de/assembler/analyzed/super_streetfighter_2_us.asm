; DEADC0DE-Cheat, Action Replay MK2 only
; Player 1 moves on to the next battle when the select button is pressed
00/8000:	C0025C   	cpy #$5C02      ; Compare Y register with immediate value $5C02, setting flags based on comparison result.
00/8003:	09ADA8   	ora #$A8AD      ; Logical OR Accumulator with immediate value $A8AD, modifying A based on bitwise OR.
00/8006:	00C9     	brk $C9         ; Software interrupt with vector to address $C9, initiating break or interrupt handling.
00/8008:	0020     	brk $20         ; Another software interrupt targeting address $20, acting as breakpoint or interrupt.
00/800A:	D00A     	bne $8016       ; Branch if Not Equal to $8016, looping if the Zero flag is clear.
00/800C:	E230     	sep #$30        ; Set Processor Status bits, enabling 8-bit mode for Accumulator, X, and Y registers.
00/800E:	A9FF     	lda #$FF        ; Load Accumulator with immediate value $FF, setting A to this constant.
00/8010:	8F71077E 	sta $7E0771     ; Store Accumulator at long address $7E0771, saving A’s content in memory.
00/8014:	C230     	rep #$30        ; Reset Processor Status bits, enabling 16-bit mode for Accumulator, X, and Y registers.
00/8016:	AD1A42   	lda $421A       ; Load Accumulator with value from address $421A, updating A with this memory content.
00/8019:	AA       	tax             ; Transfer Accumulator to X register, copying A’s value into X.
00/801A:	5C6002C0 	jmp $C00260     ; Jump to long address $C00260, setting Program Counter to this location.
00/801E:	0000     	brk $00         ; Software interrupt with vector to address $00, serving as breakpoint or interrupt trigger.