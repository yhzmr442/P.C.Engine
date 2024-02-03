;poly_dszp.asm
;//////////////////////////////////
;----------------------------
mul16a			.ds	2
mul16b			.ds	2
div16a			equ	mul16a
div16b			equ	mul16b
sqr32a			equ	mul16a

mul16c			.ds	2
mul16d			.ds	2
div16c			equ	mul16c
div16d			equ	mul16d

mulAddr			.ds	2

;---------------------
work4a			.ds	4
work4b			.ds	4
work8a			equ	work4a
work4c			.ds	4
work4d			.ds	4
work8b			equ	work4c
transform2DRet		equ	work8b+2

;---------------------
padLast			.ds	1
padNow			.ds	1
padState		.ds	1
padState2		.ds	1

;---------------------
vsyncFlag		.ds	1
vdpStatus		.ds	1
vdcR05			.ds	2
drawingNo		.ds	1

;---------------------
irqDisableReg		.ds	1

;---------------------
vertexCount		.ds	1
vertex0Addr		.ds	2

;---------------------
clip2D0Count		.ds	1
clip2D1Count		.ds	1
clip2DFlag		.ds	1
clip2DCheckFlag		.ds	1

;---------------------
;---------------------
;share area start
;---------------------
shareAreaTop
circleX			.ds	2
circleY			.ds	2
circleD			.ds	2
circleDH		.ds	2
circleDD		.ds	2
circleRadius		.ds	2
circleCenterX		.ds	2
circleCenterY		.ds	2
circleXLeft0		.ds	2
circleXRight0		.ds	2
circleXLeft1		.ds	2
circleXRight1		.ds	2
circleYWork		.ds	2
circleXLeftWork		.ds	1
circleXRightWork	.ds	1
shareAreaBottom

;---------------------
			.org	shareAreaTop
polyLineCount		.ds	1
polyLineColorDataWork0	.ds	1
polyLineColorDataWork1	.ds	1
polyLineColorDataWork2	.ds	1
polyLineColorDataWork3	.ds	1
polyLineDataLow		.ds	1
polyLineDataHigh	.ds	1
polyLineLeftAddr	.ds	2
polyLineRightAddr	.ds	2
polyLineLeftData	.ds	1
polyLineLeftMask	.ds	1
polyLineRightData	.ds	1
polyLineRightMask	.ds	1
polyLineMask0		equ	polyLineLeftMask
polyLineMask1		equ	polyLineRightMask

;---------------------
			.org	shareAreaTop
mulSinWork0		.ds	1
mulCosWork0		.ds	1
mulSinAddr0A		.ds	2
mulSinAddr0B		.ds	2
mulCosAddr0A		.ds	2
mulCosAddr0B		.ds	2
mulDataWorkA		.ds	1
mulDataWorkB		.ds	1
mulDataWorkC		.ds	1
saveSin8Mpr		.ds	1
saveCos8Mpr		.ds	1
backCheckFlag		.ds	1

;---------------------
			.org	shareAreaTop
edgeX0			.ds	1
edgeY0			.ds	1
edgeX1			.ds	1
edgeY1			.ds	1
edgeSlopeX		.ds	1
edgeSlopeY		.ds	1
edgeSigneX		.ds	1
edgeJumpAddr		.ds	2

;---------------------
			.org	shareAreaTop
clipFrontX		.ds	2
clipFrontY		.ds	2
frontClipFlag		.ds	1
frontClipCount		.ds	1
frontClipData0		.ds	1
frontClipData1		.ds	1
frontClipDataWork	.ds	1
clipCountX0		.ds	1
clipCountX255		.ds	1
clipCountY0		.ds	1
clipCountY255		.ds	1

;---------------------
			.org	shareAreaTop
angleX0			.ds	2
angleX1			.ds	2
angleY0			.ds	2
angleY1			.ds	2
angleZ0			.ds	2
angleZ1			.ds	2
ansAngleX		.ds	1
ansAngleY		.ds	1

;---------------------
			.org	shareAreaTop
arg0			.ds	1
arg1			.ds	1
argw0			equ	arg0
si			equ	arg0

arg2			.ds	1
arg3			.ds	1
argw1			equ	arg2
di			equ	arg2

arg4			.ds	1
arg5			.ds	1
argw2			equ	arg4

arg6			.ds	1
arg7			.ds	1
argw3			equ	arg6

arg8			.ds	1
arg9			.ds	1
argw4			equ	arg8

temp0			.ds	1
temp1			.ds	1
tempw0			equ	temp0

temp2			.ds	1
temp3			.ds	1
tempw1			equ	temp2

temp4			.ds	1
temp5			.ds	1
tempw2			equ	temp4

;---------------------
			.org	shareAreaTop
matrix0			.ds	2
vertex0			.equ	matrix0

matrix1			.ds	2
vertex1			.equ	matrix1

matrix2			.ds	2
vertex2			.equ	matrix2

matrixTemp		.ds	4

;---------------------
			.org	shareAreaBottom
;---------------------
;share area end
;---------------------
;---------------------

;---------------------
minEdgeY		.ds	1
maxEdgeY		.ds	1

;---------------------
polygonColorIndex	.ds	1
polyAttribute		.ds	1

;---------------------
centerX			.ds	2
centerY			.ds	2

;---------------------
translationX		.ds	2
translationY		.ds	2
translationZ		.ds	2

rotationX		.ds	1
rotationY		.ds	1
rotationZ		.ds	1

rotationSelect		.ds	1

vertexRotationSin	.ds	2
vertexRotationCos	.ds	2

;---------------------
eyeTranslationX		.ds	2
eyeTranslationY		.ds	2
eyeTranslationZ		.ds	2

eyeRotationX		.ds	1
eyeRotationY		.ds	1
eyeRotationZ		.ds	1

eyeRotationSelect	.ds	1

;---------------------
polyBufferAddr		.ds	2
polyBufferZ0Work0	.ds	2
polyBufferZ0Work1	.ds	2

polyBufferNow		.ds	2
polyBufferNext		.ds	2

;---------------------
modelAddress		.ds	2
modelAddrWork		.ds	2
modelPolygonCount	.ds	1
setModelCount		.ds	1
setModelFrontColor	.ds	1
setModelBackColor	.ds	1
setModelAttr		.ds	1
model2DClipIndexWork	.ds	1

;---------------------
satBufferAddr		.ds	2

;---------------------
dda0No			.ds	1
dda0Address		.ds	2
