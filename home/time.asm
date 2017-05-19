RTC::
; update time and time-sensitive palettes
; rtc enabled?
	ld a, [wSpriteUpdatesEnabled]
	and a
	ret z
	farcall UpdateTime
; obj update on?
	ld a, [VramState]
	bit 0, a ; obj update
	ret z

TimeOfDayPals::
	farcall _TimeOfDayPals
	ret

UpdateTimePals::
	farcall _UpdateTimePals
	ret

SetTimeOfDay::
	xor a
	ld [StringBuffer2], a ; Set Day to 0
	; Hour to set in StringBuffer2 + 1
	; Minute to set in StringBuffer2 + 2
	ld [StringBuffer2 + 3], a ; Set Second to 0
	jr InitTime

SetDayOfWeek::
	farcall UpdateTime
	; Day to set in StringBuffer2
	ld a, [WorldHours]
	ld [StringBuffer2 + 1], a ; Keep Hour
	ld a, [WorldMinutes]
	ld [StringBuffer2 + 2], a ; Keep Minute
	ld a, [WorldSeconds]
	ld [StringBuffer2 + 3], a ; Keep Second

InitTime::
	farcall _InitTime
	ret
