[org 0x0100]

jmp start
;====================StartMenu=====================
str1: db 'classic mode',0
str2: db 'Time Survivial Mode',0
str3: db '1 live Mode',0
str4: db 'Exit',0
lastpos: dw 0
opt1pos: dw 0
opt2pos: dw 0
opt3pos: dw 0
opt4pos: dw 0
option:  dw 1
minutesplayed: dw 0


;[bp + 8] = previous string di
;[bp + 6] = previous string
;[bp + 4] = current string
downentered:
            push bp
            mov bp , sp
            pusha

            push word 2
            mov ax, [bp + 8]
            add ax, 320
            push ax
            push word [bp + 4]

            mov ax , 5          ; attribute
            push ax
            mov ax , [bp + 8]   ; di value 
            push ax
            mov ax , [bp + 6]   ; string to print 
            push ax
            call printstring

            ;mov ax , 2
            ;push ax
            ;mov ax , [bp + 8]
            ;add ax , 320*2
            ;push ax
            ;mov ax , [bp + 4]
            ;push ax
            call printstring

            popa
            pop bp
            ret 6


;[bp + 8] = previous string di
;[bp + 6] = previous string
;[bp + 4] = current string

upentered:
            push bp
            mov bp , sp
            pusha

            mov ax , 2
            push ax
            mov ax , [bp + 8]
            sub  ax , 320
            push ax
            mov ax , [bp + 4]
            push ax
            mov ax , 5
            push ax
            mov ax , [bp + 8]
            push ax
            mov ax , [bp + 6]
            push ax
            call printstring

            
            call printstring

            popa
            pop bp
            ret 6





printstring:
                push bp
                mov bp , sp
                pusha

                push ds
                pop es

                mov di , [bp + 4] 
                mov cx , 0xffff
                mov al , 0
                repne scasb
                mov ax , 0xffff
                sub ax , cx
                dec ax

                mov cx , ax
                cmp cx , 0
                je exit

                mov ax , 0xb800
                mov es , ax

                mov di , [bp + 6]
                mov si , [bp + 4]
                mov ah , [bp + 8]
                cld
l11:             lodsb
                stosw
                loop l11

exit:           pop bp
                popa
                ret 6


setoptspos:
                pusha
                mov ax, 80
                mov bx , 8
                mul bx
                add ax , 34
                shl ax , 1

                mov word[opt1pos] , ax
                add ax , 320
                mov word[opt2pos], ax
                add ax ,320
                mov word[opt3pos], ax
                add ax , 320
                mov word[opt4pos] , ax
                popa
                ret

printoptions:
                pusha
                mov ax , 5
                push ax
                mov ax , [opt1pos]
                push ax
                mov ax , str1
                push ax
                call printstring

                
                mov ax , 5
                push ax
                mov ax , [opt2pos]
                push ax
                mov ax , str2
                push ax
                call printstring

                mov ax , 5
                push ax
                mov ax , [opt3pos]
                push ax
                mov ax , str3
                push ax
                call printstring

                mov ax , 5
                push ax
                mov ax , [opt4pos]
                push ax
                mov ax , str4
                push ax
                call printstring

                popa
                ret

movedown:        
                pusha
                mov ax , [option]
                add ax , 1
                cmp ax , 5
                je enddown
                add word[option] , 1

                cmp word[option] , 2
                je pdl2
                cmp word[option] , 3
                je pdl3
                cmp word[option] , 4
                je pdl4
                jmp enddown

pdl2:           mov ax , [opt1pos]
                push ax
                mov ax , str1
                push ax
                mov ax , str2
                push ax
                call downentered
                jmp enddown
               

pdl3:           mov ax , [opt2pos]
                push ax
                mov ax , str2
                push ax
                mov ax , str3
                push ax
                call downentered
                jmp enddown  

pdl4:           mov ax , [opt3pos]
                push ax
                mov ax , str3
                push ax
                mov ax , str4
                push ax
                call downentered
                jmp enddown
                
enddown:        popa
                ret
        
moveup:         pusha
                mov ax , [option]
                sub ax , 1
                cmp ax , 0
                je endup
                sub word[option] , 1
                cmp word[option] , 1
                je pul1
                cmp word[option] , 2
                je pul2
                cmp word[option] , 3
                je pul3

pul1:           mov ax , [opt2pos]
                push ax
                mov ax , str2
                push ax
                mov ax , str1
                push ax
                call upentered
                jmp endup
               
pul2:           mov ax , [opt3pos]
                push ax
                mov ax , str3
                push ax
                mov ax , str2
                push ax
                call upentered
                jmp endup
                
pul3:           mov ax , [opt4pos]
                push ax
                mov ax , str4
                push ax
                mov ax , str3
                push ax
                call upentered
                jmp endup
                
endup:          popa
                ret

