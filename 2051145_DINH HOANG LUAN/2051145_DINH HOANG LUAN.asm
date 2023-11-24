.Orig x3000
;########################################################################
;									#
;	Display a stringz "(Input n string)" on the screen		#
;									#
;########################################################################
		LEA R0, LABEL_1
		PUTS
		LABEL_1	.STRINGZ "(Input n string) \n"

;########################################################################################
;											#
;	Input n (input from keyboard) strings of characters with the length unlimited	#
;			and count the number of strings have been input			#
;											#
;########################################################################################
		LD  R2, MEMORY_1
		AND R3, R3, #0		; Reset R3
		AND R0, R0, #0		; Reset R0
LOOP_1		GETC			; input characters
		ADD R1, R0, #-10
		BRz OUTPUT		; input "enter" to have a new string
		ADD R1, R1, #-15
		ADD R1, R1, #-2
		BRz NEXT_1		; input "esc" to stop 
		OUT
		STR R0, R2, #0		; store characters 
		ADD R2, R2, #1		; increase address 
		BR  LOOP_1
OUTPUT		AND R0, R0 ,#0		; newline
		ADD R0, R0, #13		; newline
		OUT
		STR R1, R2, #0		; store "0" at the end of each strings, started at x5000
		ADD R2, R2, #1		; increase address
		ADD R3, R3, #1		; count the number of strings have been input
		BR  LOOP_1		; loop until meet "esc"
	
NEXT_1		ST  R3, SAVE_1		; store the number of strings have been input
		AND R0, R0 ,#0		; newline
		ADD R0, R0, #13		; newline
		OUT			

;########################################################################################################
;													#
;		Display a stringz "(The redundant of comma and space have been remove)" on the screen	#
;													#
;########################################################################################################
		LEA R0, LABEL_3
	 	PUTS
		LABEL_3	.STRINGZ "(The redundant of comma and space have been remove) \n"
	
;########################################################################################
;											#
;					LABEL						#
;											#
;########################################################################################
		
		SAVE_2		.BLKW #1
			
;########################################################################################
;											#
;	Remove redundant blank comma in each strings and print on the screen		#
;											#
;########################################################################################
		AND R3, R3, #0		; reset R3
		AND R4, R4, #0		; reset R4
		LD R5, SAVE_1		; load number of sequences			
		LD R6, MEMORY_2		; load address started at x6000 
		LD R2, MEMORY_1		; load address started at x5000
LOOP_3		LDR R1, R2, #0		; load memory of R2 to R1			
		ST  R1, SAVE_2		; store the chracter  
		ADD R2, R2, #1		; increase address
		ADD R1, R1, #-15	; check space
		ADD R1, R1, #-15	; check space	
		ADD R1, R1, #-2		; check space
		BRz SPACE		; remove redundant space in each strings
		AND R4, R4, #0		; reset R4 to remove abudant space in the next sequences
		ADD R1, R1, #-12	; check comma
		BRz COMMA		; remove redundant commma in each strings
		AND R3, R3, #0		; reset R3 to remove abudant space in the next sequences
		BR  SAVE 		; store characters after confirm it not redundant comma or redundant space	
	
SPACE		ADD R4, R4, #0		; accept the legal space	
		BRp LOOP_3		
		ADD R4, R4, #1		; a signal to deny redundant space	
		BR  SAVE
		
COMMA		ADD R3, R3, #0		; accept the legal comma
		BRp LOOP_3
		ADD R3, R3, #1		; a signal to deny redundant space
	
SAVE		AND R0, R0, #0
		LD  R1, SAVE_2
		BRz NEXT_2		; if it appear "0" means the sequence has stopped and the next sequence will continue
		ADD R0, R1, #0		; print number of strings have been removed redundant blank and comma
		OUT
		STR R1, R6, #0		; store characters or legal space or legal comma
		ADD R6, R6, #1		; increase the address to store a new characters or legal space or legal comma
		BR  LOOP_3
NEXT_2		AND R0, R0 ,#0		; newline
		ADD R0, R0, #13		; newline
		OUT			; newline
		STR R1, R6, #0		; store again "0"  in the strings
		ADD R6, R6, #1		; increase address	
		ADD R5, R5, #-1		; decrease the number of total strings have been input until it equal to 0
		BRz NEXT_3
		BR  LOOP_3

;################################################################################
;										#
;	Count the characters in each strings after removing space and comma	#
;										#
;################################################################################
NEXT_3		JSR COUNT

