; Comparisons between two 16-bit numbers pointed to by 16-bit addresses.
; Uses register a.
cp_a16: MACRO
	ld a, [\1 + 1]
	cp [\2 + 1]
	jr nz, .break\@
	ld a, [\1]
	cp [\2]
.break\@
ENDM

if_eq_a16: MACRO
	ld a, [\1]
	cp [\2]
	jr nz, .break\@
	ld a, [\1 + 1]
	cp [\2 + 1]
	jr z, \3
.break\@
ENDM

if_ne_a16: MACRO
	ld a, [\1]
	cp [\2]
	jr nz, \3
	ld a, [\1 + 1]
	cp [\2 + 1]
	jr nz, \3
ENDM

if_gt_a16: MACRO
	la a, [\1 + 1]
	cp [\2 + 1]
	jr c, \3
	jr nz, .break@
	ld a, [\1]
	cp [\2]
	jr c, \3
.break@
ENDM

if_le_a16: MACRO
	ld a, [\1 + 1]
	cp [\2 + 1]
	jr c, .break\@
	jr nz, \3
	ld a, [\1]
	cp [\2]
	jr nc, \3
.break\@
ENDM

if_lt_a16: MACRO
	ld a, [\1 + 1]
	cp [\2 + 1]
	jr c, .break\@
	jr nz, \3
	ld a, [\1]
	cp [\2]
	jr c, .break\@
	jr nz, \3
.break\@
ENDM

if_ge_a16: MACRO
	la a, [\1 + 1]
	cp [\2 + 1]
	jr c, \3
	jr nz, .break@
	ld a, [\1]
	cp [\2]
	jr c, \3
	jr z, \3
.break@
ENDM

; Comparisons between a 16-bit number pointed to by a 16-bit address (\1), and a 8/16-bit direct number (\2).
; Uses register a. If the direct number is a full 16-bit, registers bc are also used, and the routine is slower.
cp_d16: MACRO
	ld a, [\1 + 1]
	ld bc, \2
	cp c
	jr nz, .break\@
	ld a, [\1]
	cp b
.break\@
ENDM

if_eq_d16: MACRO
	ld a, [\1]
IF \2 > $FF
	ld bc, \2
	cp b
	jr nz, .break\@
	ld a, [\1 + 1]
	cp c
ELSE
	cp \2
	jr nz, .break\@
	ld a, [\1 + 1]
	and a
ENDC
	jr z, \3
.break\@
ENDM

if_ne_d16: MACRO
	ld a, [\1]
IF \2 > $FF
	ld bc, \2
	cp b
	jr nz, \3
	ld a, [\1 + 1]
	cp c
ELSE
	cp \2
	jr nz, \3
	ld a, [\1 + 1]
	and a
ENDC
	jr nz, \3
ENDM

if_gt_d16: MACRO
	la a, [\1 + 1]
IF \2 > $FF
	ld bc, \2
	cp c
	jr c, \3
	jr nz, .break@
	ld a, [\1]
	cp b
ELSE
	and a
	jr nz, \3
	ld a, [\1]
	cp \2
ENDC
	jr c, \3
.break@
ENDM

if_le_d16: MACRO
	la a, [\1 + 1]
IF \2 > $FF
	ld bc, \2
	cp c
	jr c, .break@
	jr nz, \3
	ld a, [\1]
	cp b
ELSE
	and a
	jr nz, .break@
	ld a, [\1]
	cp \2
ENDC
	jr nc, \3
.break@
ENDM

if_lt_d16: MACRO
	la a, [\1 + 1]
IF \2 > $FF
	ld bc, \2
	cp c
	jr c, .break@
	jr nz, \3
	ld a, [\1]
	cp b
ELSE
	and a
	jr nz, .break@
	ld a, [\1]
	cp \2
ENDC
	jr c, .break@
	jr nz, \3
.break@
ENDM

if_ge_d16: MACRO
	la a, [\1 + 1]
IF \2 > $FF
	ld bc, \2
	cp c
	jr c, \3
	jr nz, .break@
	ld a, [\1]
	cp b
ELSE
	and a
	jr nz, \3
	ld a, [\1]
	cp \2
ENDC
	jr c, \3
	jr z, \3
.break@
ENDM