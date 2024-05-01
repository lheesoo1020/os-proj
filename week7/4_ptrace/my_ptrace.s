	.file	"my_ptrace.c"
	.text
.Ltext0:
	.comm	regs,216,32
	.section	.rodata
.LC0:
	.string	"ls"
.LC1:
	.string	"/bin/ls"
.LC2:
	.string	"Fork failed."
.LC3:
	.string	"[SYSCALL]:%-20s\t%5lld\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB5:
	.file 1 "my_ptrace.c"
	.loc 1 18 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$24, %rsp
	.cfi_offset 3, -24
	.loc 1 18 0
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	.loc 1 19 0
	call	fork@PLT
	movl	%eax, -28(%rbp)
	.loc 1 20 0
	cmpl	$0, -28(%rbp)
	jne	.L2
	.loc 1 22 0
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	ptrace@PLT
	.loc 1 23 0
	movl	$0, %edx
	leaq	.LC0(%rip), %rsi
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	execl@PLT
	jmp	.L3
.L2:
	.loc 1 24 0
	cmpl	$0, -28(%rbp)
	jns	.L5
	.loc 1 25 0
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	jmp	.L3
.L7:
.LBB2:
	.loc 1 30 0
	movl	-28(%rbp), %eax
	leaq	regs(%rip), %rcx
	movl	$0, %edx
	movl	%eax, %esi
	movl	$12, %edi
	movl	$0, %eax
	call	ptrace@PLT
	.loc 1 31 0
	movq	120+regs(%rip), %rbx
	.loc 1 31 0
	movq	120+regs(%rip), %rax
	.loc 1 31 0
	movq	%rax, %rdi
	call	get_syscode
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movq	%rbx, %rcx
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	.loc 1 34 0
	movl	-28(%rbp), %eax
	movl	$0, %ecx
	movl	$0, %edx
	movl	%eax, %esi
	movl	$24, %edi
	movl	$0, %eax
	call	ptrace@PLT