;########################################################################################
;											#
;	Splits the first letter of each string and stores the address of that letter	#
;											#
;########################################################################################
		JSR SPLIT

;########################################################################
;									#
;	Sort them in descending or ascending by the order of dictionary	#
;									#
;########################################################################
		AND R0, R0 ,#0	      ; newline
		ADD R0, R0, #13	      ; newline
		OUT		      ; newline

;########################################################################
;									#
;				LABEL					#
;									#
;########################################################################
SAVE_1		.BLKW #1
MEMORY_3	.FILL x7000
SAVE_4		.BLKW #1
MEMORY_2	.FILL x6000
MEMORY_1	.FILL x5000

;########################################################################################################################
;															#
;		Display a stringz "(Select button 0 for descending and select button 1 for ascending)" on the screen	#
;															#
;########################################################################################################################
		LEA R0, LABEL_4
	 	PUTS
		LABEL_4	.STRINGZ "(Select button 0 for descending and select button 1 for ascending) \n"

;########################################################################################################
;													#
;			Input button 0 for descending and select button 1 for ascending			#
;													#
;########################################################################################################
		AND R0, R0, #0
		GETC
		LD  R4, NASCII
		ADD R0, R0, R4
		BRz DECENDING		; if result is zero move to DECENDING

;########################################################################################
;											#
;		Display a stringz "(Ascending the order of dictionary)" on the screen	#
;											#
;########################################################################################	
		LEA R0, LABEL_6
		PUTS
		LABEL_6	.STRINGZ "(Ascending the order of dictionary) \n"

;########################################################################################
;											#
;	Sort the number of strings in ascending the order of dictionary			#
;											#
;########################################################################################
		JSR MIN

;########################################################################################################
;													#
;	Print numbers of strings have been sorted following ascending the order of dictionary		#	
;													#
;########################################################################################################
		AND R0, R0, #0
		ADD R0, R0, #13
		OUT
		LD R3, SAVE_1		; load number of sequences
		LD  R1, MEMORY_5	; load address of first letter of each strings
LOOP_8		LDR R2, R1, #0		; load first letter of each strings
		ADD R0, R2, #0		; print on screen
		PUTS				
		AND R0, R0, #0		; newline
		ADD R0, R0, #13		; newline
		OUT
		AND R0, R0, #0
		ADD R1, R1, #1		; increase address to take the next letter of strings
		ADD R3, R3, #-1		; decrement the number of sequences
		BRp LOOP_8		; if result is positive mean the number of strings is stil loop
		BR  STOP		; stop the program

;########################################################################################
;											#
;		Display a stringz "(Descending the order of dictionary)" on the screen	#
;											#
;########################################################################################
DECENDING 	LEA R0, LABEL_5
		PUTS
		LABEL_5	.STRINGZ "(Descending the order of dictionary) \n"

;########################################################################################
;											#
;	Sort the number of strings in descending the order of dictionary		#
;											#
;########################################################################################
		JSR MAX

;########################################################################################################
;													#
;	Print numbers of strings have been sorted following desending the order of dictionary		#	
;													#
;########################################################################################################
		AND R0, R0, #0		; newline
		ADD R0, R0, #13		; newline
		OUT
		LD  R3, SAVE_1		; load number of sequences
		LD  R1, MEMORY_5	; load address of first letter of each strings
LOOP_9		LDR R2, R1, #0		; load first letter of each strings
		ADD R0, R2, #0		; print on screen
		PUTS
		AND R0, R0, #0		; newline
		ADD R0, R0, #13		; newline
		OUT	
		AND R0, R0, #0			
		ADD R1, R1, #1		; increase address to take the next letter of strings
		ADD R3, R3, #-1		; decrement the number of sequences
		BRp LOOP_9		; if result is positive mean the number of strings is stil loop
STOP		HALT			; stop the program


;*********************************************************************************************************
;*********************************************************************************************************
;*********************************************************************************************************

COUNT		LD  R1, MEMORY_2	; load character of each strings have been removed comma and space
		LD  R3, SAVE_1		; load the number of strings	
		LD  R5, MEMORY_3	; prepare the address to store number of characters of each strings after being removed comma and space	
LOOP_5		AND R4, R4, #0			
LOOP_4		LDR R2, R1, #0		; load characters from Memory_3
		ADD R2, R2, #0		
		BRz NEXT_4		; if R2 = "0" it means that is the end of the strings and move to the next strings
		ADD R4, R4, #1		; count the characters
		ADD R1, R1, #1		; increase address to load next characters
		BR  LOOP_4
