;poly_edgeL0_1.asm
;//////////////////////////////////
;----------------------------
calcEdgeL0_m	.macro
		inx
		adc	<edgeSlopeY
		bcc	.jp\@
		sbc	<edgeSlopeX
		iny
.jp\1:
		sax
		sta	edgeLeft, y
		sax
.jp\@:
		.endm


;----------------------------
calcEdgeL1_m	.macro
		dex
		adc	<edgeSlopeY
		bcc	.jp\@
		sbc	<edgeSlopeX
		iny
.jp\1:
		sax
		sta	edgeLeft, y
		sax
.jp\@:
		.endm


;//////////////////////////////////
		.org	$6000

;----------------------------
calcEdgeL0:
;
		ldx	<edgeSlopeX
		lda	.jpAddrLow, x
		sta	<edgeJumpAddr
		lda	.jpAddrHigh, x
		sta	<edgeJumpAddr+1

		lda	<edgeSlopeX
		eor	#$FF
		inc	a

		ldx	<edgeX0
		ldy	<edgeY0

		clc
		jmp	[edgeJumpAddr]

.jp255:
		sax
		sta	edgeLeft, y
		sax

		calcEdgeL0_m	254
		calcEdgeL0_m	253
		calcEdgeL0_m	252
		calcEdgeL0_m	251
		calcEdgeL0_m	250
		calcEdgeL0_m	249
		calcEdgeL0_m	248
		calcEdgeL0_m	247
		calcEdgeL0_m	246
		calcEdgeL0_m	245
		calcEdgeL0_m	244
		calcEdgeL0_m	243
		calcEdgeL0_m	242
		calcEdgeL0_m	241
		calcEdgeL0_m	240
		calcEdgeL0_m	239
		calcEdgeL0_m	238
		calcEdgeL0_m	237
		calcEdgeL0_m	236
		calcEdgeL0_m	235
		calcEdgeL0_m	234
		calcEdgeL0_m	233
		calcEdgeL0_m	232
		calcEdgeL0_m	231
		calcEdgeL0_m	230
		calcEdgeL0_m	229
		calcEdgeL0_m	228
		calcEdgeL0_m	227
		calcEdgeL0_m	226
		calcEdgeL0_m	225
		calcEdgeL0_m	224
		calcEdgeL0_m	223
		calcEdgeL0_m	222
		calcEdgeL0_m	221
		calcEdgeL0_m	220
		calcEdgeL0_m	219
		calcEdgeL0_m	218
		calcEdgeL0_m	217
		calcEdgeL0_m	216
		calcEdgeL0_m	215
		calcEdgeL0_m	214
		calcEdgeL0_m	213
		calcEdgeL0_m	212
		calcEdgeL0_m	211
		calcEdgeL0_m	210
		calcEdgeL0_m	209
		calcEdgeL0_m	208
		calcEdgeL0_m	207
		calcEdgeL0_m	206
		calcEdgeL0_m	205
		calcEdgeL0_m	204
		calcEdgeL0_m	203
		calcEdgeL0_m	202
		calcEdgeL0_m	201
		calcEdgeL0_m	200
		calcEdgeL0_m	199
		calcEdgeL0_m	198
		calcEdgeL0_m	197
		calcEdgeL0_m	196
		calcEdgeL0_m	195
		calcEdgeL0_m	194
		calcEdgeL0_m	193
		calcEdgeL0_m	192
		calcEdgeL0_m	191
		calcEdgeL0_m	190
		calcEdgeL0_m	189
		calcEdgeL0_m	188
		calcEdgeL0_m	187
		calcEdgeL0_m	186
		calcEdgeL0_m	185
		calcEdgeL0_m	184
		calcEdgeL0_m	183
		calcEdgeL0_m	182
		calcEdgeL0_m	181
		calcEdgeL0_m	180
		calcEdgeL0_m	179
		calcEdgeL0_m	178
		calcEdgeL0_m	177
		calcEdgeL0_m	176
		calcEdgeL0_m	175
		calcEdgeL0_m	174
		calcEdgeL0_m	173
		calcEdgeL0_m	172
		calcEdgeL0_m	171
		calcEdgeL0_m	170
		calcEdgeL0_m	169
		calcEdgeL0_m	168
		calcEdgeL0_m	167
		calcEdgeL0_m	166
		calcEdgeL0_m	165
		calcEdgeL0_m	164
		calcEdgeL0_m	163
		calcEdgeL0_m	162
		calcEdgeL0_m	161
		calcEdgeL0_m	160
		calcEdgeL0_m	159
		calcEdgeL0_m	158
		calcEdgeL0_m	157
		calcEdgeL0_m	156
		calcEdgeL0_m	155
		calcEdgeL0_m	154
		calcEdgeL0_m	153
		calcEdgeL0_m	152
		calcEdgeL0_m	151
		calcEdgeL0_m	150
		calcEdgeL0_m	149
		calcEdgeL0_m	148
		calcEdgeL0_m	147
		calcEdgeL0_m	146
		calcEdgeL0_m	145
		calcEdgeL0_m	144
		calcEdgeL0_m	143
		calcEdgeL0_m	142
		calcEdgeL0_m	141
		calcEdgeL0_m	140
		calcEdgeL0_m	139
		calcEdgeL0_m	138
		calcEdgeL0_m	137
		calcEdgeL0_m	136
		calcEdgeL0_m	135
		calcEdgeL0_m	134
		calcEdgeL0_m	133
		calcEdgeL0_m	132
		calcEdgeL0_m	131
		calcEdgeL0_m	130
		calcEdgeL0_m	129
		calcEdgeL0_m	128
		calcEdgeL0_m	127
		calcEdgeL0_m	126
		calcEdgeL0_m	125
		calcEdgeL0_m	124
		calcEdgeL0_m	123
		calcEdgeL0_m	122
		calcEdgeL0_m	121
		calcEdgeL0_m	120
		calcEdgeL0_m	119
		calcEdgeL0_m	118
		calcEdgeL0_m	117
		calcEdgeL0_m	116
		calcEdgeL0_m	115
		calcEdgeL0_m	114
		calcEdgeL0_m	113
		calcEdgeL0_m	112
		calcEdgeL0_m	111
		calcEdgeL0_m	110
		calcEdgeL0_m	109
		calcEdgeL0_m	108
		calcEdgeL0_m	107
		calcEdgeL0_m	106
		calcEdgeL0_m	105
		calcEdgeL0_m	104
		calcEdgeL0_m	103
		calcEdgeL0_m	102
		calcEdgeL0_m	101
		calcEdgeL0_m	100
		calcEdgeL0_m	99
		calcEdgeL0_m	98
		calcEdgeL0_m	97
		calcEdgeL0_m	96
		calcEdgeL0_m	95
		calcEdgeL0_m	94
		calcEdgeL0_m	93
		calcEdgeL0_m	92
		calcEdgeL0_m	91
		calcEdgeL0_m	90
		calcEdgeL0_m	89
		calcEdgeL0_m	88
		calcEdgeL0_m	87
		calcEdgeL0_m	86
		calcEdgeL0_m	85
		calcEdgeL0_m	84
		calcEdgeL0_m	83
		calcEdgeL0_m	82
		calcEdgeL0_m	81
		calcEdgeL0_m	80
		calcEdgeL0_m	79
		calcEdgeL0_m	78
		calcEdgeL0_m	77
		calcEdgeL0_m	76
		calcEdgeL0_m	75
		calcEdgeL0_m	74
		calcEdgeL0_m	73
		calcEdgeL0_m	72
		calcEdgeL0_m	71
		calcEdgeL0_m	70
		calcEdgeL0_m	69
		calcEdgeL0_m	68
		calcEdgeL0_m	67
		calcEdgeL0_m	66
		calcEdgeL0_m	65
		calcEdgeL0_m	64
		calcEdgeL0_m	63
		calcEdgeL0_m	62
		calcEdgeL0_m	61
		calcEdgeL0_m	60
		calcEdgeL0_m	59
		calcEdgeL0_m	58
		calcEdgeL0_m	57
		calcEdgeL0_m	56
		calcEdgeL0_m	55
		calcEdgeL0_m	54
		calcEdgeL0_m	53
		calcEdgeL0_m	52
		calcEdgeL0_m	51
		calcEdgeL0_m	50
		calcEdgeL0_m	49
		calcEdgeL0_m	48
		calcEdgeL0_m	47
		calcEdgeL0_m	46
		calcEdgeL0_m	45
		calcEdgeL0_m	44
		calcEdgeL0_m	43
		calcEdgeL0_m	42
		calcEdgeL0_m	41
		calcEdgeL0_m	40
		calcEdgeL0_m	39
		calcEdgeL0_m	38
		calcEdgeL0_m	37
		calcEdgeL0_m	36
		calcEdgeL0_m	35
		calcEdgeL0_m	34
		calcEdgeL0_m	33
		calcEdgeL0_m	32
		calcEdgeL0_m	31
		calcEdgeL0_m	30
		calcEdgeL0_m	29
		calcEdgeL0_m	28
		calcEdgeL0_m	27
		calcEdgeL0_m	26
		calcEdgeL0_m	25
		calcEdgeL0_m	24
		calcEdgeL0_m	23
		calcEdgeL0_m	22
		calcEdgeL0_m	21
		calcEdgeL0_m	20
		calcEdgeL0_m	19
		calcEdgeL0_m	18
		calcEdgeL0_m	17
		calcEdgeL0_m	16
		calcEdgeL0_m	15
		calcEdgeL0_m	14
		calcEdgeL0_m	13
		calcEdgeL0_m	12
		calcEdgeL0_m	11
		calcEdgeL0_m	10
		calcEdgeL0_m	9
		calcEdgeL0_m	8
		calcEdgeL0_m	7
		calcEdgeL0_m	6
		calcEdgeL0_m	5
		calcEdgeL0_m	4
		calcEdgeL0_m	3
		calcEdgeL0_m	2
		calcEdgeL0_m	1
		calcEdgeL0_m	0

