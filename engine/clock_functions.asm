AdvanceToSecond::
	ld hl, WorldSeconds
	ld a, [hl]
	cp b
	ld a, b
	ld [hld], a
	jr nc, add_minute
	ret
AdvanceBySeconds::
	ld hl, WorldSeconds
	ld a, [hl]
	add b
	cp 60
	jr nc, .overflow_seconds
	ld [hl], a
	ret
.overflow_seconds
	xor a
	ld [hld], a
add_minute
	ld a, [hl]
	inc a
	jr check_minute_overflow

AdvanceToMinute::
	ld hl, WorldMinutes
	ld a, [hl]
	cp b
	ld a, b
	ld [hld], a
	jr nc, add_hour
	ret
AdvanceByMinutes::
	ld hl, WorldMinutes
	ld a, [hl]
	add b
check_minute_overflow
	cp 60
	jr nc, .overflow_minutes
	ld [hl], a
	ret
.overflow_minutes
	xor a
	ld [hld], a
add_hour
	ld a, [hl]
	inc a
	jr check_hour_overflow

AdvanceToHour::
	ld hl, WorldHours
	ld a, [hl]
	cp b
	ld a, b
	ld [hld], a
	jr nc, add_day
	ret
AdvanceByHours::
	ld hl, WorldHours
	ld a, [hl]
	add b
check_hour_overflow
	cp 24
	jr nc, .overflow_hours
	ld [hl], a
	ret
.overflow_hours
	xor a
	ld [hld], a
add_day
	inc [hl]
	ret nc
	dec hl
	inc [hl]
	ret

AdvanceByDays::
	ld hl, WorldDaysLow
	ld a, [hl]
	add c
	jr nc, .no_overflow
	inc b
.no_overflow
	ld [hld], a
	ld a, [hl]
	add b
	ld [hl], a
	ret
	