selectingoption:
                    pusha
l5:                 
                    pusha

                    mov ax, 0xb800
                    mov es, ax
                    mov di, 310
                    mov al, [option]
                    add al, '0'
                    mov ah, 0x05
                    stosw
                    popa


                    mov ah , 0x08
                    int 0x21

                    cmp al , 'w'
                    je l6
                    cmp al , 's'
                    je l7
                    cmp al , 0x0D
                    je l9
                    jmp l5
l6:                 call moveup
                    jmp l5
l7:                 call movedown
                    jmp l5
l9:                 cmp word[option] , 1
                    je t1
                    cmp word[option] , 2
                    je t2
                    cmp word[option] , 3
                    je t3
                    cmp word[option] , 4
                    je t4

t1:                 mov ax , str1
                    mov bx , [opt1pos]
                    jmp t5
t2:                 mov ax , str2
                    mov bx , [opt2pos]
                    jmp t5
t3:                 mov ax , str3
                    mov bx , [opt3pos]       
                    jmp t5
t4:                 mov ax , str4
                    mov bx , [opt4pos]       
                    jmp t5
       
t5:                 call clrscr
                    push 20
					push 2
					call printGame

					push 7
					push 13
					call printFinished
				
                    jmp l8

l8:                 popa
                    ret
			
;===================print Maze Runner===================
Mazel1: db  ' /$$      /$$', 0                              
Mazel2: db  '| $$$    /$$$', 0                          
Mazel3: db  '| $$$$  /$$$$  /$$$$$$  /$$$$$$$$  /$$$$$$', 0 
Mazel4: db  '| $$ $$/$$ $$ |____  $$|____ /$$/ /$$__  $$', 0
Mazel5: db  '| $$  $$$| $$  /$$$$$$$   /$$$$/ | $$$$$$$$', 0
Mazel6: db  '| $$\  $ | $$ /$$__  $$  /$$__/  | $$_____/', 0
Mazel7: db  '| $$ \/  | $$|  $$$$$$$ /$$$$$$$$|  $$$$$$$', 0
Mazel8: db  '|__/     |__/ \_______/|________/ \_______/', 0


Gamel1: db '  /$$$$$$', 0                                   
Gamel2: db ' /$$__  $$', 0                                  
Gamel3: db '| $$  \__/  /$$$$$$  /$$$$$$/$$$$   /$$$$$$ ', 0
Gamel4: db '| $$ /$$$$ |____  $$| $$_  $$_  $$ /$$__  $$', 0
Gamel5: db '| $$|_  $$  /$$$$$$$| $$ \ $$ \ $$| $$$$$$$$', 0
Gamel6: db '| $$  \ $$ /$$__  $$| $$ | $$ | $$| $$_____/', 0
Gamel7: db '|  $$$$$$/|  $$$$$$$| $$ | $$ | $$|  $$$$$$$', 0
Gamel8: db ' \______/  \_______/|__/ |__/ |__/ \_______/', 0


Finishedl1: db " /$$$$$$$$ /$$           /$$           /$$                       /$$", 0
Finishedl2: db "| $$_____/|__/          |__/          | $$                      | $$", 0
Finishedl3: db "| $$       /$$ /$$$$$$$  /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$$", 0
Finishedl4: db "| $$$$$   | $$| $$__  $$| $$ /$$_____/| $$__  $$ /$$__  $$ /$$__  $$", 0
Finishedl5: db "| $$__/   | $$| $$  \ $$| $$|  $$$$$$ | $$  \ $$| $$$$$$$$| $$  | $$", 0
Finishedl6: db "| $$      | $$| $$  | $$| $$ \____  $$| $$  | $$| $$_____/| $$  | $$", 0
Finishedl7: db "| $$      | $$| $$  | $$| $$ /$$$$$$$/| $$  | $$|  $$$$$$$|  $$$$$$$", 0
Finishedl8: db "|__/      |__/|__/  |__/|__/|_______/ |__/  |__/ \_______/ \_______/", 0
                                                                    





; bp + 4 = y
; bp + 6 = x
; bp + 8 = arr


; bp + 4 = starting position
; bp + 6 = spacing
printFinished:
		
		push bp
		mov bp, sp
		pusha
		
		mov di, [bp + 4]
		mov si, [bp + 6]
		
		push Finishedl1
		push si
		push di
		call printarr
			
		inc di
		push Finishedl2
		push si
		push di
		call printarr
				
		inc di
		push Finishedl3
		push si
		push di
		call printarr
		
		inc di
		push Finishedl4
		push si
		push di
		call printarr
		
		inc di
		push Finishedl5
		push si
		push di
		call printarr
		
		inc di	
		push Finishedl6
		push si
		push di 
		call printarr
		
		inc di 
		push Finishedl7
		push si
		push di
		call printarr
		
		
		inc di
		push Finishedl8
		push si
		push di
		call printarr
		
		popa
		pop bp
		ret 4


