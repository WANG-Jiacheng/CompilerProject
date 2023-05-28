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
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r14
	pushq	%rbx
	subq	$112, %rsp
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	leaq	-120(%rbp), %rsi
	movl	$.L_Const_String_, %edi
	xorl	%eax, %eax
	callq	scanf@PLT
	movl	$0, -20(%rbp)
	.p2align	4, 0x90
.LBB1_1:                                # %cond
                                        # =>This Inner Loop Header: Depth=1
	movslq	-20(%rbp), %rax
	cmpb	$0, -120(%rbp,%rax)
	je	.LBB1_3
# %bb.2:                                # %loop
                                        #   in Loop: Header=BB1_1 Depth=1
	incl	-20(%rbp)
	jmp	.LBB1_1
.LBB1_3:                                # %afterLoop
	movq	%rsp, %r10
	addq	$-400, %r10                     # imm = 0xFE70
	movq	%r10, %rsp
	movq	%rsp, %r9
	addq	$-112, %r9
	movq	%r9, %rsp
	movq	%rsp, %rax
	leaq	-16(%rax), %r8
	movq	%r8, %rsp
	movl	$-1, -16(%rax)
	movq	%rsp, %rax
	leaq	-16(%rax), %r11
	movq	%r11, %rsp
	movl	$-1, -16(%rax)
	movq	%rsp, %rax
	leaq	-16(%rax), %rsi
	movq	%rsi, %rsp
	movl	$0, -16(%rax)
	movq	%rsp, %rax
	leaq	-16(%rax), %rcx
	movq	%rcx, %rsp
	movl	$0, -16(%rax)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movl	$0, -16(%rax)
	movq	%rsp, %rax
	leaq	-16(%rax), %r14
	movq	%r14, %rsp
	movl	$0, -16(%rax)
	jmp	.LBB1_4
	.p2align	4, 0x90
.LBB1_6:                                # %if
                                        #   in Loop: Header=BB1_4 Depth=1
	movl	(%r11), %eax
	incl	%eax
	movl	%eax, (%r11)
	cltq
	movslq	(%rsi), %rdx
	movb	-120(%rbp,%rdx), %dl
	movb	%dl, (%r9,%rax)
	incl	(%rsi)
.LBB1_4:                                # %cond4
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_8 Depth 2
	movl	(%rsi), %eax
	cmpl	-20(%rbp), %eax
	jge	.LBB1_16
# %bb.5:                                # %loop5
                                        #   in Loop: Header=BB1_4 Depth=1
	movslq	(%rsi), %rax
	movb	-120(%rbp,%rax), %al
	leal	-43(%rax), %edx
	testb	$-3, %dl
	sete	%dl
	cmpb	$42, %al
	sete	%bl
	orb	%dl, %bl
	cmpb	$47, %al
	sete	%al
	orb	%bl, %al
	jne	.LBB1_6
# %bb.7:                                # %else
                                        #   in Loop: Header=BB1_4 Depth=1
	movl	$0, (%rcx)
	movl	$0, (%rdi)
	.p2align	4, 0x90
.LBB1_8:                                # %cond38
                                        #   Parent Loop BB1_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movslq	(%rsi), %rax
	cmpl	-20(%rbp), %eax
	setl	%dl
	movzbl	-120(%rbp,%rax), %eax
	cmpb	$48, %al
	setge	%bl
	andb	%dl, %bl
	cmpb	$58, %al
	setl	%al
	testb	%al, %bl
	je	.LBB1_10
# %bb.9:                                # %loop39
                                        #   in Loop: Header=BB1_8 Depth=2
	movslq	(%rsi), %rax
	movzbl	-120(%rbp,%rax), %eax
	addb	$-48, %al
	movzbl	%al, %eax
	movl	%eax, (%rdi)
	movl	(%rcx), %edx
	leal	(%rdx,%rdx,4), %edx
	leal	(%rax,%rdx,2), %eax
	movl	%eax, (%rcx)
	incl	(%rsi)
	jmp	.LBB1_8
	.p2align	4, 0x90
