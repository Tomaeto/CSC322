; Adrian Faircloth
; 11/09/2020
; Project 9: Sort
; Sorts an array of unsigned byte values, prints both original and sorted arrays

;; Macro for printing
;; Pass pointer to start of string and length of string
%macro	Print 2
	pusha
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, %1
	mov	edx, %2
	int	80h
	popa
%endmacro

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ
nums: 		db      100, 200, 5, 10, 0, 88, 22 ; Array to be sorted
numslen:   	EQU     ($-nums)	  ; Length of array
printField:	db	"   "	 	  ; Stores converted value
clr             db 	1bh,'[2J'	  ; Clear screen string
hundred:	db	100		 
ten:		db	10
unsortHeader:	db	"Original Array:" ; Header for unsorted array
header1len:	EQU	($-unsortHeader)  ; Length of above header
sortHeader:	db	"Sorted Array:"   ; Header for sorted array
header2len:	EQU	($-sortHeader)	  ; Length of above header
SECTION .bss
; define uninitialized data here

SECTION .text
global _main, _convNum, _printArray, _sort
_main:
	Print	clr, 4 			 ;; Clear screen
	Print	unsortHeader, header1len ;; Printing header for unsorted array
	Print	ten, 1			 ;; Move cursor to next line
	call	_printArray		 ;; Printing unsorted array
	call	_sort			 ;; Sorting array
	Print	sortHeader, header2len	 ;; Printing header for sorted array
	Print	ten, 1			 ;; Move cursor to next line
	call	_printArray		 ;; Printing sorted array
lastBreak:

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h



;;;;;;;;;;;;;;;;;END OF MAIN;;;;;;;;;;;;;;;;;;
;; Function for converting literal byte values into characters
;; Returns value with 3 digits, leading zeros if applicable
;; Value to be converted expected in al register
_convNum:
	pusha
	xor	ah, ah
	mov	ebx, printField	;; Puts pointer to printField in ebx
	div	BYTE[hundred]	;; Divides al by 100 to get 1st digit
	add	al, '0'		;; Converts quotient to character
	mov	[ebx], al	;; Moves character to first spot of printField
	inc	ebx		;; Moves pointer in ebx to next space
	shr	ax, 8		;; Shifts ax so remainder is in al
	div	BYTE[ten]	;; Divides al by 10 to get 2nd digit
	add	al, '0'		;; Converts quotient to character
	mov	[ebx], al	;; Moves character to 2nd spot of printField
	add	ah, '0'		;; Converts remaining 3rd digit to character
	inc	ebx		;; Moves pointer in ebx to next space
	mov	[ebx], ah	;; Moves character to 3rd spot of printField
	popa
	ret

;; Function for printing array of byte values, one per line
_printArray:
	pusha
	mov	ebx, nums
	mov	ecx, numslen
printArrayLoop:		        ;; Printing each value in array
	mov	eax, [ebx]	;; Setting al for _convNum call
	call	_convNum
	Print	printField, 3   ;; Printing converted value
	inc	ebx	        ;; Setting pointer to move to next val in array
	Print	ten, 1	        ;; Moving cursor to next line
	loop printArrayLoop
	popa
	ret	

;; Function for sorting an array of byte values
_sort:
	pusha
	;; Filling ecx w/ number of needed runs of value comparisons
	;; Logically,  [n*(n-1)]/2, where n is size of array
	mov	ecx, numslen
	dec	ecx
	mov	eax, numslen
	mul	ecx
	mov	ecx, 2
	div	ecx
	mov	ecx, eax
sortLoop:	;; Loop that runs one set of comparions/exchanges of values
		;; in array per loop
	push	ecx		
	mov	ebx, nums	;; Storing pointer to array in ebx
	mov	ecx, numslen	;; Storing size of array in ecx
	dec	ecx		;; Dec ecx to not overshoot array in loop
	xor	eax, eax
	xor	edx, edx
sortVals:	;; Loop that compares each value to the next in the array
		;; and exchanges values if necessary
	mov	al, [ebx]	;; Putting 'current' value into al
	mov	dl, [ebx+1]	;; Putting 'next' value into dl
	;; Swapping al and dl if al>dl
	cmp	eax, edx
	jng	skipXchg
	xchg	al, dl
skipXchg:	
	mov	[ebx], al   ;;Placing smaller val into 'current' place in array
	mov	[ebx+1], dl ;;Placing larger val into 'next' place in array
	inc	ebx	    ;; Inc ebx to point to next value in array
	loop	sortVals
	pop	ecx
	loop	sortLoop    ;; Running as many sets of comparisons as needed
	
	popa
	ret
