;Program 2: Adding
;Adds values stored in AX and BX registers
;Adrian Faircloth
;09/15/2020

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ

SECTION .bss
; define uninitialized data here

SECTION .text
global _main
_main:
;task 1
mov ax, 0CDBAh
mov bx, 0CDABh
add ax, bx
;task 2
mov ax, 0ABCDh
mov bx, 0ABCDh
add ax, bx
;task 3
mov ax, 0FAFAh
mov bx, 0505h
add ax, bx
;task 4
mov ax, 0F0F0h
mov bx, 0FF00h
add ax, bx
;task 5
mov ax, 0D468h
mov bx, 02B98h
add ax, bx
;task 6
mov ax, 700Fh
mov bx, 02B98h
add ax, bx 
;task 7
mov ax, 1234h
mov bx, 7654h
add ax, bx
;task 8
mov ax, 0B0Bh
mov bx, 0A11Eh
;task 9
mov ax, 7654h
mov bx, 789Ah
add ax, bx
;task 10
mov ax, 8000h
mov bx, 8000h
add ax, bx

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
         
