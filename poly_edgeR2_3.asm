;poly_edgeR2_3.asm
;//////////////////////////////////
;----------------------------
calcEdgeREX_m	.macro
.jp\1:
		sta	edgeRight+\1, y
		.endm


;----------------------------
calcEdgeR2_m	.macro
.jp\1:
		sax
		sta	edgeRight+\1, y
		sax
		adc	<edgeSlopeX
		bcc	.jp\2
		sbc	<edgeSlopeY
		dex
		.endm


;----------------------------
calcEdgeR3_m	.macro
.jp\1:
		sax
		sta	edgeRight+\1, y
		sax
		adc	<edgeSlopeX
		bcc	.jp\2
		sbc	<edgeSlopeY
		inx
		.endm


;//////////////////////////////////
		.org	$6000
;----------------------------
calcEdgeREX:
;
		ldx	<edgeSlopeY
		lda	.jpAddrLow, x
		sta	<edgeJumpAddr
		lda	.jpAddrHigh, x
		sta	<edgeJumpAddr+1

		lda	<edgeX0
		ldy	<edgeY0

		jmp	[edgeJumpAddr]

		calcEdgeREX_m	191
		calcEdgeREX_m	190
		calcEdgeREX_m	189
		calcEdgeREX_m	188
		calcEdgeREX_m	187
		calcEdgeREX_m	186
		calcEdgeREX_m	185
		calcEdgeREX_m	184
		calcEdgeREX_m	183
		calcEdgeREX_m	182
		calcEdgeREX_m	181
		calcEdgeREX_m	180
		calcEdgeREX_m	179
		calcEdgeREX_m	178
		calcEdgeREX_m	177
		calcEdgeREX_m	176
		calcEdgeREX_m	175
		calcEdgeREX_m	174
		calcEdgeREX_m	173
		calcEdgeREX_m	172
		calcEdgeREX_m	171
		calcEdgeREX_m	170
		calcEdgeREX_m	169
		calcEdgeREX_m	168
		calcEdgeREX_m	167
		calcEdgeREX_m	166
		calcEdgeREX_m	165
		calcEdgeREX_m	164
		calcEdgeREX_m	163
		calcEdgeREX_m	162
		calcEdgeREX_m	161
		calcEdgeREX_m	160
		calcEdgeREX_m	159
		calcEdgeREX_m	158
		calcEdgeREX_m	157
		calcEdgeREX_m	156
		calcEdgeREX_m	155
		calcEdgeREX_m	154
		calcEdgeREX_m	153
		calcEdgeREX_m	152
		calcEdgeREX_m	151
		calcEdgeREX_m	150
		calcEdgeREX_m	149
		calcEdgeREX_m	148
		calcEdgeREX_m	147
		calcEdgeREX_m	146
		calcEdgeREX_m	145
		calcEdgeREX_m	144
		calcEdgeREX_m	143
		calcEdgeREX_m	142
		calcEdgeREX_m	141
		calcEdgeREX_m	140
		calcEdgeREX_m	139
		calcEdgeREX_m	138
		calcEdgeREX_m	137
		calcEdgeREX_m	136
		calcEdgeREX_m	135
		calcEdgeREX_m	134
		calcEdgeREX_m	133
		calcEdgeREX_m	132
		calcEdgeREX_m	131
		calcEdgeREX_m	130
		calcEdgeREX_m	129
		calcEdgeREX_m	128
		calcEdgeREX_m	127
		calcEdgeREX_m	126
		calcEdgeREX_m	125
		calcEdgeREX_m	124
		calcEdgeREX_m	123
		calcEdgeREX_m	122
		calcEdgeREX_m	121
		calcEdgeREX_m	120
		calcEdgeREX_m	119
		calcEdgeREX_m	118
		calcEdgeREX_m	117
		calcEdgeREX_m	116
		calcEdgeREX_m	115
		calcEdgeREX_m	114
		calcEdgeREX_m	113
		calcEdgeREX_m	112
		calcEdgeREX_m	111
		calcEdgeREX_m	110
		calcEdgeREX_m	109
		calcEdgeREX_m	108
		calcEdgeREX_m	107
		calcEdgeREX_m	106
		calcEdgeREX_m	105
		calcEdgeREX_m	104
		calcEdgeREX_m	103
		calcEdgeREX_m	102
		calcEdgeREX_m	101
		calcEdgeREX_m	100
		calcEdgeREX_m	99
		calcEdgeREX_m	98
		calcEdgeREX_m	97
		calcEdgeREX_m	96
		calcEdgeREX_m	95
		calcEdgeREX_m	94
		calcEdgeREX_m	93
		calcEdgeREX_m	92
		calcEdgeREX_m	91
		calcEdgeREX_m	90
		calcEdgeREX_m	89
		calcEdgeREX_m	88
		calcEdgeREX_m	87
		calcEdgeREX_m	86
		calcEdgeREX_m	85
		calcEdgeREX_m	84
		calcEdgeREX_m	83
		calcEdgeREX_m	82
		calcEdgeREX_m	81
		calcEdgeREX_m	80
		calcEdgeREX_m	79
		calcEdgeREX_m	78
		calcEdgeREX_m	77
		calcEdgeREX_m	76
		calcEdgeREX_m	75
		calcEdgeREX_m	74
		calcEdgeREX_m	73
		calcEdgeREX_m	72
		calcEdgeREX_m	71
		calcEdgeREX_m	70
		calcEdgeREX_m	69
		calcEdgeREX_m	68
		calcEdgeREX_m	67
		calcEdgeREX_m	66
		calcEdgeREX_m	65
		calcEdgeREX_m	64
		calcEdgeREX_m	63
		calcEdgeREX_m	62
		calcEdgeREX_m	61
		calcEdgeREX_m	60
		calcEdgeREX_m	59
		calcEdgeREX_m	58
		calcEdgeREX_m	57
		calcEdgeREX_m	56
		calcEdgeREX_m	55
		calcEdgeREX_m	54
		calcEdgeREX_m	53
		calcEdgeREX_m	52
		calcEdgeREX_m	51
		calcEdgeREX_m	50
		calcEdgeREX_m	49
		calcEdgeREX_m	48
		calcEdgeREX_m	47
		calcEdgeREX_m	46
		calcEdgeREX_m	45
		calcEdgeREX_m	44
		calcEdgeREX_m	43
		calcEdgeREX_m	42
		calcEdgeREX_m	41
		calcEdgeREX_m	40
		calcEdgeREX_m	39
		calcEdgeREX_m	38
		calcEdgeREX_m	37
		calcEdgeREX_m	36
		calcEdgeREX_m	35
		calcEdgeREX_m	34
		calcEdgeREX_m	33
		calcEdgeREX_m	32
		calcEdgeREX_m	31
		calcEdgeREX_m	30
		calcEdgeREX_m	29
		calcEdgeREX_m	28
		calcEdgeREX_m	27
		calcEdgeREX_m	26
		calcEdgeREX_m	25
		calcEdgeREX_m	24
		calcEdgeREX_m	23
		calcEdgeREX_m	22
		calcEdgeREX_m	21
		calcEdgeREX_m	20
		calcEdgeREX_m	19
		calcEdgeREX_m	18
		calcEdgeREX_m	17
		calcEdgeREX_m	16
		calcEdgeREX_m	15
		calcEdgeREX_m	14
		calcEdgeREX_m	13
		calcEdgeREX_m	12
		calcEdgeREX_m	11
		calcEdgeREX_m	10
		calcEdgeREX_m	9
		calcEdgeREX_m	8
		calcEdgeREX_m	7
		calcEdgeREX_m	6
		calcEdgeREX_m	5
		calcEdgeREX_m	4
		calcEdgeREX_m	3
		calcEdgeREX_m	2
		calcEdgeREX_m	1
		calcEdgeREX_m	0

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


