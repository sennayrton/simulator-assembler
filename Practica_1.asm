; Programa: Práctica de Laboratorio 1

; Propósito: programa que contenga una rutina a la que se le pase el ascii de un carácter, una posición del 
; display textual (siendo 1 la primera) y el número de repeticiones y lo escriba en el display. 
; Utilizará un registro para indicar un error (único) si el número de repeticiones solicitadas es 0, 
; mayor de 32 o si al escribirlas desde la posicion deseada se desbordaría el display (en estos casos, 
; no se escribiría nada en el display). El programa principal utilizará dicha rutina para escribir 
; cuatro veces “0” desde la posición 1 y doce veces “H” desde la posición 7.

; Autores: Jorge Afonso Blandez, Diego Navarro López, Clara Monsalve Paniagua y Sergio Picazo Serrano

;Fecha: 11/10/2020

	JMP boot

ascii0:	DB 48d		; Codigo ascii correspondiente al nº 0 que se imprimirá posteriormente

asciiH: DB 72d		; Codigo ascii correspondiente a la letra H que se imprimirá posteriormente


boot:
	MOV SP, 255		; Ponemos el puntero de pila en 255 (empezará en 00FF)
	MOV C, ascii0	; Metemos en el registro C el primer caracter que vamos a imprimir (0)
    
    MOV D, 0x02E0	; Puntero que apunta a la dirección donde queremos empezar a imprimir el primer caracter, guardado en el registro D
	MOVB AH, 0x04   ; Determina el nº de repeticiones del primer caracter, lo guardamos en AHigh

;Primera condición
    CMPB AH, 0x00	; Comprueba si el nº de repeticiones es igual a 0 
    JZ end			; En caso de que sea 0 no imprime nada y se acaba el programa
;Segunda condición    
    CMPB AH, 0x20	; Compara el nº de repeticiones con el nº 32 
    JA end 			; En caso de que el nº de repeticiones sea mayor que 32 no imprime nada y se acaba el programa
;Tercera condición    
    MOVB AL, DL		; Pasamos a ALow lo que hay en DLow (la parte baja de la dirección del primer caracter), para no modificar la dirección
    SUBB AL, 0xE0	; Restamos E0 a AL para dejarlo como si fuera decimal (ya que el display empieza en 02'E0')
    ADDB AL, AH 	; Sumamos a AL el nº de repeticiones para saber si se pasa del display
    CMPB AL, 0x20	; Comparamos el nº máximo de posiciones del display (32 en decimal y 0x20 en hexadecimal) con el resultado de la suma
    JA end			; Si se pasa del nº máximo de posiciones no imprime nada y se acaba el programa 

;Si entra en .loop es porque las condiciones se cumplen y se puede imprimir el primer caracter
.loop:
	MOVB BL, [C]	; copiamos en BLow lo que haya en la dirección a la que apunta C 
	MOVB [D], BL	; Escribimos lo que hay en BLow en la posición a la que apunta D (display)
	INC D			; Incrementa la posición del display para imprimir el caracter en la siguiente posicion
    INCB BH 		; Contador en la parte alta de B para controlar las veces que se imprime un caracter
    CMPB BH, AH 	; Comparamos el contador BH con AH para que solo se imprima las veces que se indique en AH
    JNZ .loop 		; Si BH no es igual que AH sigue imprimiendo. Si es, entonces para de imprimir y sigue el programa
	
    MOV C, asciiH 	; Metemos en C la segunda letra que vamos a imprimir (H)
	
    MOVB BH, 0x00 	; Reiniciamos el contador
    
    MOV D, 0x2E6 	; Empezamos a imprimir en la posición 7 del display la siguiente letra (H)
    MOVB AH, 0xC	; Determina el nº de repeticiones de la segunda letra, lo guardamos en AHigh

;Primera condición    
    CMPB AH, 0x00	; Comprueba si el nº de repeticiones es igual a 0 
    JZ end			; En caso de que sea 0 no imprime nada y se acaba el programa
;Segunda condición    
    CMPB AH, 0x20	; Compara el nº de repeticiones con el nº 32 
    JA end 			; En caso de que el nº de repeticiones sea mayor que 32 no imprime nada y se acaba el programa
;Tercera condición    
    MOVB AL, DL		; Pasamos a ALow lo que hay en DLow (la parte baja de la dirección de la primera letra), para no modificar la dirección
    SUBB AL, 0xE0	; Restamos E0 a AL para dejarlo como si fuera decimal (ya que el display empieza en 02'E0')
    ADDB AL, AH 	; Sumamos a AL el nº de repeticiones para saber si se pasa del display
    CMPB AL, 0x20	; Comparamos el nº máximo de posiciones del display (32 en decimal y 0x20 en hexadecimal) con el resultado de la suma
    JA end			; Si se pasa del nº máximo de posiciones no imprime nada y se acaba el programa
    
;Si entra en .loop2 es porque las condiciones se cumplen y se puede imprimir la segunda letra 
.loop2:    
    MOVB BL, [C]	; Copiamos en BLow lo que haya en la dirección a la que apunta C
	MOVB [D], BL	; Escribimos lo que hay en BLow en la posición a la que apunta D (display)
    INC D 			; Incrementa la posición del display para imprimir el caracter en la siguiente posicion
    INCB BH 		; Incrementamos el contador
    CMPB BH, AH 	; Comparamos el contador BH con AH para que solo se imprima las veces que se indique en AH
    JNZ .loop2 		; Si BH no es igual que AH sigue imprimiendo. Si es, entonces para de imprimir y sigue el programa

end: HLT			; Procedimiento al que se llama si se quiere terminar el programa. Se ejecutará también si el programa llega con éxito a su fin