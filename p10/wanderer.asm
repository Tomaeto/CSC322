; Adrian Faircloth
; 11/17/2020
; Program 10: The Wanderer
; Creates a closed region in which a message moves randomly
; Works for message of any size that fits within region

;; Macro for printing
;; Pass start address of string and size
%macro Print 2
	pusha
	mov	ecx, %1
	mov	edx, %2
	mov	eax, 4
	mov	ebx, 1
	int	80h
	popa
%endmacro

;; Macro for getting a random value from 0 to 2 based on rdtsc instruction
;; Used in randomizing header character's position
;; Randomized value placed in al register
%macro randVal 0
	rdtsc
        ;; Setting ah and al to contain first and second bits from eax
        mov     ah, al
        and     al, 01  ;; Setting al to 0 or 1 based on first bit
        shr     ah, 2   ;; Getting 2nd bit value into leftmost bit
        and     ah, 01  ;; Setting ah to 0 or 1 based on first bit
        add     al, ah  ;; Adding 1st and 2nd bit to get 0, 1, or 2
%endmacro

;; Data structure for each character
;; Contains spaces for location and character data
STRUC	msgStruc
		RESB	2 ;; Space for esc'['
	.row:	RESB	2 ;; Space for 2-digit row number (characters)
		RESB	1 ;; Space for ';'
	.col:	RESB	2 ;; Space for 2-digit col number (characters)
		RESB	1 ;; Space for the 'H'
	.char:	RESB	1 ;; Space for the printed character
	.size:
ENDSTRUC	
	
SECTION .data

clr:	db	1bh, '[2J'	;; Clear screen string
;; Region bounds
ends:	db	'****************************************'
middle: db	"*                                      *"
ten:	db	10	

;; Array of structs, formatted like print interrupt uses
;; Contains the message "Snaking Message"
message:	db	1bh, '[15;15HS'
		db      1bh, '[15;16Hn'
		db      1bh, '[15;17Ha'
		db	1bh, '[15;18Hk'
		db	1bh, '[15;19Hi'
		db	1bh, '[15;20Hn'
		db	1bh, '[15;21Hg'
		db	1bh, '[15;22H '
		db	1bh, '[15;23HM'
		db	1bh, '[15;24He'
		db	1bh, '[15;25Hs'
		db	1bh, '[15;26Hs'
		db	1bh, '[15;27Ha'
		db	1bh, '[15;28Hg'
		db	1bh, '[15;29He'
		db	1bh, '[15;30H '
msgLen:	EQU	16	;; Number of characters in message
pause:	dd	0, 500000000 ;; Seconds, nanoseconds
; Set cursor position control characters
pos     db      1bh, '['
row     db      '00'
        db      ';'
col     db      '00'
        db      'H'

SECTION .bss

SECTION .text
global _main, _makeRegion, _displayMsg, _adjustMessage, _sleep, _setCursor
_main:

	Print	clr, 4	
	;; Setting cursor so region prints from first row and col on screen
	mov	ax, 0
	call	_setCursor
	call	_makeRegion

wander:  ;; infinite loop for wandering message
loopBreak:
	call 	_displayMsg	
	call	_adjustMessage	
	call	_sleep
	jmp	wander

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
;;;;;;;;;;;;;;;;;;;;;;;;; END OF MAIN ;;;;;;;;;;;;;;;;;;;;;;;;;

;; Function for making closed region
;; Creates a 20x40 region
_makeRegion:
	Print	ends, 40
	Print	ten, 1	
	mov	ecx, 18
printMid: ;;Loop to create middle sections of region
	Print	middle, 40
	Print	ten, 1
	loop	printMid
	Print	ends, 40
	ret
	
;; Function for displaying message within region
_displayMsg:
	pusha
	mov	eax, message+(msgStruc.size*(msgLen-1))
	mov	ecx, msgLen
displayChars: ;;Loop for printing each character
	push	ecx
	Print	eax, 9
	sub	eax, msgStruc.size ;; Point to previous character
	pop	ecx
	loop displayChars
	popa
	ret

;; Function for adjusting location parms for each character
;; Shifts location parms down to next char & randomly chooses head's next loc
;; If head is about to enter boundary, wraps around to other side of region
;; All comparisons done w/ characters as data is saved that way in Struct
_adjustMessage:
	pusha

;; Shifting first digit of row data
	mov	ebx, message	;; Pointer to array
	mov	ecx, msgLen-1
	mov	dl, [message+msgStruc.row+1] ;;Get 1st char's row to start loop
shiftRow:
	mov	al, dl ;; Put current char's row into al
	mov	dl, [ebx+msgStruc.size+msgStruc.row+1] ;; Gew row of next char
	add	ebx, msgStruc.size
	mov	[ebx+msgStruc.row+1], al ;; Put current char's row into next
	loop	shiftRow

;;Shifting 2nd digit of row data
	mov	ebx, message
	mov	ecx, msgLen-1
	mov	dl, [message+msgStruc.row] 
shiftRow2nd:
	mov	al, dl
	mov	dl, [ebx+msgStruc.size+msgStruc.row]
	add	ebx, msgStruc.size
	mov	[ebx+msgStruc.row], al
	loop	shiftRow2nd
	
;; Shifting first digit of column data
	mov	ebx, message
	mov	ecx, msgLen-1
	mov	dl, [ebx+msgStruc.col+1] ;; Get 1st char's col to start loop
shiftCol:
	mov	al, dl ;;Put current char's row into al
	mov	dl, [ebx+msgStruc.size+msgStruc.col+1] ;; Get col of next char
	add	ebx, msgStruc.size
	mov	[ebx+msgStruc.col+1], al ;; Put current char's row into next
	loop	shiftCol

