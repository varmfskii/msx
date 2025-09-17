;;; 
;;; msx program for a simple sprite demo to be called from BASIC width
;;; screen 1
;;; todo: set screen mode explicitly
;;; todo: write another version for msxdos
;;; 
scaddy:	equ $1800		; address of screen in vram
spattr:	equ $1b00		; address of sprite attributes in vram
sppatt:	equ $3800		; address of sprite patterns in vram
vdpdat:	equ $98			; vdp data read/write port
vdpsel:	equ $99			; vdp register/address select port
;;; 
diamond:	equ $83		; value of diamond character
maxx:	equ 248			; maximum x coordinate
maxy:	equ 184			; maximum y coordinate
numpat:	equ 1			; number of sprite patterns
spcnt:	equ 9			; number of sprites
;;; 
	org 40960-7
	db $fe			; type
	dw begin,end+1,start
begin:
start:	
;;; fill screen with diamonds
	ld hl,scaddy
	call vidaddr
	ld a,diamond
	ld bc,$0003
scloop:
	out (vdpdat),a
	djnz scloop
	dec c
	jp nz,scloop
;;; set sprite pattern data
	ld hl,sppatt
	call vidaddr
	ld hl,sprites
	ld b,8*numpat
	ld c,vdpdat
	otir
main:	
;;; set sprite attributes to new values
	ld hl,spattr
	call vidaddr
	ld hl,pos
	ld d,spcnt
upspr:
	;; y
	inc hl
	ld a,(hl)
	out (vdpdat),a
	inc hl
	;; x
	inc hl
	ld a,(hl)
	out (vdpdat),a
	inc hl
	;; pattern number
	ld a,(hl)
	out (vdpdat),a
	inc hl
	;; color
	ld a,(hl)
	out (vdpdat),a
	inc hl
	dec d
	jr nz,upspr
;;; move sprites
	ld bc,pos
	ld hl,vel
	ld d,spcnt
mvsprt:
	call add16
	call add16
	inc bc
	inc bc
	dec d
	jr nz,mvsprt
;;; check if sprites have moved out of bounds. If so invert velocity
	ld bc,pos
	ld hl,vel
	ld d,spcnt
cksprt:
	ld e,maxy
	call chkbnd
	ld e,maxx
	call chkbnd
	inc bc
	inc bc
	dec d
	jr nz,cksprt
	halt
	jr main
	ret
vidaddr:
;;; 
;;; set address in vram
;;;
;;; hl - vram address
;;; a - modified
;;; 
	di
	ld a,l
	out (vdpsel),a
	ld a,h
	or $40
	out (vdpsel),a
	ei
	ret
add16:
;;; 
;;; add 16-bit numbers (op1<-op1+op2)
;;;
;;; bc - pointer to op1, increased by two
;;; hl - pointer to op2, increased by two
;;; a - modified
;;; 
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
chkbnd:
;;;
;;; check if sprite has moved out of bounds. If it has invert velocity
;;; component
;;; 
;;; hl - pointer to sprite velocity (8.8), increased by two
;;; e - upper bound
;;; bc - pointer to sprite position (8.8), increased by two
;;; a - modified
;;; 
	inc bc
	ld a,(bc)
	inc bc
	cp e
	jr c,noop
	;; change sign of velocity
	ld a,(hl)
	neg
	ld (hl),a
	inc hl
	ld a,(hl)
	cpl
	inc a
	sbc a,0
	ld (hl),a
	inc hl
	ret
noop:
	inc hl
	inc hl
	ret
;;; sprite patterns
sprites:
	db $3c,$7e,$e7,$c3,$c3,$e7,$7e,$3c
;;; sprite attributes
;;; 
;;; 2 - y in 8.8
;;; 2 - x in 8.8
;;; 1 - pattern number
;;; 1 - color number
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
;;; sprite velocities
;;; 
;;; 2 - yv in 8.8
;;; 3 - xv in 8.8
vel:
	dw $0000,$0000
	dw $0000,$0100
	dw $0100,$0000
	dw $0000,$ff00
	dw $ff00,$0000
	dw $00b5,$00b5
	dw $00b5,$ff4b
	dw $ff4b,$ff4b
	dw $ff4b,$00b5
end:	
