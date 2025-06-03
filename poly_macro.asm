;poly_macro.asm
;//////////////////////////////////
;----------------------------
SET_POLYGON_FUNCTION	.macro

		lda	#POLYGON_FUNC_BANK
		tam	#POLYGON_FUNC_MAP

		.endm


;----------------------------
RESET_PROCESS	.macro
;
		sei

		csh

		cld

		ldx	#$FF
		txs

		lda	#$FF
		tam	#$00

		lda	#$F8
		tam	#$01

		stz	$2000
		tii	$2000, $2001, $1FFF

		stz	TIMER_CONTROL_REG

;disable interrupts
		lda	#%00000111
		sta	INTERRUPT_DISABLE_REG

		.endm


;----------------------------
IRQ_ENTRY	.macro
;
		pha
		phx
		phy

		.endm


;----------------------------
IRQ_EXIT	.macro
;
		ply
		plx
		pla

		rti
		.endm


;----------------------------
phall		.macro
		pha
		phx
		phy

		.endm


;----------------------------
plall		.macro
		ply
		plx
		pla

		.endm


;----------------------------
mov		.macro
;\1 = \2
		lda	\2
		sta	\1
		.endm


;----------------------------
movw		.macro
;\1 = \2
		.if	(\?2 = 2);Immediate
			lda	#LOW(\2)
			sta	\1
			lda	#HIGH(\2)
			sta	\1+1
		.else
			lda	\2
			sta	\1
			lda	\2+1
			sta	\1+1
		.endif
		.endm


;----------------------------
movq		.macro
;\1 = \2
;\1 = \2:\3
		.if	(\?2 = 2);Immediate
			lda	#LOW(\3)
			sta	\1
			lda	#HIGH(\3)
			sta	\1+1
			lda	#LOW(\2)
			sta	\1+2
			lda	#HIGH(\2)
			sta	\1+3
		.else
			lda	\2
			sta	\1
			lda	\2+1
			sta	\1+1
			lda	\2+2
			sta	\1+2
			lda	\2+3
			sta	\1+3
		.endif
		.endm


;----------------------------
movw2		.macro
;\1 = \2
		.if	(\?2 = 2);Immediate
			lda	#LOW(\2)
			sta	\1
			lda	#HIGH(\2)
			sta	1+\1
		.else
			lda	\2
			sta	\1
			lda	1+\2
			sta	1+\1
		.endif
		.endm


;----------------------------
movwzpx		.macro
;\1 = \2
		lda	\2
		sta	\1
		lda	1+\2
		sta	\1+1
		.endm


