pause_clock: MACRO
	ld hl, WorldPaused
	set WORLD_PAUSED_DEFAULT, [hl]
ENDM
CLEAN_pause_clock: MACRO
	push hl
	pause_clock
	pop hl
ENDM

unpause_clock: MACRO
	xor a
	ld [WorldPaused], a
ENDM
CLEAN_unpause_clock: MACRO
	push af
	unpause_clock
	pop af
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

CLEAN_set_clock_multiplier: MACRO
	push af
	set_clock_multiplier \1
	pop af
ENDM


advance_clock_to: MACRO
second  = -1
minute  = -1
hour    = -1
weekday = -1

IF _NARG % 2 == 1
FAIL "Odd number of arguments."
ENDC

REPT _NARG / 2

IF "\2" == "seconds"
IF \1 > 59
FAIL "Cannot advance clock to \1 seconds."
ENDC
IF second != -1
WARN "Already advancing clock to {second} seconds. The attempt to advance it to \1 seconds will be ignored."
ELSE
second = \1
ENDC

ELSE
IF "\2" == "minutes"
IF \1 > 59
FAIL "Cannot advance clock to \1 minutes."
ENDC
IF minute != -1
WARN "Already advancing clock to {minute} minutes. The attempt to advance it to \1 minutes will be ignored."
ELSE
minute = \1
ENDC

ELSE
IF "\2" == "hours"
IF \1 > 23
FAIL "Cannot advance clock to \1 hours."
ENDC
IF hour != -1
WARN "Already advancing clock to {hour} hours. The attempt to advance it to \1 hours will be ignored."
ELSE
hour = \1
ENDC

ELSE
IF "\2" == "AM"
IF \1 == 0 || \1 > 12
FAIL "Cannot advance clock to \1 AM."
ENDC
IF hour != -1
WARN "Already advancing clock to {hour} hours. The attempt to advance it to \1 AM will be ignored."
ELSE
hour = \1
IF hour == 12
hour = 0
ENDC
ENDC

ELSE
IF "\2" == "PM"
IF \1 == 0 || \1 > 12
FAIL "Cannot advance clock to \1 PM."
ENDC
IF hour != -1
WARN "Already advancing clock to {hour} hours. The attempt to advance it to \1 PM will be ignored."
ELSE
hour = \1 + 12
IF hour == 24
hour = 12
ENDC
ENDC

ELSE
IF "\2" == "weekday"
IF \1 > 6
FAIL "There are only 7 days in a week. Cannot advance clock to Day #\1."
ENDC
IF weekday != -1
WARN "Already advancing clock to Day #{weekday}. The attempt to advance it to Day #\1 will be ignored."
ELSE
weekday == \1
ENDC

ELSE
FAIL "Unrecognized unit of time '\2'."

ENDC
ENDC
ENDC
ENDC
ENDC
ENDC
SHIFT
SHIFT
ENDR
	
IF second != -1
	ld a, second
	call AdvanceToSecond
ENDC
IF minute != -1
	ld a, minute
	call AdvanceToMinute
ENDC
IF hour != -1
	ld a, hour
	call AdvanceToHour
ENDC
IF weekday != -1
	ld a, weekday
	call AdvanceToWeekday
ENDC
ENDM
