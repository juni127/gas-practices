.global printf
.global printd

.text
	# re-implement printf for masochist reasons
	# rsp+8 is the format string
	# rsp+(n*8) are the addresses of the values to be printed in order
printf:	
	mov %rsp, %rax
	mov $1, %rcx
	push %rcx
	mov (%rax, %rcx, 8), %r8
	
	# value starting in address %r8 is the format string
fsl:	xor %rdx, %rdx
	mov (%r8), %dl
	cmp $0x0, %rdx	# if the char is end of string
	je fsl_o	# jmp to ret
	cmp $0x25, %rdx	# if the char is a %
	je fsl_v	# jmp to variable insert
	
	# else print the char
	mov $0x1, %rax
	mov $0x1, %rdi
	mov %r8, %rsi
	mov $0x1, %rdx
	syscall

	# move to next char and repeat
	add $0x1, %r8
	jmp fsl

fsl_v:	add $0x1, %r8	# skip to next char
	xor %rdx, %rdx	# clean rdx register
	mov (%r8), %dl	# mov char in address %rbx to %rdx
	cmp $0x64, %rdx	# if the char is 'd'
	je fsl_d	# jmp to print decimal
	cmp $0x63, %rdx	# if the char is 'c'
	je fsl_c	# jmp to print char
	cmp $0x73, %rdx	# if the char is 's'
	je fsl_s	# jmp to print string
	jmp fsl_o	# we should not get here but just in case let us just return

fsl_d: 	
	pop %rcx		# get stack pointer adder counter
	inc %rcx		# get next index in stack
	mov (%rsp, %rcx, 8), %rbx	# mov the value to %rbx
	push %rcx			# getting rcx on top of stack after the usual bits
	push %rbx

	# convert numbers to string (crazy I know)
	# I know how to do it in a recursive way, maybe I just have to call printd from here
	# and write printd as a recursive function
	call printd
	pop %rbx
	add $1, %r8
	jmp fsl	# return to main loop

 
fsl_c: 	nop
fsl_s:	nop

fsl_o:
	# return from the procedure
	pop %rcx
	ret

	# print decimals (recursive)
printd:	
	mov	$1, %rdx
	mov	(%rsp, %rdx, 8), %rcx
	cmp	$0, %rcx
	je	ptrd_o
	xor 	%rdx, %rdx
	mov 	%rcx, %rax
	mov 	$10, %rcx
	idivq	%rcx
	push 	%rdx
	push 	%rax
	call printd
	pop %rax
	pop	%rdx
	# print %rdx
	mov $12, %rax	# sys brk
	xor %rdi, %rdi
	syscall
	mov %rax, %rdi
	push %rax
	add $1, %rdi
	mov $12, %rax
	syscall
	add	$48, %rdx
	mov %rdx, (%rdi)
	mov %rdi, %rsi
	mov	$1, %rax
	mov	$1, %rdi
	mov	$1, %rdx
	syscall
	pop %rax
	mov %rax, %rdi
	mov $12, %rax
	syscall
	# and ret
ptrd_o:	
	ret
