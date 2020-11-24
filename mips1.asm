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
	addi $s2, $zero, 1
	addi $s3, $zero, 2
	
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
	add $t0, $zero, 1	# Initilize 1. $t0 = 1
	add $t4, $zero, 1	# Initilize 1. $t4 = 1
	add $s1, $zero, $a0	# $s1 = x
	
	add $s0, $zero, 2
	
	li $v0, 4
	la $a0, firstLine
	syscall
	
	Loop1:
	
	mult $t0, $t0		# Multiply i * i or x^2
	mflo $t2		# Load in the lo from our x^2. $t2 = x^2
	
		Loop2:
		
		mult $t4, $t4
		mflo $t6
		
		mult $t6, $s0
		mflo $t7		# $t7 = 2y^2
		
		sub $t8, $t7, 1
		sub $t9, $t2, 1
		
		bne $t8, $t2, Else	#if equal then print
		jal print
		j Match
		Else:
		
		bne $t7, $t9, EndIf	#if equal then print
		jal print
		j Match
		
		#Else2:
		#addi $t4, $t4, 1
		#move $t6, $t0
		#j EndIf

		slt $t6, $t2, $t7 #set $t1 to 1 if x^2 < 2y^2
		bne $t6, $zero, Match
		#j EndIf
		
		#Else3:
		#move $t4, $s1
		#move $t6, $t0
		
		Match:
		move $t4, $t0
		
		EndIf:
		addi $t4, $t4, 1	# j++
		#slt $t5, $t4, $s1	
		bgt $t0, $t4, Loop2
		
	div $t4, $s3	#j = j / 2
	mflo $t4
	
	addi $t0, $t0, 1	#i++
	slt   $t3, $t0, $s1	# $t3 = 1 if i < x
	bne  $t3, $zero, Loop1 	# go to Loop1 if i < x
        
        li $v0, 10
        syscall


#H:
#move $t4, $s1
#li $v0, 4
#la $a0, inner
#syscall
#jal print
        
print:
	move $a0, $t0		# print x
	li $v0, 1
	syscall
		
	li $v0, 4		# print tab
	la $a0, tab
	syscall
		
	move $a0, $t4		# print y
	li $v0, 1	
	syscall
	
	li $v0, 4		# print tab
	la $a0, tab
	syscall
		
	move $a0, $t2		# print x^2
	li $v0, 1
	syscall
		
	li $v0, 4		# print tab
	la $a0, tab
	syscall
		
	move $a0, $t7		# print 2y^2
	li $v0, 1
	syscall
		
	li $v0, 4		# print newline
	la $a0, newLine
	syscall
	
	jr $ra
	
