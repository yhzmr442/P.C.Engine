;poly_edgeR0_1.asm
;//////////////////////////////////
;----------------------------
calcEdgeR0_m	.macro
.jp\1EX:
		inx
		adc	<edgeSlopeY
		bcc	.jp\2EX
		sbc	<edgeSlopeX
		iny
.jp\1:
		sax
		sta	edgeRight, y
		sax
		.endm


;----------------------------
calcEdgeR1_m	.macro
.jp\1EX:
		dex
		adc	<edgeSlopeY
		bcc	.jp\2EX
		sbc	<edgeSlopeX
		iny
.jp\1:
		sax
		sta	edgeRight, y
		sax
		.endm


;//////////////////////////////////
		.org	$6000
;----------------------------
calcEdgeR0:
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
		ldy	<edgeY1

		clc
		jmp	[edgeJumpAddr]

.jp255:
		sax
		sta	edgeRight, y
		sax

		calcEdgeR0_m	254, 253
		calcEdgeR0_m	253, 252
		calcEdgeR0_m	252, 251
		calcEdgeR0_m	251, 250
		calcEdgeR0_m	250, 249
		calcEdgeR0_m	249, 248
		calcEdgeR0_m	248, 247
		calcEdgeR0_m	247, 246
		calcEdgeR0_m	246, 245
		calcEdgeR0_m	245, 244
		calcEdgeR0_m	244, 243
		calcEdgeR0_m	243, 242
		calcEdgeR0_m	242, 241
		calcEdgeR0_m	241, 240
		calcEdgeR0_m	240, 239
		calcEdgeR0_m	239, 238
		calcEdgeR0_m	238, 237
		calcEdgeR0_m	237, 236
		calcEdgeR0_m	236, 235
		calcEdgeR0_m	235, 234
		calcEdgeR0_m	234, 233
		calcEdgeR0_m	233, 232
		calcEdgeR0_m	232, 231
		calcEdgeR0_m	231, 230
		calcEdgeR0_m	230, 229
		calcEdgeR0_m	229, 228
		calcEdgeR0_m	228, 227
		calcEdgeR0_m	227, 226
		calcEdgeR0_m	226, 225
		calcEdgeR0_m	225, 224
		calcEdgeR0_m	224, 223
		calcEdgeR0_m	223, 222
		calcEdgeR0_m	222, 221
		calcEdgeR0_m	221, 220
		calcEdgeR0_m	220, 219
		calcEdgeR0_m	219, 218
		calcEdgeR0_m	218, 217
		calcEdgeR0_m	217, 216
		calcEdgeR0_m	216, 215
		calcEdgeR0_m	215, 214
		calcEdgeR0_m	214, 213
		calcEdgeR0_m	213, 212
		calcEdgeR0_m	212, 211
		calcEdgeR0_m	211, 210
		calcEdgeR0_m	210, 209
		calcEdgeR0_m	209, 208
		calcEdgeR0_m	208, 207
		calcEdgeR0_m	207, 206
		calcEdgeR0_m	206, 205
		calcEdgeR0_m	205, 204
		calcEdgeR0_m	204, 203
		calcEdgeR0_m	203, 202
		calcEdgeR0_m	202, 201
		calcEdgeR0_m	201, 200
		calcEdgeR0_m	200, 199
		calcEdgeR0_m	199, 198
		calcEdgeR0_m	198, 197
		calcEdgeR0_m	197, 196
		calcEdgeR0_m	196, 195
		calcEdgeR0_m	195, 194
		calcEdgeR0_m	194, 193
		calcEdgeR0_m	193, 192
		calcEdgeR0_m	192, 191
		calcEdgeR0_m	191, 190
		calcEdgeR0_m	190, 189
		calcEdgeR0_m	189, 188
		calcEdgeR0_m	188, 187
		calcEdgeR0_m	187, 186
		calcEdgeR0_m	186, 185
		calcEdgeR0_m	185, 184
		calcEdgeR0_m	184, 183
		calcEdgeR0_m	183, 182
		calcEdgeR0_m	182, 181
		calcEdgeR0_m	181, 180
		calcEdgeR0_m	180, 179
		calcEdgeR0_m	179, 178
		calcEdgeR0_m	178, 177
		calcEdgeR0_m	177, 176
		calcEdgeR0_m	176, 175
		calcEdgeR0_m	175, 174
		calcEdgeR0_m	174, 173
		calcEdgeR0_m	173, 172
		calcEdgeR0_m	172, 171
		calcEdgeR0_m	171, 170
		calcEdgeR0_m	170, 169
		calcEdgeR0_m	169, 168
		calcEdgeR0_m	168, 167
		calcEdgeR0_m	167, 166
		calcEdgeR0_m	166, 165
		calcEdgeR0_m	165, 164
		calcEdgeR0_m	164, 163
		calcEdgeR0_m	163, 162
		calcEdgeR0_m	162, 161
		calcEdgeR0_m	161, 160
		calcEdgeR0_m	160, 159
		calcEdgeR0_m	159, 158
		calcEdgeR0_m	158, 157
		calcEdgeR0_m	157, 156
		calcEdgeR0_m	156, 155
		calcEdgeR0_m	155, 154
		calcEdgeR0_m	154, 153
		calcEdgeR0_m	153, 152
		calcEdgeR0_m	152, 151
		calcEdgeR0_m	151, 150
		calcEdgeR0_m	150, 149
		calcEdgeR0_m	149, 148
		calcEdgeR0_m	148, 147
		calcEdgeR0_m	147, 146
		calcEdgeR0_m	146, 145
		calcEdgeR0_m	145, 144
		calcEdgeR0_m	144, 143
		calcEdgeR0_m	143, 142
		calcEdgeR0_m	142, 141
		calcEdgeR0_m	141, 140
		calcEdgeR0_m	140, 139
		calcEdgeR0_m	139, 138
		calcEdgeR0_m	138, 137
		calcEdgeR0_m	137, 136
		calcEdgeR0_m	136, 135
		calcEdgeR0_m	135, 134
		calcEdgeR0_m	134, 133
		calcEdgeR0_m	133, 132
		calcEdgeR0_m	132, 131
		calcEdgeR0_m	131, 130
		calcEdgeR0_m	130, 129
		calcEdgeR0_m	129, 128
		calcEdgeR0_m	128, 127
		calcEdgeR0_m	127, 126
		calcEdgeR0_m	126, 125
		calcEdgeR0_m	125, 124
		calcEdgeR0_m	124, 123
		calcEdgeR0_m	123, 122
		calcEdgeR0_m	122, 121
		calcEdgeR0_m	121, 120
		calcEdgeR0_m	120, 119
		calcEdgeR0_m	119, 118
		calcEdgeR0_m	118, 117
		calcEdgeR0_m	117, 116
		calcEdgeR0_m	116, 115
		calcEdgeR0_m	115, 114
		calcEdgeR0_m	114, 113
		calcEdgeR0_m	113, 112
		calcEdgeR0_m	112, 111
		calcEdgeR0_m	111, 110
		calcEdgeR0_m	110, 109
		calcEdgeR0_m	109, 108
		calcEdgeR0_m	108, 107
		calcEdgeR0_m	107, 106
		calcEdgeR0_m	106, 105
		calcEdgeR0_m	105, 104
		calcEdgeR0_m	104, 103
		calcEdgeR0_m	103, 102
		calcEdgeR0_m	102, 101
		calcEdgeR0_m	101, 100
		calcEdgeR0_m	100, 99
		calcEdgeR0_m	99, 98
		calcEdgeR0_m	98, 97
		calcEdgeR0_m	97, 96
		calcEdgeR0_m	96, 95
		calcEdgeR0_m	95, 94
		calcEdgeR0_m	94, 93
		calcEdgeR0_m	93, 92
		calcEdgeR0_m	92, 91
		calcEdgeR0_m	91, 90
		calcEdgeR0_m	90, 89
		calcEdgeR0_m	89, 88
		calcEdgeR0_m	88, 87
		calcEdgeR0_m	87, 86
		calcEdgeR0_m	86, 85
		calcEdgeR0_m	85, 84
		calcEdgeR0_m	84, 83
		calcEdgeR0_m	83, 82
		calcEdgeR0_m	82, 81
		calcEdgeR0_m	81, 80
		calcEdgeR0_m	80, 79
		calcEdgeR0_m	79, 78
		calcEdgeR0_m	78, 77
		calcEdgeR0_m	77, 76
		calcEdgeR0_m	76, 75
		calcEdgeR0_m	75, 74
		calcEdgeR0_m	74, 73
		calcEdgeR0_m	73, 72
		calcEdgeR0_m	72, 71
		calcEdgeR0_m	71, 70
		calcEdgeR0_m	70, 69
		calcEdgeR0_m	69, 68
		calcEdgeR0_m	68, 67
		calcEdgeR0_m	67, 66
		calcEdgeR0_m	66, 65
		calcEdgeR0_m	65, 64
		calcEdgeR0_m	64, 63
		calcEdgeR0_m	63, 62
		calcEdgeR0_m	62, 61
		calcEdgeR0_m	61, 60
		calcEdgeR0_m	60, 59
		calcEdgeR0_m	59, 58
		calcEdgeR0_m	58, 57
		calcEdgeR0_m	57, 56
		calcEdgeR0_m	56, 55
		calcEdgeR0_m	55, 54
		calcEdgeR0_m	54, 53
		calcEdgeR0_m	53, 52
		calcEdgeR0_m	52, 51
		calcEdgeR0_m	51, 50
		calcEdgeR0_m	50, 49
		calcEdgeR0_m	49, 48
		calcEdgeR0_m	48, 47
		calcEdgeR0_m	47, 46
		calcEdgeR0_m	46, 45
		calcEdgeR0_m	45, 44
		calcEdgeR0_m	44, 43
		calcEdgeR0_m	43, 42
		calcEdgeR0_m	42, 41
		calcEdgeR0_m	41, 40
		calcEdgeR0_m	40, 39
		calcEdgeR0_m	39, 38
		calcEdgeR0_m	38, 37
		calcEdgeR0_m	37, 36
		calcEdgeR0_m	36, 35
		calcEdgeR0_m	35, 34
		calcEdgeR0_m	34, 33
		calcEdgeR0_m	33, 32
		calcEdgeR0_m	32, 31
		calcEdgeR0_m	31, 30
		calcEdgeR0_m	30, 29
		calcEdgeR0_m	29, 28
		calcEdgeR0_m	28, 27
		calcEdgeR0_m	27, 26
		calcEdgeR0_m	26, 25
		calcEdgeR0_m	25, 24
		calcEdgeR0_m	24, 23
		calcEdgeR0_m	23, 22
		calcEdgeR0_m	22, 21
		calcEdgeR0_m	21, 20
		calcEdgeR0_m	20, 19
		calcEdgeR0_m	19, 18
		calcEdgeR0_m	18, 17
		calcEdgeR0_m	17, 16
		calcEdgeR0_m	16, 15
		calcEdgeR0_m	15, 14
		calcEdgeR0_m	14, 13
		calcEdgeR0_m	13, 12
		calcEdgeR0_m	12, 11
		calcEdgeR0_m	11, 10
		calcEdgeR0_m	10, 9
		calcEdgeR0_m	9, 8
		calcEdgeR0_m	8, 7
		calcEdgeR0_m	7, 6
		calcEdgeR0_m	6, 5
		calcEdgeR0_m	5, 4
		calcEdgeR0_m	4, 3
		calcEdgeR0_m	3, 2
		calcEdgeR0_m	2, 1
		calcEdgeR0_m	1, 0
		calcEdgeR0_m	0, End

