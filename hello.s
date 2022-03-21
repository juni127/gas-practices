.global _start

.data
hello:	.ascii "Hello, World!\n"

.text

	# print Hello, World!
_start:	mov $1, %rax
	mov $1, %rdi
	mov $hello, %rsi
	mov $14, %rdx
	syscall

	# return zero
	mov $60, %rax
	xor %rdi, %rdi
	syscall
