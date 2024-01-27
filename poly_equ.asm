;poly_equ.asm
;//////////////////////////////////
;----------------------------
VDC_0			.equ	$0000
VDC_1			.equ	$0001
VDC_2			.equ	$0002
VDC_3			.equ	$0003

VDC1			.equ	1
VDC1_0			.equ	VDC_0
VDC1_1			.equ	VDC_1
VDC1_2			.equ	VDC_2
VDC1_3			.equ	VDC_3

VDC2			.equ	2
VDC2_0			.equ	$0010
VDC2_1			.equ	$0011
VDC2_2			.equ	$0012
VDC2_3			.equ	$0013

VPC_0			.equ	$0008
VPC_1			.equ	$0009
VPC_2			.equ	$000A
VPC_3			.equ	$000B
VPC_4			.equ	$000C
VPC_5			.equ	$000D
VPC_6			.equ	$000E
VPC_7			.equ	$000F

VCE_0			.equ	$0400
VCE_1			.equ	$0401
VCE_2			.equ	$0402
VCE_3			.equ	$0403
VCE_4			.equ	$0404
VCE_5			.equ	$0405
VCE_6			.equ	$0406
VCE_7			.equ	$0407

PSG_0			.equ	$0800
PSG_1			.equ	$0801
PSG_2			.equ	$0802
PSG_3			.equ	$0803
PSG_4			.equ	$0804
PSG_5			.equ	$0805
PSG_6			.equ	$0806
PSG_7			.equ	$0807
PSG_8			.equ	$0808
PSG_9			.equ	$0809

TIMER_COUNTER_REG	.equ	$0C00
TIMER_CONTROL_REG	.equ	$0C01

INTERRUPT_DISABLE_REG	.equ	$1402
INTERRUPT_STATE_REG	.equ	$1403

IO_REG			.equ	$1000

;----------------------------
POLYGON_FUNC_BANK	.equ	1
POLYGON_SUB_FUNC_BANK	.equ	POLYGON_FUNC_BANK + 1		; 2

EDGE_FUNC_L_0_1_BANK	.equ	POLYGON_SUB_FUNC_BANK + 1	; 3
EDGE_FUNC_L_2_3_BANK	.equ	EDGE_FUNC_L_0_1_BANK + 1	; 4
EDGE_FUNC_R_0_1_BANK	.equ	EDGE_FUNC_L_2_3_BANK + 1	; 5
EDGE_FUNC_R_2_3_BANK	.equ	EDGE_FUNC_R_0_1_BANK + 1	; 6

MUL_DATA_BANK		.equ	EDGE_FUNC_R_2_3_BANK + 1	; 7
DIV_DATA_BANK		.equ	MUL_DATA_BANK + 16	 	;23

POLYGON_FUNC_LAST_BANK	.equ	DIV_DATA_BANK + 8 - 1		;30

POLYGON_FUNC_MAP	.equ	6
POLYGON_SUB_FUNC_MAP	.equ	2
POLYGON_EDGE_FUNC_MAP	.equ	3

MUL_DATA_MAP		.equ	2
MUL_DATA_ADDR		.equ	$40

DIV_DATA_MAP		.equ	2
DIV_DATA_ADDR		.equ	$40

POLYGON_SIN8_MAP	.equ	2
POLYGON_SIN8_ADDR	.equ	$40

POLYGON_COS8_MAP	.equ	3
POLYGON_COS8_ADDR	.equ	$60

;----------------------------
DRAWING_NO_0		.equ	$00
DRAWING_NO_1		.equ	$01

DRAWING_NO_0_ADDR	.equ	$20
DRAWING_NO_1_ADDR	.equ	$50

;----------------------------
SCREEN_Z		.equ	128

;----------------------------
SIN_COS_ONE		.equ	$4000

;----------------------------
ATTR_CIRCLE		.equ	%10000000
ATTR_LINESKIP		.equ	%01000000
ATTR_FRONTCLIP_CXL	.equ	%00000100
ATTR_BACKCHECK_CXL	.equ	%00000010
ATTR_BACKDRAW_CXL	.equ	%00000001
ATTR_NONE		.equ	%00000000

;----------------------------
ATTR_2D_CIRCLE		.equ	%10000000
ATTR_2D_LINESKIP	.equ	%01000000

;----------------------------
MODEL_POLYGON_ADDR	.equ	0
MODEL_POLYGON_COUNT	.equ	2
MODEL_VERTEX_ADDR	.equ	3
MODEL_VERTEX_COUNT	.equ	5

;----------------------------
ROT_X			.equ	0
ROT_Y			.equ	1
ROT_Z			.equ	2
ROT_FIRST		.equ	1
ROT_SECOND		.equ	4
ROT_THIRD		.equ	16

ROT_FIRST_X		.equ	ROT_X*ROT_FIRST
ROT_SECOND_X		.equ	ROT_X*ROT_SECOND
ROT_THIRD_X		.equ	ROT_X*ROT_THIRD

ROT_FIRST_Y		.equ	ROT_Y*ROT_FIRST
ROT_SECOND_Y		.equ	ROT_Y*ROT_SECOND
ROT_THIRD_Y		.equ	ROT_Y*ROT_THIRD

ROT_FIRST_Z		.equ	ROT_Z*ROT_FIRST
ROT_SECOND_Z		.equ	ROT_Z*ROT_SECOND
ROT_THIRD_Z		.equ	ROT_Z*ROT_THIRD

;----------------------------
SP_ATTR_INVERT_Y	.equ	%1000000000000000
SP_ATTR_INVERT_X	.equ	%0000100000000000
SP_ATTR_CGY_1		.equ	%0000000000000000
SP_ATTR_CGY_2		.equ	%0001000000000000
SP_ATTR_CGY_4		.equ	%0011000000000000
SP_ATTR_CGX_1		.equ	%0000000000000000
SP_ATTR_CGX_2		.equ	%0000000100000000
SP_ATTR_FOREGROUND	.equ	%0000000010000000
SP_ATTR_BACKGROUND	.equ	%0000000000000000

;----------------------------
;VCE_5M
;VCE_7M
			IFDEF VCE_5M
VCE0_INIT_DATA		.equ	$0000
			ENDIF

			IFDEF VCE_7M
VCE0_INIT_DATA		.equ	$0001
			ENDIF
