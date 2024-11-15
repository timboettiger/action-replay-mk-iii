FEE40E  	inc $0EE4,X
08      	php 
C230    	rep #$30
48      	pha 
5A      	phy 
DA      	phx 
E230    	sep #$30
AF194200	lda $004219
2920    	and #$20
F01D    	beq $8030
AF42007E	lda $7E0042
C90B    	cmp #$0B
F015    	beq $8030
A9FD    	lda #$FD
8F71047E	sta $7E0471
A9FE    	lda #$FE
8F72047E	sta $7E0472
AF42007E	lda $7E0042
1A      	inc A
8F42007E	sta $7E0042
C230    	rep #$30
FA      	plx 
7A      	ply 
68      	pla 
28      	plp 
5CEAFE80	jmp $80FEEA
00      	brk 
