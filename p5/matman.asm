; Adrian Faircloth
; 10/8/2020
; Program 5: Matrix Management
; Creates a matrix of data, sums the rows and columns, and calcs a total sum

;;;;;;;;;;;;;;;;;;;;;;;; TEST CASE 1 ;;;;;;;;;;;;;;;;;;;;;;;;;
ROWS:        EQU    5   ; defines a constant ROWS set to 5.
COLS:      EQU    7    ; defines a constant COLS set to 7.
loopPointer:	EQU	0
sumPointer:	EQU	0
SECTION .data
MyMatrix:     dd     1,  2,  3,  4,  5,  6,  7
              dd     8,  9, 10, 11, 12, 13, 14
              dd    15, 16, 17, 18, 19, 20, 21
              dd    22, 23, 24, 25, 26, 27, 28
              dd    29, 30, 31, 32, 33, 34, 35
ecxHolder:	dd	0	; variable for holding ecx register value
colCounter:	dd	0	; variable for tracking number of columns summed
SECTION .bss
RowSums:    RESD ROWS
ColSums:    RESD COLS
Sum:        RESD 1

SECTION .text
global _main
_main:
	
	xor eax, eax
	mov  ecx, ROWS
rowLoop1:

	xor ebx, ebx
	mov [ecxHolder], ecx
	mov ecx, COLS
rowLoop2:

	add ebx, [MyMatrix+edx]
	add edx, 4
loop rowLoop2
	
	add [Sum], ebx
	mov [RowSums+eax], ebx
	add eax, 4
	mov ecx, [ecxHolder]

loop rowLoop1

	xor eax, eax
	xor edx, edx
	mov ecx, COLS

colLoop1:
	
	xor ebx, ebx
	mov [ecxHolder], ecx
	mov ecx, ROWS
	mov edx, [colCounter]

colLoop2:

	add ebx, [MyMatrix+edx]
	add edx, COLS*4
	

loop colLoop2
	

	mov [ColSums+eax], ebx
	add eax, 4
	add [colCounter],DWORD 4
	mov ecx, [ecxHolder]

loop colLoop1

lastBreak:
; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
            
