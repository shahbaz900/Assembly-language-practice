[ORG 0x100]
jmp start
swap1:
mov ax,[data+bx]
xchg ax,[data+bx+2]
mov [data+bx],ax
mov byte[swap],1
ret
start:
mov bx,0
mov byte[swap],0

beg:
mov ax,[data+bx]
cmp ax,[data+bx+2]
jg noswap

call swap1

noswap:
add bx,2
cmp bx,18
jne beg

cmp byte[swap],0
jne start

mov ax,0x4c00
int 0x21

data:dw -1,2,3
swap:db 0