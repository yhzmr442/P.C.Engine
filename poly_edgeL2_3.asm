;poly_edgeL2_3.asm
;//////////////////////////////////
;----------------------------
calcEdgeLEX_m	.macro
.jp\1:
		sta	edgeLeft+\1, y
		.endm


;----------------------------
calcEdgeL2_m	.macro
.jp\1:
		sax
		sta	edgeLeft+\1, y
		sax
		adc	<edgeSlopeX
		bcc	.jp\@
		sbc	<edgeSlopeY
		dex
.jp\@:
		.endm


;----------------------------
calcEdgeL3_m	.macro
.jp\1:
		sax
		sta	edgeLeft+\1, y
		sax
		adc	<edgeSlopeX
		bcc	.jp\@
		sbc	<edgeSlopeY
		inx
.jp\@:
		.endm


;//////////////////////////////////
		.org	$6000

;----------------------------
calcEdgeLEX:
;
		ldx	<edgeSlopeY
		lda	.jpAddrLow, x
		sta	<edgeJumpAddr
		lda	.jpAddrHigh, x
		sta	<edgeJumpAddr+1

		lda	<edgeX0
		ldy	<edgeY0

		jmp	[edgeJumpAddr]

		calcEdgeLEX_m	191
		calcEdgeLEX_m	190
		calcEdgeLEX_m	189
		calcEdgeLEX_m	188
		calcEdgeLEX_m	187
		calcEdgeLEX_m	186
		calcEdgeLEX_m	185
		calcEdgeLEX_m	184
		calcEdgeLEX_m	183
		calcEdgeLEX_m	182
		calcEdgeLEX_m	181
		calcEdgeLEX_m	180
		calcEdgeLEX_m	179
		calcEdgeLEX_m	178
		calcEdgeLEX_m	177
		calcEdgeLEX_m	176
		calcEdgeLEX_m	175
		calcEdgeLEX_m	174
		calcEdgeLEX_m	173
		calcEdgeLEX_m	172
		calcEdgeLEX_m	171
		calcEdgeLEX_m	170
		calcEdgeLEX_m	169
		calcEdgeLEX_m	168
		calcEdgeLEX_m	167
		calcEdgeLEX_m	166
		calcEdgeLEX_m	165
		calcEdgeLEX_m	164
		calcEdgeLEX_m	163
		calcEdgeLEX_m	162
		calcEdgeLEX_m	161
		calcEdgeLEX_m	160
		calcEdgeLEX_m	159
		calcEdgeLEX_m	158
		calcEdgeLEX_m	157
		calcEdgeLEX_m	156
		calcEdgeLEX_m	155
		calcEdgeLEX_m	154
		calcEdgeLEX_m	153
		calcEdgeLEX_m	152
		calcEdgeLEX_m	151
		calcEdgeLEX_m	150
		calcEdgeLEX_m	149
		calcEdgeLEX_m	148
		calcEdgeLEX_m	147
		calcEdgeLEX_m	146
		calcEdgeLEX_m	145
		calcEdgeLEX_m	144
		calcEdgeLEX_m	143
		calcEdgeLEX_m	142
		calcEdgeLEX_m	141
		calcEdgeLEX_m	140
		calcEdgeLEX_m	139
		calcEdgeLEX_m	138
		calcEdgeLEX_m	137
		calcEdgeLEX_m	136
		calcEdgeLEX_m	135
		calcEdgeLEX_m	134
		calcEdgeLEX_m	133
		calcEdgeLEX_m	132
		calcEdgeLEX_m	131
		calcEdgeLEX_m	130
		calcEdgeLEX_m	129
		calcEdgeLEX_m	128
		calcEdgeLEX_m	127
		calcEdgeLEX_m	126
		calcEdgeLEX_m	125
		calcEdgeLEX_m	124
		calcEdgeLEX_m	123
		calcEdgeLEX_m	122
		calcEdgeLEX_m	121
		calcEdgeLEX_m	120
		calcEdgeLEX_m	119
		calcEdgeLEX_m	118
		calcEdgeLEX_m	117
		calcEdgeLEX_m	116
		calcEdgeLEX_m	115
		calcEdgeLEX_m	114
		calcEdgeLEX_m	113
		calcEdgeLEX_m	112
		calcEdgeLEX_m	111
		calcEdgeLEX_m	110
		calcEdgeLEX_m	109
		calcEdgeLEX_m	108
		calcEdgeLEX_m	107
		calcEdgeLEX_m	106
		calcEdgeLEX_m	105
		calcEdgeLEX_m	104
		calcEdgeLEX_m	103
		calcEdgeLEX_m	102
		calcEdgeLEX_m	101
		calcEdgeLEX_m	100
		calcEdgeLEX_m	99
		calcEdgeLEX_m	98
		calcEdgeLEX_m	97
		calcEdgeLEX_m	96
		calcEdgeLEX_m	95
		calcEdgeLEX_m	94
		calcEdgeLEX_m	93
		calcEdgeLEX_m	92
		calcEdgeLEX_m	91
		calcEdgeLEX_m	90
		calcEdgeLEX_m	89
		calcEdgeLEX_m	88
		calcEdgeLEX_m	87
		calcEdgeLEX_m	86
		calcEdgeLEX_m	85
		calcEdgeLEX_m	84
		calcEdgeLEX_m	83
		calcEdgeLEX_m	82
		calcEdgeLEX_m	81
		calcEdgeLEX_m	80
		calcEdgeLEX_m	79
		calcEdgeLEX_m	78
		calcEdgeLEX_m	77
		calcEdgeLEX_m	76
		calcEdgeLEX_m	75
		calcEdgeLEX_m	74
		calcEdgeLEX_m	73
		calcEdgeLEX_m	72
		calcEdgeLEX_m	71
		calcEdgeLEX_m	70
		calcEdgeLEX_m	69
		calcEdgeLEX_m	68
		calcEdgeLEX_m	67
		calcEdgeLEX_m	66
		calcEdgeLEX_m	65
		calcEdgeLEX_m	64
		calcEdgeLEX_m	63
		calcEdgeLEX_m	62
		calcEdgeLEX_m	61
		calcEdgeLEX_m	60
		calcEdgeLEX_m	59
		calcEdgeLEX_m	58
		calcEdgeLEX_m	57
		calcEdgeLEX_m	56
		calcEdgeLEX_m	55
		calcEdgeLEX_m	54
		calcEdgeLEX_m	53
		calcEdgeLEX_m	52
		calcEdgeLEX_m	51
		calcEdgeLEX_m	50
		calcEdgeLEX_m	49
		calcEdgeLEX_m	48
		calcEdgeLEX_m	47
		calcEdgeLEX_m	46
		calcEdgeLEX_m	45
		calcEdgeLEX_m	44
		calcEdgeLEX_m	43
		calcEdgeLEX_m	42
		calcEdgeLEX_m	41
		calcEdgeLEX_m	40
		calcEdgeLEX_m	39
		calcEdgeLEX_m	38
		calcEdgeLEX_m	37
		calcEdgeLEX_m	36
		calcEdgeLEX_m	35
		calcEdgeLEX_m	34
		calcEdgeLEX_m	33
		calcEdgeLEX_m	32
		calcEdgeLEX_m	31
		calcEdgeLEX_m	30
		calcEdgeLEX_m	29
		calcEdgeLEX_m	28
		calcEdgeLEX_m	27
		calcEdgeLEX_m	26
		calcEdgeLEX_m	25
		calcEdgeLEX_m	24
		calcEdgeLEX_m	23
		calcEdgeLEX_m	22
		calcEdgeLEX_m	21
		calcEdgeLEX_m	20
		calcEdgeLEX_m	19
		calcEdgeLEX_m	18
		calcEdgeLEX_m	17
		calcEdgeLEX_m	16
		calcEdgeLEX_m	15
		calcEdgeLEX_m	14
		calcEdgeLEX_m	13
		calcEdgeLEX_m	12
		calcEdgeLEX_m	11
		calcEdgeLEX_m	10
		calcEdgeLEX_m	9
		calcEdgeLEX_m	8
		calcEdgeLEX_m	7
		calcEdgeLEX_m	6
		calcEdgeLEX_m	5
		calcEdgeLEX_m	4
		calcEdgeLEX_m	3
		calcEdgeLEX_m	2
		calcEdgeLEX_m	1
		calcEdgeLEX_m	0

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
calcEdgeL2:
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

		calcEdgeL2_m	191
		calcEdgeL2_m	190
		calcEdgeL2_m	189
		calcEdgeL2_m	188
		calcEdgeL2_m	187
		calcEdgeL2_m	186
		calcEdgeL2_m	185
		calcEdgeL2_m	184
		calcEdgeL2_m	183
		calcEdgeL2_m	182
		calcEdgeL2_m	181
		calcEdgeL2_m	180
		calcEdgeL2_m	179
		calcEdgeL2_m	178
		calcEdgeL2_m	177
		calcEdgeL2_m	176
		calcEdgeL2_m	175
		calcEdgeL2_m	174
		calcEdgeL2_m	173
		calcEdgeL2_m	172
		calcEdgeL2_m	171
		calcEdgeL2_m	170
		calcEdgeL2_m	169
		calcEdgeL2_m	168
		calcEdgeL2_m	167
		calcEdgeL2_m	166
		calcEdgeL2_m	165
		calcEdgeL2_m	164
		calcEdgeL2_m	163
		calcEdgeL2_m	162
		calcEdgeL2_m	161
		calcEdgeL2_m	160
		calcEdgeL2_m	159
		calcEdgeL2_m	158
		calcEdgeL2_m	157
		calcEdgeL2_m	156
		calcEdgeL2_m	155
		calcEdgeL2_m	154
		calcEdgeL2_m	153
		calcEdgeL2_m	152
		calcEdgeL2_m	151
		calcEdgeL2_m	150
		calcEdgeL2_m	149
		calcEdgeL2_m	148
		calcEdgeL2_m	147
		calcEdgeL2_m	146
		calcEdgeL2_m	145
		calcEdgeL2_m	144
		calcEdgeL2_m	143
		calcEdgeL2_m	142
		calcEdgeL2_m	141
		calcEdgeL2_m	140
		calcEdgeL2_m	139
		calcEdgeL2_m	138
		calcEdgeL2_m	137
		calcEdgeL2_m	136
		calcEdgeL2_m	135
		calcEdgeL2_m	134
		calcEdgeL2_m	133
		calcEdgeL2_m	132
		calcEdgeL2_m	131
		calcEdgeL2_m	130
		calcEdgeL2_m	129
		calcEdgeL2_m	128
		calcEdgeL2_m	127
		calcEdgeL2_m	126
		calcEdgeL2_m	125
		calcEdgeL2_m	124
		calcEdgeL2_m	123
		calcEdgeL2_m	122
		calcEdgeL2_m	121
		calcEdgeL2_m	120
		calcEdgeL2_m	119
		calcEdgeL2_m	118
		calcEdgeL2_m	117
		calcEdgeL2_m	116
		calcEdgeL2_m	115
		calcEdgeL2_m	114
		calcEdgeL2_m	113
		calcEdgeL2_m	112
		calcEdgeL2_m	111
		calcEdgeL2_m	110
		calcEdgeL2_m	109
		calcEdgeL2_m	108
		calcEdgeL2_m	107
		calcEdgeL2_m	106
		calcEdgeL2_m	105
		calcEdgeL2_m	104
		calcEdgeL2_m	103
		calcEdgeL2_m	102
		calcEdgeL2_m	101
		calcEdgeL2_m	100
		calcEdgeL2_m	99
		calcEdgeL2_m	98
		calcEdgeL2_m	97
		calcEdgeL2_m	96
		calcEdgeL2_m	95
		calcEdgeL2_m	94
		calcEdgeL2_m	93
		calcEdgeL2_m	92
		calcEdgeL2_m	91
		calcEdgeL2_m	90
		calcEdgeL2_m	89
		calcEdgeL2_m	88
		calcEdgeL2_m	87
		calcEdgeL2_m	86
		calcEdgeL2_m	85
		calcEdgeL2_m	84
		calcEdgeL2_m	83
		calcEdgeL2_m	82
		calcEdgeL2_m	81
		calcEdgeL2_m	80
		calcEdgeL2_m	79
		calcEdgeL2_m	78
		calcEdgeL2_m	77
		calcEdgeL2_m	76
		calcEdgeL2_m	75
		calcEdgeL2_m	74
		calcEdgeL2_m	73
		calcEdgeL2_m	72
		calcEdgeL2_m	71
		calcEdgeL2_m	70
		calcEdgeL2_m	69
		calcEdgeL2_m	68
		calcEdgeL2_m	67
		calcEdgeL2_m	66
		calcEdgeL2_m	65
		calcEdgeL2_m	64
		calcEdgeL2_m	63
		calcEdgeL2_m	62
		calcEdgeL2_m	61
		calcEdgeL2_m	60
		calcEdgeL2_m	59
		calcEdgeL2_m	58
		calcEdgeL2_m	57
		calcEdgeL2_m	56
		calcEdgeL2_m	55
		calcEdgeL2_m	54
		calcEdgeL2_m	53
		calcEdgeL2_m	52
		calcEdgeL2_m	51
		calcEdgeL2_m	50
		calcEdgeL2_m	49
		calcEdgeL2_m	48
		calcEdgeL2_m	47
		calcEdgeL2_m	46
		calcEdgeL2_m	45
		calcEdgeL2_m	44
		calcEdgeL2_m	43
		calcEdgeL2_m	42
		calcEdgeL2_m	41
		calcEdgeL2_m	40
		calcEdgeL2_m	39
		calcEdgeL2_m	38
		calcEdgeL2_m	37
		calcEdgeL2_m	36
		calcEdgeL2_m	35
		calcEdgeL2_m	34
		calcEdgeL2_m	33
		calcEdgeL2_m	32
		calcEdgeL2_m	31
		calcEdgeL2_m	30
		calcEdgeL2_m	29
		calcEdgeL2_m	28
		calcEdgeL2_m	27
		calcEdgeL2_m	26
		calcEdgeL2_m	25
		calcEdgeL2_m	24
		calcEdgeL2_m	23
		calcEdgeL2_m	22
		calcEdgeL2_m	21
		calcEdgeL2_m	20
		calcEdgeL2_m	19
		calcEdgeL2_m	18
		calcEdgeL2_m	17
		calcEdgeL2_m	16
		calcEdgeL2_m	15
		calcEdgeL2_m	14
		calcEdgeL2_m	13
		calcEdgeL2_m	12
		calcEdgeL2_m	11
		calcEdgeL2_m	10
		calcEdgeL2_m	9
		calcEdgeL2_m	8
		calcEdgeL2_m	7
		calcEdgeL2_m	6
		calcEdgeL2_m	5
		calcEdgeL2_m	4
		calcEdgeL2_m	3
		calcEdgeL2_m	2
		calcEdgeL2_m	1

