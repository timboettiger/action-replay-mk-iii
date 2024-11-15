80E6    	bra $7FE8
9B      	txy 
08      	php 
08      	php 
C230    	rep #$30
A20000  	ldx #$0000
A91600  	lda #$0016
9F301480	sta $801430,X
E8      	inx 
E8      	inx 
E00800  	cpx #$0008
D0F2    	bne $800A
28      	plp 
08      	php 
E220    	sep #$20
9C2121  	stz $2121
5CA1E680	jmp $80E6A1
00      	brk 
