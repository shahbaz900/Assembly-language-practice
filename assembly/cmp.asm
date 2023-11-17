[ORG 0x100]
jmp start
Stra:db'Coal Lab',0
Strb:db'Coal Lab',0
Strc:db'PF Lab',0
strlength:
push bp
mov bp,sp
push cx
push es
push di
les di,[bp+4]
mov cx,0xffff
mov ax,0
repne scasb
mov ax,0xffff
sub ax,cx
dec ax
pop di
pop es
pop cx
pop bp
ret 4
strcmp:
push bp
mov bp,sp
push si
push di
push es
push ds
push cx
lds si,[bp+8]
les di,[bp+4]
push ds
push si
call strlength
mov cx,ax
push es
push di
call strlength
cmp cx,ax
jne exit1
exit:
mov ax,0
repe cmpsb
jcxz exit2
exit1:
mov ax,1
exit2:
pop cx
pop ds
pop es
pop di
pop si
pop bp
ret 8
clrscreen:
push bp
mov bp,sp
push es
push di
push ax
mov ax,0xb800
mov es,ax
mov ax,0x0720
mov di,0
mov cx,4000
loop1:
mov [es:di],ax
add di,2
loop loop1
pop ax
pop di
pop es
pop bp
ret 
print1:
call clrscreen
push bp
mov bp,sp
push es
push di
push ax
mov ax,0xb800
mov es,ax
mov ah,0x07
mov al,[bp+4]
mov di,260
mov [es:di],ax
pop ax
pop di
pop es
pop bp
ret 2
start:
push ds
mov ax,Stra
push ax
mov ax,Strc
push ds
push ax
call strcmp
push ax
call print1
mov ax,0x100
int 0x21