.global _start

.extern printf

.data
hello: .ascii "The first number is %d the second is %d and I'm glad this works!\n\0"

.text
_start:
	mov $3999, %rax
	push %rax
	mov $123547, %rax
	push %rax
	mov $hello, %rax
	push %rax
	call printf

	mov $60, %rax
	xor %rdi, %rdi
	syscall