.L5:
	.loc 1 28 0
	leaq	-32(%rbp), %rcx
	movl	-28(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	waitpid@PLT
	testl	%eax, %eax
	je	.L3
	.loc 1 28 0 discriminator 1
	movl	-32(%rbp), %eax
	andl	$127, %eax
	.loc 1 28 0 discriminator 1
	testl	%eax, %eax
	jne	.L7
.L3:
.LBE2:
	.loc 1 37 0
	movl	$0, %eax
	.loc 1 38 0
	movq	-24(%rbp), %rbx
	xorq	%fs:40, %rbx
	je	.L9
	call	__stack_chk_fail@PLT
.L9:
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	main, .-main
	.section	.rodata
.LC4:
	.string	"SYS_read"
.LC5:
	.string	"SYS_write"
.LC6:
	.string	"SYS_close"
.LC7:
	.string	"SYS_fstat"
.LC8:
	.string	"SYS_mmap"
.LC9:
	.string	"SYS_mprotect"
.LC10:
	.string	"SYS_munmap"
.LC11:
	.string	"SYS_brk"
.LC12:
	.string	"SYS_rt_sigaction"
.LC13:
	.string	"SYS_rt_sigprocmask"
.LC14:
	.string	"SYS_rt_sigreturn"
.LC15:
	.string	"SYS_ioctl"
.LC16:
	.string	"SYS_getpid"
.LC17:
	.string	"SYS_pread64"
.LC18:
	.string	"SYS_access"
.LC19:
	.string	"SYS_pipe"
.LC20:
	.string	"SYS_execve"
.LC21:
	.string	"SYS_getdents"
.LC22:
	.string	"SYS_statfs"
.LC23:
	.string	"SYS_exit_group"
.LC24:
	.string	"SYS_openat"
.LC25:
	.string	"SYS_mkdirat"
.LC26:
	.string	"SYS_prlimit64"
.LC27:
	.string	"SYS_arch_prctl"
.LC28:
	.string	"SYS_set_tid_address"
.LC29:
	.string	"SYS_set_robust_list"
	.align 8
.LC30:
	.string	"Not registered in the function list."
	.text
	.globl	get_syscode
	.type	get_syscode, @function
get_syscode:
.LFB6:
	.loc 1 40 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	.loc 1 41 0
	movq	-8(%rbp), %rax
	cmpq	$17, %rax
	je	.L12
	cmpq	$17, %rax
	jg	.L13
	cmpq	$10, %rax
	je	.L14
	cmpq	$10, %rax
	jg	.L15
	cmpq	$3, %rax
	je	.L16
	cmpq	$3, %rax
	jg	.L17
	testq	%rax, %rax
	je	.L18
	cmpq	$1, %rax
	je	.L19
	jmp	.L11
.L17:
	cmpq	$5, %rax
	je	.L20
	cmpq	$9, %rax
	je	.L21
	jmp	.L11
.L15:
	cmpq	$13, %rax
	je	.L22
	cmpq	$13, %rax
	jg	.L23
	cmpq	$11, %rax
	je	.L24
	cmpq	$12, %rax
	je	.L25
	jmp	.L11
.L23:
	cmpq	$15, %rax
	je	.L26
	cmpq	$15, %rax
	jg	.L27
	jmp	.L46
.L13:
	cmpq	$158, %rax
	je	.L29
	cmpq	$158, %rax
	jg	.L30
	cmpq	$39, %rax
	je	.L31
	cmpq	$39, %rax
	jg	.L32
	cmpq	$21, %rax
	je	.L33
	cmpq	$22, %rax
	je	.L34
	jmp	.L11
.L32:
	cmpq	$78, %rax
	je	.L35
	cmpq	$137, %rax
	je	.L36
	cmpq	$59, %rax
	je	.L37
	jmp	.L11
.L30:
	cmpq	$257, %rax
	je	.L38
	cmpq	$257, %rax
	jg	.L39
	cmpq	$218, %rax
	je	.L40
	cmpq	$231, %rax
	je	.L41
	jmp	.L11
.L39:
	cmpq	$273, %rax
	je	.L42
	cmpq	$302, %rax
	je	.L43
	cmpq	$258, %rax
	je	.L44
	jmp	.L11
.L18:
	.loc 1 42 0
	leaq	.LC4(%rip), %rax
	jmp	.L45
.L19:
	.loc 1 43 0
	leaq	.LC5(%rip), %rax
	jmp	.L45
.L16:
	.loc 1 44 0
	leaq	.LC6(%rip), %rax
	jmp	.L45
.L20:
	.loc 1 45 0
	leaq	.LC7(%rip), %rax
	jmp	.L45
.L21:
	.loc 1 46 0
	leaq	.LC8(%rip), %rax
	jmp	.L45
.L14:
	.loc 1 47 0
	leaq	.LC9(%rip), %rax
	jmp	.L45
.L24:
	.loc 1 48 0
	leaq	.LC10(%rip), %rax
	jmp	.L45
.L25:
	.loc 1 49 0
	leaq	.LC11(%rip), %rax
	jmp	.L45
.L22:
	.loc 1 50 0
	leaq	.LC12(%rip), %rax
	jmp	.L45
.L46:
	.loc 1 51 0
	leaq	.LC13(%rip), %rax
	jmp	.L45
.L26:
	.loc 1 52 0
	leaq	.LC14(%rip), %rax
	jmp	.L45
.L27:
	.loc 1 53 0
	leaq	.LC15(%rip), %rax
	jmp	.L45
.L31:
	.loc 1 54 0
	leaq	.LC16(%rip), %rax
	jmp	.L45
.L12:
	.loc 1 55 0
	leaq	.LC17(%rip), %rax
	jmp	.L45
.L33:
	.loc 1 56 0
	leaq	.LC18(%rip), %rax
	jmp	.L45
.L34:
	.loc 1 57 0
	leaq	.LC19(%rip), %rax
	jmp	.L45
.L37:
	.loc 1 58 0
	leaq	.LC20(%rip), %rax
	jmp	.L45
.L35:
	.loc 1 59 0
	leaq	.LC21(%rip), %rax
	jmp	.L45
.L36:
	.loc 1 60 0
	leaq	.LC22(%rip), %rax
	jmp	.L45
.L41:
	.loc 1 61 0
	leaq	.LC23(%rip), %rax
	jmp	.L45
.L38:
	.loc 1 62 0
	leaq	.LC24(%rip), %rax
	jmp	.L45
.L44:
	.loc 1 63 0
	leaq	.LC25(%rip), %rax
	jmp	.L45
.L43:
	.loc 1 64 0
	leaq	.LC26(%rip), %rax
	jmp	.L45
.L29:
	.loc 1 65 0
	leaq	.LC27(%rip), %rax
	jmp	.L45
.L40:
	.loc 1 66 0
	leaq	.LC28(%rip), %rax
	jmp	.L45
.L42:
	.loc 1 67 0
	leaq	.LC29(%rip), %rax
	jmp	.L45
.L11:
	.loc 1 69 0
	leaq	.LC30(%rip), %rax
.L45:
	.loc 1 71 0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	get_syscode, .-get_syscode
.Letext0:
	.file 2 "/usr/lib/gcc/x86_64-linux-gnu/7/include/stddef.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 4 "/usr/include/x86_64-linux-gnu/bits/libio.h"
	.file 5 "/usr/include/stdio.h"
	.file 6 "/usr/include/x86_64-linux-gnu/bits/sys_errlist.h"
	.file 7 "/usr/include/x86_64-linux-gnu/sys/types.h"
	.file 8 "/usr/include/x86_64-linux-gnu/sys/user.h"
	.file 9 "/usr/include/signal.h"
	.file 10 "/usr/include/unistd.h"
	.file 11 "/usr/include/x86_64-linux-gnu/bits/getopt_core.h"
	.file 12 "/usr/include/x86_64-linux-gnu/sys/ptrace.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x66f
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF111
	.byte	0xc
	.long	.LASF112
	.long	.LASF113
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.long	.LASF7
	.byte	0x2
	.byte	0xd8
	.long	0x38
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF0
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.long	.LASF1
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.long	.LASF2
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF3
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF4
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.long	.LASF5
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF6
	.uleb128 0x2
	.long	.LASF8
	.byte	0x3
	.byte	0x8c
	.long	0x69
	.uleb128 0x2
	.long	.LASF9
	.byte	0x3
	.byte	0x8d
	.long	0x69
	.uleb128 0x2
	.long	.LASF10
	.byte	0x3
	.byte	0x8e
	.long	0x62
	.uleb128 0x5
	.byte	0x8
	.uleb128 0x6
	.byte	0x8
	.long	0x99
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF11
	.uleb128 0x7
	.long	0x99
	.uleb128 0x8
	.long	.LASF41
	.byte	0xd8
	.byte	0x4
	.byte	0xf5
	.long	0x225
	.uleb128 0x9
	.long	.LASF12
	.byte	0x4
	.byte	0xf6
	.long	0x62
	.byte	0
	.uleb128 0x9
	.long	.LASF13
	.byte	0x4
	.byte	0xfb
	.long	0x93
	.byte	0x8
	.uleb128 0x9
	.long	.LASF14
	.byte	0x4
	.byte	0xfc
	.long	0x93
	.byte	0x10
	.uleb128 0x9
	.long	.LASF15
	.byte	0x4
	.byte	0xfd
	.long	0x93
	.byte	0x18
	.uleb128 0x9
	.long	.LASF16
	.byte	0x4
	.byte	0xfe
	.long	0x93
	.byte	0x20
	.uleb128 0x9
	.long	.LASF17
	.byte	0x4
	.byte	0xff
	.long	0x93
	.byte	0x28
	.uleb128 0xa
	.long	.LASF18
	.byte	0x4
	.value	0x100
	.long	0x93
	.byte	0x30
	.uleb128 0xa
	.long	.LASF19
	.byte	0x4
	.value	0x101
	.long	0x93
	.byte	0x38
	.uleb128 0xa
	.long	.LASF20
	.byte	0x4
	.value	0x102
	.long	0x93
	.byte	0x40
	.uleb128 0xa
	.long	.LASF21
	.byte	0x4
	.value	0x104
	.long	0x93
	.byte	0x48
	.uleb128 0xa
	.long	.LASF22
	.byte	0x4
	.value	0x105
	.long	0x93
	.byte	0x50
	.uleb128 0xa
	.long	.LASF23
	.byte	0x4
	.value	0x106
	.long	0x93
	.byte	0x58
	.uleb128 0xa
	.long	.LASF24
	.byte	0x4
	.value	0x108
	.long	0x25d
	.byte	0x60
	.uleb128 0xa
	.long	.LASF25
	.byte	0x4
	.value	0x10a
	.long	0x263
	.byte	0x68
	.uleb128 0xa
	.long	.LASF26
	.byte	0x4
	.value	0x10c
	.long	0x62
	.byte	0x70
	.uleb128 0xa
	.long	.LASF27
	.byte	0x4
	.value	0x110
	.long	0x62
	.byte	0x74
	.uleb128 0xa
	.long	.LASF28
	.byte	0x4
	.value	0x112
	.long	0x70
	.byte	0x78
	.uleb128 0xa
	.long	.LASF29
	.byte	0x4
	.value	0x116
	.long	0x46
	.byte	0x80
	.uleb128 0xa
	.long	.LASF30
	.byte	0x4
	.value	0x117
	.long	0x54
	.byte	0x82
	.uleb128 0xa
	.long	.LASF31
	.byte	0x4
	.value	0x118
	.long	0x269
	.byte	0x83
	.uleb128 0xa
	.long	.LASF32
	.byte	0x4
	.value	0x11c
	.long	0x279
	.byte	0x88
	.uleb128 0xa
	.long	.LASF33
	.byte	0x4
	.value	0x125
	.long	0x7b
	.byte	0x90
	.uleb128 0xa
	.long	.LASF34
	.byte	0x4
	.value	0x12d
	.long	0x91
	.byte	0x98
	.uleb128 0xa
	.long	.LASF35
	.byte	0x4
	.value	0x12e
	.long	0x91
	.byte	0xa0
	.uleb128 0xa
	.long	.LASF36
	.byte	0x4
	.value	0x12f
	.long	0x91
	.byte	0xa8
	.uleb128 0xa
	.long	.LASF37
	.byte	0x4
	.value	0x130
	.long	0x91
	.byte	0xb0
	.uleb128 0xa
	.long	.LASF38
	.byte	0x4
	.value	0x132
	.long	0x2d
	.byte	0xb8
	.uleb128 0xa
	.long	.LASF39
	.byte	0x4
	.value	0x133
	.long	0x62
	.byte	0xc0
	.uleb128 0xa
	.long	.LASF40
	.byte	0x4
	.value	0x135
	.long	0x27f
	.byte	0xc4
	.byte	0
	.uleb128 0xb
	.long	.LASF114
	.byte	0x4
	.byte	0x9a
	.uleb128 0x8
	.long	.LASF42
	.byte	0x18
	.byte	0x4
	.byte	0xa0
	.long	0x25d
	.uleb128 0x9
	.long	.LASF43
	.byte	0x4
	.byte	0xa1
	.long	0x25d
	.byte	0
	.uleb128 0x9
	.long	.LASF44
	.byte	0x4
	.byte	0xa2
	.long	0x263
	.byte	0x8
	.uleb128 0x9
	.long	.LASF45
	.byte	0x4
	.byte	0xa6
	.long	0x62
	.byte	0x10
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.long	0x22c
	.uleb128 0x6
	.byte	0x8
	.long	0xa5
	.uleb128 0xc
	.long	0x99
	.long	0x279
	.uleb128 0xd
	.long	0x38
	.byte	0
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.long	0x225
	.uleb128 0xc
	.long	0x99
	.long	0x28f
	.uleb128 0xd
	.long	0x38
	.byte	0x13
	.byte	0
	.uleb128 0xe
	.long	.LASF115
	.uleb128 0xf
	.long	.LASF46
	.byte	0x4
	.value	0x13f
	.long	0x28f
	.uleb128 0xf
	.long	.LASF47
	.byte	0x4
	.value	0x140
	.long	0x28f
	.uleb128 0xf
	.long	.LASF48
	.byte	0x4
	.value	0x141
	.long	0x28f
	.uleb128 0x6
	.byte	0x8
	.long	0xa0
	.uleb128 0x7
	.long	0x2b8
	.uleb128 0x10
	.long	.LASF49
	.byte	0x5
	.byte	0x87
	.long	0x263
	.uleb128 0x10
	.long	.LASF50
	.byte	0x5
	.byte	0x88
	.long	0x263
	.uleb128 0x10
	.long	.LASF51
	.byte	0x5
	.byte	0x89
	.long	0x263
	.uleb128 0x10
	.long	.LASF52
	.byte	0x6
	.byte	0x1a
	.long	0x62
	.uleb128 0xc
	.long	0x2be
	.long	0x2fa
	.uleb128 0x11
	.byte	0
	.uleb128 0x7
	.long	0x2ef
	.uleb128 0x10
	.long	.LASF53
	.byte	0x6
	.byte	0x1b
	.long	0x2fa
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF54
	.uleb128 0x2
	.long	.LASF55
	.byte	0x7
	.byte	0x62
	.long	0x86
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF56
	.uleb128 0x12
	.long	.LASF116
	.byte	0x7
	.byte	0x4
	.long	0x4d
	.byte	0xc
	.byte	0x1d
	.long	0x42d
	.uleb128 0x13
	.long	.LASF57
	.byte	0
	.uleb128 0x13
	.long	.LASF58
	.byte	0x1
	.uleb128 0x13
	.long	.LASF59
	.byte	0x2
	.uleb128 0x13
	.long	.LASF60
	.byte	0x3
	.uleb128 0x13
	.long	.LASF61
	.byte	0x4
	.uleb128 0x13
	.long	.LASF62
	.byte	0x5
	.uleb128 0x13
	.long	.LASF63
	.byte	0x6
	.uleb128 0x13
	.long	.LASF64
	.byte	0x7
	.uleb128 0x13
	.long	.LASF65
	.byte	0x8
	.uleb128 0x13
	.long	.LASF66
	.byte	0x9
	.uleb128 0x13
	.long	.LASF67
	.byte	0xc
	.uleb128 0x13
	.long	.LASF68
	.byte	0xd
	.uleb128 0x13
	.long	.LASF69
	.byte	0xe
	.uleb128 0x13
	.long	.LASF70
	.byte	0xf
	.uleb128 0x13
	.long	.LASF71
	.byte	0x10
	.uleb128 0x13
	.long	.LASF72
	.byte	0x11
	.uleb128 0x13
	.long	.LASF73
	.byte	0x12
	.uleb128 0x13
	.long	.LASF74
	.byte	0x13
	.uleb128 0x13
	.long	.LASF75
	.byte	0x18
	.uleb128 0x13
	.long	.LASF76
	.byte	0x19
	.uleb128 0x13
	.long	.LASF77
	.byte	0x1a
	.uleb128 0x13
	.long	.LASF78
	.byte	0x1e
	.uleb128 0x13
	.long	.LASF79
	.byte	0x1f
	.uleb128 0x13
	.long	.LASF80
	.byte	0x20
	.uleb128 0x13
	.long	.LASF81
	.byte	0x21
	.uleb128 0x14
	.long	.LASF82
	.value	0x4200
	.uleb128 0x14
	.long	.LASF83
	.value	0x4201
	.uleb128 0x14
	.long	.LASF84
	.value	0x4202
	.uleb128 0x14
	.long	.LASF85
	.value	0x4203
	.uleb128 0x14
	.long	.LASF86
	.value	0x4204
	.uleb128 0x14
	.long	.LASF87
	.value	0x4205
	.uleb128 0x14
	.long	.LASF88
	.value	0x4206
	.uleb128 0x14
	.long	.LASF89
	.value	0x4207
	.uleb128 0x14
	.long	.LASF90
	.value	0x4208
	.uleb128 0x14
	.long	.LASF91
	.value	0x4209
	.uleb128 0x14
	.long	.LASF92
	.value	0x420a
	.uleb128 0x14
	.long	.LASF93
	.value	0x420b
	.uleb128 0x14
	.long	.LASF94
	.value	0x420c
	.uleb128 0x14
	.long	.LASF95
	.value	0x420d
	.byte	0
	.uleb128 0x8
	.long	.LASF96
	.byte	0xd8
	.byte	0x8
	.byte	0x2a
	.long	0x576
	.uleb128 0x15
	.string	"r15"
	.byte	0x8
	.byte	0x2c
	.long	0x31c
	.byte	0
	.uleb128 0x15
	.string	"r14"
	.byte	0x8
	.byte	0x2d
	.long	0x31c
	.byte	0x8
	.uleb128 0x15
	.string	"r13"
	.byte	0x8
	.byte	0x2e
	.long	0x31c
	.byte	0x10
	.uleb128 0x15
	.string	"r12"
	.byte	0x8
	.byte	0x2f
	.long	0x31c
	.byte	0x18
	.uleb128 0x15
	.string	"rbp"
	.byte	0x8
	.byte	0x30
	.long	0x31c
	.byte	0x20
	.uleb128 0x15
	.string	"rbx"
	.byte	0x8
	.byte	0x31
	.long	0x31c
	.byte	0x28
	.uleb128 0x15
	.string	"r11"
	.byte	0x8
	.byte	0x32
	.long	0x31c
	.byte	0x30
	.uleb128 0x15
	.string	"r10"
	.byte	0x8
	.byte	0x33
	.long	0x31c
	.byte	0x38
	.uleb128 0x15
	.string	"r9"
	.byte	0x8
	.byte	0x34
	.long	0x31c
	.byte	0x40
	.uleb128 0x15
	.string	"r8"
	.byte	0x8
	.byte	0x35
	.long	0x31c
	.byte	0x48
	.uleb128 0x15
	.string	"rax"
	.byte	0x8
	.byte	0x36
	.long	0x31c
	.byte	0x50
	.uleb128 0x15
	.string	"rcx"
	.byte	0x8
	.byte	0x37
	.long	0x31c
	.byte	0x58
	.uleb128 0x15
	.string	"rdx"
	.byte	0x8
	.byte	0x38
	.long	0x31c
	.byte	0x60
	.uleb128 0x15
	.string	"rsi"
	.byte	0x8
	.byte	0x39
	.long	0x31c
	.byte	0x68
	.uleb128 0x15
	.string	"rdi"
	.byte	0x8
	.byte	0x3a
	.long	0x31c
	.byte	0x70
	.uleb128 0x9
	.long	.LASF97
	.byte	0x8
	.byte	0x3b
	.long	0x31c
	.byte	0x78
	.uleb128 0x15
	.string	"rip"
	.byte	0x8
	.byte	0x3c
	.long	0x31c
	.byte	0x80
	.uleb128 0x15
	.string	"cs"
	.byte	0x8
	.byte	0x3d
	.long	0x31c
	.byte	0x88
	.uleb128 0x9
	.long	.LASF98
	.byte	0x8
	.byte	0x3e
	.long	0x31c
	.byte	0x90
	.uleb128 0x15
	.string	"rsp"
	.byte	0x8
	.byte	0x3f
	.long	0x31c
	.byte	0x98
	.uleb128 0x15
	.string	"ss"
	.byte	0x8
	.byte	0x40
	.long	0x31c
	.byte	0xa0
	.uleb128 0x9
	.long	.LASF99
	.byte	0x8
	.byte	0x41
	.long	0x31c
	.byte	0xa8
	.uleb128 0x9
	.long	.LASF100
	.byte	0x8
	.byte	0x42
	.long	0x31c
	.byte	0xb0
	.uleb128 0x15
	.string	"ds"
	.byte	0x8
	.byte	0x43
	.long	0x31c
	.byte	0xb8
	.uleb128 0x15
	.string	"es"
	.byte	0x8
	.byte	0x44
	.long	0x31c
	.byte	0xc0
	.uleb128 0x15
	.string	"fs"
	.byte	0x8
	.byte	0x45
	.long	0x31c
	.byte	0xc8
	.uleb128 0x15
	.string	"gs"
	.byte	0x8
	.byte	0x46
	.long	0x31c
	.byte	0xd0
	.byte	0
	.uleb128 0xc
	.long	0x2be
	.long	0x586
	.uleb128 0xd
	.long	0x38
	.byte	0x40
	.byte	0
	.uleb128 0x7
	.long	0x576
	.uleb128 0xf
	.long	.LASF101
	.byte	0x9
	.value	0x11e
	.long	0x586
	.uleb128 0xf
	.long	.LASF102
	.byte	0x9
	.value	0x11f
	.long	0x586
	.uleb128 0xf
	.long	.LASF103
	.byte	0xa
	.value	0x222
	.long	0x5af
	.uleb128 0x6
	.byte	0x8
	.long	0x93
	.uleb128 0x10
	.long	.LASF104
	.byte	0xb
	.byte	0x24
	.long	0x93
	.uleb128 0x10
	.long	.LASF105
	.byte	0xb
	.byte	0x32
	.long	0x62
	.uleb128 0x10
	.long	.LASF106
	.byte	0xb
	.byte	0x37
	.long	0x62
	.uleb128 0x10
	.long	.LASF107
	.byte	0xb
	.byte	0x3b
	.long	0x62
	.uleb128 0x16
	.long	.LASF108
	.byte	0x1
	.byte	0x10
	.long	0x42d
	.uleb128 0x9
	.byte	0x3
	.quad	regs
	.uleb128 0x17
	.long	.LASF117
	.byte	0x1
	.byte	0x28
	.long	0x2b8
	.quad	.LFB6
	.quad	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x626
	.uleb128 0x18
	.long	.LASF118
	.byte	0x1
	.byte	0x28
	.long	0x69
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x19
	.long	.LASF119
	.byte	0x1
	.byte	0x12
	.long	0x62
	.quad	.LFB5
	.quad	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x1a
	.long	.LASF109
	.byte	0x1
	.byte	0x13
	.long	0x311
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x1b
	.quad	.LBB2
	.quad	.LBE2-.LBB2
	.uleb128 0x1a
	.long	.LASF110
	.byte	0x1
	.byte	0x1b
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x13
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x21
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x4
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF8:
	.string	"__off_t"
.LASF71:
	.string	"PTRACE_ATTACH"
.LASF113:
	.string	"/home/lheesoo1020/work/os_proj/week7/4_ptrace"
.LASF25:
	.string	"_chain"
.LASF7:
	.string	"size_t"
.LASF31:
	.string	"_shortbuf"
.LASF111:
	.string	"GNU C11 7.5.0 -mtune=generic -march=x86-64 -g -fstack-protector-strong"
.LASF94:
	.string	"PTRACE_SECCOMP_GET_FILTER"
.LASF48:
	.string	"_IO_2_1_stderr_"
.LASF19:
	.string	"_IO_buf_base"
.LASF91:
	.string	"PTRACE_PEEKSIGINFO"
.LASF56:
	.string	"long long unsigned int"
.LASF57:
	.string	"PTRACE_TRACEME"
.LASF85:
	.string	"PTRACE_SETSIGINFO"
.LASF66:
	.string	"PTRACE_SINGLESTEP"
.LASF67:
	.string	"PTRACE_GETREGS"
.LASF54:
	.string	"long long int"
.LASF4:
	.string	"signed char"
.LASF26:
	.string	"_fileno"
.LASF14:
	.string	"_IO_read_end"
.LASF117:
	.string	"get_syscode"
.LASF102:
	.string	"sys_siglist"
.LASF6:
	.string	"long int"
.LASF83:
	.string	"PTRACE_GETEVENTMSG"
.LASF12:
	.string	"_flags"
.LASF20:
	.string	"_IO_buf_end"
.LASF29:
	.string	"_cur_column"
.LASF70:
	.string	"PTRACE_SETFPREGS"
.LASF33:
	.string	"_offset"
.LASF100:
	.string	"gs_base"
.LASF75:
	.string	"PTRACE_SYSCALL"
.LASF90:
	.string	"PTRACE_LISTEN"
.LASF95:
	.string	"PTRACE_SECCOMP_GET_METADATA"
.LASF43:
	.string	"_next"
.LASF42:
	.string	"_IO_marker"
.LASF49:
	.string	"stdin"
.LASF3:
	.string	"unsigned int"
.LASF74:
	.string	"PTRACE_SETFPXREGS"
.LASF0:
	.string	"long unsigned int"
.LASF84:
	.string	"PTRACE_GETSIGINFO"
.LASF115:
	.string	"_IO_FILE_plus"
.LASF17:
	.string	"_IO_write_ptr"
.LASF52:
	.string	"sys_nerr"
.LASF44:
	.string	"_sbuf"
.LASF2:
	.string	"short unsigned int"
.LASF21:
	.string	"_IO_save_base"
.LASF87:
	.string	"PTRACE_SETREGSET"
.LASF32:
	.string	"_lock"
.LASF78:
	.string	"PTRACE_ARCH_PRCTL"
.LASF27:
	.string	"_flags2"
.LASF80:
	.string	"PTRACE_SYSEMU_SINGLESTEP"
.LASF69:
	.string	"PTRACE_GETFPREGS"
.LASF50:
	.string	"stdout"
.LASF46:
	.string	"_IO_2_1_stdin_"
.LASF104:
	.string	"optarg"
.LASF76:
	.string	"PTRACE_GET_THREAD_AREA"
.LASF105:
	.string	"optind"
.LASF13:
	.string	"_IO_read_ptr"
.LASF98:
	.string	"eflags"
.LASF81:
	.string	"PTRACE_SINGLEBLOCK"
.LASF82:
	.string	"PTRACE_SETOPTIONS"
.LASF114:
	.string	"_IO_lock_t"
.LASF41:
	.string	"_IO_FILE"
.LASF103:
	.string	"__environ"
.LASF79:
	.string	"PTRACE_SYSEMU"
.LASF73:
	.string	"PTRACE_GETFPXREGS"
.LASF39:
	.string	"_mode"
.LASF45:
	.string	"_pos"
.LASF28:
	.string	"_old_offset"
.LASF53:
	.string	"sys_errlist"
.LASF24:
	.string	"_markers"
.LASF86:
	.string	"PTRACE_GETREGSET"
.LASF1:
	.string	"unsigned char"
.LASF109:
	.string	"child"
.LASF97:
	.string	"orig_rax"
.LASF10:
	.string	"__pid_t"
.LASF5:
	.string	"short int"
.LASF60:
	.string	"PTRACE_PEEKUSER"
.LASF47:
	.string	"_IO_2_1_stdout_"
.LASF63:
	.string	"PTRACE_POKEUSER"
.LASF93:
	.string	"PTRACE_SETSIGMASK"
.LASF68:
	.string	"PTRACE_SETREGS"
.LASF112:
	.string	"my_ptrace.c"
.LASF107:
	.string	"optopt"
.LASF65:
	.string	"PTRACE_KILL"
.LASF88:
	.string	"PTRACE_SEIZE"
.LASF99:
	.string	"fs_base"
.LASF108:
	.string	"regs"
.LASF59:
	.string	"PTRACE_PEEKDATA"
.LASF11:
	.string	"char"
.LASF62:
	.string	"PTRACE_POKEDATA"
.LASF89:
	.string	"PTRACE_INTERRUPT"
.LASF106:
	.string	"opterr"
.LASF64:
	.string	"PTRACE_CONT"
.LASF9:
	.string	"__off64_t"
.LASF15:
	.string	"_IO_read_base"
.LASF23:
	.string	"_IO_save_end"
.LASF101:
	.string	"_sys_siglist"
.LASF58:
	.string	"PTRACE_PEEKTEXT"
.LASF34:
	.string	"__pad1"
.LASF35:
	.string	"__pad2"
.LASF36:
	.string	"__pad3"
.LASF37:
	.string	"__pad4"
.LASF38:
	.string	"__pad5"
.LASF61:
	.string	"PTRACE_POKETEXT"
.LASF18:
	.string	"_IO_write_end"
.LASF40:
	.string	"_unused2"
.LASF51:
	.string	"stderr"
.LASF118:
	.string	"code"
.LASF116:
	.string	"__ptrace_request"
.LASF110:
	.string	"status"
.LASF22:
	.string	"_IO_backup_base"
.LASF96:
	.string	"user_regs_struct"
.LASF30:
	.string	"_vtable_offset"
.LASF55:
	.string	"pid_t"
.LASF72:
	.string	"PTRACE_DETACH"
.LASF92:
	.string	"PTRACE_GETSIGMASK"
.LASF119:
	.string	"main"
.LASF16:
	.string	"_IO_write_base"
.LASF77:
	.string	"PTRACE_SET_THREAD_AREA"
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
