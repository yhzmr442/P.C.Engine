;poly_proc.asm
;//////////////////////////////////
;----------------------------
;polygon display area is 256 * 192 or 256 * 144 pixels.

;----------------------------
;palette number used by the system is 15.

;----------------------------
;angles range from 0 to 255.

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
;--------------- Z:+128 or +192 or +220
;\      |      /
; \     |     /
;  \    |    /
;   \   |   /
;    \  |  /
;     \ | /
;      \|/
;    viewpoint   Z:0

;----------------------------
;memory map
;CPU
;$0000-$1FFF	I/O
;$2000-$3FFF	RAM
;$4000-$5FFF	user code/data, mul datas, transform div datas, atan datas, polygon functions : switch when using
;$6000-$7FFF	user code/data, mul datas, edge functions : switch when using
;$8000-$9FFF	user code/data
;$A000-$BFFF	user code/data
;$C000-$DFFF	polygon functions
;$E000-$FFFF	user code/data, reset nmi irq1 irq2 timer functions, polygon function datas

;VRAM
;$0000-$03FF	BAT0	1KW
;$0400-$07FF	BAT1	1KW
;$0800-$08FF	SAT0	256W
;$0900-$09FF	SAT1	256W
;$0A00-$0FFF	CG, SG	1536W
;$1000-$1FFF	CG, SG	4KW
;$2000-$4FFF	BUFFER0	12KW
;$5000-$7FFF	BUFFER1	12KW

;ROM BANK
;BANK 0		USER CODE/DATA, RESET, NMI, IRQ1, IRQ2, TIMER, POLYGON FUNCTION DATAS
;BANK 1		POLYGON FUNCTIONS
;BANK 2		POLYGON SUB FUNCTIONS, ATAN DATAS
;BANK 3- 6	EDGE CALCULATION FUNCTIONS
;BANK 7		BUFFER CLEAR_FUNCTION
;BANK 8-23	MULTIPLICATION DATAS
;BANK24-31	DIVISION DATAS

;----------------------------
;define

;SAMPLE_Z_AVG		default
;SAMPLE_Z_MAX_ONLY

;DISPLAY_BOTTOM_192	default
;DISPLAY_BOTTOM_144

;SCREEN_Z128		default
;SCREEN_Z192
;SCREEN_Z220

;VCE_5M			default
;VCE_7M
;VCE_10M

;SCREEN_256_240_A
;SCREEN_256_240_B
;SCREEN_256_240_7MHZ
;SCREEN_256_192
;SCREEN_256_224


;//////////////////////////////////
		.bank	POLYGON_FUNC_BANK
		.org	$C000

;===============================================================================
; initializePolygonFunction
;-------------------------------------------------------------------------------
; Description:
;   Initializes the polygon rendering library.
;
; Inputs:
;   None
;
; Outputs:
;   None
;
; Modifies:
;   A, X
;===============================================================================
initializePolygonFunction:
;set tia tii function
		jsr	setTiaTiiFunction

;initialize umul16
		jsr	initializeUmul16

;initialize VDC
		jsr	initializeVdc

;initialize PAD
		jsr	initializePad

;initialize PSG
		jsr	initializePsg

;clear BAT
		cla
		ldx	#$01
		jsr	clearBat

;set BAT
		jsr	setBat

;clear Sat
		jsr	clearSat

;clear buffer:
		lda	#DRAWING_NO_0_ADDR
		jsr	clearBuffer

		lda	#DRAWING_NO_1_ADDR
		jsr	clearBuffer

;set main volume
		lda	#$EE
		jsr	setMainVolume

;initialize random
		jsr	initializeRandom

;initialize systen config
		lda	#ATTR_SYSTEM_Z_MAX
		jsr	setSystemConfig

;disable interrupt IRQ2
		lda	#%00000001
		jsr	setInterruptDisable

		rts


;===============================================================================
; setMainVolume
;-------------------------------------------------------------------------------
; Description:
;   Sets the main volume.
;
; Inputs:
;   A : Volume
;
; Outputs:
;   None
;
; Modifies:
;   None
;===============================================================================
setMainVolume:
		sta	PSG_1
		rts


;===============================================================================
; initializePsg:
;-------------------------------------------------------------------------------
; Description:
;   Initializes PSG.
;
; Inputs:
;   None
;
; Outputs:
;   None
;
; Modifies:
;   A
;===============================================================================
initializePsg:
		phx
		phy

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

		ply
		plx
		rts


;===============================================================================
; signExt
;-------------------------------------------------------------------------------
; Description:
;   Returns the sign extension of register A.
;
; Inputs:
;   A : Value to be extended
;
; Outputs:
;   A : $00(Plus), $FF(Minus)
;
; Modifies:
;   A
;===============================================================================
signExt:
		and	#$80
		beq	.convPositive
		lda	#$FF
.convPositive:
		rts


;===============================================================================
; sdiv32
;-------------------------------------------------------------------------------
; Description:
;   Performs signed division: 32-bit dividend / 16-bit divisor.
;   Formula: div16a div16b = div16d : div16c / div16a
;
; Inputs:
;   [div16c] (2 bytes) : Lower 16 bits of dividend
;   [div16d] (2 bytes) : Upper 16 bits of dividend
;   [div16a] (2 bytes) : 16-bit divisor
;
; Outputs:
;   [div16a] (2 bytes) : 16-bit quotient
;   [div16b] (2 bytes) : 16-bit 16-bit remainder
;
; Modifies:
;   A
;===============================================================================
sdiv32:
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

		jsr	_udiv30

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


;===============================================================================
; udiv32
;-------------------------------------------------------------------------------
; Description:
;   Performs unsigned division: 32-bit dividend / 16-bit divisor.
;   Formula: div16a div16b = div16d : div16c / div16a
;
; Inputs:
;   [div16c] (2 bytes) : Lower 16 bits of dividend
;   [div16d] (2 bytes) : Upper 16 bits of dividend
;   [div16a] (2 bytes) : 16-bit divisor
;
; Outputs:
;   [div16a] (2 bytes) : 16-bit quotient
;   [div16b] (2 bytes) : 16-bit 16-bit remainder
;
; Modifies:
;   A
;===============================================================================
udiv32:
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


;===============================================================================
; udiv30
;-------------------------------------------------------------------------------
; Description:
;   Performs unsigned division: 30-bit dividend / 15-bit divisor.
;   Formula: div16a div16b = div16d : div16c / div16a
;
; Inputs:
;   [div16c] (2 bytes) : Lower 16 bits of dividend
;   [div16d] (2 bytes) : Upper 16 bits of dividend
;   [div16a] (2 bytes) : 16-bit divisor
;
; Outputs:
;   [div16a] (2 bytes) : 16-bit quotient
;   [div16b] (2 bytes) : 16-bit 16-bit remainder
;
; Modifies:
;   A
;===============================================================================
udiv30:
		phx
		phy

		jsr	_udiv30

		ply
		plx
		rts


;===============================================================================
; _udiv30
;-------------------------------------------------------------------------------
; Description:
;   Performs unsigned division: 30-bit dividend / 15-bit divisor.
;   Formula: div16a div16b = div16d : div16c / div16a
;
; Inputs:
;   [div16c] (2 bytes) : Lower 16 bits of dividend
;   [div16d] (2 bytes) : Upper 16 bits of dividend
;   [div16a] (2 bytes) : 16-bit divisor
;
; Outputs:
;   [div16a] (2 bytes) : 16-bit quotient
;   [div16b] (2 bytes) : 16-bit 16-bit remainder
;
; Modifies:
;   A, X, Y
;===============================================================================
_udiv30:
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

		mov	<work1a, #5
		ldx	<div16d
		ldy	<div16d+1

;----------------
.jpPl00_A:
;div16d
		txa
		rol	a
		tax

		tya
		rol	a
		tay

		txa
		sbc	<div16a
		tax

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
		txa
		rol	a
		tax

		tya
		rol	a
		tay

		txa
		sbc	<div16a
		tax

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
		txa
		rol	a
		tax

		tya
		rol	a
		tay

		txa
		sbc	<div16a
		tax

		tya
		sbc	<div16a+1
		tay

		bcc	.jpMi02_B

.jpPl02_B:
		rol	<div16c
		rol	<div16c+1

		dec	<work1a
		bne	.jpPl00_A

;----------------
.jpPlEnd:	lda	<div16c
		sta	<div16a
		lda	<div16c+1
		sta	<div16a+1

		stx	<div16b
		sty	<div16b+1

		rts

;----------------
.jpMi00_A:
;div16d
		txa
		rol	a
		tax

		tya
		rol	a
		tay

		txa
		adc	<div16a
		tax

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
		txa
		rol	a
		tax

		tya
		rol	a
		tay

		txa
		adc	<div16a
		tax

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
		txa
		rol	a
		tax

		tya
		rol	a
		tay

		txa
		adc	<div16a
		tax

		tya
		adc	<div16a+1
		tay

		bcs	.jpPl02_B

.jpMi02_B:
		rol	<div16c
		rol	<div16c+1

		dec	<work1a
		bne	.jpMi00_A

;----------------
.jpMiEnd:
		sec
		txa
		adc	<div16a
		sta	<div16b

		tya
		adc	<div16a+1
		sta	<div16b+1

		lda	<div16c
		sta	<div16a
		lda	<div16c+1
		sta	<div16a+1

		rts


;===============================================================================
; smul16
;-------------------------------------------------------------------------------
; Description:
;   Performs signed multiplication of two 16-bit integers.
;   Formula: mul16d : mul16c = mul16a * mul16b
;
; Inputs:
;   [mul16a] (2 bytes) : Multiplicand
;   [mul16b] (2 bytes) : Multiplier
;
; Outputs:
;   [mul16c] (2 bytes) : Lower 16 bits of product
;   [mul16d] (2 bytes) : Upper 16 bits of product
;
; Modifies:
;   A
;===============================================================================
smul16:
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
initializeUmul16:
;
		stz	<mulAddr0
		stz	<mulAddr1
		rts


;===============================================================================
; umul16
;-------------------------------------------------------------------------------
; Description:
;   Performs unsigned multiplication of two 16-bit integers.
;   Formula: mul16d : mul16c = mul16a * mul16b
;
; Inputs:
;   [mul16a] (2 bytes) : Multiplicand
;   [mul16b] (2 bytes) : Multiplier
;
; Outputs:
;   [mul16c] (2 bytes) : Lower 16 bits of product
;   [mul16d] (2 bytes) : Upper 16 bits of product
;
; Modifies:
;   A
;===============================================================================
umul16:
		phy

;save MPR2 data
		tma	#MUL_DATA_MAP
		pha

		ldy	<mul16b
		lda	mulBankData, y
		tam	#MUL_DATA_MAP

		lda	mulAddrData, y
		sta	<mulAddr0+1

		inc	a
		sta	<mulAddr1+1

		ldy	<mul16a
		lda	[mulAddr0], y
		sta	<mul16c

		lda	[mulAddr1], y
		sta	<mul16c+1

		clc

		ldy	<mul16a+1
		lda	[mulAddr0], y
		adc	<mul16c+1
		sta	<mul16c+1

		lda	[mulAddr1], y
		adc	#0
		sta	<mul16d

		ldy	<mul16b+1
		lda	mulBankData, y
		tam	#MUL_DATA_MAP

		lda	mulAddrData, y
		sta	<mulAddr0+1

		inc	a
		sta	<mulAddr1+1

		ldy	<mul16a
		lda	[mulAddr0], y
		adc	<mul16c+1
		sta	<mul16c+1

		lda	[mulAddr1], y
		adc	<mul16d
		sta	<mul16d

		cla
		adc	#0
		sta	<mul16d+1

		ldy	<mul16a+1
		lda	[mulAddr0], y
		adc	<mul16d
		sta	<mul16d

		lda	[mulAddr1], y
		adc	<mul16d+1
		sta	<mul16d+1

