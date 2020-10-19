; Adrian Faircloth
; 10/18/2020
; Program 6: Max Fibonacci
; Creates a DWORD and adds in fibonacci vals to max possible DWord value

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ
prevFib:	dd	1	;Value for storing previous value in sequence

SECTION .bss
MaxFib:	RESD	1	;Reserving DWORD for max fibonacci value

SECTION .text
global _main
_main:
	
	add DWORD[MaxFib], 1	;putting first fibonacci value into MaxFib to start sequence

WhileNotMax:

	mov eax, [MaxFib]	;moving current fib value into reg for adding
	mov ebx, [prevFib]	;moving previous fib value into reg for adding
	mov [prevFib], eax	;moving current fib value into prevFib for next loop
	add eax, ebx		;adding current and previous fib values
	mov [MaxFib], eax	;moving sum of fib values into memory for next loop
	jnc WhileNotMax		;loops previous code until fib value exceeds 32 bits
	mov eax, [prevFib]	;moves max unsigned 32-bit fib value into register
	mov [MaxFib], eax	;moves max unsigned 32-bit fib value into MaxFib variable

lastBreak:
; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
            
