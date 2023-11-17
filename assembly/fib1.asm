[ORG 0x100]

jmp start

data:dw 0,1,1,2,3,5
sum:dw 0

fibonacci:
push cx
push bx
push si
dec cx
shl cx,1
mov si,0
mainwork:
add ax,[bx+si]
mov dx,ax
add si,2
sub cx,2
cmp cx,0
jnz mainwork
pop si
pop bx
pop si
ret
start:
mov bx,data
mov cx,7
call fibonacci
mov ax,0x4c00
int 0x21