.jpEndEX
		rts

.jpAddrLow
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)
		.db	LOW(.jp8)
		.db	LOW(.jp9)
		.db	LOW(.jp10)
		.db	LOW(.jp11)
		.db	LOW(.jp12)
		.db	LOW(.jp13)
		.db	LOW(.jp14)
		.db	LOW(.jp15)
		.db	LOW(.jp16)
		.db	LOW(.jp17)
		.db	LOW(.jp18)
		.db	LOW(.jp19)
		.db	LOW(.jp20)
		.db	LOW(.jp21)
		.db	LOW(.jp22)
		.db	LOW(.jp23)
		.db	LOW(.jp24)
		.db	LOW(.jp25)
		.db	LOW(.jp26)
		.db	LOW(.jp27)
		.db	LOW(.jp28)
		.db	LOW(.jp29)
		.db	LOW(.jp30)
		.db	LOW(.jp31)
		.db	LOW(.jp32)
		.db	LOW(.jp33)
		.db	LOW(.jp34)
		.db	LOW(.jp35)
		.db	LOW(.jp36)
		.db	LOW(.jp37)
		.db	LOW(.jp38)
		.db	LOW(.jp39)
		.db	LOW(.jp40)
		.db	LOW(.jp41)
		.db	LOW(.jp42)
		.db	LOW(.jp43)
		.db	LOW(.jp44)
		.db	LOW(.jp45)
		.db	LOW(.jp46)
		.db	LOW(.jp47)
		.db	LOW(.jp48)
		.db	LOW(.jp49)
		.db	LOW(.jp50)
		.db	LOW(.jp51)
		.db	LOW(.jp52)
		.db	LOW(.jp53)
		.db	LOW(.jp54)
		.db	LOW(.jp55)
		.db	LOW(.jp56)
		.db	LOW(.jp57)
		.db	LOW(.jp58)
		.db	LOW(.jp59)
		.db	LOW(.jp60)
		.db	LOW(.jp61)
		.db	LOW(.jp62)
		.db	LOW(.jp63)
		.db	LOW(.jp64)
		.db	LOW(.jp65)
		.db	LOW(.jp66)
		.db	LOW(.jp67)
		.db	LOW(.jp68)
		.db	LOW(.jp69)
		.db	LOW(.jp70)
		.db	LOW(.jp71)
		.db	LOW(.jp72)
		.db	LOW(.jp73)
		.db	LOW(.jp74)
		.db	LOW(.jp75)
		.db	LOW(.jp76)
		.db	LOW(.jp77)
		.db	LOW(.jp78)
		.db	LOW(.jp79)
		.db	LOW(.jp80)
		.db	LOW(.jp81)
		.db	LOW(.jp82)
		.db	LOW(.jp83)
		.db	LOW(.jp84)
		.db	LOW(.jp85)
		.db	LOW(.jp86)
		.db	LOW(.jp87)
		.db	LOW(.jp88)
		.db	LOW(.jp89)
		.db	LOW(.jp90)
		.db	LOW(.jp91)
		.db	LOW(.jp92)
		.db	LOW(.jp93)
		.db	LOW(.jp94)
		.db	LOW(.jp95)
		.db	LOW(.jp96)
		.db	LOW(.jp97)
		.db	LOW(.jp98)
		.db	LOW(.jp99)
		.db	LOW(.jp100)
		.db	LOW(.jp101)
		.db	LOW(.jp102)
		.db	LOW(.jp103)
		.db	LOW(.jp104)
		.db	LOW(.jp105)
		.db	LOW(.jp106)
		.db	LOW(.jp107)
		.db	LOW(.jp108)
		.db	LOW(.jp109)
		.db	LOW(.jp110)
		.db	LOW(.jp111)
		.db	LOW(.jp112)
		.db	LOW(.jp113)
		.db	LOW(.jp114)
		.db	LOW(.jp115)
		.db	LOW(.jp116)
		.db	LOW(.jp117)
		.db	LOW(.jp118)
		.db	LOW(.jp119)
		.db	LOW(.jp120)
		.db	LOW(.jp121)
		.db	LOW(.jp122)
		.db	LOW(.jp123)
		.db	LOW(.jp124)
		.db	LOW(.jp125)
		.db	LOW(.jp126)
		.db	LOW(.jp127)
		.db	LOW(.jp128)
		.db	LOW(.jp129)
		.db	LOW(.jp130)
		.db	LOW(.jp131)
		.db	LOW(.jp132)
		.db	LOW(.jp133)
		.db	LOW(.jp134)
		.db	LOW(.jp135)
		.db	LOW(.jp136)
		.db	LOW(.jp137)
		.db	LOW(.jp138)
		.db	LOW(.jp139)
		.db	LOW(.jp140)
		.db	LOW(.jp141)
		.db	LOW(.jp142)
		.db	LOW(.jp143)
		.db	LOW(.jp144)
		.db	LOW(.jp145)
		.db	LOW(.jp146)
		.db	LOW(.jp147)
		.db	LOW(.jp148)
		.db	LOW(.jp149)
		.db	LOW(.jp150)
		.db	LOW(.jp151)
		.db	LOW(.jp152)
		.db	LOW(.jp153)
		.db	LOW(.jp154)
		.db	LOW(.jp155)
		.db	LOW(.jp156)
		.db	LOW(.jp157)
		.db	LOW(.jp158)
		.db	LOW(.jp159)
		.db	LOW(.jp160)
		.db	LOW(.jp161)
		.db	LOW(.jp162)
		.db	LOW(.jp163)
		.db	LOW(.jp164)
		.db	LOW(.jp165)
		.db	LOW(.jp166)
		.db	LOW(.jp167)
		.db	LOW(.jp168)
		.db	LOW(.jp169)
		.db	LOW(.jp170)
		.db	LOW(.jp171)
		.db	LOW(.jp172)
		.db	LOW(.jp173)
		.db	LOW(.jp174)
		.db	LOW(.jp175)
		.db	LOW(.jp176)
		.db	LOW(.jp177)
		.db	LOW(.jp178)
		.db	LOW(.jp179)
		.db	LOW(.jp180)
		.db	LOW(.jp181)
		.db	LOW(.jp182)
		.db	LOW(.jp183)
		.db	LOW(.jp184)
		.db	LOW(.jp185)
		.db	LOW(.jp186)
		.db	LOW(.jp187)
		.db	LOW(.jp188)
		.db	LOW(.jp189)
		.db	LOW(.jp190)
		.db	LOW(.jp191)
		.db	LOW(.jp192)
		.db	LOW(.jp193)
		.db	LOW(.jp194)
		.db	LOW(.jp195)
		.db	LOW(.jp196)
		.db	LOW(.jp197)
		.db	LOW(.jp198)
		.db	LOW(.jp199)
		.db	LOW(.jp200)
		.db	LOW(.jp201)
		.db	LOW(.jp202)
		.db	LOW(.jp203)
		.db	LOW(.jp204)
		.db	LOW(.jp205)
		.db	LOW(.jp206)
		.db	LOW(.jp207)
		.db	LOW(.jp208)
		.db	LOW(.jp209)
		.db	LOW(.jp210)
		.db	LOW(.jp211)
		.db	LOW(.jp212)
		.db	LOW(.jp213)
		.db	LOW(.jp214)
		.db	LOW(.jp215)
		.db	LOW(.jp216)
		.db	LOW(.jp217)
		.db	LOW(.jp218)
		.db	LOW(.jp219)
		.db	LOW(.jp220)
		.db	LOW(.jp221)
		.db	LOW(.jp222)
		.db	LOW(.jp223)
		.db	LOW(.jp224)
		.db	LOW(.jp225)
		.db	LOW(.jp226)
		.db	LOW(.jp227)
		.db	LOW(.jp228)
		.db	LOW(.jp229)
		.db	LOW(.jp230)
		.db	LOW(.jp231)
		.db	LOW(.jp232)
		.db	LOW(.jp233)
		.db	LOW(.jp234)
		.db	LOW(.jp235)
		.db	LOW(.jp236)
		.db	LOW(.jp237)
		.db	LOW(.jp238)
		.db	LOW(.jp239)
		.db	LOW(.jp240)
		.db	LOW(.jp241)
		.db	LOW(.jp242)
		.db	LOW(.jp243)
		.db	LOW(.jp244)
		.db	LOW(.jp245)
		.db	LOW(.jp246)
		.db	LOW(.jp247)
		.db	LOW(.jp248)
		.db	LOW(.jp249)
		.db	LOW(.jp250)
		.db	LOW(.jp251)
		.db	LOW(.jp252)
		.db	LOW(.jp253)
		.db	LOW(.jp254)
		.db	LOW(.jp255)

