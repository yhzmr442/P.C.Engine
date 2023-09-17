;poly_datas.asm
;//////////////////////////////////
;----------------------------
;SCREEN_256_240_A
;SCREEN_256_240_B
;SCREEN_256_240_7MHZ
;SCREEN_256_192
;SCREEN_256_224

vdcData
		.db	$05, $00, $00	;+1 bgoff spoff

		IFDEF	SCREEN_256_240_A
		.db	$0A, $02, $02	;HSW $02 HDS $02
		.db	$0B, $1F, $03	;HDW $1F HDE $03
		.db	$0C, $02, $0F	;VSW $02 VDS $0F
		.db	$0D, $EF, $00	;VDW $00EF
		.db	$0E, $03, $00	;VCR $0003
		ENDIF

		IFDEF	SCREEN_256_240_B
		.db	$0A, $02, $02	;HSW $02 HDS $02
		.db	$0B, $1F, $04	;HDW $1F HDE $04
		.db	$0C, $02, $0F	;VSW $02 VDS $0F
		.db	$0D, $EF, $00	;VDW $00EF
		.db	$0E, $04, $00	;VCR $0004
		ENDIF

		IFDEF	SCREEN_256_240_7MHZ
		.db	$0A, $02, $09	;HSW $02 HDS $09
		.db	$0B, $1F, $04	;HDW $1F HDE $04
		.db	$0C, $02, $0F	;VSW $02 VDS $0F
		.db	$0D, $EF, $00	;VDW $00EF
		.db	$0E, $04, $00	;VCR $0004
		ENDIF

		IFDEF	SCREEN_256_192
		.db	$0A, $02, $02	;HSW $02 HDS $02
		.db	$0B, $1F, $04	;HDW $1F HDE $04
		.db	$0C, $02, $25	;VSW $02 VDS $25
		.db	$0D, $BF, $00	;VDW $00BF
		.db	$0E, $1E, $00	;VCR $001E
		ENDIF

		IFDEF	SCREEN_256_224
		.db	$0A, $02, $02	;HSW $02 HDS $02
		.db	$0B, $1F, $04	;HDW $1F HDE $04
		.db	$0C, $02, $17	;VSW $02 VDS $17
		.db	$0D, $DF, $00	;VDW $00DF
		.db	$0E, $04, $00	;VCR $0004
		ENDIF

		.db	$0F, $00, $00	;DMA +1 +1
		.db	$07, $00, $00	;scrollx 0
		.db	$08, $00, $00	;scrolly 0
		.db	$09, $40, $00	;32x64
		.db	$FF		;end


;----------------------------
sin8DataHigh
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$81, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80


;----------------------------
sin8DataLow
		.db	$00, $06, $0C, $12, $19, $1F, $25, $2B, $31, $38, $3E, $44, $4A, $50, $56, $5C,\
			$61, $67, $6D, $73, $78, $7E, $83, $88, $8E, $93, $98, $9D, $A2, $A7, $AB, $B0,\
			$B5, $B9, $BD, $C1, $C5, $C9, $CD, $D1, $D4, $D8, $DB, $DE, $E1, $E4, $E7, $EA,\
			$EC, $EE, $F1, $F3, $F4, $F6, $F8, $F9, $FB, $FC, $FD, $FE, $FE, $FF, $FF, $FF,\
			$00, $FF, $FF, $FF, $FE, $FE, $FD, $FC, $FB, $F9, $F8, $F6, $F4, $F3, $F1, $EE,\
			$EC, $EA, $E7, $E4, $E1, $DE, $DB, $D8, $D4, $D1, $CD, $C9, $C5, $C1, $BD, $B9,\
			$B5, $B0, $AB, $A7, $A2, $9D, $98, $93, $8E, $88, $83, $7E, $78, $73, $6D, $67,\
			$61, $5C, $56, $50, $4A, $44, $3E, $38, $31, $2B, $25, $1F, $19, $12, $0C, $06,\
			$00, $06, $0C, $12, $19, $1F, $25, $2B, $31, $38, $3E, $44, $4A, $50, $56, $5C,\
			$61, $67, $6D, $73, $78, $7E, $83, $88, $8E, $93, $98, $9D, $A2, $A7, $AB, $B0,\
			$B5, $B9, $BD, $C1, $C5, $C9, $CD, $D1, $D4, $D8, $DB, $DE, $E1, $E4, $E7, $EA,\
			$EC, $EE, $F1, $F3, $F4, $F6, $F8, $F9, $FB, $FC, $FD, $FE, $FE, $FF, $FF, $FF,\
			$00, $FF, $FF, $FF, $FE, $FE, $FD, $FC, $FB, $F9, $F8, $F6, $F4, $F3, $F1, $EE,\
			$EC, $EA, $E7, $E4, $E1, $DE, $DB, $D8, $D4, $D1, $CD, $C9, $C5, $C1, $BD, $B9,\
			$B5, $B0, $AB, $A7, $A2, $9D, $98, $93, $8E, $88, $83, $7E, $78, $73, $6D, $67,\
			$61, $5C, $56, $50, $4A, $44, $3E, $38, $31, $2B, $25, $1F, $19, $12, $0C, $06 


