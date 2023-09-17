;poly_edgeL0_1.asm
;//////////////////////////////////
;----------------------------
calcEdgeL0_m	.macro
.jp\1EX:
		inx
		adc	<edgeSlopeY
		bcc	.jp\2EX
		sbc	<edgeSlopeX
		iny
.jp\1:
		sax
		sta	edgeLeft, y
		sax
		.endm


;----------------------------
calcEdgeL1_m	.macro
.jp\1EX:
		dex
		adc	<edgeSlopeY
		bcc	.jp\2EX
		sbc	<edgeSlopeX
		iny
.jp\1:
		sax
		sta	edgeLeft, y
		sax
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

		calcEdgeL0_m	254, 253
		calcEdgeL0_m	253, 252
		calcEdgeL0_m	252, 251
		calcEdgeL0_m	251, 250
		calcEdgeL0_m	250, 249
		calcEdgeL0_m	249, 248
		calcEdgeL0_m	248, 247
		calcEdgeL0_m	247, 246
		calcEdgeL0_m	246, 245
		calcEdgeL0_m	245, 244
		calcEdgeL0_m	244, 243
		calcEdgeL0_m	243, 242
		calcEdgeL0_m	242, 241
		calcEdgeL0_m	241, 240
		calcEdgeL0_m	240, 239
		calcEdgeL0_m	239, 238
		calcEdgeL0_m	238, 237
		calcEdgeL0_m	237, 236
		calcEdgeL0_m	236, 235
		calcEdgeL0_m	235, 234
		calcEdgeL0_m	234, 233
		calcEdgeL0_m	233, 232
		calcEdgeL0_m	232, 231
		calcEdgeL0_m	231, 230
		calcEdgeL0_m	230, 229
		calcEdgeL0_m	229, 228
		calcEdgeL0_m	228, 227
		calcEdgeL0_m	227, 226
		calcEdgeL0_m	226, 225
		calcEdgeL0_m	225, 224
		calcEdgeL0_m	224, 223
		calcEdgeL0_m	223, 222
		calcEdgeL0_m	222, 221
		calcEdgeL0_m	221, 220
		calcEdgeL0_m	220, 219
		calcEdgeL0_m	219, 218
		calcEdgeL0_m	218, 217
		calcEdgeL0_m	217, 216
		calcEdgeL0_m	216, 215
		calcEdgeL0_m	215, 214
		calcEdgeL0_m	214, 213
		calcEdgeL0_m	213, 212
		calcEdgeL0_m	212, 211
		calcEdgeL0_m	211, 210
		calcEdgeL0_m	210, 209
		calcEdgeL0_m	209, 208
		calcEdgeL0_m	208, 207
		calcEdgeL0_m	207, 206
		calcEdgeL0_m	206, 205
		calcEdgeL0_m	205, 204
		calcEdgeL0_m	204, 203
		calcEdgeL0_m	203, 202
		calcEdgeL0_m	202, 201
		calcEdgeL0_m	201, 200
		calcEdgeL0_m	200, 199
		calcEdgeL0_m	199, 198
		calcEdgeL0_m	198, 197
		calcEdgeL0_m	197, 196
		calcEdgeL0_m	196, 195
		calcEdgeL0_m	195, 194
		calcEdgeL0_m	194, 193
		calcEdgeL0_m	193, 192
		calcEdgeL0_m	192, 191
		calcEdgeL0_m	191, 190
		calcEdgeL0_m	190, 189
		calcEdgeL0_m	189, 188
		calcEdgeL0_m	188, 187
		calcEdgeL0_m	187, 186
		calcEdgeL0_m	186, 185
		calcEdgeL0_m	185, 184
		calcEdgeL0_m	184, 183
		calcEdgeL0_m	183, 182
		calcEdgeL0_m	182, 181
		calcEdgeL0_m	181, 180
		calcEdgeL0_m	180, 179
		calcEdgeL0_m	179, 178
		calcEdgeL0_m	178, 177
		calcEdgeL0_m	177, 176
		calcEdgeL0_m	176, 175
		calcEdgeL0_m	175, 174
		calcEdgeL0_m	174, 173
		calcEdgeL0_m	173, 172
		calcEdgeL0_m	172, 171
		calcEdgeL0_m	171, 170
		calcEdgeL0_m	170, 169
		calcEdgeL0_m	169, 168
		calcEdgeL0_m	168, 167
		calcEdgeL0_m	167, 166
		calcEdgeL0_m	166, 165
		calcEdgeL0_m	165, 164
		calcEdgeL0_m	164, 163
		calcEdgeL0_m	163, 162
		calcEdgeL0_m	162, 161
		calcEdgeL0_m	161, 160
		calcEdgeL0_m	160, 159
		calcEdgeL0_m	159, 158
		calcEdgeL0_m	158, 157
		calcEdgeL0_m	157, 156
		calcEdgeL0_m	156, 155
		calcEdgeL0_m	155, 154
		calcEdgeL0_m	154, 153
		calcEdgeL0_m	153, 152
		calcEdgeL0_m	152, 151
		calcEdgeL0_m	151, 150
		calcEdgeL0_m	150, 149
		calcEdgeL0_m	149, 148
		calcEdgeL0_m	148, 147
		calcEdgeL0_m	147, 146
		calcEdgeL0_m	146, 145
		calcEdgeL0_m	145, 144
		calcEdgeL0_m	144, 143
		calcEdgeL0_m	143, 142
		calcEdgeL0_m	142, 141
		calcEdgeL0_m	141, 140
		calcEdgeL0_m	140, 139
		calcEdgeL0_m	139, 138
		calcEdgeL0_m	138, 137
		calcEdgeL0_m	137, 136
		calcEdgeL0_m	136, 135
		calcEdgeL0_m	135, 134
		calcEdgeL0_m	134, 133
		calcEdgeL0_m	133, 132
		calcEdgeL0_m	132, 131
		calcEdgeL0_m	131, 130
		calcEdgeL0_m	130, 129
		calcEdgeL0_m	129, 128
		calcEdgeL0_m	128, 127
		calcEdgeL0_m	127, 126
		calcEdgeL0_m	126, 125
		calcEdgeL0_m	125, 124
		calcEdgeL0_m	124, 123
		calcEdgeL0_m	123, 122
		calcEdgeL0_m	122, 121
		calcEdgeL0_m	121, 120
		calcEdgeL0_m	120, 119
		calcEdgeL0_m	119, 118
		calcEdgeL0_m	118, 117
		calcEdgeL0_m	117, 116
		calcEdgeL0_m	116, 115
		calcEdgeL0_m	115, 114
		calcEdgeL0_m	114, 113
		calcEdgeL0_m	113, 112
		calcEdgeL0_m	112, 111
		calcEdgeL0_m	111, 110
		calcEdgeL0_m	110, 109
		calcEdgeL0_m	109, 108
		calcEdgeL0_m	108, 107
		calcEdgeL0_m	107, 106
		calcEdgeL0_m	106, 105
		calcEdgeL0_m	105, 104
		calcEdgeL0_m	104, 103
		calcEdgeL0_m	103, 102
		calcEdgeL0_m	102, 101
		calcEdgeL0_m	101, 100
		calcEdgeL0_m	100, 99
		calcEdgeL0_m	99, 98
		calcEdgeL0_m	98, 97
		calcEdgeL0_m	97, 96
		calcEdgeL0_m	96, 95
		calcEdgeL0_m	95, 94
		calcEdgeL0_m	94, 93
		calcEdgeL0_m	93, 92
		calcEdgeL0_m	92, 91
		calcEdgeL0_m	91, 90
		calcEdgeL0_m	90, 89
		calcEdgeL0_m	89, 88
		calcEdgeL0_m	88, 87
		calcEdgeL0_m	87, 86
		calcEdgeL0_m	86, 85
		calcEdgeL0_m	85, 84
		calcEdgeL0_m	84, 83
		calcEdgeL0_m	83, 82
		calcEdgeL0_m	82, 81
		calcEdgeL0_m	81, 80
		calcEdgeL0_m	80, 79
		calcEdgeL0_m	79, 78
		calcEdgeL0_m	78, 77
		calcEdgeL0_m	77, 76
		calcEdgeL0_m	76, 75
		calcEdgeL0_m	75, 74
		calcEdgeL0_m	74, 73
		calcEdgeL0_m	73, 72
		calcEdgeL0_m	72, 71
		calcEdgeL0_m	71, 70
		calcEdgeL0_m	70, 69
		calcEdgeL0_m	69, 68
		calcEdgeL0_m	68, 67
		calcEdgeL0_m	67, 66
		calcEdgeL0_m	66, 65
		calcEdgeL0_m	65, 64
		calcEdgeL0_m	64, 63
		calcEdgeL0_m	63, 62
		calcEdgeL0_m	62, 61
		calcEdgeL0_m	61, 60
		calcEdgeL0_m	60, 59
		calcEdgeL0_m	59, 58
		calcEdgeL0_m	58, 57
		calcEdgeL0_m	57, 56
		calcEdgeL0_m	56, 55
		calcEdgeL0_m	55, 54
		calcEdgeL0_m	54, 53
		calcEdgeL0_m	53, 52
		calcEdgeL0_m	52, 51
		calcEdgeL0_m	51, 50
		calcEdgeL0_m	50, 49
		calcEdgeL0_m	49, 48
		calcEdgeL0_m	48, 47
		calcEdgeL0_m	47, 46
		calcEdgeL0_m	46, 45
		calcEdgeL0_m	45, 44
		calcEdgeL0_m	44, 43
		calcEdgeL0_m	43, 42
		calcEdgeL0_m	42, 41
		calcEdgeL0_m	41, 40
		calcEdgeL0_m	40, 39
		calcEdgeL0_m	39, 38
		calcEdgeL0_m	38, 37
		calcEdgeL0_m	37, 36
		calcEdgeL0_m	36, 35
		calcEdgeL0_m	35, 34
		calcEdgeL0_m	34, 33
		calcEdgeL0_m	33, 32
		calcEdgeL0_m	32, 31
		calcEdgeL0_m	31, 30
		calcEdgeL0_m	30, 29
		calcEdgeL0_m	29, 28
		calcEdgeL0_m	28, 27
		calcEdgeL0_m	27, 26
		calcEdgeL0_m	26, 25
		calcEdgeL0_m	25, 24
		calcEdgeL0_m	24, 23
		calcEdgeL0_m	23, 22
		calcEdgeL0_m	22, 21
		calcEdgeL0_m	21, 20
		calcEdgeL0_m	20, 19
		calcEdgeL0_m	19, 18
		calcEdgeL0_m	18, 17
		calcEdgeL0_m	17, 16
		calcEdgeL0_m	16, 15
		calcEdgeL0_m	15, 14
		calcEdgeL0_m	14, 13
		calcEdgeL0_m	13, 12
		calcEdgeL0_m	12, 11
		calcEdgeL0_m	11, 10
		calcEdgeL0_m	10, 9
		calcEdgeL0_m	9, 8
		calcEdgeL0_m	8, 7
		calcEdgeL0_m	7, 6
		calcEdgeL0_m	6, 5
		calcEdgeL0_m	5, 4
		calcEdgeL0_m	4, 3
		calcEdgeL0_m	3, 2
		calcEdgeL0_m	2, 1
		calcEdgeL0_m	1, 0
		calcEdgeL0_m	0, End

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

		calcEdgeL1_m	254, 253
		calcEdgeL1_m	253, 252
		calcEdgeL1_m	252, 251
		calcEdgeL1_m	251, 250
		calcEdgeL1_m	250, 249
		calcEdgeL1_m	249, 248
		calcEdgeL1_m	248, 247
		calcEdgeL1_m	247, 246
		calcEdgeL1_m	246, 245
		calcEdgeL1_m	245, 244
		calcEdgeL1_m	244, 243
		calcEdgeL1_m	243, 242
		calcEdgeL1_m	242, 241
		calcEdgeL1_m	241, 240
		calcEdgeL1_m	240, 239
		calcEdgeL1_m	239, 238
		calcEdgeL1_m	238, 237
		calcEdgeL1_m	237, 236
		calcEdgeL1_m	236, 235
		calcEdgeL1_m	235, 234
		calcEdgeL1_m	234, 233
		calcEdgeL1_m	233, 232
		calcEdgeL1_m	232, 231
		calcEdgeL1_m	231, 230
		calcEdgeL1_m	230, 229
		calcEdgeL1_m	229, 228
		calcEdgeL1_m	228, 227
		calcEdgeL1_m	227, 226
		calcEdgeL1_m	226, 225
		calcEdgeL1_m	225, 224
		calcEdgeL1_m	224, 223
		calcEdgeL1_m	223, 222
		calcEdgeL1_m	222, 221
		calcEdgeL1_m	221, 220
		calcEdgeL1_m	220, 219
		calcEdgeL1_m	219, 218
		calcEdgeL1_m	218, 217
		calcEdgeL1_m	217, 216
		calcEdgeL1_m	216, 215
		calcEdgeL1_m	215, 214
		calcEdgeL1_m	214, 213
		calcEdgeL1_m	213, 212
		calcEdgeL1_m	212, 211
		calcEdgeL1_m	211, 210
		calcEdgeL1_m	210, 209
		calcEdgeL1_m	209, 208
		calcEdgeL1_m	208, 207
		calcEdgeL1_m	207, 206
		calcEdgeL1_m	206, 205
		calcEdgeL1_m	205, 204
		calcEdgeL1_m	204, 203
		calcEdgeL1_m	203, 202
		calcEdgeL1_m	202, 201
		calcEdgeL1_m	201, 200
		calcEdgeL1_m	200, 199
		calcEdgeL1_m	199, 198
		calcEdgeL1_m	198, 197
		calcEdgeL1_m	197, 196
		calcEdgeL1_m	196, 195
		calcEdgeL1_m	195, 194
		calcEdgeL1_m	194, 193
		calcEdgeL1_m	193, 192
		calcEdgeL1_m	192, 191
		calcEdgeL1_m	191, 190
		calcEdgeL1_m	190, 189
		calcEdgeL1_m	189, 188
		calcEdgeL1_m	188, 187
		calcEdgeL1_m	187, 186
		calcEdgeL1_m	186, 185
		calcEdgeL1_m	185, 184
		calcEdgeL1_m	184, 183
		calcEdgeL1_m	183, 182
		calcEdgeL1_m	182, 181
		calcEdgeL1_m	181, 180
		calcEdgeL1_m	180, 179
		calcEdgeL1_m	179, 178
		calcEdgeL1_m	178, 177
		calcEdgeL1_m	177, 176
		calcEdgeL1_m	176, 175
		calcEdgeL1_m	175, 174
		calcEdgeL1_m	174, 173
		calcEdgeL1_m	173, 172
		calcEdgeL1_m	172, 171
		calcEdgeL1_m	171, 170
		calcEdgeL1_m	170, 169
		calcEdgeL1_m	169, 168
		calcEdgeL1_m	168, 167
		calcEdgeL1_m	167, 166
		calcEdgeL1_m	166, 165
		calcEdgeL1_m	165, 164
		calcEdgeL1_m	164, 163
		calcEdgeL1_m	163, 162
		calcEdgeL1_m	162, 161
		calcEdgeL1_m	161, 160
		calcEdgeL1_m	160, 159
		calcEdgeL1_m	159, 158
		calcEdgeL1_m	158, 157
		calcEdgeL1_m	157, 156
		calcEdgeL1_m	156, 155
		calcEdgeL1_m	155, 154
		calcEdgeL1_m	154, 153
		calcEdgeL1_m	153, 152
		calcEdgeL1_m	152, 151
		calcEdgeL1_m	151, 150
		calcEdgeL1_m	150, 149
		calcEdgeL1_m	149, 148
		calcEdgeL1_m	148, 147
		calcEdgeL1_m	147, 146
		calcEdgeL1_m	146, 145
		calcEdgeL1_m	145, 144
		calcEdgeL1_m	144, 143
		calcEdgeL1_m	143, 142
		calcEdgeL1_m	142, 141
		calcEdgeL1_m	141, 140
		calcEdgeL1_m	140, 139
		calcEdgeL1_m	139, 138
		calcEdgeL1_m	138, 137
		calcEdgeL1_m	137, 136
		calcEdgeL1_m	136, 135
		calcEdgeL1_m	135, 134
		calcEdgeL1_m	134, 133
		calcEdgeL1_m	133, 132
		calcEdgeL1_m	132, 131
		calcEdgeL1_m	131, 130
		calcEdgeL1_m	130, 129
		calcEdgeL1_m	129, 128
		calcEdgeL1_m	128, 127
		calcEdgeL1_m	127, 126
		calcEdgeL1_m	126, 125
		calcEdgeL1_m	125, 124
		calcEdgeL1_m	124, 123
		calcEdgeL1_m	123, 122
		calcEdgeL1_m	122, 121
		calcEdgeL1_m	121, 120
		calcEdgeL1_m	120, 119
		calcEdgeL1_m	119, 118
		calcEdgeL1_m	118, 117
		calcEdgeL1_m	117, 116
		calcEdgeL1_m	116, 115
		calcEdgeL1_m	115, 114
		calcEdgeL1_m	114, 113
		calcEdgeL1_m	113, 112
		calcEdgeL1_m	112, 111
		calcEdgeL1_m	111, 110
		calcEdgeL1_m	110, 109
		calcEdgeL1_m	109, 108
		calcEdgeL1_m	108, 107
		calcEdgeL1_m	107, 106
		calcEdgeL1_m	106, 105
		calcEdgeL1_m	105, 104
		calcEdgeL1_m	104, 103
		calcEdgeL1_m	103, 102
		calcEdgeL1_m	102, 101
		calcEdgeL1_m	101, 100
		calcEdgeL1_m	100, 99
		calcEdgeL1_m	99, 98
		calcEdgeL1_m	98, 97
		calcEdgeL1_m	97, 96
		calcEdgeL1_m	96, 95
		calcEdgeL1_m	95, 94
		calcEdgeL1_m	94, 93
		calcEdgeL1_m	93, 92
		calcEdgeL1_m	92, 91
		calcEdgeL1_m	91, 90
		calcEdgeL1_m	90, 89
		calcEdgeL1_m	89, 88
		calcEdgeL1_m	88, 87
		calcEdgeL1_m	87, 86
		calcEdgeL1_m	86, 85
		calcEdgeL1_m	85, 84
		calcEdgeL1_m	84, 83
		calcEdgeL1_m	83, 82
		calcEdgeL1_m	82, 81
		calcEdgeL1_m	81, 80
		calcEdgeL1_m	80, 79
		calcEdgeL1_m	79, 78
		calcEdgeL1_m	78, 77
		calcEdgeL1_m	77, 76
		calcEdgeL1_m	76, 75
		calcEdgeL1_m	75, 74
		calcEdgeL1_m	74, 73
		calcEdgeL1_m	73, 72
		calcEdgeL1_m	72, 71
		calcEdgeL1_m	71, 70
		calcEdgeL1_m	70, 69
		calcEdgeL1_m	69, 68
		calcEdgeL1_m	68, 67
		calcEdgeL1_m	67, 66
		calcEdgeL1_m	66, 65
		calcEdgeL1_m	65, 64
		calcEdgeL1_m	64, 63
		calcEdgeL1_m	63, 62
		calcEdgeL1_m	62, 61
		calcEdgeL1_m	61, 60
		calcEdgeL1_m	60, 59
		calcEdgeL1_m	59, 58
		calcEdgeL1_m	58, 57
		calcEdgeL1_m	57, 56
		calcEdgeL1_m	56, 55
		calcEdgeL1_m	55, 54
		calcEdgeL1_m	54, 53
		calcEdgeL1_m	53, 52
		calcEdgeL1_m	52, 51
		calcEdgeL1_m	51, 50
		calcEdgeL1_m	50, 49
		calcEdgeL1_m	49, 48
		calcEdgeL1_m	48, 47
		calcEdgeL1_m	47, 46
		calcEdgeL1_m	46, 45
		calcEdgeL1_m	45, 44
		calcEdgeL1_m	44, 43
		calcEdgeL1_m	43, 42
		calcEdgeL1_m	42, 41
		calcEdgeL1_m	41, 40
		calcEdgeL1_m	40, 39
		calcEdgeL1_m	39, 38
		calcEdgeL1_m	38, 37
		calcEdgeL1_m	37, 36
		calcEdgeL1_m	36, 35
		calcEdgeL1_m	35, 34
		calcEdgeL1_m	34, 33
		calcEdgeL1_m	33, 32
		calcEdgeL1_m	32, 31
		calcEdgeL1_m	31, 30
		calcEdgeL1_m	30, 29
		calcEdgeL1_m	29, 28
		calcEdgeL1_m	28, 27
		calcEdgeL1_m	27, 26
		calcEdgeL1_m	26, 25
		calcEdgeL1_m	25, 24
		calcEdgeL1_m	24, 23
		calcEdgeL1_m	23, 22
		calcEdgeL1_m	22, 21
		calcEdgeL1_m	21, 20
		calcEdgeL1_m	20, 19
		calcEdgeL1_m	19, 18
		calcEdgeL1_m	18, 17
		calcEdgeL1_m	17, 16
		calcEdgeL1_m	16, 15
		calcEdgeL1_m	15, 14
		calcEdgeL1_m	14, 13
		calcEdgeL1_m	13, 12
		calcEdgeL1_m	12, 11
		calcEdgeL1_m	11, 10
		calcEdgeL1_m	10, 9
		calcEdgeL1_m	9, 8
		calcEdgeL1_m	8, 7
		calcEdgeL1_m	7, 6
		calcEdgeL1_m	6, 5
		calcEdgeL1_m	5, 4
		calcEdgeL1_m	4, 3
		calcEdgeL1_m	3, 2
		calcEdgeL1_m	2, 1
		calcEdgeL1_m	1, 0
		calcEdgeL1_m	0, End

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
