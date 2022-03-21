.global printf
.global printd

.text
	# re-implement printf for masochist reasons
	# rsp+8 is the format string
	# rsp+(n*8) are the addresses of the values to be printed in order
printf:	
	mov %rsp, %rax
	mov $8, %rcx
	push %rcx
	add %rcx, %rax
	mov (%rax), %rbx
	
	# value starting in address %rbx is the format string
fsl:	xor %rdx, %rdx
	mov (%rbx), %dl
	cmp $0x0, %rdx	# if the char is end of string
	je fsl_o	# jmp to ret
	cmp $0x25, %rdx	# if the char is a %
	je fsl_v	# jmp to variable insert
	
	# else print the char
	mov $0x1, %rax
	mov $0x1, %rsi
	mov %rbx, %rsi
	mov $0x1, %rdx
	syscall

	# move to next char and repeat
	add $0x1, %rbx
	jmp fsl

fsl_v:	add $0x1, %rbx	# skip to next char
	xor %rdx, %rdx	# clean rdx register
	mov (%rbx), %dl	# mov char in address %rbx to %rdx
	cmp $0x64, %rdx	# if the char is 'd'
	je fsl_d	# jmp to print decimal
	cmp $0x63, %rdx	# if the char is 'c'
	je fsl_c	# jmp to print char
	cmp $0x73, %rdx	# if the char is 's'
	je fsl_s	# jmp to print string
	jmp fsl_o	# we should not get here but just in case let us just return

fsl_d: 	mov %rsp, %rax		# get stack pointer
	add $8, %rcx		# get next index in stack
	pop %rcx
	add %rcx, %rax		# get the stack address
	mov (%rax), %rbx	# mov the value to %rbx
	
	# convert numbers to string (crazy I know)
	# I know how to do it in a recursive way, maybe I just have to call printd from here
	# and write printd as a recursive function
	call printd
	jmp fsl	# return to main loop

 
fsl_c: 	nop
fsl_s:	nop

fsl_o:
	# return from the procedure
	ret

	# print decimals (recursive)
printd:	mov	%rsp, %rdx
	add	$8, %rdx
	mov	(%rdx), %rcx
	xor 	%rdx, %rdx
	mov 	%rbx, %rax
	mov 	$10, %rcx
	idivq	%rcx
	cmp	$10, %rax
	jg	ptrd_o
	push 	%rdx
	mov 	%rax, %rbx
	call printd
	pop	%rdx
	# print %rdx
ptrd_o:	mov	$1, %rax
	mov	$1, %rdi
	add	$48, %rdx
	mov	%rdx, %rsi
	mov	$1, %rdx
	syscall
	# and ret
	ret