NEXT_4		STR R4, R5, #0		; store number characters of each strings in location x7000
		ADD R5, R5, #1		; increase address to store characters	       
		ADD R1, R1, #1		; increase address to load next characters
		ADD R3, R3, #-1		; decrease total of strings have been input
		BRp LOOP_5		; if R3 still positive it continue
		RET

;########################################################################################################
SPLIT		LD  R1, MEMORY_2	; number characters of strings are stored in location x6000	
		LD  R2, MEMORY_3	; number characters of each strings are stored in location x7000 
		LD  R3, SAVE_1		; load number of strings
		LD  R6, MEMORY_5	; prepare the address to store address of first letter of each strings
		
LOOP_7		ADD R3, R3, #-1		; decrease number of strings
		BRn NEXT_6		; until it negative
		LDR R4, R1, #0		; load characters   
		ST  R1, SAVE_4		; store address of first letter of each strings
		LDR R5, R2, #0		; load number of characters of each strings
LOOP_6		ADD R1, R1, #1		; increase address	
		ADD R5, R5, #-1		; decrease number of characters
		BRp LOOP_6		; it positive then continue to count
		LD  R5, SAVE_4		; if it negative it means that the next string has appeared, then load address of first letter of each strings again
		ADD R1, R1, #1		; increase address 
		STR R5, R6, #0          ; store the first letter of each string in location x9000
		ADD R6, R6, #1		; increase the location to store new address of first letter	
		ADD R2, R2, #1		; continue increase the address of number characters of each strings	
		BR LOOP_7
NEXT_6		RET

;########################################################################################################
MIN		LD  R4, SAVE_1		; load number of strings	
OUTER		ADD R4, R4, #-1		; loop n - 1 times
		BRnz NEXT_5		; looping complete, exit
		ADD R6, R4, #0		; initialize inner loop counter to outer
		LD  R1, MEMORY_5	; set file pointer to begin of file
INNER		LDR R2, R1, #0		; load address contain address of first letter of strings
		LDR R0, R2, #0		; load the first letter	
		LDR R3, R1, #1		; load address contain address of first letter of the next strings
		LDR R5, R3, #0		; load the first letter of the next strings
		ST  R5, SAVE_5
		NOT R5, R5		; compare two first letter
		ADD R5, R5, #1
		ADD R5, R0, R5
		BRnz SWAP		; if the result positive change the address of two first letter
		LD  R5, SAVE_5
		STR R3, R1, #0
		STR R2, R1, #1
SWAP		LD  R5, SAVE_5
		ADD R1, R1, #1		; increment file pointer
		ADD R6, R6, #-1		; decrement inner loop
		BRp INNER		; end of inner loop
		BR  OUTER		; end of outer loop
NEXT_5		RET

;########################################################################################################
MAX		LD  R4, SAVE_1	 	; load number of strings	
OUTER_1		ADD R4, R4, #-1 	; loop n - 1 times
		BRnz NEXT_7	 	; looping complete, exit
		ADD R6, R4, #0   	; initialize inner loop counter to outer	
		LD  R1, MEMORY_5 	; set file pointer to begin of file
INNER_1		LDR R2, R1, #0	 	; load address contain address of first letter of strings
		LDR R0, R2, #0   	; load the first letter
		LDR R3, R1, #1  	; load address contain address of first letter of the next strings
		LDR R5, R3, #0   	; load the first letter of the next strings
		ST  R5, SAVE_5
		NOT R5, R5	 	; compare two first letter
		ADD R5, R5, #1
		ADD R5, R0, R5
		BRp SWAP_1	 	; if the result negative change the address of two first letter
		LD  R5, SAVE_5
		STR R3, R1, #0
		STR R2, R1, #1
SWAP_1		LD R5, SAVE_5
		ADD R1, R1, #1		; increment file pointer
		ADD R6, R6, #-1		; decrement inner loop counter
		BRp INNER_1		; end of inner loop
		BR  OUTER_1		; end of outer loop
NEXT_7		RET


;########################################################################################################
;													#
;						LABEL							#
;													#
;########################################################################################################

MEMORY_5	.FILL x9000	
NASCII		.FILL #-48
SAVE_3		.BLKW #1
SAVE_5		.BLKW #1
.End	