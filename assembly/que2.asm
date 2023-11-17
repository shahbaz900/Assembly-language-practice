[org 0x0100]
jmp start
data: dw 60,55,45,50,40,35,25,30,10,0
data2: dw 328,329,898,8923,8293,2345,10,877,355, 98,888,533,2000,1020,30,200,761,167,90,5
swapflag: db 0
bubblesort: 
push bp 
mov bp, sp 
push ax 
push bx 
push cx 
push si 
mov bx, [bp+6] 
mov cx, [bp+4] 
dec cx 
shl cx, 1 
mainloop: 
mov si, 0 
mov byte [swapflag], 0 
innerloop:
mov ax, [bx+si] 
cmp ax, [bx+si+2] 
jbe noswap
xchg ax, [bx+si+2]
mov [bx+si], ax  
mov byte [swapflag], 1 
noswap:
add si, 2
cmp si, cx 
jne innerloop 
cmp byte [swapflag], 1 
je mainloop 
pop si 
pop cx 
pop bx 
pop ax 
pop bp 
ret 4 

start:
mov ax, data
push ax ; place start of array on stack
mov ax, 10
push ax ; place element count on stack
call bubblesort ; call our subroutine
mov ax, data2
push ax ; place start of array on stack
mov ax, 20
push ax ; place element count on stack
call bubblesort ; call our subroutine again
mov ax, 0x4c00 ; terminate program
int 0x21