;set MPR2 data
		pla
		tam	#MUL_DATA_MAP

		ply
		rts


;===============================================================================
; sqrt32
;-------------------------------------------------------------------------------
; Description:
;   Calculates the 16-bit square root of a 32-bit unsigned integer.
;   Formula: mul16c = sqrt(sqr32a)
;
; Inputs:
;   [sqr32a] (4 bytes) : 32-bit unsigned integer (Radicand)
;
; Outputs:
;   [mul16c] (2 bytes) : 16-bit square root (Result)
;
; Modifies:
;   A
;===============================================================================
sqrt32:
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


;===============================================================================
; calcDistance
;-------------------------------------------------------------------------------
; Description:
;   Calculates the Euclidean distance between two 2D points.
;   Formula: mul16c = sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
;
; Inputs:
;   [angleX0] (2 bytes) : X coordinate of first point (x1)
;   [angleY0] (2 bytes) : Y coordinate of first point (y1)
;   [angleZ0] (2 bytes) : Y coordinate of first point (z1)
;   [angleX1] (2 bytes) : X coordinate of first point (x2)
;   [angleY1] (2 bytes) : Y coordinate of first point (y2)
;   [angleZ1] (2 bytes) : Y coordinate of first point (z2)
;
; Outputs:
;   [mul16c] (2 bytes)  : 16-bit calculated distance
;
; Modifies:
;   A, X, Y
;===============================================================================
calcDistance:
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

		jsr	sqrt32

		rts


;===============================================================================
; initializePad
;-------------------------------------------------------------------------------
; Description:
;   Initializes the game controller state variables.
;
; Inputs:
;   None
;
; Outputs:
;   None
;
; Modifies:
;   A
;===============================================================================
initializePad:
		stz	<padLast
		mov	<padNow, #$FF
		stz	<padState
		rts


;===============================================================================
; initializePad2
;-------------------------------------------------------------------------------
; Description:
;   Initializes the game controller state variables.
;
; Inputs:
;   None
;
; Outputs:
;   None
;
; Modifies:
;   A
;===============================================================================
initializePad2:
		stz	<padState2
		rts


;===============================================================================
; getPadData
;-------------------------------------------------------------------------------
; Description:
;   Reads the current state of the controller and updates input buffers.
;
; Inputs:
;   None
;
; Outputs:
;   [padNow]    (1 byte) : Currently held buttons
;   [padLast]   (1 byte) : Last held buttons
;   [padState]  (1 byte) : Newly pressed buttons this frame
;   [padState2] (1 byte) : Buttons pressed within the last few frames
;
; Modifies:
;   A
;===============================================================================
getPadData:
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
		rts


;===============================================================================
; setSinCos8
;-------------------------------------------------------------------------------
; Description:
;   Sets up pointers to the pre-calculated multiplication lookup tables (MPR2, MPR3)
;   based on the provided sine and cosine values.
;
; Inputs:
;   X: Angle
;
; Outputs:
;   None
;
; Modifies:
;   A
;===============================================================================
setSinCos8:
		phx

;save MPR2 data
		tma	#POLYGON_SIN8_MAP
		sta	<saveMpr2

		tma	#POLYGON_COS8_MAP
		sta	<saveMpr3

;sin data
		lda	sin8DataLow, x
		sta	<saveSin8Data
		lda	sin8DataHigh, x
		sta	<saveSin8Data+1

;cos data
		lda	cos8DataLow, x
		sta	<saveCos8Data
		lda	cos8DataHigh, x
		sta	<saveCos8Data+1

;sin mul data
		ldx	<saveSin8Data
		lda	mulBankData, x
		tam	#POLYGON_SIN8_MAP

		stz	<sinLowAddr
		lda	mulAddrData, x
		sta	<sinLowAddr+1

		stz	<sinHighAddr
		inc	a
		sta	<sinHighAddr+1

;cos mul data
		ldx	<saveCos8Data
		lda	mulBankData, x
		tam	#POLYGON_COS8_MAP

		stz	<cosLowAddr
		lda	mulAddrData, x
		add	#POLYGON_COS8_ADDR - POLYGON_SIN8_ADDR
		sta	<cosLowAddr+1

		stz	<cosHighAddr
		inc	a
		sta	<cosHighAddr+1

		plx

		rts


;===============================================================================
; unsetSinCos8
;-------------------------------------------------------------------------------
; Description:
;   Restores the original bank mapping for MPR2 and MPR3 after sine/cosine
;   table lookup operations.
;
; Inputs:
;   None
;
; Outputs:
;   None
;
; Modifies:
;   A
;===============================================================================
unsetSinCos8:
;set MPR2 data
		lda	<saveMpr2
		tam	#2

		lda	<saveMpr3
		tam	#3

		rts


;===============================================================================
; rotation8
;-------------------------------------------------------------------------------
; Description:
;   Applies a 2D rotation to a 2D vector (work2a, work2b) using an 8-bit angle.
;   Calculates:
;     work2a = work2a * cos(A) - work2b * sin(A)
;     work2b = work2a * sin(A) + work2b * cos(A)
;
; Inputs:
;   X                  : angle
;   [work2a] (2 bytes) : X coordinate
;   [work2b] (2 bytes) : Y coordinate
;
; Outputs:
;   [work2a] (2 bytes) : Rotated X coordinate
;   [work2b] (2 bytes) : Rotated Y coordinate
;
; Modifies:
;   A
;===============================================================================
rotation8:
		phy

;================
;work2a * cosA
		movw	<mul16a, <work2a

;anser sign
		lda	<mul16a+1
		eor	<saveCos8Data+1
		pha

;a neg check
		bbr7	<mul16a+1, .jpCosA_02

;a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.jpCosA_02:
;mul16a*256 check
		bbr0	<saveCos8Data+1, .jpCosA_00

;mul16a*256
		stz	<work4c

		lda	<mul16a
		sta	<work4c+1

		lda	<mul16a+1
		sta	<work4c+2

		bra	.jpCosA_03

.jpCosA_00:
		ldy	<mul16a
		lda	[cosLowAddr], y
		sta	<work4c

		lda	[cosHighAddr], y
		sta	<work4c+1

		clc

		ldy	<mul16a+1
		lda	[cosLowAddr], y
		adc	<work4c+1
		sta	<work4c+1

		lda	[cosHighAddr], y
		adc	#0
		sta	<work4c+2

.jpCosA_03:
;anser sign
		pla
		bpl	.jpCosA_End

;anser neg
		sec
		cla
		sbc	<work4c
		sta	<work4c

		cla
		sbc	<work4c+1
		sta	<work4c+1

		cla
		sbc	<work4c+2
		sta	<work4c+2

.jpCosA_End:
;================

;================
;work2b * sinA
		movw	<mul16a, <work2b

;anser sign
		lda	<mul16a+1
		eor	<saveSin8Data+1
		pha

;a neg check
		bbr7	<mul16a+1, .jpSinA_02

;a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.jpSinA_02:
;mul16a*256 check
		bbr0	<saveSin8Data+1, .jpSinA_00

;mul16a*256
		stz	<mul16c

		lda	<mul16a
		sta	<mul16c+1

		lda	<mul16a+1
		sta	<mul16d

		bra	.jpSinA_03

.jpSinA_00:
		ldy	<mul16a
		lda	[sinLowAddr], y
		sta	<mul16c

		lda	[sinHighAddr], y
		sta	<mul16c+1

		clc

		ldy	<mul16a+1
		lda	[sinLowAddr], y
		adc	<mul16c+1
		sta	<mul16c+1

		lda	[sinHighAddr], y
		adc	#0
		sta	<mul16d

.jpSinA_03:
;anser sign
		pla
		bpl	.jpSinA_04

;anser neg
;work2a * cosA - ( - ( work2b * sinA ) )
		clc
		lda	<work4c
		adc	<mul16c
		sta	<work4c

		lda	<work4c+1
		adc	<mul16c+1
		sta	<work4c+1

		lda	<work4c+2
		adc	<mul16d
		sta	<work4c+2

		bra	.jpSinA_End

.jpSinA_04:
;work2a * cosA - work2b * sinA
		sec
		lda	<work4c
		sbc	<mul16c
		sta	<work4c

		lda	<work4c+1
		sbc	<mul16c+1
		sta	<work4c+1

		lda	<work4c+2
		sbc	<mul16d
		sta	<work4c+2

.jpSinA_End:
;================

;================
;work2a * sinA
		movw	<mul16a, <work2a

;anser sign
		lda	<mul16a+1
		eor	<saveSin8Data+1
		pha

;a neg check
		bbr7	<mul16a+1, .jpSinB_02

;a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.jpSinB_02:
;mul16a*256 check
		bbr0	<saveSin8Data+1, .jpSinB_00

;mul16a*256
		stz	<work4d

		lda	<mul16a
		sta	<work4d+1

		lda	<mul16a+1
		sta	<work4d+2

		bra	.jpSinB_03

.jpSinB_00:
		ldy	<mul16a
		lda	[sinLowAddr], y
		sta	<work4d

		lda	[sinHighAddr], y
		sta	<work4d+1

		clc

		ldy	<mul16a+1
		lda	[sinLowAddr], y
		adc	<work4d+1
		sta	<work4d+1

		lda	[sinHighAddr], y
		adc	#0
		sta	<work4d+2

.jpSinB_03:
;anser sign
		pla
		bpl	.jpSinB_End

;anser neg
		sec
		cla
		sbc	<work4d
		sta	<work4d

		cla
		sbc	<work4d+1
		sta	<work4d+1

		cla
		sbc	<work4d+2
		sta	<work4d+2

.jpSinB_End:
;================

;================
;work2b * cosA
		movw	<mul16a, <work2b
;anser sign
		lda	<mul16a+1
		eor	<saveCos8Data+1
		pha

;a neg check
		bbr7	<mul16a+1, .jpCosB_02

;a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.jpCosB_02:
;mul16a*256 check
		bbr0	<saveCos8Data+1, .jpCosB_00

;mul16a*256
		stz	<mul16c

		lda	<mul16a
		sta	<mul16c+1

		lda	<mul16a+1
		sta	<mul16d

		bra	.jpCosB_03

.jpCosB_00:
		ldy	<mul16a
		lda	[cosLowAddr], y
		sta	<mul16c

		lda	[cosHighAddr], y
		sta	<mul16c+1

		clc

		ldy	<mul16a+1
		lda	[cosLowAddr], y
		adc	<mul16c+1
		sta	<mul16c+1

		lda	[cosHighAddr], y
		adc	#0
		sta	<mul16d

.jpCosB_03:
;anser sign
		pla
		bpl	.jpCosB_04