;----------------------------
cos8DataHigh
		.db	$01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$81, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
cos8DataLow
		.db	$00, $FF, $FF, $FF, $FE, $FE, $FD, $FC, $FB, $F9, $F8, $F6, $F4, $F3, $F1, $EE,\
			$EC, $EA, $E7, $E4, $E1, $DE, $DB, $D8, $D4, $D1, $CD, $C9, $C5, $C1, $BD, $B9,\
			$B5, $B0, $AB, $A7, $A2, $9D, $98, $93, $8E, $88, $83, $7E, $78, $73, $6D, $67,\
			$61, $5C, $56, $50, $4A, $44, $3E, $38, $31, $2B, $25, $1F, $19, $12, $0C, $06,\
			$00, $06, $0C, $12, $19, $1F, $25, $2B, $31, $38, $3E, $44, $4A, $50, $56, $5C,\
			$61, $67, $6D, $73, $78, $7E, $83, $88, $8E, $93, $98, $9D, $A2, $A7, $AB, $B0,\
			$B5, $B9, $BD, $C1, $C5, $C9, $CD, $D1, $D4, $D8, $DB, $DE, $E1, $E4, $E7, $EA,\
			$EC, $EE, $F1, $F3, $F4, $F6, $F8, $F9, $FB, $FC, $FD, $FE, $FE, $FF, $FF, $FF,\
			$00, $FF, $FF, $FF, $FE, $FE, $FD, $FC, $FB, $F9, $F8, $F6, $F4, $F3, $F1, $EE,\
			$EC, $EA, $E7, $E4, $E1, $DE, $DB, $D8, $D4, $D1, $CD, $C9, $C5, $C1, $BD, $B9,\
			$B5, $B0, $AB, $A7, $A2, $9D, $98, $93, $8E, $88, $83, $7E, $78, $73, $6D, $67,\
			$61, $5C, $56, $50, $4A, $44, $3E, $38, $31, $2B, $25, $1F, $19, $12, $0C, $06,\
			$00, $06, $0C, $12, $19, $1F, $25, $2B, $31, $38, $3E, $44, $4A, $50, $56, $5C,\
			$61, $67, $6D, $73, $78, $7E, $83, $88, $8E, $93, $98, $9D, $A2, $A7, $AB, $B0,\
			$B5, $B9, $BD, $C1, $C5, $C9, $CD, $D1, $D4, $D8, $DB, $DE, $E1, $E4, $E7, $EA,\
			$EC, $EE, $F1, $F3, $F4, $F6, $F8, $F9, $FB, $FC, $FD, $FE, $FE, $FF, $FF, $FF


