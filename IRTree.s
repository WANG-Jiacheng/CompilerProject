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
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rsp, %rsi
	movl	$.L_Const_String_.2, %edi
	xorl	%eax, %eax
	callq	scanf@PLT
	movq	(%rsp), %rdi
	movl	$97, %esi
	movl	$98, %edx
	movl	$99, %ecx
	callq	move
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90                         # -- Begin function move
	.type	move,@function
move:                                   # @move
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, 16(%rsp)
	movb	%sil, 14(%rsp)
	movb	%dl, 15(%rsp)
	movb	%cl, 13(%rsp)
	cmpq	$1, %rdi
	jne	.LBB2_2
# %bb.1:                                # %if
	movzbl	13(%rsp), %edx
	movzbl	14(%rsp), %esi
	movl	$.L_Const_String_, %edi
	xorl	%eax, %eax
	callq	printf@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.LBB2_2:                                # %else
	.cfi_def_cfa_offset 32
	movq	16(%rsp), %rdi
	decq	%rdi
	movzbl	15(%rsp), %ecx
	movzbl	13(%rsp), %edx
	movzbl	14(%rsp), %esi
	callq	move
	movzbl	13(%rsp), %edx
	movzbl	14(%rsp), %esi
	movl	$.L_Const_String_.1, %edi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	16(%rsp), %rdi
	decq	%rdi
	movzbl	13(%rsp), %ecx
	movzbl	14(%rsp), %edx
	movzbl	15(%rsp), %esi
	callq	move
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	move, .Lfunc_end2-move
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata,"a",@progbits
.L.str:
	.asciz	"%d\n"
	.size	.L.str, 4

	.type	.L_Const_String_,@object        # @_Const_String_
.L_Const_String_:
	.asciz	"%c->%c\n"
	.size	.L_Const_String_, 8

	.type	.L_Const_String_.1,@object      # @_Const_String_.1
.L_Const_String_.1:
	.asciz	"%c->%c\n"
	.size	.L_Const_String_.1, 8

	.type	.L_Const_String_.2,@object      # @_Const_String_.2
.L_Const_String_.2:
	.asciz	"%d"
	.size	.L_Const_String_.2, 3

	.section	".note.GNU-stack","",@progbits
