;poly_proc.asm
;//////////////////////////////////
;----------------------------
;world coordinate
;         TOP
;         +Y
; LEFT -X  | +Z FRONT
;        \ | /
;         \|/
;         /|\
;        / | \
; BACK -Z  | +X RIGHT
;         -Y
;        BOTTOM

;----------------------------
;direction of rotation
;counterclockwise(A to B)
;+Y
; |  
; | B/--
; |  \  \
; |      \
; |       |
; |       |
; |       A
; |
;-|-------+X
;
;+Y
; |  
; | B/--
; |  \  \
; |      \
; |       |
; |       |
; |       A
; |
;-|-------+Z
;
;+Z
; |  
; | B/--
; |  \  \
; |      \
; |       |
; |       |
; |       A
; |
;-|-------+X

;----------------------------
;screen position
;--------------- Z:+128
;\      |      /
; \     |     /
;  \    |    /
;   \   |   /
;    \  |  /
;     \ | /
;      \|/
;    viewpoint   Z:0

;----------------------------
;vertex
;|v1 v2 v3|

;----------------------------
;matrix
;|a11 a21 a31|
;|a12 a22 a32|
;|a13 a23 a33|

;----------------------------
;memory map
;CPU
;$0000-$1FFF	I/O
;$2000-$3FFF	RAM
;$4000-$5FFF	user code/data, sin mul datas, mul datas, transform div datas, polygon functions : switch when using
;$6000-$7FFF	user code/data, cos mul datas, edge functions : switch when using
;$8000-$9FFF	user code/data
;$A000-$BFFF	user code/data
;$C000-$DFFF	polygon functions
;$E000-$FFFF	user code/data, reset, nmi, irq1, irq2, timer, polygon function datas

;RAM
;1F0000-1F1FFF	CPU ADDRESS $2000-$3FFF

;VRAM
;$0000-$03FF	BAT0	1KW
;$0400-$07FF	BAT1	1KW
;$0800-$08FF	SAT	256W
;$0900-$0FFF	CG, SG	1792W
;$1000-$1FFF	CG, SG	4KW
;$2000-$4FFF	BUFFER0	12KW
;$5000-$7FFF	BUFFER1	12KW

;ROM BANK
;BANK 0		USER CODE/DATA, RESET, NMI, IRQ1, IRQ2, TIMER, POLYGON FUNCTION DATAS
;BANK 1		POLYGON FUNCTIONS
;BANK 2		POLYGON FUNCTIONS
;BANK 3-18	MULTIPLICATION DATAS
;BANK19-30	DIVISION DATAS
;BANK31-34	EDGE FUNCTIONS

;----------------------------
;palette number used by the system is 15.


;//////////////////////////////////
		.bank	1
		.org	$C000

;----------------------------
;Warning.
;Using the matrix will slow down.
;----------------------------
setZeroMatrix:
;|   0    0    0|
;|   0    0    0|
;|   0    0    0|
;
		phy

		cla
		cly
.loop0:
		sta	[matrix0], y
		iny
		cpy	#18
		bne	.loop0

		ply
		rts


;----------------------------
setMatrixRotationZ:
;| cos  sin    0|
;|-sin  cos    0|
;|   0    0    1|
;
		phx
		phy

		jsr	setZeroMatrix

		ldy	#(0*3+1)*2
		lda	sinDataLow, x			;sin
		sta	[matrix0], y
		iny
		lda	sinDataHigh, x
		sta	[matrix0], y

		ldy	#(1*3+0)*2
		sec
		cla
		sbc	sinDataLow, x			;sin
		sta	[matrix0], y
		iny
		cla
		sbc	sinDataHigh, x
		sta	[matrix0], y

		ldy	#(0*3+0)*2
		lda	cosDataLow, x			;cos
		sta	[matrix0], y
		iny
		lda	cosDataHigh, x
		sta	[matrix0], y

		ldy	#(1*3+1)*2
		lda	cosDataLow, x			;cos
		sta	[matrix0], y
		iny
		lda	cosDataHigh, x
		sta	[matrix0], y

		ldy	#(2*3+2)*2
		cla
		sta	[matrix0], y
		iny
		lda	#$40
		sta	[matrix0], y

		ply
		plx
		rts


;----------------------------
setMatrixRotationY:
;| cos    0  sin|
;|   0    1    0|
;|-sin    0  cos|
;
		phx
		phy

		jsr	setZeroMatrix

		ldy	#(0*3+2)*2
		lda	sinDataLow, x			;sin
		sta	[matrix0], y
		iny
		lda	sinDataHigh, x
		sta	[matrix0], y

		ldy	#(2*3+0)*2
		sec
		cla
		sbc	sinDataLow, x			;sin
		sta	[matrix0], y
		iny
		cla
		sbc	sinDataHigh, x
		sta	[matrix0], y

		ldy	#(0*3+0)*2
		lda	cosDataLow, x			;cos
		sta	[matrix0], y
		iny
		lda	cosDataHigh, x
		sta	[matrix0], y

		ldy	#(2*3+2)*2
		lda	cosDataLow, x			;cos
		sta	[matrix0], y
		iny
		lda	cosDataHigh, x
		sta	[matrix0], y

		ldy	#(1*3+1)*2
		cla
		sta	[matrix0], y
		iny
		lda	#$40
		sta	[matrix0], y

		ply
		plx
		rts


;----------------------------
setMatrixRotationX:
;|   1    0    0|
;|   0  cos -sin|
;|   0  sin  cos|
;
		phx
		phy

		jsr	setZeroMatrix

		ldy	#(2*3+1)*2
		lda	sinDataLow, x			;sin
		sta	[matrix0], y
		iny
		lda	sinDataHigh, x
		sta	[matrix0], y

		ldy	#(1*3+2)*2
		sec
		cla
		sbc	sinDataLow, x			;sin
		sta	[matrix0], y
		iny
		cla
		sbc	sinDataHigh, x
		sta	[matrix0], y

		ldy	#(1*3+1)*2
		lda	cosDataLow, x			;cos
		sta	[matrix0], y
		iny
		lda	cosDataHigh, x
		sta	[matrix0], y

		ldy	#(2*3+2)*2
		lda	cosDataLow, x			;cos
		sta	[matrix0], y
		iny
		lda	cosDataHigh, x
		sta	[matrix0], y

		ldy	#(0*3+0)*2
		cla
		sta	[matrix0], y
		iny
		lda	#$40
		sta	[matrix0], y

		ply
		plx
		rts


;----------------------------
vertexMultiplyDatas:
;
		ldx	<vertexCount
.loop0:
		jsr	vertexMultiply
		addw	<matrix0, #6
		addw	<matrix2, #6
		dex
		bne	.loop0

		rts


;----------------------------
vertexMultiply:
;
		phx
		phy

		clx
.loop0:
		phx
		cly

		stzq	<matrixTemp

.loop1:
		lda	[matrix0], y
		sta	<mul16a
		iny
		lda	[matrix0], y
		sta	<mul16a+1
		iny

		sxy

		lda	[matrix1], y
		sta	<mul16b
		iny
		lda	[matrix1], y
		sta	<mul16b+1
		iny

		jsr	smul16

		addq	<matrixTemp, <mul16c, <matrixTemp

		iny
		iny
		iny
		iny

		sxy
		cpy	#6
		bne	.loop1

		plx

		txa
		tay

		lda	<matrixTemp+2
		asl	<matrixTemp+1
		rol	a
		rol	<matrixTemp+3
		asl	<matrixTemp+1
		rol	a
		rol	<matrixTemp+3
		sta	[matrix2], y
		iny
		lda	<matrixTemp+3
		sta	[matrix2], y

		inx
		inx
		cpx	#6
		bne	.loop0

		ply
		plx
		rts


;----------------------------
matrixMultiply:
;
		jsr	vertexMultiply

		addw	<matrix0, #6
		addw	<matrix2, #6
		jsr	vertexMultiply

		addw	<matrix0, #6
		addw	<matrix2, #6
		jsr	vertexMultiply

		rts

;----------------------------
initializePolygonFunction:
;enable interrupt TIMER IRQ1 disable interrupt IRQ2
;set tia tii function
		jsr	setTiaTiiFunction

;initialize VDC
		jsr	initializeVdc

;initialize PAD
		jsr	initializePad

;initialize PSG
		jsr	initializePsg

;set BAT
		jsr	setBat

;clear Sat
		jsr	clearSat

;set main volume
		lda	#$EE
		jsr	setMainVolume

;initialize DDA
		jsr	initializeDda

;initialize random
		jsr	initializeRandom

;disable interrupt IRQ2
		lda	#%00000001
		jsr	setInterruptDisable

		rts


;----------------------------
setMainVolume:
;
		sta	PSG_1
		rts


;----------------------------
initializePsg:
;
		stz	PSG_0
		stz	PSG_1
		stz	PSG_8
		stz	PSG_9

		cly
.loop0:
		sty	PSG_0
		stz	PSG_2
		stz	PSG_3
		mov	PSG_4, #$40
		stz	PSG_4
		stz	PSG_5

		clx
.loop1:
		stz	PSG_6
		inx
		cpx	#32
		bne	.loop1

		iny
		cpy	#6
		bne	.loop0

		mov	PSG_0, #4
		stz	PSG_7

		mov	PSG_0, #5
		stz	PSG_7

		rts


;----------------------------
initializeDda:
;
		stz	<dda0No

;use channel No3
		mov	PSG_0, #$03
		mov	PSG_4, #$DF
		mov	PSG_5, #$FF
		stz	PSG_6
		rts


;----------------------------
startDda:
;
		stz	TIMER_CONTROL_REG
		stz	TIMER_COUNTER_REG
		mov	TIMER_CONTROL_REG, #$01
		rts


;----------------------------
stopDda:
;
		stz	TIMER_CONTROL_REG
		rts


;----------------------------
setDda:
;
		tst	#$FF, <dda0No
		beq	.jp00

		ora	#$00
		bmi	.jp01

		cmp	<dda0No
		beq	.jp02
		bcs	.funcEnd
		bra	.jp02

.jp01:
		and	#$7F
		cmp	<dda0No
		bcs	.funcEnd

.jp00:
		and	#$7F

.jp02:
		sei

		sta	<dda0No
		movw	<dda0Address, #$4000

		jsr	startDda

		cli

.funcEnd:
		rts


;----------------------------
timerPlayDdaFunction:
;
		phx

;set dda data bank
		tma	#$02
		pha

		lda	<dda0No
		tam	#$02

;get dda data
		lda	[dda0Address]
		bpl	.jp00

		stz	<dda0No
		and	#$1F

		jsr	stopDda

.jp00:
		ldx	#$03
		stx	PSG_0
		sta	PSG_6
		incw	<dda0Address

.jp01:
;restore bank
		pla
		tam	#$02

		plx
		rts


;----------------------------
signExt:
;a(sign extension) = a
		cmp	#$00
		bpl	.convPositive
		lda	#$FF
		rts
.convPositive:
		cla
		rts


;----------------------------
sdiv32:
;div16a div16b = div16d:div16c / div16a(-32767 to +32767)
		phx
		phy

;d sign
		lda	<div16d+1
		pha

;d eor a sign
		eor	<div16a+1
		pha

;d sign
		bbr7	<div16d+1, .sdiv16jp00

;d neg
		sec
		cla
		sbc	<mul16c
		sta	<mul16c

		cla
		sbc	<mul16c+1
		sta	<mul16c+1

		cla
		sbc	<mul16d
		sta	<mul16d

		cla
		sbc	<mul16d+1
		sta	<mul16d+1

.sdiv16jp00:
;a sign
		bbr7	<div16a+1, .sdiv16jp01

;a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.sdiv16jp01:

		jsr	udiv30

;anser sign
		pla
		bpl	.sdiv16jp02

;anser neg
		sec
		cla
		sbc	<mul16c
		sta	<mul16a

		cla
		sbc	<mul16c+1
		sta	<mul16a+1

		bra	.sdiv16jp04

.sdiv16jp02:
		lda	<div16c
		sta	<div16a
		lda	<div16c+1
		sta	<div16a+1

.sdiv16jp04:
;remainder sign
		pla
		bpl	.sdiv16jp03

;remainder neg
		sec
		cla
		sbc	<mul16b
		sta	<mul16b

		cla
		sbc	<mul16b+1
		sta	<mul16b+1

.sdiv16jp03:
		ply
		plx
		rts


;----------------------------
udiv32:
;div16a div16b = div16d:div16c / div16a
		phx
		phy

;dec div16a
		lda	<div16a
		bne	.jp00
		dec	<div16a+1
.jp00:
		dec	<div16a

		ldx	#$10
		cly
		asl	<div16c
		rol	<div16c+1

.jpPl00:
;div16d
		rol	<div16d
		rol	<div16d+1
		tya
		rol	a
		tay

		lda	<div16d
		sbc	<div16a
		sta	<div16d

		lda	<div16d+1
		sbc	<div16a+1
		sta	<div16d+1

		tya
		sbc	#$00
		tay

		bcc	.jpMi01

.jpPl01:
		rol	<div16c
		rol	<div16c+1

		dex
		bne	.jpPl00

		lda	<div16c
		sta	<div16a
		lda	<div16c+1
		sta	<div16a+1

		lda	<div16d
		sta	<div16b
		lda	<div16d+1
		sta	<div16b+1

		ply
		plx
		rts

.jpMi00:
;div16d
		rol	<div16d
		rol	<div16d+1
		tya
		rol	a
		tay

		lda	<div16d
		adc	<div16a
		sta	<div16d

		lda	<div16d+1
		adc	<div16a+1
		sta	<div16d+1

		tya
		adc	#$00
		tay

		bcs	.jpPl01

.jpMi01:
		rol	<div16c
		rol	<div16c+1

		dex
		bne	.jpMi00

		sec
		lda	<div16d
		adc	<div16a
		sta	<div16b

		lda	<div16d+1
		adc	<div16a+1
		sta	<div16b+1

		lda	<div16c
		sta	<div16a
		lda	<div16c+1
		sta	<div16a+1

		ply
		plx
		rts


;----------------------------
udiv30:
;div16a div16b = div16d:div16c(30bit) / div16a(15bit)
		phx
		phy

;dec div16a
		lda	<div16a
		bne	.jp00
		dec	<div16a+1
.jp00:
		dec	<div16a

		asl	<div16c
		rol	<div16c+1
		rol	<div16d
		rol	<div16d+1

		asl	<div16c
		rol	<div16c+1

		ldx	#$05
		ldy	<div16d+1

;----------------
.jpPl00_A:
;div16d
		rol	<div16d
		tya
		rol	a
		tay

		lda	<div16d
		sbc	<div16a
		sta	<div16d

		tya
		sbc	<div16a+1
		tay

		bcc	.jpMi00_B

.jpPl00_B:
		rol	<div16c
		rol	<div16c+1

;----------------
.jpPl01_A:
;div16d
		rol	<div16d
		tya
		rol	a
		tay

		lda	<div16d
		sbc	<div16a
		sta	<div16d

		tya
		sbc	<div16a+1
		tay

		bcc	.jpMi01_B

.jpPl01_B:
		rol	<div16c
		rol	<div16c+1

;----------------
.jpPl02_A:
;div16d
		rol	<div16d
		tya
		rol	a
		tay

		lda	<div16d
		sbc	<div16a
		sta	<div16d

		tya
		sbc	<div16a+1
		tay

		bcc	.jpMi02_B

.jpPl02_B:
		rol	<div16c
		rol	<div16c+1

		dex
		bne	.jpPl00_A

;----------------
.jpPlEnd:	lda	<div16c
		sta	<div16a
		lda	<div16c+1
		sta	<div16a+1

		lda	<div16d
		sta	<div16b
		sty	<div16b+1

		ply
		plx
		rts

;----------------
.jpMi00_A:
;div16d
		rol	<div16d
		tya
		rol	a
		tay

		lda	<div16d
		adc	<div16a
		sta	<div16d

		tya
		adc	<div16a+1
		tay

		bcs	.jpPl00_B

.jpMi00_B:
		rol	<div16c
		rol	<div16c+1

;----------------
.jpMi01_A:
;div16d
		rol	<div16d
		tya
		rol	a
		tay

		lda	<div16d
		adc	<div16a
		sta	<div16d

		tya
		adc	<div16a+1
		tay

		bcs	.jpPl01_B

.jpMi01_B:
		rol	<div16c
		rol	<div16c+1

;----------------
.jpMi02_A:
;div16d
		rol	<div16d
		tya
		rol	a
		tay

		lda	<div16d
		adc	<div16a
		sta	<div16d

		tya
		adc	<div16a+1
		tay

		bcs	.jpPl02_B

.jpMi02_B:
		rol	<div16c
		rol	<div16c+1

		dex
		bne	.jpMi00_A

;----------------
.jpMiEnd:
		sec
		lda	<div16d
		adc	<div16a
		sta	<div16b

		tya
		adc	<div16a+1
		sta	<div16b+1

		lda	<div16c
		sta	<div16a
		lda	<div16c+1
		sta	<div16a+1

		ply
		plx
		rts


