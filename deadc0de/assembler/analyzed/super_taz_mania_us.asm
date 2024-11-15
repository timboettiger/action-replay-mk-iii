; DEADC0DE-Cheat, Action Replay MK2 only
; START Header-Block
9A          txs              ; Transfer X to Stack Pointer: Copy the value of the X register to the stack pointer.
898700      bit #$0087       ; Test Bits in Memory with Accumulator: Perform a bitwise AND between the accumulator and $0087, setting flags based on the result.
08          php              ; Push Processor Status to Stack: Save the current processor status onto the stack.
E220        sep #$20         ; Set Processor Flags: Set the processor to 8-bit accumulator mode (index unchanged).
EA          nop              ; No Operation: Perform no operation (used for timing or padding).
; END Header-Block

; Option 1: Unlimited energy
A910        lda #$10         ; Load Accumulator with Immediate Value: Load the value $10 into the accumulator.
8F96007E    sta $7E0096      ; Store Accumulator: Write the accumulator value to the absolute long address $7E0096.
EA          nop              ; No Operation: Perform no operation.
EA          nop              ; No Operation: Perform no operation.

; Option 2: You only need to collect 1 Kiwi
A901        lda #$01         ; Load Accumulator with Immediate Value: Load the value $01 into the accumulator.
8F2E707E    sta $7E702E      ; Store Accumulator: Write the accumulator value to the absolute long address $7E702E.
EA          nop              ; No Operation: Perform no operation.
EA          nop              ; No Operation: Perform no operation.

; Option 3: Unlimited time
A930        lda #$30         ; Load Accumulator with Immediate Value: Load the value $30 into the accumulator.
8F98007E    sta $7E0098      ; Store Accumulator: Write the accumulator value to the absolute long address $7E0098.
EA          nop              ; No Operation: Perform no operation.
EA          nop              ; No Operation: Perform no operation.

; Option 4: Unlimited continues
A905        lda #$05         ; Load Accumulator with Immediate Value: Load the value $05 into the accumulator.
8F20707E    sta $7E7020      ; Store Accumulator: Write the accumulator value to the absolute long address $7E7020.
EA          nop              ; No Operation: Perform no operation.
EA          nop              ; No Operation: Perform no operation.

; Option 5: Slow motion when running forward
A906        lda #$06         ; Load Accumulator with Immediate Value: Load the value $06 into the accumulator.
8F8A007E    sta $7E008A      ; Store Accumulator: Write the accumulator value to the absolute long address $7E008A.
EA          nop              ; No Operation: Perform no operation.
EA          nop              ; No Operation: Perform no operation.

; Option 6: Extra Continues every time you gain more points
A902        lda #$02         ; Load Accumulator with Immediate Value: Load the value $02 into the accumulator.
8F22707E    sta $7E7022      ; Store Accumulator: Write the accumulator value to the absolute long address $7E7022.
EA          nop              ; No Operation: Perform no operation.
EA          nop              ; No Operation: Perform no operation.

; Option 7: The timer runs down at about double the speed
A900        lda #$00         ; Load Accumulator with Immediate Value: Load the value $00 into the accumulator.
8F24707E    sta $7E7024      ; Store Accumulator: Write the accumulator value to the absolute long address $7E7024.
EA          nop              ; No Operation: Perform no operation.
EA          nop              ; No Operation: Perform no operation.

; Option 8: Timer runs backwards
A902        lda #$02         ; Load Accumulator with Immediate Value: Load the value $02 into the accumulator.
8F2A707E    sta $7E702A      ; Store Accumulator: Write the accumulator value to the absolute long address $7E702A.
EA          nop              ; No Operation: Perform no operation.
EA          nop              ; No Operation: Perform no operation.

; START Footer-Block
28          plp              ; Pull Processor Status from Stack: Restore processor status from the stack.
A5B2        lda $B2          ; Load Accumulator from Direct Page: Load the value at address $B2 into the accumulator.
25AA        and $AA          ; AND Accumulator with Memory: Perform a bitwise AND between the accumulator and the value at address $AA.
5C8B899A    jmp $9A898B      ; Jump: Jump to absolute long address $9A898B.
00          brk              ; Break: Generates a software interrupt.
00          brk              ; Break: Generates a software interrupt.
00          brk              ; Break: Generates a software interrupt.
; END Footer-Block