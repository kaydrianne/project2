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

length_of_input:				#Count length of Input
	lb $t1, 0($s5)
	beq $t1, 0, revert
	beq $t1, 10, revert
	addi $s3, $s3, 4
	addi $s5, $s5, 1 
	j length_of_input