;----------------------------
adc2		.macro
;\1 = \2 + \3
;\1 = \1 + \2
		.if	(\# = 1)
			adc	\1
		.else
			.if	(\# = 3)
				lda	\2
				adc	\3
				sta	\1
			.else
				lda	\1
				adc	\2
				sta	\1
			.endif
		.endif
		.endm


;----------------------------
add		.macro
;\1 = \2 + \3
;\1 = \1 + \2
		.if	(\# = 1)
			clc
			adc	\1
		.else
			.if	(\# = 3)
				clc
				lda	\2
				adc	\3
				sta	\1
			.else
				clc
				lda	\1
				adc	\2
				sta	\1
			.endif
		.endif
		.endm


;----------------------------
addw		.macro
;\1 = \2 + \3
;\1 = \1 + \2
		.if	(\# = 3)
			.if	(\?3 = 2);Immediate
				clc
				lda	\2
				adc	#LOW(\3)
				sta	\1

				lda	\2+1
				adc	#HIGH(\3)
				sta	\1+1
			.else
				clc
				lda	\2
				adc	\3
				sta	\1

				lda	\2+1
				adc	\3+1
				sta	\1+1
			.endif
		.else
			.if	(\?2 = 2);Immediate
				clc
				lda	\1
				adc	#LOW(\2)
				sta	\1

				lda	\1+1
				adc	#HIGH(\2)
				sta	\1+1
			.else
				clc
				lda	\1
				adc	\2
				sta	\1

				lda	\1+1
				adc	\2+1
				sta	\1+1
			.endif
		.endif
		.endm


;----------------------------
addw2		.macro
;\1 = \2 + \3
;\1 = \1 + \2
		.if	(\# = 3)
			.if	(\?3 = 2);Immediate
				clc
				lda	\2
				adc	#LOW(\3)
				sta	\1

				lda	1+\2
				adc	#HIGH(\3)
				sta	1+\1
			.else
				clc
				lda	\2
				adc	\3
				sta	\1

				lda	1+\2
				adc	1+\3
				sta	1+\1
			.endif
		.else
			.if	(\?2 = 2);Immediate
				clc
				lda	\1
				adc	#LOW(\2)
				sta	\1

				lda	1+\1
				adc	#HIGH(\2)
				sta	1+\1
			.else
				clc
				lda	\1
				adc	\2
				sta	\1

				lda	1+\1
				adc	1+\2
				sta	1+\1
			.endif
		.endif
		.endm


;----------------------------
addwb		.macro
;\1(word) = \1(word) + \2(byte)
		clc
		lda	\1
		adc	\2
		sta	\1
		bcc	.jp0\@
		inc	\1+1
.jp0\@
		.endm


;----------------------------
incw		.macro
;\1(word) = \1(word) + 1
		inc	\1
		bne	.jp0\@
		inc	\1+1
.jp0\@
		.endm


;----------------------------
incq		.macro
;\1(word) = \1(word) + 1
		inc	\1
		bne	.jp0\@
		inc	\1+1
		bne	.jp0\@
		inc	\1+2
		bne	.jp0\@
		inc	\1+3
.jp0\@
		.endm


;----------------------------
decw		.macro
;\1(word) = \1(word) - 1
		lda	\1
		bne	.jp0\@
		dec	\1+1
.jp0\@
		dec	a
		sta	\1
		.endm


;----------------------------
addq		.macro
;\1 = \2 + \3
;\1 = \1 + (\2:\3)
;\1 = \1 + \2
		.if	(\# = 3)
			.if	(\?2 = 2);Immediate
				clc
				lda	\1
				adc	#LOW(\3)
				sta	\1

				lda	\1+1
				adc	#HIGH(\3)
				sta	\1+1

				lda	\1+2
				adc	#LOW(\2)
				sta	\1+2

				lda	\1+3
				adc	#HIGH(\2)
				sta	\1+3
			.else
				clc
				lda	\2
				adc	\3
				sta	\1

				lda	\2+1
				adc	\3+1
				sta	\1+1

				lda	\2+2
				adc	\3+2
				sta	\1+2

				lda	\2+3
				adc	\3+3
				sta	\1+3
			.endif
		.else
			clc
			lda	\1
			adc	\2
			sta	\1

			lda	\1+1
			adc	\2+1
			sta	\1+1

			lda	\1+2
			adc	\2+2
			sta	\1+2

			lda	\1+3
			adc	\2+3
			sta	\1+3
		.endif
		.endm


;----------------------------
sbc2		.macro
;\1 = \2 - \3
;\1 = \1 - \2
		.if	(\# = 1)
			sbc	\1
		.else
			.if	(\# = 3)
				lda	\2
				sbc	\3
				sta	\1
			.else
				lda	\1
				sbc	\2
				sta	\1
			.endif
		.endif
		.endm


;----------------------------
sub		.macro
;\1 = \2 - \3
;\1 = \1 - \2
		.if	(\# = 1)
			sec
			sbc	\1
		.else
			.if	(\# = 3)
				sec
				lda	\2
				sbc	\3
				sta	\1
			.else
				sec
				lda	\1
				sbc	\2
				sta	\1
			.endif
		.endif
		.endm


;----------------------------
subw		.macro
;\1 = \2 - \3
;\1 = \1 - \2
		.if	(\# = 3)
			.if	(\?3 = 2);Immediate
				sec
				lda	\2
				sbc	#LOW(\3)
				sta	\1

				lda	\2+1
				sbc	#HIGH(\3)
				sta	\1+1
			.else
				.if	(\?2 = 2);Immediate
					sec
					lda	#LOW(\2)
					sbc	\3
					sta	\1

					lda	#HIGH(\2)
					sbc	\3+1
					sta	\1+1
				.else
					sec
					lda	\2
					sbc	\3
					sta	\1

					lda	\2+1
					sbc	\3+1
					sta	\1+1
				.endif
			.endif
		.else
			.if	(\?2 = 2);Immediate
				sec
				lda	\1
				sbc	#LOW(\2)
				sta	\1

				lda	\1+1
				sbc	#HIGH(\2)
				sta	\1+1
			.else
				sec
				lda	\1
				sbc	\2
				sta	\1

				lda	\1+1
				sbc	\2+1
				sta	\1+1
			.endif
		.endif
		.endm


;----------------------------
subw2		.macro
;\1 = \2 - \3
;\1 = \1 - \2
		.if	(\# = 3)
			.if	(\?3 = 2);Immediate
				sec
				lda	\2
				sbc	#LOW(\3)
				sta	\1

				lda	1+\2
				sbc	#HIGH(\3)
				sta	1+\1
			.else
				.if	(\?2 = 2);Immediate
					sec
					lda	#LOW(\2)
					sbc	\3
					sta	\1

					lda	#HIGH(\2)
					sbc	1+\3
					sta	1+\1
				.else
					sec
					lda	\2
					sbc	\3
					sta	\1

					lda	1+\2
					sbc	1+\3
					sta	1+\1
				.endif
			.endif
		.else
			.if	(\?2 = 2);Immediate
				sec
				lda	\1
				sbc	#LOW(\2)
				sta	\1

				lda	1+\1
				sbc	#HIGH(\2)
				sta	1+\1
			.else
				sec
				lda	\1
				sbc	\2
				sta	\1

				lda	1+\1
				sbc	1+\2
				sta	1+\1
			.endif
		.endif
		.endm


;----------------------------
subwb		.macro
;\1(word) = \1(word) - \2(byte)
		sec
		lda	\1
		sbc	\2
		sta	\1
		bcs	.jp0\@
		dec	\1+1
.jp0\@
		.endm


;----------------------------
subq		.macro
;\1 = \2 - \3
;\1 = \1 - (\2:\3)
;\1 = \1 - \2
		.if	(\# = 3)
			.if	(\?2 = 2);Immediate
				sec
				lda	\1
				sbc	#LOW(\3)
				sta	\1

				lda	\1+1
				sbc	#HIGH(\3)
				sta	\1+1

				lda	\1+2
				sbc	#LOW(\2)
				sta	\1+2

				lda	\1+3
				sbc	#HIGH(\2)
				sta	\1+3
			.else
				sec
				lda	\2
				sbc	\3
				sta	\1

				lda	\2+1
				sbc	\3+1
				sta	\1+1

				lda	\2+2
				sbc	\3+2
				sta	\1+2

				lda	\2+3
				sbc	\3+3
				sta	\1+3
			.endif
		.else
			sec
			lda	\1
			sbc	\2
			sta	\1

			lda	\1+1
			sbc	\2+1
			sta	\1+1

			lda	\1+2
			sbc	\2+2
			sta	\1+2

			lda	\1+3
			sbc	\2+3
			sta	\1+3
		.endif
		.endm


;----------------------------
adx		.macro
;x = x + \1
		sax
		clc
		adc	\1
		sax
		.endm


;----------------------------
ady		.macro
;y = y + \1
		say
		clc
		adc	\1
		say
		.endm


;----------------------------
sbx		.macro
;x = x - \1
		sax
		sec
		sbc	\1
		sax
		.endm


;----------------------------
sby		.macro
;y = y - \1
		say
		sec
		sbc	\1
		say
		.endm


;----------------------------
adx2		.macro
;x = x + \1
		txa
		clc
		adc	\1
		tax
		.endm


;----------------------------
ady2		.macro
;y = y + \1
		tya
		clc
		adc	\1
		tay
		.endm


;----------------------------
sbx2		.macro
;x = x - \1
		txa
		sec
		sbc	\1
		tax
		.endm


;----------------------------
sby2		.macro
;y = y - \1
		tya
		sec
		sbc	\1
		tay
		.endm


;----------------------------
stzw		.macro
;\1 = 0
		stz	\1
		stz	\1+1
		.endm


;----------------------------
stzq		.macro
;\1 = 0
		stz	\1
		stz	\1+1
		stz	\1+2
		stz	\1+3
		.endm


;----------------------------
aslw		.macro
;\1
		asl	\1
		rol	\1+1
		.endm


;----------------------------
aslq		.macro
;\1
		asl	\1
		rol	\1+1
		rol	\1+2
		rol	\1+3
		.endm


;----------------------------
rolq		.macro
;\1
		rol	\1
		rol	\1+1
		rol	\1+2
		rol	\1+3
		.endm


;----------------------------
lsrw		.macro
;\1
		lsr	\1+1
		ror	\1
		.endm


;----------------------------
jcc		.macro
		bcs	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
jcs		.macro
		bcc	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
jeq		.macro
		bne	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
jne		.macro
		beq	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
jpl		.macro
		bmi	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
jmi		.macro
		bpl	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
cmpw		.macro
;\1 - \2
		.if	(\?2 = 2);Immediate
			sec
			lda	\1
			sbc	#LOW(\2)
			lda	\1+1
			sbc	#HIGH(\2)
		.else
			sec
			lda	\1
			sbc	\2
			lda	\1+1
			sbc	\2+1
		.endif
		.endm


;----------------------------
cmpw2		.macro
;\1 - \2
		.if	(\?2 = 2);Immediate
			sec
			lda	\1
			sbc	#LOW(\2)
			lda	1+\1
			sbc	#HIGH(\2)
		.else
			sec
			lda	\1
			sbc	\2
			lda	1+\1
			sbc	1+\2
		.endif
		.endm


;----------------------------
cmpq		.macro
;\1 - \2
;\1 - \2:\3
		.if	(\?2 = 2);Immediate
			sec
			lda	\1
			sbc	#LOW(\3)
			lda	\1+1
			sbc	#HIGH(\3)
			lda	\1+2
			sbc	#LOW(\2)
			lda	\1+3
			sbc	#HIGH(\2)
		.else
			sec
			lda	\1
			sbc	\2
			lda	\1+1
			sbc	\2+1
			lda	\1+2
			sbc	\2+2
			lda	\1+3
			sbc	\2+3
		.endif
		.endm


;----------------------------
st012		.macro
;
		st0	#\1
		st1	#LOW(\2)
		st2	#HIGH(\2)
		.endm


;----------------------------
bbs		.macro
;
.bbs\@
		.db	$8F + \1 * $10
		.db	#LOW(\2)
		.db	\3 - (.bbs\@ + 3)
		.endm


;----------------------------
bbr		.macro
;
.bbr\@
		.db	$0F + \1 * $10
		.db	#LOW(\2)
		.db	\3 - (.bbr\@ + 3)
		.endm


;----------------------------
smb		.macro
;
		.db	$87 + \1 * $10
		.db	#LOW(\2)
		.endm


;----------------------------
rmb		.macro
;
		.db	$07 + \1 * $10
		.db	#LOW(\2)
		.endm


		IFDEF	USE_SHADING
;----------------------------
MODEL_DATA	.macro
;
				.dw	\1	;POLYGON_DATA ADDRESS
				.db	\2	;POLYGON_DATA COUNTS(1 to 32)
				.dw	\3	;VERTEX_DATA ADDRESS
				.db	\4	;VERTEX_DATA COUNTS(1 to 42)
				.dw	\5	;POLYGON VECTOR_DATA ADDRESS
		.endm
		ELSE
;----------------------------
MODEL_DATA	.macro
;
				.dw	\1	;POLYGON_DATA ADDRESS
				.db	\2	;POLYGON_DATA COUNTS(1 to 32)
				.dw	\3	;VERTEX_DATA ADDRESS
				.db	\4	;VERTEX_DATA COUNTS(1 to 42)
		.endm
		ENDIF


;----------------------------
POLYGON_DATA	.macro
;attribute: circle($80 = circlre) + even line skip($40 = skip) + shading($20 = shading) + front clip($04 = cancel) + back check($02 = cancel) + back draw($01 = not draw : front side = counterclockwise)
;front color(0 to 127)
;back color(0 to 127) or circle radius(1 to 8192) low byte
;vertex count: count(3 to 4) or circle radius(1 to 8192) high byte
;vertex index 0,
;vertex index 1,
;vertex index 2,
;vertex index 3
		.if	(\# = 4)
			.db	\1, \2, #LOW(\3), #HIGH(\3), \4*6, 0, 0, 0
		else
			.if	(\# = 6)
				.db	\1, \2, \3, 3, \4*6, \5*6, \6*6, 0
			.else
				.db	\1, \2, \3, 4, \4*6, \5*6, \6*6, \7*6
			.endif
		.endif
		.endm


;----------------------------
VERTEX_DATA	.macro
;
				.dw	\1, \2, \3	;X, Y, Z
		.endm


;----------------------------
VECTOR_DATA	.macro
;
				.dw	\1, \2, \3	;X, Y, Z
		.endm


;----------------------------
MATRIX_DATA	.macro
;
				.ds	9*2	;3*3 matrix
		.endm