; bp + 4 = starting position
; bp + 6 = spacing
printMaze:
		
		push bp
		mov bp, sp
		pusha
		
		
		mov di, [bp + 4]
		mov si, [bp + 6]
		
		push Mazel1
		push si
		push di
		call printarr
			
		inc di
		push Mazel2
		push si
		push di
		call printarr
				
		inc di
		push Mazel3
		push si
		push di
		call printarr
		
		inc di
		push Mazel4
		push si
		push di
		call printarr
		
		inc di
		push Mazel5
		push si
		push di
		call printarr
		
		inc di	
		push Mazel6
		push si
		push di 
		call printarr
		
		inc di 
		push Mazel7
		push si
		push di
		call printarr
		
		
		inc di
		push Mazel8
		push si
		push di
		call printarr
		
		popa
		pop bp
		ret 4
		
printGame:
		push bp
		mov bp, sp
		pusha
		
		
		mov di, [bp + 4]
		mov si, [bp + 6]
		
		
		inc di
		push Gamel1
		push si
		push di
		call printarr
		
		inc di
		push Gamel2
		push si
		push di
		call printarr
		
		inc di
		push Gamel3
		push si
		push di
		call printarr
		
		
		inc di
		push Gamel4
		push si
		push di
		call printarr
		
		
		inc di
		push Gamel5
		push si
		push di
		call printarr
		
		
		inc di
		push Gamel6
		push si
		push di
		call printarr
		
		
		inc di
		push Gamel7
		push si
		push di
		call printarr
		
		
		inc di
		push Gamel8
		push si
		push di
		call printarr
		
		popa
		pop bp
		ret 4






PrintFrontPage:
	pusha

	call clrscr
	push word 5
	push word 3
	call printMaze
	push word 30
	push word 13
	call printGame

	popa
	ret


gameFinished: dw 0  ; 0 if not finished 1 if finished

;------------Random Function---------

seed: dw 0


;---------------Modes----------------

supermanMode: dw 0

;-----------Hooking Timer Function---------

oldTimerIsr: dd 0

;-----------Maze Generation---------------

MazeX: dw 10
MazeY: dw 2
MazeLen: dw 21
MazeWidth: dw 61

temp: db 0
randNum: dw 0
boundary: dw 0
moveFlag: dw 1		; 1 Can move 0 Cannot move 

MazeColor: db 0x55
PathColor: db 0x33
Path: db 0x20
PlayerColor: db 0x04
PlayerPos: dw 0
Player: db 0x01

; For Fruits
FruitCoolDown: dw 0
Fruit: db 0x04
FruitColor: db 0x02

; Ending Point
End: db '+'
EndColor: db 0x35
EndFlag: dw 0

;-----------------------------Score------------
score: dw 0
StrScore: db 'SCORE : ', 0

;-----------------------------Enemy Variables
EnemyColor: db 0x35
Enemy: 		db 0x01
EnemySteps:	dw 	-160, 160, 2, -2 
Directions:	dw 	0, 0, 0, 0				
				;UP, DOWN, RIGHT, LEFT

numDirectionAvailable: dw 0
lastMove: dw 2
EnemyPos: dw 0
EnemyCoolDownTime: dw 0
Life: dw 3
strLives: db 'LIVES : ', 0

enemytemp1: dw 0x3320
enemytemp2: dw 0x0000

; ==============End Screen=============
strWinl1: db "                     __    __               ", 0
strWinl2: db "/\_/\  ___   _   _  / / /\ \ \  ___   _ __  ", 0
strWinl3: db "\_ _/ / _ \ | | | | \ \/  \/ / / _ \ | '_ \ ", 0
strWinl4: db " / \ | (_) || |_| |  \  /\  / | (_) || | | |", 0
strWinl5: db " \_/  \___/  \__,_|   \/  \/   \___/ |_| |_|", 0



strLostl1: db "                       __               _   ", 0
strLostl2: db "/\_/\  ___   _   _    / /    ___   ___ | |_ ", 0
strLostl3: db "\_ _/ / _ \ | | | |  / /    / _ \ / __|| __|", 0
strLostl4: db " / \ | (_) || |_| | / /___ | (_) |\__ \| |_ ", 0
strLostl5: db " \_/  \___/  \__,_| \____/  \___/ |___/ \__|", 0


;=========================Timer================

time: dw 0
tickcount: dw 0
strTime: db 'TIME  : ',0



checkLeftBoundary:
	pusha
	mov dx, 0
	sub di, 2
	mov ax, di
	mov cx, 160
	div cx
	
	mov bx, [MazeX]
	shl bx, 1
	cmp dx, bx
	je setT
	jmp setF