;----------------------------
sinDataHigh
		.db	$00, $01, $03, $04, $06, $07, $09, $0A, $0C, $0E, $0F, $11, $12, $14, $15, $17,\
			$18, $19, $1B, $1C, $1E, $1F, $20, $22, $23, $24, $26, $27, $28, $29, $2A, $2C,\
			$2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $36, $37, $38, $39, $39, $3A,\
			$3B, $3B, $3C, $3C, $3D, $3D, $3E, $3E, $3E, $3F, $3F, $3F, $3F, $3F, $3F, $3F,\
			$40, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3E, $3E, $3E, $3D, $3D, $3C, $3C, $3B,\
			$3B, $3A, $39, $39, $38, $37, $36, $36, $35, $34, $33, $32, $31, $30, $2F, $2E,\
			$2D, $2C, $2A, $29, $28, $27, $26, $24, $23, $22, $20, $1F, $1E, $1C, $1B, $19,\
			$18, $17, $15, $14, $12, $11, $0F, $0E, $0C, $0A, $09, $07, $06, $04, $03, $01,\
			$00, $FE, $FC, $FB, $F9, $F8, $F6, $F5, $F3, $F1, $F0, $EE, $ED, $EB, $EA, $E8,\
			$E7, $E6, $E4, $E3, $E1, $E0, $DF, $DD, $DC, $DB, $D9, $D8, $D7, $D6, $D5, $D3,\
			$D2, $D1, $D0, $CF, $CE, $CD, $CC, $CB, $CA, $C9, $C9, $C8, $C7, $C6, $C6, $C5,\
			$C4, $C4, $C3, $C3, $C2, $C2, $C1, $C1, $C1, $C0, $C0, $C0, $C0, $C0, $C0, $C0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C1, $C1, $C1, $C2, $C2, $C3, $C3, $C4,\
			$C4, $C5, $C6, $C6, $C7, $C8, $C9, $C9, $CA, $CB, $CC, $CD, $CE, $CF, $D0, $D1,\
			$D2, $D3, $D5, $D6, $D7, $D8, $D9, $DB, $DC, $DD, $DF, $E0, $E1, $E3, $E4, $E6,\
			$E7, $E8, $EA, $EB, $ED, $EE, $F0, $F1, $F3, $F5, $F6, $F8, $F9, $FB, $FC, $FE


;----------------------------
sinDataLow
		.db	$00, $92, $24, $B5, $46, $D6, $64, $F1, $7C, $06, $8D, $12, $94, $13, $90, $09,\
			$7E, $EF, $5D, $C6, $2B, $8C, $E7, $3D, $8E, $DA, $20, $60, $9A, $CE, $FB, $21,\
			$41, $5A, $6C, $76, $79, $74, $68, $53, $37, $12, $E5, $B0, $71, $2B, $DB, $82,\
			$21, $B6, $42, $C5, $3F, $AF, $15, $72, $C5, $0F, $4F, $85, $B1, $D4, $EC, $FB,\
			$00, $FB, $EC, $D4, $B1, $85, $4F, $0F, $C5, $72, $15, $AF, $3F, $C5, $42, $B6,\
			$21, $82, $DB, $2B, $71, $B0, $E5, $12, $37, $53, $68, $74, $79, $76, $6C, $5A,\
			$41, $21, $FB, $CE, $9A, $60, $20, $DA, $8E, $3D, $E7, $8C, $2B, $C6, $5D, $EF,\
			$7E, $09, $90, $13, $94, $12, $8D, $06, $7C, $F1, $64, $D6, $46, $B5, $24, $92,\
			$00, $6E, $DC, $4B, $BA, $2A, $9C, $0F, $84, $FA, $73, $EE, $6C, $ED, $70, $F7,\
			$82, $11, $A3, $3A, $D5, $74, $19, $C3, $72, $26, $E0, $A0, $66, $32, $05, $DF,\
			$BF, $A6, $94, $8A, $87, $8C, $98, $AD, $C9, $EE, $1B, $50, $8F, $D5, $25, $7E,\
			$DF, $4A, $BE, $3B, $C1, $51, $EB, $8E, $3B, $F1, $B1, $7B, $4F, $2C, $14, $05,\
			$00, $05, $14, $2C, $4F, $7B, $B1, $F1, $3B, $8E, $EB, $51, $C1, $3B, $BE, $4A,\
			$DF, $7E, $25, $D5, $8F, $50, $1B, $EE, $C9, $AD, $98, $8C, $87, $8A, $94, $A6,\
			$BF, $DF, $05, $32, $66, $A0, $E0, $26, $72, $C3, $19, $74, $D5, $3A, $A3, $11,\
			$82, $F7, $70, $ED, $6C, $EE, $73, $FA, $84, $0F, $9C, $2A, $BA, $4B, $DC, $6E


