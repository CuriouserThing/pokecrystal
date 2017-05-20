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
