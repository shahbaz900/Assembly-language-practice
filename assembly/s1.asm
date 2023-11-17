;Printing a snake at random position and start moving

[org 0x0100]
jmp start
count: dd 0

;code to clear the screen
clearscreen:
    push es
    push ax
    push di
    push cx
    mov ax,0xb800 ; video memory address
    mov es,ax
    mov ax,0x0720 ; color code and space ASCII
    mov di,0
    nextchar:
        mov [es:di],ax
        add di,2
        cmp di,4000
        jne nextchar

    ;popping all values
    pop cx
    pop di
    pop ax
    pop es
    ret

printsnake:
    ;pushing all values
    push bp
    mov bp ,sp
    push di
    push es
    push ax
    push bx
    push dx

    ;calculating positon
    mov cx,[bp+2]
    mov ax,80
    mul cx
    add ax,[bp+4]
    shl ax,1
   
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov ax,0x0702
    mov dx,0

    moving: ;for next move
    mov ax,0x472A
    mov cx,10
    call clearscreen ;previous output clearing
    nextloc:
    mov word [es:di],ax
    add di,2
    dec cx
	cmp cx,2
	jne face ; to make snake face
	mov al,0x01
	face:
    cmp cx,0
    jne nextloc

;a large loop for delaying next move
	mov dword[count],400000
n:
	dec dword[count]
	cmp dword[count],0
	jne  n
	inc dx
	cmp dx,30 ; total no of moves
	jne moving

    pop dx
    pop bx
    pop ax
    pop es
    pop di
    pop bp
    ret
   
start:
call clearscreen
; location of snake at start
push 4 ; row
push 4 ;col
call printsnake
mov ax,0x4c00
int 0x21

