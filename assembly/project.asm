[org 0x0100]
jmp start
count1: dw 0

  sym: db '='
  sym2: db '|'
  food_location: dw 1950
  intial_snake_length : dw 5
  snake: db 02,'*','*','*','*'

  snake_endlocatoin: dw 0
  count: dw 0
  count2: dw 0
  check:db 0
  
  over: db ' SNAKE DIED'
  overLength: dw 11
	
;code to clear the screen
clrscr:
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
random:
push ax
push bx
push cx
push dx
push bp
mov bp,sp
sub sp,4
mov word[bp-2],0
mov word[bp-4],0
ag:
   MOV AH, 00h  ; interrupts to get system time        
   INT 0x1A     ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 24   
   div  cx       
    ; here dx contains the remainder of the division - from 0 to 25
   mov word[bp-2],dx
   MOV AH, 00h  ; interrupts to get system time        
   INT 0x1A     ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 78   
   div  cx       
    ; here dx contains the remainder of the division - from 0 to 80
   mov word[bp-4],dx
   mov al, 80 ; load al with columns per row
mul byte [bp-2] ; multiply with y position
add ax, word[bp-4] ; add x position
shl ax, 1
mov dx,ax
	push ax
	push dx
	push cx
	mov ax,dx
	xor dx,dx
	mov cx,2
	div cx
   cmp dx,0
   je ret1
   jne again
ret1:
pop cx
pop dx
pop ax
mov [food_location],dx
mov sp,bp
pop bp
pop dx
pop cx
pop bx
pop ax
ret   
again:
pop cx
pop dx
pop ax  
jmp ag
display_food:
    push bp
    mov bp, sp
    push ax
    push di
    push es

    mov ax, 0xb800
    mov es, ax
    mov di, [bp + 4]        ;food location
    mov ax, 0x0309 ;9, 3
    mov [es:di], ax

    pop es
    pop di
    pop ax
    pop bp
    ret 2
endloc:
push ax
push bx
mov ax,[snake_locations]
mov bx,[intial_snake_length]
shl bx,1
sub bx,2
add ax,bx
mov [snake_endlocatoin],ax	
pop bx
pop ax
ret
print_space:
    push bp
    mov bp, sp
    push ax
    push es
    push di
    push cx 

    mov ax, 0xb800
    mov es, ax
    mov di, [bp+4]
    mov cx, 5

    mov word [es:di], 0x0720

    pop cx
    pop di
    pop es
    pop ax
    pop bp
    ret 2
delay:
    mov dword[count2],30000
n:
	dec dword[count2]
	cmp dword[count2],0
	jne  n
    ret	
draw_snake:
    push bp
    mov bp, sp
    push ax
    push bx
    push si
    push cx
    push dx

    mov si, [bp + 6]        ;snake
    mov cx, [bp + 8]        ;length of snake
  		;location
    mov ax, 0xb800
    mov es, ax

    mov bx, [bp+4]
	  mov di, [bx]	
    mov ah, 0x09
    snake_next_part:
        mov al, [si]02
        mov [es:di], ax
        mov [bx], di
        inc si
        add bx, 2

        add di, 2
        loop snake_next_part

    pop dx
    pop cx
    pop si
    pop bx
    pop ax
    pop bp
    ret 6
recover:
    push bp
    mov bp, sp
    push ax
    push es
    push di
    push cx 

    mov ax, 0xb800
    mov es, ax
    mov di, [bp+4]
    mov cx, 5
	mov si,sym2
	mov ah,0x04
	mov al,[si]
    mov word [es:di], ax

    pop cx
    pop di
    pop es
    pop ax
    pop bp
    ret 2
checkcollide:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push si
		mov  ax,[bp+4]
		xor  dx, dx
		mov  cx, 160   
		div  cx
		mov dx,ax
		mov al, 80 ; load al with columns per row
		mul dx ; multiply with y position
		add ax, 0 ; add x position
		shl ax, 1
		cmp ax,[bp+4]
		je l1
		mov byte[check],0
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 2
	l1:
		mov byte[check],1
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 2
		
