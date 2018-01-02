RTC::
; update time and time-sensitive palettes
; rtc enabled?
	ld a, [wSpriteUpdatesEnabled]
	and a
	ret z
	callba UpdateTime
; obj update on?
	ld a, [VramState]
	bit 0, a ; obj update
	ret z

TimeOfDayPals::
	callba _TimeOfDayPals
	ret

UpdateTimePals::
	callba _UpdateTimePals
	ret
