; DEADC0DE-Cheat, Action Replay MK2 only
00/8000:	8087     	bra $7F89       ; Branch Always to address $7F89, unconditionally setting Program Counter to this location.
00/8002:	B400     	ldy $00,X       ; Load Y register from memory at address $00 offset by X, updating Y with this value.
00/8004:	E230     	sep #$30        ; Set Processor Status bits, enabling 8-bit mode for Accumulator, X, and Y.
00/8006:	EA       	nop             ; No operation; used as a delay or placeholder, advances Program Counter.
00/8007:	EA       	nop             ; Another no-operation, maintains code alignment or timing.

; OPTION 1: Always have full magic batton
00/8008:	A902     	lda #$02        ; Load Accumulator with immediate value $02, setting A to this constant.
00/800A:	8F60047E 	sta $7E0460     ; Store Accumulator at long address $7E0460, placing A’s value in memory.
00/800E:	EA       	nop             ; No operation, keeps instruction flow without changes.
00/800F:	EA       	nop             ; No operation; additional filler or timing adjustment.

; OPTION 2: Unlimited energy
00/8010:	A906     	lda #$06        ; Load Accumulator with immediate value $06, updating A with this value.
00/8012:	8F46047E 	sta $7E0446     ; Store Accumulator at long address $7E0446, setting memory to A’s current value.
00/8016:	EA       	nop             ; No operation; maintains sequence without effect.
00/8017:	EA       	nop             ; No operation; often used for timing or spacing in code.

; OPTION 3: Unlimited coins
00/8018:	A909     	lda #$09        ; Load Accumulator with immediate value $09, setting A to this value.
00/801A:	8F75047E 	sta $7E0475     ; Store Accumulator at long address $7E0475, saving A’s content at this address.
00/801E:	EA       	nop             ; No operation; commonly used to maintain execution alignment.
00/801F:	EA       	nop             ; Another no-operation instruction, continues code alignment.

; OPTION 4: Infinite lives
00/8020:	A909     	lda #$09        ; Load immediate value $09 into Accumulator, setting A to this constant.
00/8022:	8F98047E 	sta $7E0498     ; Store Accumulator at long address $7E0498, saving the value of A here.
00/8026:	EA       	nop             ; No operation; maintains timing or alignment in execution.
00/8027:	EA       	nop             ; No operation; used for alignment or timing adjustments in code.

; OPTION 5: Unlimited time
00/8028:	A999     	lda #$99        ; Load immediate value $99 into Accumulator, updating A with this constant.
00/802A:	8FAE007E 	sta $7E00AE     ; Store Accumulator at long address $7E00AE, saving A’s value here in memory.
00/802E:	EA       	nop             ; No operation; acts as filler or for timing adjustments.
00/802F:	EA       	nop             ; No operation; additional filler, maintains code structure.

; OPTION 6: Level select:               ; Load immediate value XX into Accumulator, setting A to XX (= desired level num).
00/8030:	A9XX     	lda #$XX        ; Warning: Use a blank save game as this will keep adding to the level!
00/8032:	7EEAEA   	ror $EAEA,X     ; Rotate bits right at address $EAEA offset by X, shifting each bit and moving rightmost to Carry.

00/8035:	C210     	rep #$10        ; Reset specified bits in Processor Status, setting 16-bit mode for Accumulator.
00/8037:	5CB88780 	jmp $8087B8     ; Jump to long address $8087B8, updating Program Counter to continue execution here.
00/803B:	0000     	brk $00         ; Software interrupt with vector to address $00, acting as breakpoint or interrupt trigger.