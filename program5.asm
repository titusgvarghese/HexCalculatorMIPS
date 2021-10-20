# File Name: program5.asm
# Author: Titus Varghese
# Modification History
# This code was downloaded on 11 November 2019. 
# Procedures:
  # main: Prompts the user to input a file address, opens the file, reads the contents, converts the value to decimal value 
  #       and writes it out to the console in a fixed format
  # newLine: Loops through the contents of the file until the end
  # convertValues: Function to convert the operations within the file and prints them to the screen

.data
    # The first prompt for the user
    prompt: .asciiz "Please enter the file name: "
    # The savePrompt label that holds the Save: string
    savePrompt: .asciiz "Save: "
    # The readPrompt label that holds the Read: string
    readPrompt: .asciiz "Read: "
    # The input label that holds the Input: string
    input: .asciiz "Input: "
    # The result label that holds the Result: string
    result: .asciiz "Result: "
    # The equalSign label that holds the = string
    equalSign: .asciiz " = "
    # The resultAdd label that holds the Input: + string
    resultAdd: .asciiz "Input: +"
    # The resultSub label that holds the Input: - string
    resultSub: .asciiz "Input: -"
    # The resultMult label that holds the Input: * string
    resultMult: .asciiz "Input: *"
    # The resultDiv label that holds the Input: / string
    resultDiv: .asciiz "Input: /"
    # The resultMod label that holds the Input: % string
    resultMod: .asciiz "Input: %"
    # The resultR label that holds the Input: r string
    resultR: .asciiz "Input: r"
    # The resultC label that holds the Input: z string
    resultC: .asciiz "Input: z"
    # Specifies the amount of text allocated for the user's input
    FileName: .space 200 		# reserving space for file
    # Specifies the amount of text allocated for the file
    FileContents: .space 200  	# reserve space for file contents
    #s7 register saves the result of single number 
    #s6 register saves the total result of calculation accumulated throught
    #s5 register saves the register
    #t8 register will keep track of which operation
    
.text
    main: 
    #display prompt and get file name
    li $v0, 4 			# specify Print String service system call code
    la $a0, prompt	 		# load address of prompt
    syscall 			# print prompt
    
    # Getting user's file as input
    li $v0, 8 			# specify Print String service with String System call code
    la $a0, FileName 		# allocate space for the FileName String
    li $a1, 200 			# 200 bytes of memory allocated for string
    add $s3, $a0, $zero 		# move $a0 + 0 into $s3
    
    syscall 			# read user's string input
    jal newLine 			# call the newLine procedure
    
    # Opens the file
    li $v0, 13 			# specify open file System call code
    move $a0, $s3 			# puts the file name into $a0 register
    li $a1, 0 			# opens file for reading
    li $a2, 0 			# mode
    syscall				# opens the file
    move $s0, $v0 			# saves file descriptor in $s0 register
    
    # Reads the FileContents
    li $v0, 14 			# specify read file System call code
    move $a0, $s0 			# move file descriptor to the $a0 register
    la $a1, FileContents 		# loads FileContents space
    li $a2 100 			# sets length of FileContents
    syscall 			# read FileContents
    
    # Closes the file
    li $v0, 16 			# specify close file System call code
    move $a0, $s0 			# load descriptor into the $a0 register
    syscall 			# closes the file
    
    # Converts the hexadecimal values within the FileContents
    la $a0, FileContents 		# places address of FileContents in $a0 register
    jal convertValues		# jumps to the convertValues function
    
    # Tells the system this is the end of main
    li $v0, 10 			# specify exit System call code
    syscall				# ends main
  
# newLine:
# Author: Titus Varghese
# Modification History
# This code was downloaded on 11 November 2019. 
# Description: Loops through the contents of the file until the end
# Arguments: None
	newLine:			# calls newLine function
	li $t0, 0 			# sets the loop counter
	li $t1, 100 			# informs the function where to stop (100 bytes of space)
  
	# Calls loop
	loop:
	beq $t0, $t1, leave 		# exit loop if counter is equal to the last point in the file
	lb $t2, FileName($t0) 		# store the nth char in FileName into $t2
	bne $t2, 0x0a, repeat 		# repeat loop till 0x0a is found
	sb $zero, FileName($t0) 	# replace the last character in FileName with a 0
  
	# Calls repeat
	repeat:
	addi $t0, $t0, 1 		# increment loop counter
	j loop 				# return to top of loop
  
	# Calls leave
	leave:
	jr $ra 				# return control to Main function
  
