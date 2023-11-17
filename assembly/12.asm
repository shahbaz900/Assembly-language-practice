[ORG 0x100]
jmp start
clrscreen:
push es
push ax
push di
mov ax,0xb800
mov es,ax
mov di,0
nextlocation:
mov word[es:di],0x0720
add di,2
cmp di,4000
jne nextlocation
pop di
pop ax
pop es
ret
printnum:
push bp
mov bp,sp
push ax
push cx
push dx
push si
mov dx,0
mov cx,[bp+4]
mov ax,0xb800
mov es,ax
mov si,[bp+4]
looporig:
mov al, 80 ; load al with columns per row
mul byte[bp+4] ; multiply with y position
add ax, dx ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location
mov ah,0x12
inc dx
loop1:
mov al,0x20
mov [es:di],ax
sub di,2
jne loop1
mov al,0x31
dec cx,1
cmp cx,0
jne looporig
ret 2
start:
call clrscreen
mov ax,5
push ax
call printnum