;----------------------------
smul16:
;mul16d:mul16c = mul16a * mul16b

;a eor b sign
		lda	<mul16a+1
		eor	<mul16b+1
		pha

;a sign
		bbr7	<mul16a+1, .smul16jp00

;a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.smul16jp00:
;b sign
		bbr7	<mul16b+1, .smul16jp01

;b neg
		sec
		cla
		sbc	<mul16b
		sta	<mul16b

		cla
		sbc	<mul16b+1
		sta	<mul16b+1

.smul16jp01:
		jsr	umul16

;anser sign
		pla
		bpl	.smul16jp02

;anser neg
		sec
		cla
		sbc	<mul16c
		sta	<mul16c

		cla
		sbc	<mul16c+1
		sta	<mul16c+1

		cla
		sbc	<mul16d
		sta	<mul16d

		cla
		sbc	<mul16d+1
		sta	<mul16d+1

.smul16jp02:
		rts


;----------------------------
umul16:
;mul16d:mul16c = mul16a * mul16b
		phy

;save MPR2 data
		tma	#MUL_DATA_MAP
		pha

		ldy	<mul16b
		lda	mulBankData, y
		tam	#MUL_DATA_MAP

		lda	<mul16b
		and	#$0F
		asl	a
		adc	#MUL_DATA_ADDR
		stz	<mulAddr
		sta	<mulAddr+1

		ldy	<mul16a
		lda	[mulAddr], y
		sta	<mul16c

		lda	<mul16a+1
		ora	<mul16b+1
		bne	.jp00

		inc	<mulAddr+1
		lda	[mulAddr], y
		sta	<mul16c+1

		stzw	mul16d

		bra	.jpEnd

.jp00:
		ldy	<mul16a+1
		lda	[mulAddr], y
		sta	<mul16c+1

		inc	<mulAddr+1

		ldy	<mul16a
		lda	[mulAddr], y
		adc	<mul16c+1
		sta	<mul16c+1

		ldy	<mul16a+1
		lda	[mulAddr], y
		adc	#0
		sta	<mul16d

		ldy	<mul16b+1
		lda	mulBankData, y
		tam	#MUL_DATA_MAP

		lda	<mul16b+1
		and	#$0F
		asl	a
		adc	#MUL_DATA_ADDR
		sta	<mulAddr+1

		ldy	<mul16a
		lda	[mulAddr], y
		adc	<mul16c+1
		sta	<mul16c+1

		ldy	<mul16a+1
		lda	[mulAddr], y
		adc	<mul16d
		sta	<mul16d

		cla
		adc	#0
		sta	<mul16d+1

		inc	<mulAddr+1

		ldy	<mul16a
		lda	[mulAddr], y
		adc	<mul16d
		sta	<mul16d

		ldy	<mul16a+1
		lda	[mulAddr], y
		adc	<mul16d+1
		sta	<mul16d+1

.jpEnd:
;set MPR2 data
		pla
		tam	#MUL_DATA_MAP

		ply
		rts


;----------------------------
usqrt32:
;mul16c = sqrt(sqr32a)
		phx
		phy

		stzq	<work4a
		stzq	<work4b

		stzw	<mul16c

		ldy	#15

.loop:
		tya
		lsr	a
		lsr	a
		tax

		asl	<sqr32a, x
		rolq	<work4a
		asl	<sqr32a, x
		rolq	<work4a

		aslq	<work4b
		smb0	<work4b

		aslw	<mul16c

		subq	<work4c, <work4a, <work4b
		bcc	.jp00

		movq	<work4a, <work4c

		smb0	<mul16c

		incq	<work4b

		bra	.jp01

.jp00:
		rmb0	<work4b

.jp01:
		dey
		bpl	.loop

		ply
		plx
		rts


;----------------------------
calcDistance:
;mul16c = (angleX0, angleY0, angleZ0)  (angleX1, angleY1, angleZ1)
		subw	<mul16a, <angleX1, <angleX0
		movw	<mul16b, <mul16a
		jsr	smul16
		movq	<work4a, <mul16c

		subw	<mul16a, <angleY1, <angleY0
		movw	<mul16b, <mul16a
		jsr	smul16
		addq	<work4a, <mul16c

		subw	<mul16a, <angleZ1, <angleZ0
		movw	<mul16b, <mul16a
		jsr	smul16
		addq	<sqr32a, <work4a, <mul16c

		jsr	usqrt32

		rts


;----------------------------
initializePad:
;
		stz	<padLast
		stz	<padNow
		stz	<padState
		rts


;----------------------------
initializePad2:
;
		stz	<padState2
		rts


;----------------------------
getPadData:
;
		lda	<padNow
		sta	<padLast

		lda	#$01
		sta	IO_REG
		lda	#$03
		sta	IO_REG

		lda	#$01
		sta	IO_REG

		pha
		pla
		nop

		lda	IO_REG

		stz	IO_REG

		asl	a
		asl	a
		asl	a
		asl	a
		sta	<padNow

		lda	IO_REG
		and	#$0F
		ora	<padNow
		eor	#$FF
		sta	<padNow

		lda	<padLast
		eor	#$FF
		and	<padNow
		sta	<padState

		lda	<padState2
		ora	<padState
		sta	<padState2

;check reset
		clc
		bbr2	<padState, checkEnd
		lda	<padLast
		and	<padNow
		and	#$08
		beq	checkEnd

		sec
checkEnd:

;get pad data end
		rts


;----------------------------
setSin8MulData:
;mul16a sin data
		phy

		lda	<mul16a+1
		sta	<mulSinWork0

;save MPR2 data
		tma	#POLYGON_SIN8_MAP
		sta	<saveSin8Mpr

		ldy	<mul16a
		lda	mulBankData, y
		tam	#POLYGON_SIN8_MAP

		lda	<mul16a
		and	#$0F
		asl	a
		adc	#POLYGON_SIN8_ADDR
		stz	<mulSinAddr0A
		sta	<mulSinAddr0A+1
		stz	<mulSinAddr0B
		inc	a
		sta	<mulSinAddr0B+1

		ply

		rts


;----------------------------
calcSin8MulData:
;mul16d:mul16c = mul16a * sin data
		phy

		mov	<mul16b+1, <mul16a+1

;mul16a sign
		bbr7	<mul16a+1, .jp00

;mul16a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.jp00:
		bbr0	<mulSinWork0, .jp01

		stz	<mul16c
		lda	<mul16a
		sta	<mul16c+1
		lda	<mul16a+1
		sta	<mul16d

		bra	.jp02

.jp01:
		ldy	<mul16a
		lda	[mulSinAddr0A], y
		sta	<mul16c

		lda	[mulSinAddr0B], y

		clc

		ldy	<mul16a+1
		adc	[mulSinAddr0A], y
		sta	<mul16c+1

		lda	[mulSinAddr0B], y
		adc	#0
		sta	<mul16d

.jp02:
		lda	<mul16b+1
		eor	<mulSinWork0

		bpl	.jp03

;anser neg
		sec
		cla
		sbc	<mul16c
		sta	<mul16c

		cla
		sbc	<mul16c+1
		sta	<mul16c+1

		cla
		sbc	<mul16d
		sta	<mul16d

.jp03:
		ply

		rts


;----------------------------
_calcSin8MulData:
;mul16d:mul16c = mul16d:mul16c +- mul16a * sin data
		phy

		eor	<mul16a+1
		eor	<mulSinWork0
		sta	<mul16b+1

;mul16a sign
		bbr7	<mul16a+1, .jp00

;mul16a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.jp00:
		bbr0	<mulSinWork0, .jp01

		stz	<work8a
		lda	<mul16a
		sta	<work8a+1
		lda	<mul16a+1
		sta	<work8a+2

		bra	.jp02

.jp01:
		ldy	<mul16a
		lda	[mulSinAddr0A], y
		sta	<work8a

		lda	[mulSinAddr0B], y

		clc

		ldy	<mul16a+1
		adc	[mulSinAddr0A], y
		sta	<work8a+1

		lda	[mulSinAddr0B], y
		adc	#0
		sta	<work8a+2

.jp02:
		bbr7	<mul16b+1, .jpAdd

;sub
		sec
		lda	<mul16c
		sbc	<work8a
		sta	<mul16c

		lda	<mul16c+1
		sbc	<work8a+1
		sta	<mul16c+1

		lda	<mul16d
		sbc	<work8a+2
		sta	<mul16d

		bra	.jpEnd

;add
.jpAdd:
		clc
		lda	<mul16c
		adc	<work8a
		sta	<mul16c

		lda	<mul16c+1
		adc	<work8a+1
		sta	<mul16c+1

		lda	<mul16d
		adc	<work8a+2
		sta	<mul16d

.jpEnd:
		ply

		rts


;----------------------------
unsetSin8MulData:
;
		lda	<saveSin8Mpr
		tam	#POLYGON_SIN8_MAP

		rts


;----------------------------
setCos8MulData:
;mul16a cos data
		phy

		lda	<mul16a+1
		sta	<mulCosWork0

;save MPR3 data
		tma	#POLYGON_COS8_MAP
		sta	<saveCos8Mpr

		ldy	<mul16a
		lda	mulBankData, y
		tam	#POLYGON_COS8_MAP

		lda	<mul16a
		and	#$0F
		asl	a
		adc	#POLYGON_COS8_ADDR
		stz	<mulCosAddr0A
		sta	<mulCosAddr0A+1
		stz	<mulCosAddr0B
		inc	a
		sta	<mulCosAddr0B+1

		ply

		rts


;----------------------------
calcCos8MulData:
;mul16d:mul16c = mul16a * cos data
		phy

		mov	<mul16b+1, <mul16a+1

;mul16a sign
		bbr7	<mul16a+1, .jp00

;mul16a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.jp00:
		bbr0	<mulCosWork0, .jp01

		stz	<mul16c
		lda	<mul16a
		sta	<mul16c+1
		lda	<mul16a+1
		sta	<mul16d

		bra	.jp02

.jp01:
		ldy	<mul16a
		lda	[mulCosAddr0A], y
		sta	<mul16c

		lda	[mulCosAddr0B], y

		clc

		ldy	<mul16a+1
		adc	[mulCosAddr0A], y
		sta	<mul16c+1

		lda	[mulCosAddr0B], y
		adc	#0
		sta	<mul16d

.jp02:
		lda	<mul16b+1
		eor	<mulCosWork0

		bpl	.jp03

;anser neg
		sec
		cla
		sbc	<mul16c
		sta	<mul16c

		cla
		sbc	<mul16c+1
		sta	<mul16c+1

		cla
		sbc	<mul16d
		sta	<mul16d

.jp03:
		ply

		rts


;----------------------------
_calcCos8MulData:
;mul16d:mul16c = mul16d:mul16c +- mul16a * cos data
		phy

		eor	<mul16a+1
		eor	<mulCosWork0
		sta	<mul16b+1

;mul16a sign
		bbr7	<mul16a+1, .jp00

;mul16a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.jp00:
		bbr0	<mulCosWork0, .jp01

		stz	<work8a
		lda	<mul16a
		sta	<work8a+1
		lda	<mul16a+1
		sta	<work8a+2

		bra	.jp02

.jp01:
		ldy	<mul16a
		lda	[mulCosAddr0A], y
		sta	<work8a

		lda	[mulCosAddr0B], y

		clc

		ldy	<mul16a+1
		adc	[mulCosAddr0A], y
		sta	<work8a+1

		lda	[mulCosAddr0B], y
		adc	#0
		sta	<work8a+2

.jp02:
		bbr7	<mul16b+1, .jpAdd

;sub
		sec
		lda	<mul16c
		sbc	<work8a
		sta	<mul16c

		lda	<mul16c+1
		sbc	<work8a+1
		sta	<mul16c+1

		lda	<mul16d
		sbc	<work8a+2
		sta	<mul16d

		bra	.jpEnd

;add
.jpAdd:
		clc
		lda	<mul16c
		adc	<work8a
		sta	<mul16c

		lda	<mul16c+1
		adc	<work8a+1
		sta	<mul16c+1

		lda	<mul16d
		adc	<work8a+2
		sta	<mul16d

.jpEnd:
		ply

		rts


;----------------------------
unsetCos8MulData:
;
		lda	<saveCos8Mpr
		tam	#POLYGON_COS8_MAP

		rts


;----------------------------
vertexRotationZ8:
;x=xcosA-ysinA	y=xsinA+ycosA	z=z
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		phx
		phy

		cpx	#0
		beq	.vertexRotationZEnd

		lda	<vertexCount
		beq	.vertexRotationZEnd

		lda	sin8DataLow, x			;sin
		sta	<mul16a
		lda	sin8DataHigh, x
		sta	<mul16a+1
		jsr	setSin8MulData

		lda	cos8DataLow, x			;cos
		sta	<mul16a
		lda	cos8DataHigh, x
		sta	<mul16a+1
		jsr	setCos8MulData

		ldx	<vertexCount

		cly

.vertexRotationZLoop:
;----------------
		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		jsr	calcCos8MulData

		lda	transform2DWork0+2, y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		lda	#$80
		jsr	_calcSin8MulData

		lda	<mul16c+1
		pha
		lda	<mul16d
		pha

;----------------
		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		jsr	calcSin8MulData

		lda	transform2DWork0+2, y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		cla
		jsr	_calcCos8MulData

		lda	<mul16c+1
		sta	transform2DWork0+2, y
		lda	<mul16d
		sta	transform2DWork0+3, y

;----------------
		pla
		sta	transform2DWork0+1, y
		pla
		sta	transform2DWork0, y

;----------------
		ady	#6

		dex
		bne	.vertexRotationZLoop

		jsr	unsetSin8MulData
		jsr	unsetCos8MulData

.vertexRotationZEnd:
		ply
		plx
		rts


;----------------------------
vertexRotationY8:
;x=xcosA-zsinA	y=y		z=xsinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		phx
		phy

		cpx	#0
		beq	.vertexRotationYEnd

		lda	<vertexCount
		beq	.vertexRotationYEnd

		lda	sin8DataLow, x			;sin
		sta	<mul16a
		lda	sin8DataHigh, x
		sta	<mul16a+1
		jsr	setSin8MulData

		lda	cos8DataLow, x			;cos
		sta	<mul16a
		lda	cos8DataHigh, x
		sta	<mul16a+1
		jsr	setCos8MulData

		ldx	<vertexCount

		cly

.vertexRotationYLoop:
;----------------
		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		jsr	calcCos8MulData

		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		lda	#$80
		jsr	_calcSin8MulData

		lda	<mul16c+1
		pha
		lda	<mul16d
		pha

;----------------------------
		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		jsr	calcSin8MulData

		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		cla
		jsr	_calcCos8MulData

		lda	<mul16c+1
		sta	transform2DWork0+4, y
		lda	<mul16d
		sta	transform2DWork0+5, y

;----------------
		pla
		sta	transform2DWork0+1, y
		pla
		sta	transform2DWork0, y

;----------------
		ady	#6

		dex
		bne	.vertexRotationYLoop

		jsr	unsetSin8MulData
		jsr	unsetCos8MulData

.vertexRotationYEnd:
		ply
		plx
		rts


;----------------------------
vertexRotationX8:
;x=x		y=ycosA+zsinA	z=-ysinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		phx
		phy

		cpx	#0
		beq	.vertexRotationXEnd

		lda	<vertexCount
		beq	.vertexRotationXEnd

		lda	sin8DataLow, x			;sin
		sta	<mul16a
		lda	sin8DataHigh, x
		sta	<mul16a+1
		jsr	setSin8MulData

		lda	cos8DataLow, x			;cos
		sta	<mul16a
		lda	cos8DataHigh, x
		sta	<mul16a+1
		jsr	setCos8MulData

		ldx	<vertexCount

		cly

.vertexRotationXLoop:
;----------------
		lda	transform2DWork0+2, y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		jsr	calcCos8MulData

		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		cla
		jsr	_calcSin8MulData

		lda	<mul16c+1
		pha
		lda	<mul16d
		pha

;----------------
		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		jsr	calcCos8MulData

		lda	transform2DWork0+2, y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		lda	#$80
		jsr	_calcSin8MulData

		lda	<mul16c+1
		sta	transform2DWork0+4, y
		lda	<mul16d
		sta	transform2DWork0+5, y

;----------------
		pla
		sta	transform2DWork0+3, y
		pla
		sta	transform2DWork0+2, y

;----------------
		ady	#6

		dex
		bne	.vertexRotationXLoop

		jsr	unsetSin8MulData
		jsr	unsetCos8MulData

.vertexRotationXEnd:
		ply
		plx
		rts


;----------------------------
selectVertexRotation8:
;
		and	#3
		beq	.rotationSelectX

		cmp	#2
		beq	.rotationSelectZ
		bcc	.rotationSelectY
		rts

.rotationSelectZ:
		ldx	<rotationZ
		jsr	vertexRotationZ8
		rts