checkUpBoundary:
	pusha
	mov dx, 0
	sub di, 160
	mov ax, di
	mov bx, 160
	div bx
	cmp ax, [MazeY]
	je setT
	jmp setF
	
checkDownBoundary:
	pusha

	
	mov dx, 0
	add di, 160
	mov ax, di
	mov bx, 160
	
	
	div bx
	
	mov bx, [MazeY]
	add bx, [MazeLen]
	
	
	
	sub bx, 1
	cmp ax, bx
	
	je setT
	jmp setF	
	
checkRightBoundary:
	pusha
	mov dx, 0
	add di, 2
	mov ax, di
	mov cx, 160
	div cx
	mov bx, [MazeX]
	add bx, [MazeWidth]
	shl bx, 1
	sub bx, 2
	cmp dx, bx
	je setT
	jmp setF
		
	
setT:
	mov word [boundary], 1
	popa
	ret

setF:
	mov word [boundary], 0
	popa
	ret
	
delay:
pusha
mov cx, 0xFFFF;
loop1:
dec cx;
jnz loop1
popa
ret

randomGen:
push bp
mov bp, sp
push bx
push cx
push dx
push es

;XOR Shift Random no. Generator

mov ax, [seed]    
mov cx, 7	; Shift amount for 1st operation
mov dx, ax	; value to be shifted

lA:
shl dx, 1
loop lA
xor ax, dx

mov cx, 9	; Shift amount for 2nd operation
mov dx, ax	; value to be shifted
lB:
shr dx, 1
loop lB
xor ax, dx

mov cx, 8	; Shift amount for 3rd operation
mov dx, ax	; value to be shifted
lC:
shl dx, 1
loop lC
xor ax, dx

; ax has random value

mov [seed], ax 	; update seed
mov ah, 0		; reduce the value.
div byte [bp + 4]	; compress into the range. 
mov al, ah		; store in al.

pop es
pop dx
pop cx
pop bx

pop bp

ret 2


	


;	bp + 4 = x
;	bp + 6 = y
;	bp + 8 = len
; 	bp + 10 = width

setToStartingPointOfMaze:
	push ax
	
	mov ax, 80
	mul byte [MazeY]
	add ax, [MazeX]
	shl ax, 1
	mov di, ax	
	add di, 162
	
	;mov ax, 0x3401
	;stosw
	;sub di, 2
	
	pop ax
	
	ret

setToEndingPointOfMaze:
	push ax
	push bx

	
	mov ax, 80
	mul byte [MazeY]
	add ax, [MazeX]
	shl ax, 1
	mov di, ax	
	add di, 162
	
	mov bl, [MazeLen]
	sub bl, 4
	mov ax, 160
	mul bl
	add di, ax

	;mov ax, 0x3401
	;stosw
	;sub di, 2
	
	pop bx
	pop ax
	
	ret


clrscr:
	pusha
	
	mov ax, 0xb800
	mov es, ax
	
	mov cx, 2000
	mov ax, 0x0720
	xor di, di
	
	rep stosw
	
	popa
	ret
	
drawRect:
	push bp
	mov bp, sp
	pusha 
	
	
	mov ax, 80
	mul word [bp + 6]
	add ax, [bp + 4]
	shl ax, 1
	mov di, ax
	
	mov ax, 0xb800
	mov es, ax
	
	mov ah, [MazeColor]
	mov al, 0x20
	
	mov cx, [bp + 8]
	l1:
		push cx
		mov cx, [bp + 10]
		rep stosw

		push ax
		push bx
			mov ax, [bp + 10] 
			mov bx, 2
			mul bx
			add di, 160
			sub di, ax
		pop bx
		pop ax
		
		pop cx
		loop l1
	
	
	
	popa 
	pop bp
	ret 8
	

	
RemoveEither:
		
		pusha
		mov ah, 2ch         ;"Get System Time"
		int 21h     
		 
		; After the interrupt, DL = hundredths of a second

		mov [seed], dl		; seed
		mov ax, 7	; random no. range (0-1)
		push ax
		Call randomGen	; AL has rand
		
		cmp al, 4
		mov [temp], al
		popa
		
		ja RemoveLeft
		jb RemoveUp
		
		jmp RemoveBoth

setPathOrFruit:
    push bx
    push dx

        inc word [FruitCoolDown]
        mov ax, [FruitCoolDown]
        mov dx, 0
        mov bx, 10
        div bx

        mov word [FruitCoolDown], dx


        cmp word [FruitCoolDown], 0
        je setFruit
        
        ; set Path
        
        mov ah, [PathColor]
        mov al, 0x20
        
        jmp done

    setFruit:
        mov ah, [PathColor]
        and ah, 0xf0
        or ah, [FruitColor]
        mov al, [Fruit]

    done
        pop dx
        pop bx
        ret 








