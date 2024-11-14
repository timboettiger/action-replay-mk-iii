00/8000:	8087    	bra $7F89
00/8002:	B400    	ldy $00,X
00/8004:	E230    	sep #$30
00/8006:	EA      	nop 
00/8007:	EA      	nop 
00/8008:	A902    	lda #$02
00/800A:	8F60047E	sta $7E0460
00/800E:	EA      	nop 
00/800F:	EA      	nop 
00/8010:	A906    	lda #$06
00/8012:	8F46047E	sta $7E0446
00/8016:	EA      	nop 
00/8017:	EA      	nop 
00/8018:	A909    	lda #$09
00/801A:	8F75047E	sta $7E0475
00/801E:	EA      	nop 
00/801F:	EA      	nop 
00/8020:	A909    	lda #$09
00/8022:	8F98047E	sta $7E0498
00/8026:	EA      	nop 
00/8027:	EA      	nop 
00/8028:	A999    	lda #$99
00/802A:	8FAE007E	sta $7E00AE
00/802E:	EA      	nop 
00/802F:	EA      	nop 
00/8030:	A900    	lda #$00
00/8032:	7EEAEA  	ror $EAEA,X
00/8035:	C210    	rep #$10
00/8037:	5CB88780	jmp $8087B8
00/803B:	0000    	brk $00