.rotationSelectX:
		ldx	<rotationX
		jsr	vertexRotationX8
		rts

.rotationSelectY:
		ldx	<rotationY
		jsr	vertexRotationY8
		rts


;----------------------------
selectVertexRotation:
;
		and	#3
		beq	.rotationSelectX

		cmp	#2
		beq	.rotationSelectZ
		bcc	.rotationSelectY
		rts

.rotationSelectZ:
		ldx	<rotationZ
		jsr	vertexRotationZ
		rts

.rotationSelectX:
		ldx	<rotationX
		jsr	vertexRotationX
		rts

.rotationSelectY:
		ldx	<rotationY
		jsr	vertexRotationY
		rts


;----------------------------
vertexRotationZ:
;x=xcosA-ysinA	y=xsinA+ycosA	z=z
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		phx
		phy

		cpx	#0
		jeq	.vertexRotationZEnd

		lda	<vertexCount
		jeq	.vertexRotationZEnd

		lda	sinDataLow, x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh, x
		sta	<vertexRotationSin+1

		lda	cosDataLow, x			;cos
		sta	<vertexRotationCos
		lda	cosDataHigh, x
		sta	<vertexRotationCos+1

		ldx	<vertexCount

		cly

.vertexRotationZLoop:
;----------------
		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;xcosA

		movq	<work8a, <mul16c

		lda	transform2DWork0+2, y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;ysinA

		subq	<mul16c, <work8a, <mul16c	;xcosA-ysinA

		lda	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	a
		asl	<mul16c+1
		rol	<mul16d
		rol	a

		pha
		lda	<mul16d
		pha

;----------------
		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;xsinA

		movq	<work8a, <mul16c

		lda	transform2DWork0+2, y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;ycosA

		addq	<mul16c, <work8a, <mul16c	;xsinA+ycosA

		lda	<mul16d
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1

		sta	transform2DWork0+2, y
		lda	<mul16d+1
		sta	transform2DWork0+3, y

;----------------
		pla
		sta	transform2DWork0, y
		pla
		sta	transform2DWork0+1, y

;----------------
		ady	#6

		dex
		jne	.vertexRotationZLoop

.vertexRotationZEnd:
		ply
		plx
		rts


;----------------------------
vertexRotationY:
;x=xcosA-zsinA	y=y		z=xsinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		phx
		phy

		cpx	#0
		jeq	.vertexRotationYEnd

		lda	<vertexCount
		jeq	.vertexRotationYEnd

		lda	sinDataLow, x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh, x
		sta	<vertexRotationSin+1

		lda	cosDataLow, x			;cos
		sta	<vertexRotationCos
		lda	cosDataHigh, x
		sta	<vertexRotationCos+1

		ldx	<vertexCount

		cly

.vertexRotationYLoop:
;----------------
		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;zsinA

		movq	<work8a, <mul16c

		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;xcosA

		subq	<mul16c, <mul16c, <work8a	;xcosA-zsinA

		lda	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	a
		asl	<mul16c+1
		rol	<mul16d
		rol	a

		pha
		lda	<mul16d
		pha

;----------------------------
		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;zcosA

		movq	<work8a, <mul16c

		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;xsinA

		addq	<mul16c, <work8a, <mul16c	;zcosA+xsinA

		lda	<mul16d
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1

		sta	transform2DWork0+4, y
		lda	<mul16d+1
		sta	transform2DWork0+5, y

;----------------
		pla
		sta	transform2DWork0, y
		pla
		sta	transform2DWork0+1, y

;----------------
		ady	#6

		dex
		jne	.vertexRotationYLoop

.vertexRotationYEnd:
		ply
		plx
		rts


;----------------------------
vertexRotationX:
;x=x		y=ycosA+zsinA	z=-ysinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		phx
		phy

		cpx	#0
		jeq	.vertexRotationXEnd

		lda	<vertexCount
		jeq	.vertexRotationXEnd

		lda	sinDataLow, x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh, x
		sta	<vertexRotationSin+1

		lda	cosDataLow, x			;cos
		sta	<vertexRotationCos
		lda	cosDataHigh, x
		sta	<vertexRotationCos+1

		ldx	<vertexCount

		cly

.vertexRotationXLoop:
;----------------
		lda	transform2DWork0+2, y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;ycosA

		movq	<work8a, <mul16c

		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;zsinA

		addq	<mul16c, <work8a, <mul16c	;ycosA+zsinA

		lda	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	a
		asl	<mul16c+1
		rol	<mul16d
		rol	a

		pha
		lda	<mul16d
		pha

;----------------
		lda	transform2DWork0+2, y	;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;ysinA

		movq	<work8a, <mul16c

		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;zcosA

		subq	<mul16c, <mul16c, <work8a 	;-ysinA+zcosA

		lda	<mul16d
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1

		sta	transform2DWork0+4, y
		lda	<mul16d+1
		sta	transform2DWork0+5, y

;----------------
		pla
		sta	transform2DWork0+2, y
		pla
		sta	transform2DWork0+3, y

;----------------
		ady	#6

		dex
		jne	.vertexRotationXLoop

.vertexRotationXEnd:
		ply
		plx
		rts


;----------------------------
vertexTranslationDatas:
;target vertex data: vertexDataTemp
		phx
		phy

		ldx	<vertexCount
		beq	.vertexTranslationEnd

		cly

.vertexTranslationLoop:
		clc
		lda	transform2DWork0, y
		adc	<translationX
		sta	transform2DWork0, y
		lda	transform2DWork0+1, y
		adc	<translationX+1
		sta	transform2DWork0+1, y

		clc
		lda	transform2DWork0+2, y
		adc	<translationY
		sta	transform2DWork0+2, y
		lda	transform2DWork0+3, y
		adc	<translationY+1
		sta	transform2DWork0+3, y

		clc
		lda	transform2DWork0+4, y
		adc	<translationZ
		sta	transform2DWork0+4, y
		lda	transform2DWork0+5, y
		adc	<translationZ+1
		sta	transform2DWork0+5, y

		ady	#6

		dex
		bne	.vertexTranslationLoop

.vertexTranslationEnd:
		ply
		plx
		rts


;----------------------------
transform2D:
;
		phx
		phy

;save MPR2 data
		tma	#DIV_DATA_MAP
		pha

		ldy	<vertexCount
		clx

.transform2DLoop0:
;Z0 < 128 check
		sec
		lda	transform2DWork0+4, x	;Z0
		sta	transform2DWork1+4, x
		sbc	#SCREEN_Z
		lda	transform2DWork0+5, x
		sta	transform2DWork1+5, x
		sbc	#0

		bpl	.transform2DJump05
		jmp	.transform2DJump00

.transform2DJump05:
;X0 to mul16c
		lda	transform2DWork0, x
		sta	transform2DWork1, x
		sta	<mul16c
		lda	transform2DWork0+1, x
		sta	transform2DWork1+1, x
		sta	<mul16c+1

;Z0 to mul16a
		lda	transform2DWork0+4, x
		sta	<mul16a
		lda	transform2DWork0+5, x
		sta	<mul16a+1

;X0*128/Z0
		jsr	transform2DProc

;X0*128/Z0+centerX
;mul16a+centerX to X0
		clc
		lda	<work8b+2
		adc	<centerX
		sta	transform2DWork0, x	;X0
		lda	<work8b+3
		adc	<centerX+1
		sta	transform2DWork0+1, x

;Y0 to mul16c
		lda	transform2DWork0+2, x
		sta	transform2DWork1+2, x
		sta	<mul16c
		lda	transform2DWork0+3, x
		sta	transform2DWork1+3, x
		sta	<mul16c+1

;Z0 to mul16a
		lda	transform2DWork0+4, x
		sta	<mul16a
		lda	transform2DWork0+5, x
		sta	<mul16a+1

;Y0*128/Z0
		jsr	transform2DProc

;centerY-Y0*128/Z0
;centerY-mul16a to Y0
		sec
		lda	<centerY
		sbc	<work8b+2
		sta	transform2DWork0+2, x	;Y0
		lda	<centerY+1
		sbc	<work8b+3
		sta	transform2DWork0+3, x

		jmp	.transform2DJump01

.transform2DJump00:
		lda	transform2DWork0, x
		sta	transform2DWork1, x
		lda	transform2DWork0+1, x
		sta	transform2DWork1+1, x

		lda	transform2DWork0+2, x
		sta	transform2DWork1+2, x
		lda	transform2DWork0+3, x
		sta	transform2DWork1+3, x

;Z0<128 flag set
		stz	transform2DWork0+4, x
		lda	#$80
		sta	transform2DWork0+5, x

.transform2DJump01:
		adx	#6

		dey
		jne	.transform2DLoop0

;set MPR2 data
		pla
		tam	#DIV_DATA_MAP

		ply
		plx
		rts


;----------------------------
transform2DProc:
;work8b+3:work8b+2(rough value) = (mul16c(-32768 to 32767) * 128 / mul16a(1 to 32767))
		lda	mul16a+1
		bne	.jp99

		lda	mul16a
		cmp	#SCREEN_Z
		bne	.jp98

		movw	work8b+2, mul16c
		rts

.jp98:
		phx
		phy

;get div data
		lda	divBankData
		tax
		tam	#DIV_DATA_MAP

		lda	#DIV_DATA_ADDR
		bra	.jp97

.jp99:
		phx
		phy

;get div data
		ldy	<div16a+1
		lda	divBankData, y
		tax
		tam	#DIV_DATA_MAP

		lda	<div16a+1
		and	#$1F
		clc
		adc	#DIV_DATA_ADDR

.jp97:
		stz	<mulAddr
		sta	<mulAddr+1

		ldy	<div16a
		lda	[mulAddr], y
		sta	<work8a

		clc
		txa
		adc	#4		;carry clear
		tam	#DIV_DATA_MAP

		lda	[mulAddr], y
		sta	<work8a+1

		txa
		adc	#8		;carry clear
		tam	#DIV_DATA_MAP

		lda	[mulAddr], y
		sta	<work8a+2

;c sign
		lda	<mul16c+1
		pha
		bpl	.jp00
;c neg
		sec
		cla
		sbc	<mul16c
		sta	<mul16c

		cla
		sbc	<mul16c+1
		sta	<mul16c+1

.jp00:
;mul mul16c low byte
		ldy	<mul16c
		lda	mulBankData, y
		tam	#MUL_DATA_MAP

		lda	<mul16c
		and	#$0F
		asl	a
		clc
		adc	#MUL_DATA_ADDR
		sta	<mulAddr+1

		ldy	<work8a+1
		lda	[mulAddr], y
		sta	<work8b+1

		ldy	<work8a+2
		lda	[mulAddr], y
		sta	<work8b+2

		inc	<mulAddr+1

		ldx	#LOW(work8b+1)
		ldy	<work8a
		set
		adc	[mulAddr], y

		inx
		ldy	<work8a+1
		set
		adc	[mulAddr], y

		ldy	<work8a+2
		lda	[mulAddr], y
		adc	#0		;carry clear
		sta	<work8b+3

;mul mul16c high byte
		ldy	<mul16c+1
		lda	mulBankData, y
		tam	#MUL_DATA_MAP


		lda	<mul16c+1
		and	#$0F
		asl	a
		clc
		adc	#MUL_DATA_ADDR
		sta	<mulAddr+1

		ldx	#LOW(work8b+1)
		ldy	<work8a
		set
		adc	[mulAddr], y

		inx
		ldy	<work8a+1
		set
		adc	[mulAddr], y

		inx
		ldy	<work8a+2
		set
		adc	[mulAddr], y

		inc	<mulAddr+1

		ldx	#LOW(work8b+2)
		ldy	<work8a
		clc
		set
		adc	[mulAddr], y

		inx
		ldy	<work8a+1
		set
		adc	[mulAddr], y

		pla
		bpl	.jp01
;ans neg
		sec
		cla
		sbc	<work8b+2
		sta	<work8b+2

		cla
		sbc	<work8b+3
		sta	<work8b+3

.jp01:
		ply
		plx
		rts


;----------------------------
moveToTransform2DWork0:
;vertex0Addr to Transform2DWork0
		lda	<vertexCount
		beq	.jpEnd

		stz	tiiCnt+1
		asl	a
		rol	tiiCnt+1
		adc	<vertexCount
		bcc	.jp0
		inc	tiiCnt+1
.jp0:
		asl	a
		sta	tiiCnt
		rol	tiiCnt+1

		movw	tiiSrc, vertex0Addr
		movw	tiiDst, #transform2DWork0
		jmp	tiiFunction

.jpEnd:
		rts


;----------------------------
setPolygonColorIndex:
;
		sta	<polygonColorIndex
		rts


;----------------------------
putPolygonBuffer:
;
		phx
		phy

;save MPR2,3 data
		tma	#POLYGON_SUB_FUNC_MAP
		pha

		tma	#POLYGON_EDGE_FUNC_MAP
		pha

;set polygon function bank
		lda	#POLYGON_SUB_FUNC_BANK
		tam	#POLYGON_SUB_FUNC_MAP

		jsr	setInc32Vdc

		movw	<polyBufferAddr, polyBufferStart

		bra	.putPolyBufferLoop0

.circleProc:
;circle process
		ldy	#6
		lda	[polyBufferAddr], y	;X
		sta	<circleCenterX

		iny
		lda	[polyBufferAddr], y
		sta	<circleCenterX+1

		iny
		lda	[polyBufferAddr], y	;Y
		sta	<circleCenterY

		iny
		lda	[polyBufferAddr], y
		sta	<circleCenterY+1

		iny
		lda	[polyBufferAddr], y	;RADIUS
		sta	<circleRadius

		iny
		lda	[polyBufferAddr], y
		sta	<circleRadius+1

		jsr	calcCircle_putPoly

.nextData:
		lda	[polyBufferAddr]
		tax
		ldy	#1
		lda	[polyBufferAddr], y
		sta	<polyBufferAddr+1
		stx	<polyBufferAddr+0

.putPolyBufferLoop0:
		ldy	#4
		lda	[polyBufferAddr], y	;COLOR

;set polygon pattern
		tax
		lda	polygonColorP0, x
		sta	polyLineColorWork_H_P0
		sta	polyLineColorWork_L_P0
		rol	a
		rol	polyLineColorWork_L_P0

		lda	polygonColorP1, x
		sta	polyLineColorWork_H_P1
		sta	polyLineColorWork_L_P1
		rol	a
		rol	polyLineColorWork_L_P1

		lda	polygonColorP2, x
		sta	polyLineColorWork_H_P2
		sta	polyLineColorWork_L_P2
		rol	a
		rol	polyLineColorWork_L_P2

		lda	polygonColorP3, x
		sta	polyLineColorWork_H_P3
		sta	polyLineColorWork_L_P3
		rol	a
		rol	polyLineColorWork_L_P3

		ldy	#5
		lda	[polyBufferAddr], y	;COUNT
		jeq	.putPolyBufferEnd

		sta	<polyAttribute
		bmi	.circleProc

.polygonProc:
		and	#$0F
		dec	a
		sta	<clip2D0Count

		ldy	#7
		lda	[polyBufferAddr], y
		sta	<minEdgeY
		sta	<maxEdgeY

		clx

		dey

.putPolyBufferLoop1:
		lda	[polyBufferAddr], y
		sta	<edgeX0
		iny
		lda	[polyBufferAddr], y
		sta	<edgeY0
		iny

		phy

		lda	[polyBufferAddr], y
		sta	<edgeX1
		iny
		lda	[polyBufferAddr], y
		sta	<edgeY1
		iny

		cmp	<minEdgeY
		bcs	.jp0
		sta	<minEdgeY

.jp0:
		cmp	<maxEdgeY
		bcc	.jp1
		sta	<maxEdgeY

.jp1:
		cmp	<edgeY0
		beq	.jp2
		ldx	#1

		phx

		jsr	calcEdge

		plx

.jp2:
		ply

		dec	<clip2D0Count
		bne	.putPolyBufferLoop1

		cpx	#0
		beq	.jp4

		lda	[polyBufferAddr], y
		sta	<edgeX0
		iny
		lda	[polyBufferAddr], y
		sta	<edgeY0

		ldy	#6
		lda	[polyBufferAddr], y
		sta	<edgeX1
		iny
		lda	[polyBufferAddr], y
		sta	<edgeY1

		cmp	<edgeY0
		beq	.jp3

		jsr	calcEdge

.jp3:
		jsr	putPolyLine

.jp4:
		jmp	.nextData

.putPolyBufferEnd:
		jsr	setInc1Vdc

;set MPR2,3 data
		pla
		tam	#POLYGON_EDGE_FUNC_MAP

		pla
		tam	#POLYGON_SUB_FUNC_MAP

		ply
		plx
		rts


;----------------------------
setModelRotation:
;
		phx
		phy
