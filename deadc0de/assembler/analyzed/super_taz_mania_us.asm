; DEADC0DE-Cheat, Action Replay MK2 only
00/8000:	9A       	txs             ; Transfer X register to Stack Pointer, setting SP to the value of X.
00/8001:	898700   	bit #$0087      ; Test bits in Accumulator against immediate value $0087, setting flags based on result.
00/8004:	08       	php             ; Push Processor Status onto Stack, saving current flag state.
00/8005:	E220     	sep #$20        ; Set Processor Status to enable 8-bit Accumulator mode.
00/8007:	EA       	nop             ; No operation, often used as filler or for timing adjustments.

; OPTION 1: Unlimited energy
00/8008:	A910     	lda #$10        ; Load immediate value $10 into Accumulator, setting A to this constant.
00/800A:	8F96007E 	sta $7E0096     ; Store Accumulator at long address $7E0096, saving A’s content to memory.
00/800E:	EA       	nop             ; No operation, used to maintain alignment or control timing.
00/800F:	EA       	nop             ; No operation, another filler instruction.

; OPTION 2: You only need to collect 1 Kiwi
00/8010:	A901     	lda #$01        ; Load immediate value $01 into Accumulator, updating A with this constant.
00/8012:	8F2E707E 	sta $7E702E     ; Store Accumulator at long address $7E702E, saving A’s content at this address.
00/8016:	EA       	nop             ; No operation; keeps execution flow without changes.
00/8017:	EA       	nop             ; No operation; further filler for alignment or timing.

; OPTION 3: Unlimited time
00/8018:	A930     	lda #$30        ; Load immediate value $30 into Accumulator, setting A to this constant.
00/801A:	8F98007E 	sta $7E0098     ; Store Accumulator at long address $7E0098, placing A’s value in memory here.
00/801E:	EA       	nop             ; No operation; maintains alignment or spacing in code.
00/801F:	EA       	nop             ; Another no-operation, used as filler.

; OPTION 4: Unlimited continues
00/8020:	A905     	lda #$05        ; Load immediate value $05 into Accumulator, setting A to this value.
00/8022:	8F20707E 	sta $7E7020     ; Store Accumulator at long address $7E7020, placing A’s content here in memory.
00/8026:	EA       	nop             ; No operation; often used to align code or adjust timing.