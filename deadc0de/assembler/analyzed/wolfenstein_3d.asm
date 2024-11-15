00      	brk 
FD1500  	sbc $0015,X
48      	pha 
08      	php 
E230    	sep #$30
A90D    	lda #$0D
8F57897E	sta $7E8957
EA      	nop 
EA      	nop 
A963    	lda #$63
8F55897E	sta $7E8955
EA      	nop 
EA      	nop 
A904    	lda #$04
8F53897E	sta $7E8953
EA      	nop 
EA      	nop 
A903    	lda #$03
8F5F897E	sta $7E895F
EA      	nop 
EA      	nop 
28      	plp 
68      	pla 
AF114200	lda $004211
5C15FDC0	jmp $C0FD15
00      	brk 
00      	brk 