;anser neg
;work2a * sinA + ( - ( work2b * cosA ) )
		sec
		lda	<work4d
		sbc	<mul16c
		sta	<work4d

		lda	<work4d+1
		sbc	<mul16c+1
		sta	<work4d+1

		lda	<work4d+2
		sbc	<mul16d
		sta	<work4d+2

		bra	.jpCosB_End

.jpCosB_04:
;work2a * sinA + work2b * cosA
		clc
		lda	<work4d
		adc	<mul16c
		sta	<work4d

		lda	<work4d+1
		adc	<mul16c+1
		sta	<work4d+1

		lda	<work4d+2
		adc	<mul16d
		sta	<work4d+2

.jpCosB_End:
;================

		mov	<work2a, <work4c+1
		mov	<work2a+1, <work4c+2

		mov	<work2b, <work4d+1
		mov	<work2b+1, <work4d+2

		ply

		rts


;===============================================================================
; vertexRotationZ8
;-------------------------------------------------------------------------------
; Description:
;   Rotates a 3D vertex around the Z-axis using an angle.
;   Calculates:
;     X = X * cos(A) - Y * sin(A)
;     Y = X * sin(A) + Y * cos(A)
;     Z = Z
;
; Inputs:
;   X                       : angle
;   [vertexCount] (1 bytes) : Number of X, Y, Z coordinates
;   [vertexDataTemp]        : X, Y, Z coordinates
;
; Outputs:
;   [vertexDataTemp]        : Rotated X, Y, Z coordinates
;
; Modifies:
;   A
;===============================================================================
vertexRotationZ8:
		phx
		phy

		cpx	#0
		beq	.jpEnd

		lda	<vertexCount
		beq	.jpEnd

		jsr	setSinCos8

		cly
		ldx	<vertexCount

.loop0:
		lda	transform2DWork0+VX, y
		sta	<work2a
		lda	transform2DWork0+VX+1, y
		sta	<work2a+1

		lda	transform2DWork0+VY, y
		sta	<work2b
		lda	transform2DWork0+VY+1, y
		sta	<work2b+1

		jsr	rotation8

		lda	<work2a
		sta	transform2DWork0+VX, y
		lda	<work2a+1
		sta	transform2DWork0+VX+1, y

		lda	<work2b
		sta	transform2DWork0+VY, y
		lda	<work2b+1
		sta	transform2DWork0+VY+1, y

		ady2	#6

		dex
		bne	.loop0

		jsr	unsetSinCos8

.jpEnd:
		ply
		plx

		rts


;===============================================================================
; vertexRotationY8
;-------------------------------------------------------------------------------
; Description:
;   Rotates a 3D vertex around the Y-axis using an angle.
;   Calculates:
;     X = X * cos(A) - Z * sin(A)
;     Y = Y
;     Z = X * sin(A) + Z * cos(A)
;
; Inputs:
;   X                       : angle
;   [vertexCount] (1 bytes) : Number of X, Y, Z coordinates
;   [vertexDataTemp]        : X, Y, Z coordinates
;
; Outputs:
;   [vertexDataTemp]        : Rotated X, Y, Z coordinates
;
; Modifies:
;   A
;===============================================================================
vertexRotationY8:
		phx
		phy

		cpx	#0
		beq	.jpEnd

		lda	<vertexCount
		beq	.jpEnd

		jsr	setSinCos8

		cly
		ldx	<vertexCount

.loop0:
		lda	transform2DWork0+VX, y
		sta	<work2a
		lda	transform2DWork0+VX+1, y
		sta	<work2a+1

		lda	transform2DWork0+VZ, y
		sta	<work2b
		lda	transform2DWork0+VZ+1, y
		sta	<work2b+1

		jsr	rotation8

		lda	<work2a
		sta	transform2DWork0+VX, y
		lda	<work2a+1
		sta	transform2DWork0+VX+1, y

		lda	<work2b
		sta	transform2DWork0+VZ, y
		lda	<work2b+1
		sta	transform2DWork0+VZ+1, y

		ady2	#6

		dex
		bne	.loop0

		jsr	unsetSinCos8

.jpEnd:
		ply
		plx

		rts


;===============================================================================
; vertexRotationX8
;-------------------------------------------------------------------------------
; Description:
;   Rotates a 3D vertex around the X-axis using an angle.
;   Calculates:
;     X = X
;     Y = Z * sin(A) + Y * cos(A)
;     Z = Z * cos(A) - Y * sin(A)
;
; Inputs:
;   X                       : angle
;   [vertexCount] (1 bytes) : Number of X, Y, Z coordinates
;   [vertexDataTemp]        : X, Y, Z coordinates
;
; Outputs:
;   [vertexDataTemp]        : Rotated X, Y, Z coordinates
;
; Modifies:
;   A
;===============================================================================
vertexRotationX8:
		phx
		phy

		cpx	#0
		beq	.jpEnd

		lda	<vertexCount
		beq	.jpEnd

		jsr	setSinCos8

		cly
		ldx	<vertexCount

.loop0:
		lda	transform2DWork0+VZ, y
		sta	<work2a
		lda	transform2DWork0+VZ+1, y
		sta	<work2a+1

		lda	transform2DWork0+VY, y
		sta	<work2b
		lda	transform2DWork0+VY+1, y
		sta	<work2b+1

		jsr	rotation8

		lda	<work2a
		sta	transform2DWork0+VZ, y
		lda	<work2a+1
		sta	transform2DWork0+VZ+1, y

		lda	<work2b
		sta	transform2DWork0+VY, y
		lda	<work2b+1
		sta	transform2DWork0+VY+1, y

		ady2	#6

		dex
		bne	.loop0

		jsr	unsetSinCos8

.jpEnd:
		ply
		plx

		rts


;===============================================================================
; selectVertexRotation8
;-------------------------------------------------------------------------------
; Description:
;   Applies 3D rotation to a vertex by executing X, Y, and Z axis rotations
;   in a specified order using angles.
;
; Inputs:
;   A                       : rotation order(0:X, 1:Y, 2:Z)
;   [rotationX] (1 bytes)   : rotation angle for X-axis
;   [rotationY] (1 bytes)   : rotation angle for Y-axis
;   [rotationZ] (1 bytes)   : rotation angle for Z-axis
;   [vertexCount] (1 bytes) : Number of X, Y, Z coordinates
;   [vertexDataTemp]        : X, Y, Z coordinates
;
; Outputs:
;   [vertexDataTemp]        : Rotated X, Y, Z coordinates
;
; Modifies:
;   A
;===============================================================================
selectVertexRotation8:
		phx

		and	#3
		beq	.rotationSelectX

		cmp	#1
		beq	.rotationSelectY

.rotationSelectZ:
		ldx	<rotationZ
		jsr	vertexRotationZ8

		plx
		rts

.rotationSelectX:
		ldx	<rotationX
		jsr	vertexRotationX8

		plx
		rts

.rotationSelectY:
		ldx	<rotationY
		jsr	vertexRotationY8

		plx
		rts


;===============================================================================
; vertexTranslationDatas
;-------------------------------------------------------------------------------
; Description:
;   Data block containing 3D vertex translation offsets (X, Y, Z).
;
; Inputs:
;   [translationX] (2 bytes) : X translation offset
;   [translationY] (2 bytes) : Y translation offset
;   [translationZ] (2 bytes) : Z translation offset
;   [vertexCount] (1 bytes)  : Number of X, Y, Z coordinates
;   [vertexDataTemp]         : X, Y, Z coordinates
;
; Outputs:
;   [vertexDataTemp]         : Translated X, Y, Z coordinates
;
; Modifies:
;   A
;===============================================================================
vertexTranslationDatas:
		phx
		phy

		ldx	<vertexCount
		beq	.vertexTranslationEnd

		cly

.vertexTranslationLoop:
		clc
		lda	transform2DWork0+VX, y
		adc	<translationX
		sta	transform2DWork0+VX, y
		lda	transform2DWork0+VX+1, y
		adc	<translationX+1
		sta	transform2DWork0+VX+1, y

		clc
		lda	transform2DWork0+VY, y
		adc	<translationY
		sta	transform2DWork0+VY, y
		lda	transform2DWork0+VY+1, y
		adc	<translationY+1
		sta	transform2DWork0+VY+1, y

		clc
		lda	transform2DWork0+VZ, y
		adc	<translationZ
		sta	transform2DWork0+VZ, y
		lda	transform2DWork0+VZ+1, y
		adc	<translationZ+1
		sta	transform2DWork0+VZ+1, y

		ady2	#6

		dex
		bne	.vertexTranslationLoop

.vertexTranslationEnd:
		ply
		plx
		rts


;===============================================================================
; transform2D
;-------------------------------------------------------------------------------
; Description:
;   Performs perspective projection to transform 3D vertex coordinates (X, Y, Z)
;   into 2D screen coordinates (X, Y).
;
; Inputs:
;   [vertexCount] (1 bytes) : Number of X, Y, Z coordinates
;   [vertexDataTemp]        : X, Y, Z coordinates
;
; Outputs:
;   [vertexDataTemp]        : Projected 2D screen  X, Y coordinates
;
; Modifies:
;   A
;===============================================================================
transform2D:
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
		lda	transform2DWork0+VZ, x	;Z0
		sta	transform2DWork1+VZ, x
		sbc	#SCREEN_Z
		lda	transform2DWork0+VZ+1, x
		sta	transform2DWork1+VZ+1, x
		sbc	#0

		bpl	.transform2DJump05
		jmp	.transform2DJump00

.transform2DJump05:
;X0 to mul16b
		lda	transform2DWork0+VX, x
		sta	transform2DWork1+VX, x
		sta	<mul16b
		lda	transform2DWork0+VX+1, x
		sta	transform2DWork1+VX+1, x
		sta	<mul16b+1

;Z0 to mul16a
		lda	transform2DWork0+VZ, x
		sta	<mul16a
		lda	transform2DWork0+VZ+1, x
		sta	<mul16a+1

;X0*128/Z0
		jsr	transform2DProc

;X0*128/Z0+centerX
;mul16d+centerX to X0
		clc
		lda	<mul16d
		adc	<centerX
		sta	transform2DWork0+VX, x	;X0
		lda	<mul16d+1
		adc	#0
		sta	transform2DWork0+VX+1, x

;Y0 to mul16b
		lda	transform2DWork0+VY, x
		sta	transform2DWork1+VY, x
		sta	<mul16b
		lda	transform2DWork0+VY+1, x
		sta	transform2DWork1+VY+1, x
		sta	<mul16b+1

;Y0*128/Z0
		jsr	_transform2DProc

;centerY-Y0*128/Z0
;centerY-mul16d to Y0
		sec
		lda	<centerY
		sbc	<mul16d
		sta	transform2DWork0+VY, x	;Y0
		lda	#0
		sbc	<mul16d+1
		sta	transform2DWork0+VY+1, x

		jmp	.transform2DJump01

.transform2DJump00:
		lda	transform2DWork0+VX, x
		sta	transform2DWork1+VX, x
		lda	transform2DWork0+VX+1, x
		sta	transform2DWork1+VX+1, x

		lda	transform2DWork0+VY, x
		sta	transform2DWork1+VY, x
		lda	transform2DWork0+VY+1, x
		sta	transform2DWork1+VY+1, x