RemoveBoth:
	
	push di
	push ax
	
    




	mov ah, [PathColor]
    mov al, 0x20
	
	mov word [es:di], ax	; mark visited
	sub di, 160
	mov word [es:di], ax	; mark visited
	pop ax
	pop di
	
	push di
	push ax
	
	call setPathOrFruit
	
	mov word [es:di], ax; mark visited
	sub di, 2
	mov word[es:di], ax
	
	pop ax
	pop di
	
	jmp skip
	


RemoveUp:
	
	push di
	push ax
	
	mov ah, [PathColor]
    mov al, 0x20
	
	mov word [es:di], ax	; mark visited
	sub di, 160
	mov word [es:di], ax	; mark visited
	pop ax
	pop di
	
	
	jmp skip

	
RemoveLeft:
	push di
	push ax
	
	call setPathOrFruit
	
	mov word [es:di], ax; mark visited
	sub di, 2
	mov word[es:di], ax
	
	pop ax
	pop di
	
	jmp skip
	


generateMaze:
	pusha
		
GenMazeStr:
		call checkUpBoundary
		cmp word [boundary], 1
		je checkLeftSide
		
		
		call checkLeftBoundary
		cmp word [boundary], 1
		je RemoveUp
		jmp RemoveEither
		
	
		
checkLeftSide:	
		call checkLeftBoundary
		cmp word [boundary], 1
		je skip
		jmp RemoveLeft
		

skip:	
		call checkRightBoundary
		cmp word [boundary], 1
		
		; pushf used as flags would be changed by adding 
		pushf
		add di, 4
		popf
		
		jne skipUpdateline; sub 160 to go to the up line 
		
		add di, 160*2
		
		push ax
		mov ax, [MazeWidth]
		shl ax, 1
		sub di, ax
		add di, 2
		
		pop ax
		
		
skipUpdateline:
		
		;call delay
		call checkRightBoundary
		cmp word [boundary], 1
		jne GenMazeStr
		
		call checkDownBoundary
		cmp word [boundary], 1
		je endFr		
		jmp GenMazeStr
		 
endFr:				; EndFrrrrrrr
	
	popa
	ret

drawMaze:
	mov ax, 0xb800
	mov es, ax
	
	call clrscr

	push word [MazeWidth]		;	width
	push word [MazeLen]		; 	len
	push word [MazeY]		; start y
	push word [MazeX]		; start x
	call drawRect
	
	; calculate the starting point and put it in di
	; always start at the top left

	call setToStartingPointOfMaze
	
	call generateMaze

	call GenEnd

	ret
	





; ---------------------------Movement---------------------------

checkFruitCollision:
    pusha

    mov ax, 0xb800
    mov es, ax
    
    mov ah, [PathColor]
    and ah, 0xf0
    or ah, [FruitColor]
    mov al, [Fruit]

    cmp [es:di], ax
    jne SkipIncrementScore

    add word [score], 10

    push word 1
    push word 30
    call printScore
    
    SkipIncrementScore:

    popa
    ret

movright:
			call checkRight
			cmp word [moveFlag], 1
			jne skipMovRight

moveRightWithoutCheck:		
	
            ; move the character to right position
			push ax
			
			mov ax, 0xb800
			mov es, ax

            add di, 2
			call ReachedEnd
            call checkFruitCollision

			
			mov al , [Path]		
			mov ah, [PathColor]		; setting background color
			
			mov word [es:di - 2], ax

			mov al, [Player]
			and ah, 0xf0
			or ah, [PlayerColor]		; setting player color
			
			mov word [es:di], ax
			
			pop ax

			cmp word [supermanMode], 1
			je movright
			
skipMovRight:			
			
			ret 
			
			
movup:
            
			call checkUp
			cmp word [moveFlag], 1
			jne skipMovUp

movUpWithoutCheck:
			; move the character to Up position
			push ax
			
			
			mov ax, 0xb800
			mov es, ax

            sub di, 160
            
			call ReachedEnd
            call checkFruitCollision

			
			mov al, [Path]			
			mov ah, [PathColor]		; setting background color
			
			mov word [es:di + 160], ax
			
			mov al, [Player]
			and ah, 0xf0
			or ah, [PlayerColor]		; setting player color
			

			mov word [es:di], ax
			
			pop ax

			cmp word [supermanMode], 1
			je movup

skipMovUp:			
			ret 

movleft:    			
			
			call checkLeft
			cmp word [moveFlag], 1
			jne skipMovLeft
			
movLeftWithoutCheck:			
			push ax
			
			
			mov ax, 0xb800
			mov es, ax
			
            sub di, 2

			call ReachedEnd
            call checkFruitCollision

			
			mov al, [Path]			
			mov ah, [PathColor]		; setting background color
			
			mov word [es:di + 2], ax
			
			mov al, [Player]
			and ah, 0xf0
			or ah, [PlayerColor]		; setting player color
			

			mov word [es:di], ax
			
			pop ax

			cmp word [supermanMode], 1
			je movleft