end11:
push ax
mov word[snake_locations],308
mov ax,168
l21:
push ax
call print_space
sub ax,2
cmp ax,162
jnl l21
mov ax,160
push ax
call recover
pop ax
ret	
end12:
push ax
mov ax,[snake_locations]
sub ax,2
mov [snake_locations],ax
pop ax
ret
movsnake:
push ax
push bx
push cx
push dx
push si
call random
mov word[count],0
loop1:
mov word[count1],0
loop2:
push bx
push cx
push dx
 mov bx, snake_locations            ;snake location
    mov dx, [bx]

    mov cx, [intial_snake_length]
    sub dx, 2
    check_left_colision:
        cmp dx, [bx]
        jne again1
		pop dx
		pop cx
		pop bx
		call GameOver
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
		ret 
		again1:
        add bx, 2
        loop check_left_colision
pop dx
pop cx
pop bx
cmp word[count],3
jle nocheck
push word[snake_locations]
call checkcollide
cmp byte[check],1
je nloop1
nocheck:		
call endloc
cmp word[snake_locations],160
je ret111
jne ret112
ret111:
call end11
jmp n1
ret112:
call end12
jmp n1
n1:
push word[snake_endlocatoin]
call print_space
 push word [intial_snake_length]
    mov bx, snake
    push bx
    mov bx, snake_locations
    push bx
    call draw_snake
    push word [food_location]
    call display_food	
	
	call delay
	add word[count1],2
	cmp word[count1],150
   jne loop2
   push word[food_location]
   call print_space
  loop3: 
   call random
   cmp word[food_location],320
   jl loop3
   add word[count],1
   cmp word[count],5
   jle loop1
   
   jmp nloop1
  
   nloop1:
   call GameOver
   pop si
   pop dx
   pop cx
   pop bx
   pop ax
   ret 

border:
    push bp
    mov  bp, sp
    push es
    push ax
    push cx 
    push si 
    push di 

    mov ax, 0xb800 
    mov es, ax 
    mov di, 2              


    mov si, [bp + 4]
    mov cx, 78
    mov ah, 0x04 ; only need to do this once 
	
    print: 
        mov al, [si]
        mov [es:di], ax 
        add di, 2

        loop print 

    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 2

BottomBorder:
    push bp
    mov  bp, sp
    push es
    push ax
    push cx 
    push si 
    push di 

    mov ax, 0xb800 
    mov es, ax 
    mov di, 3840              


    mov si, [bp + 4]
    mov cx, 78
    mov ah, 0x04 ; only need to do this once 


    print3: 
        mov al, [si]
        mov [es:di], ax 
        add di, 2

        loop print3
;   // Displaying Score
    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 2


Hborder:
    push bp
    mov  bp, sp
    push es
    push ax
    push cx 
    push si 
    push di 

    mov ax, 0xb800 
    mov es, ax 
    mov di, 160              


    mov si, [bp + 4]
    mov cx, 23
    mov ah, 0x04 ; only need to do this once 
	

    print2: 
        mov al,[si]
        mov [es:di], ax 
        add di, 158
        mov [es:di], ax 
        add di, 2

        loop print2 


    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 2
	
	printName:
    push bp
    mov  bp, sp
    push es
    push ax
    push cx 
    push si 
    push di 

    mov ax, 0xb800 
    mov es, ax 
    
    mov di, [bp + 8]
    mov si, [bp + 6]
    mov cx, [bp + 4]
    mov ah, 0x02 ; only need to do this once 

    nextchar1: 
        mov al, [si]
        mov [es:di], ax 
        add di, 2 
        add si, 1 
        

        loop nextchar1


    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 6 
GameOver:
push cx
push dx
push ax
push bx
push si
push di

    call clrscr
    mov dx, 1994
    push dx
    mov dx, over 
    push dx 
    push word [overLength]
    call printName


pop di
pop si
pop bx
pop ax
pop dx
pop cx
mov ax, 0x4c00
int 0x21
ret    
start:
call clrscr
 mov ax, sym
    push ax
    call border
	mov ax, sym
    push ax
    call BottomBorder
	mov ax, sym2
    push ax
    call Hborder
 push word [intial_snake_length]
    mov bx, snake
    push bx
    mov bx, snake_locations
    push bx
    call draw_snake

	
	call delay
	call movsnake
mov ax,0x4c00
int 0x21
  snake_locations: dw 260
