.global _start

.extern printf

.data
name:  .ascii "Github\0"
hello: .ascii "Hello, %s, I guess you're my %d friend now!\n\0"

.text
_start:
	mov $2, %rax
	push %rax
	mov $name, %rax
	push %rax
	mov $hello, %rax
	push %rax
	call printf

	mov $60, %rax
	xor %rdi, %rdi
	syscall