.jpEndEX
		rts

.jpAddrLow
		.db	.jp0 % 256
		.db	.jp1 % 256
		.db	.jp2 % 256
		.db	.jp3 % 256
		.db	.jp4 % 256
		.db	.jp5 % 256
		.db	.jp6 % 256
		.db	.jp7 % 256
		.db	.jp8 % 256
		.db	.jp9 % 256
		.db	.jp10 % 256
		.db	.jp11 % 256
		.db	.jp12 % 256
		.db	.jp13 % 256
		.db	.jp14 % 256
		.db	.jp15 % 256
		.db	.jp16 % 256
		.db	.jp17 % 256
		.db	.jp18 % 256
		.db	.jp19 % 256
		.db	.jp20 % 256
		.db	.jp21 % 256
		.db	.jp22 % 256
		.db	.jp23 % 256
		.db	.jp24 % 256
		.db	.jp25 % 256
		.db	.jp26 % 256
		.db	.jp27 % 256
		.db	.jp28 % 256
		.db	.jp29 % 256
		.db	.jp30 % 256
		.db	.jp31 % 256
		.db	.jp32 % 256
		.db	.jp33 % 256
		.db	.jp34 % 256
		.db	.jp35 % 256
		.db	.jp36 % 256
		.db	.jp37 % 256
		.db	.jp38 % 256
		.db	.jp39 % 256
		.db	.jp40 % 256
		.db	.jp41 % 256
		.db	.jp42 % 256
		.db	.jp43 % 256
		.db	.jp44 % 256
		.db	.jp45 % 256
		.db	.jp46 % 256
		.db	.jp47 % 256
		.db	.jp48 % 256
		.db	.jp49 % 256
		.db	.jp50 % 256
		.db	.jp51 % 256
		.db	.jp52 % 256
		.db	.jp53 % 256
		.db	.jp54 % 256
		.db	.jp55 % 256
		.db	.jp56 % 256
		.db	.jp57 % 256
		.db	.jp58 % 256
		.db	.jp59 % 256
		.db	.jp60 % 256
		.db	.jp61 % 256
		.db	.jp62 % 256
		.db	.jp63 % 256
		.db	.jp64 % 256
		.db	.jp65 % 256
		.db	.jp66 % 256
		.db	.jp67 % 256
		.db	.jp68 % 256
		.db	.jp69 % 256
		.db	.jp70 % 256
		.db	.jp71 % 256
		.db	.jp72 % 256
		.db	.jp73 % 256
		.db	.jp74 % 256
		.db	.jp75 % 256
		.db	.jp76 % 256
		.db	.jp77 % 256
		.db	.jp78 % 256
		.db	.jp79 % 256
		.db	.jp80 % 256
		.db	.jp81 % 256
		.db	.jp82 % 256
		.db	.jp83 % 256
		.db	.jp84 % 256
		.db	.jp85 % 256
		.db	.jp86 % 256
		.db	.jp87 % 256
		.db	.jp88 % 256
		.db	.jp89 % 256
		.db	.jp90 % 256
		.db	.jp91 % 256
		.db	.jp92 % 256
		.db	.jp93 % 256
		.db	.jp94 % 256
		.db	.jp95 % 256
		.db	.jp96 % 256
		.db	.jp97 % 256
		.db	.jp98 % 256
		.db	.jp99 % 256
		.db	.jp100 % 256
		.db	.jp101 % 256
		.db	.jp102 % 256
		.db	.jp103 % 256
		.db	.jp104 % 256
		.db	.jp105 % 256
		.db	.jp106 % 256
		.db	.jp107 % 256
		.db	.jp108 % 256
		.db	.jp109 % 256
		.db	.jp110 % 256
		.db	.jp111 % 256
		.db	.jp112 % 256
		.db	.jp113 % 256
		.db	.jp114 % 256
		.db	.jp115 % 256
		.db	.jp116 % 256
		.db	.jp117 % 256
		.db	.jp118 % 256
		.db	.jp119 % 256
		.db	.jp120 % 256
		.db	.jp121 % 256
		.db	.jp122 % 256
		.db	.jp123 % 256
		.db	.jp124 % 256
		.db	.jp125 % 256
		.db	.jp126 % 256
		.db	.jp127 % 256
		.db	.jp128 % 256
		.db	.jp129 % 256
		.db	.jp130 % 256
		.db	.jp131 % 256
		.db	.jp132 % 256
		.db	.jp133 % 256
		.db	.jp134 % 256
		.db	.jp135 % 256
		.db	.jp136 % 256
		.db	.jp137 % 256
		.db	.jp138 % 256
		.db	.jp139 % 256
		.db	.jp140 % 256
		.db	.jp141 % 256
		.db	.jp142 % 256
		.db	.jp143 % 256
		.db	.jp144 % 256
		.db	.jp145 % 256
		.db	.jp146 % 256
		.db	.jp147 % 256
		.db	.jp148 % 256
		.db	.jp149 % 256
		.db	.jp150 % 256
		.db	.jp151 % 256
		.db	.jp152 % 256
		.db	.jp153 % 256
		.db	.jp154 % 256
		.db	.jp155 % 256
		.db	.jp156 % 256
		.db	.jp157 % 256
		.db	.jp158 % 256
		.db	.jp159 % 256
		.db	.jp160 % 256
		.db	.jp161 % 256
		.db	.jp162 % 256
		.db	.jp163 % 256
		.db	.jp164 % 256
		.db	.jp165 % 256
		.db	.jp166 % 256
		.db	.jp167 % 256
		.db	.jp168 % 256
		.db	.jp169 % 256
		.db	.jp170 % 256
		.db	.jp171 % 256
		.db	.jp172 % 256
		.db	.jp173 % 256
		.db	.jp174 % 256
		.db	.jp175 % 256
		.db	.jp176 % 256
		.db	.jp177 % 256
		.db	.jp178 % 256
		.db	.jp179 % 256
		.db	.jp180 % 256
		.db	.jp181 % 256
		.db	.jp182 % 256
		.db	.jp183 % 256
		.db	.jp184 % 256
		.db	.jp185 % 256
		.db	.jp186 % 256
		.db	.jp187 % 256
		.db	.jp188 % 256
		.db	.jp189 % 256
		.db	.jp190 % 256
		.db	.jp191 % 256
		.db	.jp192 % 256
		.db	.jp193 % 256
		.db	.jp194 % 256
		.db	.jp195 % 256
		.db	.jp196 % 256
		.db	.jp197 % 256
		.db	.jp198 % 256
		.db	.jp199 % 256
		.db	.jp200 % 256
		.db	.jp201 % 256
		.db	.jp202 % 256
		.db	.jp203 % 256
		.db	.jp204 % 256
		.db	.jp205 % 256
		.db	.jp206 % 256
		.db	.jp207 % 256
		.db	.jp208 % 256
		.db	.jp209 % 256
		.db	.jp210 % 256
		.db	.jp211 % 256
		.db	.jp212 % 256
		.db	.jp213 % 256
		.db	.jp214 % 256
		.db	.jp215 % 256
		.db	.jp216 % 256
		.db	.jp217 % 256
		.db	.jp218 % 256
		.db	.jp219 % 256
		.db	.jp220 % 256
		.db	.jp221 % 256
		.db	.jp222 % 256
		.db	.jp223 % 256
		.db	.jp224 % 256
		.db	.jp225 % 256
		.db	.jp226 % 256
		.db	.jp227 % 256
		.db	.jp228 % 256
		.db	.jp229 % 256
		.db	.jp230 % 256
		.db	.jp231 % 256
		.db	.jp232 % 256
		.db	.jp233 % 256
		.db	.jp234 % 256
		.db	.jp235 % 256
		.db	.jp236 % 256
		.db	.jp237 % 256
		.db	.jp238 % 256
		.db	.jp239 % 256
		.db	.jp240 % 256
		.db	.jp241 % 256
		.db	.jp242 % 256
		.db	.jp243 % 256
		.db	.jp244 % 256
		.db	.jp245 % 256
		.db	.jp246 % 256
		.db	.jp247 % 256
		.db	.jp248 % 256
		.db	.jp249 % 256
		.db	.jp250 % 256
		.db	.jp251 % 256
		.db	.jp252 % 256
		.db	.jp253 % 256
		.db	.jp254 % 256
		.db	.jp255 % 256

