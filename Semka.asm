
BYTE 00000011b
BYTE 10011111b
BYTE 00100101b
BYTE 00001101b
BYTE 10011001b
BYTE 01001001b
BYTE 01000001b
BYTE 00011111b
BYTE 00000001b
BYTE 00001001b


	mvi	a,1
	smi	0,a	
	mvi	a,10	;defaultne hodnoty pre budik ktore nenastanu pokial sa nezmenia pouzivatelom
	smi	1,a	
	smi	2,a
	smi	3,a
	smi	4,a

	mvi	a,11
	mvi	b,1
	str	a,b
	
	
	mvi	a,0
	out	3,a		;aktivacia celej klavesnice
	eit


;Hlavny program - nekonecna slucka
start:	
	mvi	c,0
	mvi	d,10
	str	d,c
opakuj:

	mvi	a,0x0f		;vypnutie displejov
	out	5,a		;pravy register	

	lmi	a,14
	mmr	b,a		
	out	6,b

	mvi	a,0x07		;aktivacia displeja 1
	out	5,a		;pravy register

	mvi	a,0x0f		;vypnutie displejov
	out	5,a		;pravy register

	
	lmi	a,13
	mmr	b,a		;nastavenie druheho displeja zram
	out	6,b

	mvi	a,0x0b		;aktivacia displeja 2
	out	5,a		;pravy register


	mvi	a,0x0f		;vypnutie displejov
	out	5,a		;pravy register
	
	lmi	a,12
	mmr	b,a		
	out	6,b

	mvi	a,0x0d		;aktivacia displeja 3
	out	5,a		;pravy register

	mvi	a,0x0f		;vypnutie displejov
	out	5,a		;pravy register
	
	lmi	a,11
	mmr	b,a		;nastavenie druheho displeja zram
	out	6,b

	mvi	a,0x0e		;aktivacia displeja 2
	out	5,a		;pravy register
	
	inc	c
	cmi	c,10
	jnz	opakuj
	mvi	a,10
	ldr	d,a
	inc	d
	str	a,d
	mvi	a,11
	ldr	b,a
	cmp	d,b
	jnz	opakuj
	mvi	a,10
	mvi	d,0
	str	a,d
	
	lmi	a,14
	inc	a
	cmi	a,10
	jzr	pridajDesMin
	smi	14,a
	jmp	kontBudik
pridajDesMin:
	mvi	a,0
	smi	14,a
	lmi	a,13
	inc	a
	cmi	a,6
	jzr	pridajHod
	smi	13,a
	jmp	kontBudik
pridajHod:
	mvi	a,0
	smi	13,a
	lmi	a,12
	inc	a
	jmp	kont24hod
vratsa:
	cmi	a,10
	jzr	pridajDesHod
	smi	12,a
	jmp	kontBudik
pridajDesHod:
	mvi	a,0
	smi	12,a	
	lmi	a,11
	inc	a
	smi	11,a
	jmp	kontBudik

kontBudik:
	lmi	a,1
	lmi	b,11
	cmp	a,b
	jnz	start
	lmi	a,2
	lmi	b,12
	cmp	a,b
	jnz	start
	lmi	a,3
	lmi	b,13
	cmp	a,b
	jnz	start
	lmi	a,4
	lmi	b,14
	cmp	a,b	
	jzr	Buzz
	jmp	start

Buzz:
	mvi	a,0x0f		;vypnutie displejov
	out	5,a		;pravy register	

	mvi	b,00100101b
	out	6,b

	mvi	a,0x07		;aktivacia displeja 1
	out	5,a		;pravy register

	mvi	a,0x0f		;vypnutie displejov
	out	5,a		;pravy register

	
	mvi	b,00100101b
	out	6,b

	mvi	a,0x0b		;aktivacia displeja 2
	out	5,a		;pravy register


	mvi	a,0x0f		;vypnutie displejov
	out	5,a		;pravy register
	
	mvi	b,10000011b	
	out	6,b

	mvi	a,0x0d		;aktivacia displeja 3
	out	5,a		;pravy register

	mvi	a,0x0f		;vypnutie displejov
	out	5,a		;pravy register
	
	mvi	b,00000001b
	out	6,b

	mvi	a,0x0e		;aktivacia displeja 2
	out	5,a		;pravy register

	inc	c
	cmi	c,255
	jnz	Buzz	
	inc	d
	cmi	d,3
	jnz	Buzz
	mvi	c,0
	mvi	d,0
	jmp	start

kont24hod:
	lmi	d,11
	cmi	d,2
	jnz	vratsa	
	lmi	d,12
	cmi	d,3
	jnz	vratsa	
	jmp	reset
	ret
reset:
	mvi	a,0
	smi	11,a
	smi	12,a
	smi	13,a
	smi	14,a
	jmp	start

ulozMin:
	smi	4,b
	mvi	a,1
	smi	0,a
	mvi	a,0
	out	011,a		;aktivacia celej klavesnice
	eit
	jmp	start
ulozDesMin:
	smi	3,b
	lmi	a,0
	inc	a
	smi	0,a
	mvi	a,0
	out	011,a		;aktivacia celej klavesnice
	eit
	jmp	start
ulozHod:
	smi	2,b
	lmi	a,0
	inc	a
	smi	0,a
	mvi	a,0
	out	011,a		;aktivacia celej klavesnice
	eit
	jmp	start
ulozDesHod:
	smi	1,b
	lmi	a,0
	inc	a
	smi	0,a
	mvi	a,0
	out	011,a		;aktivacia celej klavesnice
	eit
	jmp	start
	


;Obsluzne programy pre prerusenia
	

