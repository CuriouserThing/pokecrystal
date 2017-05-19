pause_clock: MACRO
	ld hl, WorldPaused
	set WORLD_PAUSED_DEFAULT, [hl]
ENDM
unpause_clock: MACRO
	xor a
	ld [WorldPaused], a
ENDM

set_clock_multiplier: MACRO
m = \1
IF m & $fffff000 > 0 ; fixed-point
IF m & $00000fff > 0
WARN "Clock multiplier \1 is too granular and will snap to 1/16th precision."
ENDC
IF m > 3600.0
WARN "Clock multiplier \1 is greater than 3600 and will be capped."
m = 3600.0
ENDC
m = m >> 12
ELSE ; integer
IF m > 3600
WARN "Clock multiplier \1 is greater than 3600 and will be capped."
m = 3600
ENDC
m = m << 4
ENDC
IF m < $100
	ld a, m
	ld [WorldSpeedLow], a
	xor a
	ld [WorldSpeedHigh], a
ELSE
IF m & $00ff == 0
	xor a
	ld [WorldSpeedLow], a
	ld a, (m & $ff00) >> 8
	ld [WorldSpeedHigh], a
ELSE
	ld a, m & $00ff
	ld [WorldSpeedLow], a
	ld a, (m & $ff00) >> 8
	ld [WorldSpeedHigh], a
ENDC
ENDC
ENDM
