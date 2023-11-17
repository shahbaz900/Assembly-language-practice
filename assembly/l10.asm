[ORG 0x100]
jmp start
stra:db 'FUCK YOU'0
strlen:
push bp
mov bp,sp
push cx
push es
push di
les di,[bp+4]
mov cx,0xffff
repne scasb
mov ax,0xffff
sub ax,cx
dec ax
pop di
pop es
pop cx
pop bp
ret 
printstr:
push bp
mov bp,sp
push es
push di
push cx
push si
mov cx,ax
mov ax,0xb800
mov es,ax
mov di,260
mov si,[bp+4]
cld
l1:
lodsb
stosw
loop l1
pop cx
pop di
pop es
pop bp
start:
mov ax,stra
push ax
call strlen
call printstr
mov ax,0x4c00
int 0x21