.LBB1_10:                               # %afterLoop40
                                        #   in Loop: Header=BB1_4 Depth=1
	movslq	(%r11), %rax
	testq	%rax, %rax
	setns	%dl
	movb	(%r9,%rax), %al
	cmpb	$42, %al
	sete	%bl
	andb	%dl, %bl
	cmpb	$47, %al
	sete	%al
	orb	%bl, %al
	je	.LBB1_14
# %bb.11:                               # %if68
                                        #   in Loop: Header=BB1_4 Depth=1
	movslq	(%r8), %rax
	movl	(%r10,%rax,4), %eax
	movl	%eax, (%r14)
	decl	(%r8)
	movslq	(%r11), %rax
	cmpb	$42, (%r9,%rax)
	jne	.LBB1_15
# %bb.12:                               # %if89
                                        #   in Loop: Header=BB1_4 Depth=1
	movl	(%r14), %eax
	imull	(%rcx), %eax
	jmp	.LBB1_13
.LBB1_15:                               # %else90
                                        #   in Loop: Header=BB1_4 Depth=1
	movl	(%r14), %eax
	cltd
	idivl	(%rcx)
.LBB1_13:                               # %afterifelse70
                                        #   in Loop: Header=BB1_4 Depth=1
	movl	%eax, (%rcx)
	decl	(%r11)
.LBB1_14:                               # %afterifelse70
                                        #   in Loop: Header=BB1_4 Depth=1
	movl	(%r8), %eax
	incl	%eax
	movl	%eax, (%r8)
	cltq
	movl	(%rcx), %edx
	movl	%edx, (%r10,%rax,4)
	jmp	.LBB1_4
.LBB1_16:                               # %afterLoop6
	movq	%rsp, %rax
	addq	$-16, %rax
	movq	%rax, %rsp
	movq	%rsp, %rdx
	leaq	-16(%rdx), %rcx
	movq	%rcx, %rsp
	movl	$0, -16(%rdx)
	movq	%rsp, %rsi
	leaq	-16(%rsi), %rdx
	movq	%rdx, %rsp
	movl	$0, -16(%rsi)
	jmp	.LBB1_17
	.p2align	4, 0x90
.LBB1_19:                               # %if124
                                        #   in Loop: Header=BB1_17 Depth=1
	movslq	(%rcx), %rsi
	movl	(%rax), %edi
	addl	%edi, (%r10,%rsi,4)
	incl	(%rdx)
.LBB1_17:                               # %cond112
                                        # =>This Inner Loop Header: Depth=1
	movl	(%rdx), %esi
	cmpl	(%r11), %esi
	jg	.LBB1_21
# %bb.18:                               # %loop113
                                        #   in Loop: Header=BB1_17 Depth=1
	movslq	(%rcx), %rsi
	movl	(%r10,%rsi,4), %esi
	movl	%esi, (%rax)
	incl	(%rcx)
	movslq	(%rdx), %rsi
	cmpb	$43, (%r9,%rsi)
	je	.LBB1_19
# %bb.20:                               # %else125
                                        #   in Loop: Header=BB1_17 Depth=1
	movslq	(%rcx), %rsi
	movl	(%rax), %edi
	subl	(%r10,%rsi,4), %edi
	movl	%edi, (%r10,%rsi,4)
	incl	(%rdx)
	jmp	.LBB1_17
.LBB1_21:                               # %afterLoop114
	movslq	(%rcx), %rax
	movl	(%r10,%rax,4), %esi
	movl	$.L_Const_String_.1, %edi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90                         # -- Begin function test
	.type	test,@function
test:                                   # @test
	.cfi_startproc
# %bb.0:                                # %entry
	retq
.Lfunc_end2:
	.size	test, .Lfunc_end2-test
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata,"a",@progbits
.L.str:
	.asciz	"%d\n"
	.size	.L.str, 4

	.type	.L_Const_String_,@object        # @_Const_String_
.L_Const_String_:
	.asciz	"%s"
	.size	.L_Const_String_, 3

	.type	.L_Const_String_.1,@object      # @_Const_String_.1
.L_Const_String_.1:
	.asciz	"%d\n"
	.size	.L_Const_String_.1, 4

	.section	".note.GNU-stack","",@progbits