;Z0<128 flag set
		stz	transform2DWork0+VZ, x
		lda	#$80
		sta	transform2DWork0+VZ+1, x

.transform2DJump01:
		adx2	#6

		dey
		jne	.transform2DLoop0

;set MPR2 data
		pla
		tam	#DIV_DATA_MAP

		ply
		plx
		rts


;===============================================================================
transform2DProc:
;mul16d(very rough value) = mul16b(-32768 to 32767) * 128 / mul16a(128 to 32767)
		phy

		asl	<div16a
		rol	<div16a+1

		ldy	<div16a+1
		lda	divBankData, y
		tam	#DIV_DATA_MAP

		lda	divAddrData, y
		sta	<div16a+1

		lda	[div16a]
		tay
		inc	<div16a
		lda	[div16a]

		sty	<div16a
		sta	<div16a+1

		ply

		;;;jsr	_transform2DProc
		;;;rts


;===============================================================================
_transform2DProc:
;
		lda	<div16a+1
		ora	<div16a
		bne	.jp02

		movw	<mul16d, <mul16b
		rts

.jp02:
		lda	<mul16b+1
		pha
		bpl	.jp00

		sec
		cla
		sbc	<mul16b
		sta	<mul16b

		cla
		sbc	<mul16b+1
		sta	<mul16b+1

.jp00:
		jsr	umul16

		pla
		bpl	.jp01

		sec
		cla
		sbc	<mul16d
		sta	<mul16d

		cla
		sbc	<mul16d+1
		sta	<mul16d+1

.jp01:
		rts



;===============================================================================
; moveToTransform2DWork0
;-------------------------------------------------------------------------------
; Description:
;   Copies the specified number of vertex data entries (vertexCount) from
;   vertex0Addr into the 2D transformation work buffer (vertexDataTemp / transform2DWork0).
;
; Inputs:
;   [vertex0Addr] (2 bytes) : Pointer to the source vertex data
;   [vertexCount] (1 byte)  : Number of vertices to copy
;
; Outputs:
;   [transform2DWork0]      : Work buffer populated with vertex data
;
; Modifies:
;   A
;===============================================================================
moveToTransform2DWork0:
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


;===============================================================================
; setPolygonColorIndex
;-------------------------------------------------------------------------------
; Description:
;   Sets the starting color palette index used for rendering polygons.
;
; Inputs:
;   A                            : Base color palette index
;
; Outputs:
;   [polygonColorIndex] (1 byte) : Work variable updated with the index
;
; Modifies:
;   A
;===============================================================================
setPolygonColorIndex:
		sta	<polygonColorIndex
		rts


;===============================================================================
; putPolygonBuffer
;-------------------------------------------------------------------------------
; Description:
;   Renders polygon graphics data stored in the RAM work buffer
;   directly into VRAM for visual display.
;
; Inputs:
;   [polyBuffer] : Buffer containing processed polygon data
;
; Outputs:
;   VRAM         : Updated with new polygon patterns
;
; Modifies:
;   A
;===============================================================================
putPolygonBuffer:
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



;===============================================================================
; setModelRotation
;-------------------------------------------------------------------------------
; Description:
;   Transforms 3D model vertices by executing rotation, translation, and
;   perspective projection, then writes the resulting 2D screen coordinates
;   into the render buffer.
;
; Inputs:
;   [modelAddress] (2 bytes)     : Source 3D model vertex coordinates
;   [rotationSelect](1 bytes)    : rotation order
;   [rotationX] (1 bytes)        : rotation angle for X-axis
;   [rotationY] (1 bytes)        : rotation angle for Y-axis
;   [rotationZ] (1 bytes)        : rotation angle for Z-axis
;   [translationX] (2 bytes)     : X-axis translation offsets
;   [translationY] (2 bytes)     : Y-axis translation offsets
;   [translationZ] (2 bytes)     : Z-axis translation offsets
;   [eyeRotationSelect](1 bytes) : rotation order for the viewpoint position.
;   [eyeRotationX] (1 bytes)     : rotation angle for X-axis for the viewpoint position.
;   [eyeRotationY] (1 bytes)     : rotation angle for Y-axis for the viewpoint position.
;   [eyeRotationZ] (1 bytes)     : rotation angle for Z-axis for the viewpoint position.
;   [eyeTranslationX] (2 bytes)  : X-axis translation offset for the viewpoint position.
;   [eyeTranslationY] (2 bytes)  : Y-axis translation offset for the viewpoint position.
;   [eyeTranslationZ] (2 bytes)  : Z-axis translation offset for the viewpoint position.
;
; Outputs:
;   [polyBuffer]                 : Transformed 2D screen coordinates ready for rendering
;
; Modifies:
;   A
;===============================================================================
setModelRotation:
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
		jsr	selectVertexRotation8

		lda	<rotationSelect
		lsr	a
		lsr	a
		jsr	selectVertexRotation8

		lda	<rotationSelect
		lsr	a
		lsr	a
		lsr	a
		lsr	a
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
		jsr	selectVertexRotation8

		lda	<eyeRotationSelect
		lsr	a
		lsr	a
		jsr	selectVertexRotation8

		lda	<eyeRotationSelect
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		jsr	selectVertexRotation8

		bra	setModel+2
		;;;jsr	setModel
		;;;ply
		;;;plx
		;;;rts


;===============================================================================
setModel:
;target vertex data: vertexDataTemp
		phx
		phy

;transform 2D
		jsr	transform2D

		lda	[modelAddress]
		sta	<modelAddrWork		;ModelData Polygon Addr
		ldy	#1
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
		lda	transform2DWork0+VZ+1, x	;Z0<128 flag
		jmi	.setModelJump0

;SAMPLE Z
;--------
			IFDEF SAMPLE_Z_MAX_ONLY

		ldy	#3
		sta	<mul16a+1
		sta	[polyBufferAddr], y

		dey
		lda	transform2DWork0+VZ, x
		sta	<mul16a
		sta	[polyBufferAddr], y

;--------
			ELSE
;--------

		ldy	#3
		sta	<mul16a+1
		lsr	a
		sta	[polyBufferAddr], y

		dey
		lda	transform2DWork0+VZ, x
		sta	<mul16a
		ror	a
		sta	[polyBufferAddr], y

			ENDIF
;--------

		lda	<setModelBackColor
		sta	<mul16b
		lda	<setModelCount
		sta	<mul16b+1

;transform 2D
		tma	#DIV_DATA_MAP
		pha
		jsr	transform2DProc
		pla
		tam	#DIV_DATA_MAP

		lda	<mul16d
		ora	<mul16d+1
		jeq	.setModelJump0

		mov	clip2D0+8, <mul16d
		mov	clip2D0+10, <mul16d+1

		ldy	#5
		lda	<setModelAttr
		and	#%11000000
		sta	[polyBufferAddr], y	;COUNT

		dey
		lda	<setModelFrontColor
		clc
		adc	<polygonColorIndex
		sta	[polyBufferAddr], y	;COLOR

		lda	transform2DWork0+VX, x	;X
		sta	clip2D0
		lda	transform2DWork0+VX+1, x
		sta	clip2D0+2

		lda	transform2DWork0+VY, x	;Y
		sta	clip2D0+4
		lda	transform2DWork0+VY+1, x
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

;push ModelData index for initialize front clip calculation
		phy

;check front clip
.setModelLoop5:
		lda	[modelAddrWork], y
		tax
		lda	transform2DWork0+VZ+1, x	;Z0<128 flag
		bmi	.setModelJump7

		phy

		ldy	<model2DClipIndexWork

		lda	transform2DWork0+VX, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+VX+1, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+VY, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+VY+1, x
		sta	clip2D0, y
		iny

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

;cancel front clip calculation
		bbr2	<setModelAttr, .setModelLoop4
		jmp	.setModelJump0

;front clip calculation
.setModelLoop4:
		lda	[modelAddrWork], y
		tax

		iny
		lda	[modelAddrWork], y

		phy
		tay
		jsr	clipFront
		ply

		dec	<setModelCount
		bne	.setModelLoop4

;--------
		lda	[modelAddrWork], y
		tax

		lda	<frontClipDataWork
		tay

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
;back side check cancel
		bbr1	<setModelAttr, .setModelJump15
		jmp	.setModelJump2

.setModelJump15:
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

;--------
			IFDEF SAMPLE_Z_MAX_ONLY

.compareZMax:
		ply
		phy

		stzw	<sampleZ

		iny
		iny
		iny

		lda	[modelAddrWork], y	;ModelData Count
		sta	<setModelCount

.compareZLoop0:
		iny
		lda	[modelAddrWork], y
		tax

		sec
		lda	<sampleZ
		sbc	transform2DWork1+VZ, x
		lda	<sampleZ+1
		sbc	transform2DWork1+VZ+1, x

		bpl	.compareZJp00

		lda	transform2DWork1+VZ, x
		sta	<sampleZ
		lda	transform2DWork1+VZ+1, x
		sta	<sampleZ+1

.compareZJp00:
		dec	<setModelCount
		bne	.compareZLoop0

		ldy	#2
		lda	<sampleZ
		sta	[polyBufferAddr], y

		iny
		lda	<sampleZ+1
		sta	[polyBufferAddr], y

;--------
			ELSE
;--------

		tst	#ATTR_SYSTEM_Z_MAX + ATTR_SYSTEM_Z_MIN, <systemConfig
		jne	.compareZMinMax

.compareZAvg:
		ply
		phy

		stz	<sampleZWork
		stz	<sampleZWork+1
		stz	<sampleZWork+2

		iny
		iny
		iny

		lda	[modelAddrWork], y	;ModelData Count
		sta	<setModelCount

		pha

.compareZLoop1:
		iny
		lda	[modelAddrWork], y
		tax

		clc
		lda	transform2DWork1+VZ, x
		adc	<sampleZWork
		sta	<sampleZWork

		lda	transform2DWork1+VZ+1, x
		adc	<sampleZWork+1
		sta	<sampleZWork+1

		lda	transform2DWork1+VZ+1, x
		jsr	signExt
		adc	<sampleZWork+2
		sta	<sampleZWork+2

		dec	<setModelCount
		bne	.compareZLoop1

		pla

		cmp	#4
		bne	.compareZJp02

		lsr	<sampleZWork+2
		ror	<sampleZWork+1
		ror	<sampleZWork

		lsr	<sampleZWork+2
		lda	<sampleZWork+1
		ror	a
		sta	<sampleZ+1
		lda	<sampleZWork
		ror	a
		sta	<sampleZ

		bra	.compareAvgEnd

.compareZJp02:
		movw	<sampleZ, <sampleZWork+1

		lsr	<sampleZWork+2
		ror	<sampleZWork+1
		ror	<sampleZWork

		lsr	<sampleZWork+2
		ror	<sampleZWork+1
		ror	<sampleZWork

		addw	<sampleZ, <sampleZWork

		lsr	<sampleZWork+2
		ror	<sampleZWork+1
		ror	<sampleZWork

		lsr	<sampleZWork+2
		ror	<sampleZWork+1
		ror	<sampleZWork

		addw	<sampleZ, <sampleZWork

		lsr	<sampleZWork+2
		ror	<sampleZWork+1
		ror	<sampleZWork

		lsr	<sampleZWork+2
		ror	<sampleZWork+1
		ror	<sampleZWork

		addw	<sampleZ, <sampleZWork