.jpAddrHigh
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)
		.db	HIGH(.jp8)
		.db	HIGH(.jp9)
		.db	HIGH(.jp10)
		.db	HIGH(.jp11)
		.db	HIGH(.jp12)
		.db	HIGH(.jp13)
		.db	HIGH(.jp14)
		.db	HIGH(.jp15)
		.db	HIGH(.jp16)
		.db	HIGH(.jp17)
		.db	HIGH(.jp18)
		.db	HIGH(.jp19)
		.db	HIGH(.jp20)
		.db	HIGH(.jp21)
		.db	HIGH(.jp22)
		.db	HIGH(.jp23)
		.db	HIGH(.jp24)
		.db	HIGH(.jp25)
		.db	HIGH(.jp26)
		.db	HIGH(.jp27)
		.db	HIGH(.jp28)
		.db	HIGH(.jp29)
		.db	HIGH(.jp30)
		.db	HIGH(.jp31)
		.db	HIGH(.jp32)
		.db	HIGH(.jp33)
		.db	HIGH(.jp34)
		.db	HIGH(.jp35)
		.db	HIGH(.jp36)
		.db	HIGH(.jp37)
		.db	HIGH(.jp38)
		.db	HIGH(.jp39)
		.db	HIGH(.jp40)
		.db	HIGH(.jp41)
		.db	HIGH(.jp42)
		.db	HIGH(.jp43)
		.db	HIGH(.jp44)
		.db	HIGH(.jp45)
		.db	HIGH(.jp46)
		.db	HIGH(.jp47)
		.db	HIGH(.jp48)
		.db	HIGH(.jp49)
		.db	HIGH(.jp50)
		.db	HIGH(.jp51)
		.db	HIGH(.jp52)
		.db	HIGH(.jp53)
		.db	HIGH(.jp54)
		.db	HIGH(.jp55)
		.db	HIGH(.jp56)
		.db	HIGH(.jp57)
		.db	HIGH(.jp58)
		.db	HIGH(.jp59)
		.db	HIGH(.jp60)
		.db	HIGH(.jp61)
		.db	HIGH(.jp62)
		.db	HIGH(.jp63)
		.db	HIGH(.jp64)
		.db	HIGH(.jp65)
		.db	HIGH(.jp66)
		.db	HIGH(.jp67)
		.db	HIGH(.jp68)
		.db	HIGH(.jp69)
		.db	HIGH(.jp70)
		.db	HIGH(.jp71)
		.db	HIGH(.jp72)
		.db	HIGH(.jp73)
		.db	HIGH(.jp74)
		.db	HIGH(.jp75)
		.db	HIGH(.jp76)
		.db	HIGH(.jp77)
		.db	HIGH(.jp78)
		.db	HIGH(.jp79)
		.db	HIGH(.jp80)
		.db	HIGH(.jp81)
		.db	HIGH(.jp82)
		.db	HIGH(.jp83)
		.db	HIGH(.jp84)
		.db	HIGH(.jp85)
		.db	HIGH(.jp86)
		.db	HIGH(.jp87)
		.db	HIGH(.jp88)
		.db	HIGH(.jp89)
		.db	HIGH(.jp90)
		.db	HIGH(.jp91)
		.db	HIGH(.jp92)
		.db	HIGH(.jp93)
		.db	HIGH(.jp94)
		.db	HIGH(.jp95)
		.db	HIGH(.jp96)
		.db	HIGH(.jp97)
		.db	HIGH(.jp98)
		.db	HIGH(.jp99)
		.db	HIGH(.jp100)
		.db	HIGH(.jp101)
		.db	HIGH(.jp102)
		.db	HIGH(.jp103)
		.db	HIGH(.jp104)
		.db	HIGH(.jp105)
		.db	HIGH(.jp106)
		.db	HIGH(.jp107)
		.db	HIGH(.jp108)
		.db	HIGH(.jp109)
		.db	HIGH(.jp110)
		.db	HIGH(.jp111)
		.db	HIGH(.jp112)
		.db	HIGH(.jp113)
		.db	HIGH(.jp114)
		.db	HIGH(.jp115)
		.db	HIGH(.jp116)
		.db	HIGH(.jp117)
		.db	HIGH(.jp118)
		.db	HIGH(.jp119)
		.db	HIGH(.jp120)
		.db	HIGH(.jp121)
		.db	HIGH(.jp122)
		.db	HIGH(.jp123)
		.db	HIGH(.jp124)
		.db	HIGH(.jp125)
		.db	HIGH(.jp126)
		.db	HIGH(.jp127)
		.db	HIGH(.jp128)
		.db	HIGH(.jp129)
		.db	HIGH(.jp130)
		.db	HIGH(.jp131)
		.db	HIGH(.jp132)
		.db	HIGH(.jp133)
		.db	HIGH(.jp134)
		.db	HIGH(.jp135)
		.db	HIGH(.jp136)
		.db	HIGH(.jp137)
		.db	HIGH(.jp138)
		.db	HIGH(.jp139)
		.db	HIGH(.jp140)
		.db	HIGH(.jp141)
		.db	HIGH(.jp142)
		.db	HIGH(.jp143)
		.db	HIGH(.jp144)
		.db	HIGH(.jp145)
		.db	HIGH(.jp146)
		.db	HIGH(.jp147)
		.db	HIGH(.jp148)
		.db	HIGH(.jp149)
		.db	HIGH(.jp150)
		.db	HIGH(.jp151)
		.db	HIGH(.jp152)
		.db	HIGH(.jp153)
		.db	HIGH(.jp154)
		.db	HIGH(.jp155)
		.db	HIGH(.jp156)
		.db	HIGH(.jp157)
		.db	HIGH(.jp158)
		.db	HIGH(.jp159)
		.db	HIGH(.jp160)
		.db	HIGH(.jp161)
		.db	HIGH(.jp162)
		.db	HIGH(.jp163)
		.db	HIGH(.jp164)
		.db	HIGH(.jp165)
		.db	HIGH(.jp166)
		.db	HIGH(.jp167)
		.db	HIGH(.jp168)
		.db	HIGH(.jp169)
		.db	HIGH(.jp170)
		.db	HIGH(.jp171)
		.db	HIGH(.jp172)
		.db	HIGH(.jp173)
		.db	HIGH(.jp174)
		.db	HIGH(.jp175)
		.db	HIGH(.jp176)
		.db	HIGH(.jp177)
		.db	HIGH(.jp178)
		.db	HIGH(.jp179)
		.db	HIGH(.jp180)
		.db	HIGH(.jp181)
		.db	HIGH(.jp182)
		.db	HIGH(.jp183)
		.db	HIGH(.jp184)
		.db	HIGH(.jp185)
		.db	HIGH(.jp186)
		.db	HIGH(.jp187)
		.db	HIGH(.jp188)
		.db	HIGH(.jp189)
		.db	HIGH(.jp190)
		.db	HIGH(.jp191)
		.db	HIGH(.jp192)
		.db	HIGH(.jp193)
		.db	HIGH(.jp194)
		.db	HIGH(.jp195)
		.db	HIGH(.jp196)
		.db	HIGH(.jp197)
		.db	HIGH(.jp198)
		.db	HIGH(.jp199)
		.db	HIGH(.jp200)
		.db	HIGH(.jp201)
		.db	HIGH(.jp202)
		.db	HIGH(.jp203)
		.db	HIGH(.jp204)
		.db	HIGH(.jp205)
		.db	HIGH(.jp206)
		.db	HIGH(.jp207)
		.db	HIGH(.jp208)
		.db	HIGH(.jp209)
		.db	HIGH(.jp210)
		.db	HIGH(.jp211)
		.db	HIGH(.jp212)
		.db	HIGH(.jp213)
		.db	HIGH(.jp214)
		.db	HIGH(.jp215)
		.db	HIGH(.jp216)
		.db	HIGH(.jp217)
		.db	HIGH(.jp218)
		.db	HIGH(.jp219)
		.db	HIGH(.jp220)
		.db	HIGH(.jp221)
		.db	HIGH(.jp222)
		.db	HIGH(.jp223)
		.db	HIGH(.jp224)
		.db	HIGH(.jp225)
		.db	HIGH(.jp226)
		.db	HIGH(.jp227)
		.db	HIGH(.jp228)
		.db	HIGH(.jp229)
		.db	HIGH(.jp230)
		.db	HIGH(.jp231)
		.db	HIGH(.jp232)
		.db	HIGH(.jp233)
		.db	HIGH(.jp234)
		.db	HIGH(.jp235)
		.db	HIGH(.jp236)
		.db	HIGH(.jp237)
		.db	HIGH(.jp238)
		.db	HIGH(.jp239)
		.db	HIGH(.jp240)
		.db	HIGH(.jp241)
		.db	HIGH(.jp242)
		.db	HIGH(.jp243)
		.db	HIGH(.jp244)
		.db	HIGH(.jp245)
		.db	HIGH(.jp246)
		.db	HIGH(.jp247)
		.db	HIGH(.jp248)
		.db	HIGH(.jp249)
		.db	HIGH(.jp250)
		.db	HIGH(.jp251)
		.db	HIGH(.jp252)
		.db	HIGH(.jp253)
		.db	HIGH(.jp254)
		.db	HIGH(.jp255)


