C0025C  	cpy #$5C02
09ADA8  	ora #$A8AD
00      	brk 
C90020  	cmp #$2000
D00A    	bne $8016
E230    	sep #$30
A9FF    	lda #$FF
8F71077E	sta $7E0771
C230    	rep #$30
AD1A42  	lda $421A
AA      	tax 
5C6002C0	jmp $C00260
00      	brk 
00      	brk 