.compareAvgEnd:
		ldy	#3
		lda	<sampleZ+1
		asl	a
		lda	<sampleZ+1
		ror	a
		sta	[polyBufferAddr], y
		dey
		lda	<sampleZ
		ror	a
		sta	[polyBufferAddr], y

		bra	.compareEnd

.compareZMinMax:
		ply
		phy

		bbr7	<systemConfig, .compareZMinInit
		movw	<sampleZ, #-16384
		bra	.compareZJp03

.compareZMinInit:
		movw	<sampleZ, #16384

.compareZJp03:
		iny
		iny
		iny

		lda	[modelAddrWork], y	;ModelData Count
		sta	<setModelCount

.compareZLoop0:
		iny
		lda	[modelAddrWork], y
		tax

		lda	transform2DWork1+VZ+1, x
		asl	a
		lda	transform2DWork1+VZ+1, x
		ror	a
		sta	<sampleZWork+1
		lda	transform2DWork1+VZ, x
		ror	a
		sta	<sampleZWork

		sec
		lda	<sampleZ
		sbc	<sampleZWork
		lda	<sampleZ+1
		sbc	<sampleZWork+1

		bbr7	<systemConfig, .compareZMinJp
		bpl	.compareZJp00
		bra	.compareZJp01

.compareZMinJp:
		bmi	.compareZJp00

.compareZJp01:
		lda	<sampleZWork
		sta	<sampleZ
		lda	<sampleZWork+1
		sta	<sampleZ+1

.compareZJp00:
		dec	<setModelCount
		bne	.compareZLoop0

		ldy	#2
		lda	<sampleZ
		sta	[polyBufferAddr], y
		iny
		lda	<sampleZ+1
		sta	[polyBufferAddr], y

.compareEnd:
			ENDIF
;--------

;set buffer
.setBuffer:
		movw	<polyBufferNow, #polyBufferStart

.setBufferLoop:
		lda	[polyBufferNow]		;NEXT ADDR
		sta	<polyBufferNext
		ldy	#1
		lda	[polyBufferNow], y
		sta	<polyBufferNext+1

		iny				;SAMPLE Z and NEXT SAMPLE Z
		sec
		lda	[polyBufferAddr], y	;SAMPLE Z
		sbc	[polyBufferNext], y	;NEXT SAMPLE Z
		iny
		lda	[polyBufferAddr], y
		sbc	[polyBufferNext], y

		bpl	.setBufferJump		;SAMPLE Z >= NEXT SAMPLE Z

		movw	<polyBufferNow, <polyBufferNext

		bra	.setBufferLoop

.setBufferJump:
		lda	<polyBufferNext		;BUFFER -> NEXT
		sta	[polyBufferAddr]
		lda	<polyBufferAddr		;NOW -> BUFFER
		sta	[polyBufferNow]
		ldy	#1
		lda	<polyBufferNext+1
		sta	[polyBufferAddr], y
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
		sbx2	#6
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


;===============================================================================
clipFront:
;
		lda	transform2DWork0+VZ+1, x	;Z0<128 flag
		and	#$80
		lsr	a
		sta	<frontClipFlag
		lda	transform2DWork0+VZ+1, y	;Z0<128 flag
		and	#$80
		ora	<frontClipFlag
		sta	<frontClipFlag
		jeq	.clipFrontJump8

		cmp	#$C0
		bne	.clipFrontJump12
		rts

.clipFrontJump12:
;clip front
;(128-Z0) => mul16d
		sec
		lda	#SCREEN_Z
		sbc	transform2DWork1+VZ, x
		sta	<mul16d
		cla
		sbc	transform2DWork1+VZ+1, x
		sta	<mul16d+1

;(128-Z0) * 32768 => mul16d:mul16c
		stzw	<mul16c
		asl	a
		ror	<mul16d+1
		ror	<mul16d
		ror	<mul16c+1

;(Z1-Z0) => mul16a
		sec
		lda	transform2DWork1+VZ, y
		sbc	transform2DWork1+VZ, x
		sta	<mul16a
		lda	transform2DWork1+VZ+1, y
		sbc	transform2DWork1+VZ+1, x
		sta	<mul16a+1

;(128-Z0)*32768/(Z1-Z0) => mul16a
		jsr	sdiv32

		lda	<mul16a
		pha
		lda	<mul16a+1
		pha

;(X1-X0) => mul16b
		sec
		lda	transform2DWork1+VX, y
		sbc	transform2DWork1+VX, x
		sta	<mul16b
		lda	transform2DWork1+VX+1, y
		sbc	transform2DWork1+VX+1, x
		sta	<mul16b+1

;(128-Z0)*32768/(Z1-Z0)*(X1-X0) => mul16d:mul16c
		jsr	smul16

;(128-Z0)*32768/(Z1-Z0)*(X1-X0)*2 => mul16d
		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

;(128-Z0)*32768/(Z1-Z0)*(X1-X0)*2+X0 => mul16a
		clc
		lda	<mul16d
		adc	transform2DWork1+VX, x
		sta	<mul16a
		lda	<mul16d+1
		adc	transform2DWork1+VX+1, x
		sta	<mul16a+1

;mul16a+centerX
		clc
		lda	<mul16a
		adc	<centerX
		sta	<clipFrontX

		lda	<mul16a+1
		adc	#0
		sta	<clipFrontX+1

;(128-Z0)*32768/(Z1-Z0) => mul16a
		pla
		sta	<mul16a+1
		pla
		sta	<mul16a

;(Y1-Y0) to mul16b
		sec
		lda	transform2DWork1+VY, y
		sbc	transform2DWork1+VY, x
		sta	<mul16b
		lda	transform2DWork1+VY+1, y
		sbc	transform2DWork1+VY+1, x
		sta	<mul16b+1

;(128-Z0)*32768/(Z1-Z0)*(Y1-Y0) => mul16d:mul16c
		jsr	smul16

;(128-Z0)*32768/(Z1-Z0)*(Y1-Y0)*2 => mul16d
		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

;(128-Z0)*32768/(Z1-Z0)*(Y1-Y0)*2+Y0 => mul16a
		clc
		lda	<mul16d
		adc	transform2DWork1+VY, x
		sta	<mul16a
		lda	<mul16d+1
		adc	transform2DWork1+VY+1, x
		sta	<mul16a+1

;centerY-mul16a
		sec
		lda	<centerY
		sbc	<mul16a
		sta	<clipFrontY

		lda	#0
		sbc	<mul16a+1
		sta	<clipFrontY+1

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

		inc	<frontClipCount

		bra	.clipFrontJump9

.clipFrontJump10:
		ldy	<model2DClipIndexWork

		lda	transform2DWork0+VX, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+VX+1, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+VY, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+VY+1, x
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

		inc	<frontClipCount
		inc	<frontClipCount

		bra	.clipFrontJump9

.clipFrontJump8:
		ldy	<model2DClipIndexWork

		lda	transform2DWork0+VX, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+VX+1, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+VY, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+VY+1, x
		sta	clip2D0, y
		iny

		sty	<model2DClipIndexWork

		inc	<frontClipCount

.clipFrontJump9:
		rts


;===============================================================================
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
		sbc	#DISPLAY_BOTTOM
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


;===============================================================================
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


;===============================================================================
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

		adx2	#8

		jmp	.clip2DX255Jump03


;===============================================================================
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

		adx2	#8

		jmp	.clip2DX0Jump03


;===============================================================================
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
		sbc	#DISPLAY_BOTTOM
		lda	clip2D1+3, y
		sbc	#0
		bmi	.clip2DY255Jump00
		smb0	<clip2DFlag

.clip2DY255Jump00:
		sec
		lda	clip2D1+6, y	;Y1
		sbc	#DISPLAY_BOTTOM
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
		lda	#DISPLAY_BOTTOM - 1
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

		lda	#DISPLAY_BOTTOM - 1
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

		lda	#DISPLAY_BOTTOM - 1
		sta	clip2D0+6, x	;Y1
		stz	clip2D0+7, x

		add	<clip2D0Count, #$02

		adx2	#8

		jmp	.clip2DY255Jump03


;===============================================================================
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

		adx2	#8

		jmp	.clip2DY0Jump03


;===============================================================================
; getAngle
;-------------------------------------------------------------------------------
; Description:
;   Calculates the relative rotation angles (ansAngleX, ansAngleY) required
;   to orient from the source point (X0, Y0, Z0) toward the target
;   point (X1, Y1, Z1).
;
; Inputs:
;   [angleX0] (2 byte)   : Source 3D coordinates
;   [angleY0] (2 byte)   : Source 3D coordinates
;   [angleZ0] (2 byte)   : Source 3D coordinates
;   [angleX1] (2 byte)   : Target 3D coordinates
;   [angleY1] (2 byte)   : Target 3D coordinates
;   [angleZ1] (2 byte)   : Target 3D coordinates
;
; Outputs:
;   [ansAngleX] (1 byte) : Calculated X-axis angle
;   [ansAngleY] (1 byte) : Calculated Y-axis angle
;
; Modifies:
;   A
;===============================================================================
getAngle:
		phx
		phy

		subw	<mul16a, <angleZ1, <angleZ0
		subw	<mul16b, <angleX1, <angleX0
		jsr	atan

		tax
		eor	#$FF
		inc	a
		sta	<ansAngleY

		subw	transform2DWork0+VX, <angleX1, <angleX0
		subw	transform2DWork0+VY, <angleY1, <angleY0
		subw	transform2DWork0+VZ, <angleZ1, <angleZ0
		mov	vertexCount, #1
		jsr	vertexRotationY8

		movw	<mul16a, transform2DWork0+VZ
		movw	<mul16b, transform2DWork0+VY
		jsr	atan
		sta	<ansAngleX

;ansAngleX <= $40
		cmp	#$41
		bcc	.jpAtan00

;ansAngleX >= $C0
		cmp	#$C0
		bcs	.jpAtan00

		stz	<ansAngleX

.jpAtan00:
		ply
		plx
		rts


;===============================================================================
; atan
;-------------------------------------------------------------------------------
; Description:
;   Calculates the 2-argument arctangent (atan2) of coordinates (Y/X),
;   returning an angle.
;
; Inputs:
;   [mul16a] (2 bytes) : Signed X coordinate
;   [mul16b] (2 bytes) : Signed Y coordinate
;
; Outputs:
;   A                  : Calculated angle
;
; Modifies:
;   A
;===============================================================================
atan:
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


;===============================================================================
_atan:
;mul16a = x(0 to 32767), mul16b = y(0 to 32767)
;A(0 to 64) = atan2(y/x)
		tma	#ATAN_DATA_MAP
		pha

		lda	#ATAN_DATA_BANK
		tam	#ATAN_DATA_MAP

		lda	<mul16a+1
		ora	<mul16b+1
		beq	.jp01

.jp03:
		lda	<mul16a+1
		ora	<mul16b+1
		and	#$E0
		bne	.jp02

		asl	<mul16a
		rol	<mul16a+1
		asl	<mul16b
		rol	<mul16b+1
		bra	.jp03

.jp02:
		mov	<mul16a, <mul16a+1
		mov	<mul16b, <mul16b+1

