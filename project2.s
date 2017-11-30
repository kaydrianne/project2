.data
	create_space: .space 1001	#Create space for 1000 characters and NULL
	error: .asciiz "NaN"		#not a number string 				
	newline: .asciiz "\n"							


.text	
main:
	li $v0, 8				#Syscall for v0 = 8 is Read String
	la $t0, create_space	#Create Space in $t0
	la $a0, 0($t0)			#Loads Input into Argument
	la $a1, 1001				#Loads Length of Input
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

revert:					#To revert back to last position in Input, rather than /n or NULL
	addi $s3, $s3, -4
	
subprogram1(char, position): 	#converts a single hexadecimal character to a decimal integer

# {
# 	if (position == 1)		
# 	{
# 		return hex_value
# 	}
# if (char is valid hex)
# {
# 	return hex_value shifted by shift_amount
# 	#value  shifted left by (position - 1) * 4
# }
# else
# {
# 		return “NaN”
# 	}

# }


subprogram2(arr, i, j):	# call Subprogram 1 to get the decimal value of each of the characters in the string
# {
# 	shift_position = j - i		#gets length of string
# sum = 0
# 	if (shift_position > 8)	#when more than 32 bits it is too large
# 	{
# 		return “Too large”
# 	}
# 	while (i < j):
# 		sum += SubProg1(arr[i], shift_position)	#increments sum
# 		if (sum is “NaN”)
# 		{
# 			return “NaN”
# 		}
# 		i++				
# 		shift_position--
# 	return sum
# }

				
				
subprogram3:	#displays an unsigned decimal integer. The stack must be used to pass parameters into the subprogram. No values are returned
#print