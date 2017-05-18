UpdateTime::
	farcall GetTimeOfDay
	ret

SetTimeOfDay::
	xor a
	ld [StringBuffer2], a ; Set Day to 0
	; Hour to set in StringBuffer2 + 1
	; Minute to set in StringBuffer2 + 2
	ld [StringBuffer2 + 3], a ; Set Second to 0
	jr InitTime

SetDayOfWeek::
	call UpdateTime
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

ClearRTCStatus::
; clear sRTCStatusFlags
	xor a
	push af
	ld a, BANK(sRTCStatusFlags)
	call GetSRAMBank
	pop af
	ld [sRTCStatusFlags], a
	call CloseSRAM
	ret

RecordRTCStatus::
; append flags to sRTCStatusFlags
	ld hl, sRTCStatusFlags
	push af
	ld a, BANK(sRTCStatusFlags)
	call GetSRAMBank
	pop af
	or [hl]
	ld [hl], a
	call CloseSRAM
	ret

CheckRTCStatus::
; check sRTCStatusFlags
	ld a, BANK(sRTCStatusFlags)
	call GetSRAMBank
	ld a, [sRTCStatusFlags]
	call CloseSRAM
	ret
