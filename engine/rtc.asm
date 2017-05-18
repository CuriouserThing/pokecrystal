GetTimeOfDay::
; get time of day based on the current hour
	ld a, [WorldHours] ; hour
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

StageRTCTimeForSave:
	call UpdateTime
	ld hl, wRTC
	ld a, [CurDay]
	ld [hli], a
	ld a, [WorldHours]
	ld [hli], a
	ld a, [WorldMinutes]
	ld [hli], a
	ld a, [WorldSeconds]
	ld [hli], a
	ret

SaveRTC:
	ld a, $a
	ld [MBC5SRamEnable], a
	ld a, BANK(sRTCStatusFlags)
	ld [MBC5SRamBank], a
	xor a
	ld [sRTCStatusFlags], a
	call CloseSRAM
	ret

StartClock::
	ret
	; bit 5: Day count exceeds 139
	; bit 6: Day count exceeds 255
	jp RecordRTCStatus ; set flag on sRTCStatusFlags

Function140ae:
	call CheckRTCStatus
	ld c, a
	and %11000000 ; Day count exceeded 255 or 16383
	jr nz, .time_overflow

	ld a, c
	and %00100000 ; Day count exceeded 139
	jr z, .dont_update

	call UpdateTime
	ld a, [wRTC + 0]
	ld b, a
	ld a, [CurDay]
	cp b
	jr c, .dont_update

.time_overflow
	farcall ClearDailyTimers
	farcall Function170923
; mobile
	ld a, $5
	call GetSRAMBank
	ld a, [$aa8c]
	inc a
	ld [$aa8c], a
	ld a, [$b2fa]
	inc a
	ld [$b2fa], a
	call CloseSRAM
	ret

.dont_update
	xor a
	ret

_InitTime::	
	ld a, [StringBuffer2 + 3]
	ld [WorldSeconds], a
	ld a, [StringBuffer2 + 2]
	ld [WorldMinutes], a
	ld a, [StringBuffer2 + 1]
	ld [WorldHours], a
	ld a, [StringBuffer2]
	ld [WorldDaysLow], a
	
	ld a, $e1
	ld [WorldSpeedHigh], a
	ld a, 00
	ld [WorldSpeedLow], a
	ld a, 1
	ld [WorldRunning], a
	ret