;rotation
		ldy	#$03
		lda	[modelAddress], y		;vertex data address
		sta	<vertex0Addr
		iny
		lda	[modelAddress], y
		sta	<vertex0Addr+1

		iny
		lda	[modelAddress], y		;vertex count
		sta	<vertexCount

		jsr	moveToTransform2DWork0

		lda	<rotationSelect
		and	#3
		jsr	selectVertexRotation8

		lda	<rotationSelect
		lsr	a
		lsr	a
		and	#3
		jsr	selectVertexRotation8

		lda	<rotationSelect
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		and	#3
		jsr	selectVertexRotation8

;translation
		subw	<translationX, <eyeTranslationX

		subw	<translationY, <eyeTranslationY

		subw	<translationZ, <eyeTranslationZ

		jsr	vertexTranslationDatas

;eye rotation
		mov	<rotationX, <eyeRotationX
		mov	<rotationY, <eyeRotationY
		mov	<rotationZ, <eyeRotationZ

		lda	<eyeRotationSelect
		and	#3
		jsr	selectVertexRotation8

		lda	<eyeRotationSelect
		lsr	a
		lsr	a
		and	#3
		jsr	selectVertexRotation8

		lda	<eyeRotationSelect
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		and	#3
		jsr	selectVertexRotation8

		jsr	setModel

		ply
		plx
		rts


;----------------------------
setModel:
;target vertex data: vertexDataTemp
;transform2D
		phx
		phy

;transform 2D
		jsr	transform2D

		cly
		lda	[modelAddress], y
		sta	<modelAddrWork		;ModelData Polygon Addr
		iny
		lda	[modelAddress], y
		sta	<modelAddrWork+1

		iny
		lda	[modelAddress], y	;Polygon Count
		sta	<modelPolygonCount

		cly

.setModelLoop3:
		phy

		lda	[modelAddrWork], y	;ModelData Attribute
		sta	<setModelAttr

		iny
		lda	[modelAddrWork], y	;ModelData Front Color
		sta	<setModelFrontColor

		iny
		lda	[modelAddrWork], y	;ModelData Back Color
		sta	<setModelBackColor

		iny
		lda	[modelAddrWork], y	;ModelData Count
		sta	<setModelCount

		bbr7	<setModelAttr, .polygonProc

;circle process
		iny
		lda	[modelAddrWork], y
		tax
		lda	transform2DWork0+5, x	;Z0<128 flag
		jmi	.setModelJump0

;SAMPLE Z
		ldy	#2
		lda	transform2DWork0+4, x
		sta	[polyBufferAddr], y
		sta	<mul16a

		iny
		lda	transform2DWork0+5, x
		sta	[polyBufferAddr], y
		sta	<mul16a+1

		lda	<setModelBackColor
		sta	<mul16c
		lda	<setModelCount
		sta	<mul16c+1

;transform 2D
		tma	#DIV_DATA_MAP
		pha
		jsr	transform2DProc
		pla
		tam	#DIV_DATA_MAP

		lda	<work8b+2
		ora	<work8b+3
		jeq	.setModelJump0

		mov	clip2D0+8, <work8b+2
		mov	clip2D0+10, <work8b+3

		ldy	#5
		lda	<setModelAttr
		and	#%11000000
		sta	[polyBufferAddr], y	;COUNT

		dey
		lda	<setModelFrontColor

		sta	[polyBufferAddr], y	;COLOR

		lda	transform2DWork0+0, x	;X
		sta	clip2D0
		lda	transform2DWork0+1, x
		sta	clip2D0+2

		lda	transform2DWork0+2, x	;Y
		sta	clip2D0+4
		lda	transform2DWork0+3, x
		sta	clip2D0+6

		mov	<clip2D0Count, #3

		stz	<backCheckFlag

		jmp	.setBuffer

.polygonProc:
		lda	<setModelCount

;push setModelCount for initialize front clip calculation
		pha

		iny
		lda	[modelAddrWork], y
		sta	<frontClipDataWork

		stz	<model2DClipIndexWork

		stz	<frontClipCount

		stz	<polyBufferZ0Work0
		stz	<polyBufferZ0Work0+1

;push ModelData index for initialize front clip calculation
		phy

;check front clip
.setModelLoop5:
		lda	[modelAddrWork], y
		tax
		lda	transform2DWork0+5, x	;Z0<128 flag
		bmi	.setModelJump7

		phy

		ldy	<model2DClipIndexWork

		lda	transform2DWork0, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+1, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+2, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+3, x
		sta	clip2D0, y
		iny

;check Z sample
		sec
		lda	<polyBufferZ0Work0
		sbc	transform2DWork0+4, x
		lda	<polyBufferZ0Work0+1
		sbc	transform2DWork0+5, x

		bpl	.setModelJump9

		lda	transform2DWork0+4, x
		sta	<polyBufferZ0Work0
		lda	transform2DWork0+5, x
		sta	<polyBufferZ0Work0+1

.setModelJump9:
		sty	<model2DClipIndexWork

		ply

		iny

		dec	<setModelCount
		bne	.setModelLoop5

		ply
		pla

		bra	.setModelJump8

;initialize front clip calculation
.setModelJump7:
		ply
		pla
		dec	a
		sta	<setModelCount

		stz	<model2DClipIndexWork

		stz	<polyBufferZ0Work0
		stz	<polyBufferZ0Work0+1

;cancel front clip calculation
		bbr2	<setModelAttr, .setModelLoop4
		jmp	.setModelJump0

;front clip calculation
.setModelLoop4:
		lda	[modelAddrWork], y
		sta	<frontClipData0

		iny

		lda	[modelAddrWork], y
		sta	<frontClipData1

		phy
		jsr	clipFront
		ply

		dec	<setModelCount
		bne	.setModelLoop4

;--------
		lda	[modelAddrWork], y
		sta	<frontClipData0

		lda	<frontClipDataWork
		sta	<frontClipData1

		jsr	clipFront

		lda	<frontClipCount
		jeq	.setModelJump0

.setModelJump8:
		sta	<clip2D0Count

		movq	 backCheckWork+0, clip2D0+0
		movq	 backCheckWork+4, clip2D0+4
		movq	 backCheckWork+8, clip2D0+8

;check 2d clip
		jsr	checkClip2D
		lda	<clip2DCheckFlag
		jmi	.setModelJump0

.setModelJump13:
;back side check
		stz	<backCheckFlag
		subw	<mul16a, backCheckWork+8, backCheckWork+4	;X2-X1
		subw	<mul16b, backCheckWork+2, backCheckWork+6	;Y0-Y1
		jsr	smul16
		movq	<work8a, <mul16c

		subw	<mul16a, backCheckWork+10, backCheckWork+6	;Y2-Y1
		subw	<mul16b, backCheckWork, backCheckWork+4		;X0-X1
		jsr	smul16

		subq	<work8a, <mul16c
		bmi	.setModelJump2

		lda	<work8a
		ora	<work8a+1
		ora	<work8a+2
		ora	<work8a+3
		jeq	.setModelJump0

;back side
		smb0	<backCheckFlag
		bbr0	<setModelAttr, .setModelJump6
		jmp	.setModelJump0

.setModelJump6:
		lda	<setModelBackColor
		bra	.setModelJump10

.setModelJump2:
;front side
		lda	<setModelFrontColor

.setModelJump10:
		clc
		adc	<polygonColorIndex

		ldy	#4
		sta	[polyBufferAddr], y	;COLOR

		lda	<clip2DCheckFlag
		beq	.setModelJump14

		jsr	clip2D
		jeq	.setModelJump0

.setModelJump14:
		lda	<setModelAttr
		and	#%11000000
		ora	<clip2D0Count
		ldy	#5
		sta	[polyBufferAddr], y	;COUNT

;SAMPLE Z
		ldy	#2
		lda	<polyBufferZ0Work0	;SAMPLE Z
		sta	[polyBufferAddr], y
		iny
		lda	<polyBufferZ0Work0+1
		sta	[polyBufferAddr], y

;set buffer
.setBuffer:
		movw	<polyBufferNow, #polyBufferStart

.setBufferLoop:
		cly				;NEXT ADDR
		lda	[polyBufferNow], y
		sta	<polyBufferNext
		iny
		lda	[polyBufferNow], y
		sta	<polyBufferNext+1

		ldy	#2			;NEXT SAMPLE Z
		lda	[polyBufferNext], y
		sta	<polyBufferZ0Work0
		iny
		lda	[polyBufferNext], y
		sta	<polyBufferZ0Work0+1

		ldy	#2			;SAMPLE Z
		sec
		lda	[polyBufferAddr], y
		sbc	<polyBufferZ0Work0
		iny
		lda	[polyBufferAddr], y
		sbc	<polyBufferZ0Work0+1

		bpl	.setBufferJump		;SAMPLE Z >= NEXT SAMPLE Z

		movw	<polyBufferNow, <polyBufferNext

		bra	.setBufferLoop

.setBufferJump:
		cly				;BUFFER -> NEXT
		lda	<polyBufferNext
		sta	[polyBufferAddr], y
		iny
		lda	<polyBufferNext+1
		sta	[polyBufferAddr], y

		cly				;NOW -> BUFFER
		lda	<polyBufferAddr
		sta	[polyBufferNow], y
		iny
		lda	<polyBufferAddr+1
		sta	[polyBufferNow], y

;set data
		bbs0	<backCheckFlag, .setModelJump11

		clx
		ldy	#6
.setModelLoop2:
		lda	clip2D0, x
		sta	[polyBufferAddr], y
		inx
		inx
		iny

		lda	clip2D0, x
		sta	[polyBufferAddr], y
		inx
		inx
		iny

		dec	<clip2D0Count
		bne	.setModelLoop2

		bra	.setModelJump12

.setModelJump11:
		lda	<clip2D0Count
		dec	a
		asl	a
		asl	a
		tax
		ldy	#6
.setModelLoop6:
		lda	clip2D0, x
		sta	[polyBufferAddr], y
		inx
		inx
		iny

		lda	clip2D0, x
		sta	[polyBufferAddr], y
		sbx	#6
		iny

		dec	<clip2D0Count
		bne	.setModelLoop6

.setModelJump12:
;next buffer address
		clc
		tya
		adc	<polyBufferAddr
		sta	<polyBufferAddr
		bcc	.setModelJump0
		inc	<polyBufferAddr+1

.setModelJump0:
		pla
		add	#8
		tay

		dec	<modelPolygonCount
		jne	.setModelLoop3

		ply
		plx
		rts


;----------------------------
clipFront:
;
		ldx	<frontClipData0
		ldy	<frontClipData1

		lda	transform2DWork0+5, x	;Z0<128 flag
		and	#$80
		lsr	a
		sta	<frontClipFlag
		lda	transform2DWork0+5, y	;Z0<128 flag
		and	#$80
		ora	<frontClipFlag
		sta	<frontClipFlag
		jeq	.clipFrontJump8

		cmp	#$C0
		jeq	.clipFrontJump9

;clip front
;(128-Z0) to mul16a
		sec
		lda	#SCREEN_Z
		sbc	transform2DWork1+4, x
		sta	<mul16a
		cla
		sbc	transform2DWork1+5, x
		sta	<mul16a+1

;(X1-X0) to mul16b
		sec
		lda	transform2DWork1+0, y
		sbc	transform2DWork1+0, x
		sta	<mul16b
		lda	transform2DWork1+1, y
		sbc	transform2DWork1+1, x
		sta	<mul16b+1

;(128-Z0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Z1-Z0) to mul16a
		sec
		lda	transform2DWork1+4, y
		sbc	transform2DWork1+4, x
		sta	<mul16a
		lda	transform2DWork1+5, y
		sbc	transform2DWork1+5, x
		sta	<mul16a+1

;(128-Z0)*(X1-X0)/(Z1-Z0)
		jsr	sdiv32

;(128-Z0)*(X1-X0)/(Z1-Z0)+X0
		clc
		lda	<mul16a
		adc	transform2DWork1+0, x
		sta	<mul16a
		lda	<mul16a+1
		adc	transform2DWork1+1, x
		sta	<mul16a+1

;mul16a+centerX
		addw	<clipFrontX, <mul16a, <centerX

;(128-Z0) to mul16a
		sec
		lda	#SCREEN_Z
		sbc	transform2DWork1+4, x
		sta	<mul16a
		cla
		sbc	transform2DWork1+5, x
		sta	<mul16a+1

;(Y1-Y0) to mul16b
		sec
		lda	transform2DWork1+2, y
		sbc	transform2DWork1+2, x
		sta	<mul16b
		lda	transform2DWork1+3, y
		sbc	transform2DWork1+3, x
		sta	<mul16b+1

