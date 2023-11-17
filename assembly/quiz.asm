; comparing null terminated strings
[org 0x0100]
jmp start
source: db 'You show pay attention when your classmates are presenting now you will learn it the hard way', 0
dest: db 'aeiou', 0
; takes segment and offset pairs of two strings to compare
; returns 1 in ax if they match and 0 other wise
;to compare two strings
; subroutine to calculate the length of arr string
; takes the segment and offset of arr string as parameters
strlen: 
push bp
mov bp,sp
push es
push cx
push di
les di, [bp+4] ; point es:di to string
mov cx, 0xffff ; load maximum number in cx
xor al, al ; load arr zero in al
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
 lds si, [bp+8] ; point ds:si to first string 045 ;source string
 les di, [bp+4] ; point es:di to second string 046 ; destination string
push es ; push segment of second string 053 
push di ; push offset of second string 054 
call strlen ; calculate string lenth 055

mov cx, ax ; save length in cx 
push ds ; push segment of first string 048 
push si ; push offset of first string 049 
call strlen ; calculate string length 050 

cmp ax, cx ; compare length of both strings 056 
jbe false ; return 0 if they are unequal 057 not possible
mov bx,ax;length of source string stored
mov ax, 1 ; store 1 in ax to be returned 059 
mov dx,[bp+8]
add dx,bx
push si
push di
push cx
loop1:
repe cmpsb ; compare both strings
jcxz exitsimple ; are they successfully compared and substring found
pop cx
pop di
pop si
add si,1
push si
push di
push cx
cmp si,dx ;cmp that whole source string is checked or not
jne loop1 
false:
mov ax, 0 ; store 0 to mark unequal 063 
exitsimple: 
inc byte[count]
jmp loop1


pop cx
pop di
pop si
pop ds 
pop es 
pop di 
pop si 
pop cx 
pop bp 
ret 8

start: 

push ds ; push segment of first string
mov ax, source
push ax ; push offset of first string
push ds ; push segment of second string
mov ax, dest
push ax ; push offset of second string
call strcmp ; call strcmp subroutine

mov ax, 0x4c00 ; terminate program
int 0x21