.jpAddrHigh
		.db	.jp0 / 256
		.db	.jp1 / 256
		.db	.jp2 / 256
		.db	.jp3 / 256
		.db	.jp4 / 256
		.db	.jp5 / 256
		.db	.jp6 / 256
		.db	.jp7 / 256
		.db	.jp8 / 256
		.db	.jp9 / 256
		.db	.jp10 / 256
		.db	.jp11 / 256
		.db	.jp12 / 256
		.db	.jp13 / 256
		.db	.jp14 / 256
		.db	.jp15 / 256
		.db	.jp16 / 256
		.db	.jp17 / 256
		.db	.jp18 / 256
		.db	.jp19 / 256
		.db	.jp20 / 256
		.db	.jp21 / 256
		.db	.jp22 / 256
		.db	.jp23 / 256
		.db	.jp24 / 256
		.db	.jp25 / 256
		.db	.jp26 / 256
		.db	.jp27 / 256
		.db	.jp28 / 256
		.db	.jp29 / 256
		.db	.jp30 / 256
		.db	.jp31 / 256
		.db	.jp32 / 256
		.db	.jp33 / 256
		.db	.jp34 / 256
		.db	.jp35 / 256
		.db	.jp36 / 256
		.db	.jp37 / 256
		.db	.jp38 / 256
		.db	.jp39 / 256
		.db	.jp40 / 256
		.db	.jp41 / 256
		.db	.jp42 / 256
		.db	.jp43 / 256
		.db	.jp44 / 256
		.db	.jp45 / 256
		.db	.jp46 / 256
		.db	.jp47 / 256
		.db	.jp48 / 256
		.db	.jp49 / 256
		.db	.jp50 / 256
		.db	.jp51 / 256
		.db	.jp52 / 256
		.db	.jp53 / 256
		.db	.jp54 / 256
		.db	.jp55 / 256
		.db	.jp56 / 256
		.db	.jp57 / 256
		.db	.jp58 / 256
		.db	.jp59 / 256
		.db	.jp60 / 256
		.db	.jp61 / 256
		.db	.jp62 / 256
		.db	.jp63 / 256
		.db	.jp64 / 256
		.db	.jp65 / 256
		.db	.jp66 / 256
		.db	.jp67 / 256
		.db	.jp68 / 256
		.db	.jp69 / 256
		.db	.jp70 / 256
		.db	.jp71 / 256
		.db	.jp72 / 256
		.db	.jp73 / 256
		.db	.jp74 / 256
		.db	.jp75 / 256
		.db	.jp76 / 256
		.db	.jp77 / 256
		.db	.jp78 / 256
		.db	.jp79 / 256
		.db	.jp80 / 256
		.db	.jp81 / 256
		.db	.jp82 / 256
		.db	.jp83 / 256
		.db	.jp84 / 256
		.db	.jp85 / 256
		.db	.jp86 / 256
		.db	.jp87 / 256
		.db	.jp88 / 256
		.db	.jp89 / 256
		.db	.jp90 / 256
		.db	.jp91 / 256
		.db	.jp92 / 256
		.db	.jp93 / 256
		.db	.jp94 / 256
		.db	.jp95 / 256
		.db	.jp96 / 256
		.db	.jp97 / 256
		.db	.jp98 / 256
		.db	.jp99 / 256
		.db	.jp100 / 256
		.db	.jp101 / 256
		.db	.jp102 / 256
		.db	.jp103 / 256
		.db	.jp104 / 256
		.db	.jp105 / 256
		.db	.jp106 / 256
		.db	.jp107 / 256
		.db	.jp108 / 256
		.db	.jp109 / 256
		.db	.jp110 / 256
		.db	.jp111 / 256
		.db	.jp112 / 256
		.db	.jp113 / 256
		.db	.jp114 / 256
		.db	.jp115 / 256
		.db	.jp116 / 256
		.db	.jp117 / 256
		.db	.jp118 / 256
		.db	.jp119 / 256
		.db	.jp120 / 256
		.db	.jp121 / 256
		.db	.jp122 / 256
		.db	.jp123 / 256
		.db	.jp124 / 256
		.db	.jp125 / 256
		.db	.jp126 / 256
		.db	.jp127 / 256
		.db	.jp128 / 256
		.db	.jp129 / 256
		.db	.jp130 / 256
		.db	.jp131 / 256
		.db	.jp132 / 256
		.db	.jp133 / 256
		.db	.jp134 / 256
		.db	.jp135 / 256
		.db	.jp136 / 256
		.db	.jp137 / 256
		.db	.jp138 / 256
		.db	.jp139 / 256
		.db	.jp140 / 256
		.db	.jp141 / 256
		.db	.jp142 / 256
		.db	.jp143 / 256
		.db	.jp144 / 256
		.db	.jp145 / 256
		.db	.jp146 / 256
		.db	.jp147 / 256
		.db	.jp148 / 256
		.db	.jp149 / 256
		.db	.jp150 / 256
		.db	.jp151 / 256
		.db	.jp152 / 256
		.db	.jp153 / 256
		.db	.jp154 / 256
		.db	.jp155 / 256
		.db	.jp156 / 256
		.db	.jp157 / 256
		.db	.jp158 / 256
		.db	.jp159 / 256
		.db	.jp160 / 256
		.db	.jp161 / 256
		.db	.jp162 / 256
		.db	.jp163 / 256
		.db	.jp164 / 256
		.db	.jp165 / 256
		.db	.jp166 / 256
		.db	.jp167 / 256
		.db	.jp168 / 256
		.db	.jp169 / 256
		.db	.jp170 / 256
		.db	.jp171 / 256
		.db	.jp172 / 256
		.db	.jp173 / 256
		.db	.jp174 / 256
		.db	.jp175 / 256
		.db	.jp176 / 256
		.db	.jp177 / 256
		.db	.jp178 / 256
		.db	.jp179 / 256
		.db	.jp180 / 256
		.db	.jp181 / 256
		.db	.jp182 / 256
		.db	.jp183 / 256
		.db	.jp184 / 256
		.db	.jp185 / 256
		.db	.jp186 / 256
		.db	.jp187 / 256
		.db	.jp188 / 256
		.db	.jp189 / 256
		.db	.jp190 / 256
		.db	.jp191 / 256
		.db	.jp192 / 256
		.db	.jp193 / 256
		.db	.jp194 / 256
		.db	.jp195 / 256
		.db	.jp196 / 256
		.db	.jp197 / 256
		.db	.jp198 / 256
		.db	.jp199 / 256
		.db	.jp200 / 256
		.db	.jp201 / 256
		.db	.jp202 / 256
		.db	.jp203 / 256
		.db	.jp204 / 256
		.db	.jp205 / 256
		.db	.jp206 / 256
		.db	.jp207 / 256
		.db	.jp208 / 256
		.db	.jp209 / 256
		.db	.jp210 / 256
		.db	.jp211 / 256
		.db	.jp212 / 256
		.db	.jp213 / 256
		.db	.jp214 / 256
		.db	.jp215 / 256
		.db	.jp216 / 256
		.db	.jp217 / 256
		.db	.jp218 / 256
		.db	.jp219 / 256
		.db	.jp220 / 256
		.db	.jp221 / 256
		.db	.jp222 / 256
		.db	.jp223 / 256
		.db	.jp224 / 256
		.db	.jp225 / 256
		.db	.jp226 / 256
		.db	.jp227 / 256
		.db	.jp228 / 256
		.db	.jp229 / 256
		.db	.jp230 / 256
		.db	.jp231 / 256
		.db	.jp232 / 256
		.db	.jp233 / 256
		.db	.jp234 / 256
		.db	.jp235 / 256
		.db	.jp236 / 256
		.db	.jp237 / 256
		.db	.jp238 / 256
		.db	.jp239 / 256
		.db	.jp240 / 256
		.db	.jp241 / 256
		.db	.jp242 / 256
		.db	.jp243 / 256
		.db	.jp244 / 256
		.db	.jp245 / 256
		.db	.jp246 / 256
		.db	.jp247 / 256
		.db	.jp248 / 256
		.db	.jp249 / 256
		.db	.jp250 / 256
		.db	.jp251 / 256
		.db	.jp252 / 256
		.db	.jp253 / 256
		.db	.jp254 / 256
		.db	.jp255 / 256