;----------------------------
cosDataHigh
		.db	$40, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3E, $3E, $3E, $3D, $3D, $3C, $3C, $3B,\
			$3B, $3A, $39, $39, $38, $37, $36, $36, $35, $34, $33, $32, $31, $30, $2F, $2E,\
			$2D, $2C, $2A, $29, $28, $27, $26, $24, $23, $22, $20, $1F, $1E, $1C, $1B, $19,\
			$18, $17, $15, $14, $12, $11, $0F, $0E, $0C, $0A, $09, $07, $06, $04, $03, $01,\
			$00, $FE, $FC, $FB, $F9, $F8, $F6, $F5, $F3, $F1, $F0, $EE, $ED, $EB, $EA, $E8,\
			$E7, $E6, $E4, $E3, $E1, $E0, $DF, $DD, $DC, $DB, $D9, $D8, $D7, $D6, $D5, $D3,\
			$D2, $D1, $D0, $CF, $CE, $CD, $CC, $CB, $CA, $C9, $C9, $C8, $C7, $C6, $C6, $C5,\
			$C4, $C4, $C3, $C3, $C2, $C2, $C1, $C1, $C1, $C0, $C0, $C0, $C0, $C0, $C0, $C0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C1, $C1, $C1, $C2, $C2, $C3, $C3, $C4,\
			$C4, $C5, $C6, $C6, $C7, $C8, $C9, $C9, $CA, $CB, $CC, $CD, $CE, $CF, $D0, $D1,\
			$D2, $D3, $D5, $D6, $D7, $D8, $D9, $DB, $DC, $DD, $DF, $E0, $E1, $E3, $E4, $E6,\
			$E7, $E8, $EA, $EB, $ED, $EE, $F0, $F1, $F3, $F5, $F6, $F8, $F9, $FB, $FC, $FE,\
			$00, $01, $03, $04, $06, $07, $09, $0A, $0C, $0E, $0F, $11, $12, $14, $15, $17,\
			$18, $19, $1B, $1C, $1E, $1F, $20, $22, $23, $24, $26, $27, $28, $29, $2A, $2C,\
			$2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $36, $37, $38, $39, $39, $3A,\
			$3B, $3B, $3C, $3C, $3D, $3D, $3E, $3E, $3E, $3F, $3F, $3F, $3F, $3F, $3F, $3F


;----------------------------
cosDataLow
		.db	$00, $FB, $EC, $D4, $B1, $85, $4F, $0F, $C5, $72, $15, $AF, $3F, $C5, $42, $B6,\
			$21, $82, $DB, $2B, $71, $B0, $E5, $12, $37, $53, $68, $74, $79, $76, $6C, $5A,\
			$41, $21, $FB, $CE, $9A, $60, $20, $DA, $8E, $3D, $E7, $8C, $2B, $C6, $5D, $EF,\
			$7E, $09, $90, $13, $94, $12, $8D, $06, $7C, $F1, $64, $D6, $46, $B5, $24, $92,\
			$00, $6E, $DC, $4B, $BA, $2A, $9C, $0F, $84, $FA, $73, $EE, $6C, $ED, $70, $F7,\
			$82, $11, $A3, $3A, $D5, $74, $19, $C3, $72, $26, $E0, $A0, $66, $32, $05, $DF,\
			$BF, $A6, $94, $8A, $87, $8C, $98, $AD, $C9, $EE, $1B, $50, $8F, $D5, $25, $7E,\
			$DF, $4A, $BE, $3B, $C1, $51, $EB, $8E, $3B, $F1, $B1, $7B, $4F, $2C, $14, $05,\
			$00, $05, $14, $2C, $4F, $7B, $B1, $F1, $3B, $8E, $EB, $51, $C1, $3B, $BE, $4A,\
			$DF, $7E, $25, $D5, $8F, $50, $1B, $EE, $C9, $AD, $98, $8C, $87, $8A, $94, $A6,\
			$BF, $DF, $05, $32, $66, $A0, $E0, $26, $72, $C3, $19, $74, $D5, $3A, $A3, $11,\
			$82, $F7, $70, $ED, $6C, $EE, $73, $FA, $84, $0F, $9C, $2A, $BA, $4B, $DC, $6E,\
			$00, $92, $24, $B5, $46, $D6, $64, $F1, $7C, $06, $8D, $12, $94, $13, $90, $09,\
			$7E, $EF, $5D, $C6, $2B, $8C, $E7, $3D, $8E, $DA, $20, $60, $9A, $CE, $FB, $21,\
			$41, $5A, $6C, $76, $79, $74, $68, $53, $37, $12, $E5, $B0, $71, $2B, $DB, $82,\
			$21, $B6, $42, $C5, $3F, $AF, $15, $72, $C5, $0F, $4F, $85, $B1, $D4, $EC, $FB