skipMovLeft:
			ret 


movdown:     	
			call checkDown
			cmp word [moveFlag], 1
			jne skipMovDown

movDownWithoutCheck:	
			push ax
				
			mov ax, 0xb800
			mov es, ax
			

            add di, 160

			call ReachedEnd
            call checkFruitCollision


			mov al, 0x20			
			mov ah, [PathColor]		; setting background color
			
			mov word [es:di - 160], ax
			
			mov al, [Player]
			and ah, 0xf0
			or ah, [PlayerColor]		; setting player color
			
			mov word [es:di], ax
			
			pop ax

			cmp word [supermanMode], 1
			je movdown

skipMovDown:
			ret 



checkRight:
	pusha 
	
	mov ah, [MazeColor]
	mov al, 0x20
	cmp word [es:di + 2], ax
	jne SetCheckDirTrue
	jmp SetCheckDirFalse
	
checkLeft:
	pusha 

	
	mov ah, [MazeColor]
	mov al, 0x20
	cmp word [es:di - 2], ax
	jne SetCheckDirTrue
	jmp SetCheckDirFalse

checkUp:
	pusha 

	
	mov ah, [MazeColor]
	mov al, 0x20
	cmp word [es:di - 160], ax
	jne SetCheckDirTrue
	jmp SetCheckDirFalse


checkDown:
	pusha 

	mov ah, [MazeColor]
	mov al, 0x20
	cmp word [es:di + 160] , ax
	jne SetCheckDirTrue
	jmp SetCheckDirFalse


SetCheckDirFalse:
	mov word [moveFlag], 0
	popa 
	ret
	
SetCheckDirTrue:
	mov word [moveFlag], 1
	popa
	ret



movePlayer:
	
	pusha
	mov di, [PlayerPos]
	
	mov ah ,0x08
	int 0x21
	mov dl , al
	cmp al , 'w'
	je goUp ; up

	cmp al ,'d'
	je goRight ; right

	cmp al , 's'
	je goDown ; down

	cmp al , 'a'
	je goLeft; left

    cmp al, 'm'
    jne SkipToggleSupermanMode

    ToggleSupermanMode:

    cmp word [supermanMode], 1
    jne setOne

    mov word [supermanMode], 0
    jmp SkipToggleSupermanMode

    setOne:
    mov word [supermanMode], 1


    SkipToggleSupermanMode:
	jmp skipMove


	goUp:     
			call movup
			jmp skipMove

	goRight:     
			call  movright
			jmp skipMove

	goDown: 
			call movdown
			jmp skipMove

	goLeft:    
			call movleft

	skipMove:

		mov [PlayerPos], di		
		popa
		ret




;-----------------Fruits----------------
; i am goona make 10 fruits randomly appear on the screen
; the positions of whome will be stored in an array




;-----------------Enemy-----------------



moveEnemy:
	
	; will be given the spaun coordinates
	pusha
	mov di, [EnemyPos]
	
	mov word [numDirectionAvailable], 0
	
	call checkUp
	mov ax, [moveFlag]
	mov [Directions], ax
	add [numDirectionAvailable], ax
	
	
	call checkDown 
	mov ax, [moveFlag]
	mov [Directions + 2], ax
	add [numDirectionAvailable], ax
	
	call checkRight
	mov ax, [moveFlag]
	mov [Directions + 4], ax
	add [numDirectionAvailable], ax
	
	
	call checkLeft
	mov ax, [moveFlag]
	mov [Directions + 6], ax
	add [numDirectionAvailable], ax
	
	
	
	RandEnemyMovement:	; generates a random number till a number is generated which has a 

		push word 4
		call randomGen
		mov ah, 0
		mov si, ax
		shl si, 1
		
		; rotate 180 degree only when the surronded by 3 walls
		
		
		
		cmp word [Directions + si], 1
		jne RandEnemyMovement
		;jmp skipRandEnemyMovement


		cmp word [lastMove], 0	; is last move was up
		jne checkDownMove
	
	checkMoveUp:
		; last move was up
		cmp si, 2	; is this move down
		je CheckOtherOptions
		jmp skipRandEnemyMovement
		
		; check if last move was down 
	checkDownMove:
		cmp  word [lastMove], 2
		jne checkRightMove
		
		; last move was down
		cmp si, 0	; is this move up
		je CheckOtherOptions
		jmp skipRandEnemyMovement
		
	checkRightMove:
		cmp word [lastMove], 4
		jne checkLeftMove
		
		; last move was right
		cmp si, 6	; is this move left
		je CheckOtherOptions
		jmp skipRandEnemyMovement
		
		
	checkLeftMove:
		cmp word [lastMove], 6
		jne RandEnemyMovement
		
		; last move was right
		cmp si, 4	; is this move left
		je CheckOtherOptions
		jmp skipRandEnemyMovement
		
		
