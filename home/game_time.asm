ResetGameTime:: ; 208a
	xor a
	ld [GameTimeCap], a
	ld [GameTimeHours], a
	ld [GameTimeHours + 1], a
	ld [GameTimeMinutes], a
	ld [GameTimeSeconds], a
	ld [GameTimeFrames], a
	ret
; 209e


GameTimer:: ; 209e

	nop

	ld a, [rSVBK]
	push af
	ld a, 1
	ld [rSVBK], a

	call UpdateGameTimer
	call UpdateWorldClock

	pop af
	ld [rSVBK], a
	ret
; 20ad


UpdateGameTimer:: ; 20ad
; Increment the game timer by one frame.
; The game timer is capped at 999:59:59.00.


; Don't update if game logic is paused.
	ld a, [wGameLogicPaused]
	and a
	ret nz

; Is the timer paused?
	ld hl, GameTimerPause
	bit 0, [hl]
	ret z

; Is the timer already capped?
	ld hl, GameTimeCap
	bit 0, [hl]
	ret nz


; +1 frame
	ld hl, GameTimeFrames
	ld a, [hl]
	inc a

	cp 60 ; frames/second
	jr nc, .second

	ld [hl], a
	ret


.second
	xor a
	ld [hl], a

; +1 second
	ld hl, GameTimeSeconds
	ld a, [hl]
	inc a

	cp 60 ; seconds/minute
	jr nc, .minute

	ld [hl], a
	ret


.minute
	xor a
	ld [hl], a

; +1 minute
	ld hl, GameTimeMinutes
	ld a, [hl]
	inc a

	cp 60 ; minutes/hour
	jr nc, .hour

	ld [hl], a
	ret


.hour
	xor a
	ld [hl], a

; +1 hour
	ld a, [GameTimeHours]
	ld h, a
	ld a, [GameTimeHours + 1]
	ld l, a
	inc hl


; Cap the timer after 1000 hours.
	ld a, h
	cp 1000 / $100
	jr c, .ok

	ld a, l
	cp 1000 % $100
	jr c, .ok

	ld hl, GameTimeCap
	set 0, [hl]

	ld a, 59 ; 999:59:59.00
	ld [GameTimeMinutes], a
	ld [GameTimeSeconds], a
	ret


.ok
	ld a, h
	ld [GameTimeHours], a
	ld a, l
	ld [GameTimeHours + 1], a
	ret
; 210f


UpdateWorldClock::
	; Don't update if the world isn't running right now
	ld a, [WorldRunning]
	and a
	ret z
	
	push de
	
	; Speed is capped at $e100  (57,600)
	; This signifies an addition of one world-minute this update (16 ticks * 60 frames * 60 seconds)
	ld a, [WorldSpeedHigh]
	cp $e1
	jr c, .full_update ; ...else, simple update
	ld hl, WorldMinutes
	ld a, [hl]
	inc a
	cp 60 ; minutes per hour
	jr nc, .hours
	ld [hl], a
	jr .end
	
.full_update
	; In a, load # of ticks to add this frame
	ld a, [WorldSpeedLow]
	and $f
	; Add ticks
	ld hl, WorldTicks
	add [hl]
	cp 16
	jr c, .continue
	sub 16
	ld hl, WorldFrames
	inc [hl]
	inc hl ; -> WorldTicks
.continue
	ld [hld], a
	
	; In de, load # of world-frames to add this frame (big endian)
	ld a, [WorldSpeedHigh]
	swap a
	ld e, a
	and $0f
	ld d, a
	ld a, e
	and $f0
	ld e, a
	ld a, [WorldSpeedLow]
	swap a
	and $0f
	or e
	ld e, a
	
	; Add 1 world-second for every 60 world-frames (0-59 world-seconds total)
	dec hl ; -> WorldSeconds
.loop
	cp 60 ; frames per seconds
	jr nc, .add_second
	ld a, d
	and a
	jr nz, .add_four_seconds
	jr .break
.add_second
	inc [hl]
	sub 60
	jr .loop
.add_four_seconds
	ld a, [hl]
	add 4
	ld [hl], a
	dec d
	ld a, e
	add 16 ; 256 - 60 * 4
	jr .loop
.break

	; Add remainder of world-frames (0-59)
	ld a, [WorldFrames]
	add e
	cp 60 ; frames per seconds
	jr c, .seconds
	inc [hl] ; WorldSeconds
	sub 60
.seconds
	ld [WorldFrames], a
	ld a, [hl] ; WorldSeconds
	cp 60 ; seconds per minute
	jr c, .minutes
	ld hl, WorldMinutes
	inc [hl]
	inc hl
	sub 60
.minutes
	ld [hld], a ; WorldSeconds
	ld a, [hl] ; WorldMinutes
	cp 60 ; minutes per hour
	jr c, .end
.hours
	xor a
	ld [hld], a ; WorldMinutes
	ld a, [hl] ; WorldHours
	inc a
	cp 24 ; hours per day
	jr nc, .days
	ld [hl], a
	jr .end
.days
	xor a
	ld [hld], a ; WorldHours
	ld a, [hl] ; WorldDaysLow
	inc a
	ld [hld], a
	and a
	jr nz, .end
	inc [hl] ; WorldDaysHigh
	
.end
	pop de
	ret
