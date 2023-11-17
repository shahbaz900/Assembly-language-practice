[ORG 0x100]
jmp start
length:dw 12 
string1:db'FUCK YOU!!!!'
clrscreen:
push es
push ax
push di
mov ax,0xb800
mov es,ax 
xor di,di
mov ax,0x0720
loop12:
mov word[es:di],ax
add di,2 
cmp di,4000
jnz loop12
pop di
pop ax
pop es
ret
print:
push bp
mov bp,sp
push es
push ax
push di
push cx
push si
mov ax,0xb800
mov es,ax
mov di,1500
mov si,[bp+6]
mov cx,[bp+4]
mov ah,0x21
loop1:
mov al,[si]
mov word[es:di],ax
add di,2
inc si
loop loop1
pop si
pop cx
pop di
pop ax
pop es
pop bp
ret
start:
call clrscreen
mov ax,string1
push ax
push word[length]
call print
;mov ah,0x1
;int 0x21
;call print
mov ax,0x4c00
int 0x21