CheckOtherOptions:
		cmp word [numDirectionAvailable], 1
		je skipRandEnemyMovement
		jmp RandEnemyMovement
		
		
	; here al would store the offset of direction	
skipRandEnemyMovement:
	mov word [lastMove], si
	
	add di, [EnemySteps + si]
	
	pusha 
	mov ax, 0xb800
	mov es, ax
	

    ; saving the contents of new position
    mov ax, [es:di]
    mov [enemytemp2], ax


    ; print the contents of prev position at that position
	mov ax, [enemytemp1]
	
	mov bx, [EnemySteps + si]
	neg bx
	mov word [es:di + bx], ax
	
    ; printing enemy
	mov ah, [EnemyColor]
	mov al, 0x01
	
	mov word [es:di], ax

    ; moving temp 2 to temp1
    mov ax, [enemytemp2]
    mov [enemytemp1], ax

	popa
	
	
	
	mov [EnemyPos], di
	popa
	ret


;=========================Timer========================
; bp + 4 = num
; bp + 6 = x
; bp + 8 = y
printnum:
        push bp
        mov bp, sp
        push es
        push ax
        push bx
        push cx
        push dx
        push di
        mov ax, 0xb800
        mov es, ax ; point es to video base
        mov ax, [bp+4] ; load number in ax
        mov bx, 10 ; use base 10 for division
        mov cx, 0 ; initialize count of digits
        
    nextdigit: 
        mov dx, 0 ; zero upper half of dividend
        div bx ; divide by 10
        add dl, 0x30 ; convert digit into ascii value
        push dx ; save ascii value on stack
        inc cx ; increment count of values
        cmp ax, 0 ; is the quotient zero
        jnz nextdigit ; if no divide it again
        
        cmp cx, 1
        je nextdigit
       
        push ax
        push dx
        mov ax, 80
        mul byte [bp + 8]
        add ax, [bp + 6]
        shl ax, 1
        mov di, ax
        pop dx
        pop ax
        
    nextpos: 
        pop dx ; remove a digit from the stack
        mov dh, 0x07 ; use normal attribute
        mov [es:di], dx ; print char on screen
        add di, 2 ; move to next screen location
        loop nextpos ; repeat for all digits on stack
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        pop es
        pop bp
        ret 6

; bp + 4 = y
; bp + 6 = x
; bp + 8 = arr
printarr:
		push bp
		mov bp, sp
		pusha

		mov ax, 0xb800
		mov es, ax

		mov ax, 80
		mul byte [bp + 4]
		add ax, [bp + 6]
		shl ax, 1
		mov di, ax

		mov si, [bp + 8]

		cld
		mov ah, 0x05

		l3:
		lodsb 
		
		cmp al, 0
		je end

		stosw
		jmp l3

		end:

		popa
		pop bp
		ret 6

; bp + 4 = x
; bp + 6 = y
printTime:
	push bp
	mov bp, sp
    pusha

    mov ax, [time]
    mov dx, 0
	mov bx, 60
    div bx

    ; mins in ax 
    ; sec in dx
    push ax

    push strTime
    push word [bp + 4]
    push word [bp + 6]
    call printarr

    pop ax

	mov word[minutesplayed] , ax
	
    push word [bp + 6]
	mov bx, [bp + 4]
	add bx, 8
    push bx
    push ax
    call printnum

	push ax
	push dx

	mov ax, 80
	mul byte [bp + 6]
	add ax, bx
	add ax, 2
	shl ax, 1
	mov di, ax

	pop dx
	pop ax


    printColon:
        mov ax, 0xb800
        mov es, ax
        mov al, ':'
        mov ah, 0x07
        mov word [es:di], ax

        push word [bp + 6]
        add bx, 3
		push bx
        push dx
        call printnum
    popa 
	pop bp
    ret 4






;=========================Timer================


Timer:
    pusha

    inc word [tickcount]
    cmp word [tickcount], 18
    jne skipL
    mov word [tickcount], 0

	push 1
	push 58
    call printTime
    inc word [time]
    skipL:
   
    popa
	ret

myfunction:

    pusha
    
    ; functionality of timer

    call Timer

    ; funtionality of movement of enemy and checking collision with player

    inc word [EnemyCoolDownTime];
	mov ax, [EnemyCoolDownTime]
	mov dx, 0
	mov bx, 5
	div bx
	mov ax, dx
	mov word [EnemyCoolDownTime], ax
	cmp word [EnemyCoolDownTime], 0
	je CallMoveEnemy
	jmp skipMoveEnemy

	CallMoveEnemy:
	    call moveEnemy
        call checkCollision

	skipMoveEnemy:

    ;====================Print Lives=====================

    call PrintLives



    ; EOI
    mov al, 0x20
    out 0x20, al

    popa
    iret

