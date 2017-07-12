.text
	nop
	addi $t0, $zero, 0x25
	addi $t1, $zero, 0x7
	addi $t2, $t2, 0x10010000
	addi $t3, $t3, 0x10010004
	nop
	sw $t0, 0($t2)
	lw $t4, 0($t2)
	sw $t1, 0($t3)
	lw $t5, 0($t3)