.data 
input: .asciiz "Enter # of terms in the sequence: "
newLine: .asciiz "\n"
comma:	.asciiz ", "
.text

main:
	addi, $s1, $zero, 1
	addi, $s2, $zero, 2

	li $v0, 4
        la $a0, input
        syscall
        
        li $v0, 5
        syscall
        
        # $s0 = size
        addi $s0, $v0, 0	
        
        #allocate space
        sll $a0, $s0, 2 	#number of bytes now in $a0
        li  $v0 9
        syscall 
        
        addi $s5, $v0, 0	# $s5 holds the address of the array
        
        la $t0, ($s5)		# $t0 = array
        
        # $t2 = array index
        addi $t2, $zero, 0 
        
        # $t3 = offset
        mul $t3, $t2, 4 
        
        # $t4 = index to be added at
        add $t4, $t3, $t0
         #$t5 = value to be added to array
        add $t5, $zero, $s1
        
        # store element
        sw $t5, ($t4)
        
        # $t2 = array index
        addi $t2, $zero, 1 
        
        # $t3 = offset
        mul $t3, $t2, 4 
        
        # $t4 = index to be added at
        add $t4, $t3, $t0
        add $t5, $zero, $s2
        
        # store element
        sw $t5, ($t4)
        
        # !!!!!!!! Array is [1,2] at this point!!!!!!!!!!!!!
        
        jal isSum
        		
        move $t2, $0
        la $t0, ($s5)		# reset arr address
        addi $t9, $0, 0 	# counter for printing a break
        jal print
     
        li $v0, 10
        syscall
        
isSum:
	addi $t2, $t2, 1	# Set the index for the array to add to 2.
	addi $t1, $t1, 2	# $t1 is the currentSize of the array
        addi $t6, $0, 3		# $t6 is the currentNumber
        addi $t7, $0, 0		# $t7 is the amount of matches
        
        addi $t8, $zero, 0	# init i
        
        #while we have not found the amount of terms
        while:
        	Loop1:
        	addi $t9, $t8, 1	# init j. j = i + 1
        	slt $t2, $t9, $t1	
        	bne $t2, $0, Loop2	#continue if j is not the current size
        	j CheckLoop1
        	
        		Loop2:
        		la $t0, ($s5)
        		mul $t3, $t9, 4 	# offset for j
        		add $t0, $t0, $t3
        		lw $t4, 0($t0)		# $t4 = arr[i]
        		
        		la $t0, ($s5)
        		mul $t3, $t8, 4 	# offset for i
        		add $t0, $t0, $t3
        		lw $t5, 0($t0) 		# $t5 = arr[j]
        		
        		add $t2, $t4, $t5	# $t2 = arr[i] + arr[j]
        		
        		bne $t2, $t6, NotEqual	# check if arr[i] + arr[j] = currentNumber
        		addi $t7, $t7, 1	# matches++
        		NotEqual:
        		
        		# If 1 < matches then end the for loop
        		slt $t2, $s1, $t7
        		beq $t2, $0, Increment1
        		move $t9, $t1		# j = currentSize. 
        		j CheckLoop2		# For loop will end because there was more than 1 match
        		
        		Increment1:
        		addi $t9, $t9, 1	#j++
        		
        		CheckLoop2:
        		slt $t3, $t9, $t1
        		bne $t3, $zero, Loop2
        	
        	CheckLoop1:
        	addi $t8, $t8, 1	#i++
        	slt $t3, $t8, $t1
        	bne $t3, $zero, Loop1	#if i < size then continue
        	
        bne $t7, $s1, WrongMatches
        
        # $t3 = offset
        mul $t3, $t1, 4 
        
        la $t0, ($s5)
        
        # $t4 = index to be added at
        add $t4, $t3, $t0
        add $t5, $zero, $t6
        
        # store element
        sw $t5, ($t4)
        
        addi $t1, $t1, 1
        
        WrongMatches:
        
        move $t7, $zero		#reset matches
        move $t8, $zero		#reset i
        addi $t6, $t6, 1	#currentNumber++
        
        slt $t3, $t1, $s0
        bne $t3, $zero, while	#continue if we have not found the amount of numbers

	jr $ra

print:
beq $t2, $s0, exit

lw $a0, ($t0)
li $v0, 1
syscall

addi $t0, $t0, 4
addi $t2, $t2, 1

addi $t9, $t9, 1

bne $t9, 5, space
move $t9, $zero
li $v0, 4
la $a0, newLine
syscall
j print

space:
li $v0, 4
la $a0, comma
syscall
j print

exit:
jr $ra



