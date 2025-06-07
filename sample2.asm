;sample2.asm
;///////////////////////////
;////////  DEFINE   ////////
;///////////////////////////
;---------------------
;System parameters
SAMPLE_Z_MAX_ONLY	;Z sample 'maximum only'
DISPLAY_BOTTOM_192	;bottom line '192'
SCREEN_Z128		;screen position '128'
VCE_5M			;VCE clock '5M'
SCREEN_256_240_B	;screen dots '256 * 240'
ENABLE_SHADING		;flat shading 'enable'
BRIGHT_CONVERT_8_8	;'8brightnesses 8colors'


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
modelRotaionZ	.ds	1
lightRotaionXZ	.ds	1


;///////////////////////////
;////////    BSS    ////////
;///////////////////////////
		.bss
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
		SET_POLYGON_FUNCTION

		jsr	initializePolygonFunction

		movw	<argw0, #paletteData
		jsr	setAllPalette

		movw	<argw0, #polygonColor
		jsr	setAllPolygonColor

		jsr	initializeScreenVsync

		ldx	#128
		ldy	#96
		jsr	setScreenCenter

		stz	<modelRotaionZ
		stz	<lightRotaionXZ

		jsr	onScreen

		jsr	enableIrqVdc

		cli

;----------------
.mainLoop:
		inc	<modelRotaionZ
		add	<lightRotaionXZ, #2

		movw	vertexDataWork+VX, #0
		movw	vertexDataWork+VY, #16384
		movw	vertexDataWork+VZ, #0

		mov	<rotationX, <lightRotaionXZ
		mov	<rotationY, #0
		mov	<rotationZ, <lightRotaionXZ
		mov	<vertexCount, #1
		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y
		jsr	orderVertexRotation8

		movw	<lightVectorX, vertexDataWork+VX
		movw	<lightVectorY, vertexDataWork+VY
		movw	<lightVectorZ, vertexDataWork+VZ

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

		lda	<lightVectorX+1
		sta	<translationX
		jsr	signExt
		asl	<translationX
		rol	a
		sta	<translationX+1

		lda	<lightVectorY+1
		sta	<translationY
		jsr	signExt
		asl	<translationY
		rol	a
		sta	<translationY+1

		lda	<lightVectorZ+1
		sta	<translationZ
		jsr	signExt
		asl	<translationZ
		rol	a
		sta	<translationZ+1

		addw	<translationZ, #200
		mov	<rotationX, #0
		mov	<rotationY, #0
		mov	<rotationZ, #0
		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y
		movw	<modelAddress, #modelLightData
		jsr	setModelRotation

		movw	<translationX, #0
		movw	<translationY, #0
		movw	<translationZ, #200
		mov	<rotationX, #32
		mov	<rotationY, #64
		mov	<rotationZ, <modelRotaionZ
		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y
		movw	<modelAddress, #modelData
		jsr	setModelRotation

		jsr	putPolygonWithVsync

		jsr	setVsyncFlag

		jmp	.mainLoop


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
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $88, $88, $88, $88, $00, $00, $00, $00,\
			$AA, $AA, $AA, $AA, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00,\
			$55, $55, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$AA, $AA, $AA, $AA, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

		;CH1
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$AA, $AA, $AA, $AA, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00,\
			$FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

		;CH2
		.db	$00, $FF, $00, $FF, $00, $00, $00, $00, $00, $FF, $00, $FF, $00, $00, $00, $00,\
			$00, $FF, $00, $FF, $00, $00, $00, $00, $00, $FF, $00, $FF, $00, $00, $00, $00,\
			$00, $FF, $00, $FF, $00, $00, $00, $00, $00, $FF, $00, $FF, $00, $00, $00, $00,\
			$00, $FF, $00, $FF, $00, $00, $00, $00, $00, $FF, $00, $FF, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

		;CH3
		.db	$00, $00, $FF, $FF, $00, $00, $00, $00, $00, $00, $FF, $FF, $00, $00, $00, $00,\
			$00, $00, $FF, $FF, $00, $00, $00, $00, $00, $00, $FF, $FF, $00, $00, $00, $00,\
			$00, $00, $FF, $FF, $00, $00, $00, $00, $00, $00, $FF, $FF, $00, $00, $00, $00,\
			$00, $00, $FF, $FF, $00, $00, $00, $00, $00, $00, $FF, $FF, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
paletteData:
;0000000G GGRRRBBB
		.dw	$0187, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
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
		.dw	$0000, $0092, $0124, $01B6, $0008, $0018, $0028, $0038,\
			$0001, $0003, $0005, $0007, $0049, $00DB, $016D, $01FF

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
		MODEL_DATA	modelDataPolygon, 13, modelDataVertex, 13, modelDataVector

modelDataPolygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $03, $00,  0,  1,  2,  3	;center bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $02, $00,  0,  3,  4		;center front left
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $02, $00,  0,  4,  1		;center front right
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $03, $00,  4,  3,  2		;center back left
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $03, $00,  4,  2,  1		;center back right

		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $03, $00,  5,  7,  6		;right center
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $03, $00,  5,  6,  8		;right front top
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $03, $00,  5,  8,  7		;right front bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $01, $00,  6,  7,  8		;right back

		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $03, $00,  9, 10, 11		;left center
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $03, $00,  9, 12, 10		;left front top
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $03, $00,  9, 11, 12		;left front bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_SHADING, $01, $00, 10, 12, 11		;left back

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

modelDataVector
		VECTOR_DATA	     0, -16384,      0
		VECTOR_DATA	-11408,  11408,   2852
		VECTOR_DATA	 11408,  11408,   2852
		VECTOR_DATA	-10923,  10923,  -5461
		VECTOR_DATA	 10923,  10923,  -5461
		VECTOR_DATA	-16384,      0,      0
		VECTOR_DATA	  9882,  12890,   2148
		VECTOR_DATA	  9882, -12890,   2148
		VECTOR_DATA	 13332,      0,  -9523
		VECTOR_DATA	 16384,      0,      0
		VECTOR_DATA	 -9882,  12890,   2148
		VECTOR_DATA	 -9882, -12890,   2148
		VECTOR_DATA	-13332,      0,  -9523


;----------------------------
modelLightData
		MODEL_DATA	modelLightDataPolygon, 1, modelLightDataVertex, 1, 0

modelLightDataPolygon
		POLYGON_DATA	ATTR_CIRCLE, $39, 10, 0

modelLightDataVertex
		VERTEX_DATA	     0,      0,      0


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
