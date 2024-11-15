; DEADC0DE-Cheat, Action Replay MK2 only
; START Header-Block
8087     	bra $7F89       ; Branch Always to address $7F89, unconditionally setting Program Counter to this location.
B400     	ldy $00,X       ; Load Y register from memory at address $00 offset by X, updating Y with this value.
E230     	sep #$30        ; Set Processor Status bits, enabling 8-bit mode for Accumulator, X, and Y.
EA       	nop             ; No operation; used as a delay or placeholder, advances Program Counter.
EA       	nop             ; Another no-operation, maintains code alignment or timing.
; END Header-Block

; OPTION 1: Always have full magic batton
A902     	lda #$02        ; Load Accumulator with immediate value $02, setting A to this constant.
8F60047E 	sta $7E0460     ; Store Accumulator at long address $7E0460, placing A’s value in memory.
EA       	nop             ; No operation, keeps instruction flow without changes.
EA       	nop             ; No operation; additional filler or timing adjustment.

; OPTION 2: Unlimited energy
A906     	lda #$06        ; Load Accumulator with immediate value $06, updating A with this value.
8F46047E 	sta $7E0446     ; Store Accumulator at long address $7E0446, setting memory to A’s current value.
EA       	nop             ; No operation; maintains sequence without effect.
EA       	nop             ; No operation; often used for timing or spacing in code.

; OPTION 3: Unlimited coins
A909     	lda #$09        ; Load Accumulator with immediate value $09, setting A to this value.
8F75047E 	sta $7E0475     ; Store Accumulator at long address $7E0475, saving A’s content at this address.
EA       	nop             ; No operation; commonly used to maintain execution alignment.
EA       	nop             ; Another no-operation instruction, continues code alignment.

; OPTION 4: Infinite lives
A909     	lda #$09        ; Load immediate value $09 into Accumulator, setting A to this constant.
8F98047E 	sta $7E0498     ; Store Accumulator at long address $7E0498, saving the value of A here.
EA       	nop             ; No operation; maintains timing or alignment in execution.
EA       	nop             ; No operation; used for alignment or timing adjustments in code.

; OPTION 5: Unlimited time
A999     	lda #$99        ; Load immediate value $99 into Accumulator, updating A with this constant.
8FAE007E 	sta $7E00AE     ; Store Accumulator at long address $7E00AE, saving A’s value here in memory.
EA       	nop             ; No operation; acts as filler or for timing adjustments.
EA       	nop             ; No operation; additional filler, maintains code structure.

; OPTION 6: Level select:               ; Warning: Use a blank save game as this will keep adding to the level!
A9XX     	lda #$XX        ; Load immediate value XX into Accumulator, setting A to XX (= desired level num).
8F92007E 	sta $7E0092     ; Store Accumulator at long address $7E092E, saving A’s value here in memory.
EA       	nop             ; No operation; acts as filler or for timing adjustments.
EA       	nop             ; No operation; additional filler, maintains code structure.

; START Footer-Block
C210     	rep #$10        ; Reset specified bits in Processor Status, setting 16-bit mode for Accumulator.
5CB88780 	jmp $8087B8     ; Jump to long address $8087B8, updating Program Counter to continue execution here.
00       	brk             ; Software interrupt acting as breakpoint or interrupt trigger.
00       	brk             ; Software interrupt acting as breakpoint or interrupt trigger.
; END Footer-Block