STACK SEGMENT PARA STACK
	DB 64 DUP(' ')
STACK ENDS

DATA SEGMENT PARA 'DATA'

	BALL_X_POS DW 0Ah ;posición en eje x de la pelota
	BALL_Y_POS DW 0Ah ;posición en el eje y de la pelota
	BALL_SIZE DW 04h  ;el tamaño de la pelota de 4 pixeles

DATA ENDS

CODE SEGMENT PARA 'CODE'
	
	MAIN PROC FAR
	ASSUME CS:CODE, DS:DATA, SS:STACK	;asume como CODE, DATA  y STACK a sus respectivos registros
	PUSH DS                             ;pushea en el stack el segmento DS	
	SUB AX,AX                           ;limpia registro AX
	PUSH AX                             ;pushea AX al STACK
	MOV AX,DATA                         ;guarda en el registro AX el contenido del segmento DATA
	MOV DS,AX                           ;guarda en segmento DS el contenido de AX
	POP AX                              ;libera el head element del STACK
	POP AX
	
		MOV AH, 00h ;setea la configuración en video mode
		MOV AL, 13h ;elegimos el modo gráfico 320*200
		INT 10h     ;ejecutamos la configuración llamando interrupción 10
		
		MOV AH,0Bh  ;setea la cofiguracinó del color de fondo
		MOV BH, 00h ;se elige el negro como color de fondo
		INT 10h     ;ejecutamos la configuración
		
		CALL DRAW_BALL
		
		RET
	MAIN ENDP
	
	DRAW_BALL PROC NEAR
	
		MOV CX, BALL_X_POS ;setea posición inicial de la columna x-pos
		MOV DX, BALL_Y_POS ;setea posición inicial de la linea y
		
		DRAW_BALL_HORIZONTAL:
			MOV AH, 0CH 			;setea la configuración para escribir un pixel
			MOV AL, 0Fh 			;elige el blanco como color del pixel
			MOV BH, 00h 			;setea numero de página
			INT 10h     			;ejecuta la configuración seteada
			INC CX      			;CX = CX + 1
			MOV AX, CX  			;CX - BALL_X_POS > BALL_SIZE (y -> siguiente línea, sino continuamos con la siguiente columna
			SUB AX, BALL_X_POS
			CMP AX, BALL_SIZE
			JNP DRAW_BALL_HORIZONTAL
			MOV CX, BALL_X_POS 		;El registro CX vuelve a la columna inicial
			INC DX     				;avanzamos una líena
			MOV AX,DX				;DX - BALL_Y_POS > BALL_SIZE (y -> salimos del procedimiento; sino continuamos con la siguiente linea.
			SUB AX, BALL_Y_POS
			CMP AX, BALL_SIZE
			JNP DRAW_BALL_HORIZONTAL	

		RET
	DRAW_BALL ENDP

CODE ENDS
END