int07:
	mvi	a,1110b
	out	3,a		;aktivacia riadku 1
	inn	a,0		;citanie stavu stlpcov
	ani	a,00001111b	;vynulovanie hornych bitov
	cmi	a,0111b		;je stlacene?
	jzr	nula

	mvi	a,1101b
	out	3,a		;aktivacia riadku 2
	inn	a,0		;citanie stavu stlpcov
	ani	a,00001111b	;vynulovanie hornych bitov
	cmi	a,0111b		;je stlacene?
	jzr	styri

	mvi	a,1011b
	out	3,a		;aktivacia riadku 3
	inn	a,0		;citanie stavu stlpcov
	ani	a,00001111b	;vynulovanie hornych bitov
	cmi	a,0111b		;je stlacene?
	jzr	osem

	mvi	a,0
	out	011,a		;aktivacia celej klavesnice
	eit
	ret

;kontrola dalsich tlacidiel v stpci - dorobit

nula:
	
	lmi	a,0
	mvi	b,0
	cmi	a,4
	jzr	ulozMin
	cmi	a,3
	jzr	ulozDesMin
	cmi	a,2
	jzr	ulozHod
	cmi	a,1
	jzr	ulozDesHod

	ret

styri:
	lmi	a,0
	mvi	b,4
	cmi	a,4
	jzr	ulozMin
	cmi	a,3
	jzr	ulozDesMin
	cmi	a,2
	jzr	ulozHod
	cmi	a,1
	jzr	ulozDesHod

	ret

osem:
	lmi	a,0
	mvi	b,8
	cmi	a,4
	jzr	ulozMin
	cmi	a,3
	jzr	ulozDesMin
	cmi	a,2
	jzr	ulozHod
	cmi	a,1
	jzr	ulozDesHod
	ret



int11:
	mvi	a,1110b
	out	0,a		;aktivacia riadku 1
	inn	a,0		;citanie stavu stlpcov
	ani	a,00001111b	;vynulovanie hornych bitov
	cmi	a,1011b		;je stlacene?
	jzr	jedna

	mvi	a,1101b
	out	0,a		;aktivacia riadku 2
	inn	a,0		;citanie stavu stlpcov
	ani	a,00001111b	;vynulovanie hornych bitov
	cmi	a,1011b		;je stlacene?
	jzr	pat

	mvi	a,1011b
	out	0,a		;aktivacia riadku 3
	inn	a,0		;citanie stavu stlpcov
	ani	a,00001111b	;vynulovanie hornych bitov
	cmi	a,1011b		;je stlacene?
	jzr	devat

	mvi	a,0
	out	0,a		;aktivacia celej klavesnice
	eit
	ret

jedna:

	lmi	a,0
	mvi	b,1
	cmi	a,4
	jzr	ulozMin
	cmi	a,3
	jzr	ulozDesMin
	cmi	a,2
	jzr	ulozHod
	cmi	a,1
	jzr	ulozDesHod
	jmp	start

pat:
	lmi	a,0
	mvi	b,5
	cmi	a,4
	jzr	ulozMin
	cmi	a,3
	jzr	ulozDesMin
	cmi	a,2
	jzr	ulozHod
	cmi	a,1
	jzr	ulozDesHod
	ret

devat:
	lmi	a,0
	mvi	b,9
	cmi	a,4
	jzr	ulozMin
	cmi	a,3
	jzr	ulozDesMin
	cmi	a,2
	jzr	ulozHod
	cmi	a,1
	jzr	ulozDesHod
	ret

int13:
	mvi	a,1110b
	out	0,a		;aktivacia riadku 1
	inn	a,0		;citanie stavu stlpcov
	ani	a,00001111b	;vynulovanie hornych bitov
	cmi	a,1101b		;je stlacene?
	jzr	dva

	mvi	a,1101b
	out	0,a		;aktivacia riadku 2
	inn	a,0		;citanie stavu stlpcov
	ani	a,00001111b	;vynulovanie hornych bitov
	cmi	a,1101b		;je stlacene?
	jzr	sest

	mvi	a,0
	out	0,a		;aktivacia celej klavesnice
	eit
	ret

dva:
	lmi	a,0
	mvi	b,2
	cmi	a,4
	jzr	ulozMin
	cmi	a,3
	jzr	ulozDesMin
	cmi	a,2
	jzr	ulozHod
	cmi	a,1
	jzr	ulozDesHod
ret

sest:
	lmi	a,0
	mvi	b,6
	cmi	a,4
	jzr	ulozMin
	cmi	a,3
	jzr	ulozDesMin
	cmi	a,2
	jzr	ulozHod
	cmi	a,1
	jzr	ulozDesHod
	jmp	start


int14:
		mvi	a,1110b
	out	0,a		;aktivacia riadku 1
	inn	a,0		;citanie stavu stlpcov
	ani	a,00001111b	;vynulovanie hornych bitov
	cmi	a,1110b		;je stlacene?
	jzr	tri

	mvi	a,1101b
	out	0,a		;aktivacia riadku 2
	inn	a,0		;citanie stavu stlpcov
	ani	a,00001111b	;vynulovanie hornych bitov
	cmi	a,1110b		;je stlacene?
	jzr	sedem


	mvi	a,0
	out	0,a		;aktivacia celej klavesnice
	eit
	ret

tri:
	lmi	a,0
	mvi	b,3
	cmi	a,4
	jzr	ulozMin
	cmi	a,3
	jzr	ulozDesMin
	cmi	a,2
	jzr	ulozHod
	cmi	a,1
	jzr	ulozDesHod
	jmp	start
	
sedem:

	lmi	a,0
	mvi	b,7
	cmi	a,4
	jzr	ulozMin
	cmi	a,3
	jzr	ulozDesMin
	cmi	a,2
	jzr	ulozHod
	cmi	a,1
	jzr	ulozDesHod
	jmp	start


