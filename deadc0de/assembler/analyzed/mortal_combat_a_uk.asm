; DEADC0DE-Cheat, Action Replay MK2 only
; This is for Full Blood During Combat (A)
00/8000:	80E6      	bra $7FE8     ; Branch Always to address $7FE8, moving Program Counter unconditionally.
00/8002:	9B        	txy           ; Transfer Index Register X to Index Register Y, copying value from X to Y.
00/8003:	08        	php           ; Push Processor Status onto the Stack, storing current flags.
00/8004:	08        	php           ; Another push of Processor Status, duplicating flag storage on stack.
00/8005:	C230      	rep #$30      ; Reset specified bits in Processor Status, clearing bits 4 and 5 to set 16-bit mode for A, X, and Y.
00/8007:	A20000    	ldx #$0000    ; Load immediate 16-bit value $0000 into X register, initializing it to zero.
00/800A:	A91600    	lda #$0016    ; Load immediate 16-bit value $0016 into Accumulator, setting A to this constant.
00/800D:	9F301480  	sta $801430,X ; Store Accumulator at $801430 offset by X, saving value in memory at computed address.
00/8011:	E8        	inx           ; Increment X register by one, advancing its value.
00/8012:	E8        	inx           ; Increment X register again, increasing it by another one.
00/8013:	E00800    	cpx #$0008    ; Compare X register with immediate value $0008, setting flags based on the result.
00/8016:	D0F2      	bne $800A     ; Branch if Not Equal to $800A, repeating loop if X isn’t equal to $0008.
00/8018:	28        	plp           ; Pull Processor Status from Stack, restoring previous flag state.
00/8019:	08        	php           ; Push Processor Status again, preserving current flags on stack.
00/801A:	E220      	sep #$20      ; Set specified bits in Processor Status, setting bit 5 to use 8-bit A, X, and Y.
00/801C:	9C2121    	stz $2121     ; Store zero at address $2121, effectively clearing this memory location.
00/801F:	5CA1E680  	jmp $80E6A1   ; Jump to long address $80E6A1, setting Program Counter to this address for further execution.
00/8023:	00                        ; Break instruction with no vector provided, acts as software interrupt or breakpoint.