.jp01:
		lda	<mul16a
		ora	<mul16b
		and	#$C0
		beq	.jp00

		lsr	<mul16a
		lsr	<mul16b
		bra	.jp01

.jp00:
		lda	<mul16b
		stz	<mul16b
		lsr	a
		ror	<mul16b
		lsr	a
		ror	<mul16b
		sta	<mul16b+1

		lda	<mul16a
		ora	<mul16b
		sta	<mul16b
		add	<mul16b+1, #ATAN_DATA_ADDR
		lda	[mul16b]
		sta	<mul16a

		pla
		tam	#ATAN_DATA_MAP

		lda	<mul16a
		rts



;===============================================================================
; romToVram
;-------------------------------------------------------------------------------
; Description:
;   Transfers a specified block of data directly from ROM into VRAM.
;
; Inputs:
;   [argw0]  (2 bytes) : Source ROM start address
;   [argw1]  (2 bytes) : Destination VRAM target address
;   [argw2]  (2 bytes) : Transfer size in bytes
;
; Outputs:
;   VRAM               : Updated with data from ROM
;
; Modifies:
;   A
;===============================================================================
romToVram:
		movw	tiaSrc, <argw0

		st0	#$00
		movw	VDC_2, <argw1
		st0	#$02
		movw	tiaDst, #VDC_2

		movw	tiaCnt, <argw2

		jsr	tiaFunction

		rts


;===============================================================================
; setCgCharData
;-------------------------------------------------------------------------------
; Description:
;   Copies character/tile pattern data from ROM to VRAM, mapping source
;   character indices to destination character indices.
;
; Inputs:
;   [argw0]  (2 bytes) : Base ROM address of source character data
;   [argw1]  (2 bytes) : Source character number / CG index (0-2047)
;   [argw2]  (2 bytes) : Destination character number / CG index (0-2047)
;   [argw3]  (2 bytes) : Number of characters to copy (1-2048)
;
; Outputs:
;   VRAM               : Updated with specified character pattern data
;
; Modifies:
;   A
;===============================================================================
setCgCharData:
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


;===============================================================================
; setSgCharData
;-------------------------------------------------------------------------------
; Description:
;   Copies sprite character pattern data from ROM into VRAM for the
;   Sprite Generator (SG).
;
; Inputs:
;   [argw0]  (2 bytes) : Base ROM address of source sprite pattern data
;   [argw1]  (2 bytes) : Source sprite pattern number / SG index (0-1022)
;   [argw2]  (2 bytes) : Destination sprite pattern number / SG index (0-1022)
;   [argw3]  (2 bytes) : Number of sprite characters to copy (1-512)
;
; Outputs:
;   VRAM               : Updated with specified sprite pattern data
;
; Modifies:
;   A
;===============================================================================
setSgCharData:
		phx

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

		plx
		rts


;===============================================================================
setTiaTiiFunction:
;
		mov	tiaFunction, #$E3
		mov	tiaRts, #$60
		mov	tiiFunction, #$73
		mov	tiiRts, #$60
		rts


;===============================================================================
switchClearBuffer:
;switching the drawing area and clear buffer
		bbs0	<drawingNo, .jp0

		lda	#DRAWING_NO_0_ADDR
		;;;bra	.jp1
		jmp	clearBuffer

.jp0:
		lda	#DRAWING_NO_1_ADDR

;;;.jp1:
		;;;jsr	clearBuffer
		;;;rts


;===============================================================================
clearBuffer:
;clear buffer
		st0	#$00
		st1	#$00
		sta	VDC_3

		tma	#POLYGON_SUB_FUNC_MAP
		pha

		tma	#POLYGON_EDGE_FUNC_MAP
		pha

		lda	#CLEAR_FUNC_BANK
		tam	#POLYGON_SUB_FUNC_MAP

		lda	#POLYGON_SUB_FUNC_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

		st0	#$02
		st1	#$00

		jsr	clearBufferSub
		jsr	clearBufferSub

			IFDEF DISPLAY_BOTTOM_144
		jsr	clearBufferSub + (8192 - 2048)
			ELSE
		jsr	clearBufferSub
			ENDIF

		pla
		tam	#POLYGON_EDGE_FUNC_MAP

		pla
		tam	#POLYGON_SUB_FUNC_MAP

		rts


;===============================================================================
; setAllPolygonColor
;-------------------------------------------------------------------------------
; Description:
;   Sets a uniform color value across all polygons in the render buffer.
;
; Inputs:
;   [argw0]  (2 bytes) : Color data address
;
; Outputs:
;   [polygonColorP0]    : Color fields for all polygons updated
;
; Modifies:
;   A
;===============================================================================
setAllPolygonColor:
		movw	tiiSrc, <argw0
		movw	tiiDst, #polygonColorP0
		movw	tiiCnt, #128*4

		jsr	tiiFunction
		rts


;===============================================================================
; setAllPalette
;-------------------------------------------------------------------------------
; Description:
;   Loads and applies color palette data for all palette slots from the
;   specified memory address into the system palette/VCE.
;
; Inputs:
;   [argw0]  (2 bytes) : Base memory address of the palette data
;
; Outputs:
;   Palette RAM / VCE  : Updated with the new palette table
;
; Modifies:
;   A
;===============================================================================
setAllPalette:
		stzw	VCE_2

		movw	tiaSrc, <argw0
		movw	tiaDst, #VCE_4
		movw	tiaCnt, #$20*32

		jsr	tiaFunction
		rts


;===============================================================================
; initializeVdc
;-------------------------------------------------------------------------------
; Description:
;   Initializes the Video Display Controller (VDC / HuC6270). Sets up
;   screen resolution, VRAM memory mapping (BAT, SATB), display control
;   registers, and clears hardware display status.
;
; Inputs:
;   None
;
; Outputs:
;   VDC Registers      : Configured to default system display settings
;
; Modifies:
;   A
;===============================================================================
initializeVdc:
		phx
		phy

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

;set vce
		movw	VCE_0, #VCE0_INIT_DATA

;wait vsync
		st012	#$05, #$0008

.resetWait:
		tst	#$20, VDC_0
		beq	.resetWait

		st012	#$05, #$0000

		ply
		plx
		rts


;===============================================================================
clearBat:
;x:a CG
		phx
		phy

		st012	#$00, #$0000
		st0	#$02
		sta	VDC_2

		cly
.loop0:
		lda	#8
.loop1:
		stx	VDC_3
		dec	a
		bne	.loop1

		dey
		bne	.loop0

		ply
		plx
		rts


;----------------------------
			IFDEF DISPLAY_BOTTOM_144
SETBAT_DATA_COUNT	.equ	$0240
			ELSE
SETBAT_DATA_COUNT	.equ	$0300
			ENDIF
setBat:
;set BAT
		phx

;BAT0
		st012	#$00, #$0000
		st0	#$02

		movw	setBatWork, #$F200
.clearbatloop0:
		movw	VDC_2, setBatWork

		addw	setBatWork, #$0002
		cmpw	setBatWork, #$F200 + SETBAT_DATA_COUNT
		bcc	.clearbatloop0

		movw	setBatWork, #$F201
.clearbatloop1:
		movw	VDC_2, setBatWork

		addw	setBatWork, #$0002
		cmpw	setBatWork, #$F201 + SETBAT_DATA_COUNT
		bcc	.clearbatloop1

;BAT1
		st012	#$00, #$0400
		st0	#$02

		movw	setBatWork, #$F500
.clearbatloop3:
		movw	VDC_2, setBatWork

		addw	setBatWork, #$0002
		cmpw	setBatWork, #$F500 + SETBAT_DATA_COUNT
		bcc	.clearbatloop3

		movw	setBatWork, #$F501
.clearbatloop4:
		movw	VDC_2, setBatWork

		addw	setBatWork, #$0002
		cmpw	setBatWork, #$F501 + SETBAT_DATA_COUNT
		bcc	.clearbatloop4

		plx
		rts


;===============================================================================
clearSat:
;
		jsr	clearSatBuffer

		jsr	setSatToVram

;set VRAM_SATB DMA
		st012	#$13, #$0800

		rts


;===============================================================================
setInterruptDisable:
;
		sta	INTERRUPT_DISABLE_REG
		sta	<irqDisableReg
		rts


;===============================================================================
irq1PolygonFunction:
;
		lda	VDC_0
		sta	<vdpStatus

		bbr5	<vdpStatus, .jp00

		lda	<vsyncFlag
		sta	<vsyncFlagTemp

		bbr7	<vsyncFlag, .jp00

		stz	<vsyncFlag

		lda	<drawingNo
		eor	#$01
		sta	<drawingNo

		beq	.jp01

;set VRAM_SAT DMA
		st012	#$13, #$0800

;set scroll y
		st012	#$08, #$0000
		bra	.jp00

.jp01:
;set VRAM_SAT DMA
		st012	#$13, #$0900

;set scroll y
		st012	#$08, #$0100

.jp00:
		rts


;===============================================================================
clearSatBuffer:
;
		phx

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

		clc
		lda	<setBufferFirstNo
		adc	#13
		and	#63
		sta	<setBufferFirstNo
		sta	<setBufferSetNo

		plx
		rts


;===============================================================================
initializeSatBuffer:
;
		mov	<setBufferSkipNo, #$FF

		cla
		sta	<setBufferFirstNo
		sta	<setBufferSetNo

		rts


;===============================================================================
setSatBufferSkipNo:
;
;A:skip max No.
		and	#63
		sta	<setBufferSkipNo
		rts


;===============================================================================
setSatBufferAutoNo:
;set sprite data
;argw0:Y, argw1:X, argw2:pattern No., argw3:attribute
		bra	.startJp

.skipJp:
		clc
		lda	<setBufferSetNo
		adc	#7
		and	#63
		sta	<setBufferSetNo

.startJp:
		lda	<setBufferSetNo
		cmp	<setBufferSkipNo
		bmi	.skipJp
		beq	.skipJp

		jsr	setSatBuffer

		clc
		lda	<setBufferSetNo
		adc	#7
		and	#63
		sta	<setBufferSetNo

		rts


;===============================================================================
; setSatBuffer
;-------------------------------------------------------------------------------
; Description:
;   Populates a single sprite entry in the RAM Sprite Attribute Table (SAT)
;   buffer with 16-bit coordinates, pattern index, and render attributes.
;
; Inputs:
;   A                 : Sprite index / number (0 to 63)
;   [argw0] (2 bytes) : Y coordinate
;   [argw1] (2 bytes) : X coordinate
;   [argw2] (2 bytes) : Pattern number / SG index
;   [argw3] (2 bytes) : Sprite attributes (palette, priority, h-flip, v-flip)
;
; Outputs:
;   [satBuffer]       : Updated sprite entry at index A
;
; Modifies:
;   A
;===============================================================================
setSatBuffer:
		phy

		and	#63

		asl	a
		asl	a
		asl	a

		stz	<satBufferAddr+1
		rol	<satBufferAddr+1

		clc
		adc	#LOW(satBuffer)
		sta	<satBufferAddr

		lda	<satBufferAddr+1
		adc	#HIGH(satBuffer)
		sta	<satBufferAddr+1

		cly
.loop:
		lda	argw0, y
		sta	[satBufferAddr], y

		iny
		cpy	#8
		bne	.loop

		ply
		rts



