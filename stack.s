.global _start

.data
char: 	.byte 0xa

.text

prnt:	# get value from stack
	mov %rsp, %rax
	add $8, %rax
	mov (%rax), %rax 
	mov %rax, (char)
	
	mov $1, %rax
	mov $1, %rdi
	mov $char, %rsi
	mov $1, %rdx
	syscall

	mov $10, %rcx
	mov %rcx, (char)

	# print nl
	syscall
	ret

_start:	

	mov $74, %rax
	push %rax
	call prnt

	# return zero
	mov $60, %rax
	xor %rsi, %rsi
	syscall
