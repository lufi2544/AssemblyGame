INCLUDE Irvine32.inc

.data
ground BYTE "--------------------------------------------------------------------", 0

xPos BYTE 20
yPos BYTE 20

inputChar BYTE ?

isJumping BYTE 'F'

; DOCUMENTATION
; ReadChar - reads player input and puts it in the AL(8-bit) register which is the less significant byte in the EAX register(32-bit).
; WriteString - reading the EAX register until we hit a 0, see ground variable
; Gotoxy - moves the cursor to the x, y positions stored in the dl(x), dh(y) registers.

.code

main PROC
	; draw the ground at (0, 29) along the player
	mov dl, 0 ; dl containing the X position
	mov dh, 29; dh containing the Y position
	call Gotoxy ; moves the cursor to the x, y coordinates taken in the dl and dh register
	mov edx, OFFSET ground ; as the EDX register is a 32-bit register, we move only the first 32bits of the ground variable and by calling the WriteString function, it will keep reading the EDX register util we hit a 0. 
	call WriteString
	call DrawPlayer

	gameLoop:		
		; get user key input
		call ReadChar
		mov inputChar, al

		; exit game if user types 'x'
		cmp inputChar, "x"
		je exitGame 

		cmp inputChar, "w"
		je moveUp

		cmp inputChar, "s"
		je moveDown

		cmp inputChar, "d"
		je moveRight

		cmp inputChar, "a"
		je moveLeft

		; if input not recognized, then we recursively call this.
		jmp gameLoop
		
		moveUp:
		call UpdatePlayer
		dec yPos
		call DrawPlayer
		jmp gameLoop

		moveDown:
		call UpdatePlayer
		inc yPos
		call DrawPlayer
		jmp gameLoop

		moveRight:
		call UpdatePlayer
		inc xPos
		call DrawPlayer
		jmp gameLoop

		moveLeft:
		call UpdatePlayer
		dec xPos
		call DrawPlayer
		jmp gameLoop


	exitGame:
	exit
main ENDP

; Draw player at (20, 20)
DrawPlayer PROC ; as the EAX register is a 32bit register, we can not put a char here, because they are 8-bit, so we are using the less significant byte here for it, which is the AL register
	mov dl, xPos
	mov dh ,yPos
	call Gotoxy
	mov al, "X" ; less significant byte of the EAX register, meaning 8-bits
	call WriteChar
	ret
DrawPlayer ENDP

UpdatePlayer PROC
	mov dl, xPos
	mov dh ,yPos
	call Gotoxy
	mov al, " " ; less significant byte of the EAX register, meaning 8-bits
	call WriteChar
	ret
UpdatePlayer ENDP


END main