;; Shifting second digit of column data
	mov	ebx, message
	mov	ecx, msgLen-1
	mov	dl, [ebx+msgStruc.col]
shiftCol2nd:
	mov	al, dl
	mov	dl, [ebx+msgStruc.size+msgStruc.col]
	add	ebx, msgStruc.size
	mov	[ebx+msgStruc.col], al
	loop	shiftCol2nd

;; Randomizing 1st char's next row
	randVal
;	;; if sum=2, set value to -1
	cmp	al, 2
	jne	notNegRow
	mov	al, -1
notNegRow:
	mov	ebx, message ;; Pointer to first struct in array
	;; If first digit of row data >= 10, incrementing second digit
	;; Done by checking if 1st digit is 9 and if digit to be added = 1
	cmp	BYTE[ebx+msgStruc.row+1], '9' 
	jl	skipInc
	cmp	al, 1
	jne	skipInc
	;; If true, first digit set to 0 and second incremented
	;; subtracting 10 is offset by later adding 1 from al
	sub	BYTE[ebx+msgStruc.row+1], 10
	add	BYTE[ebx+msgStruc.row], 1
skipInc:
	;; If first digit of row data < 0, decrementing second digit
	;; Done by checking if 1st digit is 0 and if digit to be added = -1
	cmp	BYTE[ebx+msgStruc.row+1], '0'
	jg	skipDec
	cmp	al, -1
	jne	skipDec
	;; If true, first digit set to 9 and second decremented
	;; Adding 10 is offset by later adding -1 from al
	add	BYTE[ebx+msgStruc.row+1], 10
	sub	BYTE[ebx+msgStruc.row], 1
skipDec:
	add	[ebx+msgStruc.row+1], al ;; Adding random value to row (-1,0,1)

;; Wrapping around if char going to enter region bounds
	cmp	BYTE[ebx+msgStruc.row], '2' ;;check if row data >= 20
	jl	notBotBound
	;; if row data >= 20, set row to 2
	mov	BYTE[ebx+msgStruc.row], '0'
	mov	BYTE[ebx+msgStruc.row+1], '2'
notBotBound:
	cmp	BYTE[ebx+msgStruc.row], '0' ;; check if row data below 10
	jne	notTopBound
	cmp	BYTE[ebx+msgStruc.row+1], '1' ;; check if row data = 1
	jne	notTopBound
	;; if row data = 1, set row to 19
	mov	BYTE[ebx+msgStruc.row], '1'
	mov	BYTE[ebx+msgStruc.row+1], '9'
notTopBound:

;; Randomizing 1st char's next column
	randVal
	;; if sum=2, set value to -1
	cmp	al, 2
	jne	notNegCol
	mov	al, -1
notNegCol:
	;; If first digit of col data >=10, incrementing second digit
	;; Done by checking if 1st digit = 9  and if value to be added = 1
	cmp	BYTE[ebx+msgStruc.col+1], '9' 
	jne	skipIncCol
	cmp	al, 1
	jne	skipIncCol
	;;If true first digit set to 9 and 2nd digit incremented
	;; Subtracting 10 is offset by adding 1 from al
	sub	BYTE[ebx+msgStruc.col+1], 10
	add	BYTE[ebx+msgStruc.col], 1
skipIncCol:
	;; If first digit of col data < 0, decrementing second digit
	;; Done by checking if 1st digit = 0  and if value to be added = -1
	cmp	BYTE[ebx+msgStruc.col+1], '0'
	jne	skipDecCol
	cmp	al, -1
	jne	skipDecCol
	;; If true, 1st digit set to 9 and 2nd digit decremented
	;; Adding 10 to 1st digit offset by adding -1 from al
	add	BYTE[ebx+msgStruc.col+1], 10
	sub	BYTE[ebx+msgStruc.col], 1
skipDecCol:
	add	[ebx+msgStruc.col+1], al ;; adding random value to col (-1,0,1)

;; Wrapping around if char going to enter region bounds
	cmp	BYTE[ebx+msgStruc.col], '4' ;; Check if col data = 40
	jne	notRightBound
	;;If col data =40, set col to 2
	mov	BYTE[ebx+msgStruc.col],'0'
	mov	BYTE[ebx+msgStruc.col+1], '2' 
notRightBound:
	cmp	BYTE[ebx+msgStruc.col], '0' ;; Check if col is below 10
	jne	notLeftBound
	cmp	BYTE[ebx+msgStruc.col+1], '1' ;; Check if col = 1
	jg	notLeftBound
	;;If col data = 1, set col to 39
	mov	BYTE[ebx+msgStruc.col], '3'
	mov	BYTE[ebx+msgStruc.col+1], '9'
notLeftBound:
	popa
	ret

;; Function for sleeping for 1/2 second
_sleep:
	mov	eax, 162
	mov	ebx, pause
	mov	ecx, 0
	int 80h
	ret

;; Function for setting cursor position on screen
;; Expects row in ah and col in al, only works for 1- or 2-digit values
_setCursor:
        pusha
;; save original to process col later
        push    eax
;; process row
        shr     ax,8    ;; shift row to right
        mov     bl,10
        div     bl      ;; puts ax/10 in al, remainder in ah
        add     ah,'0'
        add     al,'0'
        mov     BYTE [row],al
        mov     BYTE [row+1],ah
;; process col
        pop     eax     ;; restore original parms
        and     ax,0FFh ;; erase row, leave col
        mov     bl,10
        div     bl      ;; puts ax/10 in al, remainder in ah
        add     ah,'0'
        add     al,'0'
        mov     BYTE [col],al
        mov     BYTE [col+1],ah
	;; Print cursor control code
	Print	pos, 8
	popa
	ret