;====================Timer===================

PrintLives:
    pusha
    
    mov ax, 0xb800
    mov es, ax


    push strLives
    push 10
    push 1
    call printarr

    mov cx, [Life]
    
    mov di, 196
    mov ah, 0x05
    mov al, 0x03
    rep stosw

    mov cx, 3
    sub cx, [Life]
    mov ah, 0x00
    rep stosw

    popa
    ret 


checkCollision:
        pusha

        mov ax, [EnemyPos]
	    cmp ax, [PlayerPos]
        jne skipCollision
        
    collision:
        dec word [Life]
    
    skipCollision
        popa
        ret

;================================Score============================

; bp + 4 = x
; bp + 6 = y
printScore:
        push bp
        mov bp, sp
        pusha
        
        mov ax, [bp + 4]    ; x

        push StrScore
        push word [bp + 4]
        push word [bp + 6]
        call printarr

        add ax, 10
        push word [bp + 6]
        push ax
        push word [score]
        call printnum

        popa 
        pop bp
        ret 4

GenEnd:

	pusha

	call setToEndingPointOfMaze

	push 41
	call randomGen
	add al, 10
	; now al has values from 10 to 70
	mov ah, 0
	shl ax, 1

	add di, ax

	mov al, [End]
	mov ah, [EndColor]
	stosw

	popa
	ret

ReachedEnd: 
	pusha

    mov ax, 0xb800
    mov es, ax
    
    mov ah, [EndColor]
    mov al, [End]

    cmp [es:di], ax
    jne SkipSetEnd

    mov word [EndFlag], 1
    
	SkipSetEnd:

    popa
    ret

;===================End Screen==============

EndScreen:
    pusha
    cmp word [EndFlag], 1
	pushf
    call clrscr
	popf
    je Won
    jmp Lost


    Won:

        push strWinl1
        push 20
        push 7
        call printarr

        push strWinl2
        push 20
        push 8
        call printarr
        
        push strWinl3
        push 20
        push 9
        call printarr

        push strWinl4
        push 20
        push 10
        call printarr
        
        push strWinl5
        push 20
        push 11
        call printarr

		jmp SkipEndScreen

		
    Lost:

		push strLostl1
        push 20
        push 7
        call printarr

        push strLostl2
        push 20
        push 8
        call printarr
        
        push strLostl3
        push 20
        push 9
        call printarr

        push strLostl4
        push 20
        push 10
        call printarr
        
        push strLostl5
        push 20
        push 11
        call printarr

	SkipEndScreen:

        push  15
        push 35
        call printScore

		push 17
		push 35
        call printTime

    popa
    ret











start:

	call PrintFrontPage
	mov cx , 12

m1:
	call delay
	loop m1


	call clrscr
	call setoptspos
	call printoptions
	call selectingoption

	cmp word [option], 4
	jne checkSingleLifeMode

	push terminate
	ret






checkSingleLifeMode:

	cmp word[option] , 3
	jne  l12
	mov word [Life] , 1

l12:	mov ax, 0xb800
		mov es, ax
	
	call drawMaze

    push word 1
    push word 30
    call printScore
	
    call setToStartingPointOfMaze	;	sets di to starting point of maze
	mov word [PlayerPos], di

	call setToEndingPointOfMaze;	sets di to starting point of maze
	mov word [EnemyPos], di

    ; hooking timer interupt
    mov ax, 0
    mov es, ax

    ; saving prev timer
    mov ax, [es:8*4]
    mov [oldTimerIsr], ax
    mov ax, [es:8*4 + 2]
    mov [oldTimerIsr + 2], ax  

    cli
    mov word [es:8*4], myfunction
    mov word [es:8*4+2], cs
    sti 
	
    mov ax, 0xb800
    mov es, ax

	RepeatMove:

        call movePlayer

		cmp word [EndFlag], 1
		je GameFinished


        call checkCollision

        ; code for checking game end

        call PrintLives

        cmp word [Life], 0
        je GameFinished  

		cmp word[option] , 2
		je cmpmin
		jmp RepeatMove

	cmpmin:
		cmp word[minutesplayed] , 1
		je GameFinished

	jmp RepeatMove


    ; program terminated

GameFinished:
    xor ax, ax
    mov es, ax
    cli
	mov ax, [oldTimerIsr]
    mov bx, [oldTimerIsr + 2]
    mov [es:8*4], ax
    mov [es:8*4 + 2], bx
    sti

    call EndScreen

terminate:
	mov ax, 0x4c00
	int 0x21