;----------------------------
calcEdgeL1:
;
		ldx	<edgeSlopeX
		lda	.jpAddrLow, x
		sta	<edgeJumpAddr
		lda	.jpAddrHigh, x
		sta	<edgeJumpAddr+1

		lda	<edgeSlopeX
		eor	#$FF
		inc	a

		ldx	<edgeX0
		ldy	<edgeY0

		clc
		jmp	[edgeJumpAddr]

.jp255:
		sax
		sta	edgeLeft, y
		sax

		calcEdgeL1_m	254
		calcEdgeL1_m	253
		calcEdgeL1_m	252
		calcEdgeL1_m	251
		calcEdgeL1_m	250
		calcEdgeL1_m	249
		calcEdgeL1_m	248
		calcEdgeL1_m	247
		calcEdgeL1_m	246
		calcEdgeL1_m	245
		calcEdgeL1_m	244
		calcEdgeL1_m	243
		calcEdgeL1_m	242
		calcEdgeL1_m	241
		calcEdgeL1_m	240
		calcEdgeL1_m	239
		calcEdgeL1_m	238
		calcEdgeL1_m	237
		calcEdgeL1_m	236
		calcEdgeL1_m	235
		calcEdgeL1_m	234
		calcEdgeL1_m	233
		calcEdgeL1_m	232
		calcEdgeL1_m	231
		calcEdgeL1_m	230
		calcEdgeL1_m	229
		calcEdgeL1_m	228
		calcEdgeL1_m	227
		calcEdgeL1_m	226
		calcEdgeL1_m	225
		calcEdgeL1_m	224
		calcEdgeL1_m	223
		calcEdgeL1_m	222
		calcEdgeL1_m	221
		calcEdgeL1_m	220
		calcEdgeL1_m	219
		calcEdgeL1_m	218
		calcEdgeL1_m	217
		calcEdgeL1_m	216
		calcEdgeL1_m	215
		calcEdgeL1_m	214
		calcEdgeL1_m	213
		calcEdgeL1_m	212
		calcEdgeL1_m	211
		calcEdgeL1_m	210
		calcEdgeL1_m	209
		calcEdgeL1_m	208
		calcEdgeL1_m	207
		calcEdgeL1_m	206
		calcEdgeL1_m	205
		calcEdgeL1_m	204
		calcEdgeL1_m	203
		calcEdgeL1_m	202
		calcEdgeL1_m	201
		calcEdgeL1_m	200
		calcEdgeL1_m	199
		calcEdgeL1_m	198
		calcEdgeL1_m	197
		calcEdgeL1_m	196
		calcEdgeL1_m	195
		calcEdgeL1_m	194
		calcEdgeL1_m	193
		calcEdgeL1_m	192
		calcEdgeL1_m	191
		calcEdgeL1_m	190
		calcEdgeL1_m	189
		calcEdgeL1_m	188
		calcEdgeL1_m	187
		calcEdgeL1_m	186
		calcEdgeL1_m	185
		calcEdgeL1_m	184
		calcEdgeL1_m	183
		calcEdgeL1_m	182
		calcEdgeL1_m	181
		calcEdgeL1_m	180
		calcEdgeL1_m	179
		calcEdgeL1_m	178
		calcEdgeL1_m	177
		calcEdgeL1_m	176
		calcEdgeL1_m	175
		calcEdgeL1_m	174
		calcEdgeL1_m	173
		calcEdgeL1_m	172
		calcEdgeL1_m	171
		calcEdgeL1_m	170
		calcEdgeL1_m	169
		calcEdgeL1_m	168
		calcEdgeL1_m	167
		calcEdgeL1_m	166
		calcEdgeL1_m	165
		calcEdgeL1_m	164
		calcEdgeL1_m	163
		calcEdgeL1_m	162
		calcEdgeL1_m	161
		calcEdgeL1_m	160
		calcEdgeL1_m	159
		calcEdgeL1_m	158
		calcEdgeL1_m	157
		calcEdgeL1_m	156
		calcEdgeL1_m	155
		calcEdgeL1_m	154
		calcEdgeL1_m	153
		calcEdgeL1_m	152
		calcEdgeL1_m	151
		calcEdgeL1_m	150
		calcEdgeL1_m	149
		calcEdgeL1_m	148
		calcEdgeL1_m	147
		calcEdgeL1_m	146
		calcEdgeL1_m	145
		calcEdgeL1_m	144
		calcEdgeL1_m	143
		calcEdgeL1_m	142
		calcEdgeL1_m	141
		calcEdgeL1_m	140
		calcEdgeL1_m	139
		calcEdgeL1_m	138
		calcEdgeL1_m	137
		calcEdgeL1_m	136
		calcEdgeL1_m	135
		calcEdgeL1_m	134
		calcEdgeL1_m	133
		calcEdgeL1_m	132
		calcEdgeL1_m	131
		calcEdgeL1_m	130
		calcEdgeL1_m	129
		calcEdgeL1_m	128
		calcEdgeL1_m	127
		calcEdgeL1_m	126
		calcEdgeL1_m	125
		calcEdgeL1_m	124
		calcEdgeL1_m	123
		calcEdgeL1_m	122
		calcEdgeL1_m	121
		calcEdgeL1_m	120
		calcEdgeL1_m	119
		calcEdgeL1_m	118
		calcEdgeL1_m	117
		calcEdgeL1_m	116
		calcEdgeL1_m	115
		calcEdgeL1_m	114
		calcEdgeL1_m	113
		calcEdgeL1_m	112
		calcEdgeL1_m	111
		calcEdgeL1_m	110
		calcEdgeL1_m	109
		calcEdgeL1_m	108
		calcEdgeL1_m	107
		calcEdgeL1_m	106
		calcEdgeL1_m	105
		calcEdgeL1_m	104
		calcEdgeL1_m	103
		calcEdgeL1_m	102
		calcEdgeL1_m	101
		calcEdgeL1_m	100
		calcEdgeL1_m	99
		calcEdgeL1_m	98
		calcEdgeL1_m	97
		calcEdgeL1_m	96
		calcEdgeL1_m	95
		calcEdgeL1_m	94
		calcEdgeL1_m	93
		calcEdgeL1_m	92
		calcEdgeL1_m	91
		calcEdgeL1_m	90
		calcEdgeL1_m	89
		calcEdgeL1_m	88
		calcEdgeL1_m	87
		calcEdgeL1_m	86
		calcEdgeL1_m	85
		calcEdgeL1_m	84
		calcEdgeL1_m	83
		calcEdgeL1_m	82
		calcEdgeL1_m	81
		calcEdgeL1_m	80
		calcEdgeL1_m	79
		calcEdgeL1_m	78
		calcEdgeL1_m	77
		calcEdgeL1_m	76
		calcEdgeL1_m	75
		calcEdgeL1_m	74
		calcEdgeL1_m	73
		calcEdgeL1_m	72
		calcEdgeL1_m	71
		calcEdgeL1_m	70
		calcEdgeL1_m	69
		calcEdgeL1_m	68
		calcEdgeL1_m	67
		calcEdgeL1_m	66
		calcEdgeL1_m	65
		calcEdgeL1_m	64
		calcEdgeL1_m	63
		calcEdgeL1_m	62
		calcEdgeL1_m	61
		calcEdgeL1_m	60
		calcEdgeL1_m	59
		calcEdgeL1_m	58
		calcEdgeL1_m	57
		calcEdgeL1_m	56
		calcEdgeL1_m	55
		calcEdgeL1_m	54
		calcEdgeL1_m	53
		calcEdgeL1_m	52
		calcEdgeL1_m	51
		calcEdgeL1_m	50
		calcEdgeL1_m	49
		calcEdgeL1_m	48
		calcEdgeL1_m	47
		calcEdgeL1_m	46
		calcEdgeL1_m	45
		calcEdgeL1_m	44
		calcEdgeL1_m	43
		calcEdgeL1_m	42
		calcEdgeL1_m	41
		calcEdgeL1_m	40
		calcEdgeL1_m	39
		calcEdgeL1_m	38
		calcEdgeL1_m	37
		calcEdgeL1_m	36
		calcEdgeL1_m	35
		calcEdgeL1_m	34
		calcEdgeL1_m	33
		calcEdgeL1_m	32
		calcEdgeL1_m	31
		calcEdgeL1_m	30
		calcEdgeL1_m	29
		calcEdgeL1_m	28
		calcEdgeL1_m	27
		calcEdgeL1_m	26
		calcEdgeL1_m	25
		calcEdgeL1_m	24
		calcEdgeL1_m	23
		calcEdgeL1_m	22
		calcEdgeL1_m	21
		calcEdgeL1_m	20
		calcEdgeL1_m	19
		calcEdgeL1_m	18
		calcEdgeL1_m	17
		calcEdgeL1_m	16
		calcEdgeL1_m	15
		calcEdgeL1_m	14
		calcEdgeL1_m	13
		calcEdgeL1_m	12
		calcEdgeL1_m	11
		calcEdgeL1_m	10
		calcEdgeL1_m	9
		calcEdgeL1_m	8
		calcEdgeL1_m	7
		calcEdgeL1_m	6
		calcEdgeL1_m	5
		calcEdgeL1_m	4
		calcEdgeL1_m	3
		calcEdgeL1_m	2
		calcEdgeL1_m	1
		calcEdgeL1_m	0

