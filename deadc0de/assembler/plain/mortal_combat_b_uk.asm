80E6    	bra $7FE8
CF0808C2	cmp $C20808
30A2    	bmi $A2
00      	brk
00      	brk
A91600  	lda #$0016
9F6A1480	sta $80146A,X
E8      	inx 
E8      	inx 
E00800  	cpx #$0008
D0F2    	bne $800A
28      	plp 
08      	php 
E220    	sep #$20
9C2121  	stz $2121
5C
9C2121	jmp $21219C
5C
