;gs.asm

;2026-09-15
;7423行位にステージセット
;STAGE7の修正
;debug print 7948行位


;長さ統一して
;--------
;----------------
;---------------------
;----------------------------
;ゲームルール
;赤砲台を破壊でクリア
;緑砲台をある数量破壊（多分全破壊）で赤砲台を破壊可能になる
;
;当たり判定のない壁
;壊れる壁
;弾を打たない敵に乗らないと届かない空中ブロック
;当たり判定のある透明空中ブロック

;緑砲台をある順番で破壊しないといけない
;緑砲台を壊すと現れるブロック
;緑砲台を壊すと消えるブロック
;緑砲台を壊した回数で出てくる敵がちがう（例えば最初は弾を弾を打つ敵、次は弾を打たない敵）
;特定のブロックに乗ると現れるブロック
;特定のブロックに乗ると消えるブロック
;緑砲台総数セット（ゲーム開始時だけだと思う）
;緑砲台カウントダウン（緑砲台破壊時だけだと思う）
;出現する敵の種類変更（緑・青砲台破壊時とかブロックを打った・乗った時）
;出現する敵の総数+1（緑砲台破壊時だけだと思う）
;出現する敵の総数変更（ゲーム開始時とか緑砲台破壊時だけだと思う）


;ブロックに乗った時
;ブロックを打った時
;砲台を壊したとき

;イベント
;ステージ1	無し　ザコ敵出ません
;ステージ2	無し　緑を空中島に置いてジャンプをさせる　ザコ敵1
;ステージ3	無し　壊れるブロック・当たり判定のないブロック
;ステージ4	乗ると現れるブロック　緑を空中島に置いてジャンプをさせる
;ステージ5	緑を壊すと順番に現れる　緑を空中島に置いてジャンプをさせる
;ステージ6	無し　緑を空中島に置いてジャンプをさせる　見えない空中島
;ステージ7	無し　弾を打たない敵が出てきて、それに乗らないと届かない
;ステージ8	無し

;STAGE START
;STAGE CLEAR




;///////////////////////////
;////////  DEFINE   ////////
;///////////////////////////
;---------------------
SCREEN_256_192		;screen 256 * 192 dot
VCE_5M			;VCE Clock 5M
DISPLAY_BOTTOM_144	;polygon screen 144 line

SAMPLE_Z_MAX_ONLY

;///////////////////////////
;////////  INCLUDE  ////////
;///////////////////////////
;---------------------
		INCLUDE	"poly_inc.asm"


;///////////////////////////
;////////    EQU    ////////
;///////////////////////////
;---------------------
CG_DATA_BANK		.equ	POLYGON_FUNC_LAST_BANK + 1	;32
SG_DATA_BANK		.equ	CG_DATA_BANK + 1		;33
MAIN_PRG_BANK		.equ	SG_DATA_BANK + 1		;34
MAIN_PRG_MAP		.equ	$05
SUB0_PRG_BANK		.equ	MAIN_PRG_BANK + 1
SUB0_PRG_MAP		.equ	$04
SUB1_PRG_BANK		.equ	SUB0_PRG_BANK + 1
SUB1_PRG_MAP		.equ	$03
SUB2_PRG_BANK		.equ	SUB1_PRG_BANK + 1
SUB2_PRG_MAP		.equ	$02

;---------------------
SCREEN_CENTER_X		.equ	128
SCREEN_CENTER_Y		.equ	72

;---------------------
POLYGON_DRAW_XYZ_MAX	.equ	1024

;---------------------
SHIP_WORLD_SIZE_X		.equ	1024 * 4
SHIP_WORLD_SIZE_Y		.equ	1024 * 8
SHIP_WORLD_SIZE_Z		.equ	1024 * 4

;---------------------
SHIP_SIZE_X		.equ	128
SHIP_SIZE_Y		.equ	72
SHIP_SIZE_Z		.equ	128

;---------------------
SHIP_SHIELD_MAX		.equ	16
;;;SHIP_SHIELD_MAX		.equ	32

;---------------------
OBJ_ACTIVE		.equ	$80
OBJ_ENTITY		.equ	$40
OBJ_HIT			.equ	$20
OBJ_RADAR		.equ	$10	;主に BLOCK でもレーダーに表示するもの 島とか

OBJ_EXPLOSION		.equ	$02
OBJ_UNEXPLOSION		.equ	$FD
OBJ_FLASH		.equ	$01
OBJ_UNFLASH		.equ	$FE
OBJ_UNSET		.equ	$00

OBJ_START_WAIT		.equ	$10
OBJ_NO3_MOVE_MODE1	.equ	$20
OBJ_NO3_UN_MOVE_MODE1	.equ	$DF
OBJ_NO3_MOVE_MODE1_TIMER_MAX	.equ	64

OBJ_NO4_MOVE_MODE1	.equ	OBJ_NO3_MOVE_MODE1
OBJ_NO4_UN_MOVE_MODE1	.equ	OBJ_NO3_UN_MOVE_MODE1
OBJ_NO4_MOVE_MODE1_TIMER_MAX	.equ	OBJ_NO3_MOVE_MODE1_TIMER_MAX

OBJ_ROTATION_STEP	.equ	4
OBJ_MOVE_TIMER_DATA	.equ	64
OBJ_DOWN_DATA		.equ	16
OBJ_NO3_MODE1_ROTATION_DATA	.equ	192

OBJ_NO4_MODE1_ROTATION_DATA	.equ	OBJ_NO3_MODE1_ROTATION_DATA

MODEL_TYPE_BLOCK	.equ	$01
MODEL_TYPE_OBJ		.equ	$02	;レーダーと ENEMY 表示用
MODEL_TYPE_SHOT		.equ	$03
MODEL_TYPE_ENEMY_SHOT	.equ	$04
MODEL_TYPE_EXOBJ	.equ	$05	;obj_NO 8 "壊れるブロック No.0" 用 使わず
MODEL_TYPE_BLOCK_RADAR	.equ	$06	;BLOCK でもレーダーに表示するもの 島とか

OBJ_FLASH_COLOR_INDEX	.equ	96

;---------------------
;;;OBJ0_SIZE		.equ	(100+128)
OBJ_SIZE		.equ	(200+128)	;OBJの大きさは当たり判定のために同じ
;当たり判定は大きいほうのを使う
;なので大きさで別々のを設定すればいいけど
;今のところ面倒くさいのでOBJの当たり判定はみんな同じ

;---------------------
;SE
SE_SHOT				.equ	0
SE_JUMP				.equ	1
SE_ENEMY_DAMAGE			.equ	2
SE_EXPLOSION			.equ	3
SE_SHIP_DAMAGE			.equ	4
SE_ON_ENEMY			.equ	5


;///////////////////////////
;////////    RAM    ////////
;///////////////////////////
		.zp
;---------------------
stageDataAddr		.ds	2
stageAddr		.ds	2
blockDataAddr		.ds	2

;;;<--eventDataIndx		.ds	1
;;;<--eventSubAddr		.ds	2

polygonTableAddr	.ds	2

setCgtoSgStrAddr	.ds	2
setCgtoSgStrW0		.ds	2
setCgtoSgStrW1		.ds	2
setCgtoSgStrW2		.ds	2
setCgtoSgStrW3		.ds	2

psetAddr		.equ	setCgtoSgStrAddr
psetWork0		.equ	setCgtoSgStrW0
psetWork1		.equ	setCgtoSgStrW0+1
psetWork2		.equ	setCgtoSgStrW1
psetWork3		.equ	setCgtoSgStrW1+1
psetWork4		.equ	setCgtoSgStrW2
psetWork5		.equ	setCgtoSgStrW2+1
psetWork6		.equ	setCgtoSgStrW3
psetWork7		.equ	setCgtoSgStrW3+1


;---------------------
stageFlag0		.ds	1

;---------------------
;PSG
seAddress		.ds	2


;///////////////////////////
		.bss
;---------------------
;debug
;;;frameCount		.ds	1
;drawCount		.ds	1
;drawCountWork		.ds	1

;---------------------
stageCount		.ds	1

;---------------------
;PSG
seCounter		.ds	1
seCounterEnd		.ds	1
seNoise			.ds	1

seNo			.ds	1
seNoWork		.ds	1

;---------------------
setCgtoSgWorkW0		.ds	2
setCgtoSgWorkW1		.ds	2
;;;<--setCgtoSgWorkW2		.ds	2
setCgtoSgWork0		.ds	1

;---------------------
titleRotY		.ds	1

;---------------------
reentrantFlag		.ds	1

;---------------------
stageStartCounter	.ds	1
stageClearCounter	.ds	1
gameOverCounter		.ds	1
stageEventCounter	.ds	1

;---------------------
enemyCount		.ds	1
enemyCountMax		.ds	1
enemyCountStageMax	.ds	1
ENEMY_COUNT_MAX		.equ	3

enemyCountMaxTable	.ds	5	;緑の砲台が 0,1,2,3,4 の時の順で並ぶ

;---------------------
moveObj_MODEL_1		.ds	2
moveObj_MODEL_2		.ds	2

;---------------------
subBaseCount		.ds	1
stageFlag		.ds	1
stageClearFlag		.ds	1
gameOverFlag		.ds	1
pauseFlag		.ds	1

;---------------------
setObjTimer		.ds	1
setObjSwitch		.ds	1
setSubObjTimer		.ds	1

;---------------------
setEnemyWait		.ds	1
setEnemyType		.ds	1
setEnemyHP		.ds	1
setEnemyShotWait	.ds	1

;---------------------
eyeTranslationXWork	.ds	2
eyeTranslationYWork	.ds	2
eyeTranslationZWork	.ds	2
eyeRotationXWork	.ds	1
eyeRotationYWork	.ds	1
eyeRotationZWork	.ds	1

;---------------------
shipPX			.ds	2
shipX			.ds	2
shipPY			.ds	2
shipY			.ds	2
shipPZ			.ds	2
shipZ			.ds	2
shipRX			.ds	1
shipRY			.ds	1
shipRZ			.ds	1
shipModel		.ds	2
shipStatus		.ds	1
shipHitX0		.ds	2
shipHitY0		.ds	2
shipHitZ0		.ds	2
shipHitX1		.ds	2
shipHitY1		.ds	2
shipHitZ1		.ds	2

;---------------------
shipShield		.ds	1

;---------------------
shipSpeed		.ds	2
shipJumpY		.ds	1

;---------------------
damageTimer		.ds	1

;---------------------
JUMP_INIT_DATA		.equ	$FF
JUMP_DOWN_INDEX		.equ	$40
JUMP_LAST_INDEX		.equ	$7E
JUMP_MAX_COUNT		.equ	2
JUMP_SECOND_INDEX	.equ	$20

jumpCount		.ds	1
jumpMaxCount		.ds	1;;;<--2026-09-15
jumpObjNo		.ds	1;;;<--2026-09-15
jumpIndex		.ds	1

;---------------------
shipWorldX0		.ds	2
shipWorldX1		.ds	2
shipWorldZ0		.ds	2
shipWorldZ1		.ds	2

;---------------------
moveShipWorkZ		.ds	2
moveShipWorkRY		.ds	1

;---------------------
shipMoveX		.ds	4
shipMoveY		.ds	4
shipMoveZ		.ds	4

;---------------------
shipWorkX		.ds	4
shipWorkY		.ds	4
shipWorkZ		.ds	4

;---------------------
hitX			.ds	2
hitY			.ds	2
hitZ			.ds	2

;---------------------
hitWorldX0		.ds	2
hitWorldZ0		.ds	2

;---------------------
;enemy shot で使っているけど objWorkPX と一緒にしても良い？
enemyPX			.ds	2
enemyX			.ds	2
enemyPY			.ds	2
enemyY			.ds	2
enemyPZ			.ds	2
enemyZ			.ds	2

;---------------------
;obj 旧位置データ退避用 shipWorkX と一緒にしても良い？
objWorkPX		.ds	2
objWorkX		.ds	2
objWorkPY		.ds	2
objWorkY		.ds	2
objWorkPZ		.ds	2
objWorkZ		.ds	2

;---------------------
;obj 移動距離保存用 shipMoveX と一緒にしても良い？
objMoveX		.ds	4
objMoveY		.ds	4
objMoveZ		.ds	4

;---------------------
;obj 移動角度計算用
objWorkRY_A		.ds	1
objWorkRY_B		.ds	1

;---------------------
;地平線描画用
groundY			.ds	1
groundYWork		.ds	1

groundCharCount		.ds	1
groundLineCount		.ds	1

_groundCharCount	.ds	1
_groundLineCount	.ds	1

_groundY		.ds	1

skyCharCount		.ds	1
skyLineCount		.ds	1

groundClolorP0		.ds	1
groundClolorP1		.ds	1
groundClolorP2		.ds	1
groundClolorP3		.ds	1

groundVramAddr		.ds	2

;---------------------
;レーダー描画用
radarPsetColor		.ds	1

;---------------------
TO_MEM_FROM_TABLE_W		.macro
;\1 = \2, x
		lda	\2_0, x
		sta	\1

		lda	\2_1, x
		sta	\1+1
		.endm


;---------------------
TO_MEM_FROM_TABLE_Q		.macro
;\1 = \3, x:\2, x
		TO_MEM_FROM_TABLE_W	\1, \2
		TO_MEM_FROM_TABLE_W	\1+2, \3
		.endm


;---------------------
TO_TABLE_Q		.macro
;\2, x:\1, x = \3:\4
;\2, x:\1, x = \3
		.if	(\?2 = 3);Immediate
			TO_TABLE_W	\1, \4
			TO_TABLE_W	\2, \3
		.else
			TO_TABLE_W	\1, \3
			TO_TABLE_W	\2, \3+2
		.endif
		.endm


;---------------------
TO_A_FROM_TABLE		.macro
;a = \1, x
		lda	\1, x
		.endm


;---------------------
TO_ADDR_Y_FROM_TABLE		.macro
;[\1], \2 = \3, x
		lda	\3, x
		ldy	#\2
		sta	[\1], y
		.endm


;---------------------
TO_ADDR_Y_FROM_TABLE_W		.macro
;[\1], \2 = \3, x
		lda	\3_0, x
		ldy	#\2
		sta	[\1], y

		lda	\3_1, x
		iny
		sta	[\1], y
		.endm


;---------------------
TO_ADDR_Y_FROM_A		.macro
;[\1], \2 = A
		ldy	#\2
		sta	[\1], y
		.endm


;---------------------
TO_TABLE		.macro
;\1, x = \2
		lda	\2
		sta	\1, x
		.endm


;---------------------
TO_TABLE_FROM_A		.macro
;\1, x = a
		sta	\1, x
		.endm


;---------------------
TO_TABLE_W		.macro
;\1, x = \2
		.if	(\?2 = 2);Immediate
			lda	#LOW(\2)
			sta	\1_0, x

			lda	#HIGH(\2)
			sta	\1_1, x
		.else
			lda	\2
			sta	\1_0, x

			lda	\2+1
			sta	\1_1, x
		.endif
		.endm


;---------------------
TO_MEM_FROM_ADDR_Y_W		.macro
;\1 = [\2], \3
		ldy	#\3
		lda	[\2], y
		sta	\1

		iny
		lda	[\2], y
		sta	\1+1
		.endm


;---------------------
TO_MEM_FROM_ADDR_Y		.macro
;\1 = [\2], \3
		ldy	#\3
		lda	[\2], y
		sta	\1
		.endm


;---------------------
TO_ADDR_Y		.macro
;[\1], \2 = \3
		lda	\3
		ldy	#\2
		sta	[\1], y
		.endm


;---------------------
TO_ADDR_Y_W		.macro
;[\1], \2 = \3
		.if	(\?3 = 2);Immediate
			lda	#LOW(\3)
			ldy	#\2
			sta	[\1], y

			lda	#HIGH(\3)
			iny
			sta	[\1], y
		.else
			lda	\3
			ldy	#\2
			sta	[\1], y

			lda	\3+1
			iny
			sta	[\1], y
		.endif
		.endm


;---------------------
TO_A_FROM_ADDR_Y		.macro
;a = [\1], \2
		ldy	#\2
		lda	[\1], y
		.endm


;---------------------
TO_TABLE_FROM_ADDR_Y		.macro
;\1, x = [\2], \3
		ldy	#\3
		lda	[\2], y
		sta	\1, x
		.endm


;---------------------
TO_TABLE_FROM_ADDR_Y_W		.macro
;\1, x = [\2], \3
		ldy	#\3
		lda	[\2], y
		sta	\1_0, x

		iny
		lda	[\2], y
		sta	\1_1, x
		.endm


;---------------------
ADD_TABLE_FROM_ADDR_Y_W		.macro
;\1, x = \2, x + [\3], \4

		ldy	#\4
		lda	\2_0, x
		clc
		adc	[\3], y
		sta	\1_0, x

		iny
		lda	\2_1, x
		adc	[\3], y
		sta	\1_1, x
		.endm


;---------------------
ADD_TABLE_FROM_MEM_MEM_Q		.macro
;\2, x:\1, x = \3 + \4
		clc

		lda	\3
		adc	\4
		sta	\1_0, x

		lda	\3+1
		adc	\4+1
		sta	\1_1, x

		lda	\3+2
		adc	\4+2
		sta	\2_0, x

		lda	\3+3
		adc	\4+3
		sta	\2_1, x
		.endm


;---------------------
ADD_TABLES_W		.macro
;\1, x = \2, x + \3, x

		lda	\2_0, x
		clc
		adc	\3_0, x
		sta	\1_0, x

		lda	\2_1, x
		adc	\3_1, x
		sta	\1_1, x
		.endm


;---------------------
ADD_TABLES_Q		.macro
;\2, x:\1, x = \2, x:\1, x + \4, x:\3, x
;\2, x:\1, x = \4, x:\3, x + \6, x:\5, x

		.if	(\# = 6)
			clc
			lda	\3_0, x
			adc	\5_0, x
			sta	\1_0, x

			lda	\3_1, x
			adc	\5_1, x
			sta	\1_1, x

			lda	\4_0, x
			adc	\6_0, x
			sta	\2_0, x

			lda	\4_1, x
			adc	\6_1, x
			sta	\2_1, x
		.else
			clc
			lda	\1_0, x
			adc	\3_0, x
			sta	\1_0, x

			lda	\1_1, x
			adc	\3_1, x
			sta	\1_1, x

			lda	\2_0, x
			adc	\4_0, x
			sta	\2_0, x

			lda	\2_1, x
			adc	\4_1, x
			sta	\2_1, x
		.endif
		.endm


;---------------------
TO_MEM_SUB_ADDR_Y_FROM_MEM_W		.macro
;\1 = [\2], \3 - \4
		ldy	#\3
		lda	[\2], y
		sec
		sbc	\4
		sta	\1

		iny
		lda	[\2], y
		sbc	\4+1
		sta	\1+1
		.endm


;---------------------
CMP_MEM_FROM_TABLE_W		.macro
;\1 - \2, x
		lda	\1
		sec
		sbc	\2_0, x

		lda	\1+1
		sbc	\2_1, x
		.endm


;---------------------
CMP_A_FROM_TABLE		.macro
;A - \1, x
		cmp	\1, x
		.endm


;---------------------
CMP_TABLE		.macro
;\1, x - \2
		lda	\1, x
		cmp	\2
		.endm


;---------------------
CMP_TABLE_W		.macro
;\1, x - \2
		.if	(\?2 = 2);Immediate
			sec
			lda	\1_0, x
			sbc	#LOW(\2)

			lda	\1_1, x
			sbc	#HIGH(\2)
		.else
			sec
			lda	\1_0, x
			sbc	\2

			lda	\1_1, x
			sbc	\2+1
		.endif
		.endm


;---------------------
ADD_TABLE		.macro
;\1, x = \1, x - \2
		clc
		lda	\1, x
		adc	\2
		sta	\1, x
		.endm


;---------------------
SUB_TABLE		.macro
;\1, x = \1, x - \2
		sec
		lda	\1, x
		sbc	\2
		sta	\1, x
		.endm


;---------------------
SUB_A_FROM_TABLE		.macro
;A - \1, x
		sec
		sbc	\1, x
		.endm


;---------------------
SUB_TABLE_W		.macro
;\1, x = \1, x - \2
		.if	(\?2 = 2);Immediate
			sec
			lda	\1_0, x
			sbc	#LOW(\2)
			sta	\1_0, x

			lda	\1_1, x
			sbc	#HIGH(\2)
			sta	\1_1, x
		.else
			sec
			lda	\1_0, x
			sbc	\2
			sta	\1_0, x

			lda	\1_1, x
			sbc	\2+1
			sta	\1_1, x
		.endif
		.endm


;---------------------
SHOT_TABLE_COUNT_MAX	.equ	4

shot_PX_0		.ds	SHOT_TABLE_COUNT_MAX
shot_PX_1		.ds	SHOT_TABLE_COUNT_MAX

shot_X_0		.ds	SHOT_TABLE_COUNT_MAX
shot_X_1		.ds	SHOT_TABLE_COUNT_MAX

shot_PY_0		.ds	SHOT_TABLE_COUNT_MAX
shot_PY_1		.ds	SHOT_TABLE_COUNT_MAX

shot_Y_0		.ds	SHOT_TABLE_COUNT_MAX
shot_Y_1		.ds	SHOT_TABLE_COUNT_MAX

shot_PZ_0		.ds	SHOT_TABLE_COUNT_MAX
shot_PZ_1		.ds	SHOT_TABLE_COUNT_MAX

shot_Z_0		.ds	SHOT_TABLE_COUNT_MAX
shot_Z_1		.ds	SHOT_TABLE_COUNT_MAX

shot_RX			.ds	SHOT_TABLE_COUNT_MAX
shot_RY			.ds	SHOT_TABLE_COUNT_MAX
shot_RZ			.ds	SHOT_TABLE_COUNT_MAX

shot_MODEL_0		.ds	SHOT_TABLE_COUNT_MAX
shot_MODEL_1		.ds	SHOT_TABLE_COUNT_MAX

shot_STATUS		.ds	SHOT_TABLE_COUNT_MAX

shot_MOVE_PX_0		.ds	SHOT_TABLE_COUNT_MAX
shot_MOVE_PX_1		.ds	SHOT_TABLE_COUNT_MAX

shot_MOVE_X_0		.ds	SHOT_TABLE_COUNT_MAX
shot_MOVE_X_1		.ds	SHOT_TABLE_COUNT_MAX

shot_MOVE_PY_0		.ds	SHOT_TABLE_COUNT_MAX
shot_MOVE_PY_1		.ds	SHOT_TABLE_COUNT_MAX

shot_MOVE_Y_0		.ds	SHOT_TABLE_COUNT_MAX
shot_MOVE_Y_1		.ds	SHOT_TABLE_COUNT_MAX

shot_MOVE_PZ_0		.ds	SHOT_TABLE_COUNT_MAX
shot_MOVE_PZ_1		.ds	SHOT_TABLE_COUNT_MAX

shot_MOVE_Z_0		.ds	SHOT_TABLE_COUNT_MAX
shot_MOVE_Z_1		.ds	SHOT_TABLE_COUNT_MAX

;;;<--shotCount		.ds	1


;---------------------
ENEMYSHOT_TABLE_COUNT_MAX	.equ	16

enemyshot_PX_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_PX_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_X_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_X_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_PY_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_PY_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_Y_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_Y_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_PZ_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_PZ_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_Z_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_Z_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_RX			.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_RY			.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_RZ			.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_MODEL_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_MODEL_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_STATUS		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_MOVE_PX_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_MOVE_PX_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_MOVE_X_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_MOVE_X_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_MOVE_PY_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_MOVE_PY_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_MOVE_Y_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_MOVE_Y_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_MOVE_PZ_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_MOVE_PZ_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

enemyshot_MOVE_Z_0		.ds	ENEMYSHOT_TABLE_COUNT_MAX
enemyshot_MOVE_Z_1		.ds	ENEMYSHOT_TABLE_COUNT_MAX

;;;<--enemyshotCount		.ds	1


;---------------------
BLOCK_TABLE_COUNT_MAX	.equ	32

block_X_0		.ds	BLOCK_TABLE_COUNT_MAX
block_X_1		.ds	BLOCK_TABLE_COUNT_MAX

block_Y_0		.ds	BLOCK_TABLE_COUNT_MAX
block_Y_1		.ds	BLOCK_TABLE_COUNT_MAX

block_Z_0		.ds	BLOCK_TABLE_COUNT_MAX
block_Z_1		.ds	BLOCK_TABLE_COUNT_MAX

block_RX		.ds	BLOCK_TABLE_COUNT_MAX
block_RY		.ds	BLOCK_TABLE_COUNT_MAX
block_RZ		.ds	BLOCK_TABLE_COUNT_MAX

block_MODEL_0		.ds	BLOCK_TABLE_COUNT_MAX
block_MODEL_1		.ds	BLOCK_TABLE_COUNT_MAX

block_STATUS		.ds	BLOCK_TABLE_COUNT_MAX

block_HIT_X0_0		.ds	BLOCK_TABLE_COUNT_MAX
block_HIT_X0_1		.ds	BLOCK_TABLE_COUNT_MAX

block_HIT_Y0_0		.ds	BLOCK_TABLE_COUNT_MAX
block_HIT_Y0_1		.ds	BLOCK_TABLE_COUNT_MAX

block_HIT_Z0_0		.ds	BLOCK_TABLE_COUNT_MAX
block_HIT_Z0_1		.ds	BLOCK_TABLE_COUNT_MAX

block_HIT_X1_0		.ds	BLOCK_TABLE_COUNT_MAX
block_HIT_X1_1		.ds	BLOCK_TABLE_COUNT_MAX

block_HIT_Y1_0		.ds	BLOCK_TABLE_COUNT_MAX
block_HIT_Y1_1		.ds	BLOCK_TABLE_COUNT_MAX

block_HIT_Z1_0		.ds	BLOCK_TABLE_COUNT_MAX
block_HIT_Z1_1		.ds	BLOCK_TABLE_COUNT_MAX

block_ON_EVENT0		.ds	BLOCK_TABLE_COUNT_MAX
block_ON_EVENT1		.ds	BLOCK_TABLE_COUNT_MAX

block_HIT_EVENT0	.ds	BLOCK_TABLE_COUNT_MAX
block_HIT_EVENT1	.ds	BLOCK_TABLE_COUNT_MAX

;block の個数は１ステージ通して変わらないので、ループ数を少なくするために比較用カウントを記録しておく
blockCount		.ds	1


;---------------------
;OBJ No.$FF は OBJ 同士の判定以外で使うので OBJ の最大数は 254 まで
OBJ_TABLE_COUNT_MAX	.equ	8+4	;固定 obj 用 8 + enemy obj 用 4
obj_PX_0		.ds	OBJ_TABLE_COUNT_MAX
obj_PX_1		.ds	OBJ_TABLE_COUNT_MAX

obj_X_0			.ds	OBJ_TABLE_COUNT_MAX
obj_X_1			.ds	OBJ_TABLE_COUNT_MAX

obj_PY_0		.ds	OBJ_TABLE_COUNT_MAX
obj_PY_1		.ds	OBJ_TABLE_COUNT_MAX

obj_Y_0			.ds	OBJ_TABLE_COUNT_MAX
obj_Y_1			.ds	OBJ_TABLE_COUNT_MAX

obj_PZ_0		.ds	OBJ_TABLE_COUNT_MAX
obj_PZ_1		.ds	OBJ_TABLE_COUNT_MAX

obj_Z_0			.ds	OBJ_TABLE_COUNT_MAX
obj_Z_1			.ds	OBJ_TABLE_COUNT_MAX

obj_RX			.ds	OBJ_TABLE_COUNT_MAX
obj_RY			.ds	OBJ_TABLE_COUNT_MAX
obj_RZ			.ds	OBJ_TABLE_COUNT_MAX

obj_MODEL_0		.ds	OBJ_TABLE_COUNT_MAX
obj_MODEL_1		.ds	OBJ_TABLE_COUNT_MAX

obj_STATUS		.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_X0_0		.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_X0_1		.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_Y0_0		.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_Y0_1		.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_Z0_0		.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_Z0_1		.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_X1_0		.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_X1_1		.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_Y1_0		.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_Y1_1		.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_Z1_0		.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_Z1_1		.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_DATA_X0_0	.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_DATA_X0_1	.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_DATA_Y0_0	.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_DATA_Y0_1	.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_DATA_Z0_0	.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_DATA_Z0_1	.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_DATA_X1_0	.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_DATA_X1_1	.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_DATA_Y1_0	.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_DATA_Y1_1	.ds	OBJ_TABLE_COUNT_MAX

obj_HIT_DATA_Z1_0	.ds	OBJ_TABLE_COUNT_MAX
obj_HIT_DATA_Z1_1	.ds	OBJ_TABLE_COUNT_MAX

obj_SHOT_TIMER		.ds	OBJ_TABLE_COUNT_MAX

obj_SHOT_TIMER_MAX	.ds	OBJ_TABLE_COUNT_MAX

obj_MODEL_TIMER		.ds	OBJ_TABLE_COUNT_MAX

obj_FLASH_TIMER		.ds	OBJ_TABLE_COUNT_MAX

obj_MOVE_TIMER		.ds	OBJ_TABLE_COUNT_MAX

obj_HP			.ds	OBJ_TABLE_COUNT_MAX

obj_NO			.ds	OBJ_TABLE_COUNT_MAX

obj_MOVE_STATUS		.ds	OBJ_TABLE_COUNT_MAX

obj_DESTORY_EVENT_0	.ds	OBJ_TABLE_COUNT_MAX
obj_DESTORY_EVENT_1	.ds	OBJ_TABLE_COUNT_MAX

obj_WAIT_TIMER		.equ	obj_FLASH_TIMER

OBJ_WAIT_TIMER_MAX	.equ	64
OBJ_FLASH_TIMER_MAX	.equ	10
OBJ_EXPLOSION_TIMER_0_MAX	.equ	32
OBJ_EXPLOSION_TIMER_1_MAX	.equ	64

;;;<--objCount		.ds	1
objHitNo		.ds	1

;---------------------
setObjX			.ds	2
setObjY			.ds	2
setObjZ			.ds	2
setObjRX		.ds	1
setObjRY		.ds	1
setObjRZ		.ds	1
setObjHp		.ds	1
setObjNo		.ds	1
setObjShotTimerMax	.ds	1
setObjStatus		.ds	1
setObjMoveStatus	.ds	1
setObjModel		.ds	2
setObjDestroyEvent0	.ds	1
setObjDestroyEvent1	.ds	1


;---------------------
			.rsset	0
POLYGON_X		.rs	2
POLYGON_Y		.rs	2
POLYGON_Z		.rs	2
POLYGON_RX		.rs	1
POLYGON_RY		.rs	1
POLYGON_RZ		.rs	1
POLYGON_MODEL		.rs	2
POLYGON_MODEL_TYPE	.rs	1
POLYGON_COLOR		.rs	1
POLYGON_STRUCT_SIZE	.rs	0

POLYGON_TABLE_COUNT_MAX	.equ	(32 + 8 + 4 + 16)	;32 BLOCK, 8 ENEMY, 4 SHOT, 16 ENEMY SHOT
POLYGON_TABLE_SIZE	.equ	POLYGON_TABLE_COUNT_MAX * POLYGON_STRUCT_SIZE
polygonTable		.ds	POLYGON_TABLE_SIZE

polygonTableCount	.ds	1

;---------------------
mul16aTemp		.ds	2
mul16bTemp		.ds	2
mul16cTemp		.ds	2
mul16dTemp		.ds	2

mulAddr0Temp		.ds	2
mulAddr1Temp		.ds	2

saveMpr2Temp		.ds	1
saveMpr3Temp		.ds	1

sinLowAddrTemp		.ds	2
sinHighAddrTemp		.ds	2

cosLowAddrTemp		.ds	2
cosHighAddrTemp		.ds	2

saveSin8DataTemp	.ds	2
saveCos8DataTemp	.ds	2

vertexCountTemp		.ds	1

transform2DWork0Temp	.ds	6

angleX0Temp		.ds	2
angleY0Temp		.ds	2
angleZ0Temp		.ds	2

angleX1Temp		.ds	2
angleY1Temp		.ds	2
angleZ1Temp		.ds	2

ansAngleXTemp		.ds	1
ansAngleYTemp		.ds	1

work8aTemp		.ds	8
work8bTemp		.ds	8
vertexRotationSinTemp	.ds	2
vertexRotationCosTemp	.ds	2

;---------------------
;debug
debug0			.ds	1
;;;debug1			.ds	1

;---------------------
		INCLUDE	"poly_ds.asm"


;///////////////////////////
;////////    ROM    ////////
;///////////////////////////
;----------------------------
;--------    CODE    --------
;----------------------------
		.code

		.bank	0
		.org	$E000

;----------------------------
main:
;
		lda	#MAIN_PRG_BANK
		tam	#MAIN_PRG_MAP

		jmp	mainPrg


;----------------------------
vsyncFunction:
;
		bbr5	<vdpStatus, .skip

;----------------
		jsr	getPadData
		jcs	_reset


		;;;jmp	.psgSkip	;;;<--

;----------------
;psg
;;;<--
		mov	PSG_0, #$05	;ch sel(bit2-0)

		lda	seCounterEnd
		beq	.psgSkip

		ldy	seCounter
		beq	.psgJp00

		cpy	seCounterEnd
		beq	.psgJp01

		bra	.psgJp02

;keyon
.psgJp00:
		mov	PSG_4, #$9F	;key on(bit7), dda off(bit6), ch vol(bit4-0)
		stz	PSG_7		;ch noise enable(bit7), freq low(bit4-0)

.psgJp02:
		lda	seNoise
		bmi	.jpNoise

;psg
		lda	[seAddress], y
		sta	PSG_2		;ch freq low(bit7-0)

		iny
		lda	[seAddress], y
		sta	PSG_3		;ch freq high(bit3-0)

		iny
		lda	[seAddress], y
		sta	PSG_5		;ch vol Lvol(bit7-4) Rvol(bit3-0)

		iny
		sty	seCounter
		bra	.psgSkip

;noise
.jpNoise:
		lda	[seAddress], y
		sta	PSG_7		;ch noise enable(bit7), freq low(bit4-0)

		iny
		lda	[seAddress], y
		sta	PSG_5		;ch vol Lvol(bit7-4) Rvol(bit3-0)

		iny
		sty	seCounter
		bra	.psgSkip

;keyoff
.psgJp01:
		mov	PSG_4, #$1F	;key on(bit7), dda off(bit6), ch vol(bit4-0)
		mov	seCounter, #0
		mov	seCounterEnd, #0

.psgSkip:



;----------------
;;;		dec	frameCount
;		bne	.debugEnd
;
;		lda	#60
;		sta	frameCount
;
;		lda	drawCountWork
;		sta	drawCount
;		stz	drawCountWork
;.debugEnd:

;----------------
.skip:
		rts


;----------------------------
_irq1_SwitchScreen:
;clear vsyncFlag, set drawingNo, set VRAM_SAT DMA, set scroll y
		stz	<vsyncFlag

		lda	<drawingNo
		eor	#$01
		sta	<drawingNo

		beq	.jp01

;set VRAM_SAT DMA
		st012	#$13, #$0800

;set scroll y
		st012	#$08, #$0000
		bra	.jp00

.jp01:
;set VRAM_SAT DMA
		st012	#$13, #$0900

;set scroll y
		st012	#$08, #$0100

.jp00:
		rts


;----------------------------
_irq1:
;
		IRQ_ENTRY

;----------------
		lda	VDC_0
		sta	<vdpStatus


;----------------
;game stage ?
		lda	stageFlag
		bne	.gameStage

;----------------
;vsync ?
		tst	#%00100000, <vdpStatus
		jeq	.titleJp00

;----------------
;palette
		movw	tiaSrc, #undamagePalette

		movw	VCE_2, #16*15

		movw	tiaDst, #VCE_4
		movw	tiaCnt, #32

		jsr	tiaFunction

;----------------
;vsync flag ?
		bbr7	<vsyncFlag, .titleJp00

;----------------
		jsr	_irq1_SwitchScreen

;;;;clear vsyncFlag, set drawingNo, set VRAM_SAT DMA, set scroll y
;		stz	<vsyncFlag
;
;		lda	<drawingNo
;		eor	#$01
;		sta	<drawingNo
;
;		beq	.titleJp01
;
;;set VRAM_SAT DMA
;		st012	#$13, #$0800
;
;;set scroll y
;		st012	#$08, #$0000
;		bra	.titleJp00
;
;.titleJp01:
;;set VRAM_SAT DMA
;		st012	#$13, #$0900
;
;;set scroll y
;		st012	#$08, #$0100
;

;----------------
.titleJp00:
		jsr	vsyncFunction

		IRQ_EXIT



;----------------
.gameStage:
;vsync ?
		tst	#%00100000, <vdpStatus
		jeq	.jp00


;;;<--
;;----------------
;		lda	reentrantFlag
;		beq	.entrant
;		IRQ_EXIT
;
;.entrant:



;----------------
;palette
		lda	damageTimer
		bne	.damagePalette

		movw	tiaSrc, #undamagePalette
		bra	.setPalette

.damagePalette:
		lda	damageTimer
		and	#$60
		clc
		adc	#LOW(damagePalette)
		sta	tiaSrc
		cla
		adc	#HIGH(damagePalette)
		sta	tiaSrc+1

.setPalette:
		movw	VCE_2, #16*15

		movw	tiaDst, #VCE_4
		movw	tiaCnt, #32

		jsr	tiaFunction

;----------------
;vsync flag ?
		bbr7	<vsyncFlag, .jp00

;----------------
;clear vsyncFlag, set drawingNo, set VRAM_SAT DMA, set scroll y
		stz	<vsyncFlag

		lda	<drawingNo
		eor	#$01
		sta	<drawingNo

		beq	.jp01

;set VRAM_SAT DMA
		st012	#$13, #$0800

;set scroll y
		st012	#$08, #$0000
		bra	.jp03

.jp01:
;set VRAM_SAT DMA
		st012	#$13, #$0900

;set scroll y
		st012	#$08, #$0100

.jp03:
;----------------
		jsr	setGroundY

;----------------
		jsr	setEyeWork

;----------------
		jsr	setPolygonWork

;----------------
.jp00:

;----------------
		jsr	vsyncFunction

;;;<--
;----------------
;game logic

;----------------
;vsync ?
		bbr5	<vdpStatus, .jp10

;----------------
;PAUSE?
		bbr3	<padState, .skipPause

		lda	stageClearFlag
		ora	gameOverFlag
		bne	.skipPause

		lda	pauseFlag
		eor	#$FF
		sta	pauseFlag

.skipPause:
		lda	pauseFlag
		bne	.jp10

;----------------
		lda	reentrantFlag
		bne	.jp10

		mov	reentrantFlag, #$FF
		cli

;----------------
		lda	stageStartCounter
		beq	.skipStartJp

		dec	a
		sta	stageStartCounter
.skipStartJp:

;----------------
;;;<--		lda	stageClearCounter
;		cmp	#191
;		bne	.clearJp00
;
;;;;<--
;		tma	#SUB2_PRG_MAP
;		pha
;		lda	#CG_DATA_BANK
;		tam	#SUB2_PRG_MAP
;
;		movw	<setCgtoSgStrAddr, #strSTAGE_CLEAR
;		movw	setCgtoSgWorkW0, #$4000
;		movw	setCgtoSgWorkW1, #$0070
;		mov	setCgtoSgWork0, #$00
;		jsr	setStrToSg
;
;		pla
;;;;<--		lda	#SUB2_PRG_BANK
;		tam	#SUB2_PRG_MAP
;
;.clearJp00:
		lda	stageClearCounter
		beq	.skipClearJp

		dec	a
		sta	stageClearCounter
.skipClearJp:

;----------------
		lda	gameOverCounter
		beq	.skipOverJp

		dec	a
		sta	gameOverCounter
.skipOverJp:

;----------------
		lda	stageEventCounter
		beq	.skipEventJp

		dec	a
		sta	stageEventCounter
.skipEventJp:


;----------------
		jsr	moveToTemp

;----------------
		jsr	clearObjHitFlag

;----------------
		jsr	moveShot

;----------------
		jsr	moveEnemyshot

;----------------
		jsr	moveShip

;----------------
		jsr	jumpShip

;----------------
		jsr	moveObj

;----------------
		jsr	setGameObj

;----------------
		jsr	moveFromTemp

;----------------
		sec
		stz	reentrantFlag

;----------------
.jp10:
		IRQ_EXIT


;----------------------------
_timer:
;
		IRQ_ENTRY

		stz	INTERRUPT_STATE_REG

		;;;<--jsr	timerPlayDdaFunction

		IRQ_EXIT


;----------------------------
_irq2:
_nmi:
;
		IRQ_ENTRY

		IRQ_EXIT


;----------------------------
_reset:
;
		RESET_PROCESS

;jump main
		jmp	main


;----------------------------
setSe:
;a:se No.
		phx

		sta	seNoWork
		tax

		lda	seCounterEnd
		beq	.jp02

;;;		lda	seNoiseData, x
;		and	#$01
;		beq	.jp03
;
;		lda	seNoWork
;		cmp	seNo
;		beq	.jp00
;		bcc	.jp00
;
;		bra	.jp02
;
;.jp03:
		lda	seNoWork
		cmp	seNo
		bcc	.jp00

.jp02:
		sec

		sta	seNo
		;;;tax

		mov	seCounter, #0

		lda	seNoiseData, x
		sta	seNoise

		lda	seCounterEndData, x
		sta	seCounterEnd

		lda	seAddressLow, x
		sta	<seAddress

		lda	seAddressHigh, x
		sta	<seAddress+1

		cli

.jp00:
		plx
		rts


;----------------------------
;--------    DATA    --------
;----------------------------
;----------------------------
polygonColor:
;128 pattern
		;CH0
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $FF, $FF, $55, $00, $AA, $55, $FF
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $00, $00, $FF, $00, $FF, $00, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF
		.db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

		;CH1
		.db	$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $AA, $FF, $55, $00, $AA, $00, $FF
		.db	$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF
		.db	$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF
		.db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

		;CH2
		.db	$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $55, $00, $AA, $55, $FF
		.db	$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF
		.db	$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF
		.db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

		;CH3
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $AA, $55, $00, $AA, $FF, $FF, $FF, $FF
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $FF, $FF, $FF, $FF
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $AA, $FF, $FF, $FF, $FF
		.db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


;----------------------------
paletteData:
;0000000G GGRRRBBB
;----BG
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $00EA, $0104, $0124,\
			$01B6, $0038, $01C0, $0117, $0007, $00A1, $01C7, $01FF
		;;;<--.dw	$0000, $0020, $0100, $0120, $0004, $00EA, $01F8, $0124,\
		;	$01B6, $0038, $01C0, $0117, $0007, $00A1, $01C7, $01FF


;----SP
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		;;;<--.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
		;	$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0000, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01F8

		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0117, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $00A1, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF


;----------------------------
damagePalette:
;+1
		.dw	$0008, $0028, $0108, $0128, $000C, $00F2, $010C, $012C,\
			$01BE, $0038, $01C8, $011F, $000F, $00A9, $01CF, $01BE

;+2
		.dw	$0010, $0030, $0110, $0130, $0014, $00FA, $0114, $0134,\
			$017D, $0038, $01D0, $0127, $0017, $00B1, $01D7, $017D

;+3
		.dw	$0018, $0038, $0118, $0138, $001C, $00B9, $011C, $013C,\
			$013C, $0038, $01D8, $012F, $001F, $00B9, $01DF, $013C

;+4
		.dw	$0020, $0038, $0120, $00F8, $0024, $0078, $0124, $00FB,\
			$00FB, $0038, $01E0, $0137, $0027, $0078, $01E7, $00FB

;;;<--;+1
;		.dw	$0008, $0028, $0108, $0128, $000C, $00F2, $01B8, $012C,\
;			$01BE, $0038, $01C8, $011F, $000F, $00A9, $01CF, $01BE
;
;;+2
;		.dw	$0010, $0030, $0110, $0130, $0014, $00FA, $0178, $0134,\
;			$017D, $0038, $01D0, $0127, $0017, $00B1, $01D7, $017D
;
;;+3
;		.dw	$0018, $0038, $0118, $0138, $001C, $00B9, $0138, $013C,\
;			$013C, $0038, $01D8, $012F, $001F, $00B9, $01DF, $013C
;
;;+4
;		.dw	$0020, $0038, $0120, $00F8, $0024, $0078, $00F8, $00FB,\
;			$00FB, $0038, $01E0, $0137, $0027, $0078, $01E7, $00FB

;----------------------------
undamagePalette:
;+0
		.dw	$0000, $0020, $0100, $0120, $0004, $00EA, $0104, $0124,\
			$01B6, $0038, $01C0, $0117, $0007, $00A1, $01C7, $01FF

		;;;<--.dw	$0000, $0020, $0100, $0120, $0004, $00EA, $01F8, $0124,\
		;	$01B6, $0038, $01C0, $0117, $0007, $00A1, $01C7, $01FF


;----------------------------
;PSG
waveData0
		.db	$0F, $15, $19, $1B, $1D, $1E, $1F, $1E, $1D, $1B, $19, $15, $0F, $07, $17, $0A,\
			$14, $0D, $12, $0F, $10, $0A, $06, $04, $02, $01, $00, $01, $02, $04, $06, $0A

waveData3
		.db	$0F, $02, $11, $1F, $0F, $1C, $0D, $00, $0F, $02, $11, $1F, $0F, $1C, $0D, $00,\
			$0F, $02, $11, $1F, $0F, $1C, $0D, $00, $0F, $02, $11, $1F, $0F, $1C, $0D, $00


;;;se0FreqLow
;se0FreqHigh
;se0FreqVol

se00Data	;ショット
		.db	$1F, $00, $FF,\
			$0F, $00, $EE,\
			$8E, $00, $DD,\
			$6E, $00, $CC

		.db	$3F, $00, $FF,\
			$1F, $00, $FF,\
			$9E, $00, $FF,\
			$7E, $00, $FF,\
			$7E, $00, $CC,\
			$7E, $00, $88,\
			$7E, $00, $44,\
			$7E, $00, $22

		.db	$7F, $00, $FF,\
			$5F, $00, $FF,\
			$FE, $00, $FF,\
			$BE, $00, $FF,\
			$FE, $00, $FF,\
			$BE, $00, $FF,\
			$FE, $00, $FF,\
			$BE, $00, $FF,\
			$FE, $00, $FF,\
			$BE, $00, $FF,\
			$FE, $00, $FF,\
			$BE, $00, $FF,\
			$FE, $00, $FF,\
			$BE, $00, $FF,\
			$FE, $00, $FF,\
			$BE, $00, $FF,\
			$FE, $00, $FF,\
			$BE, $00, $FF,\
			$FE, $00, $FF,\
			$BE, $00, $FF

se03Data	;爆発
		.db	$94, $DD,\
			$94, $DD,\
			$97, $DD,\
			$97, $DD,\
			$98, $DD,\
			$98, $DD,\
			$82, $DD,\
			$81, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$8D, $DD,\
			$9D, $DD,\
			$8E, $DD,\
			$8E, $DD,\
			$8F, $DD,\
			$8F, $DD,\
			$82, $DD,\
			$81, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD



		.db	$9D, $DD,\
			$9E, $DD,\
			$9F, $DD,\
			$82, $DD,\
			$81, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$82, $DD,\
			$81, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$82, $DD,\
			$81, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD,\
			$80, $DD

se01Data	;ジャンプ
		.db	$9D, $BB,\
			$9E, $BB,\
			$9F, $BB,\
			$82, $BB,\
			$81, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$82, $BB,\
			$81, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$82, $BB,\
			$81, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB,\
			$80, $BB


se02Data	;エネミーダメージ
		.db	$40, $00, $FF,\
			$40, $00, $FF,\
			$40, $00, $DD,\
			$40, $00, $BB,\
			$40, $00, $99,\
			$40, $00, $77,\
			$40, $00, $55

		.db	$62, $00, $FF,\
			$8F, $00, $FF,\
			$62, $00, $FF,\
			$8F, $00, $FF,\
			$62, $00, $FF,\
			$8F, $00, $FF,\
			$62, $00, $FF,\
			$8F, $00, $FF,\
			$62, $00, $FF,\
			$8F, $00, $FF,\
			$62, $00, $FF,\
			$8F, $00, $FF,\
			$62, $00, $FF,\
			$8F, $00, $FF



se04Data	;シップダメージ
		.db	$9D, $DD,\
			$9E, $DD,\
			$9F, $DD,\
			$9D, $DD,\
			$9E, $DD,\
			$9F, $DD,\
			$82, $DD,\
			$81, $DD,\
			$80, $DD,\
			$80, $DD


se05Data	;赤敵に乗った時の音
		.db	$80, $01, $FF,\
			$B0, $00, $EE,\
			$D0, $00, $DD,\
			$F0, $00, $CC,\
			$10, $01, $CC,\
			$20, $01, $CC




seCounterEndData
		.db	3*4, 2*30, 3*7, 2*30, 2*10, 3*6

seNoiseData
		.db	$01, $80, $01, $80, $80, $01

seAddressLow
		.db	LOW(se00Data), LOW(se01Data), LOW(se02Data), LOW(se03Data), LOW(se04Data), LOW(se05Data)

seAddressHigh
		.db	HIGH(se00Data), HIGH(se01Data), HIGH(se02Data), HIGH(se03Data), HIGH(se04Data), HIGH(se05Data)



;///////////////////////////
;////////   DATAS   ////////
;///////////////////////////
		INCLUDE	"poly_datas.asm"


;----------------------------
		.org	$FFF6

		.dw	_irq2
		.dw	_irq1
		.dw	_timer
		.dw	_nmi
		.dw	_reset


;///////////////////////////
;//////// FUNCTIONS ////////
;///////////////////////////
		INCLUDE	"poly_proc.asm"


;////////////////////////////
		.bank	CG_DATA_BANK
		INCBIN	"char.chr"


;////////////////////////////
		.bank	SG_DATA_BANK
		INCBIN	"sp_char.chr"


;////////////////////////////
		.bank	MAIN_PRG_BANK
		.org	MAIN_PRG_MAP * $2000

;----------------------------
mainPrg:
		SET_POLYGON_FUNCTION

		jsr	initializePolygonFunction

;----------------
		movw	<argw0, #paletteData
		jsr	setAllPalette

;----------------
		movw	<argw0, #polygonColor
		jsr	setAllPolygonColor

;----------------
		lda	#CG_DATA_BANK
		tam	#$02

		movw	<argw0, #$4000
		movw	<argw1, #$0000
		movw	<argw2, #$0100
		movw	<argw3, #$0100
		jsr	setCgCharData

;----------------
		lda	#SG_DATA_BANK
		tam	#$02
		movw	<argw0, #$4000
		movw	<argw1, #$0048
		movw	<argw2, #$0048
		movw	<argw3, #28
		jsr	setSgCharData

;----------------
		lda	#SUB0_PRG_BANK
		tam	#SUB0_PRG_MAP

		lda	#SUB1_PRG_BANK
		tam	#SUB1_PRG_MAP

		lda	#SUB2_PRG_BANK
		tam	#SUB2_PRG_MAP


;;;<--
;----------------
		jmp	stageMain


;----------------
		jsr	initializeScreenVsync

;----------------
		ldx	#SCREEN_CENTER_X
		ldy	#SCREEN_CENTER_Y
		jsr	setScreenCenter

;----------------
;debug
;;;		lda	#60
;		sta	frameCount
;		stz	drawCount
;		stz	drawCountWork

;----------------
;debug
		ldx	#0
		ldy	#18
		jsr	setWriteVramAddress

		lda	#$30
		ldx	#$00
		jsr	putChar

		mov	<drawingNo, #DRAWING_NO_1

		ldx	#0
		ldy	#18
		jsr	setWriteVramAddress

		lda	#$31
		ldx	#$00
		jsr	putChar

		mov	<drawingNo, #DRAWING_NO_0

;----------------
;initialize game logic
		stz	reentrantFlag

		stz	setObjTimer
		stz	setObjSwitch
		stz	setSubObjTimer

		stz	enemyCount
		;;;stz	enemyCountMax
		mov	enemyCountMax, #4
		mov	enemyCountStageMax, #4

;緑 サブ砲台のカウント
		mov	subBaseCount, #4

		stz	stageClearFlag
		stz	gameOverFlag
		stz	pauseFlag

;;;<--
;;----------------
;;initialize etc
;		mov	subBaseCount, #4

;----------------
		jsr	initializeShip

;----------------
		jsr	setStageBlocks

;----------------
		jsr	setStageObjs

;----------------
		jsr	initializeShot

;----------------
		jsr	initializeEnemyshot

;----------------
		jsr	onScreen

;----------------
		jsr	enableIrqVdc

;----------------
		jsr	setEyeWork

;----------------
		jsr	setPolygonWork

;----------------
		jsr	setVsyncFlag

;----------------
		cli

;----------------
.mainLoop:
;----------------
		jsr	waitScreenVsync

;----------------
		jsr	initializePolygonAndSat

;----------------
;照準
		movw	<argw0, #72-8+64
		movw	<argw1, #128-16+32
		movw	<argw2, #$0050
		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
		jsr	setSatBuffer

;----------------
;コンパス
		movw	<eyeTranslationX, #0
		movw	<eyeTranslationY, #0
		movw	<eyeTranslationZ, #0
		mov	<eyeRotationX, #0
		mov	<eyeRotationY, #0
		mov	<eyeRotationZ, #0
		mov	<eyeRotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y

		lda	#0
		jsr	setPolygonColorIndex

		movw	<translationX, #0
		movw	<translationY, #0
		movw	<translationZ, #300

		mov	<rotationX, #0
		mov	<rotationY, #0
		mov	<rotationZ, #0

		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y

		;;;movw	<modelAddress, #compassModel
		movw	<modelAddress, #modelShot

		jsr	setModelRotation


;----------------
;;;		jsr	setEyeFromWork

;;;		jsr	putPolygonFromWork

;----------------
		jsr	setSatToVram

;;;<--
;;----------------
		jsr	switchClearBuffer2
;;;		jsr	switchClearBuffer

;----------------
		jsr	putPolygonBuffer

;----------------
;debug
;;;		inc	drawCountWork
;
;		ldx	#0
;		ldy	#19
;		jsr	setWriteVramAddress
;
;		lda	drawCount
;		ldx	#$00
;		jsr	putHex

		ldx	#0
		ldy	#20
		jsr	setWriteVramAddress

		lda	eyeTranslationXWork+1
		ldx	#$00
		jsr	putHex

		lda	eyeTranslationXWork
		ldx	#$00
		jsr	putHex

		lda	#$20
		ldx	#$00
		jsr	putChar

		lda	eyeTranslationYWork+1
		ldx	#$00
		jsr	putHex

		lda	eyeTranslationYWork
		ldx	#$00
		jsr	putHex

		lda	#$20
		ldx	#$00
		jsr	putChar

		lda	eyeTranslationZWork+1
		ldx	#$00
		jsr	putHex

		lda	eyeTranslationZWork
		ldx	#$00
		jsr	putHex

		lda	#$20
		ldx	#$00
		jsr	putChar

		lda	eyeRotationXWork
		ldx	#$00
		jsr	putHex

		lda	#$20
		ldx	#$00
		jsr	putChar

		lda	eyeRotationYWork
		ldx	#$00
		jsr	putHex

		lda	#$20
		ldx	#$00
		jsr	putChar

		lda	eyeRotationZWork
		ldx	#$00
		jsr	putHex

		lda	#$20
		ldx	#$00
		jsr	putChar

		lda	jumpIndex
		ldx	#$00
		jsr	putHex

		lda	#$20
		ldx	#$00
		jsr	putChar

		lda	jumpCount
		ldx	#$00
		jsr	putHex

;;;		ldx	#0
;		ldy	#21
;		jsr	setWriteVramAddress
;
;;;;		lda	polygonTableCount
;;		ldx	#$00
;;		jsr	putHex
;
;		lda	#SUB0_PRG_BANK
;		ldx	#$00
;		jsr	putHex
;
;		lda	$20
;		ldx	#$00
;		jsr	putChar
;
;		tma	#SUB0_PRG_MAP
;		ldx	#$00
;		jsr	putHex

;----------------
		jsr	setVsyncFlag

;----------------
		jmp	.mainLoop


;----------------------------
moveFromTemp:
;
		movw	<mul16a, mul16aTemp
		movw	<mul16b, mul16bTemp
		movw	<mul16c, mul16cTemp
		movw	<mul16d, mul16dTemp

		movw	<mulAddr0, mulAddr0Temp
		movw	<mulAddr1, mulAddr1Temp

		mov	<saveMpr2, saveMpr2Temp
		mov	<saveMpr3, saveMpr3Temp

		movw	<sinLowAddr, sinLowAddrTemp
		movw	<sinHighAddr, sinHighAddrTemp

		movw	<cosLowAddr, cosLowAddrTemp
		movw	<cosHighAddr, cosHighAddrTemp

		movw	<saveSin8Data, saveSin8DataTemp
		movw	<saveCos8Data, saveCos8DataTemp

		mov	<vertexCount, vertexCountTemp

		movw	transform2DWork0+VX, transform2DWork0Temp+VX
		movw	transform2DWork0+VY, transform2DWork0Temp+VY
		movw	transform2DWork0+VZ, transform2DWork0Temp+VZ

		movw	<angleX0, angleX0Temp
		movw	<angleY0, angleY0Temp
		movw	<angleZ0, angleZ0Temp

		movw	<angleX1, angleX1Temp
		movw	<angleY1, angleY1Temp
		movw	<angleZ1, angleZ1Temp

		mov	<ansAngleX, ansAngleXTemp
		mov	<ansAngleY, ansAngleYTemp

		movq	<work8a, work8aTemp
		movq	<work8a+4, work8aTemp+4
		movq	<work8b, work8bTemp
		movq	<work8b+4, work8bTemp+4

		movw	<vertexRotationSin, vertexRotationSinTemp
		movw	<vertexRotationCos, vertexRotationCosTemp

		rts


;----------------------------
moveToTemp:
;
		movw	mul16aTemp, <mul16a
		movw	mul16bTemp, <mul16b
		movw	mul16cTemp, <mul16c
		movw	mul16dTemp, <mul16d

		movw	mulAddr0Temp, <mulAddr0
		movw	mulAddr1Temp, <mulAddr1

		mov	saveMpr2Temp, <saveMpr2
		mov	saveMpr3Temp, <saveMpr3

		movw	sinLowAddrTemp, <sinLowAddr
		movw	sinHighAddrTemp, <sinHighAddr

		movw	cosLowAddrTemp, <cosLowAddr
		movw	cosHighAddrTemp, <cosHighAddr

		movw	saveSin8DataTemp, <saveSin8Data
		movw	saveCos8DataTemp, <saveCos8Data

		mov	vertexCountTemp, <vertexCount

		movw	transform2DWork0Temp+VX, transform2DWork0+VX
		movw	transform2DWork0Temp+VY, transform2DWork0+VY
		movw	transform2DWork0Temp+VZ, transform2DWork0+VZ

		movw	angleX0Temp, <angleX0
		movw	angleY0Temp, <angleY0
		movw	angleZ0Temp, <angleZ0

		movw	angleX1Temp, <angleX1
		movw	angleY1Temp, <angleY1
		movw	angleZ1Temp, <angleZ1

		mov	ansAngleXTemp, <ansAngleX
		mov	ansAngleYTemp, <ansAngleY

		movq	work8aTemp, <work8a
		movq	work8aTemp+4, <work8a+4
		movq	work8bTemp, <work8b
		movq	work8bTemp+4, <work8b+4

		movw	vertexRotationSinTemp, <vertexRotationSin
		movw	vertexRotationCosTemp, <vertexRotationCos

		rts


;----------------------------
putPolygonFromWork:
;フレームスキップ用 polygon 出力
		movw	<polygonTableAddr, #polygonTable
		clx
.polygonLoop0:
		cpx	polygonTableCount
		jeq	.jpEnd

;----------------
;OBJだったらスプライトでENY表示
;;;<--		TO_A_FROM_ADDR_Y	polygonTableAddr, POLYGON_MODEL_TYPE
;		cmp	#MODEL_TYPE_OBJ
;		jne	.WorldCheck
;
;
;
;


;----------------
.WorldCheck:
;SHIP_WORLD_SIZE_X SHIP_WORLD_SIZE_Z 範囲か？

		TO_MEM_SUB_ADDR_Y_FROM_MEM_W	shipWorldX0, polygonTableAddr, POLYGON_X, <eyeTranslationX
		TO_MEM_SUB_ADDR_Y_FROM_MEM_W	shipWorldZ0, polygonTableAddr, POLYGON_Z, <eyeTranslationZ

;OBJだったらENY表示のため WorldCheck をスキップ
		TO_A_FROM_ADDR_Y	polygonTableAddr, POLYGON_MODEL_TYPE
		cmp	#MODEL_TYPE_OBJ
		beq	.eyeJp00

;eyeTranslationX eyeTranslationZ から判断
;-WorldX <= X < WorldX
;;;<--		TO_MEM_SUB_ADDR_Y_FROM_MEM_W	shipWorldX0, polygonTableAddr, POLYGON_X, <eyeTranslationX

;-WorldX <= X
		cmpw	shipWorldX0, #-SHIP_WORLD_SIZE_X
		jmi	.jpSkip

;X < WorldX
		cmpw	shipWorldX0, #SHIP_WORLD_SIZE_X
		jpl	.jpSkip

;-WorldZ <= Z < WorldZ
;;;<--		TO_MEM_SUB_ADDR_Y_FROM_MEM_W	shipWorldZ0, polygonTableAddr, POLYGON_Z, <eyeTranslationZ

;-WorldZ <= Z
		cmpw	shipWorldZ0, #-SHIP_WORLD_SIZE_Z
		jmi	.jpSkip

;Z < WorldZ
		cmpw	shipWorldZ0, #SHIP_WORLD_SIZE_Z
		jpl	.jpSkip

;----------------
.eyeJp00:
;eye での回転
		movw	transform2DWork0+VX, shipWorldX0

		TO_MEM_SUB_ADDR_Y_FROM_MEM_W	transform2DWork0+VY, polygonTableAddr, POLYGON_Y, <eyeTranslationY

		movw	transform2DWork0+VZ, shipWorldZ0

		mov	<vertexCount, #1

		phx
		ldx	eyeRotationYWork
		jsr	vertexRotationY8
		plx

;eye での回転後、z が 前か後ろか？
		lda	transform2DWork0+VZ+1
		jmi	.jpBack

		jsr	transform2D

;OBJだったらスプライトでENY表示
		TO_A_FROM_ADDR_Y	polygonTableAddr, POLYGON_MODEL_TYPE
		cmp	#MODEL_TYPE_OBJ
		jne	.penetrateJp00

;Transform2D で変換出来なかった 0 <= VZ < 128
		lda	transform2DWork0+VZ+1
		jmi	.recheckJp00

;スクリーン領域内かチェック
		lda	transform2DWork0+VZ+1
		jmi	.recheckJp00

		cmpw	transform2DWork0+VX, #-16
		;;;<--bmi	.recheckJp00
		jmi	.recheckJp00

		cmpw	transform2DWork0+VX, #16+256
		;;;<--bpl	.recheckJp00
		jpl	.recheckJp00

		;;;<--cmpw	transform2DWork0+VY, #-16
		cmpw	transform2DWork0+VY, #0
		;;;<--bmi	.recheckJp00
		bpl	.spJp03
		movw	transform2DWork0+VY, #0
		bra	.spJp02

.spJp03:
		;;;<--cmpw	transform2DWork0+VY, #16+144
		cmpw	transform2DWork0+VY, #144
		;;;<--bpl	.recheckJp00
		bmi	.spJp02
		movw	transform2DWork0+VY, #144

;スプライトセット
.spJp02:
		phx

		clx

		cmpw	transform2DWork0+VY, #32
		bpl	.spJp00

		txa
		ora	#$01
		tax

.spJp00:
		cmpw	transform2DWork0+VX, #256-32
		bmi	.spJp01

		txa
		ora	#$02
		tax

.spJp01:
		clc
		lda	transform2DWork0+VY
		adc	.spY, x
		sta	<argw0
		lda	transform2DWork0+VY+1
		adc	#0
		sta	<argw0+1

		clc
		lda	transform2DWork0+VX
		adc	.spX, x
		sta	<argw1
		lda	transform2DWork0+VX+1
		adc	#0
		sta	<argw1+1

		lda	.spNo, x
		sta	<argw2
		stz	<argw2+1

		;;;movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_1 + SP_ATTR_FOREGROUND + 0	;0 palette no
		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
		jsr	setSatBufferAutoNo

		plx

.recheckJp00:
;;;<--;OBJだったらENY表示のため Z < WorldZ をスキップしたのをここで
;;Z < WorldZ
;		cmpw	shipWorldZ0, #SHIP_WORLD_SIZE_Z
;		jpl	.jpSkip

;OBJだったらENY表示のため WorldCheck をスキップしたのをここで
;-WorldX <= X < WorldX
;-WorldX <= X
		cmpw	shipWorldX0, #-SHIP_WORLD_SIZE_X
		jmi	.jpSkip

;X < WorldX
		cmpw	shipWorldX0, #SHIP_WORLD_SIZE_X
		jpl	.jpSkip

;-WorldZ <= Z < WorldZ
;-WorldZ <= Z
		cmpw	shipWorldZ0, #-SHIP_WORLD_SIZE_Z
		jmi	.jpSkip

;Z < WorldZ
		cmpw	shipWorldZ0, #SHIP_WORLD_SIZE_Z
		jpl	.jpSkip

.penetrateJp00:
;貫通しているか？（transform2D で変換出来なかった 0 <= VZ < 128）
		lda	transform2DWork0+VZ+1
		bmi	.jpSet

.centerJp00:
;中心より x が1024より大きい obj は消える
;-1024 < X <=1024
		cmpw	transform2DWork0+VX, #-POLYGON_DRAW_XYZ_MAX + SCREEN_CENTER_X
		jmi	.jpSkip

		cmpw	transform2DWork0+VX, #POLYGON_DRAW_XYZ_MAX + SCREEN_CENTER_X
		bpl	.jpSkip

;中心より y が1024より大きい obj は消える
;-1024 < Y <=1024
		cmpw	transform2DWork0+VY, #-POLYGON_DRAW_XYZ_MAX + SCREEN_CENTER_Y
		bmi	.jpSkip

		cmpw	transform2DWork0+VY, #POLYGON_DRAW_XYZ_MAX + SCREEN_CENTER_Y
		bpl	.jpSkip
		bra	.jpSet

.jpBack:
;eye での回転後、z が -1024 より小さいのは捨てる
;中心より z が1024より大きい obj は貫通していても消える
		cmpw	transform2DWork0+VZ, #-POLYGON_DRAW_XYZ_MAX
		bmi	.jpSkip

.jpSet:
		TO_MEM_FROM_ADDR_Y_W	<translationX, polygonTableAddr, POLYGON_X
		TO_MEM_FROM_ADDR_Y_W	<translationY, polygonTableAddr, POLYGON_Y
		TO_MEM_FROM_ADDR_Y_W	<translationZ, polygonTableAddr, POLYGON_Z

		TO_MEM_FROM_ADDR_Y	<rotationX, polygonTableAddr, POLYGON_RX
		TO_MEM_FROM_ADDR_Y	<rotationY, polygonTableAddr, POLYGON_RY
		TO_MEM_FROM_ADDR_Y	<rotationZ, polygonTableAddr, POLYGON_RZ

		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y

		TO_A_FROM_ADDR_Y	polygonTableAddr, POLYGON_COLOR
		jsr	setPolygonColorIndex

		TO_MEM_FROM_ADDR_Y_W	<modelAddress, polygonTableAddr, POLYGON_MODEL
		jsr	setModelRotation

.jpSkip:
		addw	<polygonTableAddr, #POLYGON_STRUCT_SIZE

		inx
		jmp	.polygonLoop0

.jpEnd:
		rts


;;;<--.spX		.db	   32, 32-16, 32-16,  32
;;;<--.spY		.db	64-16,    64, 64-16,  64
;;;<--.spNo		.db	  $5A,   $54,   $56, $58
;;;.spNo		.db	  $7C,   $58,   $5C, $78

.spX		.db	   32,    32, 32-32, 32-32
.spY		.db	64-16,    64, 64-16,    64
.spNo		.db	  $7C,   $78,   $5C,   $58


;----------------------------
setEyeFromWork:
;フレームスキップ用 eye 設定
		movw	<eyeTranslationX, eyeTranslationXWork
		movw	<eyeTranslationY, eyeTranslationYWork
		movw	<eyeTranslationZ, eyeTranslationZWork
		mov	<eyeRotationX, eyeRotationXWork
		mov	<eyeRotationY, eyeRotationYWork
		mov	<eyeRotationZ, eyeRotationZWork
		mov	<eyeRotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y

		rts


;----------------------------
clearPolygonWork:
;フレームスキップ用 polygon ワーククリア
		movw	<polygonTableAddr, #polygonTable
		stz	polygonTableCount
		rts


;----------------------------
setPolygonWork:
;フレームスキップ用 polygon ワーク設定
		jsr	clearPolygonWork

;--------
;block
		clx

.setBlockModelLoop0:
		cpx	blockCount
		jeq	.setBlockModelEnd

;entity か？
		TO_A_FROM_TABLE	block_STATUS
		and	#OBJ_ENTITY
		jeq	.setBlockModelJp010

		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_X, block_X
		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_Y, block_Y
		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_Z, block_Z

		TO_ADDR_Y	polygonTableAddr, POLYGON_RX, #0
		TO_ADDR_Y	polygonTableAddr, POLYGON_RY, #0
		TO_ADDR_Y	polygonTableAddr, POLYGON_RZ, #0

		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_MODEL, block_MODEL

		TO_ADDR_Y	polygonTableAddr, POLYGON_COLOR, #0

		TO_A_FROM_TABLE	block_STATUS
		and	#OBJ_RADAR
		bne	.setBlockModelJp008

		TO_ADDR_Y	polygonTableAddr, POLYGON_MODEL_TYPE, #MODEL_TYPE_BLOCK
		bra	.setBlockModelJp009

.setBlockModelJp008:
		TO_ADDR_Y	polygonTableAddr, POLYGON_MODEL_TYPE, #MODEL_TYPE_BLOCK_RADAR

.setBlockModelJp009:
		addw	<polygonTableAddr, #POLYGON_STRUCT_SIZE
		inc	polygonTableCount

.setBlockModelJp010:
		inx
		jmp	.setBlockModelLoop0

.setBlockModelEnd:


;--------
;obj
		clx

.setObjModelLoop0:
		;;;<--cpx	objCount
		cpx	#OBJ_TABLE_COUNT_MAX
		jeq	.setObjModelEnd

		TO_A_FROM_TABLE	obj_STATUS
		jeq	.setObjModelJp010

		and	#OBJ_ENTITY
		jeq	.setObjModelJp010

		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_FLASH
		beq	.setObjModelJp000

		lda	#OBJ_FLASH_COLOR_INDEX

.setObjModelJp000:
		TO_ADDR_Y_FROM_A	polygonTableAddr, POLYGON_COLOR

		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_X, obj_X
		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_Y, obj_Y
		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_Z, obj_Z

		TO_ADDR_Y_FROM_TABLE polygonTableAddr, POLYGON_RX, obj_RX
		TO_ADDR_Y_FROM_TABLE polygonTableAddr, POLYGON_RY, obj_RY
		TO_ADDR_Y_FROM_TABLE polygonTableAddr, POLYGON_RZ, obj_RZ

		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_MODEL, obj_MODEL

		TO_A_FROM_TABLE	obj_NO
		cmp	#8
		bne	.setObjModelJp008

		TO_ADDR_Y	polygonTableAddr, POLYGON_MODEL_TYPE, #MODEL_TYPE_EXOBJ
		bra	.setObjModelJp009

.setObjModelJp008:
		TO_ADDR_Y	polygonTableAddr, POLYGON_MODEL_TYPE, #MODEL_TYPE_OBJ

.setObjModelJp009:
		addw	<polygonTableAddr, #POLYGON_STRUCT_SIZE
		inc	polygonTableCount

.setObjModelJp010:
		inx
		jmp	.setObjModelLoop0

.setObjModelEnd:

;----------------
;shot
		clx

.setShotModelLoop0:
		;;;<--cpx	shotCount
		cpx	#SHOT_TABLE_COUNT_MAX
		beq	.setShotModelEnd

		TO_A_FROM_TABLE	shot_STATUS
		beq	.setShotModelJp00

		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_X, shot_X
		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_Y, shot_Y
		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_Z, shot_Z

		TO_ADDR_Y_FROM_TABLE polygonTableAddr, POLYGON_RX, shot_RX
		TO_ADDR_Y_FROM_TABLE polygonTableAddr, POLYGON_RY, shot_RY
		TO_ADDR_Y_FROM_TABLE polygonTableAddr, POLYGON_RZ, shot_RZ

		TO_ADDR_Y_W polygonTableAddr, POLYGON_MODEL, #modelShot

		TO_ADDR_Y polygonTableAddr, POLYGON_COLOR, #0

		TO_ADDR_Y	polygonTableAddr, POLYGON_MODEL_TYPE, #MODEL_TYPE_SHOT

		addw	<polygonTableAddr, #POLYGON_STRUCT_SIZE
		inc	polygonTableCount

.setShotModelJp00:
		inx
		bra	.setShotModelLoop0

.setShotModelEnd:

;----------------
;enemy shot
		clx

.setEnemyshotModelLoop0:
		;;;<--cpx	enemyshotCount
		cpx	#ENEMYSHOT_TABLE_COUNT_MAX
		beq	.setEnemyshotModelEnd

		TO_A_FROM_TABLE	enemyshot_STATUS
		beq	.setEnemyshotModelJp00

		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_X, enemyshot_X
		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_Y, enemyshot_Y
		TO_ADDR_Y_FROM_TABLE_W polygonTableAddr, POLYGON_Z, enemyshot_Z

		TO_ADDR_Y polygonTableAddr, POLYGON_RX, #0
		TO_ADDR_Y polygonTableAddr, POLYGON_RY, #0
		TO_ADDR_Y polygonTableAddr, POLYGON_RZ, #0

		TO_ADDR_Y_W polygonTableAddr, POLYGON_MODEL, #modelEnemyShot

		TO_ADDR_Y polygonTableAddr, POLYGON_COLOR, #0

		TO_ADDR_Y	polygonTableAddr, POLYGON_MODEL_TYPE, #MODEL_TYPE_ENEMY_SHOT

		addw	<polygonTableAddr, #POLYGON_STRUCT_SIZE
		inc	polygonTableCount

.setEnemyshotModelJp00:
		inx
		bra	.setEnemyshotModelLoop0

.setEnemyshotModelEnd:
		rts


;----------------------------
setGroundY:
;set groundY
		lda	shipY+1
		asl	groundY
		rol	a
		clc
		adc	#72
		cmp	#144
		bcc	.jpGround00
		lda	#143
.jpGround00:
		sta	groundY

		rts


;----------------------------
setEyeWork:
;フレームスキップ用 eye ワーク設定
		movw	eyeTranslationXWork, shipX
		movw	eyeTranslationYWork, shipY
		movw	eyeTranslationZWork, shipZ
		mov	eyeRotationXWork, #0

;damage scroll
		clc
		lda	damageTimer
		and	#$10
		asl	a
		adc	eyeTranslationYWork
		sta	eyeTranslationYWork
		lda	#0
		adc	eyeTranslationYWork+1
		sta	eyeTranslationYWork+1

		lda	shipRY
		eor	#$FF
		inc	a
		sta	eyeRotationYWork

		mov	eyeRotationZWork, #0

		rts


;----------------------------
moveObj:
;obj の移動
		cly

.loop0:
		;;;<--cpy	objCount
		cpy	#OBJ_TABLE_COUNT_MAX
		beq	.jpEnd

		tya
		tax

		TO_A_FROM_TABLE	obj_STATUS
		beq	.enemyMoveEnd

		TO_A_FROM_TABLE	obj_NO
		asl	a
		tax
		jmp	[.moveObjJumpTable, x]
.obj0:
		tya
		tax

		jsr	moveObj0
		jmp	.enemyMoveEnd

.obj1:
		tya
		tax

		jsr	moveObj1
		jmp	.enemyMoveEnd

.obj2:
		tya
		tax

		jsr	moveObj2
		jmp	.enemyMoveEnd

.obj3:
		tya
		tax

		jsr	moveObj3
		jmp	.enemyMoveEnd

.obj4:
		tya
		tax

		jsr	moveObj4
		jmp	.enemyMoveEnd

.obj5:
		tya
		tax

		jmp	.enemyMoveEnd

.obj6:
		tya
		tax

		jmp	.enemyMoveEnd

.obj7:
		tya
		tax

		jmp	.enemyMoveEnd

.obj8:
		tya
		tax

		jsr	moveObj8
		jmp	.enemyMoveEnd

.enemyMoveEnd:
		iny
		bra	.loop0

.jpEnd:
		rts

.moveObjJumpTable
		.dw	.obj0, .obj1, .obj2, .obj3, .obj4, .obj5, .obj6, .obj7, .obj8


;----------------
moveShot:
;move shot
		clx

.moveLoop:
		;;;<--cpx	shotCount
		cpx	#SHOT_TABLE_COUNT_MAX
		jeq	.moveEnd

		TO_A_FROM_TABLE	shot_STATUS
		jeq	.moveNext

;world check
		TO_MEM_FROM_TABLE_W	hitX, shot_X
		TO_MEM_FROM_TABLE_W	hitY, shot_Y
		TO_MEM_FROM_TABLE_W	hitZ, shot_Z

		;;;<--jsr	checkShipWorld2
		jsr	checkShipWorld
		jcc	.moveUnset

.checkObj:
;obj との当たり判定
		mov	objHitNo, #$FF
		jsr	checkObjHit
		bcc	.checkBlock

		phx

		tax
		TO_A_FROM_TABLE	obj_NO
		asl	a

		phx
		tax
		jmp	[.hitObjJumpTable, x]

.obj0:
		plx
		jsr	hitObj0
		bra	.objEnd

.obj1:
		plx
		jsr	hitObj1
		bra	.objEnd

.obj2:
		plx
		jsr	hitObj2
		bra	.objEnd

.obj3:
		plx
		jsr	hitObj3
		bra	.objEnd

.obj4:
		plx
		jsr	hitObj4
		bra	.objEnd

.obj5:
		plx
		bra	.objEnd

.obj6:
		plx
		bra	.objEnd

.obj7:
		plx
		bra	.objEnd

.obj8:
		plx
		jsr	hitObj8
		bra	.objEnd

.objEnd:
		plx
		jmp	.moveUnset

.checkBlock:
;block との当たり判定
		jsr	checkBlockHit
		bcs	.blockEvent

		ADD_TABLES_Q	shot_PX, shot_X, shot_MOVE_PX, shot_MOVE_X
		ADD_TABLES_Q	shot_PY, shot_Y, shot_MOVE_PY, shot_MOVE_Y
		ADD_TABLES_Q	shot_PZ, shot_Z, shot_MOVE_PZ, shot_MOVE_Z

		bra	.moveNext

.blockEvent:

;当たったのでイベント発生
		phx
		tax
		TO_A_FROM_TABLE	block_HIT_EVENT0
		;;;lda	#$FF;;;<--
		jsr	eventProc

		TO_A_FROM_TABLE	block_HIT_EVENT1
		;;;<--lda	#$FF;;;<--
		jsr	eventProc
		plx

;;;<--
;		cmp	#$FF
;		bne	.jp0000
;		sta	debug0
;.jp0000:

.moveUnset:
		TO_TABLE	shot_STATUS, #OBJ_UNSET

.moveNext:
		inx
		jmp	.moveLoop

.moveEnd:
		rts

.hitObjJumpTable
		.dw	.obj0, .obj1, .obj2, .obj3, .obj4, .obj5, .obj6, .obj7, .obj8


;----------------
moveEnemyshot:
;move enemy shot
		clx

.moveLoop:
		;;;<--cpx	enemyshotCount
		cpx	#ENEMYSHOT_TABLE_COUNT_MAX
		jeq	.moveEnd

		TO_A_FROM_TABLE	enemyshot_STATUS
		jeq	.moveNext

;world check
		TO_MEM_FROM_TABLE_W	hitX, enemyshot_X
		TO_MEM_FROM_TABLE_W	hitY, enemyshot_Y
		TO_MEM_FROM_TABLE_W	hitZ, enemyshot_Z

		jsr	checkShipWorld2
		;;;<--jsr	checkShipWorld
		jcc	.moveUnset

;;;<--.checkBlock:
;block との当たり判定
		jsr	checkBlockHit
		jcs	.moveUnset

;ship との当たり判定
;----------
;check shipHitX0 <= hitX < shipHitX1
;jump hitX < shipHitX0
		cmpw	hitX, shipHitX0
		bmi	.moveAdd

;jump hitX >= shipHitX1
		cmpw	hitX, shipHitX1
		bpl	.moveAdd

;check shipHitY0 <= hitY < shipHitY1
;jump hitY < shipHitY0
		cmpw	hitY, shipHitY0
		bmi	.moveAdd

;jump hitY >= shipHitY1
		cmpw	hitY, shipHitY1
		bpl	.moveAdd

;check shipHitZ0 <= hitZ < shipHitZ1
;jump hitZ < shipHitZ0
		cmpw	hitZ, shipHitZ0
		bmi	.moveAdd

;jump hitZ >= shipHitZ1
		cmpw	hitZ, shipHitZ1
		bpl	.moveAdd

.shipHit:
;ship にヒット
		lda	stageClearFlag
		bne	.shipHitEnd

		lda	shipShield
		beq	.shipHitEnd

;set se
		lda	#SE_SHIP_DAMAGE
		jsr	setSe

		mov	damageTimer, #128

		;;;<--dec	a
		;sta	shipShield
		dec	shipShield
		;;;bne	.shipHitJp
		bne	.shipHitEnd

;game over
		mov	gameOverFlag, #$FF
		mov	gameOverCounter, #$FF

;;;<--		bra	.shipHitEnd
;
;.shipHitJp:
;		mov	damageTimer, #128

;;;<--
;		lda	#SE_SHIP_DAMAGE
;		jsr	setSe

.shipHitEnd:
		bra	.moveUnset

.moveAdd:
;移動量を加算
		ADD_TABLES_Q	enemyshot_PX, enemyshot_X, enemyshot_MOVE_PX, enemyshot_MOVE_X
		ADD_TABLES_Q	enemyshot_PY, enemyshot_Y, enemyshot_MOVE_PY, enemyshot_MOVE_Y
		ADD_TABLES_Q	enemyshot_PZ, enemyshot_Z, enemyshot_MOVE_PZ, enemyshot_MOVE_Z

		bra	.moveNext

.moveUnset:
		TO_TABLE	enemyshot_STATUS, #OBJ_UNSET

.moveNext:
		inx
		jmp	.moveLoop

.moveEnd:
		rts


;----------------------------
checkShipWorld:
;obj の位置が ship の world の範囲にあるか、あれば carry
;対象は x と z で y は対象外
;-WorldX <= X < WorldX
		sec
		lda	hitX
		sbc	shipX
		sta	hitWorldX0

		lda	hitX+1
		sbc	shipX+1
		sta	hitWorldX0+1

;-WorldX <= X
		cmpw	hitWorldX0, #-SHIP_WORLD_SIZE_X
		bmi	.checkShipWorldEnd

;X < WorldX
		cmpw	hitWorldX0, #SHIP_WORLD_SIZE_X
		bpl	.checkShipWorldEnd

;-WorldZ <= Z < WorldZ
		sec
		lda	hitZ
		sbc	shipZ
		sta	hitWorldZ0

		lda	hitZ+1
		sbc	shipZ+1
		sta	hitWorldZ0+1

;-WorldZ <= Z
		cmpw	hitWorldZ0, #-SHIP_WORLD_SIZE_Z
		bmi	.checkShipWorldEnd

;Z < WorldZ
		cmpw	hitWorldZ0, #SHIP_WORLD_SIZE_Z
		bpl	.checkShipWorldEnd

		sec
		rts

.checkShipWorldEnd:
		clc
		rts


;----------------------------
checkShipWorld2:
;obj の位置が ship の world の範囲にあるか、あれば carry
;対象は x と y と z
		jsr	checkShipWorld
		bcc	.checkShipWorldEnd

;0<= Y < WorldY
		sec
		lda	hitY
		sbc	#LOW(SHIP_WORLD_SIZE_Y)

		lda	hitY+1
		bmi	.checkShipWorldEnd
		sbc	#HIGH(SHIP_WORLD_SIZE_Y)
		bpl	.checkShipWorldEnd

		sec
		rts

.checkShipWorldEnd:
		clc
		rts


;----------------------------
clearObjHitFlag:
;obj の hit フラグを削除
		clx

.loop0:
		;;;<--cpx	objCount
		cpx	#OBJ_TABLE_COUNT_MAX
		beq	.jpEnd

		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_UNFLASH
		TO_TABLE_FROM_A	obj_MOVE_STATUS

		inx
		bra	.loop0

.jpEnd:
		rts







;----------------------------
_checkObjHit:
;X で チェックする obj を指定
;;;<--		phx
;		phy

;hit flag?
		TO_A_FROM_TABLE	obj_STATUS
		and	#OBJ_HIT
		beq	.jpUnSetCarry

;----------
;check obj_HIT_X0 <= hitX < obj_HIT_X1
		CMP_MEM_FROM_TABLE_W	hitX, obj_HIT_X0

;jump hitX < obj_HIT_X0
		bmi	.jpUnSetCarry

		CMP_MEM_FROM_TABLE_W	hitX, obj_HIT_X1

;jump hitX >= obj_HIT_X1
		bpl	.jpUnSetCarry

;----------
;check obj_HIT_Y0 <= hitY < obj_HIT_Y1
		CMP_MEM_FROM_TABLE_W	hitY, obj_HIT_Y0

;jump hitY < obj_HIT_Y0
		bmi	.jpUnSetCarry

		CMP_MEM_FROM_TABLE_W	hitY, obj_HIT_Y1

;jump hitY >= obj_HIT_Y1
		bpl	.jpUnSetCarry

;----------
;check obj_HIT_Z0 <= hitZ < obj_HIT_Z1
		CMP_MEM_FROM_TABLE_W	hitZ, obj_HIT_Z0

;jump hitZ < obj_HIT_Z0
		bmi	.jpUnSetCarry

		CMP_MEM_FROM_TABLE_W	hitZ, obj_HIT_Z1

;jump hitZ >= obj_HIT_Z1
		bpl	.jpUnSetCarry

;obj hit set carry
		sec
		bra	.jpEnd

.jpUnSetCarry:
		clc

.jpEnd:
;;;<--		ply
;		plx
		rts


;----------------------------
checkObjHit:
;objHitNo でチェックしない obj を指定（同じ OBJ 同士で比較しない為）
;ヒットしない場合 caryy を clear
;ヒットした場合 caryy を set
;ヒットした obj を A で返す
		phx
;;;<--		phy

		clx

.loop0:
		;;;<--cpx	objCount
		cpx	#OBJ_TABLE_COUNT_MAX
		beq	.jpUnSetCarry

;objHitNo = X ?
		cpx	objHitNo
		beq	.jpNext

		jsr	_checkObjHit
		bcs	.jpEnd

.jpNext:
		inx
		bra	.loop0

.jpUnSetCarry:
		clc

.jpEnd:
		txa

;;;<--		ply
		plx
		rts


;----------------------------
checkBlockHit:
;ヒットしない場合 caryy を clear
;ヒットした場合 caryy を set
;ヒットした block を A で返す
		phx
		phy

		clx

.loop0:
		cpx	blockCount
		beq	.jpUnSetCarry

;hit flag?
		TO_A_FROM_TABLE	block_STATUS
		and	#OBJ_HIT
		beq	.jpNext

;----------
;check block_HIT_X0 <= hitX < block_HIT_X1
		CMP_MEM_FROM_TABLE_W	hitX, block_HIT_X0

;jump hitX < block_HIT_X0
		bmi	.jpNext

		CMP_MEM_FROM_TABLE_W	hitX, block_HIT_X1

;jump hitX >= block_HIT_X1
		bpl	.jpNext

;----------
;check block_HIT_Y0 <= hitY < block_HIT_Y1
		CMP_MEM_FROM_TABLE_W	hitY, block_HIT_Y0

;jump hitY < block_HIT_Y0
		bmi	.jpNext

		CMP_MEM_FROM_TABLE_W	hitY, block_HIT_Y1

;jump hitY >= block_HIT_Y1
		bpl	.jpNext

;----------
;check block_HIT_Z0 <= hitZ < block_HIT_Z1
		CMP_MEM_FROM_TABLE_W	hitZ, block_HIT_Z0

;jump hitZ < block_HIT_Z0
		bmi	.jpNext

		CMP_MEM_FROM_TABLE_W	hitZ, block_HIT_Z1

;jump hitZ >= block_HIT_Z1
		bpl	.jpNext

;block hit set carry

;;;<--
;		cpx	#$FF
;		bne	.jp0001
;		sta	debug0
;.jp0001:

		sec
		bra	.jpEnd

.jpNext:
		inx
		bra	.loop0

.jpUnSetCarry:

;;;<--
;		cpx	#$FF
;		bne	.jp0000
;		sta	debug0
;.jp0000:

		clc

.jpEnd:
		txa

		ply
		plx
		rts


;----------------------------
moveShip:
;ship の移動
		movw	moveShipWorkZ, #0

		stz	moveShipWorkRY

;check damageTimer
		lda	damageTimer
		beq	.jumpJp

		dec	a
		dec	a
		sta	damageTimer

.jumpJp:

;game over?
		lda	gameOverFlag
		beq	.skipOver
		rts

.skipOver:


;P0Button1
;jump
		bbr0	<padState, .jpShot

;jump ?
		lda	jumpIndex
		bmi	.jpJump00

		cmp	#JUMP_SECOND_INDEX
		bmi	.jpShot

		lda	jumpCount
		;;;cmp	#JUMP_MAX_COUNT
		cmp	jumpMaxCount;;;<--2026-09-15
		bpl	.jpShot

		inc	jumpCount

.jpJump00:
		stz	jumpIndex


;se jump
		lda	#SE_JUMP
		jsr	setSe


.jpShot:
;P0Button0
;shot
		bbr1	<padNow, .jpP0

		jsr	setShot

		lda	<padNow
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		beq	.jpP0End

		tax
		lda	.padMoveData, x

		sta	moveShipWorkRY
		movw	moveShipWorkZ, #16384

		bra	.jpP0End


;================================
;P0Left

.jpP0:
		lda	<padNow
		and	#$F0
		beq	.jpP0End


.jpP0L:
		bbr7	<padNow, .jpP0D

		clc
		lda	shipRY
		adc	#2

;down?
		bbr6	<padNow, .jpP0L0
		clc
		adc	#2

.jpP0L0:
		sta	shipRY


;P0Down
.jpP0D:
		bbr6	<padNow, .jpP0R
		movw	moveShipWorkZ, #16384
		mov	moveShipWorkRY, #128

;P0Right
.jpP0R:
		bbr5	<padNow, .jpP0U

		sec
		lda	shipRY
		sbc	#2

;down?
		bbr6	<padNow, .jpP0R0
		sec
		sbc	#2

.jpP0R0:
		sta	shipRY

;P0Up
.jpP0U:
		bbr4	<padNow, .jpP0r
		movw	moveShipWorkZ, #16384

;P0Run
.jpP0r:
		bbr3	<padNow, .jpP0S
;;;		lda	pauseFlag
;		eor	#$FF
;		sta	pauseFlag

;P0Select
.jpP0S:
		bbr2	<padNow, .jpP02

;P0Button2
.jpP02:
		bbr1	<padNow, .jpP01

;P0Button1
.jpP01:
		bbr0	<padNow, .jpP0End

.jpP0End:
;================================

		lda	moveShipWorkZ
		ora	moveShipWorkZ+1
		jeq	.jpHitEnd

;Y軸回転しかしない前提
		clc
		lda	shipRY
		adc	moveShipWorkRY
		tax

		jsr	vertexRotationY8_Z16384

		movw	<mul16a, transform2DWork0 + VX
;shiftで 16*4倍
		jsr	mul64
		movq	shipMoveX, <mul16c

		movw	<mul16a, transform2DWork0 + VY
;shiftで 16*4倍
		jsr	mul64
		movq	shipMoveY, <mul16c

		movw	<mul16a, transform2DWork0 + VZ
;shiftで 16*4倍
		jsr	mul64
		movq	shipMoveZ, <mul16c


;現在の ship の位置データを Work へ
		movq	shipWorkX, shipPX
		movq	shipWorkY, shipPY
		movq	shipWorkZ, shipPZ

;現在の ship の位置データへ MoveX と MoveY と MoveZ  を足す
		addq	shipPX, shipWorkX, shipMoveX
		addq	shipPY, shipWorkY, shipMoveY
		addq	shipPZ, shipWorkZ, shipMoveZ

;当たり判定用
		movw	hitX, shipX
		movw	hitY, shipY
		movw	hitZ, shipZ

;block との当たり判定
		jsr	checkBlockHit
		bcs	.hitJp00

;obj との当たり判定
		mov	objHitNo, #$FF
		jsr	checkObjHit
		bcs	.hitJp00

;当たらなかったので
		jmp	.jpHitEnd

;当たったので
.hitJp00:
;現在の ship の位置データへ MoveX と MoveY を足す
		addq	shipPX, shipWorkX, shipMoveX
		addq	shipPY, shipWorkY, shipMoveY
		movq	shipPZ, shipWorkZ

;当たり判定用
		movw	hitX, shipX
		movw	hitY, shipY
		movw	hitZ, shipZ

;block との当たり判定
		jsr	checkBlockHit
		bcs	.hitJp01

;obj との当たり判定
		mov	objHitNo, #$FF
		jsr	checkObjHit
		bcs	.hitJp01

;当たらなかったので
		jmp	.jpHitEnd

;当たったので
.hitJp01:
;現在の ship の位置データへ MoveY と MoveZ を足す
		movq	shipPX, shipWorkX
		addq	shipPY, shipWorkY, shipMoveY
		addq	shipPZ, shipWorkZ, shipMoveZ

;当たり判定用
		movw	hitX, shipX
		movw	hitY, shipY
		movw	hitZ, shipZ

;block との当たり判定
		mov	objHitNo, #$FF
		jsr	checkBlockHit
		bcs	.hitJp02

;obj との当たり判定
		jsr	checkObjHit
		bcs	.hitJp02

;当たらなかったので
		bra	.jpHitEnd

;当たったので移動しない 移動データを元に戻す
.hitJp02:
		movq	shipPX, shipWorkX
		movq	shipPY, shipWorkY
		movq	shipPZ, shipWorkZ

		bra	.jpEnd

.jpHitEnd:
;当たらなかったので
;移動した位置での当たり判定データ更新
		addw	shipHitX0, shipX, #-SHIP_SIZE_X
		addw	shipHitY0, shipY, #-SHIP_SIZE_Y
		addw	shipHitZ0, shipZ, #-SHIP_SIZE_Z

		addw	shipHitX1, shipX, #SHIP_SIZE_X
		addw	shipHitY1, shipY, #SHIP_SIZE_Y
		addw	shipHitZ1, shipZ, #SHIP_SIZE_Z

.jpEnd:
		rts


.padMoveData
		.db	  0	; 0
		.db	  0	; 1                 up
		.db	192	; 2           right
		.db	224	; 3           right up
		.db	128	; 4      down
		.db	  0	; 5      down       up *
		.db	160	; 6      down right
		.db	  0	; 7      down right up *
		.db	 64	; 8 left
		.db	 32	; 9 left            up
		.db	  0	;10 left      right    *
		.db	  0	;11 left      right up *
		.db	 96	;12 left down
		.db	  0	;13 left down       up *
		.db	  0	;14 left down right    *
		.db	  0	;15 left down right up *


;----------------------------
jumpShip:
;ship のジャンプ
;jump 中か
		ldx	jumpIndex
		bpl	.jpJump03

;地面より上か
		sec
		lda	shipY
		sbc	#72 + 1
		lda	shipY+1
		sbc	#00

		jmi	.jpJumpEnd

;落下中設定
		ldx	#JUMP_DOWN_INDEX+4
		stx	jumpIndex

.jpJump03:
;現在の ship の位置データを Work へ
		movw	shipWorkY, shipY

;位置データ 加算
		clc
		lda	shipY
		adc	.jumpDataUp, x
		sta	shipY
		lda	shipY+1
		adc	.jumpDataUp +1, x
		sta	shipY+1

;当たり判定用
		movw	hitX, shipX
		movw	hitY, shipY
		movw	hitZ, shipZ

;Blcok との当たり判定
		jsr	checkBlockHit

;;;<--
;;;		bcs	.jpJump04
		bcc	.jpCheckObj
;乗ったのでイベント発生
		tax
		TO_A_FROM_TABLE	block_ON_EVENT0
		jsr	eventProc

		TO_A_FROM_TABLE	block_ON_EVENT1
		jsr	eventProc

		bra	.jpJump04
.jpCheckObj:


;obj との当たり判定
		mov	objHitNo, #$FF
		mov	jumpObjNo, #$FF	;;;<--2026-06-15
		jsr	checkObjHit
		bcc	.jpJump02

		phx	;;;<--2026-06-15
		tax
		TO_A_FROM_TABLE	obj_NO
		sta	jumpObjNo
		plx

		;;;<--- 4番のOBJ赤敵に乗ったか？
		cmp	#4
		bne	.jpJump04

		lda	#SE_ON_ENEMY
		jsr	setSe

		stz	jumpIndex	;;;<--2026-06-15
		stz	jumpCount
		mov	jumpMaxCount, #JUMP_MAX_COUNT+1
		bra	.jpJumpEnd




.jpJump04:
;当たった高さが元の高さと上か下か？
		cmpw	shipWorkY, shipY
		bmi	.jpJump05

;下なら着地なので jumpCount を 0 にする
		stz	jumpCount

		mov	jumpMaxCount, #JUMP_MAX_COUNT	;;;<--2026-06-15

.jpJump05:

;当たったので jump 終了 元の位置データへ戻す
		movw	shipY, shipWorkY
		lda	#JUMP_INIT_DATA


		;stz	jumpIndex	;;;<--2026-06-15
		;stz	jumpCount
		;movw	jumpMaxCount, #JUMP_MAX_COUNT+1

		;phx
		;ldx	jumpObjNo
		;TO_A_FROM_TABLE	obj_NO
		;stx	debug0
		;plx
		;;;lda	#$88
		;sta	jumpObjNo
		;sta	debug0


;;;;上昇中？
;		cpx	#32
;		bcc	.jpJump01

;;;		stz	jumpCount
		bra	.jpJump01

;地面より下になったか
.jpJump02:
		sec
		lda	shipY
		sbc	#72
		lda	shipY+1
		sbc	#00

		bpl	.jpJump00

;下になったので jump 終了
		movw	shipY, #72
		lda	#JUMP_INIT_DATA
		stz	jumpCount

		pha
		mov	jumpMaxCount, #JUMP_MAX_COUNT	;;;<--2026-06-15
		pla

		bra	.jpJump01

;jump インデックスを +2 する
.jpJump00:
		txa
		inc	a
		inc	a
		and	#JUMP_LAST_INDEX

		bne	.jpJump01

;jump インデックスが $3E より大きくなった場合 $3E にする
		lda	#JUMP_LAST_INDEX

.jpJump01:
;jump インデックス保存
		sta	jumpIndex

.jpJumpEnd:
		rts

.jumpDataUp
		.dw	 64,  62,  60,  58,  54,  52,  50,  48,\
			 46,  44,  42,  40,  38,  36,  34,  32,\
			 30,  28,  26,  24,  22,  20,  18,  16,\
			 14,  12,  10,   8,   6,   4,   0,   0
.jumpDataDown
		.dw	  0,   0,  -4,  -6,  -8, -10, -12, -14,\
			-16, -18, -20, -22, -24, -26, -28, -30,\
			-32, -34, -36, -38, -40, -42, -44, -46,\
			-48, -50, -52, -54, -58, -60, -62, -64


;----------------------------
setShot:
;ship の shot の設定
		clx

.setShotLoop:
		;;;<--cpx	shotCount
		cpx	#SHOT_TABLE_COUNT_MAX
		jeq	.setEnd

		TO_A_FROM_TABLE	shot_STATUS
		jne	.setNext

;se shot
		lda	#SE_SHOT
		jsr	setSe

		TO_TABLE	shot_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT

		TO_TABLE_Q	shot_PX, shot_X, shipPX
		TO_TABLE_Q	shot_PY, shot_Y, shipPY
		TO_TABLE_Q	shot_PZ, shot_Z, shipPZ

		TO_TABLE	shot_RX, shipRX
		TO_TABLE	shot_RY, shipRY
		TO_TABLE	shot_RZ, shipRZ

;Y軸回転しかしない前提
		phx

		ldx	shipRY
		jsr	vertexRotationY8_Z16384

		plx

		movw	<mul16a, transform2DWork0 + VX
;shiftで 256*4倍
		jsr	mul1024
		TO_TABLE_Q	shot_MOVE_PX, shot_MOVE_X, <mul16c

		movw	<mul16a, transform2DWork0 + VY
;shiftで 256*4倍
		jsr	mul1024
		TO_TABLE_Q	shot_MOVE_PY, shot_MOVE_Y, <mul16c

		movw	<mul16a, transform2DWork0 + VZ
;shiftで 256*4倍
		jsr	mul1024
		TO_TABLE_Q	shot_MOVE_PZ, shot_MOVE_Z, <mul16c

		bra	.setEnd

.setNext:
		inx
		jmp	.setShotLoop

.setEnd:
		rts


;----------------------------
setEnemyshot:
;ship の shot の設定
		phx

		lda	stageClearFlag
;;;		jne	.setEnd
;
;		lda	gameOverFlag
		ora	gameOverFlag
		jne	.setEnd

		clx
.setShotLoop:
		;;;<--cpx	enemyshotCount
		cpx	#ENEMYSHOT_TABLE_COUNT_MAX
		jeq	.setEnd

		TO_A_FROM_TABLE	enemyshot_STATUS
		jne	.setNext

		TO_TABLE	enemyshot_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT

		TO_TABLE_Q	enemyshot_PX, enemyshot_X, enemyPX
		TO_TABLE_Q	enemyshot_PY, enemyshot_Y, enemyPY
		TO_TABLE_Q	enemyshot_PZ, enemyshot_Z, enemyPZ

		movw	<angleX1, shipX
		movw	<angleY1, shipY
		movw	<angleZ1, shipZ

		movw	<angleX0, enemyX
		movw	<angleY0, enemyY
		movw	<angleZ0, enemyZ

		jsr	getAngle

		movw	transform2DWork0 + VX, #$0000
		movw	transform2DWork0 + VY, #$0000
		movw	transform2DWork0 + VZ, #16384

		phx

		ldx	<ansAngleX
		jsr	vertexRotationX8_Z16384

		mov	<vertexCount, #1
		ldx	<ansAngleY
		jsr	vertexRotationY8

		plx

		movw	<mul16a, transform2DWork0 + VX
;shiftで 64*4倍
		jsr	mul256
		TO_TABLE_Q	enemyshot_MOVE_PX, enemyshot_MOVE_X, <mul16c

		movw	<mul16a, transform2DWork0 + VY
;shiftで 64*4倍
		jsr	mul256
		TO_TABLE_Q	enemyshot_MOVE_PY, enemyshot_MOVE_Y, <mul16c

		movw	<mul16a, transform2DWork0 + VZ
;shiftで 64*4倍
		jsr	mul256
		TO_TABLE_Q	enemyshot_MOVE_PZ, enemyshot_MOVE_Z, <mul16c

		bra	.setEnd

.setNext:
		inx
		jmp	.setShotLoop

.setEnd:
		plx
		rts


;----------------------------
setGameObj:
;enemy をセットする
;set obj
		lda	stageClearFlag
		jne	.setObjEnd

		ldx	subBaseCount
		lda	enemyCount
		;;;cmp	enemyCountMax
		;;;jeq	.setObjEnd
		cmp	enemyCountMaxTable, x
		jpl	.setObjEnd

		lda	setObjTimer
		inc	a
		sta	setObjTimer
		;;;<--cmp	#128
		cmp	setEnemyWait
		jne	.setObjEnd
		stz	setObjTimer

		lda	setObjSwitch
		inc	a
		and	#3
		sta	setObjSwitch

		bne	.setObjJp01
;0
		movw	setObjX, #-1000
		movw	setObjY, #0+100+1000
		movw	setObjZ, #-1000

		bra	.setObjSet

.setObjJp01:
;1
		cmp	#1
		bne	.setObjJp02

		movw	setObjX, #1000
		movw	setObjY, #0+100+1000
		movw	setObjZ, #-1000

		bra	.setObjSet

.setObjJp02:
;2
		cmp	#2
		bne	.setObjJp03

		movw	setObjX, #1000
		movw	setObjY, #0+100+1000
		movw	setObjZ, #1000

		bra	.setObjSet

.setObjJp03:
;3
		movw	setObjX, #-1000
		movw	setObjY, #0+100+1000
		movw	setObjZ, #1000

.setObjSet:
		movw	<angleX1, shipX
		movw	<angleY1, shipY
		movw	<angleZ1, shipZ

		movw	<angleX0, setObjX
		movw	<angleY0, setObjY
		movw	<angleZ0, setObjZ

		jsr	getAngle

		mov	setObjRX, #0
		mov	setObjRY, <ansAngleY
		mov	setObjRZ, #0

		;;;<--mov	setObjShotTimerMax, #$40
		mov	setObjShotTimerMax, setEnemyShotWait
		;;;<--mov	setObjHp, #32
		mov	setObjHp, setEnemyHP

		mov	setObjStatus, #OBJ_ACTIVE+OBJ_ENTITY
		mov	setObjMoveStatus, #OBJ_START_WAIT


		mov	setObjDestroyEvent0, $FF
		mov	setObjDestroyEvent1, $FF

;enemy出現タイプ
		lda	setEnemyType
		beq	.setObjJp04

		jsr	getRandom

		and	#$01
		beq	.setObjJp04

		mov	setObjNo, #ENEMY4_NO
		movw	setObjModel, #modelEnemy4_5
		mov	setObjHp, #1
		bra	.setObjJp05

.setObjJp04:
		mov	setObjNo, #ENEMY3_NO
		movw	setObjModel, #modelEnemy3_5

.setObjJp05:

		jsr	setObj2

		bcc	.setObjEnd

		inc	enemyCount

.setObjEnd:
		rts


;----------------------------
setStageObjs:
;objのイニシャライズ
		phx
		phy

		;;;<--mov	objCount, #OBJ_TABLE_COUNT_MAX

		clx
.clearLoop:
		;;;<--cpx	objCount
		cpx	#OBJ_TABLE_COUNT_MAX
		beq	.clearEnd

		TO_TABLE	obj_STATUS, #OBJ_UNSET

		inx
		bra	.clearLoop

.clearEnd:


		;;;<--jmp	.initEnd

;set obj
		;;;<--movw	<stageAddr, #stage1Obj
		lda	[stageAddr]
		tax
		incw	<stageAddr

.objInitLoop:
		cpx	#0
		jeq	.initEnd
		dex

		TO_MEM_FROM_ADDR_Y	setObjNo, stageAddr, STAGE_OBJ_NO

		TO_MEM_FROM_ADDR_Y_W	setObjX, stageAddr, STAGE_OBJ_X
		TO_MEM_FROM_ADDR_Y_W	setObjY, stageAddr, STAGE_OBJ_Y
		TO_MEM_FROM_ADDR_Y_W	setObjZ, stageAddr, STAGE_OBJ_Z

		TO_MEM_FROM_ADDR_Y	setObjRX, stageAddr, STAGE_OBJ_RX
		TO_MEM_FROM_ADDR_Y	setObjRY, stageAddr, STAGE_OBJ_RY
		TO_MEM_FROM_ADDR_Y	setObjRZ, stageAddr, STAGE_OBJ_RZ

		TO_MEM_FROM_ADDR_Y	setObjShotTimerMax, stageAddr, STAGE_OBJ_SHOT_TIMER
		TO_MEM_FROM_ADDR_Y	setObjHp, stageAddr, STAGE_OBJ_HP
		TO_MEM_FROM_ADDR_Y	setObjStatus, stageAddr, STAGE_OBJ_STATUS
		TO_MEM_FROM_ADDR_Y	setObjMoveStatus, stageAddr, STAGE_OBJ_MOVE_STATUS

		TO_MEM_FROM_ADDR_Y_W	setObjModel, stageAddr, STAGE_OBJ_MODEL

		TO_MEM_FROM_ADDR_Y	setObjDestroyEvent0, stageAddr, STAGE_OBJ_DESTORY_EVENT_0
		TO_MEM_FROM_ADDR_Y	setObjDestroyEvent1, stageAddr, STAGE_OBJ_DESTORY_EVENT_1

		jsr	setObj

		addw	<stageAddr, #STAGE_OBJ_SIZE

		jmp	.objInitLoop

.initEnd:


;;;<--;--------
;;set obj No1
;;左奥
;		movw	setObjX, #-4096
;		movw	setObjY, #ENEMY1_CENTER_Y
;		movw	setObjZ, #4096
;
;		mov	setObjRX, #0
;		mov	setObjRY, #0
;		mov	setObjRZ, #0
;
;		mov	setObjShotTimerMax, #64
;		mov	setObjHp, #16
;		mov	setObjNo, #1
;		mov	setObjStatus, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
;		mov	setObjMoveStatus, #0
;		movw	setObjModel, #modelEnemy1_0
;		jsr	setObj
;
;;--------
;;set obj No1
;;左前
;		movw	setObjX, #-4096
;		movw	setObjY, #ENEMY1_CENTER_Y
;		movw	setObjZ, #-4096
;
;		mov	setObjRX, #0
;		mov	setObjRY, #0
;		mov	setObjRZ, #0
;
;		mov	setObjShotTimerMax, #64
;		mov	setObjHp, #16
;		mov	setObjNo, #1
;		mov	setObjStatus, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
;		mov	setObjMoveStatus, #0
;		movw	setObjModel, #modelEnemy1_0
;		jsr	setObj

		ply
		plx
		rts


;----------------------------
_setObj:
;setObjのサブルーチン xの示すobjの位置にセットする
		TO_TABLE_W	obj_PX, #0
		TO_TABLE_W	obj_X, setObjX

		TO_TABLE_W	obj_PY, #0
		TO_TABLE_W	obj_Y, setObjY

		TO_TABLE_W	obj_PZ, #0
		TO_TABLE_W	obj_Z, setObjZ

		TO_TABLE	obj_RX, setObjRX
		TO_TABLE	obj_RY, setObjRY
		TO_TABLE	obj_RZ, setObjRZ

		TO_TABLE_W	obj_HIT_DATA_X0, #-OBJ_SIZE
		TO_TABLE_W	obj_HIT_DATA_Y0, #-OBJ_SIZE
		TO_TABLE_W	obj_HIT_DATA_Z0, #-OBJ_SIZE

		TO_TABLE_W	obj_HIT_DATA_X1, #OBJ_SIZE
		TO_TABLE_W	obj_HIT_DATA_Y1, #OBJ_SIZE
		TO_TABLE_W	obj_HIT_DATA_Z1, #OBJ_SIZE

		TO_TABLE	obj_STATUS, setObjStatus

		TO_TABLE	obj_MOVE_STATUS, setObjMoveStatus

		TO_TABLE	obj_SHOT_TIMER, #0
		TO_TABLE	obj_SHOT_TIMER_MAX, setObjShotTimerMax

		TO_TABLE	obj_MODEL_TIMER, #0

		TO_TABLE	obj_FLASH_TIMER, #0

		TO_TABLE	obj_MOVE_TIMER, #0

		TO_TABLE	obj_HP, setObjHp

		TO_TABLE	obj_NO, setObjNo

		TO_TABLE_W	obj_MODEL, setObjModel

		TO_TABLE	obj_DESTORY_EVENT_0, setObjDestroyEvent0
		TO_TABLE	obj_DESTORY_EVENT_1, setObjDestroyEvent1

		ADD_TABLES_W	obj_HIT_X0, obj_X, obj_HIT_DATA_X0
		ADD_TABLES_W	obj_HIT_Y0, obj_Y, obj_HIT_DATA_Y0
		ADD_TABLES_W	obj_HIT_Z0, obj_Z, obj_HIT_DATA_Z0

		ADD_TABLES_W	obj_HIT_X1, obj_X, obj_HIT_DATA_X1
		ADD_TABLES_W	obj_HIT_Y1, obj_Y, obj_HIT_DATA_Y1
		ADD_TABLES_W	obj_HIT_Z1, obj_Z, obj_HIT_DATA_Z1

		rts


;----------------------------
setObj:
;
		phx
		phy

		clx
.loop0:
		;;;<--cpx	objCount
		cpx	#OBJ_TABLE_COUNT_MAX
		jeq	.clearCarry

		TO_A_FROM_TABLE	obj_STATUS
		jne	.loop0Next

		jsr	_setObj

;;;<--		TO_TABLE_W	obj_PX, #0
;		TO_TABLE_W	obj_X, setObjX
;
;		TO_TABLE_W	obj_PY, #0
;		TO_TABLE_W	obj_Y, setObjY
;
;		TO_TABLE_W	obj_PZ, #0
;		TO_TABLE_W	obj_Z, setObjZ
;
;		TO_TABLE	obj_RX, setObjRX
;		TO_TABLE	obj_RY, setObjRY
;		TO_TABLE	obj_RZ, setObjRZ
;
;		TO_TABLE_W	obj_HIT_DATA_X0, #-OBJ_SIZE
;		TO_TABLE_W	obj_HIT_DATA_Y0, #-OBJ_SIZE
;		TO_TABLE_W	obj_HIT_DATA_Z0, #-OBJ_SIZE
;
;		TO_TABLE_W	obj_HIT_DATA_X1, #OBJ_SIZE
;		TO_TABLE_W	obj_HIT_DATA_Y1, #OBJ_SIZE
;		TO_TABLE_W	obj_HIT_DATA_Z1, #OBJ_SIZE
;
;		TO_TABLE	obj_STATUS, setObjStatus
;
;		TO_TABLE	obj_MOVE_STATUS, setObjMoveStatus
;
;		TO_TABLE	obj_SHOT_TIMER, #0
;		TO_TABLE	obj_SHOT_TIMER_MAX, setObjShotTimerMax
;
;		TO_TABLE	obj_MODEL_TIMER, #0
;
;		TO_TABLE	obj_FLASH_TIMER, #0
;
;		TO_TABLE	obj_MOVE_TIMER, #0
;
;		TO_TABLE	obj_HP, setObjHp
;
;		TO_TABLE	obj_NO, setObjNo
;
;		TO_TABLE_W	obj_MODEL, setObjModel
;
;		TO_TABLE	obj_DESTORY_EVENT_0, setObjDestroyEvent0
;		TO_TABLE	obj_DESTORY_EVENT_1, setObjDestroyEvent1

		ADD_TABLES_W	obj_HIT_X0, obj_X, obj_HIT_DATA_X0
		ADD_TABLES_W	obj_HIT_Y0, obj_Y, obj_HIT_DATA_Y0
		ADD_TABLES_W	obj_HIT_Z0, obj_Z, obj_HIT_DATA_Z0

		ADD_TABLES_W	obj_HIT_X1, obj_X, obj_HIT_DATA_X1
		ADD_TABLES_W	obj_HIT_Y1, obj_Y, obj_HIT_DATA_Y1
		ADD_TABLES_W	obj_HIT_Z1, obj_Z, obj_HIT_DATA_Z1

		sec

		bra	.setObjEnd

.loop0Next:
		inx
		jmp	.loop0

.clearCarry:
		clc

.setObjEnd:
		ply
		plx
		rts


;----------------------------
setObj2:
;setGameObj用 obj テーブルの検索スタートの index が 8 から始まる
		phx
		phy

		;;;clx
		ldx	#8
.loop0:
		;;;<--cpx	objCount
		cpx	#OBJ_TABLE_COUNT_MAX
		jeq	.clearCarry

		TO_A_FROM_TABLE	obj_STATUS
		jne	.loop0Next

		jsr	_setObj

;;;<--		TO_TABLE_W	obj_PX, #0
;		TO_TABLE_W	obj_X, setObjX
;
;		TO_TABLE_W	obj_PY, #0
;		TO_TABLE_W	obj_Y, setObjY
;
;		TO_TABLE_W	obj_PZ, #0
;		TO_TABLE_W	obj_Z, setObjZ
;
;		TO_TABLE	obj_RX, setObjRX
;		TO_TABLE	obj_RY, setObjRY
;		TO_TABLE	obj_RZ, setObjRZ
;
;		TO_TABLE_W	obj_HIT_DATA_X0, #-OBJ_SIZE
;		TO_TABLE_W	obj_HIT_DATA_Y0, #-OBJ_SIZE
;		TO_TABLE_W	obj_HIT_DATA_Z0, #-OBJ_SIZE
;
;		TO_TABLE_W	obj_HIT_DATA_X1, #OBJ_SIZE
;		TO_TABLE_W	obj_HIT_DATA_Y1, #OBJ_SIZE
;		TO_TABLE_W	obj_HIT_DATA_Z1, #OBJ_SIZE
;
;		TO_TABLE	obj_STATUS, setObjStatus
;
;		TO_TABLE	obj_MOVE_STATUS, setObjMoveStatus
;
;		TO_TABLE	obj_SHOT_TIMER, #0
;		TO_TABLE	obj_SHOT_TIMER_MAX, setObjShotTimerMax
;
;		TO_TABLE	obj_MODEL_TIMER, #0
;
;		TO_TABLE	obj_FLASH_TIMER, #0
;
;		TO_TABLE	obj_MOVE_TIMER, #0
;
;		TO_TABLE	obj_HP, setObjHp
;
;		TO_TABLE	obj_NO, setObjNo
;
;		TO_TABLE_W	obj_MODEL, setObjModel
;
;		TO_TABLE	obj_DESTORY_EVENT_0, setObjDestroyEvent0
;		TO_TABLE	obj_DESTORY_EVENT_1, setObjDestroyEvent1

		ADD_TABLES_W	obj_HIT_X0, obj_X, obj_HIT_DATA_X0
		ADD_TABLES_W	obj_HIT_Y0, obj_Y, obj_HIT_DATA_Y0
		ADD_TABLES_W	obj_HIT_Z0, obj_Z, obj_HIT_DATA_Z0

		ADD_TABLES_W	obj_HIT_X1, obj_X, obj_HIT_DATA_X1
		ADD_TABLES_W	obj_HIT_Y1, obj_Y, obj_HIT_DATA_Y1
		ADD_TABLES_W	obj_HIT_Z1, obj_Z, obj_HIT_DATA_Z1

		sec

		bra	.setObjEnd

.loop0Next:
		inx
		jmp	.loop0

.clearCarry:
		clc

.setObjEnd:
		ply
		plx
		rts


;----------------------------
initializeShip:
;shipのイニシャライズ
		stzw	shipPX
		stzw	shipPY
		stzw	shipPZ

		movw	shipX, #0
		;;;movw	shipY, #72
		movw	shipY, #2048
		;;;movw	shipZ, #$FE00
		movw	shipZ, #$E000

		stz	shipRX
		stz	shipRY
		stz	shipRZ

		stzw	shipSpeed

		stz	damageTimer

		stz	shipJumpY

		stz	jumpCount

		movw	jumpMaxCount, #JUMP_MAX_COUNT	;;;<--2026-06-15

		movw	jumpIndex, #JUMP_INIT_DATA

		;;;mov	shipShield, #SHIP_SHIELD_MAX

		rts


;----------------------------
setStageBlocks:
;blockのイニシャライズ
		;;;mov	blockCount, #1+(5+3*4)+4+8+2	;メインボスの下1, 道路5+3*4, ビル4, 木8, 小さいビル2
		;;;mov	blockCount, #1	;メインボスの下1

		;;;<--movw	<stageAddr, #stage1Block

		lda	[stageAddr]
		sta	blockCount
		incw	<stageAddr

		clx
.blockInitLoop:
		cpx	blockCount
		jeq	.initEnd

		;;;TO_TABLE	block_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		TO_TABLE_FROM_ADDR_Y	block_STATUS, stageAddr, STAGE_BLOCK_STATUS

		TO_MEM_FROM_ADDR_Y_W	<blockDataAddr, stageAddr, STAGE_BLOCK_NO

;X
		TO_TABLE_FROM_ADDR_Y_W	block_X, stageAddr, STAGE_BLOCK_X

		ADD_TABLE_FROM_ADDR_Y_W	block_HIT_X0, block_X, blockDataAddr, BLOCK_DATA_HIT_X0

		ADD_TABLE_FROM_ADDR_Y_W	block_HIT_X1, block_X, blockDataAddr, BLOCK_DATA_HIT_X1

;Y
		TO_TABLE_FROM_ADDR_Y_W	block_Y, stageAddr, STAGE_BLOCK_Y

		ADD_TABLE_FROM_ADDR_Y_W	block_HIT_Y0, block_Y, blockDataAddr, BLOCK_DATA_HIT_Y0

		ADD_TABLE_FROM_ADDR_Y_W	block_HIT_Y1, block_Y, blockDataAddr, BLOCK_DATA_HIT_Y1

;Z
		TO_TABLE_FROM_ADDR_Y_W	block_Z, stageAddr, STAGE_BLOCK_Z

		ADD_TABLE_FROM_ADDR_Y_W	block_HIT_Z0, block_Z, blockDataAddr, BLOCK_DATA_HIT_Z0

		ADD_TABLE_FROM_ADDR_Y_W	block_HIT_Z1, block_Z, blockDataAddr, BLOCK_DATA_HIT_Z1

;MODEL
		TO_TABLE_FROM_ADDR_Y_W	block_MODEL, blockDataAddr, BLOCK_DATA_MODEL

;EVENT
		TO_TABLE_FROM_ADDR_Y	block_ON_EVENT0, stageAddr, STAGE_BLOCK_ON_EVENT0
		TO_TABLE_FROM_ADDR_Y	block_ON_EVENT1, stageAddr, STAGE_BLOCK_ON_EVENT1

		TO_TABLE_FROM_ADDR_Y	block_HIT_EVENT0, stageAddr, STAGE_BLOCK_HIT_EVENT0
		TO_TABLE_FROM_ADDR_Y	block_HIT_EVENT1, stageAddr, STAGE_BLOCK_HIT_EVENT1

		addw	<stageAddr, #STAGE_BLOCK_SIZE

		inx
		jmp	.blockInitLoop

.initEnd:
		rts


;----------------------------
initializeShot:
;ship の shot のイニシャライズ
		;;;<--mov	shotCount, #SHOT_TABLE_COUNT_MAX

		clx
.shotInitLoop:
		;;;<--cpx	shotCount
		cpx	#SHOT_TABLE_COUNT_MAX
		beq	.initEnd

		TO_TABLE	shot_STATUS, #OBJ_UNSET

		inx
		bra	.shotInitLoop

.initEnd:
		rts


;----------------------------
initializeEnemyshot:
;enemy の shot のイニシャライズ
		;;;<--mov	enemyshotCount, #ENEMYSHOT_TABLE_COUNT_MAX

		clx
.shotInitLoop:
		;;;<--cpx	enemyshotCount
		cpx	#ENEMYSHOT_TABLE_COUNT_MAX
		beq	.initEnd

		TO_TABLE	enemyshot_STATUS, #OBJ_UNSET

		inx
		bra	.shotInitLoop

.initEnd:
		rts


;////////////////////////////
		.bank	SUB0_PRG_BANK
		.org	SUB0_PRG_MAP * $2000

;----------------------------
moveObj0_1_2:
;砲台移動ルーチン
		phx
		phy

;entity ?
		TO_A_FROM_TABLE	obj_STATUS
		and	#OBJ_ENTITY
		jeq	.setShotEnd

.jpExplosion:
;爆発？
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_EXPLOSION
		beq	.jpFlash

;Model の設定
;爆発モデル
		TO_A_FROM_TABLE	obj_MODEL_TIMER
		inc	a
		TO_TABLE_FROM_A	obj_MODEL_TIMER

		cmp	#OBJ_EXPLOSION_TIMER_0_MAX
		bcs	.jpExp01

		TO_TABLE_W	obj_MODEL, moveObj_MODEL_1
		jmp	.setShotEnd

.jpExp01:
		cmp	#OBJ_EXPLOSION_TIMER_1_MAX
		bcs	.jpExp02

		TO_TABLE_W	obj_MODEL, moveObj_MODEL_2
		jmp	.setShotEnd

.jpExp02:
		TO_TABLE	obj_STATUS, #OBJ_UNSET
		jmp	.setShotEnd

.jpFlash:
;set Flash
		TO_A_FROM_TABLE	obj_FLASH_TIMER
		beq	.jpFlash00

		dec	a
		TO_TABLE_FROM_A	obj_FLASH_TIMER

		TO_A_FROM_TABLE	obj_MOVE_STATUS
		ora	#OBJ_FLASH
		TO_TABLE_FROM_A	obj_MOVE_STATUS

		bra	.jpWorld00

.jpFlash00:
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_UNFLASH
		TO_TABLE_FROM_A	obj_MOVE_STATUS

.jpWorld00:
		TO_MEM_FROM_TABLE_W	hitX, obj_X
		TO_MEM_FROM_TABLE_W	hitY, obj_Y
		TO_MEM_FROM_TABLE_W	hitZ, obj_Z

		jsr	checkShipWorld
		jcc	.setShotEnd

;set shot
		TO_A_FROM_TABLE	obj_SHOT_TIMER_MAX
		beq	.setShotEnd

		TO_A_FROM_TABLE	obj_SHOT_TIMER
		inc	a
		CMP_A_FROM_TABLE	obj_SHOT_TIMER_MAX
		bne	.setShotjp0

		TO_MEM_FROM_TABLE_W	enemyPX, obj_PX
		TO_MEM_FROM_TABLE_W	enemyX, obj_X

		TO_MEM_FROM_TABLE_W	enemyPY, obj_PY
		TO_MEM_FROM_TABLE_W	enemyY, obj_Y

		TO_MEM_FROM_TABLE_W	enemyPZ, obj_PZ
		TO_MEM_FROM_TABLE_W	enemyZ, obj_Z

		jsr	setEnemyshot

		cla

.setShotjp0:
		TO_TABLE_FROM_A	obj_SHOT_TIMER

.setShotEnd:
		ply
		plx
		rts


;----------------------------
moveObj0:
;赤 メイン砲台

		movw	moveObj_MODEL_1, #modelEnemy0_1
		movw	moveObj_MODEL_2, #modelEnemy0_2
		jsr	moveObj0_1_2

		rts


;;;<--
		phx
		phy

.jpExplosion:
;爆発？
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_EXPLOSION
		beq	.jpFlash

;Model の設定
;爆発モデル
		TO_A_FROM_TABLE	obj_MODEL_TIMER
		inc	a
		TO_TABLE_FROM_A	obj_MODEL_TIMER

		cmp	#OBJ_EXPLOSION_TIMER_0_MAX
		bcs	.jpExp01

		TO_TABLE_W	obj_MODEL, #modelEnemy0_1
		jmp	.setShotEnd

.jpExp01:
		cmp	#OBJ_EXPLOSION_TIMER_1_MAX
		bcs	.jpExp02

		TO_TABLE_W	obj_MODEL, #modelEnemy0_2
		jmp	.setShotEnd

.jpExp02:
		TO_TABLE	obj_STATUS, #OBJ_UNSET
		jmp	.setShotEnd

.jpFlash:
;set Flash
		TO_A_FROM_TABLE	obj_FLASH_TIMER
		beq	.jpFlash00

		dec	a
		TO_TABLE_FROM_A	obj_FLASH_TIMER

		TO_A_FROM_TABLE	obj_MOVE_STATUS
		ora	#OBJ_FLASH
		TO_TABLE_FROM_A	obj_MOVE_STATUS

		bra	.jpWorld00

.jpFlash00:
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_UNFLASH
		TO_TABLE_FROM_A	obj_MOVE_STATUS

.jpWorld00:
		TO_MEM_FROM_TABLE_W	hitX, obj_X
		TO_MEM_FROM_TABLE_W	hitY, obj_Y
		TO_MEM_FROM_TABLE_W	hitZ, obj_Z

		jsr	checkShipWorld
		jcc	.setShotEnd

;set shot
		TO_A_FROM_TABLE	obj_SHOT_TIMER_MAX
		beq	.setShotEnd

		TO_A_FROM_TABLE	obj_SHOT_TIMER
		inc	a
		CMP_A_FROM_TABLE	obj_SHOT_TIMER_MAX
		bne	.setShotjp0

		TO_MEM_FROM_TABLE_W	enemyPX, obj_PX
		TO_MEM_FROM_TABLE_W	enemyX, obj_X

		TO_MEM_FROM_TABLE_W	enemyPY, obj_PY
		TO_MEM_FROM_TABLE_W	enemyY, obj_Y

		TO_MEM_FROM_TABLE_W	enemyPZ, obj_PZ
		TO_MEM_FROM_TABLE_W	enemyZ, obj_Z

		jsr	setEnemyshot

		cla

.setShotjp0:
		TO_TABLE_FROM_A	obj_SHOT_TIMER

.setShotEnd:
		ply
		plx
		rts


;----------------------------
moveObj1:
;緑 サブ砲台

		movw	moveObj_MODEL_1, #modelEnemy1_1
		movw	moveObj_MODEL_2, #modelEnemy1_2
		jsr	moveObj0_1_2

		rts


;;;<--
		phx
		phy

.jpExplosion:
;爆発？
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_EXPLOSION
		beq	.jpFlash

;Model の設定
;爆発モデル
		TO_A_FROM_TABLE	obj_MODEL_TIMER
		inc	a
		TO_TABLE_FROM_A	obj_MODEL_TIMER

		cmp	#OBJ_EXPLOSION_TIMER_0_MAX
		bcs	.jpExp01

		TO_TABLE_W	obj_MODEL, #modelEnemy1_1
		jmp	.setShotEnd

.jpExp01:
		cmp	#OBJ_EXPLOSION_TIMER_1_MAX
		bcs	.jpExp02

		TO_TABLE_W	obj_MODEL, #modelEnemy1_2
		jmp	.setShotEnd

.jpExp02:
		TO_TABLE	obj_STATUS, #OBJ_UNSET
		jmp	.setShotEnd

.jpFlash:
;set Flash
		TO_A_FROM_TABLE	obj_FLASH_TIMER
		beq	.jpFlash00

		dec	a
		TO_TABLE_FROM_A	obj_FLASH_TIMER

		TO_A_FROM_TABLE	obj_MOVE_STATUS
		ora	#OBJ_FLASH
		TO_TABLE_FROM_A	obj_MOVE_STATUS

		bra	.jpWorld00

.jpFlash00:
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_UNFLASH
		TO_TABLE_FROM_A	obj_MOVE_STATUS

.jpWorld00:
		TO_MEM_FROM_TABLE_W	hitX, obj_X
		TO_MEM_FROM_TABLE_W	hitY, obj_Y
		TO_MEM_FROM_TABLE_W	hitZ, obj_Z

		jsr	checkShipWorld
		jcc	.setShotEnd

;set shot
		TO_A_FROM_TABLE	obj_SHOT_TIMER
		inc	a
		CMP_A_FROM_TABLE	obj_SHOT_TIMER_MAX
		bne	.setShotjp0

		TO_MEM_FROM_TABLE_W	enemyPX, obj_PX
		TO_MEM_FROM_TABLE_W	enemyX, obj_X

		TO_MEM_FROM_TABLE_W	enemyPY, obj_PY
		TO_MEM_FROM_TABLE_W	enemyY, obj_Y

		TO_MEM_FROM_TABLE_W	enemyPZ, obj_PZ
		TO_MEM_FROM_TABLE_W	enemyZ, obj_Z

		jsr	setEnemyshot

		cla

.setShotjp0:
		TO_TABLE_FROM_A	obj_SHOT_TIMER

.setShotEnd:
		ply
		plx
		rts


;----------------------------
moveObj2:
;青 ザコ砲台
		movw	moveObj_MODEL_1, #modelEnemy2_1
		movw	moveObj_MODEL_2, #modelEnemy2_2
		jsr	moveObj0_1_2

		rts


;----------------------------
moveObj3:
;移動ザコ No.0
		phx
		phy

;start wait ?
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_START_WAIT
		beq	.jpExplosion

		TO_A_FROM_TABLE	obj_WAIT_TIMER
		inc	a
		TO_TABLE_FROM_A	obj_WAIT_TIMER

		cmp	#OBJ_WAIT_TIMER_MAX
		jne	.enemyDownMoveEnd

		TO_TABLE	obj_FLASH_TIMER, #0
		TO_TABLE	obj_MOVE_STATUS, #OBJ_NO3_MOVE_MODE1

		TO_TABLE_W	obj_MODEL, #modelEnemy3_0

		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		TO_TABLE	obj_MOVE_TIMER, #0

		jmp	.enemyDownMoveEnd

.jpExplosion:
;爆発？
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_EXPLOSION
		beq	.jpFlash

;Model の設定
;爆発モデル
		TO_A_FROM_TABLE	obj_MODEL_TIMER
		inc	a
		TO_TABLE_FROM_A	obj_MODEL_TIMER

		cmp	#OBJ_EXPLOSION_TIMER_0_MAX
		bcs	.jpExp01

		TO_TABLE_W	obj_MODEL, #modelEnemy3_3
		jmp	.enemyDownMoveEnd

.jpExp01:
		cmp	#OBJ_EXPLOSION_TIMER_1_MAX
		bcs	.jpExp02

		TO_TABLE_W	obj_MODEL, #modelEnemy3_4
		jmp	.enemyDownMoveEnd

.jpExp02:
		TO_TABLE	obj_STATUS, #OBJ_UNSET
		jmp	.enemyDownMoveEnd

.jpFlash:
;set Flash
		TO_A_FROM_TABLE	obj_FLASH_TIMER
		beq	.jpFlash00

		dec	a
		TO_TABLE_FROM_A	obj_FLASH_TIMER

		TO_A_FROM_TABLE	obj_MOVE_STATUS
		ora	#OBJ_FLASH
		TO_TABLE_FROM_A	obj_MOVE_STATUS

		bra	.jpWorld00

.jpFlash00:
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_UNFLASH
		TO_TABLE_FROM_A	obj_MOVE_STATUS

.jpWorld00:
		TO_MEM_FROM_TABLE_W	hitX, obj_X
		TO_MEM_FROM_TABLE_W	hitY, obj_Y
		TO_MEM_FROM_TABLE_W	hitZ, obj_Z

		jsr	checkShipWorld
		jcc	.setShotEnd

;set shot
		TO_A_FROM_TABLE	obj_SHOT_TIMER_MAX
		beq	.setShotEnd

		TO_A_FROM_TABLE	obj_SHOT_TIMER
		inc	a
		CMP_A_FROM_TABLE	obj_SHOT_TIMER_MAX
		bne	.setShotjp0

		TO_MEM_FROM_TABLE_W	enemyPX, obj_PX
		TO_MEM_FROM_TABLE_W	enemyX, obj_X

		TO_MEM_FROM_TABLE_W	enemyPY, obj_PY
		TO_MEM_FROM_TABLE_W	enemyY, obj_Y

		TO_MEM_FROM_TABLE_W	enemyPZ, obj_PZ
		TO_MEM_FROM_TABLE_W	enemyZ, obj_Z

		jsr	setEnemyshot

		cla

.setShotjp0:
		TO_TABLE_FROM_A	obj_SHOT_TIMER

.setShotEnd:

;Model の設定
;歩きモデル
		TO_A_FROM_TABLE	obj_MODEL_TIMER
		clc
		adc	#16
		TO_TABLE_FROM_A	obj_MODEL_TIMER

		and	#$C0
		bne	.modelJp00

		TO_TABLE_W	obj_MODEL, #modelEnemy3_0
		bra	.modelJp03

.modelJp00:
		cmp	#$40
		bne	.modelJp01

		TO_TABLE_W	obj_MODEL, #modelEnemy3_1
		bra	.modelJp03

.modelJp01:
		cmp	#$80
		bne	.modelJp02

		TO_TABLE_W	obj_MODEL, #modelEnemy3_0
		bra	.modelJp03

.modelJp02:
		TO_TABLE_W	obj_MODEL, #modelEnemy3_2

.modelJp03:

;check move mode
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_NO3_MOVE_MODE1
		beq	.jpMode0

;move timer check
		TO_A_FROM_TABLE	obj_MOVE_TIMER
		beq	.moveTimerJp02

		dec	a
		TO_TABLE_FROM_A	obj_MOVE_TIMER
		bra	.moveTimerJp00

.moveTimerJp02:
;unset move mode 1
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_NO3_UN_MOVE_MODE1
		TO_TABLE_FROM_A	obj_MOVE_STATUS

		bra	.moveTimerJp00

.jpMode0:
;move timer check
		TO_A_FROM_TABLE	obj_MOVE_TIMER
		beq	.moveTimerJp00

		dec	a
		TO_TABLE_FROM_A	obj_MOVE_TIMER
		jmp	.moveTimerJp01

.moveTimerJp00:
;ship への角度計算
		movw	<angleX1, shipX
		movw	<angleY1, shipY
		movw	<angleZ1, shipZ

		TO_MEM_FROM_TABLE_W	<angleX0, obj_X
		TO_MEM_FROM_TABLE_W	<angleY0, obj_Y
		TO_MEM_FROM_TABLE_W	<angleZ0, obj_Z

		jsr	getAngle

;move mode check
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_NO3_MOVE_MODE1
		beq	.jpMode0Jp1

		add	<ansAngleY, #OBJ_NO3_MODE1_ROTATION_DATA

.jpMode0Jp1:
;移動距離計算
		TO_A_FROM_TABLE	obj_RY
		sub	<ansAngleY
		sta	objWorkRY_A

		lda	<ansAngleY
		SUB_A_FROM_TABLE	     obj_RY
		sta	objWorkRY_B

		cmp	objWorkRY_A
		bcs	.jpRotation00

		lda	objWorkRY_B
		cmp	#OBJ_ROTATION_STEP
		bcc	.jpRotation02

		ADD_TABLE	obj_RY, #OBJ_ROTATION_STEP
		bra	.moveTimerJp01

.jpRotation00:
		lda	objWorkRY_A
		cmp	#OBJ_ROTATION_STEP
		bcc	.jpRotation02

		ADD_TABLE	obj_RY, #-OBJ_ROTATION_STEP
		bra	.moveTimerJp01

.jpRotation02:
		TO_TABLE	obj_RY, <ansAngleY

.moveTimerJp01:
		TO_A_FROM_TABLE	obj_RY

		phx
		tax
		jsr	vertexRotationY8_Z16384
		plx


;shiftで 4*4倍
		movw	<mul16a, transform2DWork0 + VX
		jsr	mul16
		movq	objMoveX, <mul16c

;shiftで 4*4倍
		movw	<mul16a, transform2DWork0 + VY
		jsr	mul16
		movq	objMoveY, <mul16c

;shiftで 4*4倍
		movw	<mul16a, transform2DWork0 + VZ
		jsr	mul16
		movq	objMoveZ, <mul16c

;旧位置データ退避
		TO_MEM_FROM_TABLE_Q	objWorkPX, obj_PX, obj_X
		TO_MEM_FROM_TABLE_Q	objWorkPY, obj_PY, obj_Y
		TO_MEM_FROM_TABLE_Q	objWorkPZ, obj_PZ, obj_Z

;位置データ更新
		ADD_TABLE_FROM_MEM_MEM_Q	obj_PX, obj_X, objWorkPX, objMoveX
		ADD_TABLE_FROM_MEM_MEM_Q	obj_PY, obj_Y, objWorkPY, objMoveY
		ADD_TABLE_FROM_MEM_MEM_Q	obj_PZ, obj_Z, objWorkPZ, objMoveZ

;当たり判定用
		TO_MEM_FROM_TABLE_W	hitX, obj_X
		TO_MEM_FROM_TABLE_W	hitY, obj_Y
		TO_MEM_FROM_TABLE_W	hitZ, obj_Z

;Block との当たり判定
		jsr	checkBlockHit
		jcs	.jpEnemyMove0

;Obj との当たり判定
		stx	objHitNo
		jsr	checkObjHit
		jcs	.jpEnemyMove0

;ヒット矩形データ更新
		ADD_TABLES_W	obj_HIT_X0, obj_X, obj_HIT_DATA_X0
		ADD_TABLES_W	obj_HIT_Y0, obj_Y, obj_HIT_DATA_Y0
		ADD_TABLES_W	obj_HIT_Z0, obj_Z, obj_HIT_DATA_Z0

		ADD_TABLES_W	obj_HIT_X1, obj_X, obj_HIT_DATA_X1
		ADD_TABLES_W	obj_HIT_Y1, obj_Y, obj_HIT_DATA_Y1
		ADD_TABLES_W	obj_HIT_Z1, obj_Z, obj_HIT_DATA_Z1

;当たり判定用
		movw	hitX, shipX
		movw	hitY, shipY
		movw	hitZ, shipZ

;Ship との当たり判定
		jsr	_checkObjHit
		bcs	.jpEnemyMove0

;当たりませんでした
		jmp	.enemyMoveEnd

.jpEnemyMove0:

;移動できない
		TO_A_FROM_TABLE	obj_RY
		clc
		adc	#OBJ_ROTATION_STEP
		TO_TABLE_FROM_A	obj_RY

		TO_TABLE	obj_MOVE_TIMER, #OBJ_MOVE_TIMER_DATA

;unset move mode 1
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_NO3_UN_MOVE_MODE1
		TO_TABLE_FROM_A	obj_MOVE_STATUS

.enemyNoMove:
;位置データ Work から戻す 位置データ更新
		TO_TABLE_Q	obj_PX, obj_X, objWorkPX
		TO_TABLE_Q	obj_PY, obj_Y, objWorkPY
		TO_TABLE_Q	obj_PZ, obj_Z, objWorkPZ

;ヒット矩形データ更新
		ADD_TABLES_W	obj_HIT_X0, obj_X, obj_HIT_DATA_X0
		ADD_TABLES_W	obj_HIT_Y0, obj_Y, obj_HIT_DATA_Y0
		ADD_TABLES_W	obj_HIT_Z0, obj_Z, obj_HIT_DATA_Z0

		ADD_TABLES_W	obj_HIT_X1, obj_X, obj_HIT_DATA_X1
		ADD_TABLES_W	obj_HIT_Y1, obj_Y, obj_HIT_DATA_Y1
		ADD_TABLES_W	obj_HIT_Z1, obj_Z, obj_HIT_DATA_Z1

.enemyMoveEnd:
.enemyDownMove:
;地面より上か？
		CMP_TABLE_W	obj_Y, #ENEMY3_CENTER_Y+1
		bpl	.enemyDownMove00

		TO_TABLE_W	obj_Y, #ENEMY3_CENTER_Y
		jmp	.enemyDownMoveEnd

.enemyDownMove00:
;現在の obj の位置データを Work へ
		TO_MEM_FROM_TABLE_W	objWorkY, obj_Y

;位置データ 加算
		SUB_TABLE_W	obj_Y, #OBJ_DOWN_DATA

;当たり判定用
		TO_MEM_FROM_TABLE_W	hitX, obj_X
		TO_MEM_FROM_TABLE_W	hitY, obj_Y
		TO_MEM_FROM_TABLE_W	hitZ, obj_Z

;Block との当たり判定
		jsr	checkBlockHit
		jcs	.enemyDownNoMove

;Obj との当たり判定
		stx	objHitNo
		jsr	checkObjHit
		jcs	.enemyDownNoMove

;ヒット矩形データ更新
		ADD_TABLES_W	obj_HIT_Y0, obj_Y, obj_HIT_DATA_Y0

		ADD_TABLES_W	obj_HIT_Y1, obj_Y, obj_HIT_DATA_Y1

;当たり判定用
		movw	hitX, shipX
		movw	hitY, shipY
		movw	hitZ, shipZ

;Ship との当たり判定
		jsr	_checkObjHit
		bcc	.enemyDownMoveEnd

.enemyDownNoMove:
;当たりました
;位置データ Work から戻す 位置データ更新
		TO_TABLE_W	obj_Y, objWorkY

;ヒット矩形データ更新
		ADD_TABLES_W	obj_HIT_Y0, obj_Y, obj_HIT_DATA_Y0

		ADD_TABLES_W	obj_HIT_Y1, obj_Y, obj_HIT_DATA_Y1

.enemyDownMoveEnd:
		ply
		plx
		rts


;----------------------------
moveObj4:
;移動ザコ No.1
		phx
		phy

;start wait ?
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_START_WAIT
		beq	.jpExplosion

		TO_A_FROM_TABLE	obj_WAIT_TIMER
		inc	a
		TO_TABLE_FROM_A	obj_WAIT_TIMER

		cmp	#OBJ_WAIT_TIMER_MAX
		jne	.enemyDownMoveEnd

		TO_TABLE	obj_FLASH_TIMER, #0
		TO_TABLE	obj_MOVE_STATUS, #OBJ_NO3_MOVE_MODE1
		;;;TO_TABLE	obj_MOVE_STATUS, #0

		TO_TABLE_W	obj_MODEL, #modelEnemy4_0

		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		TO_TABLE	obj_MOVE_TIMER, #0

		jmp	.enemyDownMoveEnd

.jpExplosion:
;爆発？
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_EXPLOSION
		beq	.jpFlash

;Model の設定
;爆発モデル
		TO_A_FROM_TABLE	obj_MODEL_TIMER
		inc	a
		TO_TABLE_FROM_A	obj_MODEL_TIMER

		cmp	#OBJ_EXPLOSION_TIMER_0_MAX
		bcs	.jpExp01

		TO_TABLE_W	obj_MODEL, #modelEnemy4_3
		jmp	.enemyDownMoveEnd

.jpExp01:
		cmp	#OBJ_EXPLOSION_TIMER_1_MAX
		bcs	.jpExp02

		TO_TABLE_W	obj_MODEL, #modelEnemy4_4
		jmp	.enemyDownMoveEnd

.jpExp02:
		TO_TABLE	obj_STATUS, #OBJ_UNSET
		jmp	.enemyDownMoveEnd

.jpFlash:
;set Flash
		TO_A_FROM_TABLE	obj_FLASH_TIMER
		beq	.jpFlash00

		dec	a
		TO_TABLE_FROM_A	obj_FLASH_TIMER

		TO_A_FROM_TABLE	obj_MOVE_STATUS
		ora	#OBJ_FLASH
		TO_TABLE_FROM_A	obj_MOVE_STATUS

		bra	.jpWorld00

.jpFlash00:
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_UNFLASH
		TO_TABLE_FROM_A	obj_MOVE_STATUS

.jpWorld00:
;;;<--		TO_MEM_FROM_TABLE_W	hitX, obj_X
;		TO_MEM_FROM_TABLE_W	hitY, obj_Y
;		TO_MEM_FROM_TABLE_W	hitZ, obj_Z
;
;		jsr	checkShipWorld
;		jcc	.setShotEnd
;
;;set shot
;		TO_A_FROM_TABLE	obj_SHOT_TIMER_MAX
;		beq	.setShotEnd
;
;		TO_A_FROM_TABLE	obj_SHOT_TIMER
;		inc	a
;		CMP_A_FROM_TABLE	obj_SHOT_TIMER_MAX
;		bne	.setShotjp0
;
;		TO_MEM_FROM_TABLE_W	enemyPX, obj_PX
;		TO_MEM_FROM_TABLE_W	enemyX, obj_X
;
;		TO_MEM_FROM_TABLE_W	enemyPY, obj_PY
;		TO_MEM_FROM_TABLE_W	enemyY, obj_Y
;
;		TO_MEM_FROM_TABLE_W	enemyPZ, obj_PZ
;		TO_MEM_FROM_TABLE_W	enemyZ, obj_Z
;
;		jsr	setEnemyshot
;
;		cla
;
;.setShotjp0:
;		TO_TABLE_FROM_A	obj_SHOT_TIMER
;
;.setShotEnd:

;Model の設定
;歩きモデル
		TO_A_FROM_TABLE	obj_MODEL_TIMER
		clc
		adc	#16
		TO_TABLE_FROM_A	obj_MODEL_TIMER

		and	#$C0
		bne	.modelJp00

		TO_TABLE_W	obj_MODEL, #modelEnemy4_0
		bra	.modelJp03

.modelJp00:
		cmp	#$40
		bne	.modelJp01

		TO_TABLE_W	obj_MODEL, #modelEnemy4_1
		bra	.modelJp03

.modelJp01:
		cmp	#$80
		bne	.modelJp02

		TO_TABLE_W	obj_MODEL, #modelEnemy4_0
		bra	.modelJp03

.modelJp02:
		TO_TABLE_W	obj_MODEL, #modelEnemy4_2

.modelJp03:

;check move mode
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_NO3_MOVE_MODE1
		beq	.jpMode0

;move timer check
		TO_A_FROM_TABLE	obj_MOVE_TIMER
		beq	.moveTimerJp02

		dec	a
		TO_TABLE_FROM_A	obj_MOVE_TIMER
		bra	.moveTimerJp00

.moveTimerJp02:
;unset move mode 1
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_NO3_UN_MOVE_MODE1
		TO_TABLE_FROM_A	obj_MOVE_STATUS

		bra	.moveTimerJp00

.jpMode0:
;move timer check
		TO_A_FROM_TABLE	obj_MOVE_TIMER
		beq	.moveTimerJp00

		dec	a
		TO_TABLE_FROM_A	obj_MOVE_TIMER
		jmp	.moveTimerJp01

.moveTimerJp00:
;ship への角度計算
		movw	<angleX1, shipX
		movw	<angleY1, shipY
		movw	<angleZ1, shipZ

		TO_MEM_FROM_TABLE_W	<angleX0, obj_X
		TO_MEM_FROM_TABLE_W	<angleY0, obj_Y
		TO_MEM_FROM_TABLE_W	<angleZ0, obj_Z

		jsr	getAngle

;move mode check
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_NO3_MOVE_MODE1
		beq	.jpMode0Jp1

		add	<ansAngleY, #OBJ_NO3_MODE1_ROTATION_DATA

.jpMode0Jp1:
;移動距離計算
		TO_A_FROM_TABLE	obj_RY
		sub	<ansAngleY
		sta	objWorkRY_A

		lda	<ansAngleY
		SUB_A_FROM_TABLE	     obj_RY
		sta	objWorkRY_B

		cmp	objWorkRY_A
		bcs	.jpRotation00

		lda	objWorkRY_B
		cmp	#OBJ_ROTATION_STEP
		bcc	.jpRotation02

		ADD_TABLE	obj_RY, #OBJ_ROTATION_STEP
		bra	.moveTimerJp01

.jpRotation00:
		lda	objWorkRY_A
		cmp	#OBJ_ROTATION_STEP
		bcc	.jpRotation02

		ADD_TABLE	obj_RY, #-OBJ_ROTATION_STEP
		bra	.moveTimerJp01

.jpRotation02:
		TO_TABLE	obj_RY, <ansAngleY

.moveTimerJp01:
		TO_A_FROM_TABLE	obj_RY

		phx
		tax
		jsr	vertexRotationY8_Z16384
		plx


;shiftで 4*4倍
		movw	<mul16a, transform2DWork0 + VX
		jsr	mul16
		movq	objMoveX, <mul16c

;shiftで 4*4倍
		movw	<mul16a, transform2DWork0 + VY
		jsr	mul16
		movq	objMoveY, <mul16c

;shiftで 4*4倍
		movw	<mul16a, transform2DWork0 + VZ
		jsr	mul16
		movq	objMoveZ, <mul16c

;旧位置データ退避
		TO_MEM_FROM_TABLE_Q	objWorkPX, obj_PX, obj_X
		TO_MEM_FROM_TABLE_Q	objWorkPY, obj_PY, obj_Y
		TO_MEM_FROM_TABLE_Q	objWorkPZ, obj_PZ, obj_Z

;位置データ更新
		ADD_TABLE_FROM_MEM_MEM_Q	obj_PX, obj_X, objWorkPX, objMoveX
		ADD_TABLE_FROM_MEM_MEM_Q	obj_PY, obj_Y, objWorkPY, objMoveY
		ADD_TABLE_FROM_MEM_MEM_Q	obj_PZ, obj_Z, objWorkPZ, objMoveZ

;当たり判定用
		TO_MEM_FROM_TABLE_W	hitX, obj_X
		TO_MEM_FROM_TABLE_W	hitY, obj_Y
		TO_MEM_FROM_TABLE_W	hitZ, obj_Z

;Block との当たり判定
		jsr	checkBlockHit
		jcs	.jpEnemyMove0

;Obj との当たり判定
		stx	objHitNo
		jsr	checkObjHit
		jcs	.jpEnemyMove0

;ヒット矩形データ更新
		ADD_TABLES_W	obj_HIT_X0, obj_X, obj_HIT_DATA_X0
		ADD_TABLES_W	obj_HIT_Y0, obj_Y, obj_HIT_DATA_Y0
		ADD_TABLES_W	obj_HIT_Z0, obj_Z, obj_HIT_DATA_Z0

		ADD_TABLES_W	obj_HIT_X1, obj_X, obj_HIT_DATA_X1
		ADD_TABLES_W	obj_HIT_Y1, obj_Y, obj_HIT_DATA_Y1
		ADD_TABLES_W	obj_HIT_Z1, obj_Z, obj_HIT_DATA_Z1

;当たり判定用
		movw	hitX, shipX
		movw	hitY, shipY
		movw	hitZ, shipZ

;Ship との当たり判定
		jsr	_checkObjHit
		bcs	.jpEnemyMove0

;当たりませんでした
		jmp	.enemyMoveEnd

.jpEnemyMove0:

;移動できない
		TO_A_FROM_TABLE	obj_RY
		clc
		adc	#OBJ_ROTATION_STEP
		TO_TABLE_FROM_A	obj_RY

		TO_TABLE	obj_MOVE_TIMER, #OBJ_MOVE_TIMER_DATA

;unset move mode 1
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		and	#OBJ_NO3_UN_MOVE_MODE1
		TO_TABLE_FROM_A	obj_MOVE_STATUS

.enemyNoMove:
;位置データ Work から戻す 位置データ更新
		TO_TABLE_Q	obj_PX, obj_X, objWorkPX
		TO_TABLE_Q	obj_PY, obj_Y, objWorkPY
		TO_TABLE_Q	obj_PZ, obj_Z, objWorkPZ

;ヒット矩形データ更新
		ADD_TABLES_W	obj_HIT_X0, obj_X, obj_HIT_DATA_X0
		ADD_TABLES_W	obj_HIT_Y0, obj_Y, obj_HIT_DATA_Y0
		ADD_TABLES_W	obj_HIT_Z0, obj_Z, obj_HIT_DATA_Z0

		ADD_TABLES_W	obj_HIT_X1, obj_X, obj_HIT_DATA_X1
		ADD_TABLES_W	obj_HIT_Y1, obj_Y, obj_HIT_DATA_Y1
		ADD_TABLES_W	obj_HIT_Z1, obj_Z, obj_HIT_DATA_Z1

.enemyMoveEnd:
.enemyDownMove:
;地面より上か？
		CMP_TABLE_W	obj_Y, #ENEMY4_CENTER_Y+1
		bpl	.enemyDownMove00

		TO_TABLE_W	obj_Y, #ENEMY4_CENTER_Y
		jmp	.enemyDownMoveEnd

.enemyDownMove00:
;現在の obj の位置データを Work へ
		TO_MEM_FROM_TABLE_W	objWorkY, obj_Y

;位置データ 加算
		SUB_TABLE_W	obj_Y, #OBJ_DOWN_DATA

;当たり判定用
		TO_MEM_FROM_TABLE_W	hitX, obj_X
		TO_MEM_FROM_TABLE_W	hitY, obj_Y
		TO_MEM_FROM_TABLE_W	hitZ, obj_Z

;Block との当たり判定
		jsr	checkBlockHit
		jcs	.enemyDownNoMove

;Obj との当たり判定
		stx	objHitNo
		jsr	checkObjHit
		jcs	.enemyDownNoMove

;ヒット矩形データ更新
		ADD_TABLES_W	obj_HIT_Y0, obj_Y, obj_HIT_DATA_Y0

		ADD_TABLES_W	obj_HIT_Y1, obj_Y, obj_HIT_DATA_Y1

;当たり判定用
		movw	hitX, shipX
		movw	hitY, shipY
		movw	hitZ, shipZ

;Ship との当たり判定
		jsr	_checkObjHit
		bcc	.enemyDownMoveEnd

.enemyDownNoMove:
;当たりました
;位置データ Work から戻す 位置データ更新
		TO_TABLE_W	obj_Y, objWorkY

;ヒット矩形データ更新
		ADD_TABLES_W	obj_HIT_Y0, obj_Y, obj_HIT_DATA_Y0

		ADD_TABLES_W	obj_HIT_Y1, obj_Y, obj_HIT_DATA_Y1

.enemyDownMoveEnd:
		ply
		plx
		rts


;----------------------------
moveObj8:
;壊れる標準立方体
		rts


;----------------------------
hitObj0_1_2:
;砲台ヒットルーチン
;HP 0 の時 carry セット
		phx
		phy

;set flash
		TO_TABLE	obj_FLASH_TIMER, #OBJ_FLASH_TIMER_MAX

;HP dec
		TO_A_FROM_TABLE	obj_HP
		dec	a
		TO_TABLE_FROM_A	obj_HP

		cmp	#0
		beq	.jpExp01

;se enemy damage
		lda	#SE_ENEMY_DAMAGE
		jsr	setSe

		clc
		bra	.jpExp00

.jpExp01:
;HP 0 処理
;se enemy explosion
		lda	#SE_EXPLOSION
		jsr	setSe

		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY
		TO_TABLE	obj_MOVE_STATUS, #OBJ_EXPLOSION
		TO_TABLE	obj_MODEL_TIMER, #0

		sec

.jpExp00:
		ply
		plx
		rts


;----------------------------
hitObj0:
;赤 メイン砲台
;緑 サブ砲台のカウントが0以外は当たり判定は無し
		lda	subBaseCount
		bne	.jpEnd

		jsr	hitObj0_1_2
		bcc	.jpEnd

		lda	gameOverFlag
		bne	.jpEnd
		mov	stageClearFlag, #$FF
		mov	stageClearCounter, #$FF

.jpEnd:
		rts


;;;<--
		phx
		phy

;緑 サブ砲台のカウントが0以外は当たり判定は無し
		lda	subBaseCount
		bne	.jpExp00

;set flash
		TO_TABLE	obj_FLASH_TIMER, #OBJ_FLASH_TIMER_MAX

;HP dec
		TO_A_FROM_TABLE	obj_HP
		dec	a
		TO_TABLE_FROM_A	obj_HP

		cmp	#0
		beq	.jpExp01

;se enemy damage
		lda	#SE_ENEMY_DAMAGE
		jsr	setSe

		bra	.jpExp00

.jpExp01:
;HP 0 処理
;se enemy explosion
		lda	#SE_EXPLOSION
		jsr	setSe

		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY
		TO_TABLE	obj_MOVE_STATUS, #OBJ_EXPLOSION
		TO_TABLE	obj_MODEL_TIMER, #0

		lda	gameOverFlag
		bne	.jpExp00
		mov	stageClearFlag, #$FF
		;;;mov	stageClearCounter, #191
		mov	stageClearCounter, #$FF

;;;<--		tma	#SUB2_PRG_MAP
;		pha
;		lda	#CG_DATA_BANK
;		tam	#SUB2_PRG_MAP
;
;		movw	<setCgtoSgStrAddr, #strSTAGE_CLEAR
;		movw	setCgtoSgWorkW0, #$4000
;		movw	setCgtoSgWorkW1, #$0070
;		mov	setCgtoSgWork0, #$00
;		jsr	setStrToSg2
;
;		pla
;;;;		lda	#SUB2_PRG_BANK
;		tam	#SUB2_PRG_MAP

.jpExp00:
		ply
		plx
		rts


;----------------------------
hitObj1:
;緑 サブ砲台
		jsr	hitObj0_1_2
		bcc	.jpEnd

;破壊された
;緑 サブ砲台のカウントを減らす
		dec	subBaseCount

;イベント発生
		TO_A_FROM_TABLE	obj_DESTORY_EVENT_0
		jsr	eventProc

		TO_A_FROM_TABLE	obj_DESTORY_EVENT_1
		jsr	eventProc

.jpEnd:
		rts

;;;<--
		phx
		phy

;set flash
		TO_TABLE	obj_FLASH_TIMER, #OBJ_FLASH_TIMER_MAX

;HP dec
		TO_A_FROM_TABLE	obj_HP
		dec	a
		TO_TABLE_FROM_A	obj_HP

		cmp	#0
		beq	.jpExp01

;se enemy damage
		lda	#SE_ENEMY_DAMAGE
		jsr	setSe

		bra	.jpExp00

.jpExp01:
;HP 0 処理
;se enemy explosion
		lda	#SE_EXPLOSION
		jsr	setSe

		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY
		TO_TABLE	obj_MOVE_STATUS, #OBJ_EXPLOSION
		TO_TABLE	obj_MODEL_TIMER, #0

;緑 サブ砲台のカウントを減らす
		dec	subBaseCount

;;;<--
;Obj3 ;移動ザコ No.0
;増やしたり減らしたり
;		dec	subBaseCount
;
;		lda	enemyCountMax
;		cmp	#ENEMY_COUNT_MAX
;		beq	.jpExp00
;
;		inc	enemyCountMax

.jpExp00:
		ply
		plx
		rts


;----------------------------
hitObj2:
;青 ザコ砲台
		jsr	hitObj0_1_2
		bcc	.jpEnd

;イベント発生
		TO_A_FROM_TABLE	obj_DESTORY_EVENT_0
		jsr	eventProc

		TO_A_FROM_TABLE	obj_DESTORY_EVENT_1
		jsr	eventProc

.jpEnd:
		rts


;----------------------------
hitObj3:
;移動ザコ No.0
		phx
		phy

;set flash
		TO_TABLE	obj_FLASH_TIMER, #OBJ_FLASH_TIMER_MAX

;check timer
		TO_A_FROM_TABLE	obj_MOVE_TIMER
		bne	.hpJp0

;set move mode 1
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		ora	#OBJ_NO3_MOVE_MODE1
		TO_TABLE_FROM_A	obj_MOVE_STATUS
		TO_TABLE obj_MOVE_TIMER, #OBJ_NO3_MOVE_MODE1_TIMER_MAX

;HP dec
.hpJp0:
		TO_A_FROM_TABLE	obj_HP
		dec	a
		TO_TABLE_FROM_A	obj_HP

		cmp	#0
		beq	.jpExp01

;se enemy damage
		lda	#SE_ENEMY_DAMAGE
		jsr	setSe

		bra	.jpExp00

.jpExp01:
;HP 0 処理
;se enemy explosion
		lda	#SE_EXPLOSION
		jsr	setSe

		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY
		TO_TABLE	obj_MOVE_STATUS, #OBJ_EXPLOSION
		TO_TABLE	obj_MODEL_TIMER, #0

		dec	enemyCount

.jpExp00:
		ply
		plx
		rts


;----------------------------
hitObj4:
;移動ザコ No.1
		phx
		phy

;set flash
		TO_TABLE	obj_FLASH_TIMER, #OBJ_FLASH_TIMER_MAX

;check timer
		TO_A_FROM_TABLE	obj_MOVE_TIMER
		bne	.hpJp0

;set move mode 1
		TO_A_FROM_TABLE	obj_MOVE_STATUS
		ora	#OBJ_NO3_MOVE_MODE1
		TO_TABLE_FROM_A	obj_MOVE_STATUS
		TO_TABLE obj_MOVE_TIMER, #OBJ_NO3_MOVE_MODE1_TIMER_MAX

;HP dec
.hpJp0:
		TO_A_FROM_TABLE	obj_HP
		dec	a
		TO_TABLE_FROM_A	obj_HP

		cmp	#0
		beq	.jpExp01

;se enemy damage
		lda	#SE_ENEMY_DAMAGE
		jsr	setSe

		bra	.jpExp00

.jpExp01:
;HP 0 処理
;se enemy explosion
		lda	#SE_EXPLOSION
		jsr	setSe

		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY
		TO_TABLE	obj_MOVE_STATUS, #OBJ_EXPLOSION
		TO_TABLE	obj_MODEL_TIMER, #0

		dec	enemyCount

.jpExp00:
		ply
		plx
		rts


;----------------------------
hitObj8:
;壊れる標準立方体

		phx
		phy

;set flash
		TO_TABLE	obj_FLASH_TIMER, #OBJ_FLASH_TIMER_MAX

;HP dec
		TO_A_FROM_TABLE	obj_HP
		dec	a
		TO_TABLE_FROM_A	obj_HP

		cmp	#0
		beq	.jpExp01

;se enemy damage
		lda	#SE_ENEMY_DAMAGE
		jsr	setSe

		bra	.jpExp00

.jpExp01:
;HP 0 処理
;se enemy explosion
		lda	#SE_EXPLOSION
		jsr	setSe

		TO_TABLE	obj_STATUS, #OBJ_UNSET

.jpExp00:
		ply
		plx
		rts


;----------------------------
_setGroundVramAddr:
;
		phy

		ldy	_groundY

		bbs0	<drawingNo, .jp00

;No0
		lda	_polyLineAddrConvXLow
		ora	_polyLineAddrConvYLow, y
		sta	groundVramAddr

		lda	_polyLineAddrConvXHigh
		ora	_polyLineAddrConvYHigh0, y
		sta	groundVramAddr+1

		bra	.jp01

.jp00:
;No1
		lda	_polyLineAddrConvXLow
		ora	_polyLineAddrConvYLow, y
		sta	groundVramAddr

		lda	_polyLineAddrConvXHigh
		ora	_polyLineAddrConvYHigh1, y
		sta	groundVramAddr+1

.jp01:
		ply
		rts


;----------------------------
__clearBufferLine:
;
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3

		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3

		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3

		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3
		sta	VDC_3

		rts


;----------------------------
_clearBufferLine8:
;
		phy

		jsr	_setGroundVramAddr

;P0 P1
		ldy	#8

		phx

.loop0:
		st0	#$00
		lda	groundVramAddr
		sta	VDC_2
		lda	groundVramAddr+1
		sta	VDC_3

		st0	#$02
		lda	clearP0Data, x
		sta	VDC_2
		lda	clearP1Data, x

		jsr	__clearBufferLine

		inc	groundVramAddr

		inx

		dey
		bne	.loop0

		plx

;P2 P3
		ldy	#8

.loop1:
		st0	#$00
		lda	groundVramAddr
		sta	VDC_2
		lda	groundVramAddr+1
		sta	VDC_3

		st0	#$02
		lda	clearP2Data, x
		sta	VDC_2
		lda	clearP3Data, x

		jsr	__clearBufferLine

		inc	groundVramAddr

		inx

		dey
		bne	.loop1

.jpEnd:
		ply

		rts


;----------------------------
switchClearBuffer2:
;
		phx
		phy

		jsr	setInc32Vdc

		stz	_groundY

		;;;<--clx
		lda	#144
		sub	groundY
		tax

		ldy	#144 / 8

.loop0:
		jsr	_clearBufferLine8

		add	_groundY, #8

		dey
		bne	.loop0

		jsr	setInc1Vdc

		ply
		plx

		rts


;;;<--
;;----------------------------
;_clearBufferLine:
;;
;
;		phx
;		phy
;
;		ldx	_groundLineCount
;		beq	.jpEnd
;
;		jsr	_setGroundVramAddr
;
;		lda	groundVramAddr
;		pha
;		ldy	groundVramAddr+1
;
;;P0 P1
;.loop0:
;		st0	#$00
;		lda	groundVramAddr
;		sta	VDC_2
;		lda	groundVramAddr+1
;		sta	VDC_3
;
;		st0	#$02
;		lda	groundClolorP0
;		sta	VDC_2
;		lda	groundClolorP1
;
;		jsr	__clearBufferLine
;
;		inc	groundVramAddr
;
;		dex
;		bne	.loop0
;
;;P2 P3
;		pla
;		ora	#8
;		sta	groundVramAddr
;		sty	groundVramAddr+1
;
;		ldx	_groundLineCount
;.loop1:
;		st0	#$00
;		lda	groundVramAddr
;		sta	VDC_2
;		lda	groundVramAddr+1
;		sta	VDC_3
;
;		st0	#$02
;		lda	groundClolorP2
;		sta	VDC_2
;		lda	groundClolorP3
;
;		jsr	__clearBufferLine
;
;		inc	groundVramAddr
;
;		dex
;		bne	.loop1
;
;		add	_groundY, _groundLineCount
;
;.jpEnd:
;		ply
;		plx
;		rts
;
;
;;----------------------------
;_clearBufferChar:
;;
;		phx
;		phy
;
;		ldy	_groundCharCount
;		beq	.jpEnd
;
;.loop2:
;		jsr	_setGroundVramAddr
;
;;P0 P1
;		ldx	#8
;.loop0:
;		st0	#$00
;		lda	groundVramAddr
;		sta	VDC_2
;		lda	groundVramAddr+1
;		sta	VDC_3
;
;		st0	#$02
;		lda	groundClolorP0
;		sta	VDC_2
;		lda	groundClolorP1
;
;		jsr	__clearBufferLine
;
;		inc	groundVramAddr
;
;		dex
;		bne	.loop0
;
;;P2 P3
;		ldx	#8
;.loop1:
;		st0	#$00
;		lda	groundVramAddr
;		sta	VDC_2
;		lda	groundVramAddr+1
;		sta	VDC_3
;
;		st0	#$02
;		lda	groundClolorP2
;		sta	VDC_2
;		lda	groundClolorP3
;
;		jsr	__clearBufferLine
;
;		inc	groundVramAddr
;
;		dex
;		bne	.loop1
;
;		add	_groundY, #8
;
;		dey
;		bne	.loop2
;
;.jpEnd:
;		ply
;		plx
;		rts
;
;
;;----------------------------
;switchClearBuffer2:
;;
;		phx
;		phy
;
;		mov	groundYWork, groundY
;
;		lda	groundYWork
;		lsr	a
;		lsr	a
;		lsr	a
;		sta	skyCharCount
;
;		lda	groundYWork
;		and	#7
;		sta	skyLineCount
;
;		sec
;		lda	#17
;		sbc	skyCharCount
;		bpl	.jp00
;		cla
;.jp00:
;		sta	groundCharCount
;
;		sub	groundLineCount, #8, skyLineCount
;
;		jsr	setInc32Vdc
;
;		stz	_groundY
;
;		mov	groundClolorP0, #$FF
;		mov	groundClolorP1, #$FF
;		mov	groundClolorP2, #0
;		mov	groundClolorP3, #$FF
;
;		mov	_groundCharCount, skyCharCount
;		jsr	_clearBufferChar
;
;		mov	_groundLineCount, skyLineCount
;		jsr	_clearBufferLine
;
;		mov	groundClolorP0, #$FF
;		mov	groundClolorP1, #0
;		mov	groundClolorP2, #$FF
;		mov	groundClolorP3, #$FF
;
;		mov	_groundLineCount, groundLineCount
;		jsr	_clearBufferLine
;
;		mov	_groundCharCount, groundCharCount
;		jsr	_clearBufferChar
;
;		jsr	setInc1Vdc
;
;		ply
;		plx
;		rts


;----------------------------
mul16:
;mul16d:mul16c = mul16a * 16
		lda	<mul16a
		sta	<mul16c

		lda	<mul16a+1
		sta	<mul16c+1

		jsr	signExt

		asl	<mul16c
		rol	<mul16c+1
		rol	a

		asl	<mul16c
		rol	<mul16c+1
		rol	a

		asl	<mul16c
		rol	<mul16c+1
		rol	a

		asl	<mul16c
		rol	<mul16c+1
		rol	a

		sta	<mul16d

		jsr	signExt
		sta	<mul16d+1

		rts


;----------------------------
mul64:
;mul16d:mul16c = mul16a * 64
		stz	<mul16c

		lda	<mul16a
		sta	<mul16c+1

		lda	<mul16a+1
		sta	<mul16d

		jsr	signExt

		lsr	a
		ror	<mul16d
		ror	<mul16c+1
		ror	<mul16c

		lsr	a
		ror	<mul16d
		ror	<mul16c+1
		ror	<mul16c

		lda	<mul16d
		jsr	signExt
		sta	<mul16d+1

		rts


;----------------------------
mul256:
;mul16d:mul16c = mul16a * 256
		stz	<mul16c

		lda	<mul16a
		sta	<mul16c+1

		lda	<mul16a+1
		sta	<mul16d

		jsr	signExt
		sta	<mul16d+1

		rts


;----------------------------
mul1024:
;mul16d:mul16c = mul16a * 1024
		stz	<mul16c

		lda	<mul16a
		sta	<mul16c+1

		lda	<mul16a+1
		sta	<mul16d

		jsr	signExt

		asl	<mul16c+1
		rol	<mul16d
		rol	a

		asl	<mul16c+1
		rol	<mul16d
		rol	a

		sta	<mul16d+1

		rts


;----------------------------
vertexRotationY8_Z16384:
;x=xcosA-zsinA	y=y		z=xsinA+zcosA
;y = 0
		stz	transform2DWork0 + VY
		stz	transform2DWork0 + VY + 1

		cpx	#0
		beq	.endJp01

;x = -(sin * 16384)
		stz	transform2DWork0 + VX

		lda	sin8DataLow, x
		sta	transform2DWork0 + VX + 1

		lda	sin8DataHigh, x
		and	#$01

		lsr	a
		ror	transform2DWork0 + VX + 1
		ror	transform2DWork0 + VX

		lsr	a
		ror	transform2DWork0 + VX + 1
		ror	transform2DWork0 + VX

		lda	sin8DataHigh, x
		bmi	.zJp00

		sec
		cla
		sbc	transform2DWork0 + VX
		sta	transform2DWork0 + VX

		cla
		sbc	transform2DWork0 + VX + 1
		sta	transform2DWork0 + VX + 1

.zJp00:
;z = cos * 16384
		stz	transform2DWork0 + VZ

		lda	cos8DataLow, x
		sta	transform2DWork0 + VZ + 1

		lda	cos8DataHigh, x
		and	#$01

		lsr	a
		ror	transform2DWork0 + VZ + 1
		ror	transform2DWork0 + VZ

		lsr	a
		ror	transform2DWork0 + VZ + 1
		ror	transform2DWork0 + VZ

		lda	cos8DataHigh, x
		bpl	.endJp00

		sec
		cla
		sbc	transform2DWork0 + VZ
		sta	transform2DWork0 + VZ

		cla
		sbc	transform2DWork0 + VZ + 1
		sta	transform2DWork0 + VZ + 1

.endJp00:
		rts

.endJp01:
		stz	transform2DWork0 + VX
		stz	transform2DWork0 + VX + 1
		movw	transform2DWork0 + VZ, #16384

		rts


;----------------------------
vertexRotationX8_Z16384:
;x=x		y=zsinA+ycosA	z=zcosA-ysinA
;x = 0
		stz	transform2DWork0 + VX
		stz	transform2DWork0 + VX + 1

		cpx	#0
		beq	.endJp01

;y = sin * 16384
		stz	transform2DWork0 + VY

		lda	sin8DataLow, x
		sta	transform2DWork0 + VY + 1

		lda	sin8DataHigh, x
		and	#$01

		lsr	a
		ror	transform2DWork0 + VY + 1
		ror	transform2DWork0 + VY

		lsr	a
		ror	transform2DWork0 + VY + 1
		ror	transform2DWork0 + VY

		lda	sin8DataHigh, x
		bpl	.zJp00

		sec
		cla
		sbc	transform2DWork0 + VY
		sta	transform2DWork0 + VY

		cla
		sbc	transform2DWork0 + VY + 1
		sta	transform2DWork0 + VY + 1

.zJp00:
;z = cos * 16384
		stz	transform2DWork0 + VZ

		lda	cos8DataLow, x
		sta	transform2DWork0 + VZ + 1

		lda	cos8DataHigh, x
		and	#$01

		lsr	a
		ror	transform2DWork0 + VZ + 1
		ror	transform2DWork0 + VZ

		lsr	a
		ror	transform2DWork0 + VZ + 1
		ror	transform2DWork0 + VZ

		lda	cos8DataHigh, x
		bpl	.endJp00

		sec
		cla
		sbc	transform2DWork0 + VZ
		sta	transform2DWork0 + VZ

		cla
		sbc	transform2DWork0 + VZ + 1
		sta	transform2DWork0 + VZ + 1

.endJp00:
		rts

.endJp01:
		stz	transform2DWork0 + VY
		stz	transform2DWork0 + VY + 1
		movw	transform2DWork0 + VZ, #16384

		rts

;144 LINE
;----------------------------
_polyLineAddrConvYHigh0:
		.db	$20, $20, $20, $20, $20, $20, $20, $20, $24, $24, $24, $24, $24, $24, $24, $24,\
			$28, $28, $28, $28, $28, $28, $28, $28, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C,\
			$30, $30, $30, $30, $30, $30, $30, $30, $34, $34, $34, $34, $34, $34, $34, $34,\
			$38, $38, $38, $38, $38, $38, $38, $38, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C,\
			$40, $40, $40, $40, $40, $40, $40, $40

		.db	$20, $20, $20, $20, $20, $20, $20, $20, $24, $24, $24, $24, $24, $24, $24, $24,\
			$28, $28, $28, $28, $28, $28, $28, $28, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C,\
			$30, $30, $30, $30, $30, $30, $30, $30, $34, $34, $34, $34, $34, $34, $34, $34,\
			$38, $38, $38, $38, $38, $38, $38, $38, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C,\
			$40, $40, $40, $40, $40, $40, $40, $40


;----------------------------
_polyLineAddrConvYHigh1:
		.db	$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C,\
			$60, $60, $60, $60, $60, $60, $60, $60, $64, $64, $64, $64, $64, $64, $64, $64,\
			$68, $68, $68, $68, $68, $68, $68, $68, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C,\
			$70, $70, $70, $70, $70, $70, $70, $70

		.db	$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C,\
			$60, $60, $60, $60, $60, $60, $60, $60, $64, $64, $64, $64, $64, $64, $64, $64,\
			$68, $68, $68, $68, $68, $68, $68, $68, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C,\
			$70, $70, $70, $70, $70, $70, $70, $70


;----------------------------
_polyLineAddrConvYLow:
		.db	$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07

		.db	$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17


;----------------------------
_polyLineAddrConvXHigh:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01,\
			$02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03, $03


;----------------------------
_polyLineAddrConvXLow:
		.db	$00, $20, $40, $60, $80, $A0, $C0, $E0, $00, $20, $40, $60, $80, $A0, $C0, $E0,\
			$00, $20, $40, $60, $80, $A0, $C0, $E0, $00, $20, $40, $60, $80, $A0, $C0, $E0




;;;<--
;----------------------------
eventProc:
;A:event No.
		phx
		phy

		cmp	#$FF
		jeq	.eventEnd

		asl	a
		;;;asl	a

		tax
		jmp	[.eventJumpTable, x]

.eventFunc0:
;ステージ４
		ldx	#1
		TO_A_FROM_TABLE	block_STATUS
		and	#OBJ_ENTITY
		jne	.eventEnd

		TO_TABLE	block_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR

		mov	stageEventCounter, #60*3
		lda	#SE_EXPLOSION
		jsr	setSe

		jmp	.eventEnd

.eventFunc1:
;ステージ４
		ldx	#4
		TO_A_FROM_TABLE	block_STATUS
		and	#OBJ_ENTITY
		jne	.eventEnd

		TO_TABLE	block_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR

		mov	stageEventCounter, #60*3
		lda	#SE_EXPLOSION
		jsr	setSe

		jmp	.eventEnd

.eventFunc2:
;ステージ４
		ldx	#10
		TO_A_FROM_TABLE	block_STATUS
		and	#OBJ_ENTITY
		bne	.eventEnd

		TO_TABLE	block_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR

		mov	stageEventCounter, #60*3
		lda	#SE_EXPLOSION
		jsr	setSe

		jmp	.eventEnd

.eventFunc3:
;ステージ４
		ldx	#7
		TO_A_FROM_TABLE	block_STATUS
		and	#OBJ_ENTITY
		bne	.eventEnd

		TO_TABLE	block_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR

		mov	stageEventCounter, #60*3
		lda	#SE_EXPLOSION
		jsr	setSe

		jmp	.eventEnd

.eventFunc4:
;ステージ５
		ldx	#3
		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT

		mov	stageEventCounter, #60*3

		jmp	.eventEnd

.eventFunc5:
;ステージ５
		ldx	#2
		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT

		ldx	#5
		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT

		ldx	#6
		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT

		mov	stageEventCounter, #60*3

		jmp	.eventEnd

.eventFunc6:
;ステージ５
		ldx	#4
		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT

		ldx	#7
		TO_TABLE	obj_STATUS, #OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT

		mov	stageEventCounter, #60*3

		jmp	.eventEnd

.eventEnd:
		ply
		plx
		rts



;;;<--		phx
;
;		cmp	$FF
;		jeq	.eventEnd
;
;		;;;<--stx	debug0
;		;sta	debug1
;
;		asl	a
;		asl	a
;
;		tax
;
;		phx
;
;		lda	.eventData + EVENT_FUNC_NO, x
;		asl	a
;		tax
;
;		jmp	[.eventJumpTable, x]
;
;;
;.eventFunc0:
;;ブロック属性変更
;;arg0 が属性
;;arg1, arg2 が対象ブロックNo.($FFは処理しない)
;		plx
;
;		lda	.eventData + EVENT_ARG_2, x
;		pha
;		lda	.eventData + EVENT_ARG_1, x
;		pha
;		lda	.eventData + EVENT_ARG_0, x
;		plx
;		cpx	$FF
;		beq	.jpEV0_0
;		TO_TABLE_FROM_A	block_STATUS
;.jpEV0_0:
;		plx
;		cpx	$FF
;		beq	.jpEV0_1
;		TO_TABLE_FROM_A	block_STATUS
;
;.jpEV0_1:
;		jmp	.eventEnd
;
;.eventEnd:
;		plx
;		rts

.eventJumpTable
		.dw	.eventFunc0
		.dw	.eventFunc1
		.dw	.eventFunc2
		.dw	.eventFunc3
		.dw	.eventFunc4
		.dw	.eventFunc5
		.dw	.eventFunc6

		.rsset	0
EVENT_FUNC_NO	.rs	1
EVENT_ARG_0	.rs	1
EVENT_ARG_1	.rs	1
EVENT_ARG_2	.rs	1

.eventData
		.db	0,  OBJ_ACTIVE, 0, $FF	;0	ステージ1のブロックNo.0の属性変更








;////////////////////////////
		.bank	SUB1_PRG_BANK
		.org	SUB1_PRG_MAP * $2000

;----------------------------
stageMain:
;


;;;<--
;;;<--		jmp	.jp000


;----------------
;スプライトへ文字列セット
		lda	#CG_DATA_BANK
		tam	#SUB2_PRG_MAP

		;;;<--movw	<argw0, #$4000
		;movw	<argw1, #$0043
		;movw	<argw2, #$0060
		;mov	<arg6, #$00
		;jsr	setCgToSgData

;144LINE の時は
;BUFFER0 $2000-$4DFF 空きは$4E00-$4FFF CGで$04E0-$04FF SGで$270-27F
;BUFFER1 $5000-$7DFF 空きは$7E00-$7FFF CGで$07E0-$07FF SGで$3F0-3FF

		movw	<setCgtoSgStrAddr, #strPUSH_RUN
		movw	setCgtoSgWorkW0, #$4000
		movw	setCgtoSgWorkW1, #$0220
		mov	setCgtoSgWork0, #$00
		jsr	setStrToSg2

		movw	<setCgtoSgStrAddr, #strSTAGE_START
		movw	setCgtoSgWorkW0, #$4000
		movw	setCgtoSgWorkW1, #$0230
		mov	setCgtoSgWork0, #$00
		jsr	setStrToSg2

		movw	<setCgtoSgStrAddr, #strSTAGE_CLEAR
		movw	setCgtoSgWorkW0, #$4000
		movw	setCgtoSgWorkW1, #$0240
		mov	setCgtoSgWork0, #$00
		jsr	setStrToSg2

		movw	<setCgtoSgStrAddr, #strGAME_OVER
		movw	setCgtoSgWorkW0, #$4000
		movw	setCgtoSgWorkW1, #$0250
		mov	setCgtoSgWork0, #$00
		jsr	setStrToSg2

		movw	<setCgtoSgStrAddr, #strPAUSE
		movw	setCgtoSgWorkW0, #$4000
		movw	setCgtoSgWorkW1, #$0260
		mov	setCgtoSgWork0, #$00
		jsr	setStrToSg2

		movw	<setCgtoSgStrAddr, #strEVENT
		movw	setCgtoSgWorkW0, #$4000
		movw	setCgtoSgWorkW1, #$0270
		mov	setCgtoSgWork0, #$00
		jsr	setStrToSg2

		lda	#SUB2_PRG_BANK
		tam	#SUB2_PRG_MAP



;----------------
;WAVE DATA セット
;;;		stz	seCounter
;		stz	seCounterEnd
;		stz	seNoise
;
;		stz	seNo
;		stz	seNoWork

		mov	PSG_0, #$05	;ch sel(bit2-0)

		mov	PSG_4, #$40	;dda on
		mov	PSG_4, #$00	;dda off	;when wave data transfer

		clx
.waveDataLoop:
		;;;lda	waveData0, x
		lda	waveData3, x
		sta	PSG_6		;wave data (bit4-0)
		inx
		cpx	#32
		bne	.waveDataLoop

		mov	PSG_1, #$FF	;main vol Lvol(bit7-4) Rvol(bit3-0)


;----------------
.gameStart:

;----------------
;SE ワーク 初期化
		stz	seCounter
		stz	seCounterEnd
		stz	seNoise

		stz	seNo
		stz	seNoWork


;タイトル処理
		jsr	titleFunction


;ルール処理
		jsr	ruleFunction


;操作説明処理
		jsr	guideFunction


;ゲーム処理
;----------------
		mov	shipShield, #SHIP_SHIELD_MAX

		stz	stageCount
		;;;mov	stageCount, #1
		;;;mov	stageCount, #3
		;;;mov	stageCount, #4
		;;;mov	stageCount, #5
		;;;mov	stageCount, #6

.gameLoop:

;set stage data 
		;;;movw	<stageDataAddr, #stage1Data
		;;;movw	<stageDataAddr, #stage2Data
		;;;movw	<stageDataAddr, #stage3Data
		;;;movw	<stageDataAddr, #stage4Data
		;;;movw	<stageDataAddr, #stage5Data
		;;;movw	<stageDataAddr, #stage6Data
		;;;movw	<stageDataAddr, #stage7Data
		;;;movw	<stageDataAddr, #stage8Data

		lda	stageCount
		asl	a
		tax
		inc	stageCount

		lda	.stageDataTable, x
		sta	<stageDataAddr
		inx
		lda	.stageDataTable, x
		sta	<stageDataAddr+1

		jsr	gameFunction

		lda	gameOverFlag
		;;;bne	stageMain
		bne	.gameStart

		lda	stageCount
		cmp	#8
		bne	.gameLoop

;all stage clear
;エンディング処理
		jsr	endingFunction


;----------------
		;;;jmp	stageMain
		jmp	.gameStart


.stageDataTable
		.dw	stage1Data
		.dw	stage2Data
		.dw	stage3Data
		.dw	stage4Data
		.dw	stage5Data
		.dw	stage6Data
		.dw	stage7Data
		.dw	stage8Data


;----------------------------
gameFunction:
;ゲームメイン
		phx
		phy

;----------------
;set ship shield
;;;<--		mov	shipShield, #16



;;;<--
;;;		mov	debug0, #$88
;;;		mov	debug1, #$88


;;;<--
;.jp000:



;----------------
;clear BAT
		cla
		ldx	#$01
		jsr	clearBat

;set BAT
		jsr	setBat

;----------------
		jsr	initializeScreenVsync

;----------------
		lda	#DRAWING_NO_0_ADDR
		jsr	clearBuffer

		lda	#DRAWING_NO_1_ADDR
		jsr	clearBuffer

;----------------
		jsr	clearSat

;----------------
		ldx	#SCREEN_CENTER_X
		ldy	#SCREEN_CENTER_Y
		jsr	setScreenCenter

;----------------
;debug
;;;		lda	#60
;		sta	frameCount
;		stz	drawCount
;		stz	drawCountWork

;----------------
;debug
;;;		ldx	#0
;		ldy	#18
;		jsr	setWriteVramAddress
;
;		lda	#$30
;		ldx	#$00
;		jsr	putChar
;
;		mov	<drawingNo, #DRAWING_NO_1
;
;		ldx	#0
;		ldy	#18
;		jsr	setWriteVramAddress
;
;		lda	#$31
;		ldx	#$00
;		jsr	putChar
;
;		mov	<drawingNo, #DRAWING_NO_0


;----------------
;stage
		mov	<drawingNo, #DRAWING_NO_0

		ldx	#1
		ldy	#18
		jsr	setWriteVramAddress

		movw	<argw0, #strSTAGE
		mov	<arg2, #0
		jsr	putString

		ldx	#1
		ldy	#19
		jsr	setWriteVramAddress

		movw	<argw0, #strSHIELD
		mov	<arg2, #0
		jsr	putString

		ldx	#1
		ldy	#20
		jsr	setWriteVramAddress

		movw	<argw0, #strBASE
		mov	<arg2, #0
		jsr	putString

		mov	<drawingNo, #DRAWING_NO_1

		ldx	#1
		ldy	#18
		jsr	setWriteVramAddress

		movw	<argw0, #strSTAGE
		mov	<arg2, #0
		jsr	putString

		ldx	#1
		ldy	#19
		jsr	setWriteVramAddress

		movw	<argw0, #strSHIELD
		mov	<arg2, #0
		jsr	putString

		ldx	#1
		ldy	#20
		jsr	setWriteVramAddress

		movw	<argw0, #strBASE
		mov	<arg2, #0
		jsr	putString

		mov	<drawingNo, #DRAWING_NO_0


;----------------
		mov	stageFlag, #$FF

		jsr	initializeSatBuffer

		lda	#4
		jsr	setSatBufferSkipNo

;----------------
;initialize game logic
		stz	reentrantFlag

		stz	<stageFlag0

		mov	stageStartCounter, #60 * 3
		stz	stageClearCounter
		stz	gameOverCounter
		stz	stageEventCounter

		stz	setObjTimer
		stz	setObjSwitch
		stz	setSubObjTimer

		stz	enemyCount		;現在存在する enemy の数　ゲーム中増減する　enemyCountMax の値より大きくならない
		;;;stz	enemyCountMax
		mov	enemyCountMax, #4	;現在存在する enemy の最大数　ゲーム中増減する　緑を倒すたびに+1　enemyCountStageMax の値より大きくならない
		mov	enemyCountStageMax, #4	;現在存在する enemy の最大数　ゲーム中増減しない　enemyCountMax はこの値以上増えない　ゲームスタート時に設定

;緑 サブ砲台のカウント
		mov	subBaseCount, #4

;flag initialize
		stz	stageClearFlag
		stz	gameOverFlag
		stz	pauseFlag

;;;<--
;;----------------
;;initialize etc
;		mov	subBaseCount, #4



;----------------
;set stage data 
		;;;movw	<stageDataAddr, #stage1Data
		;;;movw	<stageDataAddr, #stage2Data
		;;;movw	<stageDataAddr, #stage3Data
		;;;movw	<stageDataAddr, #stage4Data
		;;;movw	<stageDataAddr, #stage5Data
		;;;movw	<stageDataAddr, #stage6Data
		;;;movw	<stageDataAddr, #stage7Data
		;;;movw	<stageDataAddr, #stage8Data

;enemy出現間隔
		ldy	#STAGE_DATA_ENEMY_WAIT
		lda	[stageDataAddr] ,y
		sta	setEnemyWait

;enemy出現タイプ
		ldy	#STAGE_DATA_ENEMY_SET_TYPE
		lda	[stageDataAddr] ,y
		sta	setEnemyType

;enemyHP
		ldy	#STAGE_DATA_ENEMY_HP
		lda	[stageDataAddr] ,y
		sta	setEnemyHP

;enemy shot 間隔
		ldy	#STAGE_DATA_ENEMY_SHOT_WAIT
		lda	[stageDataAddr] ,y
		sta	setEnemyShotWait

;stage flag 0
		ldy	#STAGE_DATA_FLAG0
		lda	[stageDataAddr] ,y
		sta	<stageFlag0

;;;;enemy出現間隔
;		lda	stage1Data+STAGE_DATA_ENEMY_WAIT
;		sta	setEnemyWait
;
;;enemy出現タイプ
;		lda	stage1Data+STAGE_DATA_ENEMY_SET_TYPE
;		sta	setEnemyType
;
;;enemyHP
;		lda	stage1Data+STAGE_DATA_ENEMY_HP
;		sta	setEnemyHP
;
;;enemy shot 間隔
;		lda	stage1Data+STAGE_DATA_ENEMY_SHOT_WAIT
;		sta	setEnemyShotWait

;----------------
;set enemyCountMaxTable
;;;		clx
;.enemyCountLoop:
;		lda	stage1EnemyCountTable, x
;		sta	enemyCountMaxTable, x
;		inx
;		cpx	#5
;		bne	.enemyCountLoop

		ldy	#STAGE_DATA_ENEMY_COUNT_TABLE
		lda	[stageDataAddr] ,y
		sta	<stageAddr
		iny
		lda	[stageDataAddr] ,y
		sta	<stageAddr+1

		cly
.enemyCountLoop:
		lda	[stageAddr], y
		sta	enemyCountMaxTable, y
		iny
		cpy	#5
		bne	.enemyCountLoop

;----------------
		jsr	initializeShip

;----------------
		;;;movw	<stageAddr, #stage1Block
		ldy	#STAGE_DATA_BLOCK_DATA
		lda	[stageDataAddr] ,y
		sta	<stageAddr
		iny
		lda	[stageDataAddr] ,y
		sta	<stageAddr+1
		jsr	setStageBlocks

;----------------
		;;;movw	<stageAddr, #stage1Obj
		ldy	#STAGE_DATA_OBJ_DATA
		lda	[stageDataAddr] ,y
		sta	<stageAddr
		iny
		lda	[stageDataAddr] ,y
		sta	<stageAddr+1
		jsr	setStageObjs

;----------------
		jsr	initializeShot

;----------------
		jsr	initializeEnemyshot

;----------------
		jsr	onScreen

;----------------
		jsr	enableIrqVdc

;----------------
		;;;<--jsr	setEyeWork

;----------------
		;;;<--jsr	setPolygonWork

;----------------
		jsr	setVsyncFlag

;----------------
		cli

;----------------
.mainLoop:
;----------------
;stage clear?
		lda	stageClearFlag
		beq	.jpNotClear

;;;<--
;		tma	#SUB2_PRG_MAP
;		pha
;		lda	#CG_DATA_BANK
;		tam	#SUB2_PRG_MAP
;
;		movw	<setCgtoSgStrAddr, #strSTAGE_CLEAR
;		movw	setCgtoSgWorkW0, #$4000
;		movw	setCgtoSgWorkW1, #$0070
;		mov	setCgtoSgWork0, #$00
;		jsr	setStrToSg2
;
;		pla
;;;;		lda	#SUB2_PRG_BANK
;		tam	#SUB2_PRG_MAP

		lda	stageClearCounter
		bne	.jpNotClear

		jmp	.exitJp

.jpNotClear:



;----------------
;game over?
		lda	gameOverFlag
		beq	.jpNotOver

		lda	gameOverCounter
		bne	.jpNotOver

		jmp	.exitJp

.jpNotOver:

;----------------
		jsr	waitScreenVsync

;----------------
		jsr	initializePolygonAndSat

;----------------
;照準
		movw	<argw0, #72-8+64
		movw	<argw1, #128-16+32
		movw	<argw2, #$0050
		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
		lda	#4
		jsr	setSatBuffer

;----------------
		movw	<argw2, #$0000
		movw	<argw3, #$0000

;PAUSE
		lda	pauseFlag
		beq	.skipPause

		movw	<argw2, #$0260
		bra	.putSp

.skipPause:
		;;;<--movw	<argw2, #$0000

;----------------
;STAGE START
		lda	stageStartCounter
		beq	.skipPutStart

		movw	<argw2, #$0230
		;;;bra	.putSp

.skipPutStart:

;----------------
;EVENT
		lda	stageEventCounter
		beq	.skipPutEvent

		movw	<argw2, #$0270
		movw	<argw3, #$0001

.skipPutEvent:

;----------------
;STAGE CLEAR
		lda	stageClearCounter
		beq	.skipPutClear

		movw	<argw2, #$0240
		;;;bra	.putSp

.skipPutClear:

;----------------
;GAME OVER
		lda	gameOverCounter
		beq	.skipPutOver

		movw	<argw2, #$0250
		;;;bra	.putSp

.skipPutOver:
		lda	<argw2
		ora	<argw2+1
		beq	.skipPutSp

.putSp:
		movw	<argw0, #72-4+64
		movw	<argw1, #128-44+32
		;;;<--movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
		addw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND
		lda	#0
		ldx	#3
		jsr	setStringSprite

;;;<--
;		movw	<argw0, #72-4+64
;		movw	<argw1, #128-44+32
;		movw	<argw2, #$0230
;		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
;		lda	#0
;		jsr	setSatBuffer
;
;		movw	<argw0, #72-4+64
;		movw	<argw1, #128-44+32+32
;		movw	<argw2, #$0234
;		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
;		lda	#1
;		jsr	setSatBuffer
;
;		movw	<argw0, #72-4+64
;		movw	<argw1, #128-44+64+32
;		movw	<argw2, #$0238
;		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
;		lda	#2
;		jsr	setSatBuffer

.skipPutSp:


;----------------
;コンパス
		movw	<eyeTranslationX, #0
		movw	<eyeTranslationY, #0
		movw	<eyeTranslationZ, #0
		mov	<eyeRotationX, #0
		mov	<eyeRotationY, #0
		mov	<eyeRotationZ, #0
		mov	<eyeRotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y

		lda	#0
		jsr	setPolygonColorIndex

;;;<--		movw	<translationX, #128-32
;		movw	<translationY, #72-32
;		movw	<translationZ, #128
;
;		mov	<rotationX, #0
;		mov	<rotationY, #0
;		;;;mov	<rotationZ, eyeRotationYWork
;		lda	eyeRotationYWork
;		eor	#$FF
;		inc	a
;		sta	<rotationZ
;
;		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y
;
;		movw	<modelAddress, #modelCompass
;
;		jsr	setModelRotation


		;;;<--movw	<translationX, #128-16-16
		movw	<translationX, #128-32-16
		movw	<translationY, #0
		movw	<translationZ, #128

		mov	<rotationX, #0
		mov	<rotationY, #0
		mov	<rotationZ, #0

		movw	<modelAddress, #modelScreen

		jsr	setModelRotation


;----------------
		jsr	setEyeFromWork

		jsr	putPolygonFromWork

;----------------
		jsr	setSatToVram

;;;<--
;;----------------
		jsr	switchClearBuffer2
;;;		jsr	switchClearBuffer

;----------------
		jsr	putPolygonBuffer


;----------------
;レーダー
		;;;<--jsr	pset

		movw	<polygonTableAddr, #polygonTable
		clx
.loop0:
		cpx	polygonTableCount
		jeq	.jpEnd

		TO_A_FROM_ADDR_Y	polygonTableAddr, POLYGON_MODEL_TYPE
		cmp	#MODEL_TYPE_OBJ
		bne	.radarJp00

		lda	#9
		sta	radarPsetColor
		bra	.radarJp01

.radarJp00:
		cmp	#MODEL_TYPE_BLOCK_RADAR
		;;;<--bne	.jpNext0	;2*2
		jne	.jpNext0	;3*3

		lda	#2
		;;;<--lda	#10
		sta	radarPsetColor

.radarJp01:

		TO_MEM_SUB_ADDR_Y_FROM_MEM_W	shipWorldX0, polygonTableAddr, POLYGON_X, <eyeTranslationX
		TO_MEM_SUB_ADDR_Y_FROM_MEM_W	shipWorldZ0, polygonTableAddr, POLYGON_Z, <eyeTranslationZ

		movw	transform2DWork0+VX, shipWorldX0
		movw	transform2DWork0+VY, #0
		movw	transform2DWork0+VZ, shipWorldZ0

		mov	<vertexCount, #1

		phx
		ldx	eyeRotationYWork
		jsr	vertexRotationY8
		plx

		phx
		phy

;;;<--		lda	transform2DWork0+VX+1
;		add	#224
;		tax
;
;		;;;lda	transform2DWork0+VZ+1
;		;add	#72
;		lda	#72
;		sub	transform2DWork0+VZ+1
;		tay

;1/256
		ldx	transform2DWork0+VX+1
		ldy	transform2DWork0+VZ+1

;1/512
;		lda	transform2DWork0+VX+1
;		asl	transform2DWork0+VX+1
;		ror	a
;		tax
;
;		lda	transform2DWork0+VZ+1
;		asl	transform2DWork0+VZ+1
;		ror	a
;		tay

		;;;<--lda	#9
		lda	radarPsetColor

;;<--2*2
;		jsr	checkPset
;
;		inx
;		jsr	checkPset
;
;		dex
;		iny
;		jsr	checkPset
;
;		inx
;		jsr	checkPset

;;;<--3*3
		dex
		dey
		jsr	checkPset

		inx
		jsr	checkPset

		inx
		jsr	checkPset

		dex
		dex
		iny
		jsr	checkPset

		inx
		jsr	checkPset

		inx
		jsr	checkPset

		dex
		dex
		iny
		jsr	checkPset

		inx
		jsr	checkPset

		inx
		jsr	checkPset

		ply
		plx

.jpNext0:
		addw	<polygonTableAddr, #POLYGON_STRUCT_SIZE

		inx
		jmp	.loop0
.jpEnd:

		clx
		cly
		lda	#14
		jsr	checkPset

;;<--2*2
;		inx
;		jsr	checkPset
;
;		dex
;		iny
;		jsr	checkPset
;
;		inx
;		jsr	checkPset

;;;<--3*3
		dex
		dey
		jsr	checkPset

		inx
		jsr	checkPset

		inx
		jsr	checkPset

		dex
		dex
		iny
		jsr	checkPset

		inx
		jsr	checkPset

		inx
		jsr	checkPset

		dex
		dex
		iny
		jsr	checkPset

		inx
		jsr	checkPset

		inx
		jsr	checkPset


;----------------
;debug print
;;;		inc	drawCountWork
;
;		ldx	#0
;		ldy	#19
;		jsr	setWriteVramAddress
;
;		lda	drawCount
;		ldx	#$00
;		jsr	putHex

;		ldx	#0
;		ldy	#20
;		jsr	setWriteVramAddress

;		lda	eyeTranslationXWork+1
;		ldx	#$00
;		jsr	putHex

;		lda	eyeTranslationXWork
;		ldx	#$00
;		jsr	putHex

;		lda	$20
;		ldx	#$00
;		jsr	putChar

;		lda	eyeTranslationYWork+1
;		ldx	#$00
;		jsr	putHex

;		lda	eyeTranslationYWork
;		ldx	#$00
;		jsr	putHex

;		lda	$20
;		ldx	#$00
;		jsr	putChar

;		lda	eyeTranslationZWork+1
;		ldx	#$00
;		jsr	putHex

;		lda	eyeTranslationZWork
;		ldx	#$00
;		jsr	putHex

;		lda	$20
;		ldx	#$00
;		jsr	putChar

;		lda	eyeRotationXWork
;		ldx	#$00
;		jsr	putHex

;		lda	$20
;		ldx	#$00
;		jsr	putChar

;		lda	eyeRotationYWork
;		ldx	#$00
;		jsr	putHex

;		lda	$20
;		ldx	#$00
;		jsr	putChar

;		lda	eyeRotationZWork
;		ldx	#$00
;		jsr	putHex

;		lda	$20
;		ldx	#$00
;		jsr	putChar

;		lda	jumpIndex
;		ldx	#$00
;		jsr	putHex

;		lda	$20
;		ldx	#$00
;		jsr	putChar

;		lda	jumpCount
;		ldx	#$00
;		jsr	putHex

;		ldx	#0
;		ldy	#21
;		jsr	setWriteVramAddress

		;;;lda	pauseFlag
		;;;lda	gameOverFlag
		;;;lda	debug0
		;ldx	#$00
		;jsr	putHex

		;;;lda	debug1
		;ldx	#$00
		;jsr	putHex

;		lda	shipShield
;		ldx	#$00
;		jsr	putHex

;		lda	$20
;		ldx	#$00
;		jsr	putChar

;		lda	<padLast
;		ldx	#$00
;		jsr	putHex

;		lda	<padNow
;		ldx	#$00
;		jsr	putHex

;		lda	<padState
;		ldx	#$00
;		jsr	putHex

;		lda	<padState2
;		ldx	#$00
;		jsr	putHex

;;;;		lda	polygonTableCount
;;		ldx	#$00
;;		jsr	putHex
;
;		lda	#SUB0_PRG_BANK
;		ldx	#$00
;		jsr	putHex
;
;		lda	$20
;		ldx	#$00
;		jsr	putChar
;
;		tma	#SUB0_PRG_MAP
;		ldx	#$00
;		jsr	putHex



;		ldx	#0	;;;<--2029-09-15
;		ldy	#21
;		jsr	setWriteVramAddress
;
;		;;;lda	jumpCount
;		lda	jumpMaxCount
;		ldx	#$00
;		jsr	putHex
;
;		lda	jumpObjNo
;		ldx	#$00
;		jsr	putHex
;
;		lda	debug0
;		ldx	#$00
;		jsr	putHex


;----------------
;stage
		ldx	#7
		ldy	#18
		jsr	setWriteVramAddress

		lda	stageCount
		ora	#$30
		ldx	#0
		jsr	putChar


;;;<--
;		lda	groundY
;		ldx	#$00
;		jsr	putHex


		ldx	#8
		ldy	#19
		jsr	setWriteVramAddress

;;;<--		clx
;		lda	shipShield
;.putShieldJp:
;		cmp	#10
;		bcc	.putShieldEnd
;		sec
;		sbc	#10
;		inx
;		bra	.putShieldJp
;
;.putShieldEnd:
;		pha
;		txa
;		ora	#$30
;		ldx	#0
;		jsr	putChar
;
;		pla
;		ora	#$30
;		ldx	#0
;		jsr	putChar

		cly
		clx
.putShieldLoop0:
		cpy	shipShield
		bcs	.putShieldEnd0

		lda	.shildChrData, y
		jsr	setVramData
		iny

		bra	.putShieldLoop0
.putShieldEnd0:

		lda	#16
		sub	shipShield
		tay
.putShieldLoop1:
		dey
		bmi	.putShieldEnd1
		lda	#228
		jsr	setVramData

		bra	.putShieldLoop1
.putShieldEnd1:



		ldx	#6
		ldy	#20
		jsr	setWriteVramAddress

;;;<--		lda	subBaseCount
;		ora	#$30
;		ldx	#0
;		jsr	putChar


		cly
		clx
.putBaseLoop0:
		cpy	subBaseCount
		bcs	.putBaseEnd0

		lda	#232
		jsr	setVramData
		iny

		bra	.putBaseLoop0
.putBaseEnd0:

		lda	#4
		sub	subBaseCount
		tay
.putBaseLoop1:
		dey
		bmi	.putBaseEnd1
		lda	#228
		jsr	setVramData

		bra	.putBaseLoop1
.putBaseEnd1:




;----------------
		jsr	setVsyncFlag

;----------------
		jmp	.mainLoop

.exitJp:
;----------------
		sei

;----------------
		jsr	offScreen

		ply
		plx

		rts

.shildChrData	.db	224, 224, 224, 224, 226, 226, 226, 226, 225, 225, 225, 225, 227, 227, 227, 227


;----------------------------
checkPset:
;
		pha
		phx
		phy

;;;		cpx	#224-16
;		bcc	.jpEnd
;
;		cpx	#224+16
;		bcs	.jpEnd
;
;		cpy	#72-16
;		bcc	.jpEnd
;
;		cpy	#72+16
;		bcs	.jpEnd

;;;<--screen dot 32*32
;		cpx	#-16
;		bmi	.jpEnd
;
;		cpx	#16
;		bpl	.jpEnd
;
;		cpy	#-16
;		bmi	.jpEnd
;
;		cpy	#16
;		bpl	.jpEnd
;
;		pha
;
;		txa
;		add	#224
;		tax
;
;		tya
;		eor	#$FF
;		inc	a
;		add	#72
;		tay
;
;		pla
;
;		jsr	pset


;;;<--screen dot 64*64
;		cpx	#-32
;		bmi	.jpEnd
;
;		cpx	#32
;		bpl	.jpEnd
;
;		cpy	#-32
;		bmi	.jpEnd
;
;		cpy	#32
;		bpl	.jpEnd
;
;		pha
;
;		txa
;		add	#256-16-32
;		tax
;
;		tya
;		eor	#$FF
;		inc	a
;		add	#72
;		tay
;
;		pla
;
;		jsr	pset


;;<--screen dot 48*48
		cpx	#-24
		bmi	.jpEnd

		cpx	#24
		bpl	.jpEnd

		cpy	#-24
		bmi	.jpEnd

		cpy	#24
		bpl	.jpEnd

		pha

		txa
		add	#256-16-32
		tax

		tya
		eor	#$FF
		inc	a
		add	#72
		tay

		pla

		jsr	pset

.jpEnd:
		ply
		plx
		pla

		rts


;----------------------------
pset:
;
;;;<--		lda	#8
;		ldx	#0
;		ldy	#0

		pha
		phx
		phy

		sta	<psetWork6	;color
		stx	<psetWork4	;x
		sty	<psetWork5	;y

;アドレス計算
;元のバンクを退避しつつアドレス変換テーブルのあるバンクへ切り替え
;;;<--		tma	#2
;		pha
;		lda	#2
;		tam	#2

		txa
		lsr	a
		lsr	a
		lsr	a
		tax

		bbs0	<drawingNo, .jp00

		lda	_polyLineAddrConvXHigh, x
		ora	_polyLineAddrConvYHigh0, y
		sta	<psetAddr+1

		bra	.jp01

.jp00:
		lda	_polyLineAddrConvXHigh, x
		ora	_polyLineAddrConvYHigh1, y
		sta	<psetAddr+1

.jp01:
		lda	_polyLineAddrConvXLow, x
		ora	_polyLineAddrConvYLow, y
		sta	<psetAddr

;リードアドレスセット
		st0	#1
		lda	<psetAddr
		sta	VDC_2
		lda	<psetAddr+1
		sta	VDC_3

;CH0 CH1 リード
		st0	#2
		lda	VDC_2
		sta	<psetWork0
		lda	VDC_3
		sta	<psetWork1

;リードアドレス+8セット
		st0	#1
		clc
		lda	<psetAddr
		adc	#8
		sta	VDC_2
		lda	<psetAddr+1
		sta	VDC_3

;CH2 CH3 リード
		st0	#2
		lda	VDC_2
		sta	<psetWork2
		lda	VDC_3
		sta	<psetWork3


		lda	<psetWork4
		and	#7
		tay

		clx
.loop0:
		lda	<psetWork0, x
		and	.psetAndData, y
		lsr	<psetWork6
		bcc	.jp02

		ora	.psetOrData, y

.jp02:
		sta	<psetWork0, x

		inx
		cpx	#4
		bne	.loop0



;ライトアドレスセット
		st0	#0
		lda	<psetAddr
		sta	VDC_2
		lda	<psetAddr+1
		sta	VDC_3

		st0	#2
		lda	<psetWork0
		sta	VDC_2
		lda	<psetWork1
		sta	VDC_3


		st0	#0
		clc
		lda	<psetAddr
		adc	#8
		sta	VDC_2
		lda	<psetAddr+1
		sta	VDC_3

		st0	#2
		lda	<psetWork2
		sta	VDC_2
		lda	<psetWork3
		sta	VDC_3



;バンクを元に戻す
;;;<--		pla
;		tam	#2

		ply
		plx
		pla

		rts

.psetOrData	.db	$80, $40, $20, $10, $08, $04, $02, $01
.psetAndData	.db	$7F, $BF, $DF, $EF, $F7, $FB, $FD, $FE


;----------------------------
setStringSprite:
;横32 縦16 のスプライト
.loop:
		pha
		jsr	setSatBuffer
		pla

		dex
		beq	.jpEnd

		pha
		addw	<argw1, #32
		addw	<argw2, #$0004
		pla
		inc	a

		bra	.loop

.jpEnd:
		rts


;----------------------------
guideFunction:
;操作説明
;----------------
;clear BAT
		cla
		ldx	#$01
		jsr	clearBat

;set BAT
		jsr	setBat

;----------------
		jsr	initializeScreenVsync

;----------------
		lda	#DRAWING_NO_0_ADDR
		jsr	clearBuffer

		lda	#DRAWING_NO_1_ADDR
		jsr	clearBuffer

;----------------
		jsr	clearSat

;----------------
		ldx	#SCREEN_CENTER_X
		ldy	#SCREEN_CENTER_Y
		jsr	setScreenCenter

;----------------
		stz	stageFlag

		jsr	initializeSatBuffer

		mov	titleRotY, #128

;----------------
		jsr	onScreen

;----------------
		jsr	enableIrqVdc

;----------------
		jsr	setVsyncFlag

;----------------
		jsr	initializePad

;----------------
		jsr	initializePad2

;----------------
		cli

;----------------
.titleLoop:
		jsr	getRandom

		bbr3	<padState2, .jp00
		jmp	.exitJp

.jp00:
;----------------
		jsr	initializePad2

;----------------
		jsr	waitScreenVsync

;----------------
		jsr	initializePolygonAndSat


;----------------
;メッセージ描画
		ldx	#11
		ldy	#2
		jsr	setWriteVramAddress

		movw	<argw0, #.strGuide7
		mov	<arg2, #0
		jsr	putString

		ldx	#1
		ldy	#4
		jsr	setWriteVramAddress

		movw	<argw0, #.strGuide0
		mov	<arg2, #0
		jsr	putString

		ldx	#1
		ldy	#6
		jsr	setWriteVramAddress

		movw	<argw0, #.strGuide1
		mov	<arg2, #0
		jsr	putString

		ldx	#1
		ldy	#8
		jsr	setWriteVramAddress

		movw	<argw0, #.strGuide2
		mov	<arg2, #0
		jsr	putString

		ldx	#1
		ldy	#10
		jsr	setWriteVramAddress

		movw	<argw0, #.strGuide3
		mov	<arg2, #0
		jsr	putString

		ldx	#1
		ldy	#12
		jsr	setWriteVramAddress

		movw	<argw0, #.strGuide4
		mov	<arg2, #0
		jsr	putString

		ldx	#1
		ldy	#14
		jsr	setWriteVramAddress

		movw	<argw0, #.strGuide5
		mov	<arg2, #0
		jsr	putString

		ldx	#1
		ldy	#16
		jsr	setWriteVramAddress

		movw	<argw0, #.strGuide6
		mov	<arg2, #0
		jsr	putString

;PUSH RUN
		movw	<argw0, #72+32+64+32
		movw	<argw1, #128-44+32
		movw	<argw2, #$0220
		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
		lda	#4
		ldx	#3
		jsr	setStringSprite

		lda	#0
		jsr	setPolygonColorIndex

		movw	<eyeTranslationX, #0
		movw	<eyeTranslationY, #0
		movw	<eyeTranslationZ, #0
		mov	<eyeRotationX, #0
		mov	<eyeRotationY, #0
		mov	<eyeRotationZ, #0
		mov	<eyeRotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y

		movw	<translationX, #0
		movw	<translationY, #0
		movw	<translationZ, #225
		mov	<rotationX, #0
		mov	<rotationY, titleRotY
		mov	<rotationZ, #0
		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y
		movw	<modelAddress, #modelTitle
		;;;jsr	setModelRotation

		inc	titleRotY

;----------------
		jsr	switchClearBuffer

;----------------
		jsr	setSatToVram

;----------------
		jsr	putPolygonBuffer

;----------------
		jsr	setVsyncFlag

;----------------
		jmp	.titleLoop

.exitJp:
;----------------
		sei

;----------------
		jsr	offScreen

		rts


.strGuide0	.db	$93, $94, $CE, $DE, $C0, $DD, $E3, $DE, $EF, $94, $ED, $92, $E4, $DE, $93,\
			$9D, $F9, $F6, $00								;うえﾎﾞﾀﾝでまえへいどうするよ

.strGuide1	.db	$9C, $E0, $CE, $DE, $C0, $DD, $E3, $DE, $93, $9C, $FB, $ED, $92, $E4, $DE,\
			$93, $9D, $F9, $F6, $00								;したﾎﾞﾀﾝでうしろへいどうするよ

.strGuide2	.db	$EB, $E0, $DE, $F8, $CE, $DE, $C0, $DD, $E3, $DE, $EB, $E0, $DE, $F8, $ED,\
			$F1, $97, $86, $96, $94, $F9, $F6, $00						;ひだりﾎﾞﾀﾝでひだりへむきをかえるよ

.strGuide3	.db	$F0, $97, $DE, $CE, $DE, $C0, $DD, $E3, $DE, $F0, $97, $DE, $ED, $F1, $97,\
			$86, $96, $94, $F9, $F6, $00							;みぎﾎﾞﾀﾝでみぎへむきをかえるよ

.strGuide4	.db	$31, $CE, $DE, $C0, $DD, $E3, $DE, $BC, $DE, $AC, $DD, $CC, $DF, $20, $32,\
			$CE, $DE, $C0, $DD, $E3, $DE, $BC, $AE, $AF, $C4, $E0, $DE, $F6, $00		;1ﾎﾞﾀﾝでｼﾞｬﾝﾌﾟ 2ﾎﾞﾀﾝでｼｮｯﾄだよ

.strGuide5	.db	$32, $CE, $DE, $C0, $DD, $86, $95, $9C, $E0, $EF, $EF, $E3, $DE, $20, $EB,\
			$E0, $DE, $F8, $ED, $F0, $97, $DE, $ED, $92, $E4, $DE, $93, $9D, $F9, $F6, $00	;2ﾎﾞﾀﾝをおしたままで ひだりへみぎへいどうするよ

.strGuide6	.db	$98, $93, $E1, $8D, $93, $E3, $DE, $32, $96, $92, $BC, $DE, $AC, $DD, $CC,\
			$DF, $E3, $DE, $97, $F9, $F6, $00						;くうちゅうで2かいｼﾞｬﾝﾌﾟできるよ

.strGuide7	.db	$9F, $93, $9B, $9E, $E2, $F2, $92, $E0, $DE, $F6, $00				;そうさせつめいだよ



;----------------------------
endingFunction
;エンディング
;----------------
;clear BAT
		cla
		ldx	#$01
		jsr	clearBat

;set BAT
		jsr	setBat

;----------------
		jsr	initializeScreenVsync

;----------------
		lda	#DRAWING_NO_0_ADDR
		jsr	clearBuffer

		lda	#DRAWING_NO_1_ADDR
		jsr	clearBuffer

;----------------
		jsr	clearSat

;----------------
		ldx	#SCREEN_CENTER_X
		ldy	#SCREEN_CENTER_Y
		jsr	setScreenCenter

;----------------
		stz	stageFlag

		jsr	initializeSatBuffer

		mov	titleRotY, #128

;----------------
		jsr	onScreen

;----------------
		jsr	enableIrqVdc

;----------------
		jsr	setVsyncFlag

;----------------
		jsr	initializePad

;----------------
		jsr	initializePad2

;----------------
		cli

;----------------
.titleLoop:
		jsr	getRandom

		bbr3	<padState2, .jp00
		jmp	.exitJp

.jp00:
;----------------
		jsr	initializePad2

;----------------
		jsr	waitScreenVsync

;----------------
		jsr	initializePolygonAndSat


;----------------
;メッセージ描画
		ldx	#8
		ldy	#2
		jsr	setWriteVramAddress

		movw	<argw0, #.strEnding0
		mov	<arg2, #0
		jsr	putString

		ldx	#7
		ldy	#4
		jsr	setWriteVramAddress

		movw	<argw0, #.strEnding1
		mov	<arg2, #0
		jsr	putString


;PUSH RUN
		movw	<argw0, #72+32+64
		movw	<argw1, #128-44+32
		movw	<argw2, #$0220
		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
		lda	#4
		ldx	#3
		jsr	setStringSprite

		lda	#0
		jsr	setPolygonColorIndex

		movw	<eyeTranslationX, #0
		movw	<eyeTranslationY, #0
		movw	<eyeTranslationZ, #0
		mov	<eyeRotationX, #0
		mov	<eyeRotationY, #0
		mov	<eyeRotationZ, #0
		mov	<eyeRotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y

		movw	<translationX, #0
		movw	<translationY, #-100
		movw	<translationZ, #460
		mov	<rotationX, #0
		mov	<rotationY, titleRotY
		mov	<rotationZ, #128+32
		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y

		lda	titleRotY
		;;;rol	a
		;rol	a
		;rol	a
		;rol	a
		lsr	a
		and	#6
		tax
		lda	.modelAddr, x
		sta	<modelAddress
		lda	.modelAddr +1, x
		sta	<modelAddress+1

;;;		bne	.model2
;		movw	<modelAddress, #modelEnemy3_0
;		bra	.modelEnd
;
;.model2:
;		cmp	#1
;		bne	.model3
;		movw	<modelAddress, #modelEnemy3_1
;		bra	.modelEnd
;
;.model3:
;		cmp	#2
;		bne	.model4
;		movw	<modelAddress, #modelEnemy3_0
;		bra	.modelEnd
;
;.model4:
;		movw	<modelAddress, #modelEnemy3_2

		jsr	setModelRotation

		movw	<translationX, #-400
		movw	<translationY, #-100
		movw	<translationZ, #800
		mov	<rotationX, #0-16
		add	<rotationY, titleRotY, #85
		mov	<rotationZ, #128

		lda	titleRotY
		lsr	a
		lsr	a
		and	#6
		tax
		lda	.modelAddr, x
		sta	<modelAddress
		lda	.modelAddr +1, x
		sta	<modelAddress+1

		jsr	setModelRotation

		movw	<translationX, #400
		movw	<translationY, #-100
		movw	<translationZ, #800
		mov	<rotationX, #0-16
		add	<rotationY, titleRotY, #170
		mov	<rotationZ, #128-32

		lda	titleRotY
		and	#6
		tax
		lda	.modelAddr, x
		sta	<modelAddress
		lda	.modelAddr +1, x
		sta	<modelAddress+1

		jsr	setModelRotation


		inc	titleRotY

;----------------
		jsr	switchClearBuffer

;----------------
		jsr	setSatToVram

;----------------
		jsr	putPolygonBuffer

;----------------
		jsr	setVsyncFlag

;----------------
		jmp	.titleLoop

.exitJp:
;----------------
		sei

;----------------
		jsr	offScreen

		rts


.modelAddr	.dw	modelEnemy3_0, modelEnemy3_1, modelEnemy3_0, modelEnemy3_2

.strEnding0	.db	"CONGRATULATIONS", $00
.strEnding1	.db	$BD, $C0, $BD, $C0, $9E, $92, $9C, $DE, $FD, $86, $F4, $8F, $E2, $99, $E0, $F6, $21, $21, $00	;ｽﾀｽﾀせいじんをやっつけたよ!!



;----------------------------
ruleFunction:
;ルール説明
;----------------
;clear BAT
		cla
		ldx	#$01
		jsr	clearBat

;set BAT
		jsr	setBat

;----------------
		jsr	initializeScreenVsync

;----------------
		lda	#DRAWING_NO_0_ADDR
		jsr	clearBuffer

		lda	#DRAWING_NO_1_ADDR
		jsr	clearBuffer

;----------------
		jsr	clearSat

;----------------
		ldx	#SCREEN_CENTER_X
		ldy	#SCREEN_CENTER_Y
		jsr	setScreenCenter

;----------------
;debug
;;;		lda	#60
;		sta	frameCount
;		stz	drawCount
;		stz	drawCountWork

;----------------
;debug
;;;		ldx	#0
;		ldy	#18
;		jsr	setWriteVramAddress
;
;		lda	#$30
;		ldx	#$00
;		jsr	putChar
;
;		mov	<drawingNo, #DRAWING_NO_1
;
;		ldx	#0
;		ldy	#18
;		jsr	setWriteVramAddress
;
;		lda	#$31
;		ldx	#$00
;		jsr	putChar
;
;		mov	<drawingNo, #DRAWING_NO_0

;----------------
		stz	stageFlag

		jsr	initializeSatBuffer

		mov	titleRotY, #128

;----------------
		jsr	onScreen

;----------------
		jsr	enableIrqVdc

;----------------
		;;;<--jsr	setEyeWork

;----------------
		;;;<--jsr	setPolygonWork

;----------------
		jsr	setVsyncFlag

;----------------
		jsr	initializePad

;----------------
		jsr	initializePad2

		;;;<--mov	<padNow, #$08

;----------------
;;;<--		lda	#CG_DATA_BANK
;		tam	#SUB2_PRG_MAP
;
;		;;;<--movw	<argw0, #$4000
;		;movw	<argw1, #$0043
;		;movw	<argw2, #$0060
;		;mov	<arg6, #$00
;		;jsr	setCgToSgData
;
;		movw	<setCgtoSgStrAddr, #strPUSH_RUN
;		movw	setCgtoSgWorkW0, #$4000
;		;;;movw	setCgtoSgWorkW1, #$0070
;		;;;movw	setCgtoSgWorkW1, #$0240
;		movw	setCgtoSgWorkW1, #$0220
;		mov	setCgtoSgWork0, #$00
;		jsr	setStrToSg2
;
;		lda	#SUB2_PRG_BANK
;		tam	#SUB2_PRG_MAP

;----------------
		cli

;----------------
.titleLoop:
		jsr	getRandom

		;;;bbr3	<padNow, .jp00
		;;;bbr3	<padState, .jp00
		bbr3	<padState2, .jp00
		jmp	.exitJp

.jp00:
;----------------
		jsr	initializePad2

;----------------
		jsr	waitScreenVsync

;----------------
		jsr	initializePolygonAndSat

;----------------
;ルール説明描画
		ldx	#10
		ldy	#2
		jsr	setWriteVramAddress

		movw	<argw0, #.strRule0
		mov	<arg2, #0
		jsr	putString

		ldx	#7
		ldy	#4
		jsr	setWriteVramAddress

		movw	<argw0, #.strRule1
		mov	<arg2, #0
		jsr	putString

		ldx	#2
		ldy	#6
		jsr	setWriteVramAddress

		movw	<argw0, #.strRule2
		mov	<arg2, #0
		jsr	putString

		ldx	#3
		ldy	#8
		jsr	setWriteVramAddress

		movw	<argw0, #.strRule3
		mov	<arg2, #0
		jsr	putString


;PUSH RUN
		movw	<argw0, #72+32+64
		movw	<argw1, #128-44+32
		movw	<argw2, #$0220
		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
		lda	#4
		ldx	#3
		jsr	setStringSprite

		lda	#0
		jsr	setPolygonColorIndex

		movw	<eyeTranslationX, #0
		movw	<eyeTranslationY, #0
		movw	<eyeTranslationZ, #0
		mov	<eyeRotationX, #0
		mov	<eyeRotationY, #0
		mov	<eyeRotationZ, #0
		mov	<eyeRotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y

		movw	<translationX, #-1000
		movw	<translationY, #-780
		movw	<translationZ, #2000
		mov	<rotationX, #0
		mov	<rotationY, titleRotY
		mov	<rotationZ, #0
		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y
		movw	<modelAddress, #modelEnemy0_0
		jsr	setModelRotation

;;;<--
;		movw	<translationX, #-1000
;		movw	<translationY, #-1000
;		movw	<translationZ, #2000
;		mov	<rotationX, #0
;		mov	<rotationY, titleRotY
;		mov	<rotationZ, #128
;		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y
;		movw	<modelAddress, #modelEnemy0_0
;		jsr	setModelRotation

		movw	<translationX, #1000
		movw	<translationY, #-780
		movw	<translationZ, #2000
		mov	<rotationX, #0
		mov	<rotationY, titleRotY
		mov	<rotationZ, #0
		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y
		movw	<modelAddress, #modelEnemy1_0
		jsr	setModelRotation

		inc	titleRotY

;----------------
		jsr	switchClearBuffer

;----------------
		jsr	setSatToVram

;----------------
		jsr	putPolygonBuffer

;----------------
;debug
;;;		inc	drawCountWork
;
;		ldx	#0
;		ldy	#19
;		jsr	setWriteVramAddress
;
;		lda	drawCount
;		ldx	#$00
;		jsr	putHex

;----------------
		jsr	setVsyncFlag

;----------------
		jmp	.titleLoop

.exitJp:
;----------------
		sei

;----------------
		jsr	offScreen

		rts

.strRule0	.db	$D9, $B0, $D9, $9E, $E2, $F2, $92, $E0, $DE, $F6, $00								;ﾙｰﾙせつめいだよ
.strRule1	.db	$F0, $E4, $DE, $F8, $E9, $EE, $93, $E0, $DE, $92, $86, $34, $E2, $EA, $96, $92, $9C, $E3, $00			;みどりのほうだいを4つはかいして
.strRule2	.db	$91, $96, $92, $EE, $93, $E0, $DE, $92, $86, $EA, $96, $92, $9D, $FA, $EA, $DE, $BD, $C3, $B0, $BC, $DE,\	;あかいほうだいをはかいすればｽﾃｰｼﾞｸﾘｱだよ
			$B8, $D8, $B1, $E0, $DE, $F6, $00
.strRule3	.db	$BC, $B0, $D9, $C4, $DE, $96, $DE, $E5, $98, $E5, $FA, $EA, $DE, $B9, $DE, $B0, $D1, $B5, $B0, $CA, $DE,\	;ｼｰﾙﾄﾞがなくなればｹﾞｰﾑｵｰﾊﾞｰだよ
			$B0, $E0, $DE, $F6, $00



;----------------------------
titleFunction:
;タイトル
;;;<--
;----------------
;clear BAT
		cla
		ldx	#$01
		jsr	clearBat

;set BAT
		jsr	setBat

;----------------
		jsr	initializeScreenVsync

;----------------
		lda	#DRAWING_NO_0_ADDR
		jsr	clearBuffer

		lda	#DRAWING_NO_1_ADDR
		jsr	clearBuffer

;----------------
		jsr	clearSat

;----------------
		ldx	#SCREEN_CENTER_X
		ldy	#SCREEN_CENTER_Y
		jsr	setScreenCenter

;----------------
;debug
;;;		lda	#60
;		sta	frameCount
;		stz	drawCount
;		stz	drawCountWork

;----------------
;debug
;;;		ldx	#0
;		ldy	#18
;		jsr	setWriteVramAddress
;
;		lda	#$30
;		ldx	#$00
;		jsr	putChar
;
;		mov	<drawingNo, #DRAWING_NO_1
;
;		ldx	#0
;		ldy	#18
;		jsr	setWriteVramAddress
;
;		lda	#$31
;		ldx	#$00
;		jsr	putChar
;
;		mov	<drawingNo, #DRAWING_NO_0


;----------------
;copy right
		mov	<drawingNo, #DRAWING_NO_0

		ldx	#7
		ldy	#18
		jsr	setWriteVramAddress

		movw	<argw0, #strCOPYRIGHT
		mov	<arg2, #0
		jsr	putString

		ldx	#26
		ldy	#19
		jsr	setWriteVramAddress

		movw	<argw0, #strVERSION
		mov	<arg2, #0
		jsr	putString

		mov	<drawingNo, #DRAWING_NO_1

		ldx	#7
		ldy	#18
		jsr	setWriteVramAddress

		movw	<argw0, #strCOPYRIGHT
		mov	<arg2, #0
		jsr	putString

		ldx	#26
		ldy	#19
		jsr	setWriteVramAddress

		movw	<argw0, #strVERSION
		mov	<arg2, #0
		jsr	putString



;;;<--
;		movw	<clip2dWorkX0, #-1
;		movw	<clip2dWorkY0, #1
;
;		movw	<clip2dWorkX1, #1
;		movw	<clip2dWorkY1, #1
;
;		mov	<clip2dWork0, #0
;
;		jsr	clip2dX
;
;
;		ldx	#0
;		ldy	#20
;		jsr	setWriteVramAddress
;
;		lda	<clip2dWorkA+1
;		ldx	#$00
;		jsr	putHex
;
;		lda	<clip2dWorkA
;		ldx	#$00
;		jsr	putHex
;
;
;		ldx	#6
;		ldy	#20
;		jsr	setWriteVramAddress
;
;		lda	<clip2dWorkB+1
;		ldx	#$00
;		jsr	putHex
;
;		lda	<clip2dWorkB
;		ldx	#$00
;		jsr	putHex



		mov	<drawingNo, #DRAWING_NO_0


;----------------
		stz	stageFlag

		jsr	initializeSatBuffer

		mov	titleRotY, #128

;----------------
		jsr	onScreen



;;;<--
;.loopEx:
;		bra	.loopEx



;----------------
		jsr	enableIrqVdc

;----------------
		;;;<--jsr	setEyeWork

;----------------
		;;;<--jsr	setPolygonWork

;----------------
		jsr	setVsyncFlag

;----------------
		jsr	initializePad

;----------------
		jsr	initializePad2

		;;;<--mov	<padNow, #$08

;----------------
;;;<--		lda	#CG_DATA_BANK
;		tam	#SUB2_PRG_MAP
;
;		;;;<--movw	<argw0, #$4000
;		;movw	<argw1, #$0043
;		;movw	<argw2, #$0060
;		;mov	<arg6, #$00
;		;jsr	setCgToSgData
;
;		movw	<setCgtoSgStrAddr, #strPUSH_RUN
;		movw	setCgtoSgWorkW0, #$4000
;		;;;movw	setCgtoSgWorkW1, #$0070
;		;;;movw	setCgtoSgWorkW1, #$0240
;		movw	setCgtoSgWorkW1, #$0220
;		mov	setCgtoSgWork0, #$00
;		jsr	setStrToSg2
;
;		lda	#SUB2_PRG_BANK
;		tam	#SUB2_PRG_MAP

;----------------
		cli

;----------------
.titleLoop:
		jsr	getRandom

		;;;bbr3	<padNow, .jp00
		;;;bbr3	<padState, .jp00
		bbr3	<padState2, .jp00
		jmp	.exitJp

.jp00:
;----------------
		jsr	initializePad2

;----------------
		jsr	waitScreenVsync

;----------------
		jsr	initializePolygonAndSat

;TILTE
		movw	<argw0, #72-8+64
		movw	<argw1, #128-64+32
		movw	<argw2, #$0060
		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
		lda	#0
		ldx	#4
		jsr	setStringSprite

;;;<--		movw	<argw0, #72-8+64
;		movw	<argw1, #128-64+32
;		movw	<argw2, #$0060
;		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
;		lda	#0
;		jsr	setSatBuffer
;
;		movw	<argw0, #72-8+64
;		movw	<argw1, #128-32+32
;		movw	<argw2, #$0064
;		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
;		lda	#1
;		jsr	setSatBuffer
;
;		movw	<argw0, #72-8+64
;		movw	<argw1, #128+32
;		movw	<argw2, #$0068
;		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
;		lda	#2
;		jsr	setSatBuffer
;
;		movw	<argw0, #72-8+64
;		movw	<argw1, #128+32+32
;		movw	<argw2, #$006C
;		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
;		lda	#3
;		jsr	setSatBuffer

;PUSH RUN
		movw	<argw0, #72+32+64
		movw	<argw1, #128-44+32
		movw	<argw2, #$0220
		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
		lda	#4
		ldx	#3
		jsr	setStringSprite

;;;<--		movw	<argw0, #72+32+64
;		movw	<argw1, #128-44+32
;		;;;movw	<argw2, #$0070
;		;;;movw	<argw2, #$0240
;		movw	<argw2, #$0220
;		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
;		lda	#4
;		jsr	setSatBuffer
;
;		movw	<argw0, #72+32+64
;		movw	<argw1, #128-44+32+32
;		;;;movw	<argw2, #$0074
;		;;;movw	<argw2, #$0244
;		movw	<argw2, #$0224
;		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
;		lda	#5
;		jsr	setSatBuffer
;
;		movw	<argw0, #72+32+64
;		movw	<argw1, #128-44+64+32
;		;;;movw	<argw2, #$0078
;		;;;movw	<argw2, #$0248
;		movw	<argw2, #$0228
;		movw	<argw3, #SP_ATTR_CGY_1 + SP_ATTR_CGX_2 + SP_ATTR_FOREGROUND + 0	;0 palette no
;		lda	#6
;		jsr	setSatBuffer

		lda	#0
		jsr	setPolygonColorIndex

		movw	<eyeTranslationX, #0
		;;;movw	<eyeTranslationY, #-25
		movw	<eyeTranslationY, #0
		movw	<eyeTranslationZ, #0
		mov	<eyeRotationX, #0
		mov	<eyeRotationY, #0
		mov	<eyeRotationZ, #0
		mov	<eyeRotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y

		movw	<translationX, #0
		;;;movw	<translationY, #0
		movw	<translationY, #20
		movw	<translationZ, #225
		;;;movw	<translationZ, #280
		mov	<rotationX, #0
		mov	<rotationY, titleRotY
		mov	<rotationZ, #0
		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y
		movw	<modelAddress, #modelTitle
		jsr	setModelRotation

;;;<--
		movw	<translationX, #0
		movw	<translationY, #-170
		;;;movw	<translationZ, #225
		movw	<translationZ, #280
		mov	<rotationX, #16
		mov	<rotationY, titleRotY
		mov	<rotationZ, #128
		;;;mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_X + ROT_THIRD_Y
		mov	<rotationSelect, #ROT_FIRST_Z + ROT_SECOND_Y + ROT_THIRD_X
		movw	<modelAddress, #modelTitleMirror
		jsr	setModelRotation

		inc	titleRotY

;----------------
		jsr	switchClearBuffer

;----------------
		jsr	setSatToVram

;----------------
		jsr	putPolygonBuffer

;----------------
;debug print
;;;		inc	drawCountWork
;
;		ldx	#0
;		ldy	#19
;		jsr	setWriteVramAddress
;
;		lda	drawCount
;		ldx	#$00
;		jsr	putHex

;;;		ldx	#0
;		ldy	#20
;		jsr	setWriteVramAddress
;
;		lda	eyeTranslationXWork+1
;		ldx	#$00
;		jsr	putHex
;
;		lda	eyeTranslationXWork
;		ldx	#$00
;		jsr	putHex
;
;		lda	$20
;		ldx	#$00
;		jsr	putChar
;
;		lda	eyeTranslationYWork+1
;		ldx	#$00
;		jsr	putHex
;
;		lda	eyeTranslationYWork
;		ldx	#$00
;		jsr	putHex
;
;		lda	$20
;		ldx	#$00
;		jsr	putChar
;
;		lda	eyeTranslationZWork+1
;		ldx	#$00
;		jsr	putHex
;
;		lda	eyeTranslationZWork
;		ldx	#$00
;		jsr	putHex
;
;		lda	$20
;		ldx	#$00
;		jsr	putChar
;
;		lda	eyeRotationXWork
;		ldx	#$00
;		jsr	putHex
;
;		lda	$20
;		ldx	#$00
;		jsr	putChar

;		lda	eyeRotationYWork
;		ldx	#$00
;		jsr	putHex
;
;		lda	$20
;		ldx	#$00
;		jsr	putChar
;
;		lda	eyeRotationZWork
;		ldx	#$00
;		jsr	putHex
;
;		lda	$20
;		ldx	#$00
;		jsr	putChar
;
;		lda	jumpIndex
;		ldx	#$00
;		jsr	putHex
;
;		lda	$20
;		ldx	#$00
;		jsr	putChar
;
;		lda	jumpCount
;		ldx	#$00
;		jsr	putHex

;		ldx	#0
;		ldy	#21
;		jsr	setWriteVramAddress

;;;;		lda	polygonTableCount
;;		ldx	#$00
;;		jsr	putHex
;
;		lda	#SUB0_PRG_BANK
;		ldx	#$00
;		jsr	putHex
;
;		lda	$20
;		ldx	#$00
;		jsr	putChar
;
;		tma	#SUB0_PRG_MAP
;		ldx	#$00
;		jsr	putHex

;		lda	shipShield
;		ldx	#$00
;		jsr	putHex

;		lda	$20
;		ldx	#$00
;		jsr	putChar

;		lda	<padLast
;		ldx	#$00
;		jsr	putHex

;		lda	<padNow
;		ldx	#$00
;		jsr	putHex

;		lda	<padState
;		ldx	#$00
;		jsr	putHex

;		lda	<padState2
;		ldx	#$00
;		jsr	putHex

;----------------
		jsr	setVsyncFlag

;----------------
		jmp	.titleLoop

.exitJp:
;----------------
		sei

;----------------
		jsr	offScreen

		rts


;----------------------------
setStrToSg2:
;文字数は４の倍数
		phy

		cly

		lda	setCgtoSgWorkW1
		asl	a
		rol	setCgtoSgWorkW1+1
		asl	a
		rol	setCgtoSgWorkW1+1
		asl	a
		rol	setCgtoSgWorkW1+1
		asl	a
		rol	setCgtoSgWorkW1+1
		asl	a
		rol	setCgtoSgWorkW1+1
		sta	setCgtoSgWorkW1

		st0	#$00
		movw	VDC_2, setCgtoSgWorkW1

.loop0:
		lda	[setCgtoSgStrAddr], y
		jeq	.jpEnd

;1st character
		stz	<setCgtoSgStrW0
		lsr	a
		ror	<setCgtoSgStrW0
		lsr	a
		ror	<setCgtoSgStrW0
		lsr	a
		ror	<setCgtoSgStrW0
		sta	<setCgtoSgStrW0+1

		addw	<setCgtoSgStrW0, setCgtoSgWorkW0

;2nd character
		iny

		lda	[setCgtoSgStrAddr], y

		stz	<setCgtoSgStrW1
		lsr	a
		ror	<setCgtoSgStrW1
		lsr	a
		ror	<setCgtoSgStrW1
		lsr	a
		ror	<setCgtoSgStrW1
		sta	<setCgtoSgStrW1+1

		addw	<setCgtoSgStrW1, setCgtoSgWorkW0

;3rd character
		iny

		lda	[setCgtoSgStrAddr], y

		stz	<setCgtoSgStrW2
		lsr	a
		ror	<setCgtoSgStrW2
		lsr	a
		ror	<setCgtoSgStrW2
		lsr	a
		ror	<setCgtoSgStrW2
		sta	<setCgtoSgStrW2+1

		addw	<setCgtoSgStrW2, setCgtoSgWorkW0

;4th character
		iny

		lda	[setCgtoSgStrAddr], y

		stz	<setCgtoSgStrW3
		lsr	a
		ror	<setCgtoSgStrW3
		lsr	a
		ror	<setCgtoSgStrW3
		lsr	a
		ror	<setCgtoSgStrW3
		sta	<setCgtoSgStrW3+1

		addw	<setCgtoSgStrW3, setCgtoSgWorkW0

		st0	#$02

		phy

		cly
.loopP0A:
		lda	[setCgtoSgStrW1], y
		sta	VDC_2

		lda	[setCgtoSgStrW0], y
		sta	VDC_3

		iny
		iny
		cpy	#16
		bne	.loopP0A

		cly
.loopP0B:
		lda	[setCgtoSgStrW3], y
		sta	VDC_2

		lda	[setCgtoSgStrW2], y
		sta	VDC_3

		iny
		iny
		cpy	#16
		bne	.loopP0B


		ldy	#1
.loopP1A:
		lda	[setCgtoSgStrW1], y
		sta	VDC_2

		lda	[setCgtoSgStrW0], y
		sta	VDC_3

		iny
		iny
		cpy	#17
		bne	.loopP1A

		ldy	#1
.loopP1B:
		lda	[setCgtoSgStrW3], y
		sta	VDC_2

		lda	[setCgtoSgStrW2], y
		sta	VDC_3

		iny
		iny
		cpy	#17
		bne	.loopP1B


		ldy	#16
.loopP2A:
		lda	[setCgtoSgStrW1], y
		sta	VDC_2

		lda	[setCgtoSgStrW0], y
		sta	VDC_3

		iny
		iny
		cpy	#32
		bne	.loopP2A

		ldy	#16
.loopP2B:
		lda	[setCgtoSgStrW3], y
		sta	VDC_2

		lda	[setCgtoSgStrW2], y
		sta	VDC_3

		iny
		iny
		cpy	#32
		bne	.loopP2B


		ldy	#17
.loopP3A:
		lda	[setCgtoSgStrW1], y
		sta	VDC_2

		lda	[setCgtoSgStrW0], y
		sta	VDC_3

		iny
		iny
		cpy	#33
		bne	.loopP3A

		ldy	#17
.loopP3B:
		lda	[setCgtoSgStrW3], y
		sta	VDC_2

		lda	[setCgtoSgStrW2], y
		sta	VDC_3

		iny
		iny
		cpy	#33
		bne	.loopP3B

		ply
		iny

		jmp	.loop0

.jpEnd:
		ply
		rts


;----------------------------
_setStrToSg2:
;
		phy

		cly

		lda	setCgtoSgWorkW1
		asl	a
		rol	setCgtoSgWorkW1+1
		asl	a
		rol	setCgtoSgWorkW1+1
		asl	a
		rol	setCgtoSgWorkW1+1
		asl	a
		rol	setCgtoSgWorkW1+1
		asl	a
		rol	setCgtoSgWorkW1+1
		sta	setCgtoSgWorkW1

.loop0:
		lda	[setCgtoSgStrAddr], y
		jeq	.jpEnd

		stz	<setCgtoSgStrW0
		lsr	a
		ror	<setCgtoSgStrW0
		lsr	a
		ror	<setCgtoSgStrW0
		lsr	a
		ror	<setCgtoSgStrW0
		sta	<setCgtoSgStrW0+1

		addw	<setCgtoSgStrW0, setCgtoSgWorkW0

		movw	<setCgtoSgStrW0, #$4820

		iny

		lda	[setCgtoSgStrAddr], y

		stz	<setCgtoSgStrW1
		lsr	a
		ror	<setCgtoSgStrW1
		lsr	a
		ror	<setCgtoSgStrW1
		lsr	a
		ror	<setCgtoSgStrW1
		sta	<setCgtoSgStrW1+1

		addw	<setCgtoSgStrW1, setCgtoSgWorkW0

		st0	#$00
		;;;movw	VDC_2, setCgtoSgWorkW1
		movw	VDC_2, #$0E00

		st0	#$02

		phy

		cly
.loopP0A:
		;;;lda	[setCgtoSgStrW0], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_2

		;;;lda	[setCgtoSgStrW1], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_3

		iny
		iny
		cpy	#16
		bne	.loopP0A

		cly
.loopP0B:
		;;;lda	[setCgtoSgStrW0], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_2

		;;;lda	[setCgtoSgStrW1], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_3

		iny
		iny
		cpy	#16
		bne	.loopP0B


		ldy	#1
.loopP1A:
		;;;lda	[setCgtoSgStrW0], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_2

		;;;lda	[setCgtoSgStrW1], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_3

		iny
		iny
		cpy	#17
		bne	.loopP1A

		ldy	#1
.loopP1B:
		;;;lda	[setCgtoSgStrW0], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_2

		;;;lda	[setCgtoSgStrW1], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_3

		iny
		iny
		cpy	#17
		bne	.loopP1B


		ldy	#16
.loopP2A:
		;;;lda	[setCgtoSgStrW0], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_2

		;;;lda	[setCgtoSgStrW1], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_3

		iny
		iny
		cpy	#32
		bne	.loopP2A

		ldy	#16
.loopP2B:
		;;;lda	[setCgtoSgStrW0], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_2

		;;;lda	[setCgtoSgStrW1], y
		;;;lda	$4820, y
		lda	.chrData, y
		sta	VDC_3

		iny
		iny
		cpy	#32
		bne	.loopP2B


		ldy	#17
.loopP3A:
		;;;lda	[setCgtoSgStrW0], y
		lda	$4820, y
		sta	VDC_2

		;;;lda	[setCgtoSgStrW1], y
		lda	$4820, y
		sta	VDC_3

		iny
		iny
		cpy	#33
		bne	.loopP3A

		ldy	#17
.loopP3B:
		;;;lda	[setCgtoSgStrW0], y
		lda	$4820, y
		sta	VDC_2

		;;;lda	[setCgtoSgStrW1], y
		lda	$4820, y
		sta	VDC_3

		iny
		iny
		cpy	#33
		bne	.loopP3B


.jpLoop0End:
		ply


		;;;bra	.loop0

.jpEnd:
		ply
		rts


.chrData
;;;		.db	$01, $02, $04, $08, $10, $20, $40, $80, $02, $04, $08, $01, $20, $40, $80, $10
;		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

		.db	$3C, $3C, $3C, $3C, $7E, $7E, $7E, $7E, $FF, $FF, $FF, $FF, $FF, $FF, $E7, $E7
		.db	$38, $38, $38, $38, $6C, $6C, $6C, $6C, $C6, $C6, $FE, $FE, $C6, $C6, $00, $00

;----------------------------
setStrToSg:
;
		phy

		cly

.loop0:
		lda	[setCgtoSgStrAddr], y
		beq	.jpEnd

		sta	<argw1
		stz	<argw1+1

		movw	<argw0, setCgtoSgWorkW0
		movw	<argw2, setCgtoSgWorkW1
		mov	<arg6, setCgtoSgWork0
		jsr	setCgToSgData

		iny

		lda	[setCgtoSgStrAddr], y
		beq	.jpEnd

		sta	<argw1
		stz	<argw1+1

		movw	<argw0, setCgtoSgWorkW0
		movw	<argw2, setCgtoSgWorkW1
		lda	setCgtoSgWork0
		ora	#$01
		sta	<arg6
		jsr	setCgToSgData

		iny

		addw	setCgtoSgWorkW1, #2

		bra	.loop0

.jpEnd:
		ply
		rts


;;;strPUSH_RUN	.db	" PUSH RUN   ", $00
;;;strSTAGE_START	.db	"STAGE START ", $00
;;;strSTAGE_CLEAR	.db	"STAGE CLEAR ", $00
;;;strGAME_OVER	.db	" GAME OVER  ", $00
;;;strPAUSE	.db	"   PAUSE    ", $00

strPUSH_RUN	.db	"   P  US  H   RU  N     ", $00
strSTAGE_START	.db	"  ST  AG  E   ST  AR  T ", $00
strSTAGE_CLEAR	.db	"  ST  AG  E   CL  EA  R ", $00
strGAME_OVER	.db	"   G  AM  E   OV  ER    ", $00
strPAUSE	.db	"       P  AU  SE        ", $00
strEVENT	.db	"       !  ?!  ?         ", $00

strCOPYRIGHT	.db	"(C) 2024 GORIMUCHU", $00
strVERSION	.db	"0.9.9", $00

strSTAGE	.db	"STAGE", $00
strSHIELD	.db	"SHIELD", $00
strBASE		.db	"BASE", $00

;SP CHAR NO
;strPUSH_RUN	$0220, $0224, $0228
;strSTAGE_START	$0230 
;strSTAGE_CLEAR $0240
;strGAME_OVER	$0250
;strPAUSE	$0260
;$0220-$0270
;$03A0-$03F0

;;;<--
;----------------------------
;eventProc:
;;A:event No.
;
;		rts
;
;		phx
;
;		cmp	$FF
;		jeq	.eventEnd
;
;		asl	a
;		asl	a
;
;		tax
;
;		phx
;
;		lda	.eventData, x
;		asl	a
;		tax
;
;		jmp	[.eventJumpTable, x]
;
;
;.eventProc0:
;		plx
;		jmp	.eventEnd
;
;.eventEnd:
;		plx
;		rts
;
;.eventJumpTable
;		.dw	.eventProc0
;
;.eventData
;		.db	$00, $00, $00, $00	;0	ステージ1のブロック属性変更




;;;<--		.db	$00, $00, $00, $00	;0	ステージ開始時の動く敵の最大数 0 設定
;		.db	$00, $01, $00, $00	;1	ステージ開始時の動く敵の最大数 1 設定
;		.db	$00, $02, $00, $00	;2	ステージ開始時の動く敵の最大数 2 設定
;		.db	$00, $03, $00, $00	;3	ステージ開始時の動く敵の最大数 3 設定
;		.db	$00, $04, $00, $00	;4	ステージ開始時の動く敵の最大数 4 設定
;
;		.db	$01, $01, $00, $00	;1	動く敵のカウント 1 アップ


;----------------------------
;;;<--eventProc:
;;A:event No.
;		phx
;
;		cmp	$FF
;		jeq	.eventEnd
;
;		asl	a
;		tax
;
;.event0:
;		jsr	event0Sub
;		jmp	.eventEnd
;
;.eventEnd:
;		plx
;		rts
;
;.event0Data	.db	$00, $00
;
;.eventDatas	.dw	.event0Data


;;;;----------------------------
;event0Sub:
;;
;		rts



;----------------------------
;;;<--event0Sub:
;;
;		rts
;
;
;event0Data	.dw	event0Sub
;		.db	0
;
;
;eventDatas	.dw	event0Data


;////////////////////////////
		.bank	SUB2_PRG_BANK
		.org	SUB2_PRG_MAP * $2000

;----------------------------
;Stage Data
;----------------------------
				.rsset	0
STAGE_DATA_ENEMY_WAIT		.rs	1
STAGE_DATA_ENEMY_SET_TYPE	.rs	1
STAGE_DATA_ENEMY_HP		.rs	1
STAGE_DATA_ENEMY_SHOT_WAIT	.rs	1
STAGE_DATA_FLAG0		.rs	1
STAGE_DATA_ENEMY_COUNT_TABLE	.rs	2
STAGE_DATA_OBJ_DATA		.rs	2
STAGE_DATA_BLOCK_DATA		.rs	2

stage1Data
			.db	255			;enemy出現間隔
			.db	0			;enemy出現タイプ
			.db	1			;enemyHP
			.db	255			;enemy shot 間隔 0の時は撃たない
			.db	0			;stage flag 0
			.dw	stage1EnemyCountTable	;Stage Enemy Count Max Table
			.dw	stage1Obj		;obj data
			.dw	stage1Block		;block data


stage2Data
			.db	225			;enemy出現間隔
			.db	0			;enemy出現タイプ
			.db	2			;enemyHP
			.db	225			;enemy shot 間隔 0の時は撃たない
			.db	0			;stage flag 0
			.dw	stage2EnemyCountTable	;Stage Enemy Count Max Table
			.dw	stage2Obj		;obj data
			.dw	stage2Block		;block data


stage3Data
			.db	200			;enemy出現間隔
			.db	0			;enemy出現タイプ
			.db	3			;enemyHP
			.db	200			;enemy shot 間隔 0の時は撃たない
			.db	0			;stage flag 0
			.dw	stage3EnemyCountTable	;Stage Enemy Count Max Table
			.dw	stage3Obj		;obj data
			.dw	stage3Block		;block data


stage4Data
			.db	175			;enemy出現間隔
			.db	0			;enemy出現タイプ
			.db	4			;enemyHP
			.db	175			;enemy shot 間隔 0の時は撃たない
			.db	0			;stage flag 0
			.dw	stage4EnemyCountTable	;Stage Enemy Count Max Table
			.dw	stage4Obj		;obj data
			.dw	stage4Block		;block data


stage5Data
			.db	150			;enemy出現間隔
			.db	0			;enemy出現タイプ
			.db	5			;enemyHP
			.db	150			;enemy shot 間隔 0の時は撃たない
			.db	0			;stage flag 0
			.dw	stage5EnemyCountTable	;Stage Enemy Count Max Table
			.dw	stage5Obj		;obj data
			.dw	stage5Block		;block data


stage6Data
			.db	125			;enemy出現間隔
			.db	0			;enemy出現タイプ
			.db	6			;enemyHP
			.db	125			;enemy shot 間隔 0の時は撃たない
			.db	0			;stage flag 0
			.dw	stage6EnemyCountTable	;Stage Enemy Count Max Table
			.dw	stage6Obj		;obj data
			.dw	stage6Block		;block data


stage7Data
			.db	100			;enemy出現間隔
			.db	1			;enemy出現タイプ
			.db	7			;enemyHP
			.db	100			;enemy shot 間隔 0の時は撃たない
			.db	0			;stage flag 0
			.dw	stage7EnemyCountTable	;Stage Enemy Count Max Table
			.dw	stage7Obj		;obj data
			.dw	stage7Block		;block data


stage8Data
			.db	75			;enemy出現間隔
			.db	0			;enemy出現タイプ
			.db	8			;enemyHP
			.db	75			;enemy shot 間隔 0の時は撃たない
			.db	0			;stage flag 0
			.dw	stage8EnemyCountTable	;Stage Enemy Count Max Table
			.dw	stage8Obj		;obj data
			.dw	stage8Block		;block data

;---------------------
;Stage Obj
;---------------------
			.rsset	0
STAGE_OBJ_NO		.rs	1

STAGE_OBJ_X		.rs	2
STAGE_OBJ_Y		.rs	2
STAGE_OBJ_Z		.rs	2

STAGE_OBJ_RX		.rs	1
STAGE_OBJ_RY		.rs	1
STAGE_OBJ_RZ		.rs	1

STAGE_OBJ_SHOT_TIMER	.rs	1
STAGE_OBJ_HP		.rs	1
STAGE_OBJ_STATUS	.rs	1
STAGE_OBJ_MOVE_STATUS	.rs	1

STAGE_OBJ_MODEL		.rs	2

STAGE_OBJ_DESTORY_EVENT_0	.rs	1
STAGE_OBJ_DESTORY_EVENT_1	.rs	1

STAGE_OBJ_SIZE		.rs	0

;----------------------------
stage1Obj
;obj 総数
		.db	5

;No0 中央
		.db	0
		.dw	0, 250+ENEMY0_CENTER_Y, 0
		.db	0, 0, 0
		.db	255, 8, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy0_0
		.db	$FF, $FF

;No1 左奥
		.db	1
		.dw	-4096, ENEMY1_CENTER_Y, 4096
		.db	0, 0, 0
		.db	255, 4, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 左手前
		.db	1
		.dw	-4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 4, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右奥
		.db	1
		.dw	4096, ENEMY1_CENTER_Y, 4096
		.db	0, 0, 0
		.db	255, 4, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右手前
		.db	1
		.dw	4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 4, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF


;----------------------------
stage2Obj
;obj 総数
		.db	5

;No0 中央
		.db	0
		.dw	0, 250+ENEMY0_CENTER_Y, 0
		.db	0, 0, 0
		.db	255, 9, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy0_0
		.db	$FF, $FF

;No1 左奥
		.db	1
		.dw	-4096, 600+ENEMY1_CENTER_Y+block1_CENTER_Y, 4096
		.db	0, 0, 0
		.db	255, 5, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 左手前
		.db	1
		.dw	-4096, 0+ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 5, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右奥
		.db	1
		.dw	4096, 3000+ENEMY1_CENTER_Y+block1_CENTER_Y, 4096
		.db	0, 0, 0
		.db	255, 5, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右手前
		.db	1
		.dw	4096, 6100+ENEMY1_CENTER_Y+block1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 5, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF


;----------------------------
stage3Obj
;obj 総数
		.db	5

;No0 中央
		.db	0
		.dw	0, 250+ENEMY0_CENTER_Y, 0
		.db	0, 0, 0
		.db	255, 10, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy0_0
		.db	$FF, $FF

;No1 左奥
		.db	1
		.dw	-4096, ENEMY1_CENTER_Y, 4096
		.db	0, 0, 0
		.db	255, 6, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 左手前
		.db	1
		.dw	-4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 6, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右奥
		.db	1
		.dw	4096, ENEMY1_CENTER_Y, 4096
		.db	0, 0, 0
		.db	255, 6, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右手前
		.db	1
		.dw	4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 6, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF


;;;		.db	8
;		.dw	0, 0+ENEMY1_CENTER_Y, 3000
;		.db	0, 0, 0
;		.db	255, 4, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
;		.dw	modelEnemy8_0
;		.db	$FF, $FF


;----------------------------
stage4Obj
;obj 総数
		.db	5

;No0 中央
		.db	0
		.dw	0, 250+ENEMY0_CENTER_Y, 0
		.db	0, 0, 0
		.db	255, 11, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy0_0
		.db	$FF, $FF

;No1 左奥
		.db	1
		.dw	-4096, 3000+block1_CENTER_Y+ENEMY1_CENTER_Y+100, 4096
		.db	0, 0, 0
		.db	255, 7, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 左手前
		.db	1
		.dw	-4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 7, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右奥
		.db	1
		.dw	4096, 3000+block1_CENTER_Y+ENEMY1_CENTER_Y+100, 4096
		.db	0, 0, 0
		.db	255, 7, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右手前
		.db	1
		.dw	4096, 3000+4500+block1_CENTER_Y+ENEMY1_CENTER_Y+100, -4096
		.db	0, 0, 0
		.db	255, 7, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF


;----------------------------
stage5Obj
;obj 総数
		.db	8

;No0 中央 0
		.db	0
		.dw	0, 250+ENEMY0_CENTER_Y, 0
		.db	0, 0, 0
		.db	255, 12, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy0_0
		.db	$FF, $FF

;No1 左手前下 1 最初から出現 1番目 イベントNo.4（3を出現）
		.db	1
		.dw	-4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 8, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	4, $FF

;No1 左手前下 2 3破壊後出現 3番目 イベントNo.6（4を出現）
		.db	1
		.dw	-4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 8, OBJ_ACTIVE, 0;;;+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	6, $FF

;No1 左手前上 3 1破壊後出現 2番目 イベントNo.5（2を出現）
		.db	1
		.dw	-4096, 1000*8+block1_CENTER_Y+ENEMY1_CENTER_Y+100, -4096
		.db	0, 0, 0
		.db	255, 8, OBJ_ACTIVE, 0;;;+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	5, $FF

;No1 左手前上 4 2破壊後出現 4番目
		.db	1
		.dw	-4096, 1000*8+block1_CENTER_Y+ENEMY1_CENTER_Y+100, -4096
		.db	0, 0, 0
		.db	255, 8, OBJ_ACTIVE, 0;;;+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No2 5 イベントNo.5で出現
		.db	2
		.dw	-4096+500, 0+ENEMY1_CENTER_Y, -4096+500
		.db	0, 0, 0
		.db	255, 6, OBJ_ACTIVE, 0;;;+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy2_0
		.db	$FF, $FF

;No2 6 イベントNo.5で出現
		.db	2
		.dw	-4096-500, 0+ENEMY1_CENTER_Y, -4096-500
		.db	0, 0, 0
		.db	255, 6, OBJ_ACTIVE, 0;;;+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy2_0
		.db	$FF, $FF

;No2 7 イベントNo.6で出現
		.db	2
		.dw	-4096+500, 1000*8+block1_CENTER_Y+ENEMY1_CENTER_Y+100, -4096
		.db	0, 0, 0
		.db	255, 6, OBJ_ACTIVE, 0;;;+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy2_0
		.db	$FF, $FF

;----------------------------
stage6Obj
;obj 総数
		.db	5

;No0 中央 0
		.db	0
		.dw	0, 250+ENEMY0_CENTER_Y, 0
		.db	0, 0, 0
		.db	255, 13, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy0_0
		.db	$FF, $FF

;No1 左手前下 1
		.db	1
		.dw	-4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 9, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右手前下 2
		.db	1
		.dw	4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 9, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 左奥 3
		.db	1
		.dw	-4096, 1000*1+block1_CENTER_Y+ENEMY1_CENTER_Y+100, 4096
		.db	0, 0, 0
		.db	255, 9, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右奥 4
		.db	1
		.dw	4096, 1000*4+block1_CENTER_Y+ENEMY1_CENTER_Y+100, 4096
		.db	0, 0, 0
		.db	255, 9, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF


;----------------------------
stage7Obj
;obj 総数
		.db	5

;No0 中央 0
		.db	0
		.dw	0, 250+ENEMY0_CENTER_Y, 0
		.db	0, 0, 0
		.db	255, 14, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy0_0
		.db	$FF, $FF

;No1 左手前下 1
		.db	1
		.dw	-4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 10, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右手前下 2
		.db	1
		.dw	4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 10, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 左奥 3
		.db	1
		.dw	-4096, 1000*1+block1_CENTER_Y+ENEMY1_CENTER_Y+100, 4096
		.db	0, 0, 0
		.db	255, 10, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右奥 4
		.db	1
		.dw	4096, 3000-200+block1_CENTER_Y+ENEMY1_CENTER_Y+100, 4096
		.db	0, 0, 0
		.db	255, 10, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF


;----------------------------
stage8Obj
;obj 総数
		.db	5

;No0 中央 0
		.db	0
		.dw	0, 250+ENEMY0_CENTER_Y, 0
		.db	0, 0, 0
		.db	255, 15, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy0_0
		.db	$FF, $FF

;No1 左手前下 1
		.db	1
		.dw	-4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 11, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右手前下 2
		.db	1
		.dw	4096, ENEMY1_CENTER_Y, -4096
		.db	0, 0, 0
		.db	255, 11, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 左奥 3
		.db	1
		.dw	-4096, ENEMY1_CENTER_Y, 4096
		.db	0, 0, 0
		.db	255, 11, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF

;No1 右奥 4
		.db	1
		.dw	4096, ENEMY1_CENTER_Y, 4096
		.db	0, 0, 0
		.db	255, 11, OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT, 0
		.dw	modelEnemy1_0
		.db	$FF, $FF


;---------------------
;Stage Enemy Count Max Table
;---------------------
;----------------------------
stage1EnemyCountTable	
			.db	0, 0, 0, 0, 0
			;;;.db	4, 3, 2, 1, 0

stage2EnemyCountTable	
			.db	1, 0, 0, 0, 0

stage3EnemyCountTable	
			.db	2, 2, 1, 1, 1

stage4EnemyCountTable	
			.db	2, 2, 2, 2, 2

stage5EnemyCountTable	
			.db	4, 2, 2, 2, 2

stage6EnemyCountTable	
			.db	4, 3, 2, 1, 0

stage7EnemyCountTable	
			.db	4, 3, 2, 1, 0

stage8EnemyCountTable	
			.db	4, 4, 4, 4, 4

;---------------------
;Stage Block
;---------------------
			.rsset	0
STAGE_BLOCK_NO		.rs	2
STAGE_BLOCK_X		.rs	2
STAGE_BLOCK_Y		.rs	2
STAGE_BLOCK_Z		.rs	2
STAGE_BLOCK_STATUS	.rs	1
STAGE_BLOCK_ON_EVENT0	.rs	1
STAGE_BLOCK_ON_EVENT1	.rs	1
STAGE_BLOCK_HIT_EVENT0	.rs	1
STAGE_BLOCK_HIT_EVENT1	.rs	1
STAGE_BLOCK_SIZE	.rs	0


;----------------------------
stage1Block
;block 総数
		.db	32

;センターボスの支え
		.dw	blockData0
		.dw	0, 0+block0_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;道路真ん中
		.dw	blockData20
		.dw	    0,    0,    0
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData22
		.dw	-2048,    0,    0
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData20
		.dw	-4096,    0,    0
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData22
		.dw	 2048,    0,    0
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData20
		.dw	 4096,    0,    0
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;道路手前
		.dw	blockData21
		.dw	-4096,    0,-2048
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData21
		.dw	    0,    0,-2048
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData21
		.dw	 4096,    0,-2048
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;道路最手前
		.dw	blockData21
		.dw	    0,    0,-4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData21
		.dw	-4096,    0,-4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData21
		.dw	 4096,    0,-4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;道路奥
		.dw	blockData21
		.dw	-4096,    0, 2048
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData21
		.dw	    0,    0, 2048
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData21
		.dw	 4096,    0, 2048
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;道路最奥
		.dw	blockData21
		.dw	    0,    0, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData21
		.dw	-4096,    0, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData21
		.dw	 4096,    0, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;メインボス周りのビル
		.dw	blockData10
		.dw	 -900, 0+block10_CENTER_Y,  -900
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	  900, 0+block10_CENTER_Y,  -900
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	 -900, 0+block10_CENTER_Y,   900
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	  900, 0+block10_CENTER_Y,   900
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;右側のビル
		.dw	blockData10
		.dw	  600+200+4096,   400, -600-200
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;左側のビル
		.dw	blockData10
		.dw	 -600-200-4096,   400,  600+200
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;木
;真ん中の通路
		.dw	blockData30
		.dw	  384,  128,-2048
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData30
		.dw	 -384,  128,-3072
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData30
		.dw	  384,  128,-4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData30
		.dw	 -384,  128, 2048
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData30
		.dw	  384,  128, 3072
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData30
		.dw	 -384,  128, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;右の通路
		.dw	blockData30
		.dw	 -384+4096,  128,  384
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;左の通路
		.dw	blockData30
		.dw	  384-4096,  128, -384
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF


;----------------------------
stage2Block
;block 総数
		;;;<--.db	17	;島の影込み
		.db	9

;センターボスの支え
		.dw	blockData0
		.dw	0, 0+block0_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;緑砲台空中大きい
;左奥
		.dw	blockData1
		.dw	-4096, 500+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;左奥手前寄り
		.dw	blockData1
		.dw	-4096, 500+block1_CENTER_Y, 4096-2000
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;右奥
		.dw	blockData1
		.dw	4096, 2900+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;右奥左寄り
		.dw	blockData1
		.dw	4096-2000, 2900+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;奥中央
		.dw	blockData1
		.dw	0, 1400+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;右手前
		.dw	blockData1
		.dw	4096, 6000+block1_CENTER_Y, -4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;右手前中央寄り
		.dw	blockData1
		.dw	4096, 6000+block1_CENTER_Y, -4096+2000
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;右中央
		.dw	blockData1
		.dw	4096, 4000+block1_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;島の影
;左奥
		.dw	blockData31
		.dw	-4096, 0+block31_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;左奥手前寄り
		.dw	blockData31
		.dw	-4096, 0+block31_CENTER_Y, 4096-2000
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;右奥
		.dw	blockData31
		.dw	4096, 0+block31_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;右奥左寄り
		.dw	blockData31
		.dw	4096-2000, 0+block31_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;奥中央
		.dw	blockData31
		.dw	0, 0+block31_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;右手前
		.dw	blockData31
		.dw	4096, 0+block31_CENTER_Y, -4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;右手前中央寄り
		.dw	blockData31
		.dw	4096, 0+block31_CENTER_Y, -4096+2000
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;右中央
		.dw	blockData31
		.dw	4096, 0+block31_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF



;----------------------------
stage3Block
;block 総数
		.db	17

;センターボスの支え
		.dw	blockData0
		.dw	0, 0+block0_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF


;左奥
		.dw	blockData10
		.dw	-4096-500, 0+block10_CENTER_Y, 4096+500
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	-4096, 0+block10_CENTER_Y, 4096+500
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	-4096+500, 0+block10_CENTER_Y, 4096+500
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	-4096-500, 0+block10_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	-4096+500, 0+block10_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	-4096-500, 0+block10_CENTER_Y, 4096-500
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	-4096, 0+block10_CENTER_Y, 4096-500
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	-4096+500, 0+block10_CENTER_Y, 4096-500
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;右奥
		.dw	blockData10
		.dw	4096-500, 0+block10_CENTER_Y, 4096+500
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	4096, 0+block10_CENTER_Y, 4096+500
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	4096+500, 0+block10_CENTER_Y, 4096+500
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	4096-500, 0+block10_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	4096+500, 0+block10_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	4096-500, 0+block10_CENTER_Y, 4096-500
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	4096, 0+block10_CENTER_Y, 4096-500
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

		.dw	blockData10
		.dw	4096+500, 0+block10_CENTER_Y, 4096-500
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF


;----------------------------
stage4Block
;block 総数
		.db	17
;02__040605
;03______10
;01__00__07
;________09
;________08

;センターボスの支え 0
		.dw	blockData0
		.dw	0, 0+block0_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;緑砲台空中大きい
;左中央 1	イベントNo.0で出現
		.dw	blockData1
		.dw	-4096, 1500+block1_CENTER_Y, 0
		.db	OBJ_ACTIVE;;;+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;左奥 2
		.dw	blockData1
		.dw	-4096, 3000+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;左奥手前 3
		.dw	blockData1
		.dw	-4096, 3000+block1_CENTER_Y, 4096-2000
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF


;中央奥 4	イベントNo.1で出現
		.dw	blockData1
		.dw	0, 3000+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE;;;+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;右奥 5
		.dw	blockData1
		.dw	4096, 3000+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;右奥中央寄り 6
		.dw	blockData1
		.dw	4096-2000, 3000+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;右中央 7	イベントNo.3で出現
		.dw	blockData1
		.dw	4096, 3000+3000+block1_CENTER_Y, 0
		.db	OBJ_ACTIVE;;;+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;右手前 8
		.dw	blockData1
		.dw	4096, 3000+4500+block1_CENTER_Y, -4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;右手前中央寄り 9
		.dw	blockData1
		.dw	4096, 3000+4500+block1_CENTER_Y, -4096+2000
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;右手前奥寄り 10	イベントNo.2で出現
		.dw	blockData1
		.dw	4096, 3000+1500+block1_CENTER_Y, 4096-2000
		.db	OBJ_ACTIVE;;;+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;イベントブロック1
		.dw	blockData2
		.dw	-4096, block2_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	0, $FF, $FF, $FF

;イベントブロック2
		.dw	blockData2
		.dw	-4096-700, 3000+block1_CENTER_Y+block2_CENTER_Y+100, 4096-2000-700
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, 1, $FF

;イベントブロック3
		.dw	blockData2
		.dw	4096-2000, 3000+block1_CENTER_Y+block2_CENTER_Y+100, 2048
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	3, $FF, 2, $FF

;ブロック
		.dw	blockData2
		.dw	4096-700, 3000+block1_CENTER_Y+block2_CENTER_Y+100, 4096+700
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;ブロック
		.dw	blockData2
		.dw	4096, block2_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	0, $FF, $FF, $FF

;道路真ん中
		.dw	blockData20
		.dw	    0,    0,    0
		.db	OBJ_ACTIVE+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF


;----------------------------
stage5Block
;block 総数
		.db	10
;02__03__04
;__________
;01__00__05
;_________
;090807__06

;センターボスの支え 0
		.dw	blockData0
		.dw	0, 0+block0_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;1
		.dw	blockData1
		.dw	-4096, 1000*1+block1_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;2
		.dw	blockData1
		.dw	-4096, 1000*2+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;3
		.dw	blockData1
		.dw	0, 1000*3+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;4
		.dw	blockData1
		.dw	4096, 1000*4+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;5
		.dw	blockData1
		.dw	4096, 1000*5+block1_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;6
		.dw	blockData1
		.dw	4096, 1000*6+block1_CENTER_Y, -4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;7
		.dw	blockData1
		.dw	0, 1000*7+block1_CENTER_Y, -4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;8
		.dw	blockData1
		.dw	-4096+2000, 1000*8+block1_CENTER_Y, -4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;9
		.dw	blockData1
		.dw	-4096, 1000*8+block1_CENTER_Y, -4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF


;----------------------------
stage6Block
;block 総数
		.db	10

;センターボスの支え 0
		.dw	blockData0
		.dw	0, 0+block0_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;1
		.dw	blockData1
		.dw	-4096, 1000*1+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;2
		.dw	blockData1
		.dw	-4096, 1000*1+block1_CENTER_Y, 4096-2000
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;3
		.dw	blockData1
		.dw	-4096+2000, 1000*1+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;4
		.dw	blockData1
		.dw	-4096+2000, 1000*1+block1_CENTER_Y, 4096-2000
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;5
		.dw	blockData1
		.dw	4096, 1000*4+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;6
		.dw	blockData1
		.dw	4096, 1000*4+block1_CENTER_Y, 4096-2000
		.db	OBJ_ACTIVE+OBJ_HIT;;;+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;7
		.dw	blockData1
		.dw	4096-2000, 1000*4+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_HIT;;;+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;8
		.dw	blockData1
		.dw	4096-2000, 1000*4+block1_CENTER_Y, 4096-2000
		.db	OBJ_ACTIVE+OBJ_HIT;;;+OBJ_ENTITY
		.db	$FF, $FF, $FF, $FF

;9
		.dw	blockData1
		;;;.dw	0, 1000*2+block1_CENTER_Y, 4096-1000
		.dw	-1000, 1000*2+block1_CENTER_Y, 4096-1000
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;----------------------------
stage7Block
;block 総数
		.db	5

;センターボスの支え 0
		.dw	blockData0
		.dw	0, 0+block0_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF

;1
		.dw	blockData1
		.dw	-4096, 1000*1+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;2
		.dw	blockData1
		.dw	-4096, 1000*1+block1_CENTER_Y, 4096-2000
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;3
		.dw	blockData1
		.dw	4096, 3000-200+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;4
		.dw	blockData1
		.dw	4096-2000, 3000-200+block1_CENTER_Y, 4096
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT+OBJ_RADAR
		.db	$FF, $FF, $FF, $FF

;----------------------------
stage8Block
;block 総数
		.db	1

;センターボスの支え 0
		.dw	blockData0
		.dw	0, 0+block0_CENTER_Y, 0
		.db	OBJ_ACTIVE+OBJ_ENTITY+OBJ_HIT
		.db	$FF, $FF, $FF, $FF


;----------------------------
;----------------------------
;Block Data Struct
;---------------------
			.rsset	0
BLOCK_DATA_HIT_X0	.rs	2
BLOCK_DATA_HIT_Y0	.rs	2
BLOCK_DATA_HIT_Z0	.rs	2
BLOCK_DATA_HIT_X1	.rs	2
BLOCK_DATA_HIT_Y1	.rs	2
BLOCK_DATA_HIT_Z1	.rs	2
BLOCK_DATA_MODEL	.rs	2
BLOCK_DATA_SIZE		.rs	0

;----------------------------
;----------------------------
;Block Data
;ここで当たり判定の大きさを設定。なので同じModelなのに違う当たり判定を指定できる
;----------------------------
;Block No.0	メイン砲台の土台となる大きめの台形の立方体
;Block No.1	大きい逆四角錐
;Block No.2	標準立方体

;Block No.10	ビル位大きい立方体 3階建てビル 12m 800が12m 1mは64

;Block No.20	十字道路 4m
;Block No.21	縦道路 4m
;Block No.22	横道路 4m

;Block No.30	木 4m
;Block No.31	島の影

;----------------------------
;Block No.0
;メイン砲台の土台となる大きめの台形の立方体
;大きさ X:-270, 270 / Y:-125, 125 / Z:-270, 270
blockData0
		dw	 -270-180, -125-72, -270-180, 270+180, 125+72, 270+180, modelBlock0

;----------------------------
;Block No.1
;大きい逆四角錐
;大きさ X:-895, 895 / Y:-150, 125 / Z:-895, 895
blockData1
		dw	 -895-180, -150-72, -895-180, 895+180, 125+72, 895+180, modelBlock1

;----------------------------
;Block No.2
;標準立方体
;大きさ X:-150, 150 / Y:-150, 150 / Z:-150, 150
blockData2
		dw	 -150-180, -150-72, -150-180, 150+180, 150+72, 150+180, modelBlock2

;----------------------------
;Block No.10
;ビル位大きい立方体 3階建てビル 12m 800が12m 1mは64
;大きさ X:-200, 200 / Y:-400, 400 / Z:-200, 200
blockData10
		dw	 -200-180, -400-72, -200-180, 200+180, 400+72, 200+180, modelBlock10

;----------------------------
;Block No.20
;十字道路 4m
;大きさ X:-1024, 1023 / Y:   0,   0 / Z:-1024, 1023
blockData20
		dw	0, 0, 0, 0, 0, 0, modelBlock20

;----------------------------
;Block No.21
;縦道路 4m
;大きさ X:-256, 256 / Y:   0,   0 / Z:-1024, 1023
blockData21
		dw	0, 0, 0, 0, 0, 0, modelBlock21

;----------------------------
;Block No.22
;横道路 4m
;大きさ X:-1024, 1023 / Y:   0,   0 / Z:-256, 256
blockData22
		dw	0, 0, 0, 0, 0, 0, modelBlock22

;----------------------------
;Block No.30
;木 4m
;大きさ X:-64, 64 / Y: -128, 128 / Z:-64, 64
blockData30
		dw	0, 0, 0, 0, 0, 0, modelBlock30

;----------------------------
;Block No.31
;島の影
;大きさ X:-895, 895 / Y:0, 0 / Z:-895, 895
blockData31
		dw	0, 0, 0, 0, 0, 0, modelBlock31


;----------------------------
;----------------------------
;Block Center
;----------------------------
;Block No.0
;メイン砲台の土台となる大きめの台形の立方体
block0_CENTER_Y .equ	125

;----------------------------
;Block N0.1
;大きい逆四角錐
block1_CENTER_Y .equ	150

;----------------------------
;Block No.2
;標準立方体
block2_CENTER_Y .equ	150

;----------------------------
;Block No.10
;ビル位大きい立方体 3階建てビル 12m 800が12m 1mは64
block10_CENTER_Y .equ	400

;----------------------------
;Block No.20
;十字道路 4m
block20_CENTER_Y .equ	0

;----------------------------
;Block No.21
;縦道路 4m
block21_CENTER_Y .equ	0

;----------------------------
;Block No.22
;横道路 4m
block22_CENTER_Y .equ	0

;----------------------------
;Block No.30
;木 4m
block30_CENTER_Y .equ	0

;----------------------------
;Block No.31
;島の影
block31_CENTER_Y .equ	0


;----------------------------
;----------------------------
;Block Model
;----------------------------
;Block No.0
;メイン砲台の土台となる大きめの台形の立方体
modelBlock0
		MODEL_DATA	modelBlock0Polygon, 6, modelBlock0Vertex, 8

modelBlock0Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 2, 0, 1, 3	;後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 6, 4, 0, 2	;左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 3, 1, 5, 7	;右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 7, 5, 4, 6	;前
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1C, $00, 6, 2, 3, 7	;上

modelBlock0Vertex
		VERTEX_DATA	 -270, -125, -270
		VERTEX_DATA	  270, -125, -270

		VERTEX_DATA	 -220,  125, -220
		VERTEX_DATA	  220,  125, -220

		VERTEX_DATA	 -270, -125,  270
		VERTEX_DATA	  270, -125,  270

		VERTEX_DATA	 -220,  125,  220
		VERTEX_DATA	  220,  125,  220

;----------------------------
;----------------------------
;Block N0.1
;大きい逆四角錐
modelBlock1
		MODEL_DATA	modelBlock1Polygon, 8, modelBlock1Vertex, 7
		;;;MODEL_DATA	modelBlock1Polygon, 5, modelBlock1Vertex, 5

modelBlock1Polygon
;;;<--		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1C, $00, 0, 1, 3, 2	;上
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 2, 3, 4	;前
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 0, 2, 4	;左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 3, 1, 4	;右
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 1, 0, 4	;後ろ

;;;<--		POLYGON_DATA	ATTR_BACKDRAW_CXL, $02, $00, 0, 1, 3, 2	;上
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $19, $00, 2, 3, 4	;前
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1E, $00, 0, 2, 4	;左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $05, $00, 3, 1, 4	;右
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $18, $00, 1, 0, 4	;後ろ

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $02, $00, 0, 3, 2, 5	;上前左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $02, $00, 0, 1, 6, 3	;上後右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $19, $00, 2, 3, 4	;前
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1E, $00, 0, 5, 4	;左後
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1E, $00, 5, 2, 4	;左前
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $05, $00, 6, 1, 4	;右後
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $05, $00, 3, 6, 4	;右前
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $18, $00, 1, 0, 4	;後ろ

modelBlock1Vertex
;;;<--		VERTEX_DATA	 -895,  125, -895
;		VERTEX_DATA	  895,  125, -895
;
;		VERTEX_DATA	 -895,  125,  895
;		VERTEX_DATA	  895,  125,  895
;
;		VERTEX_DATA	    0, -150,    0

		VERTEX_DATA	 -600,  125, -895
		VERTEX_DATA	  600,  125, -895

		VERTEX_DATA	 -600,  125,  895
		VERTEX_DATA	  600,  125,  895

		VERTEX_DATA	    0, -150,    0

		VERTEX_DATA	 -895,  125,    0
		VERTEX_DATA	  895,  125,    0



;----------------------------
;Block N0.2
;標準立方体
modelBlock2
		MODEL_DATA	modelBlock2Polygon, 6, modelBlock2Vertex, 8

modelBlock2Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 2, 0, 1, 3	;後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 6, 4, 0, 2	;左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 3, 1, 5, 7	;右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 7, 5, 4, 6	;前
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1C, $00, 6, 2, 3, 7	;上
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 0, 4, 5, 1	;下

modelBlock2Vertex
		VERTEX_DATA	 -150, -150, -150
		VERTEX_DATA	  150, -150, -150

		VERTEX_DATA	 -150,  150, -150
		VERTEX_DATA	  150,  150, -150

		VERTEX_DATA	 -150, -150,  150
		VERTEX_DATA	  150, -150,  150

		VERTEX_DATA	 -150,  150,  150
		VERTEX_DATA	  150,  150,  150

;----------------------------
;Block No.10
;ビル位大きい立方体 3階建てビル 12m 800が12m 1mは64
modelBlock10
		;;;<--MODEL_DATA	modelBlock10Polygon, 5, modelBlock10Vertex, 8
		MODEL_DATA	modelBlock10Polygon, 6, modelBlock10Vertex, 12

modelBlock10Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 8, 9,10,11	;

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0E, $00, 2, 0, 1, 3	;後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 6, 4, 0, 2	;左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 3, 1, 5, 7	;右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 7, 5, 4, 6	;前
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1C, $00, 6, 2, 3, 7	;上

modelBlock10Vertex
		VERTEX_DATA	 -200, -400, -200
		VERTEX_DATA	  200, -400, -200

		VERTEX_DATA	 -200,  400, -200
		VERTEX_DATA	  200,  400, -200

		VERTEX_DATA	 -200, -400,  200
		VERTEX_DATA	  200, -400,  200

		VERTEX_DATA	 -200,  400,  200
		VERTEX_DATA	  200,  400,  200

		VERTEX_DATA	 -200,   25, -200
		VERTEX_DATA	 -200,  -25, -200

		VERTEX_DATA	  200,  -25, -200
		VERTEX_DATA	  200,   25, -200


;----------------------------
;Block No.20
;十字道路 4m
modelBlock20
		MODEL_DATA	modelBlock20Polygon, 3, modelBlock20Vertex, 12

modelBlock20Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00, 1, 0, 2, 3	;
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00, 5, 4, 6, 7	;
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00, 9, 8,10,11	;

modelBlock20Vertex
		VERTEX_DATA	 -256,    0, 1023
		VERTEX_DATA	  256,    0, 1023

		VERTEX_DATA	 -256,    0,-1024
		VERTEX_DATA	  256,    0,-1024

		VERTEX_DATA	-1024,    0,  256
		VERTEX_DATA	 -256,    0,  256

		VERTEX_DATA	-1024,    0, -256
		VERTEX_DATA	 -256,    0, -256

		VERTEX_DATA	  256,    0,  256
		VERTEX_DATA	 1023,    0,  256

		VERTEX_DATA	  256,    0, -256
		VERTEX_DATA	 1023,    0, -256

;----------------------------
;Block No.21
;縦道路 4m
modelBlock21
		MODEL_DATA	modelBlock21Polygon, 2, modelBlock21Vertex, 8

modelBlock21Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00, 1, 0, 2, 3	;
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 5, 4, 6, 7	;

modelBlock21Vertex
		VERTEX_DATA	 -256,    0, 1023
		VERTEX_DATA	  256,    0, 1023

		VERTEX_DATA	 -256,    0,-1024
		VERTEX_DATA	  256,    0,-1024

		VERTEX_DATA	  -16,    0,  255
		VERTEX_DATA	   16,    0,  255

		VERTEX_DATA	  -16,    0, -256
		VERTEX_DATA	   16,    0, -256

;----------------------------
;Block No.22
;横道路 4m
modelBlock22
		MODEL_DATA	modelBlock22Polygon, 2, modelBlock22Vertex, 8

modelBlock22Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00, 1, 0, 2, 3	;
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 5, 4, 6, 7	;

modelBlock22Vertex
		VERTEX_DATA	-1024,    0,  256
		VERTEX_DATA	 1023,    0,  256

		VERTEX_DATA	-1024,    0, -256
		VERTEX_DATA	 1023,    0, -256

		VERTEX_DATA	 -256,    0,   16
		VERTEX_DATA	  255,    0,   16

		VERTEX_DATA	 -256,    0,  -16
		VERTEX_DATA	  255,    0,  -16


;----------------------------
;Block No.30
;木 4m
modelBlock30
		MODEL_DATA	modelBlock30Polygon, 4, modelBlock30Vertex, 10

modelBlock30Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $02, $00, 0, 1, 2	;
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $02, $00, 0, 3, 4	;
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $05, $00, 5, 6, 7	;
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $05, $00, 5, 8, 9	;

modelBlock30Vertex
		VERTEX_DATA	    0,  128,    0
		VERTEX_DATA	  -64,  -64,    0
		VERTEX_DATA	   64,  -64,    0
		VERTEX_DATA	    0,  -64,  -64
		VERTEX_DATA	    0,  -64,   64

		VERTEX_DATA	    0,    0,    0
		VERTEX_DATA	  -32, -128,    0
		VERTEX_DATA	   32, -128,    0
		VERTEX_DATA	    0, -128,  -32
		VERTEX_DATA	    0, -128,   32


;----------------------------
;Block No.31
;島の影
modelBlock31
		MODEL_DATA	modelBlock31Polygon, 2, modelBlock31Vertex, 6

modelBlock31Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL+ATTR_LINESKIP, $07, $00, 0, 3, 2, 4	;上前左
		POLYGON_DATA	ATTR_BACKCHECK_CXL+ATTR_LINESKIP, $07, $00, 0, 1, 5, 3	;上後右

modelBlock31Vertex
		VERTEX_DATA	 -600/2,    0, -895/2
		VERTEX_DATA	  600/2,    0, -895/2

		VERTEX_DATA	 -600/2,    0,  895/2
		VERTEX_DATA	  600/2,    0,  895/2

		VERTEX_DATA	 -895/2,    0,    0
		VERTEX_DATA	  895/2,    0,    0


;----------------------------
;----------------------------
;Enemy Model
;Enemy No.0	赤 メイン砲台
ENEMY0_NO	.equ	0
ENEMY0_CENTER_Y	.equ	200

;Enemy No.1	緑 サブ砲台
ENEMY1_NO	.equ	1
ENEMY1_CENTER_Y	.equ	200

;Enemy No.2	青 ザコ砲台
ENEMY2_NO	.equ	2

;Enemy No.3	移動ザコ No.0
ENEMY3_NO	.equ	3
ENEMY3_CENTER_Y	.equ	100

;Enemy No.4	移動ザコ No.1
ENEMY4_NO	.equ	4
ENEMY4_CENTER_Y	.equ	100

;Enemy No.8	壊れるブロック No.0
ENEMY8_NO	.equ	8
ENEMY8_CENTER_Y	.equ	150

;----------------------------
;Enemy No0_0
;赤 メイン砲台
modelEnemy0_0
		MODEL_DATA	modelEnemy0_0Polygon, 5, modelEnemy0_0Vertex, 5

modelEnemy0_0Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 0, 1, 4	;左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 1, 2, 4	;後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 2, 3, 4	;右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 3, 0, 4	;前

		POLYGON_DATA	ATTR_CIRCLE, $09, 200, 4

modelEnemy0_0Vertex
		VERTEX_DATA	 -200, -200,  200
		VERTEX_DATA	 -200, -200, -200
		VERTEX_DATA	  200, -200, -200
		VERTEX_DATA	  200, -200,  200

		VERTEX_DATA	    0,  300,    0

;----------------------------
;Enemy No0_1
;爆発1
modelEnemy0_1
		MODEL_DATA	modelEnemy0_1Polygon, 4, modelEnemy0_1Vertex, 8

modelEnemy0_1Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0F, $1D, 0, 1, 2	;左
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $1A, $0F, 3, 4, 5	;右

		POLYGON_DATA	ATTR_CIRCLE, $09, 200, 6
		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $01, 400, 7	;爆発

modelEnemy0_1Vertex
		VERTEX_DATA	 -200-100, -200, -200
		VERTEX_DATA	 -200-100, -200,  200
		VERTEX_DATA	    0-100,  300,    0

		VERTEX_DATA	  200+100, -200,  200
		VERTEX_DATA	  200+100, -200, -200
		VERTEX_DATA	    0+100,  300,    0

		VERTEX_DATA	    0,  300+100,    0

		VERTEX_DATA	    0,    0,    0

;----------------------------
;Enemy No0_2
;爆発2
modelEnemy0_2
		MODEL_DATA	modelEnemy0_2Polygon, 4, modelEnemy0_2Vertex, 8

modelEnemy0_2Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0F, $1D, 0, 1, 2	;左
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $1A, $0F, 3, 4, 5	;右

		POLYGON_DATA	ATTR_CIRCLE, $09, 200, 6
		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $01, 200, 7	;爆発

modelEnemy0_2Vertex
		VERTEX_DATA	 -200-200, -200, -200
		VERTEX_DATA	 -200-200, -200,  200
		VERTEX_DATA	    0-200,  300,    0

		VERTEX_DATA	  200+200, -200,  200
		VERTEX_DATA	  200+200, -200, -200
		VERTEX_DATA	    0+200,  300,    0

		VERTEX_DATA	    0,  300+200,    0

		VERTEX_DATA	    0,    0,    0


;----------------------------
;Enemy No1_0
;緑 サブ砲台
modelEnemy1_0
		MODEL_DATA	modelEnemy1_0Polygon, 5, modelEnemy1_0Vertex, 5

modelEnemy1_0Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 0, 1, 4	;左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 1, 2, 4	;後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 2, 3, 4	;右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 3, 0, 4	;前

		POLYGON_DATA	ATTR_CIRCLE, $0A, 200, 4

modelEnemy1_0Vertex
		VERTEX_DATA	 -200, -200,  200
		VERTEX_DATA	 -200, -200, -200
		VERTEX_DATA	  200, -200, -200
		VERTEX_DATA	  200, -200,  200

		VERTEX_DATA	    0,  300,    0

;----------------------------
;Enemy No1_1
;爆発1
modelEnemy1_1
		MODEL_DATA	modelEnemy1_1Polygon, 4, modelEnemy1_1Vertex, 8

modelEnemy1_1Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0F, $1D, 0, 1, 2	;左
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $1A, $0F, 3, 4, 5	;右

		POLYGON_DATA	ATTR_CIRCLE, $0A, 200, 6
		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $01, 400, 7	;爆発

modelEnemy1_1Vertex
		VERTEX_DATA	 -200-100, -200, -200
		VERTEX_DATA	 -200-100, -200,  200
		VERTEX_DATA	    0-100,  300,    0

		VERTEX_DATA	  200+100, -200,  200
		VERTEX_DATA	  200+100, -200, -200
		VERTEX_DATA	    0+100,  300,    0

		VERTEX_DATA	    0,  300+100,    0

		VERTEX_DATA	    0,    0,    0

;----------------------------
;Enemy No1_2
;爆発2
modelEnemy1_2
		MODEL_DATA	modelEnemy1_2Polygon, 4, modelEnemy1_2Vertex, 8

modelEnemy1_2Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0F, $1D, 0, 1, 2	;左
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $1A, $0F, 3, 4, 5	;右

		POLYGON_DATA	ATTR_CIRCLE, $0A, 200, 6
		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $01, 200, 7	;爆発

modelEnemy1_2Vertex
		VERTEX_DATA	 -200-200, -200, -200
		VERTEX_DATA	 -200-200, -200,  200
		VERTEX_DATA	    0-200,  300,    0

		VERTEX_DATA	  200+200, -200,  200
		VERTEX_DATA	  200+200, -200, -200
		VERTEX_DATA	    0+200,  300,    0

		VERTEX_DATA	    0,  300+200,    0

		VERTEX_DATA	    0,    0,    0



;----------------------------
;Enemy No2_0
;青 ザコ砲台
modelEnemy2_0
		MODEL_DATA	modelEnemy2_0Polygon, 5, modelEnemy2_0Vertex, 5

modelEnemy2_0Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 0, 1, 4	;左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 1, 2, 4	;後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 2, 3, 4	;右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 3, 0, 4	;前

		POLYGON_DATA	ATTR_CIRCLE, $0C, 200, 4

modelEnemy2_0Vertex
		VERTEX_DATA	 -200, -200,  200
		VERTEX_DATA	 -200, -200, -200
		VERTEX_DATA	  200, -200, -200
		VERTEX_DATA	  200, -200,  200

		VERTEX_DATA	    0,  300,    0

;----------------------------
;Enemy No2_1
;爆発1
modelEnemy2_1
		MODEL_DATA	modelEnemy2_1Polygon, 4, modelEnemy2_1Vertex, 8

modelEnemy2_1Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0F, $1D, 0, 1, 2	;左
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $1A, $0F, 3, 4, 5	;右

		POLYGON_DATA	ATTR_CIRCLE, $0C, 200, 6
		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $01, 400, 7	;爆発

modelEnemy2_1Vertex
		VERTEX_DATA	 -200-100, -200, -200
		VERTEX_DATA	 -200-100, -200,  200
		VERTEX_DATA	    0-100,  300,    0

		VERTEX_DATA	  200+100, -200,  200
		VERTEX_DATA	  200+100, -200, -200
		VERTEX_DATA	    0+100,  300,    0

		VERTEX_DATA	    0,  300+100,    0

		VERTEX_DATA	    0,    0,    0

;----------------------------
;Enemy No2_2
;爆発2
modelEnemy2_2
		MODEL_DATA	modelEnemy2_2Polygon, 4, modelEnemy2_2Vertex, 8

modelEnemy2_2Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0F, $1D, 0, 1, 2	;左
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $1A, $0F, 3, 4, 5	;右

		POLYGON_DATA	ATTR_CIRCLE, $0C, 200, 6
		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $01, 200, 7	;爆発

modelEnemy2_2Vertex
		VERTEX_DATA	 -200-200, -200, -200
		VERTEX_DATA	 -200-200, -200,  200
		VERTEX_DATA	    0-200,  300,    0

		VERTEX_DATA	  200+200, -200,  200
		VERTEX_DATA	  200+200, -200, -200
		VERTEX_DATA	    0+200,  300,    0

		VERTEX_DATA	    0,  300+200,    0

		VERTEX_DATA	    0,    0,    0



;----------------------------
;Enemy No3_0
;移動ザコ No.0
;歩き0
modelEnemy3_0
		MODEL_DATA	modelEnemy3_0Polygon, 10, modelEnemy3_0Vertex, 12

modelEnemy3_0Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 0, 2, 1	;上 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 1, 2, 3	;上 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $04, $00, 0, 1, 3	;上 右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 0, 3, 2	;上 下

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 4, 6, 5	;左足 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 5, 6, 7	;左足 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 4, 5, 7	;左足 右

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 8,10, 9	;右足 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 9,10,11	;右足 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 8, 9,11	;右足 右

modelEnemy3_0Vertex
		VERTEX_DATA	    0,   25,  100	;上 前
		VERTEX_DATA	    0,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75,   25, -100	;上 後ろ 左
		VERTEX_DATA	   75,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40, -100,  -25	;左足 前
		VERTEX_DATA	  -40,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65, -100,  -75	;左足 後ろ 左
		VERTEX_DATA	  -15, -100,  -75	;左足 後ろ 右

		VERTEX_DATA	   40, -100,  -25	;右足 前
		VERTEX_DATA	   40,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   15, -100,  -75	;右足 後ろ 左
		VERTEX_DATA	   65, -100,  -75	;右足 後ろ 右

;----------------------------
;Enemy No3_1
;歩き1
modelEnemy3_1
		MODEL_DATA	modelEnemy3_0Polygon, 10, modelEnemy3_1Vertex, 12

;;;modelEnemy3_1Polygon
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 0, 2, 1	;上 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 1, 2, 3	;上 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 0, 1, 3	;上 右
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0D, $00, 0, 3, 2	;上 下
;
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 4, 6, 5	;左足 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 5, 6, 7	;左足 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 4, 5, 7	;左足 右
;
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 8,10, 9	;右足 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 9,10,11	;右足 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 8, 9,11	;右足 右

modelEnemy3_1Vertex
		VERTEX_DATA	    0,   25,  100	;上 前
		VERTEX_DATA	    0,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75,   25, -100	;上 後ろ 左
		VERTEX_DATA	   75,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40, -100,   30	;左足 前
		VERTEX_DATA	  -40,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65, -100,  -20	;左足 後ろ 左
		VERTEX_DATA	  -15, -100,  -20	;左足 後ろ 右

		VERTEX_DATA	   40, -100,  -80	;右足 前
		VERTEX_DATA	   40,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   15, -100, -130	;右足 後ろ 左
		VERTEX_DATA	   65, -100, -130	;右足 後ろ 右

;----------------------------
;Enemy No3_2
;歩き2
modelEnemy3_2
		MODEL_DATA	modelEnemy3_0Polygon, 10, modelEnemy3_2Vertex, 12

;;;modelEnemy3_2Polygon
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 0, 2, 1	;上 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 1, 2, 3	;上 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 0, 1, 3	;上 右
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0D, $00, 0, 3, 2	;上 下
;
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 4, 6, 5	;左足 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 5, 6, 7	;左足 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 4, 5, 7	;左足 右
;
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 8,10, 9	;右足 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 9,10,11	;右足 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 8, 9,11	;右足 右

modelEnemy3_2Vertex
		VERTEX_DATA	    0,   25,  100	;上 前
		VERTEX_DATA	    0,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75,   25, -100	;上 後ろ 左
		VERTEX_DATA	   75,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40, -100,  -80	;左足 前
		VERTEX_DATA	  -40,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65, -100, -130	;左足 後ろ 左
		VERTEX_DATA	  -15, -100, -130	;左足 後ろ 右

		VERTEX_DATA	   40, -100,   30	;右足 前
		VERTEX_DATA	   40,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   15, -100,  -20	;右足 後ろ 左
		VERTEX_DATA	   65, -100,  -20	;右足 後ろ 右


;----------------------------
;Enemy No3_3
;爆発1
modelEnemy3_3
		MODEL_DATA	modelEnemy3_3Polygon, 5, modelEnemy3_3Vertex, 13

modelEnemy3_3Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0C, $0C, 0, 2, 1	;上 左
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $04, $04, 3, 4, 5	;上 右

		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0F, $0F, 6, 8, 7	;左足 左

		POLYGON_DATA	ATTR_BACKCHECK_CXL, $1B, $1B, 9,10,11	;右足 右

		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $01, 100, 12	;爆発

modelEnemy3_3Vertex
		VERTEX_DATA	    0-50,   25,  100	;上 前
		VERTEX_DATA	    0-50,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75-50,   25, -100	;上 後ろ 左

		VERTEX_DATA	    0+50,   25,  100	;上 前
		VERTEX_DATA	    0+50,  100, -100	;上 後ろ 上
		VERTEX_DATA	   75+50,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40-50, -100,  -25	;左足 前
		VERTEX_DATA	  -40-50,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65-50, -100,  -75	;左足 後ろ 左

		VERTEX_DATA	   40+50, -100,  -25	;右足 前
		VERTEX_DATA	   40+50,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   65+50, -100,  -75	;右足 後ろ 右

		VERTEX_DATA	       0,    0,    0	;爆発 真ん中


;----------------------------
;Enemy No3_4
;爆発2
modelEnemy3_4
		MODEL_DATA	modelEnemy3_4Polygon, 5, modelEnemy3_4Vertex, 13

modelEnemy3_4Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0C, $0C, 0, 2, 1	;上 左
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $04, $04, 3, 4, 5	;上 右

		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0F, $0F, 6, 8, 7	;左足 左

		POLYGON_DATA	ATTR_BACKCHECK_CXL, $1B, $1B, 9,10,11	;右足 右

		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $01, 50, 12	;爆発

modelEnemy3_4Vertex
		VERTEX_DATA	    0-100,   25,  100	;上 前
		VERTEX_DATA	    0-100,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75-100,   25, -100	;上 後ろ 左

		VERTEX_DATA	    0+100,   25,  100	;上 前
		VERTEX_DATA	    0+100,  100, -100	;上 後ろ 上
		VERTEX_DATA	   75+100,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40-100, -100,  -25	;左足 前
		VERTEX_DATA	  -40-100,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65-100, -100,  -75	;左足 後ろ 左

		VERTEX_DATA	   40+100, -100,  -25	;右足 前
		VERTEX_DATA	   40+100,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   65+100, -100,  -75	;右足 後ろ 右

		VERTEX_DATA	       0,    0,    0	;爆発 真ん中

;----------------------------
;Enemy No3_5
;出現
modelEnemy3_5
		MODEL_DATA	modelEnemy3_5Polygon, 11, modelEnemy3_5Vertex, 13

modelEnemy3_5Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 0, 2, 1	;上 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 1, 2, 3	;上 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $04, $00, 0, 1, 3	;上 右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 0, 3, 2	;上 下

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 4, 6, 5	;左足 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 5, 6, 7	;左足 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 4, 5, 7	;左足 右

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 8,10, 9	;右足 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 9,10,11	;右足 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 8, 9,11	;右足 右

		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $0A, 150, 12	;

modelEnemy3_5Vertex
		VERTEX_DATA	    0,   25,  100	;上 前
		VERTEX_DATA	    0,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75,   25, -100	;上 後ろ 左
		VERTEX_DATA	   75,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40, -100,  -25	;左足 前
		VERTEX_DATA	  -40,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65, -100,  -75	;左足 後ろ 左
		VERTEX_DATA	  -15, -100,  -75	;左足 後ろ 右

		VERTEX_DATA	   40, -100,  -25	;右足 前
		VERTEX_DATA	   40,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   15, -100,  -75	;右足 後ろ 左
		VERTEX_DATA	   65, -100,  -75	;右足 後ろ 右

		VERTEX_DATA	    0,    0,    0	;真ん中


;----------------------------
;Enemy No4_0
;移動ザコ No.1
;歩き0
modelEnemy4_0
		MODEL_DATA	modelEnemy4_0Polygon, 10, modelEnemy4_0Vertex, 12

modelEnemy4_0Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $09, $00, 0, 2, 1	;上 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 1, 2, 3	;上 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $01, $00, 0, 1, 3	;上 右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 0, 3, 2	;上 下

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 4, 6, 5	;左足 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 5, 6, 7	;左足 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 4, 5, 7	;左足 右

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 8,10, 9	;右足 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 9,10,11	;右足 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 8, 9,11	;右足 右

modelEnemy4_0Vertex
		VERTEX_DATA	    0,   25,  100	;上 前
		VERTEX_DATA	    0,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75,   25, -100	;上 後ろ 左
		VERTEX_DATA	   75,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40, -100,  -25	;左足 前
		VERTEX_DATA	  -40,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65, -100,  -75	;左足 後ろ 左
		VERTEX_DATA	  -15, -100,  -75	;左足 後ろ 右

		VERTEX_DATA	   40, -100,  -25	;右足 前
		VERTEX_DATA	   40,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   15, -100,  -75	;右足 後ろ 左
		VERTEX_DATA	   65, -100,  -75	;右足 後ろ 右

;----------------------------
;Enemy No4_1
;歩き1
modelEnemy4_1
		MODEL_DATA	modelEnemy4_0Polygon, 10, modelEnemy4_1Vertex, 12

;;;modelEnemy4_1Polygon
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 0, 2, 1	;上 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 1, 2, 3	;上 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 0, 1, 3	;上 右
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0D, $00, 0, 3, 2	;上 下
;
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 4, 6, 5	;左足 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 5, 6, 7	;左足 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 4, 5, 7	;左足 右
;
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 8,10, 9	;右足 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 9,10,11	;右足 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 8, 9,11	;右足 右

modelEnemy4_1Vertex
		VERTEX_DATA	    0,   25,  100	;上 前
		VERTEX_DATA	    0,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75,   25, -100	;上 後ろ 左
		VERTEX_DATA	   75,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40, -100,   30	;左足 前
		VERTEX_DATA	  -40,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65, -100,  -20	;左足 後ろ 左
		VERTEX_DATA	  -15, -100,  -20	;左足 後ろ 右

		VERTEX_DATA	   40, -100,  -80	;右足 前
		VERTEX_DATA	   40,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   15, -100, -130	;右足 後ろ 左
		VERTEX_DATA	   65, -100, -130	;右足 後ろ 右

;----------------------------
;Enemy No4_2
;歩き2
modelEnemy4_2
		MODEL_DATA	modelEnemy4_0Polygon, 10, modelEnemy4_2Vertex, 12

;;;modelEnemy4_2Polygon
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 0, 2, 1	;上 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 1, 2, 3	;上 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 0, 1, 3	;上 右
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0D, $00, 0, 3, 2	;上 下
;
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 4, 6, 5	;左足 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 5, 6, 7	;左足 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 4, 5, 7	;左足 右
;
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0A, $00, 8,10, 9	;右足 左
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0B, $00, 9,10,11	;右足 後ろ
;		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00, 8, 9,11	;右足 右

modelEnemy4_2Vertex
		VERTEX_DATA	    0,   25,  100	;上 前
		VERTEX_DATA	    0,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75,   25, -100	;上 後ろ 左
		VERTEX_DATA	   75,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40, -100,  -80	;左足 前
		VERTEX_DATA	  -40,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65, -100, -130	;左足 後ろ 左
		VERTEX_DATA	  -15, -100, -130	;左足 後ろ 右

		VERTEX_DATA	   40, -100,   30	;右足 前
		VERTEX_DATA	   40,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   15, -100,  -20	;右足 後ろ 左
		VERTEX_DATA	   65, -100,  -20	;右足 後ろ 右


;----------------------------
;Enemy No4_3
;爆発1
modelEnemy4_3
		MODEL_DATA	modelEnemy4_3Polygon, 5, modelEnemy4_3Vertex, 13

modelEnemy4_3Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $09, $0C, 0, 2, 1	;上 左
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $01, $04, 3, 4, 5	;上 右

		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0F, $0F, 6, 8, 7	;左足 左

		POLYGON_DATA	ATTR_BACKCHECK_CXL, $1B, $1B, 9,10,11	;右足 右

		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $01, 100, 12	;爆発

modelEnemy4_3Vertex
		VERTEX_DATA	    0-50,   25,  100	;上 前
		VERTEX_DATA	    0-50,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75-50,   25, -100	;上 後ろ 左

		VERTEX_DATA	    0+50,   25,  100	;上 前
		VERTEX_DATA	    0+50,  100, -100	;上 後ろ 上
		VERTEX_DATA	   75+50,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40-50, -100,  -25	;左足 前
		VERTEX_DATA	  -40-50,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65-50, -100,  -75	;左足 後ろ 左

		VERTEX_DATA	   40+50, -100,  -25	;右足 前
		VERTEX_DATA	   40+50,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   65+50, -100,  -75	;右足 後ろ 右

		VERTEX_DATA	       0,    0,    0	;爆発 真ん中


;----------------------------
;Enemy No4_4
;爆発2
modelEnemy4_4
		MODEL_DATA	modelEnemy4_4Polygon, 5, modelEnemy4_4Vertex, 13

modelEnemy4_4Polygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $09, $0C, 0, 2, 1	;上 左
		POLYGON_DATA	ATTR_BACKCHECK_CXL, $01, $04, 3, 4, 5	;上 右

		POLYGON_DATA	ATTR_BACKCHECK_CXL, $0F, $0F, 6, 8, 7	;左足 左

		POLYGON_DATA	ATTR_BACKCHECK_CXL, $1B, $1B, 9,10,11	;右足 右

		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $01, 50, 12	;爆発

modelEnemy4_4Vertex
		VERTEX_DATA	    0-100,   25,  100	;上 前
		VERTEX_DATA	    0-100,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75-100,   25, -100	;上 後ろ 左

		VERTEX_DATA	    0+100,   25,  100	;上 前
		VERTEX_DATA	    0+100,  100, -100	;上 後ろ 上
		VERTEX_DATA	   75+100,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40-100, -100,  -25	;左足 前
		VERTEX_DATA	  -40-100,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65-100, -100,  -75	;左足 後ろ 左

		VERTEX_DATA	   40+100, -100,  -25	;右足 前
		VERTEX_DATA	   40+100,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   65+100, -100,  -75	;右足 後ろ 右

		VERTEX_DATA	       0,    0,    0	;爆発 真ん中

;----------------------------
;Enemy No4_5
;出現
modelEnemy4_5
		MODEL_DATA	modelEnemy4_5Polygon, 11, modelEnemy4_5Vertex, 13

modelEnemy4_5Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $09, $00, 0, 2, 1	;上 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 1, 2, 3	;上 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $01, $00, 0, 1, 3	;上 右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 0, 3, 2	;上 下

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 4, 6, 5	;左足 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 5, 6, 7	;左足 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 4, 5, 7	;左足 右

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 8,10, 9	;右足 左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 9,10,11	;右足 後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 8, 9,11	;右足 右

		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $0A, 150, 12	;

modelEnemy4_5Vertex
		VERTEX_DATA	    0,   25,  100	;上 前
		VERTEX_DATA	    0,  100, -100	;上 後ろ 上
		VERTEX_DATA	  -75,   25, -100	;上 後ろ 左
		VERTEX_DATA	   75,   25, -100	;上 後ろ 右

		VERTEX_DATA	  -40, -100,  -25	;左足 前
		VERTEX_DATA	  -40,   25,  -50	;左足 後ろ 上
		VERTEX_DATA	  -65, -100,  -75	;左足 後ろ 左
		VERTEX_DATA	  -15, -100,  -75	;左足 後ろ 右

		VERTEX_DATA	   40, -100,  -25	;右足 前
		VERTEX_DATA	   40,   25,  -50	;右足 後ろ 上
		VERTEX_DATA	   15, -100,  -75	;右足 後ろ 左
		VERTEX_DATA	   65, -100,  -75	;右足 後ろ 右

		VERTEX_DATA	    0,    0,    0	;真ん中




;----------------------------
;Enemy No8_0
;壊れる標準立方体
modelEnemy8_0
		MODEL_DATA	modelEnemy8_0Polygon, 6, modelEnemy8_0Vertex, 8

modelEnemy8_0Polygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1D, $00, 2, 0, 1, 3	;後ろ
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00, 6, 4, 0, 2	;左
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 3, 1, 5, 7	;右
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1B, $00, 7, 5, 4, 6	;前
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1C, $00, 6, 2, 3, 7	;上
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $1A, $00, 0, 4, 5, 1	;下

modelEnemy8_0Vertex
		VERTEX_DATA	 -150, -150, -150
		VERTEX_DATA	  150, -150, -150

		VERTEX_DATA	 -150,  150, -150
		VERTEX_DATA	  150,  150, -150

		VERTEX_DATA	 -150, -150,  150
		VERTEX_DATA	  150, -150,  150

		VERTEX_DATA	 -150,  150,  150
		VERTEX_DATA	  150,  150,  150




;----------------------------
;Shot
modelShot
		MODEL_DATA	modelShotPolygon, 2, modelShotVertex, 6

modelShotPolygon
		POLYGON_DATA	ATTR_BACKCHECK_CXL+ATTR_FRONTCLIP_CXL, $0E, $0E, 0, 1, 2
		POLYGON_DATA	ATTR_BACKCHECK_CXL+ATTR_FRONTCLIP_CXL, $0E, $0E, 3, 4, 5

modelShotVertex
		VERTEX_DATA	 -100,    0,  100
		VERTEX_DATA	 -125,  -25, -100
		VERTEX_DATA	  -75,   25, -100

		VERTEX_DATA	  100,    0,  100
		VERTEX_DATA	  125,  -25, -100
		VERTEX_DATA	   75,   25, -100


;----------------------------
;EnemyShot
modelEnemyShot
		MODEL_DATA	modelEnemyShotPolygon, 1, modelEnemyShotVertex, 1

modelEnemyShotPolygon
		POLYGON_DATA	ATTR_CIRCLE, $03, $0028, 0

modelEnemyShotVertex
		VERTEX_DATA	    0,    0,    0



;----------------------------
modelTitle
		MODEL_DATA	modelTitlePolygon, 13, modelTitleVertex, 13

modelTitlePolygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00,  0,  1,  2,  3	;center bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $04, $00,  0,  3,  4		;center front left
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0C, $00,  0,  4,  1		;center front right
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $08, $00,  4,  3,  2		;center back left
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00,  4,  2,  1		;center back right

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $08, $00,  5,  7,  6		;right center
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00,  5,  6,  8		;right front top
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00,  5,  8,  7		;right front bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $09, $00,  6,  7,  8		;right back

		POLYGON_DATA	ATTR_BACKDRAW_CXL, $08, $00,  9, 10, 11		;left center
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $0F, $00,  9, 12, 10		;left front top
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $07, $00,  9, 11, 12		;left front bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL, $09, $00, 10, 12, 11		;left back

modelTitleVertex
;;;		VERTEX_DATA	    0,    0,  100	;0
;		VERTEX_DATA	   25,    0,    0	;1
;		VERTEX_DATA	    0,    0,  -50	;2
;		VERTEX_DATA	  -25,    0,    0	;3
;		VERTEX_DATA	    0,   25,    0	;4
;
;		VERTEX_DATA	   40,    0,  100	;5
;		VERTEX_DATA	   40,   25,  -50	;6
;		VERTEX_DATA	   40,  -25,  -50	;7
;		VERTEX_DATA	   65,    0,  -15	;8
;
;		VERTEX_DATA	  -40,    0,  100	;9
;		VERTEX_DATA	  -40,   25,  -50	;10
;		VERTEX_DATA	  -40,  -25,  -50	;11
;		VERTEX_DATA	  -65,    0,  -15	;12

		VERTEX_DATA	  0, -56,  83
		VERTEX_DATA	 25,   0,   0
		VERTEX_DATA	  0,  28, -42
		VERTEX_DATA	-25,   0,   0
		VERTEX_DATA	  0,  21,  14

		VERTEX_DATA	 40,  80, -20
		VERTEX_DATA	 40, -80, -15
		VERTEX_DATA	 40, -80,  40
		VERTEX_DATA	 65, -50,   0

		VERTEX_DATA	-40,  80, -20
		VERTEX_DATA	-40, -80, -15
		VERTEX_DATA	-40, -80,  40
		VERTEX_DATA	-65, -50,   0


;----------------------------
modelTitleMirror
		MODEL_DATA	modelTitleMirrorPolygon, 13, modelTitleVertex, 13

modelTitleMirrorPolygon
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $07, $00,  0,  1,  2,  3	;center bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $04, $00,  0,  3,  4		;center front left
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $0C, $00,  0,  4,  1		;center front right
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $08, $00,  4,  3,  2		;center back left
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $0F, $00,  4,  2,  1		;center back right

		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $08, $00,  5,  7,  6		;right center
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $0F, $00,  5,  6,  8		;right front top
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $07, $00,  5,  8,  7		;right front bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $09, $00,  6,  7,  8		;right back

		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $08, $00,  9, 10, 11		;left center
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $0F, $00,  9, 12, 10		;left front top
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $07, $00,  9, 11, 12		;left front bottom
		POLYGON_DATA	ATTR_BACKDRAW_CXL+ATTR_LINESKIP, $09, $00, 10, 12, 11		;left back


;----------------------------
modelCompass
		MODEL_DATA	modelCompassPolygon, 2, modelCompassVertex, 4

modelCompassPolygon
		POLYGON_DATA	ATTR_FRONTCLIP_CXL+ATTR_BACKCHECK_CXL, $09, $00,  0,  1,  2
		POLYGON_DATA	ATTR_CIRCLE+ATTR_LINESKIP, $08, 16, 3

modelCompassVertex
		VERTEX_DATA	    0,   10,    0	;0
		VERTEX_DATA	   -5,  -10,    0	;0
		VERTEX_DATA	    5,  -10,    0	;0

		VERTEX_DATA	    0,    0,    1


;----------------------------
;レーダー用
modelScreen
		MODEL_DATA	modelScreenPolygon, 1, modelScreenVertex, 4

modelScreenPolygon
		POLYGON_DATA	ATTR_FRONTCLIP_CXL+ATTR_BACKCHECK_CXL+ATTR_LINESKIP, $08, $00,  0,  1,  2,  3

modelScreenVertex
;;;		VERTEX_DATA	  -16,   16,    0	;0
;		VERTEX_DATA	  -16,  -16,    0	;1
;		VERTEX_DATA	   16,  -16,    0	;2
;		VERTEX_DATA	   16,   16,    0	;3

;;;		VERTEX_DATA	  -32,   32,    0	;0
;		VERTEX_DATA	  -32,  -32,    0	;1
;		VERTEX_DATA	   32,  -32,    0	;2
;		VERTEX_DATA	   32,   32,    0	;3

		VERTEX_DATA	  -24,   24,    0	;0
		VERTEX_DATA	  -24,  -24,    0	;1
		VERTEX_DATA	   24,  -24,    0	;2
		VERTEX_DATA	   24,   24,    0	;3


;使っている色
;$01 $02 $03 $04 $05     $07 $08 $09 $0A     $0C     $0E $0F                                 $18 $19 $1A $1B $1C $1D $1E
;                    $06                 $0B     $0D         $10 $11 $12 $13 $14 $15 $16 $17                             $1F




;----------------------------
clearP0Data
		.db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


;----------------------------
clearP1Data
		.db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$55, $AA, $55, $AA, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
clearP2Data
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $AA, $55, $AA,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


;----------------------------
clearP3Data
		.db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $AA, $55, $AA, $55,\
			$AA, $55, $AA, $55, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


;----------------------------
_clearP0Data
		.db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $AA, $55, $AA, $55,\
			$AA, $55, $AA, $55, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


;----------------------------
_clearP1Data
		.db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $AA, $55, $AA, $55,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
_clearP2Data
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$AA, $55, $AA, $55, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


;----------------------------
_clearP3Data
		.db	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
