[ORG 0x100]
jmp start
stra:db'FUCK YOU'
length:dw 8
clrscreen:
push ax
push di
push es
mov ax,0xb800
mov es,ax
mov di,0
looop:
mov word[es:di],0x1420
add di,2
cmp di,4000
jne looop
pop es
pop di
pop ax
ret
strprint:
;call clrscreen
printstr: push bp
mov bp, sp
push es
push ax
push cx
push si
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 560 ; point di to top left column
mov si, [bp+4] ; point si to string
mov cx, [bp+6] ; load length of string in cx
mov ah, 0x07 ; normal attribute fixed in al
nextchar: 
mov al, [si] ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
add si, 1 ; move to next char in string
loop nextchar ; repeat the operation cx times
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 4
start:
call clrscreen
push word[length]
mov ax,stra
push ax
call strprint
mov ax,0x4c00
int 0x21