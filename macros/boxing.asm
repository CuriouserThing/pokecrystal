save_box_address_chunks: MACRO
; \1 is the number of chunks
IF \1 == 0
FAIL "Box can't be divided into 0 chunks."
ENDC
	push hl
	push af
	push de
i = 0
REPT \1
	ld a, BANK(sBox)
	call GetSRAMBank
	ld hl, sBox + (wMiscEnd - wMisc) * i
	ld de, wMisc
IF i < \1 - 1
	ld bc, (wMiscEnd - wMisc)
ELSE
	ld bc, sBoxEnd - (sBox + (wMiscEnd - wMisc) * i)
ENDC
	call CopyBytes
	call CloseSRAM
	pop de
	pop af
IF i > 0
	ld hl, (wMiscEnd - wMisc)
	add hl, de
	ld e, l
	ld d, h
ENDC
IF i < \1 - 1
	push af
	push de
ENDC
	call GetSRAMBank
	ld hl, wMisc
IF i < \1 - 1
	ld bc, (wMiscEnd - wMisc)
ELSE
	ld bc, sBoxEnd - (sBox + (wMiscEnd - wMisc) * i)
ENDC
	call CopyBytes
	call CloseSRAM
i = i + 1
ENDR
	pop hl
ENDM


load_box_address_chunks: MACRO
; \1 is the number of chunks
IF \1 == 0
FAIL "Box can't be divided into 0 chunks."
ENDC
	push hl
	ld l, e
	ld h, d
i = 0
REPT \1
IF i > 0
	ld de, (wMiscEnd - wMisc)
	add hl, de
ENDC
IF i < \1 - 1
	push af
	push hl
ENDC
	call GetSRAMBank
	ld de, wMisc
IF i < \1 - 1
	ld bc, (wMiscEnd - wMisc)
ELSE
	ld bc, sBoxEnd - (sBox + (wMiscEnd - wMisc) * i)
ENDC
	call CopyBytes
	call CloseSRAM
	ld a, BANK(sBox)
	call GetSRAMBank
	ld hl, wMisc
	ld de, sBox + (wMiscEnd - wMisc) * i
IF i < \1 - 1
	ld bc, (wMiscEnd - wMisc)
ELSE
	ld bc, sBoxEnd - (sBox + (wMiscEnd - wMisc) * i)
ENDC
	call CopyBytes
	call CloseSRAM
	pop hl
IF i < \1 - 1
	pop af
ENDC
i = i + 1
ENDR
ENDM
