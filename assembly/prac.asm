[ORG 0x100]
jmp start
clrscreen:
push bp
mov bp,sp
push ax
push es
push bx
push di
mov ax,0xb800
mov es,ax
mov ax,0x0720
mov di,0
mov cx,2000
looop:
mov word[es:di],ax
add di,2
loop looop
pop di
pop bx
pop es
pop ax
pop bp
ret
printsnake:
push bp
mov bp,sp
push ax
push es
push bx
push di
mov ax,0xb800
mov es,ax
mov al,80
mul byte[bp+6]
add ax,[bp+4]
shl ax,1
mov di,ax
mov ax,0x072A
mov cx,[bp+8]
looop:
mov word[es:di],ax
add di,160
loop looop
pop di
pop bx
pop es
pop ax
pop bp
ret 6
printtriangle:
push bp
mov bp,sp
push ax
push es
push bx
push di
mov ax,0xb800
mov es,ax
mov al,80
mul byte[bp+6]
add ax,[bp+4]
shl ax,1
mov di,ax
mov ax,0x072A
mov cx,[bp+8]
looop:
mov word[es:di],ax
add di,160
loop looop
pop di
pop bx
pop es
pop ax
pop bp
ret
start:
call clrscreen
mov ax,10;length
push ax
mov ax,10;y length
push ax
mov ax,11;x length
push ax
call printsnake
;call printtriangle
mov ax,0x4c00
int 0x21