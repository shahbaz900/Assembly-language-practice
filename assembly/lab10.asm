[org 0x0100]
jmp start

clrscr:                     ;Clear subroutine
             
 push es
 push ax
 push di
 mov ax, 0xb800
 mov es, ax
 mov di, 0

 next:

 mov word [es:di], 0x2320  ;acess the screen and print spaces on all screen
 add di, 2
 cmp di, 4000              ;We set it to 4000 because our screen size is 4000
 jne next
 pop di
 pop ax
 pop es
 ret

print:

 push bp                   ;Push all our registers
 mov bp, sp
 push es
 push ax
 push di
 push cx
 push bx

 mov ax, 0xb800
 mov es, ax
 mov di, [bp+6]

 mov cx, [bp+4]
 mov bx, 0x3431            ;This is used to print our value on screen

 next2:

 mov word [es:di], bx
 add di, 2
 add bx, 1
 loop next2
 pop bx                    ;Pop all the registers
 pop cx
 pop di
 pop ax
 pop es
 pop bp
 ret 4

triangle:

 push bp
 mov bp, sp
 push ax
 push cx
 mov cx, 0
 mov ax, [bp+4]
 dec ax
 shl ax, 1                 ;Multiply the value by 2

 looop:

 add cx, 1
 push ax
 push cx
 call print
 add ax, 158               ;158 is our row size
 cmp cx, [bp+4]
 jne looop
 pop cx
 pop ax
 pop bp
 ret 2

start:                     ;Main

 call clrscr
 mov ax,6                  ;Our triangle size
 push ax
 call triangle             ;Call subroutine

 mov ax, 0x4c00
 int 0x21
