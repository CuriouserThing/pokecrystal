UpdateTime::
; get time of day based on the current hour
	ld a, [WorldHours]
	ld hl, TimesOfDay
.check
; if we're within the given time period,
; get the corresponding time of day
	cp [hl]
	jr c, .match
; else, get the next entry
	inc hl
	inc hl
; try again
	jr .check
.match
; get time of day
	inc hl
	ld a, [hl]
	ld [TimeOfDay], a
	ret

TimesOfDay:
; hours for the time of day
; 04-09 morn | 10-17 day | 18-03 nite
	db 04, NITE
	db 10, MORN
	db 18, DAY
	db 24, NITE
	db -1, MORN

SaveClock:
	ld a, BANK(sWorldClock)
	call OpenSRAM
	ld hl, hWorldClock
	ld de, sWorldClock
	ld bc, 10
	call CopyBytes	
	call CloseSRAM
	ret
