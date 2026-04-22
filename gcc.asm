.LC0:
        .string "Expr* alloc_expr(Expr_kind)"
.LC1:
        .string "/app/example.cpp"
.LC2:
        .string "expr"
alloc_expr(Expr_kind):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     DWORD PTR [rbp-20], edi
        mov     edi, 24
        call    malloc
        mov     QWORD PTR [rbp-8], rax
        cmp     QWORD PTR [rbp-8], 0
        jne     .L2
        mov     ecx, OFFSET FLAT:.LC0
        mov     edx, 43
        mov     esi, OFFSET FLAT:.LC1
        mov     edi, OFFSET FLAT:.LC2
        call    __assert_fail
.L2:
        mov     rax, QWORD PTR [rbp-8]
        mov     edx, DWORD PTR [rbp-20]
        mov     DWORD PTR [rax], edx
        mov     rax, QWORD PTR [rbp-8]
        leave
        ret
make_nil():
        push    rbp
        mov     rbp, rsp
        mov     edi, 0
        call    alloc_expr(Expr_kind)
        pop     rbp
        ret
make_symbol(char const*):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     QWORD PTR [rbp-24], rdi
        mov     edi, 1
        call    alloc_expr(Expr_kind)
        mov     QWORD PTR [rbp-8], rax
        mov     rax, QWORD PTR [rbp-8]
        mov     rdx, QWORD PTR [rbp-24]
        mov     QWORD PTR [rax+8], rdx
        mov     rax, QWORD PTR [rbp-8]
        leave
        ret
make_pair(Expr*, Expr*):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     QWORD PTR [rbp-24], rdi
        mov     QWORD PTR [rbp-32], rsi
        mov     edi, 4
        call    alloc_expr(Expr_kind)
        mov     QWORD PTR [rbp-8], rax
        mov     rax, QWORD PTR [rbp-8]
        mov     rdx, QWORD PTR [rbp-24]
        mov     QWORD PTR [rax+8], rdx
        mov     rax, QWORD PTR [rbp-8]
        mov     rdx, QWORD PTR [rbp-32]
        mov     QWORD PTR [rax+16], rdx
        mov     rax, QWORD PTR [rbp-8]
        leave
        ret
.LC3:
        .string "  "
.LC4:
        .string "Dsda"
.LC5:
        .string "%s:%d: TODO: %s\n"
.LC6:
        .string "dasd"
.LC7:
        .string "PAIR:"
.LC8:
        .string "Invalid Expr Kind"
.LC9:
        .string "%s:%d: UNREACHABLE: %s\n"
dump_expr_opt(Expr*, int):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     QWORD PTR [rbp-24], rdi
        mov     DWORD PTR [rbp-28], esi
        mov     DWORD PTR [rbp-4], 0
        jmp     .L11
.L12:
        mov     edi, OFFSET FLAT:.LC3
        mov     eax, 0
        call    printf
        add     DWORD PTR [rbp-4], 1
.L11:
        mov     eax, DWORD PTR [rbp-4]
        cmp     eax, DWORD PTR [rbp-28]
        jl      .L12
        mov     rax, QWORD PTR [rbp-24]
        mov     eax, DWORD PTR [rax]
        cmp     eax, 5
        je      .L13
        cmp     eax, 5
        jg      .L14
        cmp     eax, 4
        je      .L15
        cmp     eax, 4
        jg      .L14
        test    eax, eax
        je      .L16
        cmp     eax, 1
        je      .L17
        jmp     .L14
.L16:
        mov     rax, QWORD PTR stderr[rip]
        mov     r8d, OFFSET FLAT:.LC4
        mov     ecx, 67
        mov     edx, OFFSET FLAT:.LC1
        mov     esi, OFFSET FLAT:.LC5
        mov     rdi, rax
        mov     eax, 0
        call    fprintf
        call    abort
.L17:
        mov     rax, QWORD PTR stderr[rip]
        mov     r8d, OFFSET FLAT:.LC6
        mov     ecx, 71
        mov     edx, OFFSET FLAT:.LC1
        mov     esi, OFFSET FLAT:.LC5
        mov     rdi, rax
        mov     eax, 0
        call    fprintf
        call    abort
.L15:
        mov     edi, OFFSET FLAT:.LC7
        call    puts
        mov     eax, DWORD PTR [rbp-28]
        lea     edx, [rax+1]
        mov     rax, QWORD PTR [rbp-24]
        mov     rax, QWORD PTR [rax+8]
        mov     esi, edx
        mov     rdi, rax
        call    dump_expr_opt(Expr*, int)
        mov     eax, DWORD PTR [rbp-28]
        lea     edx, [rax+1]
        mov     rax, QWORD PTR [rbp-24]
        mov     rax, QWORD PTR [rax+16]
        mov     esi, edx
        mov     rdi, rax
        call    dump_expr_opt(Expr*, int)
        jmp     .L19
.L13:
        mov     rax, QWORD PTR stderr[rip]
        mov     r8d, OFFSET FLAT:.LC8
        mov     ecx, 80
        mov     edx, OFFSET FLAT:.LC1
        mov     esi, OFFSET FLAT:.LC9
        mov     rdi, rax
        mov     eax, 0
        call    fprintf
        call    abort
.L14:
        mov     rax, QWORD PTR stderr[rip]
        mov     r8d, OFFSET FLAT:.LC8
        mov     ecx, 82
        mov     edx, OFFSET FLAT:.LC1
        mov     esi, OFFSET FLAT:.LC9
        mov     rdi, rax
        mov     eax, 0
        call    fprintf
        call    abort
.L19:
        nop
        leave
        ret
.LC10:
        .string "4s"
.LC11:
        .string "3"
.LC12:
        .string "2"
.LC13:
        .string "1"
main:
        push    rbp
        mov     rbp, rsp
        push    rbx
        sub     rsp, 24
        call    make_nil()
        mov     rbx, rax
        mov     edi, OFFSET FLAT:.LC10
        call    make_symbol(char const*)
        mov     rsi, rbx
        mov     rdi, rax
        call    make_pair(Expr*, Expr*)
        mov     rbx, rax
        mov     edi, OFFSET FLAT:.LC11
        call    make_symbol(char const*)
        mov     rsi, rbx
        mov     rdi, rax
        call    make_pair(Expr*, Expr*)
        mov     rbx, rax
        mov     edi, OFFSET FLAT:.LC12
        call    make_symbol(char const*)
        mov     rsi, rbx
        mov     rdi, rax
        call    make_pair(Expr*, Expr*)
        mov     rbx, rax
        mov     edi, OFFSET FLAT:.LC13
        call    make_symbol(char const*)
        mov     rsi, rbx
        mov     rdi, rax
        call    make_pair(Expr*, Expr*)
        mov     QWORD PTR [rbp-24], rax
        mov     rax, QWORD PTR [rbp-24]
        mov     esi, 0
        mov     rdi, rax
        call    dump_expr_opt(Expr*, int)
        mov     eax, 0
        mov     rbx, QWORD PTR [rbp-8]
        leave
        ret