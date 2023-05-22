	.text
	.file	"main"
	.p2align	4, 0x90                         # -- Begin function echo
	.type	echo,@function
echo:                                   # @echo
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, %rsi
	movl	$.L.str, %edi
	xorl	%eax, %eax
	callq	printf@PLT
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	echo, .Lfunc_end0-echo
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90                         # -- Begin function main
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$11, %edi
	callq	do_math
	movq	%rax, %rdi
	callq	echo
	movl	$12, %edi
	callq	do_math
	movq	%rax, %rdi
	callq	echo
	movl	$10, %edi
	callq	printi@PLT
	movl	$11, %edi
	callq	do_math
	movl	$.L_Const_String_, %edi
	movq	%rax, %rsi
	xorl	%eax, %eax
	callq	printf@PLT
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90                         # -- Begin function do_math
	.type	do_math,@function
do_math:                                # @do_math
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, 16(%rsp)
	leaq	(%rdi,%rdi,4), %rax
	movq	%rax, 8(%rsp)
	movl	$3, %edi
	callq	echo
	movl	$5, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	do_math, .Lfunc_end2-do_math
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata,"a",@progbits
.L.str:
	.asciz	"%d\n"
	.size	.L.str, 4

	.type	.L_Const_String_,@object        # @_Const_String_
.L_Const_String_:
	.asciz	"%d\n"
	.size	.L_Const_String_, 4

	.section	".note.GNU-stack","",@progbits