;----------------------------
calcEdgeR1:
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
		ldy	<edgeY1

		clc
		jmp	[edgeJumpAddr]

.jp255:
		sax
		sta	edgeRight, y
		sax

		calcEdgeR1_m	254, 253
		calcEdgeR1_m	253, 252
		calcEdgeR1_m	252, 251
		calcEdgeR1_m	251, 250
		calcEdgeR1_m	250, 249
		calcEdgeR1_m	249, 248
		calcEdgeR1_m	248, 247
		calcEdgeR1_m	247, 246
		calcEdgeR1_m	246, 245
		calcEdgeR1_m	245, 244
		calcEdgeR1_m	244, 243
		calcEdgeR1_m	243, 242
		calcEdgeR1_m	242, 241
		calcEdgeR1_m	241, 240
		calcEdgeR1_m	240, 239
		calcEdgeR1_m	239, 238
		calcEdgeR1_m	238, 237
		calcEdgeR1_m	237, 236
		calcEdgeR1_m	236, 235
		calcEdgeR1_m	235, 234
		calcEdgeR1_m	234, 233
		calcEdgeR1_m	233, 232
		calcEdgeR1_m	232, 231
		calcEdgeR1_m	231, 230
		calcEdgeR1_m	230, 229
		calcEdgeR1_m	229, 228
		calcEdgeR1_m	228, 227
		calcEdgeR1_m	227, 226
		calcEdgeR1_m	226, 225
		calcEdgeR1_m	225, 224
		calcEdgeR1_m	224, 223
		calcEdgeR1_m	223, 222
		calcEdgeR1_m	222, 221
		calcEdgeR1_m	221, 220
		calcEdgeR1_m	220, 219
		calcEdgeR1_m	219, 218
		calcEdgeR1_m	218, 217
		calcEdgeR1_m	217, 216
		calcEdgeR1_m	216, 215
		calcEdgeR1_m	215, 214
		calcEdgeR1_m	214, 213
		calcEdgeR1_m	213, 212
		calcEdgeR1_m	212, 211
		calcEdgeR1_m	211, 210
		calcEdgeR1_m	210, 209
		calcEdgeR1_m	209, 208
		calcEdgeR1_m	208, 207
		calcEdgeR1_m	207, 206
		calcEdgeR1_m	206, 205
		calcEdgeR1_m	205, 204
		calcEdgeR1_m	204, 203
		calcEdgeR1_m	203, 202
		calcEdgeR1_m	202, 201
		calcEdgeR1_m	201, 200
		calcEdgeR1_m	200, 199
		calcEdgeR1_m	199, 198
		calcEdgeR1_m	198, 197
		calcEdgeR1_m	197, 196
		calcEdgeR1_m	196, 195
		calcEdgeR1_m	195, 194
		calcEdgeR1_m	194, 193
		calcEdgeR1_m	193, 192
		calcEdgeR1_m	192, 191
		calcEdgeR1_m	191, 190
		calcEdgeR1_m	190, 189
		calcEdgeR1_m	189, 188
		calcEdgeR1_m	188, 187
		calcEdgeR1_m	187, 186
		calcEdgeR1_m	186, 185
		calcEdgeR1_m	185, 184
		calcEdgeR1_m	184, 183
		calcEdgeR1_m	183, 182
		calcEdgeR1_m	182, 181
		calcEdgeR1_m	181, 180
		calcEdgeR1_m	180, 179
		calcEdgeR1_m	179, 178
		calcEdgeR1_m	178, 177
		calcEdgeR1_m	177, 176
		calcEdgeR1_m	176, 175
		calcEdgeR1_m	175, 174
		calcEdgeR1_m	174, 173
		calcEdgeR1_m	173, 172
		calcEdgeR1_m	172, 171
		calcEdgeR1_m	171, 170
		calcEdgeR1_m	170, 169
		calcEdgeR1_m	169, 168
		calcEdgeR1_m	168, 167
		calcEdgeR1_m	167, 166
		calcEdgeR1_m	166, 165
		calcEdgeR1_m	165, 164
		calcEdgeR1_m	164, 163
		calcEdgeR1_m	163, 162
		calcEdgeR1_m	162, 161
		calcEdgeR1_m	161, 160
		calcEdgeR1_m	160, 159
		calcEdgeR1_m	159, 158
		calcEdgeR1_m	158, 157
		calcEdgeR1_m	157, 156
		calcEdgeR1_m	156, 155
		calcEdgeR1_m	155, 154
		calcEdgeR1_m	154, 153
		calcEdgeR1_m	153, 152
		calcEdgeR1_m	152, 151
		calcEdgeR1_m	151, 150
		calcEdgeR1_m	150, 149
		calcEdgeR1_m	149, 148
		calcEdgeR1_m	148, 147
		calcEdgeR1_m	147, 146
		calcEdgeR1_m	146, 145
		calcEdgeR1_m	145, 144
		calcEdgeR1_m	144, 143
		calcEdgeR1_m	143, 142
		calcEdgeR1_m	142, 141
		calcEdgeR1_m	141, 140
		calcEdgeR1_m	140, 139
		calcEdgeR1_m	139, 138
		calcEdgeR1_m	138, 137
		calcEdgeR1_m	137, 136
		calcEdgeR1_m	136, 135
		calcEdgeR1_m	135, 134
		calcEdgeR1_m	134, 133
		calcEdgeR1_m	133, 132
		calcEdgeR1_m	132, 131
		calcEdgeR1_m	131, 130
		calcEdgeR1_m	130, 129
		calcEdgeR1_m	129, 128
		calcEdgeR1_m	128, 127
		calcEdgeR1_m	127, 126
		calcEdgeR1_m	126, 125
		calcEdgeR1_m	125, 124
		calcEdgeR1_m	124, 123
		calcEdgeR1_m	123, 122
		calcEdgeR1_m	122, 121
		calcEdgeR1_m	121, 120
		calcEdgeR1_m	120, 119
		calcEdgeR1_m	119, 118
		calcEdgeR1_m	118, 117
		calcEdgeR1_m	117, 116
		calcEdgeR1_m	116, 115
		calcEdgeR1_m	115, 114
		calcEdgeR1_m	114, 113
		calcEdgeR1_m	113, 112
		calcEdgeR1_m	112, 111
		calcEdgeR1_m	111, 110
		calcEdgeR1_m	110, 109
		calcEdgeR1_m	109, 108
		calcEdgeR1_m	108, 107
		calcEdgeR1_m	107, 106
		calcEdgeR1_m	106, 105
		calcEdgeR1_m	105, 104
		calcEdgeR1_m	104, 103
		calcEdgeR1_m	103, 102
		calcEdgeR1_m	102, 101
		calcEdgeR1_m	101, 100
		calcEdgeR1_m	100, 99
		calcEdgeR1_m	99, 98
		calcEdgeR1_m	98, 97
		calcEdgeR1_m	97, 96
		calcEdgeR1_m	96, 95
		calcEdgeR1_m	95, 94
		calcEdgeR1_m	94, 93
		calcEdgeR1_m	93, 92
		calcEdgeR1_m	92, 91
		calcEdgeR1_m	91, 90
		calcEdgeR1_m	90, 89
		calcEdgeR1_m	89, 88
		calcEdgeR1_m	88, 87
		calcEdgeR1_m	87, 86
		calcEdgeR1_m	86, 85
		calcEdgeR1_m	85, 84
		calcEdgeR1_m	84, 83
		calcEdgeR1_m	83, 82
		calcEdgeR1_m	82, 81
		calcEdgeR1_m	81, 80
		calcEdgeR1_m	80, 79
		calcEdgeR1_m	79, 78
		calcEdgeR1_m	78, 77
		calcEdgeR1_m	77, 76
		calcEdgeR1_m	76, 75
		calcEdgeR1_m	75, 74
		calcEdgeR1_m	74, 73
		calcEdgeR1_m	73, 72
		calcEdgeR1_m	72, 71
		calcEdgeR1_m	71, 70
		calcEdgeR1_m	70, 69
		calcEdgeR1_m	69, 68
		calcEdgeR1_m	68, 67
		calcEdgeR1_m	67, 66
		calcEdgeR1_m	66, 65
		calcEdgeR1_m	65, 64
		calcEdgeR1_m	64, 63
		calcEdgeR1_m	63, 62
		calcEdgeR1_m	62, 61
		calcEdgeR1_m	61, 60
		calcEdgeR1_m	60, 59
		calcEdgeR1_m	59, 58
		calcEdgeR1_m	58, 57
		calcEdgeR1_m	57, 56
		calcEdgeR1_m	56, 55
		calcEdgeR1_m	55, 54
		calcEdgeR1_m	54, 53
		calcEdgeR1_m	53, 52
		calcEdgeR1_m	52, 51
		calcEdgeR1_m	51, 50
		calcEdgeR1_m	50, 49
		calcEdgeR1_m	49, 48
		calcEdgeR1_m	48, 47
		calcEdgeR1_m	47, 46
		calcEdgeR1_m	46, 45
		calcEdgeR1_m	45, 44
		calcEdgeR1_m	44, 43
		calcEdgeR1_m	43, 42
		calcEdgeR1_m	42, 41
		calcEdgeR1_m	41, 40
		calcEdgeR1_m	40, 39
		calcEdgeR1_m	39, 38
		calcEdgeR1_m	38, 37
		calcEdgeR1_m	37, 36
		calcEdgeR1_m	36, 35
		calcEdgeR1_m	35, 34
		calcEdgeR1_m	34, 33
		calcEdgeR1_m	33, 32
		calcEdgeR1_m	32, 31
		calcEdgeR1_m	31, 30
		calcEdgeR1_m	30, 29
		calcEdgeR1_m	29, 28
		calcEdgeR1_m	28, 27
		calcEdgeR1_m	27, 26
		calcEdgeR1_m	26, 25
		calcEdgeR1_m	25, 24
		calcEdgeR1_m	24, 23
		calcEdgeR1_m	23, 22
		calcEdgeR1_m	22, 21
		calcEdgeR1_m	21, 20
		calcEdgeR1_m	20, 19
		calcEdgeR1_m	19, 18
		calcEdgeR1_m	18, 17
		calcEdgeR1_m	17, 16
		calcEdgeR1_m	16, 15
		calcEdgeR1_m	15, 14
		calcEdgeR1_m	14, 13
		calcEdgeR1_m	13, 12
		calcEdgeR1_m	12, 11
		calcEdgeR1_m	11, 10
		calcEdgeR1_m	10, 9
		calcEdgeR1_m	9, 8
		calcEdgeR1_m	8, 7
		calcEdgeR1_m	7, 6
		calcEdgeR1_m	6, 5
		calcEdgeR1_m	5, 4
		calcEdgeR1_m	4, 3
		calcEdgeR1_m	3, 2
		calcEdgeR1_m	2, 1
		calcEdgeR1_m	1, 0
		calcEdgeR1_m	0, End

