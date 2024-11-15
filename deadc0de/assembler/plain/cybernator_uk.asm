8082    	bra $7F84
78      	sei 
00      	brk 
8F004200	sta $004200
A9038F  	lda #$8F03
6600    	ror $00
7EEAEA  	ror $EAEA,X
A9068F  	lda #$8F06
5C007EEA	jmp $EA7E00
EA      	nop 
A9038F  	lda #$8F03
6A      	ror A
00      	brk 
7EEAEA  	ror $EAEA,X
A919BF  	lda #$BF19
60      	rts 
00      	brk 
7EEAEA  	ror $EAEA,X
A9038F  	lda #$8F03
68      	pla 
00      	brk 
7EEAEA  	ror $EAEA,X
A9078F  	lda #$8F07
5E007E  	lsr $7E00,X
EA      	nop 
EA      	nop 
A9038F  	lda #$8F03
6C007E  	jmp ($7E00)
EA      	nop 
EA      	nop 
A9B08F  	lda #$8FB0
CA      	dex 
147E    	trb $7E
EA      	nop 
EA      	nop 
5C7C8280	jmp $80827C
