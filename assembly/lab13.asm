[ORG 0x100]
jmp start
stringw:db 'w present'
lengthw:db 10
stringa:db 'a present'
lengtha:db 10
strings:db 's present'
lengths:db 10
stringd:db 'd present'
lengthd:db  10
clrscreen:
push es
push ax
push cx
push di
mov ax, 0xb800
mov es, ax
xor di,di
mov cx,2000
mov ax,0x0720
cld 
rep stosw
pop di
pop cx
pop ax
pop es
ret
checkalpha:
push ax
push es
push bx
push cx
push dx
call clrscreen
mov ah,0
int 0x16
;in al, 0x60;-->command for reading the key pressed
cmp al,0x77
mov dh , 0x07
mov dl,al
je print
cmp al,0x73
je print
cmp al,0x61
je print
cmp al,0x64
je print
jne end
print:
mov ax, 0xb800
mov es, ax
mov byte[es:2040],dl
jmp end
end:
pop dx
pop cx
pop bx
pop es
pop ax
ret
start:

call checkalpha
mov ax,0x4c00
int 0x21