.jpEndEX
		rts

.jpAddrLow
		.db	.jp0 % 256
		.db	.jp1 % 256
		.db	.jp2 % 256
		.db	.jp3 % 256
		.db	.jp4 % 256
		.db	.jp5 % 256
		.db	.jp6 % 256
		.db	.jp7 % 256
		.db	.jp8 % 256
		.db	.jp9 % 256
		.db	.jp10 % 256
		.db	.jp11 % 256
		.db	.jp12 % 256
		.db	.jp13 % 256
		.db	.jp14 % 256
		.db	.jp15 % 256
		.db	.jp16 % 256
		.db	.jp17 % 256
		.db	.jp18 % 256
		.db	.jp19 % 256
		.db	.jp20 % 256
		.db	.jp21 % 256
		.db	.jp22 % 256
		.db	.jp23 % 256
		.db	.jp24 % 256
		.db	.jp25 % 256
		.db	.jp26 % 256
		.db	.jp27 % 256
		.db	.jp28 % 256
		.db	.jp29 % 256
		.db	.jp30 % 256
		.db	.jp31 % 256
		.db	.jp32 % 256
		.db	.jp33 % 256
		.db	.jp34 % 256
		.db	.jp35 % 256
		.db	.jp36 % 256
		.db	.jp37 % 256
		.db	.jp38 % 256
		.db	.jp39 % 256
		.db	.jp40 % 256
		.db	.jp41 % 256
		.db	.jp42 % 256
		.db	.jp43 % 256
		.db	.jp44 % 256
		.db	.jp45 % 256
		.db	.jp46 % 256
		.db	.jp47 % 256
		.db	.jp48 % 256
		.db	.jp49 % 256
		.db	.jp50 % 256
		.db	.jp51 % 256
		.db	.jp52 % 256
		.db	.jp53 % 256
		.db	.jp54 % 256
		.db	.jp55 % 256
		.db	.jp56 % 256
		.db	.jp57 % 256
		.db	.jp58 % 256
		.db	.jp59 % 256
		.db	.jp60 % 256
		.db	.jp61 % 256
		.db	.jp62 % 256
		.db	.jp63 % 256
		.db	.jp64 % 256
		.db	.jp65 % 256
		.db	.jp66 % 256
		.db	.jp67 % 256
		.db	.jp68 % 256
		.db	.jp69 % 256
		.db	.jp70 % 256
		.db	.jp71 % 256
		.db	.jp72 % 256
		.db	.jp73 % 256
		.db	.jp74 % 256
		.db	.jp75 % 256
		.db	.jp76 % 256
		.db	.jp77 % 256
		.db	.jp78 % 256
		.db	.jp79 % 256
		.db	.jp80 % 256
		.db	.jp81 % 256
		.db	.jp82 % 256
		.db	.jp83 % 256
		.db	.jp84 % 256
		.db	.jp85 % 256
		.db	.jp86 % 256
		.db	.jp87 % 256
		.db	.jp88 % 256
		.db	.jp89 % 256
		.db	.jp90 % 256
		.db	.jp91 % 256
		.db	.jp92 % 256
		.db	.jp93 % 256
		.db	.jp94 % 256
		.db	.jp95 % 256
		.db	.jp96 % 256
		.db	.jp97 % 256
		.db	.jp98 % 256
		.db	.jp99 % 256
		.db	.jp100 % 256
		.db	.jp101 % 256
		.db	.jp102 % 256
		.db	.jp103 % 256
		.db	.jp104 % 256
		.db	.jp105 % 256
		.db	.jp106 % 256
		.db	.jp107 % 256
		.db	.jp108 % 256
		.db	.jp109 % 256
		.db	.jp110 % 256
		.db	.jp111 % 256
		.db	.jp112 % 256
		.db	.jp113 % 256
		.db	.jp114 % 256
		.db	.jp115 % 256
		.db	.jp116 % 256
		.db	.jp117 % 256
		.db	.jp118 % 256
		.db	.jp119 % 256
		.db	.jp120 % 256
		.db	.jp121 % 256
		.db	.jp122 % 256
		.db	.jp123 % 256
		.db	.jp124 % 256
		.db	.jp125 % 256
		.db	.jp126 % 256
		.db	.jp127 % 256
		.db	.jp128 % 256
		.db	.jp129 % 256
		.db	.jp130 % 256
		.db	.jp131 % 256
		.db	.jp132 % 256
		.db	.jp133 % 256
		.db	.jp134 % 256
		.db	.jp135 % 256
		.db	.jp136 % 256
		.db	.jp137 % 256
		.db	.jp138 % 256
		.db	.jp139 % 256
		.db	.jp140 % 256
		.db	.jp141 % 256
		.db	.jp142 % 256
		.db	.jp143 % 256
		.db	.jp144 % 256
		.db	.jp145 % 256
		.db	.jp146 % 256
		.db	.jp147 % 256
		.db	.jp148 % 256
		.db	.jp149 % 256
		.db	.jp150 % 256
		.db	.jp151 % 256
		.db	.jp152 % 256
		.db	.jp153 % 256
		.db	.jp154 % 256
		.db	.jp155 % 256
		.db	.jp156 % 256
		.db	.jp157 % 256
		.db	.jp158 % 256
		.db	.jp159 % 256
		.db	.jp160 % 256
		.db	.jp161 % 256
		.db	.jp162 % 256
		.db	.jp163 % 256
		.db	.jp164 % 256
		.db	.jp165 % 256
		.db	.jp166 % 256
		.db	.jp167 % 256
		.db	.jp168 % 256
		.db	.jp169 % 256
		.db	.jp170 % 256
		.db	.jp171 % 256
		.db	.jp172 % 256
		.db	.jp173 % 256
		.db	.jp174 % 256
		.db	.jp175 % 256
		.db	.jp176 % 256
		.db	.jp177 % 256
		.db	.jp178 % 256
		.db	.jp179 % 256
		.db	.jp180 % 256
		.db	.jp181 % 256
		.db	.jp182 % 256
		.db	.jp183 % 256
		.db	.jp184 % 256
		.db	.jp185 % 256
		.db	.jp186 % 256
		.db	.jp187 % 256
		.db	.jp188 % 256
		.db	.jp189 % 256
		.db	.jp190 % 256
		.db	.jp191 % 256
		.db	.jp192 % 256
		.db	.jp193 % 256
		.db	.jp194 % 256
		.db	.jp195 % 256
		.db	.jp196 % 256
		.db	.jp197 % 256
		.db	.jp198 % 256
		.db	.jp199 % 256
		.db	.jp200 % 256
		.db	.jp201 % 256
		.db	.jp202 % 256
		.db	.jp203 % 256
		.db	.jp204 % 256
		.db	.jp205 % 256
		.db	.jp206 % 256
		.db	.jp207 % 256
		.db	.jp208 % 256
		.db	.jp209 % 256
		.db	.jp210 % 256
		.db	.jp211 % 256
		.db	.jp212 % 256
		.db	.jp213 % 256
		.db	.jp214 % 256
		.db	.jp215 % 256
		.db	.jp216 % 256
		.db	.jp217 % 256
		.db	.jp218 % 256
		.db	.jp219 % 256
		.db	.jp220 % 256
		.db	.jp221 % 256
		.db	.jp222 % 256
		.db	.jp223 % 256
		.db	.jp224 % 256
		.db	.jp225 % 256
		.db	.jp226 % 256
		.db	.jp227 % 256
		.db	.jp228 % 256
		.db	.jp229 % 256
		.db	.jp230 % 256
		.db	.jp231 % 256
		.db	.jp232 % 256
		.db	.jp233 % 256
		.db	.jp234 % 256
		.db	.jp235 % 256
		.db	.jp236 % 256
		.db	.jp237 % 256
		.db	.jp238 % 256
		.db	.jp239 % 256
		.db	.jp240 % 256
		.db	.jp241 % 256
		.db	.jp242 % 256
		.db	.jp243 % 256
		.db	.jp244 % 256
		.db	.jp245 % 256
		.db	.jp246 % 256
		.db	.jp247 % 256
		.db	.jp248 % 256
		.db	.jp249 % 256
		.db	.jp250 % 256
		.db	.jp251 % 256
		.db	.jp252 % 256
		.db	.jp253 % 256
		.db	.jp254 % 256
		.db	.jp255 % 256

