; All clock advance functions take their argument from a, use hl, and preserve bc and de

AdvanceToSecond::
	ld hl, WorldSeconds
	cp [hl]
	ld [hld], a
	ret nc
	jr add_minute
AdvanceBySeconds::
	ld hl, WorldSeconds
	add [hl]
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
	cp [hl]
	ld [hld], a
	ret nc
	jr add_hour
AdvanceByMinutes::
	ld hl, WorldMinutes
	add [hl]
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
	cp [hl]
	ld [hld], a
	ret nc
	jr add_day
AdvanceByHours::
	ld hl, WorldHours
	add [hl]
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
	ret c
	dec hl
	inc [hl]
	ret

AdvanceToWeekday::
	push bc
	ld c, a
	call GetWeekday
	ld b, a
	ld a, c
	sub b
	pop bc
	jr nc, AdvanceByDays
	add 7	
AdvanceByDays::
	ld hl, WorldDaysLow
	add [hl]
	ld [hld], a
	ret nc
	inc [hl]
	ret
