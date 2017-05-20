pause_world_via_script: MACRO
	ld hl, WorldPaused
	set SCRIPT_PAUSE, [hl]
ENDM

pause_world_via_engine: MACRO
	ld hl, WorldPaused
	set ENGINE_PAUSE, [hl]
ENDM

reset_world_pause_from_script: MACRO
	ld hl, WorldPaused
	res SCRIPT_PAUSE, [hl]
ENDM

reset_world_pause_from_engine: MACRO
	ld hl, WorldPaused
	res ENGINE_PAUSE, [hl]
ENDM

hard_unpause_world: MACRO
	xor a
	ld [WorldPaused], a
ENDM



clock_multiplier: MACRO
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
ENDM

define_clock_multiplier: MACRO
	clock_multiplier \1
	dw m
ENDM

set_clock_multiplier: MACRO
	clock_multiplier \1
hi = (m & $ff00) >> 8
lo = m & $00ff
IF hi == 0
	xor a
ELSE
	ld a, hi
ENDC
	ld [WorldSpeedHigh], a
IF hi < $e1
IF lo != hi
IF lo == 0
	xor a
ELSE
	ld a, lo
ENDC
ENDC
	ld [WorldSpeedLow], a
ENDC
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
IF "\2" == "oclock" || "\2" == "hours"
IF \1 > 23
FAIL "Cannot advance clock to \1 oclock."
ENDC
IF hour != -1
WARN "Already advancing clock to {hour} o'clock. The attempt to advance it to \1 o'clock will be ignored."
ELSE
hour = \1
ENDC

ELSE
IF "\2" == "AM"
IF \1 == 0 || \1 > 12
FAIL "Cannot advance clock to \1 AM."
ENDC
IF hour != -1
WARN "Already advancing clock to {hour} o'clock. The attempt to advance it to \1 AM will be ignored."
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
WARN "Already advancing clock to {hour} o'clock. The attempt to advance it to \1 PM will be ignored."
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



advance_clock_by: MACRO
seconds = 0
minutes = 0
hours   = 0
days    = 0

IF _NARG % 2 == 1
FAIL "Odd number of arguments."
ENDC

REPT _NARG / 2

IF "\2" == "seconds"
IF seconds != 0
WARN "Already advancing clock by {seconds} seconds. The attempt to advance it by \1 seconds will be ignored."
ELSE
seconds = \1
ENDC

ELSE
IF "\2" == "minutes"
IF minutes != 0
WARN "Already advancing clock by {minutes} minutes. The attempt to advance it by \1 minutes will be ignored."
ELSE
minutes = \1
ENDC

ELSE
IF "\2" == "hours"
IF hours != 0
WARN "Already advancing clock by {hours} hours. The attempt to advance it by \1 hours will be ignored."
ELSE
hours = \1
ENDC

ELSE
IF "\2" == "days"
IF days != 0
WARN "Already advancing clock by {days} days. The attempt to advance it by \1 days will be ignored."
ELSE
days = \1
ENDC

ELSE
FAIL "Unrecognized unit of time '\2'."
ENDC

IF \1 == 0
WARN "Advancing the clock by 0 \2 does nothing."
ENDC

ENDC
ENDC
ENDC
SHIFT
SHIFT
ENDR

minutes = minutes + seconds / 60
seconds = seconds % 60
hours = hours + minutes / 60
minutes = minutes % 60
days = days + hours / 24
hours = hours % 24
days_low = days & $ff
days_high = (days & $ff00) >> 8

IF seconds > 0
	ld a, seconds
	call AdvanceBySeconds
ENDC
IF minutes > 0
	ld a, minutes
	call AdvanceByMinutes
ENDC
IF hours > 0
	ld a, hours
	call AdvanceByHours
ENDC
IF days_low > 0
	ld a, days_low
	call AdvanceByDays
ENDC
IF days_high > 0
	ld a, [WorldDaysHigh]
	add days_high
	ld [WorldDaysHigh], a
ENDC
ENDM