# convertValues:
# Author: Titus Varghese
# Modification History
# This code was downloaded on 11 November 2019.
# Description: Function to convert the operations within the file and prints them to the screen
# Arguments: $a0 (FileContents)
	convertValues:			# calls convertValues function
	# The outter loop exits when null terminator is reached
	add $s6, $zero, $zero 		# the $s6 register will accumulate the total, which is initalized to a value of zero
	add $s0, $a0, $zero 		# stores contents of $a0 into $s0
	add $s7, $zero, $zero 		# the $s7 register will accumulate the total, which is initalized to a value of zero
	# Jumps to the getFirstOperand operation
	j getFirstOperand
  
	# Calls Loop
	Loop:
	# Expects an operator
	# Expects an operand
	# If the null terminator is reached, An exit is prompted
  
	# Calls getOperator
	getOperator:
	lb $t1, 0($s0) 			# saves character value into $t1 register
	beq $t1, $zero, end 		# exits when character value is equal to null (End of String)
  
	# Determines which operation is called
	li $t6, '+' 			# compares $t6 register to check if it is addition
	beq $t1, $t6, isAdd		# calls isAdd function when + is found
	li $t6, '-' 			# compares $t6 register to check if it is subtraction
	beq $t1, $t6, isSub		# calls isSub function when - is found
	li $t6, '*' 			# compares $t6 register to check if it is multiplication
	beq $t1, $t6, isMult		# calls isMult function when * is found
	li $t6, '/' 			# compares $t6 register to check if it is division
	beq $t1, $t6, isDiv		# calls isDiv function when / is found
	li $t6, '%' 			# compares $t6 register to check if it is modulus
	beq $t1, $t6, isMod		# calls isMod function when % is found
	li $t6, '=' 			# compares $t6 register to check if it is equals
	beq $t1, $t6, isEquals		# calls isEquals function when = is found	
  
	# Calls isAdd
	isAdd:
	addi, $t8, $zero, 1 		# sets $t8 register to 1 for addition
	la $a0, resultAdd 		# load address of resultAdd
	li $v0, 4 			# specify Print String service system call code
	syscall				# exits isAdd operation
	j operatorFound			# jumps to the operatorFound operation
  
	# Calls isSub
	isSub:
	addi, $t8, $zero, 2 		# sets $t8 register to 2 for subtraction
	la $a0, resultSub 		# load address of resultSub
	li $v0, 4 			# specify Print String service system call code
	syscall				# exits isSub operation
	j operatorFound			# jumps to the operatorFound operation
  
	# Calls isMult
	isMult:
	addi, $t8, $zero, 3 		# sets $t8 register to 3 for multiplication
	la $a0, resultMult 		# load address of resultMult
	li $v0, 4 			# specify Print String service system call code
	syscall				# exits isMult operation
	j operatorFound			# jumps to the operatorFound operation
  
	# Calls isDiv
	isDiv:
	addi, $t8, $zero, 4 		# sets $t8 register to 4 for division
	la $a0, resultDiv 		# load address of resultMod
	li $v0, 4 			# specify Print String service system call code
	syscall				# exits isDiv operation
	j operatorFound			# jumps to the operatorFound operation
  
	# Calls isMod
	isMod:
	addi, $t8, $zero, 5 		# sets $t8 register to 5 for modulo
	la $a0, resultMod 		# load address of resultMod
	li $v0, 4 			# specify Print String service system call code
	syscall				# exits isMod operation
	j operatorFound			# jumps to the operatorFound operation
  
	# Calls isEquals
	isEquals:
	addi, $t8, $zero, 6 		# sets $t8 register to 6 for equal sign
	addi $s0, $s0, 1 		# increment index
  
	# Next char is either a newline or a null, if null, prompts exit
	lb $t1, 0($s0) 			# next char in t1
	beq $t1, $zero, end		# exits when character value is equal to null (End of String)
  
	# Program reaches this line if a newline is found
	addi $s0, $s0, 1 		# increment index value
	j equals			# jump to the equals operation
	
	# Calls operatorFound
	operatorFound:
	# Print newline
	li $v0, 11 			# specify Print character service
	addi $a0, $zero, 0xA 		# loads new line into $a0 register
	syscall 			# prints new line
	addi $s0, $s0, 1 		# increment the index value
	# Next char is either a newline or a null. If newline, get operand value
	lb $t1, 0($s0) 			# saves character value into $t1 register
	beq $t1, $zero, end		# exits when character value is equal to null (End of String)
	# Program reaches this line if a newline is found. Gets the operand value
	addi $s0, $s0, 2 		# increment the index value
	
	# Calls operandSearch
	operandSearch:
	lb $t1, 0($s0) 			# saves character value into $t1 register
	beq $t1, $zero, end 		# exits when character value is equal to null (End of String)
	li $t9, '\n' 			# places newline in $t9 to compare
	beq $t1, $t9, operandFound 	# calls displayAndLoop function when newline is found
	
	li $t9, 'r'			# loads a ascii value of 'r' into the $t9 register
	bne $t1, $t9, notR

	add $s7, $s5, $zero		# adds values to $s7 register
	la $a0, resultR 		# load address of resultR
	li $v0, 4			# specify Print String service system call code
	syscall 			# print input: r

	li $v0, 11 			# specify print char call
	addi $a0, $zero, 0xA 		# loads a newline into the $a0 register
	syscall 			# prints the new line
	la $a0, readPrompt 		# prints the readPrompt string
	li $v0 4			# specify Print String service system call code
	syscall				# print readPrompt
	la $a0, 0($s5)			# loads the result into the $a0 register
	li $v0, 1			# specify Print integer service
	syscall 			# print value in save register
	li $v0, 11 			# specify Print character service
	addi $a0, $zero, 0xA 		# loads new line into $a0 register
	syscall 			# prints the new line
	addi $s0, $s0, 2 		# increments the index value
	j printValues 			# jump to the printValues operation
	
	# calls notR
	notR:
	# Checks the type of character, If new line or null --> does not read
	# Checks if the value is valid
	li $t6, '0' 			# loads a ascii value of 0 into the $t6 register
	bltu $t1, $t6, invalidValue	# branches to invalidValue if character value is less than 0
	li $t6, '9' 			# loads a ascii value of 9 into the $t6 register
	bltu $t6, $t1, notIntegerValue 	# branches to notIntegerValue if 9 is less than character value
	# Character is a integer
	addi $t2, $t1, -48 		# the $t2 register contains the numeric value that is represented by the corresponding character
	j addValue 			# jump to the addvalue operation
	
	# Program reaches here if the character value is not an integer
	# Calls notInteger
	notIntegerValue:
	# Check if the value is a capital letter between A and F
	li $t6, 'A' 			# loads ascii of 'A' 
	bltu $t1, $t6, invalidValue 	# sets branch to invalid if char is less than 'A'
	li $t6, 'F' 			# loads ascii of 'F'
	bltu $t6, $t1, notUpperCase 	# not an uppercase letter
	# Character is a valid uppercase letter
	addi $t2, $t1, -55 		# the $t2 register now contains the numeric value that is represented by the corresponding character
	j addValue 			# jump to the addvalue operation
	
	# Calls notUpperCase
	notUpperCase:			# check if value is lowercase letter between 'a' and 'f'
	li $t6, 'a' 			# loads ascii of 'a'
	bltu $t1, $t6, invalidValue 	# invalid if character value is less than 'a'
	li $t6, 'f' 			# loads the ascii value of 'f'
	bltu $t6, $t1, invalidValue 	# invalid if f is less than character value
  
	# Character is a valid lowercase letter
	addi $t2, $t1, -87 		# the $t2 register now contains the numeric value that is represented by the corresponding character
	j addValue 			# jump to the addvalue operation
	# Calls getOperand
	# Program will jump here when it is ready to add the value onto the total number
	
	# Calls addValue
	addValue:
	# The $t2 register contains the numeric value that should be added to total
	# The $s7 register accumulates the total
	sll $s7, $s7, 4 		# shifts current total to the left by 4
	add $s7, $s7, $t2 		# adds $t2 register value to the total
	addi $s0, $s0, 1 		# increments the index by value of 1
	j operandSearch 		# top of loop
	
	# Calls invalidValue
	invalidValue:
	# Just increment index, continue loop
	addi $s0, $s0, 1
	j operandSearch
	
	# Calls getOperand
	operandFound:
	# Prints the value in decimal and goes to the getOperator
	la $a0, input			# load address of input
	li $v0, 4 			# specify Print String service system call code
	syscall 			# prints "Input: " string
	# The $s7 register contains the value that should be printed
	la $a0, 0($s7) 			# loads the result into $a0 register
	li $v0, 1 			# specify Print integer service
	syscall 			# prints the result value
	# Print newline
	li $v0, 11 			# specify Print character service
	addi $a0, $zero, 0xA 		# loads new line into the $a0 register
	syscall 			# prints a new line
	# Print result of calculation
	#-------s7 - result of single number 
	#-------s6 - total result of calculation accumulated throught
	#-------t8 - which operation
	
	# Calls printValues
	printValues:
	# Prints the result which is in the $s6 register
	la $a0, result			# load address of result
	li $v0, 4			# specify Print String service system call code
	syscall 			# prints the result value
	li $v0, 1			# specify Print integer service
	la $a0, 0($s6)			# loads the result into the $a0 register
	syscall 			# print value before calculation
	beq $t8, 1, addition		# calls addition function when '1' is found
	beq $t8, 2, subtraction		# calls subtraction function when '2' is found
	beq $t8, 3, multiplication	# calls multiplication function when '3' is found
	beq $t8, 4, division		# calls division function when '4' is found
	beq $t8, 5, modulo		# calls modulo function when '5' is found
	beq $t8, 6, equals		# calls equals function when '6' is found
	

	# Calls operandFoundContinued
	operandFoundContinued:
	# Prints equals $s6 register
	li $v0, 4			# specify Print String service system call code
	la $a0, equalSign		# load address of equalSign
	syscall 			# print equal sign
	li $v0, 1			# specify Print integer service
	la $a0, 0($s6)			# loads the result into $a0 register
	syscall 			# prints the result value
	# Prints the new line
	li $v0, 11 			# specify Print character service
	addi $a0, $zero, 0xA 		# loads new line into $a0 register
	syscall 			# prints the new line
	add $s7, $zero, $zero 		# resets $s7 register to a value of zero
	addi $s0, $s0, 1 		# increment the index value
	j Loop				# loops through again
	
	# Calls addition
	addition:
	add $s6, $s6, $s7 		# total result = result so far + operand
	li $v0, 11			# specify Print character service
	la $a0, '+'			# load address of '+'
	syscall 			# prints addition sign
	li $v0, 1			# specify Print integer service
	la $a0, 0($s7)			# loads the result into $a0 register
	syscall 			# prints the operand value
	j operandFoundContinued		# jumps to the operandFoundContinued operation
	
	# Calls subtraction
	subtraction:
	sub $s6, $s6, $s7 		# result = result - operand
	li $v0, 11			# specify Print character service
	la $a0, '-'			# load address of '-'
	syscall 			# prints the minus sign
	li $v0, 1			# specify Print integer service
	la $a0, 0($s7)			# loads the result into $a0 register
	syscall 			# prints the operand value
	j operandFoundContinued		# jumps to the operandFoundContinued function
	
	# Calls multiplication
	multiplication:
	mult $s6, $s7 			# multiplies operands
	mflo $s6 			# move result into s6
	li $v0, 11			# specify Print character service
	la $a0, '*'			# load address of '*'
	syscall 			# prints the multiplication sign
	li $v0, 1			# specify Print integer service
	la $a0, 0($s7)			# loads the result into $a0 register
	syscall				# prints the operand value
	j operandFoundContinued		# jump to the continueEquals operation
	
	# Calls division
	division:
	div $s6, $s6, $s7 		# result = result / operand
	li $v0, 11			# specify Print character service
	la $a0, '/'			# load address of '/'
	syscall 			# prints the division sign
	li $v0, 1			# specify Print integer service
	la $a0, 0($s7)			# loads the result into $a0 register
	syscall 			# prints the operand value
	j operandFoundContinued		# jumps to the operandFoundContinued function
	
	# Calls modulo
	modulo:
	div $s6, $s6, $s7 		# perform the division
	mfhi $s6 			# moves the remainder into the $s6 register
	li $v0, 11			# specify Print character service
	la $a0, '%'			# load address of '%'
	syscall 			# prints a modulus sign
	li $v0, 1			# specify Print integer service
	la $a0, 0($s7)			# loads the result into $a0 register
	syscall 			# prints the operand value
	j operandFoundContinued		# jumps to the operandFoundContinued function
	
	# Calls equals
	equals:
	addi $s0, $s0, 1 		# increment the index value
	#check if this value should be saved before clearing it
	lb $t1, 0($s0) 			# saves character value into the $t1 register
	li $t9, 's' 			# loads the value for 's'
	beq $t1, $t9, saveValue 	# saves the result if the saveValue operation is called
	#check if memory should be cleared
	li $t9, 'z' 			# loads the value for 'z'
	beq $t1, $t9, clearMemory 	# clears memory if clearMem operation is called
	# Calls continueEquals 
	continueEquals:
	add $s6, $zero, $zero 		# resets the result register to a value of zero
	add $s7, $zero, $zero 		# resets $s7 register value to zero
	j getFirstOperand 		# restart the process, get first operand
  
	# Calls end 
	end:
	jr $ra				# return control to Main function
  
	# Calls firstNotInteger
	firstNotInteger:
	# Check if the value is a capital letter between A and F
	li $t6, 'A' 			# load ascii of 'A' 
	bltu $t1, $t6, firstInvalidValue # branch to invalid if char is less than 'A'
	li $t6, 'F' 			# load ascii of 'F'
	bltu $t6, $t1, firstNotUpperCase # not an uppercase letter
	# If this line reached, char is uppercase valid letter. Process it as such
	addi $t2, $t1, -55 		# $t2 now contains the numeric value that is represented by the char
	j firstAddValue 		# jump to where the operation will proceed
  
	# Calls getFirstOperand
	getFirstOperand:
	lb $t1, 0($s0) 			# saves character value into $t1 register
	li $t9, '\n' 			# places newline in $t9 to compare
	beq $t1, $t9, firstOperandFound# calls displayAndLoop function when newline is found
  
	# Checks the type of character, If new line or null --> does not read
	# Checks if the value is valid
	li $t6, '0' 			# load ascii val of 0 into $t6
	bltu $t1, $t6, firstInvalidValue 	# branch to invalid if char is less than 0
	li $t6, '9' 			# load ascii val of 9 into $t6
	bltu $t6, $t1, firstNotInteger # branch to notInteger if '9' is less than char
  
	# Character is a integer
	addi $t2, $t1, -48 		# $t2 now contains the numeric value that is represented by the char
	j firstAddValue 		# jump to the addvalue operation
	
	# Calls firstNotUpperCase
	firstNotUpperCase:
	# Check if it's a lowercase letter between a and f
	li $t6, 'a' 			  # loads the ascii value of 'a'
	bltu $t1, $t6, firstInvalidValue # invalid if character value is less than a
	li $t6, 'f' 			  # loads the ascii value of 'f'
	bltu $t6, $t1, firstInvalidValue # invalid if 'f' is less than char
  
	# Character is a valid lowercase letter
	addi $t2, $t1, -87 		# the $t2 register now contains the numeric value that is represented by the corresponding character
	j firstAddValue 		# jump to the addvalue operation
	
	# Calls firstInvalid
	firstInvalidValue:		# checks if the character is the first invalid value
	# Just increment index, continue loop
	addi $s0, $s0, 1		# increment the index value
	j getFirstOperand		# jumps to getFirstOperand operation
	
	# Calls firstAddValue
	firstAddValue:			# program jumps here to add the value to the total number
	# $t2 register contains the numeric value that should be added to total
	# $s7 register accumulates total
	sll $s7, $s7, 4 		# shifts current total to the left by 44
	add $s7, $s7, $t2 		# adds $t2 register value to the total
	addi $s0, $s0, 1 		# increments the index by value of 1
	j getFirstOperand 		# jumps to getFirstOperand operation
	
	# Calls saveValue
	saveValue:
	add $s5, $s6, $zero 		# save s6 to save register
  
	# Prints
	la $a0, savePrompt		# load address of savePrompt
	li $v0, 4 			# print string call
	syscall 			# prints the "Save: "
  
	# Print the contents of save
	la $a0, 0($s5)
	li $v0, 1 			# specify Print integer service
	syscall 			# prints the saved value
  
	# Prints the newline
	li $v0, 11 			# specify Print character service
	addi $a0, $zero, 0xA 		# loads new line into $a0 register
	syscall 			# prints new line
	addi $s0, $s0, 3 		# increment the index value
	j continueEquals		# jumps to continueEquals operation
  
	# Calls clearMemory
	clearMemory:
	add $s5, $zero, $zero 		# sets the save register to a value of zero
	# Prints the result
	la $a0, resultC			# load address of resultC
	li $v0, 4			# specify Print String service system call code
	syscall 			# prints the "Result: r"
  
	# Prints the newline
	li $v0, 11 			# specify Print character service
	addi $a0, $zero, 0xA 		# loads new line into $a0 register
	syscall 			# prints new line
	addi $s0, $s0, 3 		# increment the index value
	j continueEquals		# jumps to the continueEquals operation
  
	# Calls firstOperandFound
	firstOperandFound:		# Prints the value in decimal and go to getOperator
	# Sets the total result to first operand
	add $s6, $s7, $zero		# resets the $s6 register to value of zero
	la $a0, input			# loads address of input
	li $v0, 4 			# specify Print String service system call code
	syscall 			# print input value
  
	# The $s7 register contains the value that should be printed
	la $a0, 0($s7) 			# loads the result into $a0 register
	li $v0, 1 			# specify Print integer service
	syscall 			# prints the result value
  
	# Prints the new line
	li $v0, 11 			# specify Print character service
	addi $a0, $zero, 0xA 		# loads new line into $a0 register
	syscall 			# prints new line
	add $s7, $zero, $zero 		# reset $s7 to value of 0
	addi $s0, $s0, 1 		# increment the index value
  
	# Starts the loop
	j Loop				# loops through again