;----------------------------
atanDataHigh
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $04, $04, $04,\
			$05, $05, $05, $06, $06, $07, $08, $09, $0A, $0C, $0E, $12, $17, $20, $36, $A2


;----------------------------
atanDataLow
		.db	$06, $13, $1F, $2C, $39, $46, $52, $5F, $6C, $7A, $87, $94, $A2, $B0, $BE, $CD,\
			$DB, $EB, $FA, $0A, $1A, $2A, $3B, $4D, $5F, $72, $86, $9A, $AF, $C5, $DC, $F4,\
			$0D, $27, $43, $60, $80, $A1, $C4, $EA, $13, $3F, $6E, $A2, $DB, $19, $5E, $AA,\
			$00, $61, $D0, $50, $E6, $97, $6C, $72, $BE, $6E, $BA, $09, $3A, $8E, $4D, $F7


;----------------------------
divBankData
		.db	DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0,\
			DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0,\
			DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0,\
			DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0,\
			DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0,\
			DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0,\
			DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0,\
			DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0, DIV_DATA_BANK+0

		.db	DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1,\
			DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1,\
			DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1,\
			DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1,\
			DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1,\
			DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1,\
			DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1,\
			DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1, DIV_DATA_BANK+1

		.db	DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2,\
			DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2,\
			DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2,\
			DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2,\
			DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2,\
			DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2,\
			DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2,\
			DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2, DIV_DATA_BANK+2

		.db	DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3,\
			DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3,\
			DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3,\
			DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3,\
			DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3,\
			DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3,\
			DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3,\
			DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3, DIV_DATA_BANK+3

		.db	DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4,\
			DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4,\
			DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4,\
			DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4,\
			DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4,\
			DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4,\
			DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4,\
			DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4, DIV_DATA_BANK+4

		.db	DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5,\
			DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5,\
			DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5,\
			DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5,\
			DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5,\
			DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5,\
			DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5,\
			DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5, DIV_DATA_BANK+5

		.db	DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6,\
			DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6,\
			DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6,\
			DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6,\
			DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6,\
			DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6,\
			DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6,\
			DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6, DIV_DATA_BANK+6

		.db	DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7,\
			DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7,\
			DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7,\
			DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7,\
			DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7,\
			DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7,\
			DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7,\
			DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7, DIV_DATA_BANK+7