;(128-Z0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(Z1-Z0) to mul16a
		sec
		lda	transform2DWork1+4, y
		sbc	transform2DWork1+4, x
		sta	<mul16a
		lda	transform2DWork1+5, y
		sbc	transform2DWork1+5, x
		sta	<mul16a+1

;(128-Z0)*(Y1-Y0)/(Z1-Z0)
		jsr	sdiv32

;(128-Z0)*(Y1-Y0)/(Z1-Z0)+Y0
		clc
		lda	<mul16a
		adc	transform2DWork1+2, x
		sta	<mul16a
		lda	<mul16a+1
		adc	transform2DWork1+3, x
		sta	<mul16a+1

;centerY-mul16a
		subw	<clipFrontY, <centerY, <mul16a

		bbs7	<frontClipFlag, .clipFrontJump10

		ldy	<model2DClipIndexWork

		lda	<clipFrontX
		sta	clip2D0, y
		iny
		lda	<clipFrontX+1
		sta	clip2D0, y
		iny

		lda	<clipFrontY
		sta	clip2D0, y
		iny
		lda	<clipFrontY+1
		sta	clip2D0, y
		iny

		sty	<model2DClipIndexWork

		lda	#SCREEN_Z
		sta	polyBufferZ0Work1
		stz	polyBufferZ0Work1+1

		inc	<frontClipCount

		bra	.clipFrontJump11

.clipFrontJump10:
		ldy	<model2DClipIndexWork

		lda	transform2DWork0, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+1, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+2, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+3, x
		sta	clip2D0, y
		iny

		lda	<clipFrontX
		sta	clip2D0, y
		iny
		lda	<clipFrontX+1
		sta	clip2D0, y
		iny

		lda	<clipFrontY
		sta	clip2D0, y
		iny
		lda	<clipFrontY+1
		sta	clip2D0, y
		iny

		sty	<model2DClipIndexWork

		lda	transform2DWork0+4, x
		sta	polyBufferZ0Work1
		lda	transform2DWork0+5, x
		sta	polyBufferZ0Work1+1

		inc	<frontClipCount
		inc	<frontClipCount

		bra	.clipFrontJump11

.clipFrontJump8:
		ldy	<model2DClipIndexWork

		lda	transform2DWork0, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+1, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+2, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+3, x
		sta	clip2D0, y
		iny

		sty	<model2DClipIndexWork

		lda	transform2DWork0+4, x
		sta	polyBufferZ0Work1
		lda	transform2DWork0+5, x
		sta	polyBufferZ0Work1+1

		inc	<frontClipCount

.clipFrontJump11:
;check Z sample
		cmpw	<polyBufferZ0Work0, <polyBufferZ0Work1

		bpl	.clipFrontJump9

		movw	<polyBufferZ0Work0, <polyBufferZ0Work1

.clipFrontJump9:
		rts


;----------------------------
checkClip2D:
;
		stz	<clipCountX0
		stz	<clipCountX255
		stz	<clipCountY0
		stz	<clipCountY255

		clx
		ldy	<clip2D0Count
.loop00:
		lda	clip2D0+1, x
		bpl	.jp00

		inc	<clipCountX0

.jp00:
		lda	clip2D0+1, x
		beq	.jp01
		bmi	.jp01

		inc	<clipCountX255

.jp01:
		lda	clip2D0+3, x
		bpl	.jp02

		inc	<clipCountY0

.jp02:
		sec
		lda	clip2D0+2, x
		sbc	#192
		lda	clip2D0+3, x
		sbc	#0
		bmi	.jp03

		inc	<clipCountY255

.jp03:
		inx
		inx
		inx
		inx

		dey
		bne	.loop00

		stz	<clip2DCheckFlag

		lda	<clipCountX0
		ora	<clipCountX255
		ora	<clipCountY0
		ora	<clipCountY255
		beq	.jpEnd

		mov	<clip2DCheckFlag, #$FF

		lda	<clip2D0Count

		cmp	<clipCountX0
		beq	.jpEnd

		cmp	<clipCountX255
		beq	.jpEnd

		cmp	<clipCountY0
		beq	.jpEnd

		cmp	<clipCountY255
		beq	.jpEnd

		mov	<clip2DCheckFlag, #$01

.jpEnd:
		rts


;----------------------------
clip2D:
;
		jsr	clip2DY0
		lda	<clip2D1Count
		beq	.clip2DEnd

		jsr	clip2DY255
		lda	<clip2D0Count
		beq	.clip2DEnd

		jsr	clip2DX0
		lda	<clip2D1Count
		beq	.clip2DEnd

		jsr	clip2DX255
		lda	<clip2D0Count

.clip2DEnd:
		rts


;----------------------------
clip2DX255:
;
		lda	<clip2D1Count
		asl	a
		asl	a
		tax

		lda	clip2D1		;X0
		sta	clip2D1, x	;last X
		lda	clip2D1+1
		sta	clip2D1+1, x

		lda	clip2D1+2	;Y0
		sta	clip2D1+2, x	;last Y
		lda	clip2D1+3
		sta	clip2D1+3, x

		clx
		cly
		stz	<clip2D0Count

		bra	.clip2DX255Loop0

.clip2DX255Rts:
		rts

.clip2DX255Jump02:
;X0<=255 X1<=255
		lda	clip2D1, y	;X0
		sta	clip2D0, x	;X0
		lda	clip2D1+1, y
		sta	clip2D0+1, x

		lda	clip2D1+2, y	;Y0
		sta	clip2D0+2, x	;Y0
		lda	clip2D1+3, y
		sta	clip2D0+3, x

		inc	<clip2D0Count

		inx
		inx
		inx
		inx

.clip2DX255Jump03:
;X0>255 X1>255
		iny
		iny
		iny
		iny

		dec	<clip2D1Count
		beq	.clip2DX255Rts

.clip2DX255Loop0:
		stz	<clip2DFlag

		lda	clip2D1+1, y
		beq	.clip2DX255Jump00
		bmi	.clip2DX255Jump00
		smb0	<clip2DFlag

.clip2DX255Jump00:
		lda	clip2D1+5, y
		beq	.clip2DX255Jump01
		bmi	.clip2DX255Jump01
		smb1	<clip2DFlag

.clip2DX255Jump01:
		lda	<clip2DFlag
		beq	.clip2DX255Jump02

		cmp	#$03
		beq	.clip2DX255Jump03

;(255-X0) to mul16a
		sec
		lda	#255
		sbc	clip2D1, y	;X0
		sta	<mul16a
		cla
		sbc	clip2D1+1, y
		sta	<mul16a+1

;(Y1-Y0) to mul16b
		sec
		lda	clip2D1+6, y	;Y1
		sbc	clip2D1+2, y	;Y0
		sta	<mul16b
		lda	clip2D1+7, y
		sbc	clip2D1+3, y
		sta	<mul16b+1

;(255-X0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(X1-X0) to mul16a
		sec
		lda	clip2D1+4, y	;X1
		sbc	clip2D1, y	;X0
		sta	<mul16a
		lda	clip2D1+5, y
		sbc	clip2D1+1, y
		sta	<mul16a+1

;(255-X0)*(Y1-Y0)/(X1-X0)
		jsr	sdiv32

;(255-X0)*(Y1-Y0)/(X1-X0)+Y0
		clc
		lda	<mul16a
		adc	clip2D1+2, y	;Y0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D1+3, y
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DX255Jump04
;X0>255 X1<=255
		lda	#$FF
		sta	clip2D0, x	;X0
		stz	clip2D0+1, x

		lda	<mul16a
		sta	clip2D0+2, x	;Y0
		lda	<mul16a+1
		sta	clip2D0+3, x

		inc	<clip2D0Count

		inx
		inx
		inx
		inx

		jmp	.clip2DX255Jump03

.clip2DX255Jump04:
;X0<=255 X1>255
		lda	clip2D1, y	;X0
		sta	clip2D0, x	;X0
		lda	clip2D1+1, y
		sta	clip2D0+1, x

		lda	clip2D1+2, y	;Y0
		sta	clip2D0+2, x	;Y0
		lda	clip2D1+3, y
		sta	clip2D0+3, x

		lda	#$FF
		sta	clip2D0+4, x	;X1
		stz	clip2D0+5, x

		lda	<mul16a
		sta	clip2D0+6, x	;Y1
		lda	<mul16a+1
		sta	clip2D0+7, x

		add	<clip2D0Count, #$02

		adx	#8

		jmp	.clip2DX255Jump03


;----------------------------
clip2DX0:
;
		lda	<clip2D0Count
		asl	a
		asl	a
		tax

		lda	clip2D0		;X0
		sta	clip2D0, x	;last X
		lda	clip2D0+1
		sta	clip2D0+1, x

		lda	clip2D0+2	;Y0
		sta	clip2D0+2, x	;last Y
		lda	clip2D0+3
		sta	clip2D0+3, x

		clx
		cly
		stz	<clip2D1Count

		bra	.clip2DX0Loop0

.clip2DX0Rts:
		rts

.clip2DX0Jump02:
;X0>=0 X1>=0
		lda	clip2D0, y	;X0
		sta	clip2D1, x	;X0
		lda	clip2D0+1, y
		sta	clip2D1+1, x

		lda	clip2D0+2, y	;Y0
		sta	clip2D1+2, x	;Y0
		lda	clip2D0+3, y
		sta	clip2D1+3, x

		inc	<clip2D1Count

		inx
		inx
		inx
		inx

.clip2DX0Jump03:
;X0<0 X1<0
		iny
		iny
		iny
		iny

		dec	<clip2D0Count
		beq	.clip2DX0Rts

.clip2DX0Loop0:
		stz	<clip2DFlag

		lda	clip2D0+1, y	;X0
		bpl	.clip2DX0Jump00
		smb0	<clip2DFlag

.clip2DX0Jump00:
		lda	clip2D0+5, y	;X1
		bpl	.clip2DX0Jump01
		smb1	<clip2DFlag

.clip2DX0Jump01:
		lda	<clip2DFlag
		beq	.clip2DX0Jump02

		cmp	#$03
		beq	.clip2DX0Jump03

;(0-X0) to mul16a
		sec
		cla
		sbc	clip2D0, y	;X0
		sta	<mul16a
		cla
		sbc	clip2D0+1, y
		sta	<mul16a+1

;(Y1-Y0) to mul16b
		sec
		lda	clip2D0+6, y	;Y1
		sbc	clip2D0+2, y	;Y0
		sta	<mul16b
		lda	clip2D0+7, y
		sbc	clip2D0+3, y
		sta	<mul16b+1

;(0-X0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(X1-X0) to mul16a
		sec
		lda	clip2D0+4, y	;X1
		sbc	clip2D0, y	;X0
		sta	<mul16a
		lda	clip2D0+5, y
		sbc	clip2D0+1, y
		sta	<mul16a+1

;(0-X0)*(Y1-Y0)/(X1-X0)
		jsr	sdiv32

;(0-X0)*(Y1-Y0)/(X1-X0)+Y0
		clc
		lda	<mul16a
		adc	clip2D0+2, y	;Y0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D0+3, y
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DX0Jump04
;X0<0 X1>=0
		stz	clip2D1, x	;X0
		stz	clip2D1+1, x

		lda	<mul16a
		sta	clip2D1+2, x	;Y0
		lda	<mul16a+1
		sta	clip2D1+3, x

		inc	<clip2D1Count

		inx
		inx
		inx
		inx

		jmp	.clip2DX0Jump03

.clip2DX0Jump04:
;X0>=0 X1<0
		lda	clip2D0, y	;X0
		sta	clip2D1, x	;X0
		lda	clip2D0+1, y
		sta	clip2D1+1, x

		lda	clip2D0+2, y	;Y0
		sta	clip2D1+2, x	;Y0
		lda	clip2D0+3, y
		sta	clip2D1+3, x

		stz	clip2D1+4, x	;X1
		stz	clip2D1+5, x

		lda	<mul16a
		sta	clip2D1+6, x	;Y1
		lda	<mul16a+1
		sta	clip2D1+7, x

		add	<clip2D1Count, #$02

		adx	#8

		jmp	.clip2DX0Jump03


;----------------------------
clip2DY255:
;
		lda	<clip2D1Count
		asl	a
		asl	a
		tax

		lda	clip2D1		;X0
		sta	clip2D1, x	;last X
		lda	clip2D1+1
		sta	clip2D1+1, x

		lda	clip2D1+2	;Y0
		sta	clip2D1+2, x	;last Y
		lda	clip2D1+3
		sta	clip2D1+3, x

		clx
		cly
		stz	<clip2D0Count

		bra	.clip2DY255Loop0

.clip2DY255Rts:
		rts

.clip2DY255Jump02:
;Y0<=191 Y1<=191
		lda	clip2D1, y	;X0
		sta	clip2D0, x	;X0
		lda	clip2D1+1, y
		sta	clip2D0+1, x

		lda	clip2D1+2, y	;Y0
		sta	clip2D0+2, x	;Y0
		lda	clip2D1+3, y
		sta	clip2D0+3, x

		inc	<clip2D0Count

		inx
		inx
		inx
		inx

.clip2DY255Jump03:
;Y0>191 Y1>191
		iny
		iny
		iny
		iny

		dec	<clip2D1Count
		beq	.clip2DY255Rts

.clip2DY255Loop0:
		stz	<clip2DFlag

		sec
		lda	clip2D1+2, y	;Y0
		sbc	#192
		lda	clip2D1+3, y
		sbc	#0
		bmi	.clip2DY255Jump00
		smb0	<clip2DFlag

.clip2DY255Jump00:
		sec
		lda	clip2D1+6, y	;Y1
		sbc	#192
		lda	clip2D1+7, y
		sbc	#0
		bmi	.clip2DY255Jump01
		smb1	<clip2DFlag

.clip2DY255Jump01:
		lda	<clip2DFlag
		beq	.clip2DY255Jump02

		cmp	#$03
		beq	.clip2DY255Jump03

;(191-Y0) to mul16a
		sec
		lda	#191
		sbc	clip2D1+2, y	;Y0
		sta	<mul16a
		cla
		sbc	clip2D1+3, y
		sta	<mul16a+1

;(X1-X0) to mul16b
		sec
		lda	clip2D1+4, y	;X1
		sbc	clip2D1, y	;X0
		sta	<mul16b
		lda	clip2D1+5, y
		sbc	clip2D1+1, y
		sta	<mul16b+1

;(191-Y0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Y1-Y0) to mul16a
		sec
		lda	clip2D1+6, y	;Y1
		sbc	clip2D1+2, y	;Y0
		sta	<mul16a
		lda	clip2D1+7, y
		sbc	clip2D1+3, y
		sta	<mul16a+1

;(191-Y0)*(X1-X0)/(Y1-Y0)
		jsr	sdiv32

;(191-Y0)*(X1-X0)/(Y1-Y0)+X0
		clc
		lda	<mul16a
		adc	clip2D1, y	;X0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D1+1, y
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DY255Jump04
;Y0>191 Y1<=191
		lda	<mul16a
		sta	clip2D0, x	;X0
		lda	<mul16a+1
		sta	clip2D0+1, x

		lda	#191
		sta	clip2D0+2, x	;Y0
		stz	clip2D0+3, x

		inc	<clip2D0Count

		inx
		inx
		inx
		inx

		jmp	.clip2DY255Jump03

.clip2DY255Jump04:
;Y0<=191 Y1>191
		lda	clip2D1, y	;X0
		sta	clip2D0, x	;X0
		lda	clip2D1+1, y
		sta	clip2D0+1, x

		lda	clip2D1+2, y	;Y0
		sta	clip2D0+2, x	;Y0
		lda	clip2D1+3, y
		sta	clip2D0+3, x

		lda	<mul16a
		sta	clip2D0+4, x	;X1
		lda	<mul16a+1
		sta	clip2D0+5, x

		lda	#191
		sta	clip2D0+6, x	;Y1
		stz	clip2D0+7, x

		add	<clip2D0Count, #$02

		adx	#8

		jmp	.clip2DY255Jump03


;----------------------------
clip2DY0:
;
		lda	<clip2D0Count
		asl	a
		asl	a
		tax

		lda	clip2D0		;X0
		sta	clip2D0, x	;last X
		lda	clip2D0+1
		sta	clip2D0+1, x

		lda	clip2D0+2	;Y0
		sta	clip2D0+2, x	;last Y
		lda	clip2D0+3
		sta	clip2D0+3, x

		clx
		cly
		stz	<clip2D1Count

		bra	.clip2DY0Loop0

.clip2DY0Rts:
		rts

.clip2DY0Jump02:
;Y0>=0 Y1>=0
		lda	clip2D0, y	;X0
		sta	clip2D1, x	;X0
		lda	clip2D0+1, y
		sta	clip2D1+1, x

		lda	clip2D0+2, y	;Y0
		sta	clip2D1+2, x	;Y0
		lda	clip2D0+3, y
		sta	clip2D1+3, x

		inc	<clip2D1Count

		inx
		inx
		inx
		inx

.clip2DY0Jump03:
;Y0<0 Y1<0
		iny
		iny
		iny
		iny

		dec	<clip2D0Count
		beq	.clip2DY0Rts

.clip2DY0Loop0:
		stz	<clip2DFlag

		lda	clip2D0+3, y	;Y0
		bpl	.clip2DY0Jump00
		smb0	<clip2DFlag

.clip2DY0Jump00:
		lda	clip2D0+7, y	;Y1
		bpl	.clip2DY0Jump01
		smb1	<clip2DFlag

.clip2DY0Jump01:
		lda	<clip2DFlag
		beq	.clip2DY0Jump02

		cmp	#$03
		beq	.clip2DY0Jump03

;(0-Y0) to mul16a
		sec
		cla
		sbc	clip2D0+2, y	;Y0
		sta	<mul16a
		cla
		sbc	clip2D0+3, y
		sta	<mul16a+1

;(X1-X0) to mul16b
		sec
		lda	clip2D0+4, y	;X1
		sbc	clip2D0, y	;X0
		sta	<mul16b
		lda	clip2D0+5, y
		sbc	clip2D0+1, y
		sta	<mul16b+1

;(0-Y0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Y1-Y0) to mul16a
		sec
		lda	clip2D0+6, y	;Y1
		sbc	clip2D0+2, y	;Y0
		sta	<mul16a
		lda	clip2D0+7, y
		sbc	clip2D0+3, y
		sta	<mul16a+1

;(0-Y0)*(X1-X0)/(Y1-Y0)
		jsr	sdiv32

;(0-Y0)*(X1-X0)/(Y1-Y0)+X0
		clc
		lda	<mul16a
		adc	clip2D0, y	;X0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D0+1, y
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DY0Jump04
;Y0<0 Y1>=0
		lda	<mul16a
		sta	clip2D1, x	;X0
		lda	<mul16a+1
		sta	clip2D1+1, x

		stz	clip2D1+2, x	;Y0
		stz	clip2D1+3, x

		inc	<clip2D1Count

		inx
		inx
		inx
		inx

		jmp	.clip2DY0Jump03

.clip2DY0Jump04:
;Y0>=0 Y1<0
		lda	clip2D0, y	;X0
		sta	clip2D1, x	;X0
		lda	clip2D0+1, y
		sta	clip2D1+1, x

		lda	clip2D0+2, y	;Y0
		sta	clip2D1+2, x	;Y0
		lda	clip2D0+3, y
		sta	clip2D1+3, x

		lda	<mul16a
		sta	clip2D1+4, x	;X1
		lda	<mul16a+1
		sta	clip2D1+5, x

		stz	clip2D1+6, x	;Y1
		stz	clip2D1+7, x

		add	<clip2D1Count, #$02

		adx	#8

		jmp	.clip2DY0Jump03


;----------------------------
getAngle:
;
		phx
		phy

		subw	<mul16a, <angleZ1, <angleZ0
		subw	<mul16b, <angleX1, <angleX0
		jsr	atan

		tax
		eor	#$FF
		inc	a
		sta	<ansAngleY

		subw	transform2DWork0, <angleX1, <angleX0
		subw	transform2DWork0+2, <angleY1, <angleY0
		subw	transform2DWork0+4, <angleZ1, <angleZ0
		mov	vertexCount, #1
		jsr	vertexRotationY

		movw	<mul16a, transform2DWork0+4
		movw	<mul16b, transform2DWork0+2
		jsr	atan
		sta	<ansAngleX

		ply
		plx
		rts


;----------------------------
atan:
;mul16a = x(-32767_32767), mul16b = y(-32767_32767)
;A(0_255) = atan(y/x)
		phx

		lda	<mul16b+1
		pha
		bpl	.atanJump0

		sec
		lda	<mul16b
		eor	#$FF
		adc	#0
		sta	<mul16b

		lda	<mul16b+1
		eor	#$FF
		adc	#0
		sta	<mul16b+1

.atanJump0:
		lda	<mul16a+1
		pha
		bpl	.atanJump1

		sec
		lda	<mul16a
		eor	#$FF
		adc	#0
		sta	<mul16a

		lda	<mul16a+1
		eor	#$FF
		adc	#0
		sta	<mul16a+1

.atanJump1:
		jsr	_atan

		plx
		bpl	.atanJump2

		eor	#$FF
		inc	a
		eor	#$80

.atanJump2:
		plx
		bpl	.atanJump3

		eor	#$FF
		inc	a

.atanJump3:
		plx
		rts


;----------------------------
_atan:
;mul16a = x(0_32767), mul16b = y(0_32767)
;A(0_63) = atan(y/x)
		phx

		lda	<mul16a
		ora	<mul16a+1
		beq	.atanJump0

		stz	<mul16c

		lda	<mul16b
		sta	<mul16c+1

		lda	<mul16b+1
		sta	<mul16d

		stz	<mul16d+1

		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		sec
		lda	<mul16d
		sbc	<mul16a
		lda	<mul16d+1
		sbc	<mul16a+1
		bcs	.atanJump0

		jsr	udiv30

		clx
.atanLoop:
		sec
		lda	atanDataLow, x
		sbc	<div16a
		lda	atanDataHigh, x
		sbc	<div16a+1
		bcs	.atanJump1

		inx
		cpx	#64
		bne	.atanLoop

.atanJump1:
		txa
		bra	.atanEnd

.atanJump0:
		lda	#64

.atanEnd:
		plx
		rts


;----------------------------
romToVram:
;argw0: rom address, argw1: VRAM address, argw2: bytes

		movw	tiaSrc, <argw0

		st0	#$00
		movw	VDC_2, <argw1
		st0	#$02
		movw	tiaDst, #VDC_2

		movw	tiaCnt, <argw2


		jsr	tiaFunction

		rts


;----------------------------
setCgCharData:
;argw0: rom address, argw1: src CG No(0-2047), argw2: dist CG No(0-2047), argw3: character count(0-2047)
		asl	<argw1
		rol	<argw1+1
		asl	<argw1
		rol	<argw1+1
		asl	<argw1
		rol	<argw1+1
		asl	<argw1
		rol	<argw1+1
		asl	<argw1
		rol	<argw1+1

		addw	<argw0, <argw1

		asl	<argw2
		rol	<argw2+1
		asl	<argw2
		rol	<argw2+1
		asl	<argw2
		rol	<argw2+1
		asl	<argw2
		rol	<argw2+1

		movw	<argw1, <argw2

		asl	<argw3
		rol	<argw3+1
		asl	<argw3
		rol	<argw3+1
		asl	<argw3
		rol	<argw3+1
		asl	<argw3
		rol	<argw3+1
		asl	<argw3
		rol	<argw3+1

		movw	<argw2, <argw3

		jsr	romToVram

		rts


;----------------------------
setSgCharData:
;argw0: rom address, argw1: SG No(0-1022), argw2: SG No(0-1022), argw3: character count(0-511)
		ldx	<argw1
		lda	<argw1+1

		stz	<argw1
		stx	<argw1+1

		lsr	a
		ror	<argw1+1
		ror	<argw1
		lsr	a
		ror	<argw1+1
		ror	<argw1

		addw	<argw0, <argw1

		asl	<argw2
		rol	<argw2+1
		asl	<argw2
		rol	<argw2+1
		asl	<argw2
		rol	<argw2+1
		asl	<argw2
		rol	<argw2+1
		asl	<argw2
		rol	<argw2+1

		movw	<argw1, <argw2

		ldx	<argw3
		lda	<argw3+1

		stz	<argw3
		stx	<argw3+1

		lsr	a
		ror	<argw3+1
		ror	<argw3

		movw	<argw2, <argw3

		jsr	romToVram

		rts


;----------------------------
setTiaTiiFunction:
;
		mov	tiaFunction, #$E3
		mov	tiaRts, #$60
		mov	tiiFunction, #$73
		mov	tiiRts, #$60
		rts


;----------------------------
switchClearBuffer:
;switching the drawing area and clear buffer
		braDrawingNo1	.jp0

		lda	#DRAWING_NO_0_ADDR
		jmp	clearBuffer

.jp0:
		lda	#DRAWING_NO_1_ADDR
		jmp	clearBuffer


;----------------------------
clearBuffer:
;clear buffer
		st0	#$00
		st1	#$00
		sta	VDC_3

		st0	#$02

		st1	#$00

		clx
.cloop0:
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00

		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00

		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00

		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00

		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00

		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00
		st2	#$00

		inx
		bne	.cloop0

		rts


;----------------------------
setAllPolygonColor:
;set all polygon color
;argw0:color data
		movw	tiiSrc, <argw0
		movw	tiiDst, #polygonColorP0
		movw	tiiCnt, #128*4
		jsr	tiiFunction

		rts


;----------------------------
setAllPalette:
;set all palette
;argw0:palette data
		stzw	VCE_2

		movw	tiaSrc, <argw0
		movw	tiaDst, #VCE_4
		movw	tiaCnt, #$20*32
		jsr	tiaFunction

		rts


;----------------------------
initializeVdc:
;
;disable interrupts
		sei

;reset wait
		cly
.resetWaitloop0:
		clx
.resetWaitloop1:
		dex
		bne	.resetWaitloop1
		dey
		bne	.resetWaitloop0

;set vdc
.vdcdataloop:	lda	vdcData, y
		cmp	#$FF
		beq	.vdcdataend
		sta	VDC_0
		iny

		lda	vdcData, y
		sta	VDC_2
		iny

		lda	vdcData, y
		sta	VDC_3
		iny
		bra	.vdcdataloop
.vdcdataend:

;sec vce
		movw	VCE_0, #VCE0_INIT_DATA

;wait vsync
		st012	#$05, #$0008

.resetWait:
		tst	#$20, VDC_0
		beq	.resetWait

		st012	#$05, #$0000

		rts


;----------------------------
setBat:
;set BAT
;BAT0
		st012	#$00, #$0000
		st0	#$02

		movw	setBatWork, #$F200
.clearbatloop0:
		movw	VDC_2, setBatWork

		addw	setBatWork, #$0002
		cmpw	setBatWork, #$F200+$0300
		bcc	.clearbatloop0

		movw	setBatWork, #$F201
.clearbatloop1:
		movw	VDC_2, setBatWork

		addw	setBatWork, #$0002
		cmpw	setBatWork, #$F201+$0300
		bcc	.clearbatloop1

		clx
		st1	#$00
.clearbatloop2:
		st2	#$01

		inx
		bne	.clearbatloop2

;BAT1
		st012	#$00, #$0400
		st0	#$02

		movw	setBatWork, #$F500
.clearbatloop3:
		movw	VDC_2, setBatWork

		addw	setBatWork, #$0002
		cmpw	setBatWork, #$F500+$0300
		bcc	.clearbatloop3

		movw	setBatWork, #$F501
.clearbatloop4:
		movw	VDC_2, setBatWork

		addw	setBatWork, #$0002
		cmpw	setBatWork, #$F501+$0300
		bcc	.clearbatloop4

		clx
		st1	#$00
.clearbatloop5:
		st2	#$01

		inx
		bne	.clearbatloop5

		rts


;----------------------------
clearSat:
;
		jsr	clearSatBuffer

		jsr	setSatToVram

;set VRAM_SATB DMA
		st012	#$13, #$0800

		rts


;----------------------------
setInterruptDisable:
;
		sta	INTERRUPT_DISABLE_REG
		sta	<irqDisableReg
		rts


;----------------------------
irq1PolygonFunction:
;
		lda	VDC_0
		sta	<vdpStatus

		bbr5	<vdpStatus, .jp00

		bbr7	<vsyncFlag, .jp00

;set VRAM_SAT DMA
		st012	#$13, #$0800

		stz	<vsyncFlag

		lda	<drawingNo
		eor	#$01
		sta	<drawingNo

		beq	.jp01

;set scroll y
		st012	#$08, #$0000
		bra	.jp00

.jp01:
;set scroll y
		st012	#$08, #$0100

.jp00:
		rts


;----------------------------
clearSatBuffer:
;
		cla
		clc

.loop0:
		tax

		stz	satBuffer, x
		stz	satBuffer+1, x

		stz	satBuffer+256, x
		stz	satBuffer+256+1, x

		adc	#8
		bne	.loop0

		movw	satBufferAddr, #satBuffer

		rts


;----------------------------
setSatBuffer:
;
;argw0:Y, argw1:X, argw2:pattern No., argw3:attribute
		phy

		cmpw	<satBufferAddr, #satBuffer+512
		bcs	.setEnd

		cly
.loop:
		lda	argw0, y
		sta	[satBufferAddr], y

		iny
		cpy	#8
		bne	.loop

		addwb	<satBufferAddr, #8

.setEnd:
		ply
		rts


;----------------------------
setScreenCenter:
;
		stx	<centerX
		sty	<centerY
		rts


;----------------------------
onScreen:
;
		jsr	onScreenBg
		jsr	onScreenSp
		rts


;----------------------------
offScreen:
;
		jsr	offScreenBg
		jsr	offScreenSp
		rts


;----------------------------
enableIrqVdc:
;
		st0	#$05

		lda	<vdc_R05
		ora	#%00001000
		sta	<vdc_R05
		sta	VDC_2

		lda	<vdc_R05+1
		sta	VDC_3

		rts


;----------------------------
disableIrqVdc:
;
		st0	#$05

		lda	<vdc_R05
		and	#%11110111
		sta	<vdc_R05
		sta	VDC_2

		lda	<vdc_R05+1
		sta	VDC_3

		rts


;----------------------------
setInc1Vdc:
;
		st0	#$05

		lda	<vdc_R05
		sta	VDC_2

		lda	<vdc_R05+1
		and	#%11100111
		sta	<vdc_R05+1
		sta	VDC_3

		rts


;----------------------------
setInc32Vdc:
;
		st0	#$05

		lda	<vdc_R05
		sta	VDC_2

		lda	<vdc_R05+1
		and	#%11100111
		ora	#%00001000
		sta	<vdc_R05+1
		sta	VDC_3

		rts


;----------------------------
setInc64Vdc:
;
		st0	#$05

		lda	<vdc_R05
		sta	VDC_2

		lda	<vdc_R05+1
		and	#%11100111
		ora	#%00010000
		sta	<vdc_R05+1
		sta	VDC_3

		rts


;----------------------------
onScreenBg:
;
		st0	#$05

		lda	<vdc_R05
		ora	#%10000000
		sta	<vdc_R05
		sta	VDC_2

		lda	<vdc_R05+1
		sta	VDC_3

		rts


;----------------------------
onScreenSp:
;
		st0	#$05

		lda	<vdc_R05
		ora	#%01000000
		sta	<vdc_R05
		sta	VDC_2

		lda	<vdc_R05+1
		sta	VDC_3

		rts


;----------------------------
offScreenBg:
;
		st0	#$05

		lda	<vdc_R05
		and	#%01111111
		sta	<vdc_R05
		sta	VDC_2

		lda	<vdc_R05+1
		sta	VDC_3

		rts


;----------------------------
offScreenSp:
;
		st0	#$05

		lda	<vdc_R05
		and	#%10111111
		sta	<vdc_R05
		sta	VDC_2

		lda	<vdc_R05+1
		sta	VDC_3

		rts


;----------------------------
initializePolygonBuffer:
;
;initialize polyBufferAddr = polyBuffer
		movw	<polyBufferAddr, #polyBuffer

;polyBufferStart NEXT ADDR = polyBufferEnd
		movw	polyBufferStart, #polyBufferEnd

;polyBufferStart SAMPLE Z = $7FFF
		movw	polyBufferStart+2, #$7FFF

;polyBufferEnd SAMPLE Z = $0000
		stzw	polyBufferEnd+2

;polyBufferEnd COLOR = $00
		stz	polyBufferEnd+4

;polyBufferEnd COUNT = $00
		stz	polyBufferEnd+5

		rts


;----------------------------
initializeScreenVsync:
;
		stzw	<vdc_R05
		st012	#$05, #$0000

;clear vsync flag
		stz	<vsyncFlag

;set drawing No.0
		mov	<drawingNo, #DRAWING_NO_0

;set scroll x
		st012	#$07, #$0000

;set scroll y
		st012	#$08, #$0000

		rts


;----------------------------
waitScreenVsync:
;Access to VRAM should be done after this function.
.waitloop0:
		bbs7	<vsyncFlag, .waitloop0
		rts


;----------------------------
setSatToVram:
;
;set vram addr
		st012	#$00, #$0800

;transfer sat to VRAM
		st0	#$02
		tia	satBuffer, VDC_2, 512

		rts


;----------------------------
setVsyncFlag:
;
		smb7	<vsyncFlag
		rts


;----------------------------
initializeRandom:
;
		lda	#$C0
		sta	randomSeed
		sta	randomSeed+1
		rts


;----------------------------
getRandom:
;
		lda	randomSeed+1
		lsr	a
		rol	randomSeed
		bcc	.getrandomJump
		eor	#$B4
.getrandomJump:
		sta	randomSeed+1
		eor	randomSeed

		rts


;----------------------------
numToChar:
;in  A Register $0 to $F
;out A Register '0'-'9'($30-$39) 'A'-'Z'($41-$5A)
		sed
		clc
		adc	#$90
		adc	#$40
		cld

		rts


;----------------------------
setCgToSgData:
;argw0: rom address, argw1: src CG No(0-2047), argw2: dist SG No(0-1022), arg6: top or bottom left or right

;CG address
		asl	<argw1
		rol	<argw1+1
		asl	<argw1
		rol	<argw1+1
		asl	<argw1
		rol	<argw1+1
		asl	<argw1
		rol	<argw1+1
		asl	<argw1
		rol	<argw1+1

		addw	<argw0, <argw1

;SG address
		asl	<argw2
		rol	<argw2+1
		asl	<argw2
		rol	<argw2+1
		asl	<argw2
		rol	<argw2+1
		asl	<argw2
		rol	<argw2+1
		asl	<argw2
		rol	<argw2+1

;top or bottom
		bbr1	<arg6, .jp00
;bottom
		addw	<argw2, #8

.jp00:

		cly

.loop00:
		st0	#$00
		movw	VDC_2, <argw2

		st0	#$01
		movw	VDC_2, <argw2

		st0	#$02

.loop01:
;left or right
		bbs0	<arg6, .jp01

;left
		ldx	VDC_2
		lda	VDC_3

		lda	[argw0], y
		stx	VDC_2
		sta	VDC_3

		bra	.jp02

.jp01:
;right
		lda	VDC_2
		ldx	VDC_3

		lda	[argw0], y
		sta	VDC_2
		stx	VDC_3

.jp02:
		iny
		iny
		cpy	#33
		beq	.funcEnd

		cpy	#16
		bne	.jp05
		ldy	#1
		bra	.jp07

.jp05:
		cpy	#17
		bne	.jp06
		ldy	#16
		bra	.jp07

.jp06:
		cpy	#32
		bne	.loop01
		ldy	#17

.jp07:
		addw	<argw2, #16
		bra	.loop00

.funcEnd:
		rts


;----------------------------
calcBatAddressXY:
;x:X, y:Y
		stx	<tempw0
		sty	<tempw0+1

		cla
		lsr	<tempw0+1
		ror	a
		lsr	<tempw0+1
		ror	a
		lsr	<tempw0+1
		ror	a
		ora	<tempw0
		tay

		ldx	<tempw0+1

		rts


;----------------------------
setWriteVramAddress:
;x:X, y:Y
;automatically select the drawing area
		phx
		phy

		jsr	calcBatAddressXY

		st0	#$00
		sty	VDC_2

		braDrawingNo1	.jp0

		stx	VDC_3
		bra	.jp1

.jp0:
		clc
		txa
		adc	#$04

		sta	VDC_3

.jp1:
		ply
		plx
		rts


;----------------------------
setVramData:
;x:a: Data
		st0	#$02
		sta	VDC_2
		stx	VDC_3

		rts


;----------------------------
putChar:
;a:char code, x:palette
		pha
		phx

		pha

		txa
		asl	a
		asl	a
		asl	a
		asl	a
		inc	a
		tax

		pla

		jsr	setVramData

		plx
		pla
		rts


;----------------------------
putString:
;argw0:String Address, arg2:palette
		phx
		phy

		lda	<arg2
		asl	a
		asl	a
		asl	a
		asl	a
		inc	a
		tax

		cly

.loop0:
		lda	[argw0], y
		beq	.procEnd

		jsr	setVramData
		iny
		bra	.loop0

.procEnd:
		ply
		plx
		rts


;----------------------------
putHex:
;a:Data, x:palette
		pha

		pha

		lsr	a
		lsr	a
		lsr	a
		lsr	a
		jsr	numToChar

		jsr	putChar

		pla

		and	#$0F
		jsr	numToChar

		jsr	putChar

		pla
		rts


;////////////////////////////
		.bank	2
		.org	$4000

;----------------------------
calcCircle_putPoly:
;
;check top < 192
		sec
		lda	<circleCenterY
		sbc	<circleRadius
		sta	<minEdgeY
		lda	<circleCenterY+1
		sbc	<circleRadius+1

;top < 0 then
		bmi	.jp11
;0 <= top <= 255 then
		beq	.jp10
;top >= 256 then
		rts

.jp10:
		lda	<minEdgeY
		cmp	#192
		bcc	.jp11
;top >= 192 then
		rts

.jp11:
;bottom >= 0
		clc
		lda	<circleCenterY
		adc	<circleRadius
		lda	<circleCenterY+1
		adc	<circleRadius+1

		bpl	.jp12
;bottom < 0 then
		rts

.jp12:
;left < 256
		sec
		lda	<circleCenterX
		sbc	<circleRadius
		lda	<circleCenterX+1
		sbc	<circleRadius+1

		bmi	.jp13
		beq	.jp13
;left >= 256 then
		rts

.jp13:
;right >= 0
		clc
		lda	<circleCenterX
		adc	<circleRadius
		lda	<circleCenterX+1
		adc	<circleRadius+1

		bpl	.jp14
;right < 0 then
		rts

.jp14:
		mov	<minEdgeY, #$FF
		stz	<maxEdgeY

		subw	<circleD, #1, <circleRadius

		movw	<circleDH, #3

		movw	<circleDD, <circleRadius
		asl	<circleDD
		rol	<circleDD+1

		subw	<circleDD, #5, <circleDD

		movw	<circleX, <circleRadius

		stzw	<circleY

		addw	<circleXRight0, <circleCenterX, <circleX
		subw	<circleXLeft0, <circleCenterX, <circleX

		movw	<circleXRight1, <circleCenterX
		movw	<circleXLeft1, <circleCenterX

		bra	.loop0

.jp999:
		lda	<minEdgeY
		cmp	#$FF
		beq	.jp03
		jmp	putPolyLine
.jp03:
		rts

.loop0:
		sec
		lda	<circleX
		sbc	<circleY
		lda	<circleX+1
		sbc	<circleY+1

		bmi	.jp999

		bbr7	<circleD+1, .jp01

		addw	<circleD, <circleDH

		addwb	<circleDH, #2

		addwb	<circleDD, #2

		bra	.jp02

.jp01:
		addw	<circleD, <circleDD

		addwb	<circleDH, #2

		addwb	<circleDD, #4

		decw	<circleX

		decw	<circleXRight0
		incw	<circleXLeft0

.jp02:
		lda	<circleXLeft0
		sta	<circleXLeftWork

		lda	<circleXLeft0+1
		beq	.jp20
		bpl	.jp04

		stz	<circleXLeftWork

.jp20:
		lda	<circleXRight0
		sta	<circleXRightWork

		lda	<circleXRight0+1
		bmi	.jp04
		beq	.jp21

		mov	<circleXRightWork, #$FF

.jp21:
		clc
		lda	<circleCenterY
		adc	<circleY
		tay
		lda	<circleCenterY+1
		adc	<circleY+1

		bne	.jp102

		cpy	#192
		bcs	.jp102

		cpy	<minEdgeY
		bcs	.jp100

		sty	<minEdgeY

.jp100:
		cpy	<maxEdgeY
		bcc	.jp101

		sty	<maxEdgeY

.jp101:
		lda	<circleXLeftWork
		sta	edgeLeft, y

		lda	<circleXRightWork
		sta	edgeRight, y

.jp102:
		sec
		lda	<circleCenterY
		sbc	<circleY
		tay
		lda	<circleCenterY+1
		sbc	<circleY+1

		bne	.jp04

		cpy	#192
		bcs	.jp04

		cpy	<minEdgeY
		bcs	.jp200

		sty	<minEdgeY

.jp200:
		cpy	<maxEdgeY
		bcc	.jp201

		sty	<maxEdgeY

.jp201:
		lda	<circleXLeftWork
		sta	edgeLeft, y

		lda	<circleXRightWork
		sta	edgeRight, y

.jp04:
		lda	<circleXLeft1
		sta	<circleXLeftWork

		lda	<circleXLeft1+1
		beq	.jp22
		bpl	.jp05

		stz	<circleXLeftWork

.jp22:
		lda	<circleXRight1
		sta	<circleXRightWork

		lda	<circleXRight1+1
		bmi	.jp05
		beq	.jp23

		mov	<circleXRightWork, #$FF

.jp23:
		clc
		lda	<circleCenterY
		adc	<circleX
		tay
		lda	<circleCenterY+1
		adc	<circleX+1

		bne	.jp302

		cpy	#192
		bcs	.jp302

		cpy	<minEdgeY
		bcs	.jp300

		sty	<minEdgeY

.jp300:
		cpy	<maxEdgeY
		bcc	.jp301

		sty	<maxEdgeY

.jp301:
		lda	<circleXLeftWork
		sta	edgeLeft, y

		lda	<circleXRightWork
		sta	edgeRight, y

.jp302:
		sec
		lda	<circleCenterY
		sbc	<circleX
		tay
		lda	<circleCenterY+1
		sbc	<circleX+1

		bne	.jp05

		cpy	#192
		bcs	.jp05

		cpy	<minEdgeY
		bcs	.jp400

		sty	<minEdgeY

.jp400:
		cpy	<maxEdgeY
		bcc	.jp401

		sty	<maxEdgeY

.jp401:
		lda	<circleXLeftWork
		sta	edgeLeft, y

		lda	<circleXRightWork
		sta	edgeRight, y

.jp05:
		incw	<circleY

		incw	<circleXRight1
		decw	<circleXLeft1

		jmp	.loop0


;----------------------------
calcEdge:
;
		lda	<edgeY1
		cmp	<edgeY0
		jcc	.jpRightEdge

;calculation left edge
;calculation edge Y
		sec
		lda	<edgeY1
		sbc	<edgeY0
		sta	<edgeSlopeY
		bcs	.edgeJump7L

		eor	#$FF
		inc	a
		sta	<edgeSlopeY

;edgeY0 > edgeY1 exchange X0<->X1 Y0<->Y1
		lda	<edgeX0
		ldx	<edgeX1
		sta	<edgeX1
		stx	<edgeX0

		lda	<edgeY0
		ldx	<edgeY1
		sta	<edgeY1
		stx	<edgeY0

.edgeJump7L:
;calculation edge X
		sec
		lda	<edgeX1
		sbc	<edgeX0
		beq	.edgeJump1L

		sta	<edgeSlopeX
		stz	<edgeSigneX
		bcs	.edgeJump3L

		eor	#$FF
		inc	a
		sta	<edgeSlopeX

		mov	<edgeSigneX, #$FF

		bra	.edgeJump3L

.edgeJump1L:
;edgeX0 = edgeX1
		lda	#EDGE_FUNC_L_2_3_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

		jmp	calcEdgeLEX

.edgeJump3L:
;edgeSlope compare
		lda	<edgeSlopeY
		cmp	<edgeSlopeX
		bcs	.edgeJump4L

;edgeSlopeX > edgeSlopeY
;check edgeSigneX
		bbs7	<edgeSigneX, .edgeJump10L


;edgeSigneX plus
		lda	#EDGE_FUNC_L_0_1_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

		jmp	calcEdgeL0

;edgeSigneX minus
.edgeJump10L:
		lda	#EDGE_FUNC_L_0_1_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

		jmp	calcEdgeL1

.edgeJump4L:
;edgeSlopeY >= edgeSlopeX
;check edgeSigneX
		bbs7	<edgeSigneX, .edgeYLoop8L

;edgeSigneX plus
		lda	#EDGE_FUNC_L_2_3_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

		jmp	calcEdgeL2

;edgeSigneX minus
.edgeYLoop8L:
		lda	#EDGE_FUNC_L_2_3_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

		jmp	calcEdgeL3

.jpRightEdge:
;calculation right edge
;calculation edge Y
		sec
		lda	<edgeY1
		sbc	<edgeY0
		sta	<edgeSlopeY
		bcs	.edgeJump7R

		eor	#$FF
		inc	a
		sta	<edgeSlopeY

;edgeY0 > edgeY1 exchange X0<->X1 Y0<->Y1
		lda	<edgeX0
		ldx	<edgeX1
		sta	<edgeX1
		stx	<edgeX0

		lda	<edgeY0
		ldx	<edgeY1
		sta	<edgeY1
		stx	<edgeY0

.edgeJump7R:
;calculation edge X
		sec
		lda	<edgeX1
		sbc	<edgeX0
		beq	.edgeJump1R

		sta	<edgeSlopeX
		stz	<edgeSigneX
		bcs	.edgeJump3R

		eor	#$FF
		inc	a
		sta	<edgeSlopeX

		mov	<edgeSigneX, #$FF

		bra	.edgeJump3R

.edgeJump1R:
;edgeX0 = edgeX1
		lda	#EDGE_FUNC_R_2_3_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

		jmp	calcEdgeREX

.edgeJump3R:
;edgeSlope compare
		lda	<edgeSlopeY
		cmp	<edgeSlopeX
		bcs	.edgeJump4R

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeJump10R

;edgeSigneX plus
		lda	#EDGE_FUNC_R_0_1_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

		jmp	calcEdgeR0

;edgeSigneX minus
.edgeJump10R:
		lda	#EDGE_FUNC_R_0_1_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

		jmp	calcEdgeR1

.edgeJump4R:
;edgeSlopeY >= edgeSlopeX
;check edgeSigneX
		bbs7	<edgeSigneX, .edgeYLoop8R

;edgeSigneX plus
		lda	#EDGE_FUNC_R_2_3_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

		jmp	calcEdgeR2

;edgeSigneX minus
.edgeYLoop8R:
		lda	#EDGE_FUNC_R_2_3_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

		jmp	calcEdgeR3


;----------------------------
putPolyLine:
;put poly line
		inc	<maxEdgeY

		mov	<polyLineColorDataWork0, polyLineColorWork_H_P0
		mov	<polyLineColorDataWork1, polyLineColorWork_H_P1
		mov	<polyLineColorDataWork2, polyLineColorWork_H_P2
		mov	<polyLineColorDataWork3, polyLineColorWork_H_P3

		lda	<minEdgeY
		inc	a
		and	#$FE
		tay

		braDrawingNo1	.jp4
		jsr	putPolyLineProc
		bra	.jp5
.jp4:
		jsr	putPolyLineProc2

.jp5:
		bbs6	<polyAttribute, .jp3

		mov	<polyLineColorDataWork0, polyLineColorWork_L_P0
		mov	<polyLineColorDataWork1, polyLineColorWork_L_P1
		mov	<polyLineColorDataWork2, polyLineColorWork_L_P2
		mov	<polyLineColorDataWork3, polyLineColorWork_L_P3

		lda	<minEdgeY
		and	#$FE
		inc	a
		tay

		braDrawingNo1	.jp6
		jsr	putPolyLineProc
		bra	.jp3
.jp6:
		jsr	putPolyLineProc2

.jp3:
		rts


;----------------------------
putPolyLineProc:
;put poly line
		bra	.loopStart

.jpRts:
		rts

.jpSwap:
;swap left and right
		beq	.jp0
		tax
		lda	edgeRight, y
		sta	edgeLeft, y
		sax
		sta	edgeRight, y
		sax
		bra	.jp0

.jpCount0:
		jmp	.jpCount0Pg

;loop
.loop0:
		iny
		iny

.loopStart:
		cpy	<maxEdgeY
		bcs	.jpRts

.putPolyProc:
		lda	edgeLeft, y
		cmp	edgeRight, y
		bcs	.jpSwap

;calation left counts
.jp0:
		lsr	a
		lsr	a
		lsr	a
		sta	<polyLineCount

;calation left vram address
		tax

		lda	polyLineAddrConvXHigh, x
		ora	polyLineAddrConvYHigh, y
		sta	<polyLineLeftAddr+1

		lda	polyLineAddrConvXLow, x
		ora	polyLineAddrConvYLow, y
		sta	<polyLineLeftAddr

;set left address
		ldx	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC_2
		stx	VDC_3

		st0	#$01
		sta	VDC_2
		stx	VDC_3

		st0	#$02

;put left data
		lda	edgeLeft, y
		tax

		lda	polyLineLeftDatas, x
		sta	<polyLineLeftData
		eor	#$FF
		sta	<polyLineLeftMask

;calation counts
		lda	edgeRight, y
		lsr	a
		lsr	a
		lsr	a
		tax
		sec
		sbc	<polyLineCount
		beq	.jpCount0

		sta	<polyLineCount

;right address
		lda	polyLineAddrConvXLow, x
		ora	polyLineAddrConvYLow, y
		sta	<polyLineRightAddr

		lda	polyLineAddrConvXHigh, x
		ora	polyLineAddrConvYHigh, y
		sta	<polyLineRightAddr+1

;put right data
		lda	edgeRight, y
		tax

		lda	polyLineRightDatas, x
		sta	<polyLineRightData
		eor	#$FF
		sta	<polyLineRightMask

;put line
;center jump index
		lda	<polyLineCount
		asl	a
		tax

		phy

;left CH0 CH1
		lda	VDC_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork1
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC_3

;center CH0 CH1
		lda	<polyLineColorDataWork0
		sta	VDC_2

		lda	<polyLineColorDataWork1

		jmp	[.centerVDC_01Addr, x]

.centerVDC_01:
		sta	VDC_3	;30
		sta	VDC_3	;29
		sta	VDC_3	;28
		sta	VDC_3	;27
		sta	VDC_3	;26
		sta	VDC_3	;25
		sta	VDC_3	;24
		sta	VDC_3	;23
		sta	VDC_3	;22
		sta	VDC_3	;21

		sta	VDC_3	;20
		sta	VDC_3	;19
		sta	VDC_3	;18
		sta	VDC_3	;17
		sta	VDC_3	;16
		sta	VDC_3	;15
		sta	VDC_3	;14
		sta	VDC_3	;13
		sta	VDC_3	;12
		sta	VDC_3	;11

		sta	VDC_3	;10
		sta	VDC_3	;9
		sta	VDC_3	;8
		sta	VDC_3	;7
		sta	VDC_3	;6
		sta	VDC_3	;5
		sta	VDC_3	;4
		sta	VDC_3	;3
		sta	VDC_3	;2
		sta	VDC_3	;1

;right CH0 CH1
		lda	<polyLineRightAddr
		ldy	<polyLineRightAddr+1

		st0	#$01
		sta	VDC_2
		sty	VDC_3

		st0	#$02

		lda	VDC_2
		and	<polyLineRightMask
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineRightMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineRightData
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork1
		and	<polyLineRightData
		ora	<polyLineDataHigh
		sta	VDC_3

;left CH2 CH3
		lda	<polyLineLeftAddr
		ora	#$08
		ldy	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC_2
		sty	VDC_3

		st0	#$01
		sta	VDC_2
		sty	VDC_3

		st0	#$02

		lda	VDC_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork3
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC_3

;center CH2 CH3
		lda	<polyLineColorDataWork2
		sta	VDC_2

		lda	<polyLineColorDataWork3

		jmp	[.centerVDC_02Addr, x]

.centerVDC_02:
		sta	VDC_3	;30
		sta	VDC_3	;29
		sta	VDC_3	;28
		sta	VDC_3	;27
		sta	VDC_3	;26
		sta	VDC_3	;25
		sta	VDC_3	;24
		sta	VDC_3	;23
		sta	VDC_3	;22
		sta	VDC_3	;21

		sta	VDC_3	;20
		sta	VDC_3	;19
		sta	VDC_3	;18
		sta	VDC_3	;17
		sta	VDC_3	;16
		sta	VDC_3	;15
		sta	VDC_3	;14
		sta	VDC_3	;13
		sta	VDC_3	;12
		sta	VDC_3	;11

		sta	VDC_3	;10
		sta	VDC_3	;9
		sta	VDC_3	;8
		sta	VDC_3	;7
		sta	VDC_3	;6
		sta	VDC_3	;5
		sta	VDC_3	;4
		sta	VDC_3	;3
		sta	VDC_3	;2
		sta	VDC_3	;1

;right CH2 CH3
		lda	<polyLineRightAddr
		ora	#$08
		ldy	<polyLineRightAddr+1

		st0	#$01
		sta	VDC_2
		sty	VDC_3

		st0	#$02

		lda	VDC_2
		and	<polyLineRightMask
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineRightMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineRightData
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork3
		and	<polyLineRightData
		ora	<polyLineDataHigh
		sta	VDC_3

		ply

;loop jump
		jmp	.loop0

.jpCount0Pg:
;count 0 then
;put line same address
		lda	edgeLeft, y
		pha

		lda	edgeRight, y
		tax
		lda	polyLineRightDatas, x
		plx
		and	polyLineLeftDatas, x
		sta	<polyLineMask0
		eor	#$FF
		sta	<polyLineMask1

;left CH0 CH1
		lda	VDC_2
		and	<polyLineMask1
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineMask1
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineMask0
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork1
		and	<polyLineMask0
		ora	<polyLineDataHigh
		sta	VDC_3

;left CH2 CH3
		lda	<polyLineLeftAddr
		ora	#$08
		ldx	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC_2
		stx	VDC_3

		st0	#$01
		sta	VDC_2
		stx	VDC_3

		st0	#$02

		lda	VDC_2
		and	<polyLineMask1
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineMask1
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineMask0
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork3
		and	<polyLineMask0
		ora	<polyLineDataHigh
		sta	VDC_3

;loop jump
		jmp	.loop0


;--------
.centerVDC_01Addr:
		dw	.centerVDC_01 +3*30	;-1
		dw	.centerVDC_01 +3*30	;0

		dw	.centerVDC_01 +3*29	;1
		dw	.centerVDC_01 +3*28	;2
		dw	.centerVDC_01 +3*27	;3
		dw	.centerVDC_01 +3*26	;4
		dw	.centerVDC_01 +3*25	;5
		dw	.centerVDC_01 +3*24	;6
		dw	.centerVDC_01 +3*23	;7
		dw	.centerVDC_01 +3*22	;8
		dw	.centerVDC_01 +3*21	;9

		dw	.centerVDC_01 +3*20	;10
		dw	.centerVDC_01 +3*19	;11
		dw	.centerVDC_01 +3*18	;12
		dw	.centerVDC_01 +3*17	;13
		dw	.centerVDC_01 +3*16	;14
		dw	.centerVDC_01 +3*15	;15
		dw	.centerVDC_01 +3*14	;16
		dw	.centerVDC_01 +3*13	;17
		dw	.centerVDC_01 +3*12	;18
		dw	.centerVDC_01 +3*11	;19

		dw	.centerVDC_01 +3*10	;20
		dw	.centerVDC_01 +3*9	;21
		dw	.centerVDC_01 +3*8	;22
		dw	.centerVDC_01 +3*7	;23
		dw	.centerVDC_01 +3*6	;24
		dw	.centerVDC_01 +3*5	;25
		dw	.centerVDC_01 +3*4	;26
		dw	.centerVDC_01 +3*3	;27
		dw	.centerVDC_01 +3*2	;28
		dw	.centerVDC_01 +3*1	;29

		dw	.centerVDC_01 +3*0	;30

;--------
.centerVDC_02Addr:
		dw	.centerVDC_02 +3*30	;-1
		dw	.centerVDC_02 +3*30	;0

		dw	.centerVDC_02 +3*29	;1
		dw	.centerVDC_02 +3*28	;2
		dw	.centerVDC_02 +3*27	;3
		dw	.centerVDC_02 +3*26	;4
		dw	.centerVDC_02 +3*25	;5
		dw	.centerVDC_02 +3*24	;6
		dw	.centerVDC_02 +3*23	;7
		dw	.centerVDC_02 +3*22	;8
		dw	.centerVDC_02 +3*21	;9

		dw	.centerVDC_02 +3*20	;10
		dw	.centerVDC_02 +3*19	;11
		dw	.centerVDC_02 +3*18	;12
		dw	.centerVDC_02 +3*17	;13
		dw	.centerVDC_02 +3*16	;14
		dw	.centerVDC_02 +3*15	;15
		dw	.centerVDC_02 +3*14	;16
		dw	.centerVDC_02 +3*13	;17
		dw	.centerVDC_02 +3*12	;18
		dw	.centerVDC_02 +3*11	;19

		dw	.centerVDC_02 +3*10	;20
		dw	.centerVDC_02 +3*9	;21
		dw	.centerVDC_02 +3*8	;22
		dw	.centerVDC_02 +3*7	;23
		dw	.centerVDC_02 +3*6	;24
		dw	.centerVDC_02 +3*5	;25
		dw	.centerVDC_02 +3*4	;26
		dw	.centerVDC_02 +3*3	;27
		dw	.centerVDC_02 +3*2	;28
		dw	.centerVDC_02 +3*1	;29

		dw	.centerVDC_02 +3*0	;30


;----------------------------
putPolyLineProc2:
;put poly line
		bra	.loopStart

.jpRts:
		rts

.jpSwap:
;swap left and right
		beq	.jp0
		tax
		lda	edgeRight, y
		sta	edgeLeft, y
		sax
		sta	edgeRight, y
		sax
		bra	.jp0

.jpCount0:
		jmp	.jpCount0Pg

;loop
.loop0:
		iny
		iny

.loopStart:
		cpy	<maxEdgeY
		bcs	.jpRts

.putPolyProc:
		lda	edgeLeft, y
		cmp	edgeRight, y
		bcs	.jpSwap

;calation left counts
.jp0:
		lsr	a
		lsr	a
		lsr	a
		sta	<polyLineCount

;calation left vram address
		tax

		lda	polyLineAddrConvXHigh, x
		ora	polyLineAddrConvYHigh2, y
		sta	<polyLineLeftAddr+1

		lda	polyLineAddrConvXLow, x
		ora	polyLineAddrConvYLow, y
		sta	<polyLineLeftAddr

;set left address
		ldx	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC_2
		stx	VDC_3

		st0	#$01
		sta	VDC_2
		stx	VDC_3

		st0	#$02

;put left data
		lda	edgeLeft, y
		tax

		lda	polyLineLeftDatas, x
		sta	<polyLineLeftData
		eor	#$FF
		sta	<polyLineLeftMask

;calation counts
		lda	edgeRight, y
		lsr	a
		lsr	a
		lsr	a
		tax
		sec
		sbc	<polyLineCount
		beq	.jpCount0

		sta	<polyLineCount

;right address
		lda	polyLineAddrConvXLow, x
		ora	polyLineAddrConvYLow, y
		sta	<polyLineRightAddr

		lda	polyLineAddrConvXHigh, x
		ora	polyLineAddrConvYHigh2, y
		sta	<polyLineRightAddr+1

;put right data
		lda	edgeRight, y
		tax

		lda	polyLineRightDatas, x
		sta	<polyLineRightData
		eor	#$FF
		sta	<polyLineRightMask

;put line
;center jump index
		lda	<polyLineCount
		asl	a
		tax

		phy

;left CH0 CH1
		lda	VDC_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork1
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC_3

;center CH0 CH1
		lda	<polyLineColorDataWork0
		sta	VDC_2

		lda	<polyLineColorDataWork1

		jmp	[.centerVDC_01Addr, x]

.centerVDC_01:
		sta	VDC_3	;30
		sta	VDC_3	;29
		sta	VDC_3	;28
		sta	VDC_3	;27
		sta	VDC_3	;26
		sta	VDC_3	;25
		sta	VDC_3	;24
		sta	VDC_3	;23
		sta	VDC_3	;22
		sta	VDC_3	;21

		sta	VDC_3	;20
		sta	VDC_3	;19
		sta	VDC_3	;18
		sta	VDC_3	;17
		sta	VDC_3	;16
		sta	VDC_3	;15
		sta	VDC_3	;14
		sta	VDC_3	;13
		sta	VDC_3	;12
		sta	VDC_3	;11

		sta	VDC_3	;10
		sta	VDC_3	;9
		sta	VDC_3	;8
		sta	VDC_3	;7
		sta	VDC_3	;6
		sta	VDC_3	;5
		sta	VDC_3	;4
		sta	VDC_3	;3
		sta	VDC_3	;2
		sta	VDC_3	;1

;right CH0 CH1
		lda	<polyLineRightAddr
		ldy	<polyLineRightAddr+1

		st0	#$01
		sta	VDC_2
		sty	VDC_3

		st0	#$02

		lda	VDC_2
		and	<polyLineRightMask
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineRightMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineRightData
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork1
		and	<polyLineRightData
		ora	<polyLineDataHigh
		sta	VDC_3

;left CH2 CH3
		lda	<polyLineLeftAddr
		ora	#$08
		ldy	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC_2
		sty	VDC_3

		st0	#$01
		sta	VDC_2
		sty	VDC_3

		st0	#$02

		lda	VDC_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork3
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC_3

;center CH2 CH3
		lda	<polyLineColorDataWork2
		sta	VDC_2

		lda	<polyLineColorDataWork3

		jmp	[.centerVDC_02Addr, x]

.centerVDC_02:
		sta	VDC_3	;30
		sta	VDC_3	;29
		sta	VDC_3	;28
		sta	VDC_3	;27
		sta	VDC_3	;26
		sta	VDC_3	;25
		sta	VDC_3	;24
		sta	VDC_3	;23
		sta	VDC_3	;22
		sta	VDC_3	;21

		sta	VDC_3	;20
		sta	VDC_3	;19
		sta	VDC_3	;18
		sta	VDC_3	;17
		sta	VDC_3	;16
		sta	VDC_3	;15
		sta	VDC_3	;14
		sta	VDC_3	;13
		sta	VDC_3	;12
		sta	VDC_3	;11

		sta	VDC_3	;10
		sta	VDC_3	;9
		sta	VDC_3	;8
		sta	VDC_3	;7
		sta	VDC_3	;6
		sta	VDC_3	;5
		sta	VDC_3	;4
		sta	VDC_3	;3
		sta	VDC_3	;2
		sta	VDC_3	;1

;right CH2 CH3
		lda	<polyLineRightAddr
		ora	#$08
		ldy	<polyLineRightAddr+1

		st0	#$01
		sta	VDC_2
		sty	VDC_3

		st0	#$02

		lda	VDC_2
		and	<polyLineRightMask
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineRightMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineRightData
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork3
		and	<polyLineRightData
		ora	<polyLineDataHigh
		sta	VDC_3

		ply

;loop jump
		jmp	.loop0


.jpCount0Pg:
;count 0 then
;put line same address
		lda	edgeLeft, y
		pha

		lda	edgeRight, y
		tax
		lda	polyLineRightDatas, x
		plx
		and	polyLineLeftDatas, x
		sta	<polyLineMask0
		eor	#$FF
		sta	<polyLineMask1

;left CH0 CH1
		lda	VDC_2
		and	<polyLineMask1
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineMask1
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineMask0
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork1
		and	<polyLineMask0
		ora	<polyLineDataHigh
		sta	VDC_3

;left CH2 CH3
		lda	<polyLineLeftAddr
		ora	#$08
		ldx	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC_2
		stx	VDC_3

		st0	#$01
		sta	VDC_2
		stx	VDC_3

		st0	#$02

		lda	VDC_2
		and	<polyLineMask1
		sta	<polyLineDataLow

		lda	VDC_3
		and	<polyLineMask1
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineMask0
		ora	<polyLineDataLow
		sta	VDC_2

		lda	<polyLineColorDataWork3
		and	<polyLineMask0
		ora	<polyLineDataHigh
		sta	VDC_3

;loop jump
		jmp	.loop0


;--------
.centerVDC_01Addr:
		dw	.centerVDC_01 +3*30	;-1
		dw	.centerVDC_01 +3*30	;0

		dw	.centerVDC_01 +3*29	;1
		dw	.centerVDC_01 +3*28	;2
		dw	.centerVDC_01 +3*27	;3
		dw	.centerVDC_01 +3*26	;4
		dw	.centerVDC_01 +3*25	;5
		dw	.centerVDC_01 +3*24	;6
		dw	.centerVDC_01 +3*23	;7
		dw	.centerVDC_01 +3*22	;8
		dw	.centerVDC_01 +3*21	;9

		dw	.centerVDC_01 +3*20	;10
		dw	.centerVDC_01 +3*19	;11
		dw	.centerVDC_01 +3*18	;12
		dw	.centerVDC_01 +3*17	;13
		dw	.centerVDC_01 +3*16	;14
		dw	.centerVDC_01 +3*15	;15
		dw	.centerVDC_01 +3*14	;16
		dw	.centerVDC_01 +3*13	;17
		dw	.centerVDC_01 +3*12	;18
		dw	.centerVDC_01 +3*11	;19

		dw	.centerVDC_01 +3*10	;20
		dw	.centerVDC_01 +3*9	;21
		dw	.centerVDC_01 +3*8	;22
		dw	.centerVDC_01 +3*7	;23
		dw	.centerVDC_01 +3*6	;24
		dw	.centerVDC_01 +3*5	;25
		dw	.centerVDC_01 +3*4	;26
		dw	.centerVDC_01 +3*3	;27
		dw	.centerVDC_01 +3*2	;28
		dw	.centerVDC_01 +3*1	;29

		dw	.centerVDC_01 +3*0	;30

;--------
.centerVDC_02Addr:
		dw	.centerVDC_02 +3*30	;-1
		dw	.centerVDC_02 +3*30	;0

		dw	.centerVDC_02 +3*29	;1
		dw	.centerVDC_02 +3*28	;2
		dw	.centerVDC_02 +3*27	;3
		dw	.centerVDC_02 +3*26	;4
		dw	.centerVDC_02 +3*25	;5
		dw	.centerVDC_02 +3*24	;6
		dw	.centerVDC_02 +3*23	;7
		dw	.centerVDC_02 +3*22	;8
		dw	.centerVDC_02 +3*21	;9

		dw	.centerVDC_02 +3*20	;10
		dw	.centerVDC_02 +3*19	;11
		dw	.centerVDC_02 +3*18	;12
		dw	.centerVDC_02 +3*17	;13
		dw	.centerVDC_02 +3*16	;14
		dw	.centerVDC_02 +3*15	;15
		dw	.centerVDC_02 +3*14	;16
		dw	.centerVDC_02 +3*13	;17
		dw	.centerVDC_02 +3*12	;18
		dw	.centerVDC_02 +3*11	;19

		dw	.centerVDC_02 +3*10	;20
		dw	.centerVDC_02 +3*9	;21
		dw	.centerVDC_02 +3*8	;22
		dw	.centerVDC_02 +3*7	;23
		dw	.centerVDC_02 +3*6	;24
		dw	.centerVDC_02 +3*5	;25
		dw	.centerVDC_02 +3*4	;26
		dw	.centerVDC_02 +3*3	;27
		dw	.centerVDC_02 +3*2	;28
		dw	.centerVDC_02 +3*1	;29

		dw	.centerVDC_02 +3*0	;30


;----------------------------
polyLineAddrConvYHigh:
		.db	$20, $20, $20, $20, $20, $20, $20, $20, $24, $24, $24, $24, $24, $24, $24, $24,\
			$28, $28, $28, $28, $28, $28, $28, $28, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C,\
			$30, $30, $30, $30, $30, $30, $30, $30, $34, $34, $34, $34, $34, $34, $34, $34,\
			$38, $38, $38, $38, $38, $38, $38, $38, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C,\
			$40, $40, $40, $40, $40, $40, $40, $40, $44, $44, $44, $44, $44, $44, $44, $44,\
			$48, $48, $48, $48, $48, $48, $48, $48, $4C, $4C, $4C, $4C, $4C, $4C, $4C, $4C,\
			$20, $20, $20, $20, $20, $20, $20, $20, $24, $24, $24, $24, $24, $24, $24, $24,\
			$28, $28, $28, $28, $28, $28, $28, $28, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C,\
			$30, $30, $30, $30, $30, $30, $30, $30, $34, $34, $34, $34, $34, $34, $34, $34,\
			$38, $38, $38, $38, $38, $38, $38, $38, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C,\
			$40, $40, $40, $40, $40, $40, $40, $40, $44, $44, $44, $44, $44, $44, $44, $44,\
			$48, $48, $48, $48, $48, $48, $48, $48, $4C, $4C, $4C, $4C, $4C, $4C, $4C, $4C


;----------------------------
polyLineAddrConvYHigh2:
		.db	$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C,\
			$60, $60, $60, $60, $60, $60, $60, $60, $64, $64, $64, $64, $64, $64, $64, $64,\
			$68, $68, $68, $68, $68, $68, $68, $68, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C,\
			$70, $70, $70, $70, $70, $70, $70, $70, $74, $74, $74, $74, $74, $74, $74, $74,\
			$78, $78, $78, $78, $78, $78, $78, $78, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C,\
			$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C,\
			$60, $60, $60, $60, $60, $60, $60, $60, $64, $64, $64, $64, $64, $64, $64, $64,\
			$68, $68, $68, $68, $68, $68, $68, $68, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C,\
			$70, $70, $70, $70, $70, $70, $70, $70, $74, $74, $74, $74, $74, $74, $74, $74,\
			$78, $78, $78, $78, $78, $78, $78, $78, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C


;----------------------------
polyLineAddrConvYLow:
		.db	$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17


;----------------------------
polyLineAddrConvXHigh:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01,\
			$02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03, $03


;----------------------------
polyLineAddrConvXLow:
		.db	$00, $20, $40, $60, $80, $A0, $C0, $E0, $00, $20, $40, $60, $80, $A0, $C0, $E0,\
			$00, $20, $40, $60, $80, $A0, $C0, $E0, $00, $20, $40, $60, $80, $A0, $C0, $E0


;----------------------------
polyLineLeftDatas:
		.db	$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01


;----------------------------
polyLineRightDatas:
		.db	$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF


;////////////////////////////
		.bank	3
		INCBIN	"mul.dat"		;  128K  3~18 $03~$12
		INCBIN	"div.dat"		;   96K 19~30 $13~$1E


;////////////////////////////
		.bank	31
		INCLUDE	"poly_edgeL0_1.asm"	;    8K


;////////////////////////////
		.bank	32
		INCLUDE	"poly_edgeL2_3.asm"	;    8K


;////////////////////////////
		.bank	33
		INCLUDE	"poly_edgeR0_1.asm"	;    8K


;////////////////////////////
		.bank	34
		INCLUDE	"poly_edgeR2_3.asm"	;    8K
