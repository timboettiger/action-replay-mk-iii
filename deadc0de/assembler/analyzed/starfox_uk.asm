; DEADC0DE-Cheat, Action Replay MK2 only
; This is for infinite energy and unlimited Nova bombs
00/8000:	02FC     	cop $FC         ; Co-processor instruction with vector to address $FC, initiating a co-processor routine.
00/8002:	7A       	ply             ; Pull Y register from Stack, restoring the last saved value of Y.
00/8003:	0608     	asl $08         ; Arithmetic Shift Left on memory address $08, doubling its value and shifting leftmost bit to Carry.
00/8005:	E220     	sep #$20        ; Set Processor Status bit to enable 8-bit Accumulator mode.
00/8007:	A928     	lda #$28        ; Load Accumulator with immediate value $28, setting A to this value.
00/8009:	8D9603   	sta $0396       ; Store Accumulator at address $0396, saving A’s content here in memory.
00/800C:	A905     	lda #$05        ; Load Accumulator with immediate value $05, updating A with this constant.
00/800E:	8DAD15   	sta $15AD       ; Store Accumulator at address $15AD, placing A’s content at this location in memory.
00/8011:	28       	plp             ; Pull Processor Status from Stack, restoring saved flags.
00/8012:	6468     	stz $68         ; Store zero at address $68, clearing this memory location.
00/8014:	6469     	stz $69         ; Store zero at address $69, effectively setting it to zero.
00/8016:	5C7EFC02 	jmp $02FC7E     ; Jump to long address $02FC7E, updating Program Counter to execute from here.
00/801A:	0000     	brk $00         ; Software interrupt with vector to $00, used for breakpoint or interrupt handling.