;sample2.asm
;///////////////////////////
;////////  INCLUDE  ////////
;///////////////////////////
;---------------------
		INCLUDE	"poly_inc.asm"


;///////////////////////////
;//////// ZERO PAGE ////////
;///////////////////////////
		.zp
;---------------------
rot_z		.ds	1


;///////////////////////////
;////////    BSS    ////////
;///////////////////////////
		.bss
;---------------------
;to use matrix
;mtx0		MATRIX_DATA
;mtx1		MATRIX_DATA
;mtx2		MATRIX_DATA

;---------------------
		INCLUDE	"poly_ds.asm"


;///////////////////////////
;////////    ROM    ////////
;///////////////////////////
;----------------------------
;--------    CODE    --------
;----------------------------
		.code

		.bank	0
		.org	$E000

;----------------------------
main:
;
		lda	#POLYGON_FUNC_BANK
		tam	#POLYGON_FUNC_MAP

		jsr	initializePolygonFunction

		movw	<argw0, #paletteData
		jsr	setAllPalette

		movw	<argw0, #polygonColor
		jsr	setAllPolygonColor

		jsr	initializeScreenVsync

		ldx	#128
		ldy	#96
		jsr	setScreenCenter

		stz	<rot_z

		jsr	onScreen

		jsr	enableIrqVdc

		cli

;----------------
;example: without matrix
.mainLoop:
		jsr	initializePolygonAndSat

		lda	#0
		jsr	setPolygonColorIndex

		movw	<eyeTranslationX, #0
		movw	<eyeTranslationY, #0
		movw	<eyeTranslationZ, #0
		mov	<eyeRotationX, #0
		mov	<eyeRotationY, #0
		mov	<eyeRotationZ, #0
		mov	<eyeRotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y

		movw	<translationX, #0
		movw	<translationY, #0
		movw	<translationZ, #200
		mov	<rotationX, #32
		mov	<rotationY, #64
		mov	<rotationZ, <rot_z
		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y
		movw	<modelAddress, #modelData
		jsr	setModelRotation

		jsr	putPolygonWithVsync

		inc	<rot_z

		jmp	.mainLoop


;----------------
;example: using matrix
;.mainLoop:
;		jsr	initializePolygonAndSat
;
;		lda	#0
;		jsr	setPolygonColorIndex
;
;		movw	<matrix0, #mtx0
;		ldx	<rot_z
;		jsr	setMatrixRotationZ
;
;		movw	<matrix0, #mtx1
;		ldx	#32
;		jsr	setMatrixRotationX
;
;		movw	<matrix0, #mtx0
;		movw	<matrix1, #mtx1
;		movw	<matrix2, #mtx2
;		jsr	matrixMultiply
;
;		movw	<matrix0, #mtx1
;		ldx	#64
;		jsr	setMatrixRotationY
;
;		movw	<matrix0, #mtx2
;		movw	<matrix1, #mtx1
;		movw	<matrix2, #mtx0
;		jsr	matrixMultiply
;
;		movw	<vertex0, modelData + MODEL_VERTEX_ADDR
;		movw	<matrix1, #mtx0
;		movw	<vertex2, #vertexDataTemp
;		mov	<vertexCount, modelData + MODEL_VERTEX_COUNT
;		jsr	vertexMultiplyDatas
;
;		movw	<translationX, #0
;		movw	<translationY, #0
;		movw	<translationZ, #200
;		mov	<vertexCount, modelData + MODEL_VERTEX_COUNT
;		jsr	vertexTranslationDatas
;
;		movw	<modelAddress, #modelData
;		jsr	setModel
;
;		jsr	putPolygonWithVsync
;
;		inc	<rot_z
;
;		jmp	.mainLoop


;----------------------------
irq1Function:
;
		bbr5	<vdpStatus, .skip

		jsr	getPadData

.skip:
		rts


;----------------------------
_irq1:
;
		IRQ_ENTRY

		jsr	irq1PolygonFunction

		jsr	irq1Function

		IRQ_EXIT


;----------------------------
_timer:
;
		IRQ_ENTRY

		stz	INTERRUPT_STATE_REG

		jsr	timerPlayDdaFunction

		IRQ_EXIT


;----------------------------
_irq2:
_nmi:
;
		IRQ_ENTRY

		IRQ_EXIT


;----------------------------
_reset:
;
		RESET_PROCESS

;jump main
		jmp	main


;----------------------------
;--------    DATA    --------
;----------------------------
;----------------------------
polygonColor:
;128 pattern
		;CH0
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $00, $00, $FF, $00, $FF, $00, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $00, $00, $FF, $00, $FF, $00, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF

		;CH1
		.db	$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF
		.db	$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF

		;CH2
		.db	$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF
		.db	$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF

		;CH3
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $AA, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $FF, $FF, $FF, $FF
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $AA, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $FF, $FF, $FF, $FF


;----------------------------
paletteData:
;0000000G GGRRRBBB
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF


;----------------------------
modelData
		MODEL_DATA	modelDataPolygon, 13, modelDataVertex, 13

modelDataPolygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00,  0,  1,  2,  3	;center bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $04, $00,  0,  3,  4		;center front left
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00,  0,  4,  1		;center front right
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $08, $00,  4,  3,  2		;center back left
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00,  4,  2,  1		;center back right

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $08, $00,  5,  7,  6		;right center
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00,  5,  6,  8		;right front top
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00,  5,  8,  7		;right front bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $09, $00,  6,  7,  8		;right back

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $08, $00,  9, 10, 11		;left center
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00,  9, 12, 10		;left front top
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00,  9, 11, 12		;left front bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $09, $00, 10, 12, 11		;left back

modelDataVertex
		VERTEX_DATA	    0,    0,  100	;0
		VERTEX_DATA	   25,    0,    0	;1
		VERTEX_DATA	    0,    0,  -50	;2
		VERTEX_DATA	  -25,    0,    0	;3
		VERTEX_DATA	    0,   25,    0	;4

		VERTEX_DATA	   40,    0,  100	;5
		VERTEX_DATA	   40,   25,  -50	;6
		VERTEX_DATA	   40,  -25,  -50	;7
		VERTEX_DATA	   65,    0,  -15	;8

		VERTEX_DATA	  -40,    0,  100	;9
		VERTEX_DATA	  -40,   25,  -50	;10
		VERTEX_DATA	  -40,  -25,  -50	;11
		VERTEX_DATA	  -65,    0,  -15	;12


;///////////////////////////
;////////   DATAS   ////////
;///////////////////////////
		INCLUDE	"poly_datas.asm"


;----------------------------
		.org	$FFF6

		.dw	_irq2
		.dw	_irq1
		.dw	_timer
		.dw	_nmi
		.dw	_reset


;///////////////////////////
;//////// FUNCTIONS ////////
;///////////////////////////
		INCLUDE	"poly_proc.asm"
