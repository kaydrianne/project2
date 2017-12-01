	.data
create_space: .space 1001
current_string: .space 1001
clean_string: .space 1001

error: .asciiz "NaN"
error_too_large: .asciiz "too large"
sub_p2_test: .asciiz "sub program 2 called"
newline:  .asciiz "\n"
comma_string: .asciiz ","

	.text
main:
	li $v0, 8
	la $a0, create_space
	li $a1, 1001
	syscall
	add $s5, $zero, $a0
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
	sb $zero, 0($t2)
	j clean_current_string
return_from_cleaning_ok:
	la $a0 clean_string
	jal sub_program_2
return_from_cleaning_not_ok:
	lb $t1, 0($s5)
	beq $t1, 0, exit
	beq $t1, 10, exit
	li $v0, 4
	la $a0, comma_string
	syscall
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

#	validates the spaces arrangements and extracts
#	the hex string into clean_string
clean_current_string:
	la $s0, current_string
	lb $t1, 0($s0)
skip_leading_spaces_and_tabs:
	beq $t1, ',', handle_space_invalid_hex_string
	beq $t1, 10, handle_space_invalid_hex_string
	beq $t1, 0, handle_space_invalid_hex_string
	beq $t1, ' ', skip_space_or_tab
	beq $t1, '	', skip_space_or_tab
	j check_spaces_in_between
skip_space_or_tab:
	addi $s0, $s0, 1
	lb $t1, 0($s0)
	j skip_leading_spaces_and_tabs

check_spaces_in_between:
	# la $s0, current_string
	la $s1, clean_string
	lb $t1, 0($s0)

check_no_space_divide_loop:
	beq $t1, ' ', ensure_no_other_char
	beq $t1, '	', ensure_no_other_char
	beq $t1, ',', deal_with_actual_string
	beq $t1, 0, deal_with_actual_string
	beq $t1, 10, deal_with_actual_string
	sb $t1, 0($s1)
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	lb $t1, 0($s0)
	j check_no_space_divide_loop

ensure_no_other_char:
	beq $t1, 0, deal_with_actual_string
	beq $t1, 10, deal_with_actual_string
	beq $t1, ',', deal_with_actual_string
	beq $t1, ' ', skip_space_or_tab_2
	beq $t1, '	', skip_space_or_tab_2
	j handle_space_invalid_hex_string
skip_space_or_tab_2:
	addi $s0, $s0, 1
	lb $t1, 0($s0)
	j ensure_no_other_char

deal_with_actual_string:
	j return_from_cleaning_ok

handle_space_invalid_hex_string:
	li $v0, 4
	la $a0, error
	syscall
	j return_from_cleaning_not_ok

handle_size_invalid_hex_string:
	li $v0, 4
	la $a0, error_too_large
	syscall
	j return_from_cleaning_not_ok

exit:
	li $v0, 10
	syscall

#	currently simply prints out hex string read in
sub_program_2:
	addi $t3, $a0, 0
#first count string to make sure it is not too large
	li $t9, 0
	lb $t1, 0($t3)
count_loop:
	beq $t1, 0, end_count_loop
	addi $t9, 1
	addi $t3, 1
	lb $t1, 0($t3)
	j count_loop
end_count_loop:
	slti $t9, $t9 9
	beq $t9, 0, handle_size_invalid_hex_string

	addi $t3, $a0, 0		#point to clean_string start again
	lb $t1, 0($t3)

is_ascii_char:
	beq $t1, $zero, sub_program_2_return

	slti $t5, $t1, '0'
	bne $t5, $zero, handle_char_invalid_hex_string

	slti $t5, $t1, 'A'
	slti $t6, $t1, ':'
	bne $t5, $t6, handle_char_invalid_hex_string

	slti $t5, $t1, 'a'
	slti $t6, $t1, 'G'
	bne $t5, $t6, handle_char_invalid_hex_string

	slti $t5, $t1, 'g'
	beq $t5, $zero, handle_char_invalid_hex_string

	add $s7, $ra, $zero
	add $a0, $t1, $zero
	jal sub_program_1
	add $t1, $v0, $zero
	add $ra, $s7, $zero

	li $v0, 1
	addi $a0, $t1, 0
	syscall

	addi $t3, $t3, 1		#point to clean_string start again
	lb $t1, 0($t3)
	j is_ascii_char

sub_program_2_return:
	jr $ra

handle_char_invalid_hex_string:
	li $v0, 4
	la $a0, error
	syscall
	jr $ra

sub_program_1:
	addi $t1, $a0, 0

	slti $t5, $t1, ':'				#	in ascii, digits have values less than :
	bne $t5, $zero, num_conversion

	slti $t5, $t1, 'G'				#	only uppercase characters are A to F
	bne $t5, $zero, upper_case_conversion

	addi $t1, $t1, -87				#	anything else has to be a lower case character
	addi $v0, $t1, 0
	jr $ra

num_conversion:
	addi $t1, $t1, -48
	addi $v0, $t1, 0
	jr $ra

upper_case_conversion:
	addi $t1, $t1, -55
	addi $v0, $t1, 0
	jr $ra