.jpEndEX
		rts

.jpAddrLow
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)
		.db	LOW(.jp8)
		.db	LOW(.jp9)
		.db	LOW(.jp10)
		.db	LOW(.jp11)
		.db	LOW(.jp12)
		.db	LOW(.jp13)
		.db	LOW(.jp14)
		.db	LOW(.jp15)
		.db	LOW(.jp16)
		.db	LOW(.jp17)
		.db	LOW(.jp18)
		.db	LOW(.jp19)
		.db	LOW(.jp20)
		.db	LOW(.jp21)
		.db	LOW(.jp22)
		.db	LOW(.jp23)
		.db	LOW(.jp24)
		.db	LOW(.jp25)
		.db	LOW(.jp26)
		.db	LOW(.jp27)
		.db	LOW(.jp28)
		.db	LOW(.jp29)
		.db	LOW(.jp30)
		.db	LOW(.jp31)
		.db	LOW(.jp32)
		.db	LOW(.jp33)
		.db	LOW(.jp34)
		.db	LOW(.jp35)
		.db	LOW(.jp36)
		.db	LOW(.jp37)
		.db	LOW(.jp38)
		.db	LOW(.jp39)
		.db	LOW(.jp40)
		.db	LOW(.jp41)
		.db	LOW(.jp42)
		.db	LOW(.jp43)
		.db	LOW(.jp44)
		.db	LOW(.jp45)
		.db	LOW(.jp46)
		.db	LOW(.jp47)
		.db	LOW(.jp48)
		.db	LOW(.jp49)
		.db	LOW(.jp50)
		.db	LOW(.jp51)
		.db	LOW(.jp52)
		.db	LOW(.jp53)
		.db	LOW(.jp54)
		.db	LOW(.jp55)
		.db	LOW(.jp56)
		.db	LOW(.jp57)
		.db	LOW(.jp58)
		.db	LOW(.jp59)
		.db	LOW(.jp60)
		.db	LOW(.jp61)
		.db	LOW(.jp62)
		.db	LOW(.jp63)
		.db	LOW(.jp64)
		.db	LOW(.jp65)
		.db	LOW(.jp66)
		.db	LOW(.jp67)
		.db	LOW(.jp68)
		.db	LOW(.jp69)
		.db	LOW(.jp70)
		.db	LOW(.jp71)
		.db	LOW(.jp72)
		.db	LOW(.jp73)
		.db	LOW(.jp74)
		.db	LOW(.jp75)
		.db	LOW(.jp76)
		.db	LOW(.jp77)
		.db	LOW(.jp78)
		.db	LOW(.jp79)
		.db	LOW(.jp80)
		.db	LOW(.jp81)
		.db	LOW(.jp82)
		.db	LOW(.jp83)
		.db	LOW(.jp84)
		.db	LOW(.jp85)
		.db	LOW(.jp86)
		.db	LOW(.jp87)
		.db	LOW(.jp88)
		.db	LOW(.jp89)
		.db	LOW(.jp90)
		.db	LOW(.jp91)
		.db	LOW(.jp92)
		.db	LOW(.jp93)
		.db	LOW(.jp94)
		.db	LOW(.jp95)
		.db	LOW(.jp96)
		.db	LOW(.jp97)
		.db	LOW(.jp98)
		.db	LOW(.jp99)
		.db	LOW(.jp100)
		.db	LOW(.jp101)
		.db	LOW(.jp102)
		.db	LOW(.jp103)
		.db	LOW(.jp104)
		.db	LOW(.jp105)
		.db	LOW(.jp106)
		.db	LOW(.jp107)
		.db	LOW(.jp108)
		.db	LOW(.jp109)
		.db	LOW(.jp110)
		.db	LOW(.jp111)
		.db	LOW(.jp112)
		.db	LOW(.jp113)
		.db	LOW(.jp114)
		.db	LOW(.jp115)
		.db	LOW(.jp116)
		.db	LOW(.jp117)
		.db	LOW(.jp118)
		.db	LOW(.jp119)
		.db	LOW(.jp120)
		.db	LOW(.jp121)
		.db	LOW(.jp122)
		.db	LOW(.jp123)
		.db	LOW(.jp124)
		.db	LOW(.jp125)
		.db	LOW(.jp126)
		.db	LOW(.jp127)
		.db	LOW(.jp128)
		.db	LOW(.jp129)
		.db	LOW(.jp130)
		.db	LOW(.jp131)
		.db	LOW(.jp132)
		.db	LOW(.jp133)
		.db	LOW(.jp134)
		.db	LOW(.jp135)
		.db	LOW(.jp136)
		.db	LOW(.jp137)
		.db	LOW(.jp138)
		.db	LOW(.jp139)
		.db	LOW(.jp140)
		.db	LOW(.jp141)
		.db	LOW(.jp142)
		.db	LOW(.jp143)
		.db	LOW(.jp144)
		.db	LOW(.jp145)
		.db	LOW(.jp146)
		.db	LOW(.jp147)
		.db	LOW(.jp148)
		.db	LOW(.jp149)
		.db	LOW(.jp150)
		.db	LOW(.jp151)
		.db	LOW(.jp152)
		.db	LOW(.jp153)
		.db	LOW(.jp154)
		.db	LOW(.jp155)
		.db	LOW(.jp156)
		.db	LOW(.jp157)
		.db	LOW(.jp158)
		.db	LOW(.jp159)
		.db	LOW(.jp160)
		.db	LOW(.jp161)
		.db	LOW(.jp162)
		.db	LOW(.jp163)
		.db	LOW(.jp164)
		.db	LOW(.jp165)
		.db	LOW(.jp166)
		.db	LOW(.jp167)
		.db	LOW(.jp168)
		.db	LOW(.jp169)
		.db	LOW(.jp170)
		.db	LOW(.jp171)
		.db	LOW(.jp172)
		.db	LOW(.jp173)
		.db	LOW(.jp174)
		.db	LOW(.jp175)
		.db	LOW(.jp176)
		.db	LOW(.jp177)
		.db	LOW(.jp178)
		.db	LOW(.jp179)
		.db	LOW(.jp180)
		.db	LOW(.jp181)
		.db	LOW(.jp182)
		.db	LOW(.jp183)
		.db	LOW(.jp184)
		.db	LOW(.jp185)
		.db	LOW(.jp186)
		.db	LOW(.jp187)
		.db	LOW(.jp188)
		.db	LOW(.jp189)
		.db	LOW(.jp190)
		.db	LOW(.jp191)
		.db	LOW(.jp192)
		.db	LOW(.jp193)
		.db	LOW(.jp194)
		.db	LOW(.jp195)
		.db	LOW(.jp196)
		.db	LOW(.jp197)
		.db	LOW(.jp198)
		.db	LOW(.jp199)
		.db	LOW(.jp200)
		.db	LOW(.jp201)
		.db	LOW(.jp202)
		.db	LOW(.jp203)
		.db	LOW(.jp204)
		.db	LOW(.jp205)
		.db	LOW(.jp206)
		.db	LOW(.jp207)
		.db	LOW(.jp208)
		.db	LOW(.jp209)
		.db	LOW(.jp210)
		.db	LOW(.jp211)
		.db	LOW(.jp212)
		.db	LOW(.jp213)
		.db	LOW(.jp214)
		.db	LOW(.jp215)
		.db	LOW(.jp216)
		.db	LOW(.jp217)
		.db	LOW(.jp218)
		.db	LOW(.jp219)
		.db	LOW(.jp220)
		.db	LOW(.jp221)
		.db	LOW(.jp222)
		.db	LOW(.jp223)
		.db	LOW(.jp224)
		.db	LOW(.jp225)
		.db	LOW(.jp226)
		.db	LOW(.jp227)
		.db	LOW(.jp228)
		.db	LOW(.jp229)
		.db	LOW(.jp230)
		.db	LOW(.jp231)
		.db	LOW(.jp232)
		.db	LOW(.jp233)
		.db	LOW(.jp234)
		.db	LOW(.jp235)
		.db	LOW(.jp236)
		.db	LOW(.jp237)
		.db	LOW(.jp238)
		.db	LOW(.jp239)
		.db	LOW(.jp240)
		.db	LOW(.jp241)
		.db	LOW(.jp242)
		.db	LOW(.jp243)
		.db	LOW(.jp244)
		.db	LOW(.jp245)
		.db	LOW(.jp246)
		.db	LOW(.jp247)
		.db	LOW(.jp248)
		.db	LOW(.jp249)
		.db	LOW(.jp250)
		.db	LOW(.jp251)
		.db	LOW(.jp252)
		.db	LOW(.jp253)
		.db	LOW(.jp254)
		.db	LOW(.jp255)