;----------------------------
mulBankData
		.db	MUL_DATA_BANK+0, MUL_DATA_BANK+0, MUL_DATA_BANK+0, MUL_DATA_BANK+0,\
			MUL_DATA_BANK+0, MUL_DATA_BANK+0, MUL_DATA_BANK+0, MUL_DATA_BANK+0,\
			MUL_DATA_BANK+0, MUL_DATA_BANK+0, MUL_DATA_BANK+0, MUL_DATA_BANK+0,\
			MUL_DATA_BANK+0, MUL_DATA_BANK+0, MUL_DATA_BANK+0, MUL_DATA_BANK+0

		.db	MUL_DATA_BANK+1, MUL_DATA_BANK+1, MUL_DATA_BANK+1, MUL_DATA_BANK+1,\
			MUL_DATA_BANK+1, MUL_DATA_BANK+1, MUL_DATA_BANK+1, MUL_DATA_BANK+1,\
			MUL_DATA_BANK+1, MUL_DATA_BANK+1, MUL_DATA_BANK+1, MUL_DATA_BANK+1,\
			MUL_DATA_BANK+1, MUL_DATA_BANK+1, MUL_DATA_BANK+1, MUL_DATA_BANK+1

		.db	MUL_DATA_BANK+2, MUL_DATA_BANK+2, MUL_DATA_BANK+2, MUL_DATA_BANK+2,\
			MUL_DATA_BANK+2, MUL_DATA_BANK+2, MUL_DATA_BANK+2, MUL_DATA_BANK+2,\
			MUL_DATA_BANK+2, MUL_DATA_BANK+2, MUL_DATA_BANK+2, MUL_DATA_BANK+2,\
			MUL_DATA_BANK+2, MUL_DATA_BANK+2, MUL_DATA_BANK+2, MUL_DATA_BANK+2

		.db	MUL_DATA_BANK+3, MUL_DATA_BANK+3, MUL_DATA_BANK+3, MUL_DATA_BANK+3,\
			MUL_DATA_BANK+3, MUL_DATA_BANK+3, MUL_DATA_BANK+3, MUL_DATA_BANK+3,\
			MUL_DATA_BANK+3, MUL_DATA_BANK+3, MUL_DATA_BANK+3, MUL_DATA_BANK+3,\
			MUL_DATA_BANK+3, MUL_DATA_BANK+3, MUL_DATA_BANK+3, MUL_DATA_BANK+3

		.db	MUL_DATA_BANK+4, MUL_DATA_BANK+4, MUL_DATA_BANK+4, MUL_DATA_BANK+4,\
			MUL_DATA_BANK+4, MUL_DATA_BANK+4, MUL_DATA_BANK+4, MUL_DATA_BANK+4,\
			MUL_DATA_BANK+4, MUL_DATA_BANK+4, MUL_DATA_BANK+4, MUL_DATA_BANK+4,\
			MUL_DATA_BANK+4, MUL_DATA_BANK+4, MUL_DATA_BANK+4, MUL_DATA_BANK+4

		.db	MUL_DATA_BANK+5, MUL_DATA_BANK+5, MUL_DATA_BANK+5, MUL_DATA_BANK+5,\
			MUL_DATA_BANK+5, MUL_DATA_BANK+5, MUL_DATA_BANK+5, MUL_DATA_BANK+5,\
			MUL_DATA_BANK+5, MUL_DATA_BANK+5, MUL_DATA_BANK+5, MUL_DATA_BANK+5,\
			MUL_DATA_BANK+5, MUL_DATA_BANK+5, MUL_DATA_BANK+5, MUL_DATA_BANK+5

		.db	MUL_DATA_BANK+6, MUL_DATA_BANK+6, MUL_DATA_BANK+6, MUL_DATA_BANK+6,\
			MUL_DATA_BANK+6, MUL_DATA_BANK+6, MUL_DATA_BANK+6, MUL_DATA_BANK+6,\
			MUL_DATA_BANK+6, MUL_DATA_BANK+6, MUL_DATA_BANK+6, MUL_DATA_BANK+6,\
			MUL_DATA_BANK+6, MUL_DATA_BANK+6, MUL_DATA_BANK+6, MUL_DATA_BANK+6

		.db	MUL_DATA_BANK+7, MUL_DATA_BANK+7, MUL_DATA_BANK+7, MUL_DATA_BANK+7,\
			MUL_DATA_BANK+7, MUL_DATA_BANK+7, MUL_DATA_BANK+7, MUL_DATA_BANK+7,\
			MUL_DATA_BANK+7, MUL_DATA_BANK+7, MUL_DATA_BANK+7, MUL_DATA_BANK+7,\
			MUL_DATA_BANK+7, MUL_DATA_BANK+7, MUL_DATA_BANK+7, MUL_DATA_BANK+7

		.db	MUL_DATA_BANK+8, MUL_DATA_BANK+8, MUL_DATA_BANK+8, MUL_DATA_BANK+8,\
			MUL_DATA_BANK+8, MUL_DATA_BANK+8, MUL_DATA_BANK+8, MUL_DATA_BANK+8,\
			MUL_DATA_BANK+8, MUL_DATA_BANK+8, MUL_DATA_BANK+8, MUL_DATA_BANK+8,\
			MUL_DATA_BANK+8, MUL_DATA_BANK+8, MUL_DATA_BANK+8, MUL_DATA_BANK+8

		.db	MUL_DATA_BANK+9, MUL_DATA_BANK+9, MUL_DATA_BANK+9, MUL_DATA_BANK+9,\
			MUL_DATA_BANK+9, MUL_DATA_BANK+9, MUL_DATA_BANK+9, MUL_DATA_BANK+9,\
			MUL_DATA_BANK+9, MUL_DATA_BANK+9, MUL_DATA_BANK+9, MUL_DATA_BANK+9,\
			MUL_DATA_BANK+9, MUL_DATA_BANK+9, MUL_DATA_BANK+9, MUL_DATA_BANK+9

		.db	MUL_DATA_BANK+10, MUL_DATA_BANK+10, MUL_DATA_BANK+10, MUL_DATA_BANK+10,\
			MUL_DATA_BANK+10, MUL_DATA_BANK+10, MUL_DATA_BANK+10, MUL_DATA_BANK+10,\
			MUL_DATA_BANK+10, MUL_DATA_BANK+10, MUL_DATA_BANK+10, MUL_DATA_BANK+10,\
			MUL_DATA_BANK+10, MUL_DATA_BANK+10, MUL_DATA_BANK+10, MUL_DATA_BANK+10

		.db	MUL_DATA_BANK+11, MUL_DATA_BANK+11, MUL_DATA_BANK+11, MUL_DATA_BANK+11,\
			MUL_DATA_BANK+11, MUL_DATA_BANK+11, MUL_DATA_BANK+11, MUL_DATA_BANK+11,\
			MUL_DATA_BANK+11, MUL_DATA_BANK+11, MUL_DATA_BANK+11, MUL_DATA_BANK+11,\
			MUL_DATA_BANK+11, MUL_DATA_BANK+11, MUL_DATA_BANK+11, MUL_DATA_BANK+11

		.db	MUL_DATA_BANK+12, MUL_DATA_BANK+12, MUL_DATA_BANK+12, MUL_DATA_BANK+12,\
			MUL_DATA_BANK+12, MUL_DATA_BANK+12, MUL_DATA_BANK+12, MUL_DATA_BANK+12,\
			MUL_DATA_BANK+12, MUL_DATA_BANK+12, MUL_DATA_BANK+12, MUL_DATA_BANK+12,\
			MUL_DATA_BANK+12, MUL_DATA_BANK+12, MUL_DATA_BANK+12, MUL_DATA_BANK+12

		.db	MUL_DATA_BANK+13, MUL_DATA_BANK+13, MUL_DATA_BANK+13, MUL_DATA_BANK+13,\
			MUL_DATA_BANK+13, MUL_DATA_BANK+13, MUL_DATA_BANK+13, MUL_DATA_BANK+13,\
			MUL_DATA_BANK+13, MUL_DATA_BANK+13, MUL_DATA_BANK+13, MUL_DATA_BANK+13,\
			MUL_DATA_BANK+13, MUL_DATA_BANK+13, MUL_DATA_BANK+13, MUL_DATA_BANK+13

		.db	MUL_DATA_BANK+14, MUL_DATA_BANK+14, MUL_DATA_BANK+14, MUL_DATA_BANK+14,\
			MUL_DATA_BANK+14, MUL_DATA_BANK+14, MUL_DATA_BANK+14, MUL_DATA_BANK+14,\
			MUL_DATA_BANK+14, MUL_DATA_BANK+14, MUL_DATA_BANK+14, MUL_DATA_BANK+14,\
			MUL_DATA_BANK+14, MUL_DATA_BANK+14, MUL_DATA_BANK+14, MUL_DATA_BANK+14

		.db	MUL_DATA_BANK+15, MUL_DATA_BANK+15, MUL_DATA_BANK+15, MUL_DATA_BANK+15,\
			MUL_DATA_BANK+15, MUL_DATA_BANK+15, MUL_DATA_BANK+15, MUL_DATA_BANK+15,\
			MUL_DATA_BANK+15, MUL_DATA_BANK+15, MUL_DATA_BANK+15, MUL_DATA_BANK+15,\
			MUL_DATA_BANK+15, MUL_DATA_BANK+15, MUL_DATA_BANK+15, MUL_DATA_BANK+15
