[ORG 0x100]
jmp start
stringa:db'FUCK YOU MOTHERFUCKER',0
count:dw 0
;-->CLEAR SCREEN-------->
clrscreen:
push es
push di
push cx
push ax
mov ax,0xb800
mov es,ax
mov cx,4000
mov ax,0x0720
xor di,di
cld
rep stosw
pop ax
pop cx
pop di
pop es
ret
strlength:
push bp
mov bp,sp
push es 
push di
push cx
mov cx,0xffff
les di,[bp+4]
xor al,al
repne scasb
mov ax,0xffff
sub ax,cx
dec ax
pop cx
pop di
pop es
pop bp
ret
;-->PRINTSTR----->
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
mov di,560
mov ah,0x09 
mov si,[bp+4]
loop1:
inc ah
lodsb
stosw
loop loop1
pop si
pop cx
pop di
pop es 
pop bp
ret
;-->SCROLL DOWN----->
scrolldown:
push bp
mov bp,sp
push ax
push bx
push cx
push es
push ds
push di
push si
mov ax,80
mul byte[bp+4]
mov si,ax
push si
shl si,1
mov si,3998
sub si,ax
mov cx,2000
sub cx,ax
mov ax,0xb800
mov es,ax
mov ds,ax
mov di,3998
std
rep movsw
mov ax,0x0302
pop cx
rep stosw
pop si
pop di
pop ds
pop es
popcx
pop bx
pop ax
pop bp
ret 2
;-->DELAY------>
delay:
mov dword[count],5000000
l1:
dec dword[count]
cmp dword[count],0
jne l1
ret
;--->START------>
start:
call clrscreen
push ds
mov ax,stringa
push ax
call strlength
call printstr
mov cx,15
loop12:
call delay
mov ax,5
push ax
call scrolldown
loop loop12
mov ax,0x4c00
int 0x21
