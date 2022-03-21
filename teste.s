.global _start

.extern printf

.data
hello: .ascii "Hello, World! (For the %d time)\n\0"

.text
_start:
	mov $2, %rax
	push %rax
	mov $hello, %rax
	push %rax
	call printf

	mov $60, %rax
	xor %rdi, %rdi
	syscall
