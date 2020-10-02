; Adrian Faircloth
; CSC 322 Fall 2020
; 09/30/2020
; Program 4: Fibonacci Sequence
; Reserves an array and fills it with numbers of the Fibonacci sequence

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ

SECTION .bss
Fibs:	RESD 16

SECTION .text
global _main
_main:
	mov eax, 0 ; moving Fibonacci values into eax register and then into Fibs array
	mov [Fibs] , eax
	mov eax, 1
	mov [Fibs+4], eax	
	add eax, [Fibs] ; adding first and second values of Fibs
	mov [Fibs+8], eax ; moving sum of previous two fib values into Fibs array
	add eax, [Fibs+4] ; repeating for 16 fibonacci values
	mov [Fibs+12], eax
	add eax, [Fibs+8]
	mov [Fibs+16], eax
	add eax, [Fibs+12]
	mov [Fibs+20], eax
	add eax, [Fibs+16]
	mov [Fibs+24], eax
	add eax, [Fibs+20]
	mov [Fibs+28], eax
	add eax, [Fibs+24]
	mov [Fibs+32], eax
	add eax, [Fibs+28]
	mov [Fibs+36], eax
	add eax, [Fibs+32]
	mov [Fibs+40], eax
	add eax, [Fibs+36]
	mov [Fibs+44], eax
	add eax, [Fibs+40]
	mov [Fibs+48], eax
	add eax, [Fibs+44]
	mov [Fibs+52], eax
	add eax, [Fibs+48]
	mov [Fibs+56], eax
	add eax, [Fibs+52]
	mov [Fibs+60], eax	

done: ; break after completing array
; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
            
