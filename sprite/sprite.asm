	org 40000
screen:	equ $1800
sppatt:	equ $3800
spattr:	equ $1b00
count:	equ 9
	;; screen pattern
	ld hl,screen
	call vidaddr
	ld a,$83
	ld bc,$0003
scloop:
	out ($98),a
	djnz scloop
	dec c
	jp nz,scloop
	;; sprite data
	ld hl,sppatt
	call vidaddr
	ld hl,sprites
	ld bc,$0898
	otir
main:	
	;; sprite attribute
	ld hl,spattr
	call vidaddr
	ld hl,pos
	ld c,$98
	ld d,count
upspr:
	;; y
	inc hl
	ld a,(hl)
	out (c),a
	inc hl
	;; x
	inc hl
	ld a,(hl)
	out (c),a
	inc hl
	;; pattern number
	ld a,(hl)
	out (c),a
	inc hl
	;; color
	ld a,(hl)
	out (c),a
	inc hl
	dec d
	jr nz,upspr
	;; ret
;;; 	jr main
	ld bc,pos
	ld hl,vel
	ld d,count
mvsprt:
	call add16
	call add16
	inc bc
	inc bc
	dec d
	jr nz,mvsprt
	ld hl,pos
	ld bc,vel
	ld d,count
check:
	ld e,183
	call ck
	ld e,247
	call ck
	add hl,2
	dec d
	jr nz,check
	halt
	jr main
	ret
vidaddr:
	di
	ld a,l
	out ($99),a
	ld a,h
	or $40
	out ($99),a
	ei
	ret
add16:
	ld a,(bc)
	add a,(hl)
	ld (bc),a
	inc bc
	inc hl
	ld a,(bc)
	adc a,(hl)
	ld (bc),a
	inc bc
	inc hl
	ret
ck:
	inc hl
	ld a,(hl)
	inc hl
	cp e
	jr c,noop
	ld a,(bc)
	cpl
	inc a
	ld (bc),a
	inc bc
	ld a,(bc)
	cpl
	adc a,0
	ld (bc),a
	inc bc
	ret
noop:
	inc bc
	inc bc
	ret
sprites:
	db $3c,$7e,$e7,$c3,$c3,$e7,$7e,$3c
pos:
	dw $5c00,$7c00,$0100
	dw $5c00,$7c00,$0200
	dw $5c00,$7c00,$0300
	dw $5c00,$7c00,$0400
	dw $5c00,$7c00,$0500
	dw $5c00,$7c00,$0600
	dw $5c00,$7c00,$0700
	dw $5c00,$7c00,$0800
	dw $5c00,$7c00,$0900
	dw $5c00,$7c00,$0a00
	dw $5c00,$7c00,$0b00
	dw $5c00,$7c00,$0c00
	dw $5c00,$7c00,$0d00
	dw $5c00,$7c00,$0e00
	dw $5c00,$7c00,$0f00
	dw $5c00,$7c00,$0100
vel:
	dw $0000,$0000
	dw $0000,$00ff
	dw $00ff,$0000
	dw $0000,$ff01
	dw $ff01,$0000
	dw $00b4,$00b4
	dw $00b4,$ff4c
	dw $ff4c,$ff4c
	dw $ff4c,$00b4
	dw $0000,$0000
	dw $0000,$0000
	dw $0000,$0000
	dw $0000,$0000
	dw $0000,$0000
	dw $0000,$0000
	dw $0000,$0000
	
	
