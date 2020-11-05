; Adrian Faircloth
; 11/04/2020
; Project 8: Bounce
; Allows message of up to 78 chars to bounce horizontally across the screen

;; Macro for printing messages
;; Pass starting address and length
%macro	Print 2
	
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, %1
	mov	edx, %2
	
	int	80h
%endmacro

;; Macro for processing row and col parameters
;; Pass row and col as immediate vals
%macro	setCursor 2
;; Putting row and col vals into ah and al respectively
	mov	ah, %1
	mov	al, %2
	push	eax
;; Process row
	shr	ax, 8
	mov	bl, 10
	div	bl	;; Puts ax/10 into al, remainder in ah
	add	ah, '0' ;; Converts param vals into characters
	add	al, '0'
	mov	BYTE[row], al
	mov	BYTE[row+1], ah
;; Process column
	pop	eax      ;; Restore parameters
	and 	ax, 0FFh ;; Erases ah, leaving al w/ col value
	mov	bl, 10
	div	bl
	add	ah, '0'
	add	al, '0'
	mov	BYTE[col], al
	mov	BYTE[col+1], ah
%endmacro
SECTION .data
;; data struct for message
message:   db    " "  ;;; one space
       	   db    "I enjoy Assembly programming :)"
       	   db    " "  ;;; one more space
msglen:    EQU    ($-message)

clr        db 1bh,'[2J'   ;; clear screen string
seconds:   dd 0, 30000000 ;; seconds, nanoseconds
;; Set cursor position control chars
pos     db      1bh, '['
row     db      '00'
        db      ';'
col     db      '00'
        db      'H'

colCount: db	0	;; Tracks starting column for message
SECTION .bss
; define uninitiialized data here

SECTION .text
global _main, _clrscr, _pause, _cursor
_main:
	call	_clrscr
bounce:	;; Infinite loop for BOUNCE
;; Setting up ecx w/ number of empty spaces after end of msg
	xor	ecx, ecx
	mov	cl, 80
	sub	cl, BYTE[colCount]
	sub	cl, msglen
incCol:	;; Loop for increasing starting col until end of msg hits col 80
	push	ecx
	call	_cursor
	Print	message, msglen
	call	_pause
	inc	BYTE[colCount]
	pop	ecx
	loop	incCol
	mov	cl, [colCount]	;; Sets ecx to # of starting col increases
decCol:	;; Loop for decreasing starting col back to 0
	push	ecx
	call	_cursor
	Print	message, msglen
	call	_pause
	dec	BYTE[colCount]
	pop	ecx
	loop	decCol
	jmp	bounce	;; infinitely looping BOUNCE
	
; Normal termination code
mov eax, 1
mov ebx, 0
int 80h

;;;;;;;;;;;;;;;;;;; END OF MAIN ;;;;;;;;;;;;;;;;;;;;;;;;
;; Function for clearing screen
_clrscr:
	pusha
	Print clr, 4
	popa
	ret

;; Function to pause for about 1/10 second
_pause:
	pusha
	mov	eax, 162
	mov	ebx, seconds
	mov	ecx, 0
	int	80h
	popa
	ret

;; Function for setting cursor position
_cursor:
	pusha
	setCursor 10, [colCount] ;; Sets cursor control based on starting col
	Print	pos, 8		 ;; Prints cursor control characters
	popa
	ret
