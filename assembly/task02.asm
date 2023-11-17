[ORG 0x100]
jmp start
message1:db 'hello            '
message2:db 'Motherfucker'
length1:dw 5
length2:dw 12
length3:dw 0
clrscreen:
push es
push ax
push di
mov ax,0xb800
mov es,ax
mov di,0
mov ax,0x0420
loop1:
mov word[es:di],ax
add di,2
cmp di,4000
jne loop1
pop di
pop ax
pop es
ret
concatenate:
push es
push ax
push di
push si
push cx
mov ax,0xb800
mov es,ax
mov si,[message1]
mov di,0
mov ah,0x07
mov cx,0
loop12:
mov al,[si]
mov word[es:di],ax
add si,1
add di,2
add cx,1
cmp cx,[bp+4]
jne loop12
pop cx
pop si
pop di
pop ax
pop es
ret
sum:
push bp
mov bp,sp
push ax
mov ax,[bp+4]
add ax,[bp+8]
mov word[length3],ax
pop ax
pop bp
ret
start:
call clrscreen
mov bx,[length1]
add bx,[length2]
mov cx,0
mov si,[message1]
loopxy:
inc si
inc cx
cmp si,[length1]
jne loopxy
mov si,[message2]
loopy:
;mov ax,[si]
mov word[message1+cx],0x0720
inc si
inc cx
cmp si,bx
jne loopy
push bx
call concatenate

mov ax,0x4c00
int 0x21