.jpAddrHigh
		.db	.jp0 / 256
		.db	.jp1 / 256
		.db	.jp2 / 256
		.db	.jp3 / 256
		.db	.jp4 / 256
		.db	.jp5 / 256
		.db	.jp6 / 256
		.db	.jp7 / 256
		.db	.jp8 / 256
		.db	.jp9 / 256
		.db	.jp10 / 256
		.db	.jp11 / 256
		.db	.jp12 / 256
		.db	.jp13 / 256
		.db	.jp14 / 256
		.db	.jp15 / 256
		.db	.jp16 / 256
		.db	.jp17 / 256
		.db	.jp18 / 256
		.db	.jp19 / 256
		.db	.jp20 / 256
		.db	.jp21 / 256
		.db	.jp22 / 256
		.db	.jp23 / 256
		.db	.jp24 / 256
		.db	.jp25 / 256
		.db	.jp26 / 256
		.db	.jp27 / 256
		.db	.jp28 / 256
		.db	.jp29 / 256
		.db	.jp30 / 256
		.db	.jp31 / 256
		.db	.jp32 / 256
		.db	.jp33 / 256
		.db	.jp34 / 256
		.db	.jp35 / 256
		.db	.jp36 / 256
		.db	.jp37 / 256
		.db	.jp38 / 256
		.db	.jp39 / 256
		.db	.jp40 / 256
		.db	.jp41 / 256
		.db	.jp42 / 256
		.db	.jp43 / 256
		.db	.jp44 / 256
		.db	.jp45 / 256
		.db	.jp46 / 256
		.db	.jp47 / 256
		.db	.jp48 / 256
		.db	.jp49 / 256
		.db	.jp50 / 256
		.db	.jp51 / 256
		.db	.jp52 / 256
		.db	.jp53 / 256
		.db	.jp54 / 256
		.db	.jp55 / 256
		.db	.jp56 / 256
		.db	.jp57 / 256
		.db	.jp58 / 256
		.db	.jp59 / 256
		.db	.jp60 / 256
		.db	.jp61 / 256
		.db	.jp62 / 256
		.db	.jp63 / 256
		.db	.jp64 / 256
		.db	.jp65 / 256
		.db	.jp66 / 256
		.db	.jp67 / 256
		.db	.jp68 / 256
		.db	.jp69 / 256
		.db	.jp70 / 256
		.db	.jp71 / 256
		.db	.jp72 / 256
		.db	.jp73 / 256
		.db	.jp74 / 256
		.db	.jp75 / 256
		.db	.jp76 / 256
		.db	.jp77 / 256
		.db	.jp78 / 256
		.db	.jp79 / 256
		.db	.jp80 / 256
		.db	.jp81 / 256
		.db	.jp82 / 256
		.db	.jp83 / 256
		.db	.jp84 / 256
		.db	.jp85 / 256
		.db	.jp86 / 256
		.db	.jp87 / 256
		.db	.jp88 / 256
		.db	.jp89 / 256
		.db	.jp90 / 256
		.db	.jp91 / 256
		.db	.jp92 / 256
		.db	.jp93 / 256
		.db	.jp94 / 256
		.db	.jp95 / 256
		.db	.jp96 / 256
		.db	.jp97 / 256
		.db	.jp98 / 256
		.db	.jp99 / 256
		.db	.jp100 / 256
		.db	.jp101 / 256
		.db	.jp102 / 256
		.db	.jp103 / 256
		.db	.jp104 / 256
		.db	.jp105 / 256
		.db	.jp106 / 256
		.db	.jp107 / 256
		.db	.jp108 / 256
		.db	.jp109 / 256
		.db	.jp110 / 256
		.db	.jp111 / 256
		.db	.jp112 / 256
		.db	.jp113 / 256
		.db	.jp114 / 256
		.db	.jp115 / 256
		.db	.jp116 / 256
		.db	.jp117 / 256
		.db	.jp118 / 256
		.db	.jp119 / 256
		.db	.jp120 / 256
		.db	.jp121 / 256
		.db	.jp122 / 256
		.db	.jp123 / 256
		.db	.jp124 / 256
		.db	.jp125 / 256
		.db	.jp126 / 256
		.db	.jp127 / 256
		.db	.jp128 / 256
		.db	.jp129 / 256
		.db	.jp130 / 256
		.db	.jp131 / 256
		.db	.jp132 / 256
		.db	.jp133 / 256
		.db	.jp134 / 256
		.db	.jp135 / 256
		.db	.jp136 / 256
		.db	.jp137 / 256
		.db	.jp138 / 256
		.db	.jp139 / 256
		.db	.jp140 / 256
		.db	.jp141 / 256
		.db	.jp142 / 256
		.db	.jp143 / 256
		.db	.jp144 / 256
		.db	.jp145 / 256
		.db	.jp146 / 256
		.db	.jp147 / 256
		.db	.jp148 / 256
		.db	.jp149 / 256
		.db	.jp150 / 256
		.db	.jp151 / 256
		.db	.jp152 / 256
		.db	.jp153 / 256
		.db	.jp154 / 256
		.db	.jp155 / 256
		.db	.jp156 / 256
		.db	.jp157 / 256
		.db	.jp158 / 256
		.db	.jp159 / 256
		.db	.jp160 / 256
		.db	.jp161 / 256
		.db	.jp162 / 256
		.db	.jp163 / 256
		.db	.jp164 / 256
		.db	.jp165 / 256
		.db	.jp166 / 256
		.db	.jp167 / 256
		.db	.jp168 / 256
		.db	.jp169 / 256
		.db	.jp170 / 256
		.db	.jp171 / 256
		.db	.jp172 / 256
		.db	.jp173 / 256
		.db	.jp174 / 256
		.db	.jp175 / 256
		.db	.jp176 / 256
		.db	.jp177 / 256
		.db	.jp178 / 256
		.db	.jp179 / 256
		.db	.jp180 / 256
		.db	.jp181 / 256
		.db	.jp182 / 256
		.db	.jp183 / 256
		.db	.jp184 / 256
		.db	.jp185 / 256
		.db	.jp186 / 256
		.db	.jp187 / 256
		.db	.jp188 / 256
		.db	.jp189 / 256
		.db	.jp190 / 256
		.db	.jp191 / 256
		.db	.jp192 / 256
		.db	.jp193 / 256
		.db	.jp194 / 256
		.db	.jp195 / 256
		.db	.jp196 / 256
		.db	.jp197 / 256
		.db	.jp198 / 256
		.db	.jp199 / 256
		.db	.jp200 / 256
		.db	.jp201 / 256
		.db	.jp202 / 256
		.db	.jp203 / 256
		.db	.jp204 / 256
		.db	.jp205 / 256
		.db	.jp206 / 256
		.db	.jp207 / 256
		.db	.jp208 / 256
		.db	.jp209 / 256
		.db	.jp210 / 256
		.db	.jp211 / 256
		.db	.jp212 / 256
		.db	.jp213 / 256
		.db	.jp214 / 256
		.db	.jp215 / 256
		.db	.jp216 / 256
		.db	.jp217 / 256
		.db	.jp218 / 256
		.db	.jp219 / 256
		.db	.jp220 / 256
		.db	.jp221 / 256
		.db	.jp222 / 256
		.db	.jp223 / 256
		.db	.jp224 / 256
		.db	.jp225 / 256
		.db	.jp226 / 256
		.db	.jp227 / 256
		.db	.jp228 / 256
		.db	.jp229 / 256
		.db	.jp230 / 256
		.db	.jp231 / 256
		.db	.jp232 / 256
		.db	.jp233 / 256
		.db	.jp234 / 256
		.db	.jp235 / 256
		.db	.jp236 / 256
		.db	.jp237 / 256
		.db	.jp238 / 256
		.db	.jp239 / 256
		.db	.jp240 / 256
		.db	.jp241 / 256
		.db	.jp242 / 256
		.db	.jp243 / 256
		.db	.jp244 / 256
		.db	.jp245 / 256
		.db	.jp246 / 256
		.db	.jp247 / 256
		.db	.jp248 / 256
		.db	.jp249 / 256
		.db	.jp250 / 256
		.db	.jp251 / 256
		.db	.jp252 / 256
		.db	.jp253 / 256
		.db	.jp254 / 256
		.db	.jp255 / 256
