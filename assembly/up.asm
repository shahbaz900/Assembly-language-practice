; scroll up the screen
[org 0x0100]
jmp start
; subroutine to scroll up the screen
; take the number of lines to scroll as parameter
scrollup: push bp
mov bp,sp
push ax
push cx
push si
push di
push es
push ds
mov ax, 80 ;loading the number of columns in first row
mul byte [bp+4] ;calculate the number of rows to be scrolled
mov si, ax ; load source position in si
push si ; save position for later use
shl si, 1 ; convert to byte offset
mov cx, 2000 ; total number of screen locations in byte
sub cx, ax ; count of words to move
mov ax, 0xb800
mov es, ax ; point es to video base
mov ds, ax ; point ds to video base
xor di, di ; point di to top left column
cld ; set auto increment mode
rep movsw ; scroll up
mov ax, 0x0720 ; space in normal attribute
pop cx ; count of positions to clear
rep stosw ; clear the scrolled space
pop ds
pop es
pop di
pop si
pop cx
pop ax
pop bp
ret 2
start: mov ax,5
push ax ; push number of lines to scroll
call scrollup ; call the scroll up subroutine
mov ax, 0x4c00 ; terminate program
int 0x21