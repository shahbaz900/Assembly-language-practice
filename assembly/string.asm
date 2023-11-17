; comparing null terminated strings
[org 0x0100]
jmp start
msg1: db 'Coal Lab', 0
msg2: db 'Coal Lab', 0
msg3: db 'PF Lab', 0
; takes segment and offset pairs of two strings to compare
; returns 1 in ax if they match and 0 other wise
;to compare two strings
; subroutine to calculate the length of a string
; takes the segment and offset of a string as parameters
strlen: push bp
mov bp,sp
push es
push cx
push di
les di, [bp+4] ; point es:di to string
mov cx, 0xffff ; load maximum number in cx
xor al, al ; load a zero in al
repne scasb ; find zero in the string
mov ax, 0xffff ; load maximum number in ax
sub ax, cx ; find change in cx
dec ax ; exclude null from length
pop di
pop cx
pop es
pop bp
ret 4
strcmp:
push bp
mov bp,sp
push cx
push si
push di
push es
push ds
lds si, [bp+4] ; point ds:si to first string
les di, [bp+8] ; point es:di to second string
push ds ; push segment of first string
push si ; push offset of first string
call strlen ; calculate string length
mov cx, ax ; save length in cx
push es ; push segment of second string
push di ; push offset of second string
call strlen ; calculate string lenth
cmp cx, ax ; compare length of both strings
jne exitfalse ; return 0 if they are unequal
mov ax, 1 ; store 1 in ax to be returned
repe cmpsb ; compare both strings
jcxz exitsimple ; are they successfully compared
exitfalse: mov ax, 0 ; store 0 to mark unequal
exitsimple: pop ds
pop es
pop di
pop si
pop cx
pop bp
ret 8
start: push ds ; push segment of first string
mov ax, msg1
push ax ; push offset of first string
push ds ; push segment of second string
mov ax, msg2
push ax ; push offset of second string
call strcmp ; call strcmp subroutine
push ds ; push segment of first string
mov ax, msg1
push ax ; push offset of first string
push ds ; push segment of third string
mov ax, msg3
push ax ; push offset of third string
call strcmp ; call strcmp subroutine
mov ax, 0x4c00 ; terminate program
int 0x21