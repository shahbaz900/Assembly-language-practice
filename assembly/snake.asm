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

randomNumber:
	push ax;
	push dx;
	
	mov ah, 00h  ; interrupts to get system time        
	int 1AH      ; CX:DX now hold number of clock ticks since midnight      

	mov  ax, dx
	xor  dx, dx
	mov  cx, [bp-2]  ;upper number
	div  cx       ; here dx contains the remainder of the division - from 0 to 9

	add  dx, 0  ; to ascii from '0' to '9'
	mov bx,dx;
   
	pop dx;
	pop ax;
	ret;

delay: ;a large loop for delaying next move
	mov dword[count],400000
delayLoop:
	dec dword[count];
	cmp dword[count],0;
	jne delayLoop;
	ret;

printSnakePos:
	push es;
	push ax;
	push cx;
	mov ax,0x472A;
nextloc:
	mov word [es:di],ax
      call death
	add di,2
	dec cx
	cmp cx,2

	jne face ; to make snake face
	mov al,0x01
face:
	cmp cx,0
	jne nextloc;
	
	pop cx;
	pop ax;
	pop es;
	ret;

printFood:
	push ax;
	push bx;
	push di;
	push es;
	
	mov bx,80; x pos
	mov [bp-2],bx;
	call randomNumber;
	mov [bp-4],bx;
	
	
	mov bx,25;
	mov [bp-2],bx;
	call randomNumber;
	mov [bp-2],bx ;y pos
	
	call calculatePosition;
	mov ax,0x4701;
	mov word [es:di],ax;
	
	pop es
	pop di
	pop bx
	pop ax
	ret 

calculatePosition:
	push cx
	push dx
	mov cx,[bp-2] ;y pos 
    mov ax,80
    mul cx
    add ax,[bp-4] ;x pos 
    shl ax,1

	mov di,ax
    mov ax,0xb800
    mov es,ax
	
	pop dx;
	pop cx;
	ret;
death:
push bp
mov sp,bp
push ax
push bx
push cx
loop1:
mov ax,di
mov bx,160
div bx
cmp dx,0
je end
pop cx
pop bx
pop ax
pop bp
ret
end:
pop cx
pop bx
pop ax
pop bp 
mov ax,0x4c00
int 0x21
printsnake:
    ;pushing all values
    push bp
    mov bp ,sp
	sub sp,4;
    push di
    push es
    push ax
    push bx
    push dx

    ;calculating positon
	mov ax,[bp+4]; y pos
	mov [bp-2],ax;
	
	mov ax,[bp+6]; x pos
	mov [bp-4],ax;
	
	call calculatePosition
   
    mov ax,0x0702
    mov dx,0

	
	
    moving: ;for next move
    
    mov cx,10; snake length
	
    call clearscreen ;previous output clearing
	
	call printSnakePos;

	call delay;
	
	call printFood;
	
	call delay
	
	inc dx;
	cmp dx,30 ; total no of moves
	jne moving;
	
	;call printFood;
    pop dx
    pop bx
    pop ax
    pop es
    pop di
	mov sp, bp
    pop bp
    ret 4
   
start:
call clearscreen
; location of snake at start
push 4 ; row
push 4 ;col
call printsnake
mov ax,0x4c00
int 0x21