;----------------------------
calcEdgeR2:
;
		ldx	<edgeSlopeY
		lda	.jpAddrLow, x
		sta	<edgeJumpAddr
		lda	.jpAddrHigh, x
		sta	<edgeJumpAddr+1

		lda	<edgeSlopeY
		eor	#$FF
		inc	a

		ldx	<edgeX1
		ldy	<edgeY0

		clc
		jmp	[edgeJumpAddr]

		calcEdgeR2_m	191, 190
		calcEdgeR2_m	190, 189
		calcEdgeR2_m	189, 188
		calcEdgeR2_m	188, 187
		calcEdgeR2_m	187, 186
		calcEdgeR2_m	186, 185
		calcEdgeR2_m	185, 184
		calcEdgeR2_m	184, 183
		calcEdgeR2_m	183, 182
		calcEdgeR2_m	182, 181
		calcEdgeR2_m	181, 180
		calcEdgeR2_m	180, 179
		calcEdgeR2_m	179, 178
		calcEdgeR2_m	178, 177
		calcEdgeR2_m	177, 176
		calcEdgeR2_m	176, 175
		calcEdgeR2_m	175, 174
		calcEdgeR2_m	174, 173
		calcEdgeR2_m	173, 172
		calcEdgeR2_m	172, 171
		calcEdgeR2_m	171, 170
		calcEdgeR2_m	170, 169
		calcEdgeR2_m	169, 168
		calcEdgeR2_m	168, 167
		calcEdgeR2_m	167, 166
		calcEdgeR2_m	166, 165
		calcEdgeR2_m	165, 164
		calcEdgeR2_m	164, 163
		calcEdgeR2_m	163, 162
		calcEdgeR2_m	162, 161
		calcEdgeR2_m	161, 160
		calcEdgeR2_m	160, 159
		calcEdgeR2_m	159, 158
		calcEdgeR2_m	158, 157
		calcEdgeR2_m	157, 156
		calcEdgeR2_m	156, 155
		calcEdgeR2_m	155, 154
		calcEdgeR2_m	154, 153
		calcEdgeR2_m	153, 152
		calcEdgeR2_m	152, 151
		calcEdgeR2_m	151, 150
		calcEdgeR2_m	150, 149
		calcEdgeR2_m	149, 148
		calcEdgeR2_m	148, 147
		calcEdgeR2_m	147, 146
		calcEdgeR2_m	146, 145
		calcEdgeR2_m	145, 144
		calcEdgeR2_m	144, 143
		calcEdgeR2_m	143, 142
		calcEdgeR2_m	142, 141
		calcEdgeR2_m	141, 140
		calcEdgeR2_m	140, 139
		calcEdgeR2_m	139, 138
		calcEdgeR2_m	138, 137
		calcEdgeR2_m	137, 136
		calcEdgeR2_m	136, 135
		calcEdgeR2_m	135, 134
		calcEdgeR2_m	134, 133
		calcEdgeR2_m	133, 132
		calcEdgeR2_m	132, 131
		calcEdgeR2_m	131, 130
		calcEdgeR2_m	130, 129
		calcEdgeR2_m	129, 128
		calcEdgeR2_m	128, 127
		calcEdgeR2_m	127, 126
		calcEdgeR2_m	126, 125
		calcEdgeR2_m	125, 124
		calcEdgeR2_m	124, 123
		calcEdgeR2_m	123, 122
		calcEdgeR2_m	122, 121
		calcEdgeR2_m	121, 120
		calcEdgeR2_m	120, 119
		calcEdgeR2_m	119, 118
		calcEdgeR2_m	118, 117
		calcEdgeR2_m	117, 116
		calcEdgeR2_m	116, 115
		calcEdgeR2_m	115, 114
		calcEdgeR2_m	114, 113
		calcEdgeR2_m	113, 112
		calcEdgeR2_m	112, 111
		calcEdgeR2_m	111, 110
		calcEdgeR2_m	110, 109
		calcEdgeR2_m	109, 108
		calcEdgeR2_m	108, 107
		calcEdgeR2_m	107, 106
		calcEdgeR2_m	106, 105
		calcEdgeR2_m	105, 104
		calcEdgeR2_m	104, 103
		calcEdgeR2_m	103, 102
		calcEdgeR2_m	102, 101
		calcEdgeR2_m	101, 100
		calcEdgeR2_m	100, 99
		calcEdgeR2_m	99, 98
		calcEdgeR2_m	98, 97
		calcEdgeR2_m	97, 96
		calcEdgeR2_m	96, 95
		calcEdgeR2_m	95, 94
		calcEdgeR2_m	94, 93
		calcEdgeR2_m	93, 92
		calcEdgeR2_m	92, 91
		calcEdgeR2_m	91, 90
		calcEdgeR2_m	90, 89
		calcEdgeR2_m	89, 88
		calcEdgeR2_m	88, 87
		calcEdgeR2_m	87, 86
		calcEdgeR2_m	86, 85
		calcEdgeR2_m	85, 84
		calcEdgeR2_m	84, 83
		calcEdgeR2_m	83, 82
		calcEdgeR2_m	82, 81
		calcEdgeR2_m	81, 80
		calcEdgeR2_m	80, 79
		calcEdgeR2_m	79, 78
		calcEdgeR2_m	78, 77
		calcEdgeR2_m	77, 76
		calcEdgeR2_m	76, 75
		calcEdgeR2_m	75, 74
		calcEdgeR2_m	74, 73
		calcEdgeR2_m	73, 72
		calcEdgeR2_m	72, 71
		calcEdgeR2_m	71, 70
		calcEdgeR2_m	70, 69
		calcEdgeR2_m	69, 68
		calcEdgeR2_m	68, 67
		calcEdgeR2_m	67, 66
		calcEdgeR2_m	66, 65
		calcEdgeR2_m	65, 64
		calcEdgeR2_m	64, 63
		calcEdgeR2_m	63, 62
		calcEdgeR2_m	62, 61
		calcEdgeR2_m	61, 60
		calcEdgeR2_m	60, 59
		calcEdgeR2_m	59, 58
		calcEdgeR2_m	58, 57
		calcEdgeR2_m	57, 56
		calcEdgeR2_m	56, 55
		calcEdgeR2_m	55, 54
		calcEdgeR2_m	54, 53
		calcEdgeR2_m	53, 52
		calcEdgeR2_m	52, 51
		calcEdgeR2_m	51, 50
		calcEdgeR2_m	50, 49
		calcEdgeR2_m	49, 48
		calcEdgeR2_m	48, 47
		calcEdgeR2_m	47, 46
		calcEdgeR2_m	46, 45
		calcEdgeR2_m	45, 44
		calcEdgeR2_m	44, 43
		calcEdgeR2_m	43, 42
		calcEdgeR2_m	42, 41
		calcEdgeR2_m	41, 40
		calcEdgeR2_m	40, 39
		calcEdgeR2_m	39, 38
		calcEdgeR2_m	38, 37
		calcEdgeR2_m	37, 36
		calcEdgeR2_m	36, 35
		calcEdgeR2_m	35, 34
		calcEdgeR2_m	34, 33
		calcEdgeR2_m	33, 32
		calcEdgeR2_m	32, 31
		calcEdgeR2_m	31, 30
		calcEdgeR2_m	30, 29
		calcEdgeR2_m	29, 28
		calcEdgeR2_m	28, 27
		calcEdgeR2_m	27, 26
		calcEdgeR2_m	26, 25
		calcEdgeR2_m	25, 24
		calcEdgeR2_m	24, 23
		calcEdgeR2_m	23, 22
		calcEdgeR2_m	22, 21
		calcEdgeR2_m	21, 20
		calcEdgeR2_m	20, 19
		calcEdgeR2_m	19, 18
		calcEdgeR2_m	18, 17
		calcEdgeR2_m	17, 16
		calcEdgeR2_m	16, 15
		calcEdgeR2_m	15, 14
		calcEdgeR2_m	14, 13
		calcEdgeR2_m	13, 12
		calcEdgeR2_m	12, 11
		calcEdgeR2_m	11, 10
		calcEdgeR2_m	10, 9
		calcEdgeR2_m	9, 8
		calcEdgeR2_m	8, 7
		calcEdgeR2_m	7, 6
		calcEdgeR2_m	6, 5
		calcEdgeR2_m	5, 4
		calcEdgeR2_m	4, 3
		calcEdgeR2_m	3, 2
		calcEdgeR2_m	2, 1
		calcEdgeR2_m	1, 0

