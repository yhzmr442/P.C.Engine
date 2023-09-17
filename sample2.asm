;sample2.asm
;///////////////////////////
;////////    EQU    ////////
;///////////////////////////
;---------------------
		INCLUDE	"poly_equ.asm"


;///////////////////////////
;////////   MACRO   ////////
;///////////////////////////
;---------------------
		INCLUDE	"poly_macro.asm"


;///////////////////////////
;////////    RAM    ////////
;///////////////////////////
		.zp
;---------------------
		INCLUDE	"poly_dszp.asm"

;---------------------
rot_z		.ds	1


;///////////////////////////
		.bss
;---------------------
mtx0		MATRIX_AREA
mtx1		MATRIX_AREA
mtx2		MATRIX_AREA

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

.mainLoop:
		jsr	initializePolygonBuffer

		jsr	clearSatBuffer

		lda	#0
		jsr	setPolygonColorIndex

;----------------
;example of using a matrix
		movw	<matrix0, #mtx0
		ldx	<rot_z
		jsr	setMatrixRotationZ

		movw	<matrix0, #mtx1
		ldx	#32
		jsr	setMatrixRotationX

		movw	<matrix0, #mtx0
		movw	<matrix1, #mtx1
		movw	<matrix2, #mtx2
		jsr	matrixMultiply

		movw	<matrix0, #mtx1
		ldx	#64
		jsr	setMatrixRotationY

		movw	<matrix0, #mtx2
		movw	<matrix1, #mtx1
		movw	<matrix2, #mtx0
		jsr	matrixMultiply

		movw	<vertex0, modelData100+MODEL_VERTEX_ADDR
		movw	<matrix1, #mtx0
		movw	<vertex2, #vertexDataTemp
		mov	<vertexCount, modelData100+MODEL_VERTEX_COUNT
		jsr	vertexMultiplyDatas

		movw	<translationX, #0
		movw	<translationY, #0
		movw	<translationZ, #200
		mov	<vertexCount, modelData100+MODEL_VERTEX_COUNT
		jsr	vertexTranslationDatas

		movw	<modelAddress, #modelData100
		jsr	setModel

;----------------
;example without matrix
;		movw	<eyeTranslationX, #0
;		movw	<eyeTranslationY, #0
;		movw	<eyeTranslationZ, #0
;		mov	<eyeRotationX, #0
;		mov	<eyeRotationY, #0
;		mov	<eyeRotationZ, #0
;		mov	<eyeRotationSelect, #$12
;
;		movw	<translationX, #0
;		movw	<translationY, #0
;		movw	<translationZ, #200
;		mov	<rotationX, #32
;		mov	<rotationY, #64
;		mov	<rotationZ, <rot_z
;		mov	<rotationSelect, #ROT_FIRST_Z+ROT_SECOND_X+ROT_THIRD_Y
;
;		movw	<modelAddress, #modelData100
;		jsr	setModelRotation

		inc	<rot_z

		jsr	waitScreenVsync

		jsr	setSatToVram

		jsr	switchClearBuffer

		jsr	putPolygonBuffer

		jsr	setVsyncFlag

		jmp	.mainLoop


;----------------------------
vsyncFunction:
;
		rts


;----------------------------
_irq1:
;
		irqEntry

		jsr	irq1PolygonFunction

		bbr5	<vdpStatus, .skip
		jsr	vsyncFunction

.skip:
		irqExit


;----------------------------
_reset:
;
		macroReset

;jump main
		jmp	main


;----------------------------
_irq2:
_nmi:
_timer:
;
		rti


;----------------------------
;--------    DATA    --------
;----------------------------
;----------------------------

;----------------
polygonColor:
		;plane0 8bit*128
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $00, $00, $FF, $00, $FF, $00, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $00, $00, $FF, $00, $FF, $00, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF

		;plane1 8bit*128
		.db	$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF
		.db	$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF

		;plane2 8bit*128
		.db	$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF
		.db	$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF

		;plane3 8bit*128
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
modelData100
		MODEL_DATA	modelData100Polygon, 13, modelData100Vertex, 13

modelData100Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00, 0, 1, 2, 3	;center bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $04, $00, 0, 3, 4	;center front left
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 0, 4, 1	;center front right
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $08, $00, 4, 3, 2	;center back left
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 4, 2, 1	;center back right

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $08, $00, 5, 7, 6	;right center
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 5, 6, 8	;right front top
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00, 5, 8, 7	;right front bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $09, $00, 6, 7, 8	;right back

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $08, $00, 9,10,11	;left center
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 9,12,10	;left front top
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00, 9,11,12	;left front bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $09, $00,10,12,11	;left back

modelData100Vertex
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


;////////////////////////////
		INCLUDE	"poly_datas.asm"


;----------------------------
		.org	$FFF6

		.dw	_irq2
		.dw	_irq1
		.dw	_timer
		.dw	_nmi
		.dw	_reset


;////////////////////////////
		INCLUDE	"poly_proc.asm"