;===============================================================================
; setScreenCenter
;-------------------------------------------------------------------------------
; Description:
;   Sets the 2D screen center coordinates (vanishing point) used for
;   perspective projection and coordinate transformation offset calculations.
;
; Inputs:
;   X                  : Screen center X coordinate (0 to 255)
;   Y                  : Screen center Y coordinate (0 to 255)
;
; Outputs:
;   [centerX] (1 byte) : Screen center offsets updated
;   [centerY] (1 byte) : Screen center offsets updated
;
; Modifies:
;   None
;===============================================================================
setScreenCenter:
		stx	<centerX
		sty	<centerY
		rts


;===============================================================================
; onScreen
;-------------------------------------------------------------------------------
; Description:
;   Enables the screen display (turns on BG/Sprite rendering via VDC).
;
; Inputs:
;   None
;
; Outputs:
;   VDC Control Register : Screen output enabled (Display ON)
;
; Modifies:
;   A
;===============================================================================
onScreen:
		jsr	onScreenBg
		jsr	onScreenSp
		rts



;===============================================================================
; offScreen
;-------------------------------------------------------------------------------
; Description:
;   Disables the screen display (turns off BG/Sprite rendering / blanking).
;
; Inputs:
;   None
;
; Outputs:
;   VDC Control Register : Screen output disabled (Display OFF)
;
; Modifies:
;   A
;===============================================================================
offScreen:
		jsr	offScreenBg
		jsr	offScreenSp
		rts


;===============================================================================
enableIrqVdc:
;
		st0	#$05

		lda	<vdcR05
		ora	#%00001000
		sta	<vdcR05
		sta	VDC_2

		lda	<vdcR05+1
		sta	VDC_3

		rts


;===============================================================================
disableIrqVdc:
;
		st0	#$05

		lda	<vdcR05
		and	#%11110111
		sta	<vdcR05
		sta	VDC_2

		lda	<vdcR05+1
		sta	VDC_3

		rts


;===============================================================================
setInc1Vdc:
;
		st0	#$05

		lda	<vdcR05
		sta	VDC_2

		lda	<vdcR05+1
		and	#%11100111
		sta	<vdcR05+1
		sta	VDC_3

		rts


;===============================================================================
setInc32Vdc:
;
		st0	#$05

		lda	<vdcR05
		sta	VDC_2

		lda	<vdcR05+1
		and	#%11100111
		ora	#%00001000
		sta	<vdcR05+1
		sta	VDC_3

		rts


;===============================================================================
setInc64Vdc:
;
		st0	#$05

		lda	<vdcR05
		sta	VDC_2

		lda	<vdcR05+1
		and	#%11100111
		ora	#%00010000
		sta	<vdcR05+1
		sta	VDC_3

		rts


;===============================================================================
onScreenBg:
;
		st0	#$05

		lda	<vdcR05
		ora	#%10000000
		sta	<vdcR05
		sta	VDC_2

		lda	<vdcR05+1
		sta	VDC_3

		rts


;===============================================================================
onScreenSp:
;
		st0	#$05

		lda	<vdcR05
		ora	#%01000000
		sta	<vdcR05
		sta	VDC_2

		lda	<vdcR05+1
		sta	VDC_3

		rts


;===============================================================================
offScreenBg:
;
		st0	#$05

		lda	<vdcR05
		and	#%01111111
		sta	<vdcR05
		sta	VDC_2

		lda	<vdcR05+1
		sta	VDC_3

		rts


;===============================================================================
offScreenSp:
;
		st0	#$05

		lda	<vdcR05
		and	#%10111111
		sta	<vdcR05
		sta	VDC_2

		lda	<vdcR05+1
		sta	VDC_3

		rts


;===============================================================================
; initializePolygonAndSat
;-------------------------------------------------------------------------------
; Description:
;   Initializes both the polygon render buffer and the Sprite Attribute
;   Table (SAT) buffer to prepare for a new frame.
;
; Inputs:
;   None
;
; Outputs:
;   [polyBuffer] : Cleared for incoming geometry
;   [satBuffer]  : Cleared for sprite updates
;
; Modifies:
;   A
;===============================================================================
initializePolygonAndSat:
		jsr	initializePolygonBuffer

		jsr	clearSatBuffer

		rts


;===============================================================================
initializePolygonBuffer:
;
;initialize polyBufferAddr = polyBuffer
		movw	<polyBufferAddr, #polyBuffer

;polyBufferStart NEXT ADDR = polyBufferEnd
		movw	polyBufferStart, #polyBufferEnd


;--------
			IFDEF SAMPLE_Z_MAX_ONLY

;polyBufferStart SAMPLE Z = $7FFF
		movw	polyBufferStart+2, #$7FFF

;polyBufferEnd SAMPLE Z = 0
		movw	polyBufferEnd+2, #0

;--------
			ELSE
;--------

;polyBufferStart SAMPLE Z = 16384
		movw	polyBufferStart+2, #16384

;polyBufferEnd SAMPLE Z = -16384
		movw	polyBufferEnd+2, #-16384

			ENDIF
;--------

;polyBufferEnd COLOR = $00
		stz	polyBufferEnd+4

;polyBufferEnd COUNT = $00
		stz	polyBufferEnd+5

		rts


;===============================================================================
setSystemConfig:
;
		sta	<systemConfig
		rts


;===============================================================================
initializeScreenVsync:
;
		stzw	<vdcR05
		st012	#$05, #$0000

;clear vsync flag
		stz	<vsyncFlag

;set drawing No.0
		mov	<drawingNo, #DRAWING_NO_0

;set scroll x
		st012	#$07, #$0000

;set scroll y
		st012	#$08, #$0100

		rts


;===============================================================================
; putPolygonWithVsync
;-------------------------------------------------------------------------------
; Description:
;   Executes the frame rendering sequence synchronized with VSYNC:
;     1. Waits for vertical blanking interval (VSYNC).
;     2. Transfers local SAT buffer to VDC VRAM (SATB DMA).
;     3. Flips active VRAM display buffers and clears back buffer.
;     4. Renders/draws buffered polygon geometry.
;
; Inputs:
;   [polyBuffer]    : Polygon data prepared for the current frame
;   [satBuffer]     : Sprite Attribute Table data prepared for VRAM transfer
;
; Outputs:
;   VDC VRAM        : Updated with new SAT data and freshly rendered polygons
;
; Modifies:
;   A
;===============================================================================
putPolygonWithVsync:
		jsr	waitScreenVsync

		jsr	setSatToVram

		jsr	switchClearBuffer

		jsr	putPolygonBuffer

		rts


;===============================================================================
waitScreenVsync:
;Access to VRAM should be done after this function.
.waitloop0:
		bbs7	<vsyncFlag, .waitloop0
		rts


;===============================================================================
setSatToVram:
;
;set vram addr
		bbs0	<drawingNo, .jp00

		st012	#$00, #$0800
		bra	.jp01

.jp00:
		st012	#$00, #$0900

.jp01:
;transfer sat to VRAM
		st0	#$02
		tia	satBuffer, VDC_2, 512

		rts


;===============================================================================
; setVsyncFlag
;-------------------------------------------------------------------------------
; Description:
;   Sets the frame completion flag (vsyncFlag) to indicate that all frame
;   rendering is finished, signaling the V-Blank handler/main loop to proceed.
;
; Inputs:
;   None
;
; Outputs:
;   [vsyncFlag] : Set to $80 (Frame render completed)
;
; Modifies:
;   A
;===============================================================================
setVsyncFlag:
		smb7	<vsyncFlag
		rts


;===============================================================================
initializeRandom:
;
		lda	#$C0
		sta	randomSeed
		sta	randomSeed+1
		rts


;===============================================================================
; getRandom
;-------------------------------------------------------------------------------
; Description:
;   Generates the next pseudo-random byte using the internal PRNG state
;   and updates the seed for subsequent calls.
;
; Inputs:
;   None
;
; Outputs:
;   A               : Generated 8-bit pseudo-random value (0 to 255)
;
; Modifies:
;   A
;===============================================================================
getRandom:
		lda	randomSeed+1
		lsr	a
		rol	randomSeed
		bcc	.getrandomJump
		eor	#$B4
.getrandomJump:
		sta	randomSeed+1
		eor	randomSeed

		rts


;===============================================================================
; numToChar
;-------------------------------------------------------------------------------
; Description:
;   Converts a 4-bit numeric value ($0-$F) into its corresponding ASCII/font
;   character code ('0'-'9', 'A'-'F').
;
; Inputs:
;   A               : 4-bit numeric value ($00 to $0F)
;
; Outputs:
;   A               : ASCII character code
;                     - '0' to '9' ($30 to $39)
;                     - 'A' to 'F' ($41 to $46)
;
; Modifies:
;   A
;===============================================================================
numToChar:
		sed
		clc
		adc	#$90
		adc	#$40
		cld

		rts


;===============================================================================
; setCgToSgData
;-------------------------------------------------------------------------------
; Description:
;   Transfers an 8x8 Character Generator (CG) tile from ROM into a specified
;   quadrant (top-left, bottom-left, top-right, or bottom-right) of a 16x16
;   Sprite Generator (SG) pattern in VRAM.
;
; Inputs:
;   [argw0] (2 bytes) : ROM source base address
;   [argw1] (2 bytes) : Source CG tile index (0 to 2047)
;   [argw2] (2 bytes) : Destination SG pattern index (0 to 1022)
;   [arg6]  (1 byte)  : Target quadrant position inside the 16x16 sprite
;                       - $00 : Top-Left
;                       - $01 : Top-Right
;                       - $02 : Bottom-Left
;                       - $03 : Bottom-Right
;
; Outputs:
;   VRAM (SG Region)  : Specified 16x16 SG quadrant updated with 8x8 CG tile
;
; Modifies:
;   A
;===============================================================================
setCgToSgData:
		phx
		phy

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
		ply
		plx
		rts


;===============================================================================
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


;===============================================================================
; setWriteVramAddress
;-------------------------------------------------------------------------------
; Description:
;   Calculates the VRAM memory address corresponding to the specified 2D
;   screen coordinates (X, Y) and configures the VDC VRAM write address
;   register (VWR / MAR).
;
; Inputs:
;   X                 : X coordinate (Tile/Screen X position)
;   Y                 : Y coordinate (Tile/Screen Y position)
;
; Outputs:
;   VDC Registers      : VRAM write target address set to position (X, Y)
;
; Modifies:
;   A
;===============================================================================
setWriteVramAddress:
		phx
		phy

		jsr	calcBatAddressXY

		st0	#$00
		sty	VDC_2

		bbs0	<drawingNo, .jp0

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


;===============================================================================
; setVramData
;-------------------------------------------------------------------------------
; Description:
;   Writes a 16-bit data word (A: Low byte, X: High byte) to the current VRAM
;   address via the VDC data port.
;
; Inputs:
;   A               : Low byte of 16-bit VRAM data
;   X               : High byte of 16-bit VRAM data
;
; Outputs:
;   VRAM Data Port  : 16-bit word written to VRAM (address auto-increments)
;
; Modifies:
;   None
;===============================================================================
setVramData:
		st0	#$02
		sta	VDC_2
		stx	VDC_3

		rts


;===============================================================================
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


;===============================================================================
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


;===============================================================================
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
		.bank	POLYGON_SUB_FUNC_BANK
		.org	$4000

