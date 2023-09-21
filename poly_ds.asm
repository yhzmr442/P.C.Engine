;poly_ds.asm
;//////////////////////////////////
;----------------------------
randomSeed		.ds	2

;---------------------
setBatWork		.ds	2

;---------------------
tiaFunction		.ds	1
tiaSrc			.ds	2
tiaDst			.ds	2
tiaCnt			.ds	2
tiaRts			.ds	1

;---------------------
tiiFunction		.ds	1
tiiSrc			.ds	2
tiiDst			.ds	2
tiiCnt			.ds	2
tiiRts			.ds	1

;---------------------
transform2DWork0	.ds	256
vertexDataTemp		.equ	transform2DWork0
vertexDataTemp0		.equ	transform2DWork0
transform2DWork1	.ds	256
vertexDataTemp1		.equ	transform2DWork1

;---------------------
clip2D0			.ds	(8+1)*4
clip2D1			.ds	(8+1)*4

;---------------------
backCheckWork		.ds	3*4

;---------------------
polyLineColorWork_H_P0	.ds	1
polyLineColorWork_H_P1	.ds	1
polyLineColorWork_H_P2	.ds	1
polyLineColorWork_H_P3	.ds	1

polyLineColorWork_L_P0	.ds	1
polyLineColorWork_L_P1	.ds	1
polyLineColorWork_L_P2	.ds	1
polyLineColorWork_L_P3	.ds	1

;---------------------
polygonColorP0		.ds	128
polygonColorP1		.ds	128
polygonColorP2		.ds	128
polygonColorP3		.ds	128

;---------------------
edgeLeft		.ds	192
edgeRight		.ds	192

;---------------------
			.rsset	0
SAT_Y			.rs	2
SAT_X			.rs	2
SAT_PATTERN		.rs	2
SAT_ATTRIBUTE		.rs	2
SAT_SIZE		.rs	0

satBuffer		.ds	SAT_SIZE*64

;---------------------
;Polygon data(MAX 24Byte) is ordered counterclockwise
;NEXT ADDR 2Byte
;SAMPLE Z 2Byte
;COLOR 1Byte COLOR:(0-127)
;VERTEX COUNT 1Byte COUNT:(3-9), CIRCLE:+$80, LINESKIP:+$40 or DATA END:$00
;X0 1Byte, Y0 1Byte or CIRCLE CENTER X 2Byte
;X1 1Byte, Y1 1Byte or CIRCLE CENTER Y 2Byte
;X2 1Byte, Y2 1Byte or CIRCLE RADIUS 2Byte (1-8192)
;X3 1Byte, Y3 1Byte
;X4 1Byte, Y4 1Byte
;X5 1Byte, Y5 1Byte
;X6 1Byte, Y6 1Byte
;X7 1Byte, Y7 1Byte
;X8 1Byte, Y8 1Byte

polyBufferStart		.ds	6
polyBufferEnd		.ds	6
polyBuffer		.ds	0	;end address $3FFF
