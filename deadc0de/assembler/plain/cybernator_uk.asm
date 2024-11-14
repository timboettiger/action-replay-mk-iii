00/8000:	8082    	bra $7F84
00/8002:	78      	sei 
00/8003:	008F    	brk $8F
00/8005:	0042    	brk $42
00/8007:	00A9    	brk $A9
00/8009:	038F    	ora $8F,S
00/800B:	6600    	ror $00
00/800D:	7EEAEA  	ror $EAEA,X
00/8010:	A9068F  	lda #$8F06
00/8013:	5C007EEA	jmp $EA7E00
00/8017:	EA      	nop 
00/8018:	A9038F  	lda #$8F03
00/801B:	6A      	ror A
00/801C:	007E    	brk $7E
00/801E:	EA      	nop 
00/801F:	EA      	nop 
00/8020:	A919BF  	lda #$BF19
00/8023:	60      	rts 
00/8024:	007E    	brk $7E
00/8026:	EA      	nop 
00/8027:	EA      	nop 
00/8028:	A9038F  	lda #$8F03
00/802B:	68      	pla 
00/802C:	007E    	brk $7E
00/802E:	EA      	nop 
00/802F:	EA      	nop 
00/8030:	A9078F  	lda #$8F07
00/8033:	5E007E  	lsr $7E00,X
00/8036:	EA      	nop 
00/8037:	EA      	nop 
00/8038:	A9038F  	lda #$8F03
00/803B:	6C007E  	jmp ($7E00)
00/803E:	EA      	nop 
00/803F:	EA      	nop 
00/8040:	A9B08F  	lda #$8FB0
00/8043:	CA      	dex 
00/8044:	147E    	trb $7E
00/8046:	EA      	nop 
00/8047:	EA      	nop 
00/8048:	5C7C8280	jmp $80827C
