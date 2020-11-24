.data
getInput: .asciiz "Enter Upper Bound of X: "
outer: .asciiz "In the outer loop "
inner: .asciiz "In the inner loop "
newLine: .asciiz "\n"
tab: .asciiz "      "	
firstLine: .asciiz "x      y     x^2    2y^2\n"

.text

.globl main

main:
	addi $s2, $zero, 2
	
        li $v0, 4
        la $a0, getInput
        syscall
        
        li $v0, 5
        syscall
        
        add $a0, $v0, $0
        
        jal compare
     
        li $v0, 10
        syscall
     
compare:
	addi $t0, $a0, 0	# $t0 = max x
	addi $t1, $zero, 1	# $t1 = x counter = i
	
	li $v0, 4
        la $a0, firstLine
        syscall
	
	Loop1:
	bgt $t1, $t0, EndLoop1		# End Loop if i > x
	addi $t2, $zero, 1		# $t2 = y counter = j
		Loop2:
			bgt $t2, $t1, EndLoop2		# End loop if j > i
		
			mult $t1, $t1			# Square i
			mflo $t3			# $t3 = x^2
		
			mult $t2, $t2			# Square j
			mflo $t4			
			mult $t4, $s2
			mflo $t5			# $t5 = 2y^2
		
			sub $t6, $t5, $t3		# $t6 = 2y^2 - x^2
			beq $t6, 1, Print		# 2y^2 - x^2 = 1 so we have a match
			beq $t6, -1, Print		# 2y^2 - x^2 = -1 so we have a match
			b Increment			# No match so just increment
		
			Increment:
			addi $t2, $t2, 1
			b Loop2
		
		EndLoop2:
		add, $t1, $t1, 1	# increment i
		b Loop1			# jump to the start of loop 1
	EndLoop1:
	jr $ra		#return
        

	Print:
	move $a0, $t1		# print x
	li $v0, 1
	syscall
		
	li $v0, 4		# print tab
	la $a0, tab
	syscall
		
	move $a0, $t2		# print y
	li $v0, 1	
	syscall
	
	li $v0, 4		# print tab
	la $a0, tab
	syscall
		
	move $a0, $t3		# print x^2
	li $v0, 1
	syscall
		
	li $v0, 4		# print tab
	la $a0, tab
	syscall
		
	move $a0, $t5		# print 2y^2
	li $v0, 1
	syscall
		
	li $v0, 4		# print newline
	la $a0, newLine
	syscall
	
	b Increment
	
