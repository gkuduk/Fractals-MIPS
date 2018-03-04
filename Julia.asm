	.data
textCh:		.asciiz "Choose your set:\n1. Julia\n2. Mandelbrot\nChoice: "
text0:		.asciiz "Enter number of iterations: "
text1:		.asciiz "Enter in format: 0.0000\nEnter xc:	 0."
text2:		.asciiz "Enter yc:	 0."
text3:		.asciiz "Enter xn:	 0."
text4:		.asciiz "Enter yn:	 0."
text5:		.asciiz "\nFinished, result saved to JuliaRes.bmp"

bmpHeader:	.space 54
bmpBuffer:	.space 750000
bmpRes:		.word 500 500
scale: 		.word 50 30 20

filenameIn:	.asciiz "in.bmp"
filenameOut:	.asciiz "FractalRes.bmp"

	.text
	.globl main

main:
	la $a0, textCh
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	la $s4, ($v0)		# s4 = choice
	
	# Set starting values
	la $s2, bmpRes
	lw $s0, 0($s2)		# width
	lw $s1, 4($s2)		# height
	
	la $s2, bmpBuffer
	
	li $t1, 0		# pixel x
	li $t2, 0		# pixel y
	li $s3, 10000		# limit
	
	la $a0, text0
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	la $t3, ($v0)		# t3 = number of iterations
	
	beq $s4, 2, iteratePixel
	
	# Additional Julia parameters
	la $a0, text1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	la $t4, ($v0)		# t4 = xc
	
	la $a0, text2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	la $t5, ($v0)		# t5 = yc

iteratePixel:
	li $t0, 0		# t0 = no of curr iteration
	
	mult $t1, $s3
	mflo $t6
	div $t6, $s0
	mflo $t6		# Re value of pixel
	
	mult $t2, $s3
	mflo $t7
	div $t7, $s1
	mflo $t7		# Im value of pixel
	
	beq $s4, 2, mLoopS
	
jLoop:				# zn = zn^2 + c
	mult $t6, $t7		# xy
	mflo $t9
	div $t9, $t9, 10000
	mflo $t9
	
	sll $t9, $t9, 1		# 2xy
	
	# zn^2
	mult $t6, $t6
	mflo $t6
	div $t6, $t6, 10000
	#mflo $t6
	mult $t7, $t7
	mflo $t7
	div $t7, $t7, 10000
	#mflo $t7
	
	sub $t6, $t6, $t7
	move $t7, $t9
	
	# zn + c
	add $t6, $t6, $t4	# xn = xn + xc
	add $t7, $t7, $t5	# yn = yn + yc
	
	# check if zn is out of range
	mult $t6, $t6		# xn^2
	mflo $t8
	div $t8, $t8, 10
	mult $t7, $t7		# yn^2
	mflo $t9
	div $t9, $t9, 10
	
	add $t8, $t8, $t9
	
	bge $t8, 40000000, loop_end	# |zn| < 2
	
	addi $t0, $t0, 1		# no of current iteration +1
	
	bge $t0, $t3, loop_end
	
	b jLoop

mLoopS:
	move $t4, $t6
	move $t5, $t7
	
	li $t6, 0
	li $t7, 0

mLoop:				# zn = zn^2 + p
	mult $t6, $t7		# xy
	mflo $t9
	div $t9, $t9, 10000
	mflo $t9
	
	sll $t9, $t9, 1		# 2xy
	
	# zn^2
	mult $t6, $t6
	mflo $t6
	div $t6, $t6, 10000
	mflo $t6
	mult $t7, $t7
	mflo $t7
	div $t7, $t7, 10000
	mflo $t7

	sub $t6, $t6, $t7
	move $t7, $t9
	
	# zn + c
	add $t6, $t6, $t4	# xn = xn + xc
	add $t7, $t7, $t5	# yn = yn + yc
	
	# check if zn is out of range
	mult $t6, $t6		# xn^2
	mflo $t8
	div $t8, $t8, 10
	mult $t7, $t7		# yn^2
	mflo $t9
	div $t9, $t9, 10
	
	add $t8, $t8, $t9
	
	bge $t8, 40000000, loop_end	# |zn| < 2
	
	addi $t0, $t0, 1		# no of current iteration +1
	
	bge $t0, $t3, loop_end
	
	b mLoop

loop_end:
	# COLOURING
	## RED
	la $t9, scale
	lw $t9, ($t9)
	mult $t0, $t9
	mflo $t8
	
	li $a0, 256
	div $t8, $a0
	mfhi $t8
	
	sb $t8, ($s2)
	
	## GREEN
	la $t9, scale
	lw $t9, 4($t9)
	mult $t0, $t9
	mflo $t8
	
	li $a0, 256
	div $t8, $a0
	mfhi $t8
	
	sb $t8, 1($s2)
	
	## BLUE
	la $t9, scale
	lw $t9, 8($t9)
	mult $t0, $t9
	mflo $t8
	
	li $a0, 256
	div $t8, $a0
	mfhi $t8
	
	sb $t8, 2($s2)
	
	# writing to memory
	addi $s2, $s2, 3
	
	# go to next pixel
	addi $t1, $t1, 1
	blt $t1, $s0, iteratePixel
	li $t1, 0
	addi $t2, $t2, 1
	blt $t2, $s1, iteratePixel
	
	b setEnd

setEnd:
	# open file 'in.bmp'
	la $a0, filenameIn
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall
	
	move $a0, $v0
	li $v0, 14 		# read bmp header from file
	la $a1, bmpHeader
	li $a2, 54
	syscall
	
	# close file 'in.bmp'
	li $v0, 16
	syscall
	
	la $a0, filenameOut
	li $a1, 1
	li $a2, 0
	li $v0, 13
	syscall
	
	move $a0, $v0
	la $a1, bmpHeader
	li $a2, 54
	li $v0, 15
	syscall
	
	la $a1, bmpBuffer
	li $a2, 750000
	li $v0, 15
	syscall
	
	# CLOSING FILE
	li $v0, 16
	syscall
	
	b exit
	
exit:
	li $v0, 10
	syscall