.jp0:
		txa
		sta	edgeLeft+0, y
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
calcEdgeL3:
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

		calcEdgeL3_m	191
		calcEdgeL3_m	190
		calcEdgeL3_m	189
		calcEdgeL3_m	188
		calcEdgeL3_m	187
		calcEdgeL3_m	186
		calcEdgeL3_m	185
		calcEdgeL3_m	184
		calcEdgeL3_m	183
		calcEdgeL3_m	182
		calcEdgeL3_m	181
		calcEdgeL3_m	180
		calcEdgeL3_m	179
		calcEdgeL3_m	178
		calcEdgeL3_m	177
		calcEdgeL3_m	176
		calcEdgeL3_m	175
		calcEdgeL3_m	174
		calcEdgeL3_m	173
		calcEdgeL3_m	172
		calcEdgeL3_m	171
		calcEdgeL3_m	170
		calcEdgeL3_m	169
		calcEdgeL3_m	168
		calcEdgeL3_m	167
		calcEdgeL3_m	166
		calcEdgeL3_m	165
		calcEdgeL3_m	164
		calcEdgeL3_m	163
		calcEdgeL3_m	162
		calcEdgeL3_m	161
		calcEdgeL3_m	160
		calcEdgeL3_m	159
		calcEdgeL3_m	158
		calcEdgeL3_m	157
		calcEdgeL3_m	156
		calcEdgeL3_m	155
		calcEdgeL3_m	154
		calcEdgeL3_m	153
		calcEdgeL3_m	152
		calcEdgeL3_m	151
		calcEdgeL3_m	150
		calcEdgeL3_m	149
		calcEdgeL3_m	148
		calcEdgeL3_m	147
		calcEdgeL3_m	146
		calcEdgeL3_m	145
		calcEdgeL3_m	144
		calcEdgeL3_m	143
		calcEdgeL3_m	142
		calcEdgeL3_m	141
		calcEdgeL3_m	140
		calcEdgeL3_m	139
		calcEdgeL3_m	138
		calcEdgeL3_m	137
		calcEdgeL3_m	136
		calcEdgeL3_m	135
		calcEdgeL3_m	134
		calcEdgeL3_m	133
		calcEdgeL3_m	132
		calcEdgeL3_m	131
		calcEdgeL3_m	130
		calcEdgeL3_m	129
		calcEdgeL3_m	128
		calcEdgeL3_m	127
		calcEdgeL3_m	126
		calcEdgeL3_m	125
		calcEdgeL3_m	124
		calcEdgeL3_m	123
		calcEdgeL3_m	122
		calcEdgeL3_m	121
		calcEdgeL3_m	120
		calcEdgeL3_m	119
		calcEdgeL3_m	118
		calcEdgeL3_m	117
		calcEdgeL3_m	116
		calcEdgeL3_m	115
		calcEdgeL3_m	114
		calcEdgeL3_m	113
		calcEdgeL3_m	112
		calcEdgeL3_m	111
		calcEdgeL3_m	110
		calcEdgeL3_m	109
		calcEdgeL3_m	108
		calcEdgeL3_m	107
		calcEdgeL3_m	106
		calcEdgeL3_m	105
		calcEdgeL3_m	104
		calcEdgeL3_m	103
		calcEdgeL3_m	102
		calcEdgeL3_m	101
		calcEdgeL3_m	100
		calcEdgeL3_m	99
		calcEdgeL3_m	98
		calcEdgeL3_m	97
		calcEdgeL3_m	96
		calcEdgeL3_m	95
		calcEdgeL3_m	94
		calcEdgeL3_m	93
		calcEdgeL3_m	92
		calcEdgeL3_m	91
		calcEdgeL3_m	90
		calcEdgeL3_m	89
		calcEdgeL3_m	88
		calcEdgeL3_m	87
		calcEdgeL3_m	86
		calcEdgeL3_m	85
		calcEdgeL3_m	84
		calcEdgeL3_m	83
		calcEdgeL3_m	82
		calcEdgeL3_m	81
		calcEdgeL3_m	80
		calcEdgeL3_m	79
		calcEdgeL3_m	78
		calcEdgeL3_m	77
		calcEdgeL3_m	76
		calcEdgeL3_m	75
		calcEdgeL3_m	74
		calcEdgeL3_m	73
		calcEdgeL3_m	72
		calcEdgeL3_m	71
		calcEdgeL3_m	70
		calcEdgeL3_m	69
		calcEdgeL3_m	68
		calcEdgeL3_m	67
		calcEdgeL3_m	66
		calcEdgeL3_m	65
		calcEdgeL3_m	64
		calcEdgeL3_m	63
		calcEdgeL3_m	62
		calcEdgeL3_m	61
		calcEdgeL3_m	60
		calcEdgeL3_m	59
		calcEdgeL3_m	58
		calcEdgeL3_m	57
		calcEdgeL3_m	56
		calcEdgeL3_m	55
		calcEdgeL3_m	54
		calcEdgeL3_m	53
		calcEdgeL3_m	52
		calcEdgeL3_m	51
		calcEdgeL3_m	50
		calcEdgeL3_m	49
		calcEdgeL3_m	48
		calcEdgeL3_m	47
		calcEdgeL3_m	46
		calcEdgeL3_m	45
		calcEdgeL3_m	44
		calcEdgeL3_m	43
		calcEdgeL3_m	42
		calcEdgeL3_m	41
		calcEdgeL3_m	40
		calcEdgeL3_m	39
		calcEdgeL3_m	38
		calcEdgeL3_m	37
		calcEdgeL3_m	36
		calcEdgeL3_m	35
		calcEdgeL3_m	34
		calcEdgeL3_m	33
		calcEdgeL3_m	32
		calcEdgeL3_m	31
		calcEdgeL3_m	30
		calcEdgeL3_m	29
		calcEdgeL3_m	28
		calcEdgeL3_m	27
		calcEdgeL3_m	26
		calcEdgeL3_m	25
		calcEdgeL3_m	24
		calcEdgeL3_m	23
		calcEdgeL3_m	22
		calcEdgeL3_m	21
		calcEdgeL3_m	20
		calcEdgeL3_m	19
		calcEdgeL3_m	18
		calcEdgeL3_m	17
		calcEdgeL3_m	16
		calcEdgeL3_m	15
		calcEdgeL3_m	14
		calcEdgeL3_m	13
		calcEdgeL3_m	12
		calcEdgeL3_m	11
		calcEdgeL3_m	10
		calcEdgeL3_m	9
		calcEdgeL3_m	8
		calcEdgeL3_m	7
		calcEdgeL3_m	6
		calcEdgeL3_m	5
		calcEdgeL3_m	4
		calcEdgeL3_m	3
		calcEdgeL3_m	2
		calcEdgeL3_m	1

.jp0:
		txa
		sta	edgeLeft+0, y
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
