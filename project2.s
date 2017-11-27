.data
	create_space: .space 9 							#Create space for 8 characters and NULL
	error: .asciiz "Invalid hexadecimal number."	#Output to be printed on invalid input
	newline: .asciiz "\n"							


.text
main:
	li $v0, 8				#Syscall for v0 = 8 is Read String
	la $t0, create_space	#Create Space in $t0
	la $a0, 0($t0)			#Loads Input into Argument
	la $a1, 9				#Loads Length of Input
	syscall 				#Calls syscall 8 - Read String

	addi $t7, $t0, 8		#Move 9th byte of Input to Register
	addi $s5, $t0, 0		#Move input to Register
	add $s3, $zero, $zero   #Intialize Register to Zero

#main program must call Subprogram 2 for conversion and call Subprogram 3 for output.

length_of_input:				#Count length of Input
	lb $t1, 0($s5)
	beq $t1, 0, revert
	beq $t1, 10, revert
	addi $s3, $s3, 4
	addi $s5, $s5, 1 
	j length_of_input

revert:					#To revert back to last position in Input, rather than /n or NULL
	addi $s3, $s3, -4

subprogram1: 	#converts a single hexadecimal character to a decimal integer

subprogram2:	# call Subprogram 1 to get the decimal value of each of the characters in the string
				#Values must be returned via the stack
				
subprogram3:	#displays an unsigned decimal integer. The stack must be used to pass parameters into the subprogram. No values are returned
