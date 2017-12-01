	.data
create_space: .space 1001
current_string: .space 1001

error: .asciiz "NaN"
sub_p2_test: .asciiz "sub program 2 called"
newline:  .asciiz "\n"

	.text
main:
	li $v0, 8
	la $a0, create_space
	li $a1, 1001
	syscall
	la $s5 create_space
	la $t2, current_string

#	loop to read each character from the input
length_of_input:
	lb $t1, 0($s5)
	beq $t1, 44, call_sub_programs
	beq $t1, 0, call_sub_programs
	beq $t1, 10, call_sub_programs
	j update_state

#	only call sub_programs once ',' or '\n', or '\0' is reached
call_sub_programs:
	sb $zero, 1($t2)
	jal sub_program_2
	beq $t1, 0, exit
	beq $t1, 10, exit
	la $t2, current_string
	j dont_store_byte

#	store each read character in temporary string
update_state:
	sb $t1, 0($t2)
	addi $t2, $t2, 1

#	skip past storing last byte read when beginning new string processing
dont_store_byte:
	addi $s5, $s5, 1
	j length_of_input

#	currently simply prints out hex string read in
sub_program_2:
	li $v0, 4
	la $a0, current_string
	syscall
	la $a0, newline
	syscall
	jr $ra

exit:
	li $v0, 10
	syscall