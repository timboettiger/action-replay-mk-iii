8087    	bra $7F89
B400    	ldy $00,X
E230    	sep #$30
EA      	nop 
EA      	nop 
A902    	lda #$02
8F60047E	sta $7E0460
EA      	nop 
EA      	nop 
A906    	lda #$06
8F46047E	sta $7E0446
EA      	nop 
EA      	nop 
A909    	lda #$09
8F75047E	sta $7E0475
EA      	nop 
EA      	nop 
A909    	lda #$09
8F98047E	sta $7E0498
EA      	nop 
EA      	nop 
A999    	lda #$99
8FAE007E	sta $7E00AE
EA      	nop 
EA      	nop 
A900    	lda #$00
7EEAEA  	ror $EAEA,X
C210    	rep #$10
5CB88780	jmp $8087B8
00      	brk
00      	brk
