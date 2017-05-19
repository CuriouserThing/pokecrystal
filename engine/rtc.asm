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
	ld a, SRAM_ENABLE
	ld [MBC5SRamEnable], a
	ld a, BANK(sWorldClock)
	ld [MBC5SRamBank], a
	ld hl, hWorldClock
	ld de, sWorldClock
	ld bc, 10
	call CopyBytes	
	call CloseSRAM
	ret

LoadClock:
	ld a, SRAM_ENABLE
	ld [MBC5SRamEnable], a
	ld a, BANK(sWorldClock)
	ld [MBC5SRamBank], a
	ld hl, sWorldClock
	ld de, hWorldClock
	ld bc, 10
	call CopyBytes	
	call CloseSRAM
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
	
	set_clock_multiplier 104.25
	ld b, 13
	farcall AdvanceByMinutes
	ld b, 20
	farcall AdvanceToMinute
	unpause_clock
	ret