.jpAddrHigh
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)
		.db	HIGH(.jp8)
		.db	HIGH(.jp9)
		.db	HIGH(.jp10)
		.db	HIGH(.jp11)
		.db	HIGH(.jp12)
		.db	HIGH(.jp13)
		.db	HIGH(.jp14)
		.db	HIGH(.jp15)
		.db	HIGH(.jp16)
		.db	HIGH(.jp17)
		.db	HIGH(.jp18)
		.db	HIGH(.jp19)
		.db	HIGH(.jp20)
		.db	HIGH(.jp21)
		.db	HIGH(.jp22)
		.db	HIGH(.jp23)
		.db	HIGH(.jp24)
		.db	HIGH(.jp25)
		.db	HIGH(.jp26)
		.db	HIGH(.jp27)
		.db	HIGH(.jp28)
		.db	HIGH(.jp29)
		.db	HIGH(.jp30)
		.db	HIGH(.jp31)
		.db	HIGH(.jp32)
		.db	HIGH(.jp33)
		.db	HIGH(.jp34)
		.db	HIGH(.jp35)
		.db	HIGH(.jp36)
		.db	HIGH(.jp37)
		.db	HIGH(.jp38)
		.db	HIGH(.jp39)
		.db	HIGH(.jp40)
		.db	HIGH(.jp41)
		.db	HIGH(.jp42)
		.db	HIGH(.jp43)
		.db	HIGH(.jp44)
		.db	HIGH(.jp45)
		.db	HIGH(.jp46)
		.db	HIGH(.jp47)
		.db	HIGH(.jp48)
		.db	HIGH(.jp49)
		.db	HIGH(.jp50)
		.db	HIGH(.jp51)
		.db	HIGH(.jp52)
		.db	HIGH(.jp53)
		.db	HIGH(.jp54)
		.db	HIGH(.jp55)
		.db	HIGH(.jp56)
		.db	HIGH(.jp57)
		.db	HIGH(.jp58)
		.db	HIGH(.jp59)
		.db	HIGH(.jp60)
		.db	HIGH(.jp61)
		.db	HIGH(.jp62)
		.db	HIGH(.jp63)
		.db	HIGH(.jp64)
		.db	HIGH(.jp65)
		.db	HIGH(.jp66)
		.db	HIGH(.jp67)
		.db	HIGH(.jp68)
		.db	HIGH(.jp69)
		.db	HIGH(.jp70)
		.db	HIGH(.jp71)
		.db	HIGH(.jp72)
		.db	HIGH(.jp73)
		.db	HIGH(.jp74)
		.db	HIGH(.jp75)
		.db	HIGH(.jp76)
		.db	HIGH(.jp77)
		.db	HIGH(.jp78)
		.db	HIGH(.jp79)
		.db	HIGH(.jp80)
		.db	HIGH(.jp81)
		.db	HIGH(.jp82)
		.db	HIGH(.jp83)
		.db	HIGH(.jp84)
		.db	HIGH(.jp85)
		.db	HIGH(.jp86)
		.db	HIGH(.jp87)
		.db	HIGH(.jp88)
		.db	HIGH(.jp89)
		.db	HIGH(.jp90)
		.db	HIGH(.jp91)
		.db	HIGH(.jp92)
		.db	HIGH(.jp93)
		.db	HIGH(.jp94)
		.db	HIGH(.jp95)
		.db	HIGH(.jp96)
		.db	HIGH(.jp97)
		.db	HIGH(.jp98)
		.db	HIGH(.jp99)
		.db	HIGH(.jp100)
		.db	HIGH(.jp101)
		.db	HIGH(.jp102)
		.db	HIGH(.jp103)
		.db	HIGH(.jp104)
		.db	HIGH(.jp105)
		.db	HIGH(.jp106)
		.db	HIGH(.jp107)
		.db	HIGH(.jp108)
		.db	HIGH(.jp109)
		.db	HIGH(.jp110)
		.db	HIGH(.jp111)
		.db	HIGH(.jp112)
		.db	HIGH(.jp113)
		.db	HIGH(.jp114)
		.db	HIGH(.jp115)
		.db	HIGH(.jp116)
		.db	HIGH(.jp117)
		.db	HIGH(.jp118)
		.db	HIGH(.jp119)
		.db	HIGH(.jp120)
		.db	HIGH(.jp121)
		.db	HIGH(.jp122)
		.db	HIGH(.jp123)
		.db	HIGH(.jp124)
		.db	HIGH(.jp125)
		.db	HIGH(.jp126)
		.db	HIGH(.jp127)
		.db	HIGH(.jp128)
		.db	HIGH(.jp129)
		.db	HIGH(.jp130)
		.db	HIGH(.jp131)
		.db	HIGH(.jp132)
		.db	HIGH(.jp133)
		.db	HIGH(.jp134)
		.db	HIGH(.jp135)
		.db	HIGH(.jp136)
		.db	HIGH(.jp137)
		.db	HIGH(.jp138)
		.db	HIGH(.jp139)
		.db	HIGH(.jp140)
		.db	HIGH(.jp141)
		.db	HIGH(.jp142)
		.db	HIGH(.jp143)
		.db	HIGH(.jp144)
		.db	HIGH(.jp145)
		.db	HIGH(.jp146)
		.db	HIGH(.jp147)
		.db	HIGH(.jp148)
		.db	HIGH(.jp149)
		.db	HIGH(.jp150)
		.db	HIGH(.jp151)
		.db	HIGH(.jp152)
		.db	HIGH(.jp153)
		.db	HIGH(.jp154)
		.db	HIGH(.jp155)
		.db	HIGH(.jp156)
		.db	HIGH(.jp157)
		.db	HIGH(.jp158)
		.db	HIGH(.jp159)
		.db	HIGH(.jp160)
		.db	HIGH(.jp161)
		.db	HIGH(.jp162)
		.db	HIGH(.jp163)
		.db	HIGH(.jp164)
		.db	HIGH(.jp165)
		.db	HIGH(.jp166)
		.db	HIGH(.jp167)
		.db	HIGH(.jp168)
		.db	HIGH(.jp169)
		.db	HIGH(.jp170)
		.db	HIGH(.jp171)
		.db	HIGH(.jp172)
		.db	HIGH(.jp173)
		.db	HIGH(.jp174)
		.db	HIGH(.jp175)
		.db	HIGH(.jp176)
		.db	HIGH(.jp177)
		.db	HIGH(.jp178)
		.db	HIGH(.jp179)
		.db	HIGH(.jp180)
		.db	HIGH(.jp181)
		.db	HIGH(.jp182)
		.db	HIGH(.jp183)
		.db	HIGH(.jp184)
		.db	HIGH(.jp185)
		.db	HIGH(.jp186)
		.db	HIGH(.jp187)
		.db	HIGH(.jp188)
		.db	HIGH(.jp189)
		.db	HIGH(.jp190)
		.db	HIGH(.jp191)
		.db	HIGH(.jp192)
		.db	HIGH(.jp193)
		.db	HIGH(.jp194)
		.db	HIGH(.jp195)
		.db	HIGH(.jp196)
		.db	HIGH(.jp197)
		.db	HIGH(.jp198)
		.db	HIGH(.jp199)
		.db	HIGH(.jp200)
		.db	HIGH(.jp201)
		.db	HIGH(.jp202)
		.db	HIGH(.jp203)
		.db	HIGH(.jp204)
		.db	HIGH(.jp205)
		.db	HIGH(.jp206)
		.db	HIGH(.jp207)
		.db	HIGH(.jp208)
		.db	HIGH(.jp209)
		.db	HIGH(.jp210)
		.db	HIGH(.jp211)
		.db	HIGH(.jp212)
		.db	HIGH(.jp213)
		.db	HIGH(.jp214)
		.db	HIGH(.jp215)
		.db	HIGH(.jp216)
		.db	HIGH(.jp217)
		.db	HIGH(.jp218)
		.db	HIGH(.jp219)
		.db	HIGH(.jp220)
		.db	HIGH(.jp221)
		.db	HIGH(.jp222)
		.db	HIGH(.jp223)
		.db	HIGH(.jp224)
		.db	HIGH(.jp225)
		.db	HIGH(.jp226)
		.db	HIGH(.jp227)
		.db	HIGH(.jp228)
		.db	HIGH(.jp229)
		.db	HIGH(.jp230)
		.db	HIGH(.jp231)
		.db	HIGH(.jp232)
		.db	HIGH(.jp233)
		.db	HIGH(.jp234)
		.db	HIGH(.jp235)
		.db	HIGH(.jp236)
		.db	HIGH(.jp237)
		.db	HIGH(.jp238)
		.db	HIGH(.jp239)
		.db	HIGH(.jp240)
		.db	HIGH(.jp241)
		.db	HIGH(.jp242)
		.db	HIGH(.jp243)
		.db	HIGH(.jp244)
		.db	HIGH(.jp245)
		.db	HIGH(.jp246)
		.db	HIGH(.jp247)
		.db	HIGH(.jp248)
		.db	HIGH(.jp249)
		.db	HIGH(.jp250)
		.db	HIGH(.jp251)
		.db	HIGH(.jp252)
		.db	HIGH(.jp253)
		.db	HIGH(.jp254)
		.db	HIGH(.jp255)


;----------------------------
_initializePsg:
;
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


;----------------------------
_setCgCharData:
;argw0: rom address, argw1: src CG No(0-2047), argw2: dist CG No(0-2047), argw3: character count(1-2048)
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
_setSgCharData:
;argw0: rom address, argw1: SG No(0-1022), argw2: SG No(0-1022), argw3: character count(0-511)
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


;----------------------------
_setCgToSgData:
;argw0: rom address, argw1: src CG No(0-2047), argw2: dist SG No(0-1022), arg6: top or bottom left or right
;arg6 $00:left top, $02:left bottom, $01:right top, $03:right bottom
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
