[ORG 0x100]
jmp start
loop1:
push ax
push bx
push cx
push bp
mov bp,sp
sub sp,4
mov ax,[bp+4]
mov [bp-2],ax
mov ax,[bp+6]
mov [bp-4],ax
mov ax,[bp+8]
sub ax,3
mov cx,ax
code1:
mov ax,[bp-4]
mov bx,[bp-2]
mov [bp-4],bx
add [bp-2],ax
sub cx,1
cmp cx,0
jne code1
;loop code1
mov ax,[bp-2]
mov sp,bp
pop cx
pop bx
pop ax
pop bp
ret 6
start:
mov ax,2
push ax
mov ax,0
push ax
cmp ax,0
jz end
mov ax,1
push ax
cmp ax,1
jz end
call loop1
end:
mov ax,0x4c00
int 0x21