;----------------------------
;for clearBuffer function
		rts


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
		cmp	#DISPLAY_BOTTOM
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
		cmpw	<circleX, <circleY
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

		cpy	#DISPLAY_BOTTOM
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

		cpy	#DISPLAY_BOTTOM
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

		cpy	#DISPLAY_BOTTOM
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

		cpy	#DISPLAY_BOTTOM
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
		bcc	.jpRightEdge

;calculation left edge
;calculation slope Y
		sbc	<edgeY0
		sta	<edgeSlopeY

;calculation slope X
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
;set bank
		lda	#EDGE_FUNC_L_0_1_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeJump10L

;edgeSigneX plus
		jmp	calcEdgeL0

;edgeSigneX minus
.edgeJump10L:
		jmp	calcEdgeL1

.edgeJump4L:
;edgeSlopeY >= edgeSlopeX
;set bank
		lda	#EDGE_FUNC_L_2_3_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeYLoop8L

;edgeSigneX plus
		jmp	calcEdgeL2

;edgeSigneX minus
.edgeYLoop8L:
		jmp	calcEdgeL3

.jpRightEdge:
;calculation right edge
;edgeY0 > edgeY1 swap X0 and X1
		lda	<edgeX0
		ldx	<edgeX1
		sta	<edgeX1
		stx	<edgeX0

;calculation slope Y
		sec
		lda	<edgeY0
		sbc	<edgeY1
		sta	<edgeSlopeY

;calculation slope X
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

;edgeSlopeX > edgeSlopeY
;set bank
		lda	#EDGE_FUNC_R_0_1_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeJump10R

;edgeSigneX plus
		jmp	calcEdgeR0

;edgeSigneX minus
.edgeJump10R:
		jmp	calcEdgeR1

.edgeJump4R:
;edgeSlopeY >= edgeSlopeX
;set bank
		lda	#EDGE_FUNC_R_2_3_BANK
		tam	#POLYGON_EDGE_FUNC_MAP

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeYLoop8R

;edgeSigneX plus
		jmp	calcEdgeR2

;edgeSigneX minus
.edgeYLoop8R:
		jmp	calcEdgeR3


;----------------------------
putPolyLine:
;put horizontal lines
		inc	<maxEdgeY

		mov	<polyLineColorDataWork0, polyLineColorWork_H_P0
		mov	<polyLineColorDataWork1, polyLineColorWork_H_P1
		mov	<polyLineColorDataWork2, polyLineColorWork_H_P2
		mov	<polyLineColorDataWork3, polyLineColorWork_H_P3

		lda	<minEdgeY
		inc	a
		and	#$FE
		tay

		bbs0	<drawingNo, .jp4
		jsr	putPolyLineProc0
		bra	.jp5
.jp4:
		jsr	putPolyLineProc1

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

		bbs0	<drawingNo, .jp6
		jsr	putPolyLineProc0
		bra	.jp3
.jp6:
		jsr	putPolyLineProc1

.jp3:
		rts


;----------------------------
putPolyLineProc0:
;put horizontal line
		bra	.loopStart

.jpRts:
		rts

.jpSwap:
;swap left and right
		beq	.jp0
		ldx	edgeRight, y
		sta	edgeRight, y
		txa
		sta	edgeLeft, y
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

;compare left and right values
		lda	edgeLeft, y
		cmp	edgeRight, y
		bcs	.jpSwap

;calculation left counts
.jp0:
		lsr	a
		lsr	a
		lsr	a
		sta	<polyLineCount

;calculation left vram address
		tax

		lda	polyLineAddrConvXHigh, x
		ora	polyLineAddrConvYHigh0, y
		sta	<polyLineLeftAddr+1

		lda	polyLineAddrConvXLow, x
		ora	polyLineAddrConvYLow, y
		pha

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
		ldx	edgeLeft, y

		lda	polyLineLeftDatas, x
		sta	<polyLineLeftData
		eor	#$FF
		sta	<polyLineLeftMask

;calculation counts
		lda	edgeRight, y
		lsr	a
		lsr	a
		lsr	a
		tax
		sec
		sbc	<polyLineCount
		beq	.jpCount0

;center jump index
		asl	a
		sta	<polyLineJumpIndex

;right address
		lda	polyLineAddrConvXLow, x
		ora	polyLineAddrConvYLow, y
		sta	<polyLineRightAddr

		lda	polyLineAddrConvXHigh, x
		ora	polyLineAddrConvYHigh0, y
		sta	<polyLineRightAddr+1

;put right data
		ldx	edgeRight, y

		lda	polyLineRightDatas, x
		sta	<polyLineRightData
		eor	#$FF
		sta	<polyLineRightMask

;put line process
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

		ldx	<polyLineJumpIndex

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
		st0	#$01
		lda	<polyLineRightAddr
		sta	VDC_2
		lda	<polyLineRightAddr+1
		sta	VDC_3

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
		pla
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

		ldx	<polyLineJumpIndex

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
		st0	#$01
		lda	<polyLineRightAddr
		ora	#$08
		sta	VDC_2
		lda	<polyLineRightAddr+1
		sta	VDC_3

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

;loop jump
		jmp	.loop0

.jpCount0Pg:
;count 0 then
;put line same address
		ldx	edgeRight, y
		lda	polyLineRightDatas, x
		ldx	edgeLeft, y
		and	polyLineLeftDatas, x

		sta	<polyLineMask0
		eor	#$FF
		sta	<polyLineMask1

;CH0 CH1
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

;CH2 CH3
		pla
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
putPolyLineProc1:
;put horizontal line
		bra	.loopStart

.jpRts:
		rts

.jpSwap:
;swap left and right
		beq	.jp0
		ldx	edgeRight, y
		sta	edgeRight, y
		txa
		sta	edgeLeft, y
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

;compare left and right values
		lda	edgeLeft, y
		cmp	edgeRight, y
		bcs	.jpSwap

;calculation left counts
.jp0:
		lsr	a
		lsr	a
		lsr	a
		sta	<polyLineCount

;calculation left vram address
		tax

		lda	polyLineAddrConvXHigh, x
		ora	polyLineAddrConvYHigh1, y
		sta	<polyLineLeftAddr+1

		lda	polyLineAddrConvXLow, x
		ora	polyLineAddrConvYLow, y
		pha

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
		ldx	edgeLeft, y

		lda	polyLineLeftDatas, x
		sta	<polyLineLeftData
		eor	#$FF
		sta	<polyLineLeftMask

;calculation counts
		lda	edgeRight, y
		lsr	a
		lsr	a
		lsr	a
		tax
		sec
		sbc	<polyLineCount
		beq	.jpCount0

;center jump index
		asl	a
		sta	<polyLineJumpIndex

;right address
		lda	polyLineAddrConvXLow, x
		ora	polyLineAddrConvYLow, y
		sta	<polyLineRightAddr

		lda	polyLineAddrConvXHigh, x
		ora	polyLineAddrConvYHigh1, y
		sta	<polyLineRightAddr+1

;put right data
		ldx	edgeRight, y

		lda	polyLineRightDatas, x
		sta	<polyLineRightData
		eor	#$FF
		sta	<polyLineRightMask

;put line process
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

		ldx	<polyLineJumpIndex

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
		st0	#$01
		lda	<polyLineRightAddr
		sta	VDC_2
		lda	<polyLineRightAddr+1
		sta	VDC_3

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
		pla
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

		ldx	<polyLineJumpIndex

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
		st0	#$01
		lda	<polyLineRightAddr
		ora	#$08
		sta	VDC_2
		lda	<polyLineRightAddr+1
		sta	VDC_3

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

;loop jump
		jmp	.loop0

.jpCount0Pg:
;count 0 then
;put line same address
		ldx	edgeRight, y
		lda	polyLineRightDatas, x
		ldx	edgeLeft, y
		and	polyLineLeftDatas, x

		sta	<polyLineMask0
		eor	#$FF
		sta	<polyLineMask1

;CH0 CH1
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

;CH2 CH3
		pla
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
			IFDEF DISPLAY_BOTTOM_144
;----------------------------
polyLineAddrConvYHigh0:
		.db	$20, $20, $20, $20, $20, $20, $20, $20, $24, $24, $24, $24, $24, $24, $24, $24,\
			$28, $28, $28, $28, $28, $28, $28, $28, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C,\
			$30, $30, $30, $30, $30, $30, $30, $30, $34, $34, $34, $34, $34, $34, $34, $34,\
			$38, $38, $38, $38, $38, $38, $38, $38, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C,\
			$40, $40, $40, $40, $40, $40, $40, $40

		.db	$20, $20, $20, $20, $20, $20, $20, $20, $24, $24, $24, $24, $24, $24, $24, $24,\
			$28, $28, $28, $28, $28, $28, $28, $28, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C,\
			$30, $30, $30, $30, $30, $30, $30, $30, $34, $34, $34, $34, $34, $34, $34, $34,\
			$38, $38, $38, $38, $38, $38, $38, $38, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C,\
			$40, $40, $40, $40, $40, $40, $40, $40


;----------------------------
polyLineAddrConvYHigh1:
		.db	$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C,\
			$60, $60, $60, $60, $60, $60, $60, $60, $64, $64, $64, $64, $64, $64, $64, $64,\
			$68, $68, $68, $68, $68, $68, $68, $68, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C,\
			$70, $70, $70, $70, $70, $70, $70, $70

		.db	$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C,\
			$60, $60, $60, $60, $60, $60, $60, $60, $64, $64, $64, $64, $64, $64, $64, $64,\
			$68, $68, $68, $68, $68, $68, $68, $68, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C,\
			$70, $70, $70, $70, $70, $70, $70, $70


;----------------------------
polyLineAddrConvYLow:
		.db	$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07

		.db	$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17


;----------------------------
			ELSE
;----------------------------
polyLineAddrConvYHigh0:
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
polyLineAddrConvYHigh1:
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
			ENDIF
;----------------------------


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


;----------------------------
		.org	$5000
		INCBIN	"atan.dat"		;  4K


;////////////////////////////
		.bank	EDGE_FUNC_L_0_1_BANK
		INCLUDE	"poly_edgeL0_1.asm"	;  8K


;////////////////////////////
		.bank	EDGE_FUNC_L_2_3_BANK
		INCLUDE	"poly_edgeL2_3.asm"	;  8K


;////////////////////////////
		.bank	EDGE_FUNC_R_0_1_BANK
		INCLUDE	"poly_edgeR0_1.asm"	;  8K


;////////////////////////////
		.bank	EDGE_FUNC_R_2_3_BANK
		INCLUDE	"poly_edgeR2_3.asm"	;  8K


;////////////////////////////
		.bank	CLEAR_FUNC_BANK
		.org	$4000

clearBufferSub:
		INCBIN	"clear.dat"		;  8K


;////////////////////////////
		.bank	MUL_DATA_BANK
		INCBIN	"mul.dat"		;128K


;////////////////////////////
		.bank	DIV_DATA_BANK
			IFDEF SCREEN_Z192
		INCBIN	"div_z192.dat"		; 64K

			ELSE

			IFDEF SCREEN_Z220
		INCBIN	"div_z220.dat"		; 64K

			ELSE

		INCBIN	"div_z128.dat"		; 64K
			ENDIF

			ENDIF
