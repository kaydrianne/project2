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