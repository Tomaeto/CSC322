; Adrian Faircloth
; Program 1: Data Storage
; 09/11/2020


SECTION .data


a1:      db      11
b1:      dw      11b
c1:      dd      11h
d1:      dq      11q
e1:      dw      -5
f1:      db      'CSC322'

a2:	 db	 5, 4, 3, 2, 1
b2:	 dw	 1, 2, 3, 4, 5
c2:	 dd	 10, 11, 12, 13
d2:	 dq	 10h, 11h, 12h, 13h

a3:	 db	 -5
b3:	 dw	 -10
c3:	 db	 -15
d3:	 dw	 -20
e3:	 db	 -25

a4:	 db	 'Mercer'
b4:	 db	 10
c4:	 db	 0
d4:	 db	 'Go '
e4:	 db	 'Bears!'

a5:	 dw	 100
b5:	 dd	 100h
c5:	 db	 100b
d5:	 dw	 100q
e5:	 dd	 100d

SECTION .bss
; define uninitialized data here

SECTION .text
global _main
_main:

; put your code here.



; Normal termination code
mov eax, 1
mov ebx, 0
int 80h

