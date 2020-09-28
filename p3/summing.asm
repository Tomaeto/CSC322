; Adrian Faircloth
; CSC 322 Fall 2020
; Program 3: Summing Arrays
; Sums three different arrays of signed integers and totals all three sums
; 09/27/2020

SECTION .data
bArray:        DB     	 -1,2,-3,4,-5,6
wArray:        DW        09h,0ah,0bh,0ch,0dh
dArray:        DD        -10,-20,-30,-40,-50
bArraySum:     DB        0
wArraySum:     DW        0
dArraySum:     DD        0
grandTotal:    DD        0


SECTION .bss
; define uninitialized data here

SECTION .text
global _main
_main:

break0: ; break label before code

	mov     al, [bArray] ; moving the first bArray value to the al register
	add     al, [bArray+1] ; adding each byte within bArray to al
	add     al, [bArray+2]
	add	al, [bArray+3]
	add	al, [bArray+4]
	add	al, [bArray+5]
	mov	[bArraySum], al ; moving the sum from al to bArraySum variable

break1: ; break after summing first array

	xor	ax, ax ; zeroing ax register
	mov	ax, [wArray] ; moving first wArray value to the ax register
	add	ax, [wArray+2] ; adding each word within wArray to ax
	add	ax, [wArray+4]
	add	ax, [wArray+6]
	add	ax, [wArray+8]
	mov	[wArraySum], ax ; moving the sum from ax to wArraySum

break2: ; break after summing second array

	xor	ax, ax ; zeroing ax register
	mov	eax, [dArray] ; moving first dArray value to the eax register
	add	eax, [dArray+4] ; adding each double-word within dArray to eax
	add	eax, [dArray+8]
	add	eax, [dArray+12]
	add	eax, [dArray+16]
	mov	[dArraySum], eax ; moving sum from eax to dArraySum	

break3: ; break after summing third array

	xor eax, eax ; zeroing eax register
	mov eax, [dArraySum] ; moving dArraySum value into eax register
	add al, [bArraySum] ; adding dArraySum and bArraySum
	add ax, [wArraySum] ; adding wArraySum to other sums
	mov [grandTotal], eax ; moving total sum to grandTotal

lastBreak: ; break label just before termination

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
            