.jp0:
		txa
		sta	edgeRight+0, y
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


;----------------------------
calcEdgeR3:
;
		ldx	<edgeSlopeY
		lda	.jpAddrLow, x
		sta	<edgeJumpAddr
		lda	.jpAddrHigh, x
		sta	<edgeJumpAddr+1

		lda	<edgeSlopeY
		eor	#$FF
		inc	a

		ldx	<edgeX1
		ldy	<edgeY0

		clc
		jmp	[edgeJumpAddr]

		calcEdgeR3_m	191, 190
		calcEdgeR3_m	190, 189
		calcEdgeR3_m	189, 188
		calcEdgeR3_m	188, 187
		calcEdgeR3_m	187, 186
		calcEdgeR3_m	186, 185
		calcEdgeR3_m	185, 184
		calcEdgeR3_m	184, 183
		calcEdgeR3_m	183, 182
		calcEdgeR3_m	182, 181
		calcEdgeR3_m	181, 180
		calcEdgeR3_m	180, 179
		calcEdgeR3_m	179, 178
		calcEdgeR3_m	178, 177
		calcEdgeR3_m	177, 176
		calcEdgeR3_m	176, 175
		calcEdgeR3_m	175, 174
		calcEdgeR3_m	174, 173
		calcEdgeR3_m	173, 172
		calcEdgeR3_m	172, 171
		calcEdgeR3_m	171, 170
		calcEdgeR3_m	170, 169
		calcEdgeR3_m	169, 168
		calcEdgeR3_m	168, 167
		calcEdgeR3_m	167, 166
		calcEdgeR3_m	166, 165
		calcEdgeR3_m	165, 164
		calcEdgeR3_m	164, 163
		calcEdgeR3_m	163, 162
		calcEdgeR3_m	162, 161
		calcEdgeR3_m	161, 160
		calcEdgeR3_m	160, 159
		calcEdgeR3_m	159, 158
		calcEdgeR3_m	158, 157
		calcEdgeR3_m	157, 156
		calcEdgeR3_m	156, 155
		calcEdgeR3_m	155, 154
		calcEdgeR3_m	154, 153
		calcEdgeR3_m	153, 152
		calcEdgeR3_m	152, 151
		calcEdgeR3_m	151, 150
		calcEdgeR3_m	150, 149
		calcEdgeR3_m	149, 148
		calcEdgeR3_m	148, 147
		calcEdgeR3_m	147, 146
		calcEdgeR3_m	146, 145
		calcEdgeR3_m	145, 144
		calcEdgeR3_m	144, 143
		calcEdgeR3_m	143, 142
		calcEdgeR3_m	142, 141
		calcEdgeR3_m	141, 140
		calcEdgeR3_m	140, 139
		calcEdgeR3_m	139, 138
		calcEdgeR3_m	138, 137
		calcEdgeR3_m	137, 136
		calcEdgeR3_m	136, 135
		calcEdgeR3_m	135, 134
		calcEdgeR3_m	134, 133
		calcEdgeR3_m	133, 132
		calcEdgeR3_m	132, 131
		calcEdgeR3_m	131, 130
		calcEdgeR3_m	130, 129
		calcEdgeR3_m	129, 128
		calcEdgeR3_m	128, 127
		calcEdgeR3_m	127, 126
		calcEdgeR3_m	126, 125
		calcEdgeR3_m	125, 124
		calcEdgeR3_m	124, 123
		calcEdgeR3_m	123, 122
		calcEdgeR3_m	122, 121
		calcEdgeR3_m	121, 120
		calcEdgeR3_m	120, 119
		calcEdgeR3_m	119, 118
		calcEdgeR3_m	118, 117
		calcEdgeR3_m	117, 116
		calcEdgeR3_m	116, 115
		calcEdgeR3_m	115, 114
		calcEdgeR3_m	114, 113
		calcEdgeR3_m	113, 112
		calcEdgeR3_m	112, 111
		calcEdgeR3_m	111, 110
		calcEdgeR3_m	110, 109
		calcEdgeR3_m	109, 108
		calcEdgeR3_m	108, 107
		calcEdgeR3_m	107, 106
		calcEdgeR3_m	106, 105
		calcEdgeR3_m	105, 104
		calcEdgeR3_m	104, 103
		calcEdgeR3_m	103, 102
		calcEdgeR3_m	102, 101
		calcEdgeR3_m	101, 100
		calcEdgeR3_m	100, 99
		calcEdgeR3_m	99, 98
		calcEdgeR3_m	98, 97
		calcEdgeR3_m	97, 96
		calcEdgeR3_m	96, 95
		calcEdgeR3_m	95, 94
		calcEdgeR3_m	94, 93
		calcEdgeR3_m	93, 92
		calcEdgeR3_m	92, 91
		calcEdgeR3_m	91, 90
		calcEdgeR3_m	90, 89
		calcEdgeR3_m	89, 88
		calcEdgeR3_m	88, 87
		calcEdgeR3_m	87, 86
		calcEdgeR3_m	86, 85
		calcEdgeR3_m	85, 84
		calcEdgeR3_m	84, 83
		calcEdgeR3_m	83, 82
		calcEdgeR3_m	82, 81
		calcEdgeR3_m	81, 80
		calcEdgeR3_m	80, 79
		calcEdgeR3_m	79, 78
		calcEdgeR3_m	78, 77
		calcEdgeR3_m	77, 76
		calcEdgeR3_m	76, 75
		calcEdgeR3_m	75, 74
		calcEdgeR3_m	74, 73
		calcEdgeR3_m	73, 72
		calcEdgeR3_m	72, 71
		calcEdgeR3_m	71, 70
		calcEdgeR3_m	70, 69
		calcEdgeR3_m	69, 68
		calcEdgeR3_m	68, 67
		calcEdgeR3_m	67, 66
		calcEdgeR3_m	66, 65
		calcEdgeR3_m	65, 64
		calcEdgeR3_m	64, 63
		calcEdgeR3_m	63, 62
		calcEdgeR3_m	62, 61
		calcEdgeR3_m	61, 60
		calcEdgeR3_m	60, 59
		calcEdgeR3_m	59, 58
		calcEdgeR3_m	58, 57
		calcEdgeR3_m	57, 56
		calcEdgeR3_m	56, 55
		calcEdgeR3_m	55, 54
		calcEdgeR3_m	54, 53
		calcEdgeR3_m	53, 52
		calcEdgeR3_m	52, 51
		calcEdgeR3_m	51, 50
		calcEdgeR3_m	50, 49
		calcEdgeR3_m	49, 48
		calcEdgeR3_m	48, 47
		calcEdgeR3_m	47, 46
		calcEdgeR3_m	46, 45
		calcEdgeR3_m	45, 44
		calcEdgeR3_m	44, 43
		calcEdgeR3_m	43, 42
		calcEdgeR3_m	42, 41
		calcEdgeR3_m	41, 40
		calcEdgeR3_m	40, 39
		calcEdgeR3_m	39, 38
		calcEdgeR3_m	38, 37
		calcEdgeR3_m	37, 36
		calcEdgeR3_m	36, 35
		calcEdgeR3_m	35, 34
		calcEdgeR3_m	34, 33
		calcEdgeR3_m	33, 32
		calcEdgeR3_m	32, 31
		calcEdgeR3_m	31, 30
		calcEdgeR3_m	30, 29
		calcEdgeR3_m	29, 28
		calcEdgeR3_m	28, 27
		calcEdgeR3_m	27, 26
		calcEdgeR3_m	26, 25
		calcEdgeR3_m	25, 24
		calcEdgeR3_m	24, 23
		calcEdgeR3_m	23, 22
		calcEdgeR3_m	22, 21
		calcEdgeR3_m	21, 20
		calcEdgeR3_m	20, 19
		calcEdgeR3_m	19, 18
		calcEdgeR3_m	18, 17
		calcEdgeR3_m	17, 16
		calcEdgeR3_m	16, 15
		calcEdgeR3_m	15, 14
		calcEdgeR3_m	14, 13
		calcEdgeR3_m	13, 12
		calcEdgeR3_m	12, 11
		calcEdgeR3_m	11, 10
		calcEdgeR3_m	10, 9
		calcEdgeR3_m	9, 8
		calcEdgeR3_m	8, 7
		calcEdgeR3_m	7, 6
		calcEdgeR3_m	6, 5
		calcEdgeR3_m	5, 4
		calcEdgeR3_m	4, 3
		calcEdgeR3_m	3, 2
		calcEdgeR3_m	2, 1
		calcEdgeR3_m	1, 0

.jp0:
		txa
		sta	edgeRight+0, y
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
