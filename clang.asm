alloc_expr(Expr_kind):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     dword ptr [rbp - 4], edi
        mov     edi, 24
        call    malloc@PLT
        mov     qword ptr [rbp - 16], rax
        cmp     qword ptr [rbp - 16], 0
        je      .LBB0_2
        jmp     .LBB0_3
.LBB0_2:
        lea     rdi, [rip + .L.str]
        lea     rsi, [rip + .L.str.1]
        mov     edx, 43
        lea     rcx, [rip + .L__PRETTY_FUNCTION__.alloc_expr(Expr_kind)]
        call    __assert_fail@PLT
.LBB0_3:
        mov     ecx, dword ptr [rbp - 4]
        mov     rax, qword ptr [rbp - 16]
        mov     dword ptr [rax], ecx
        mov     rax, qword ptr [rbp - 16]
        add     rsp, 16
        pop     rbp
        ret

make_nil():
        push    rbp
        mov     rbp, rsp
        xor     edi, edi
        call    alloc_expr(Expr_kind)
        pop     rbp
        ret

make_symbol(char const*):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     qword ptr [rbp - 8], rdi
        mov     edi, 1
        call    alloc_expr(Expr_kind)
        mov     qword ptr [rbp - 16], rax
        mov     rcx, qword ptr [rbp - 8]
        mov     rax, qword ptr [rbp - 16]
        mov     qword ptr [rax + 8], rcx
        mov     rax, qword ptr [rbp - 16]
        add     rsp, 16
        pop     rbp
        ret

make_pair(Expr*, Expr*):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     qword ptr [rbp - 8], rdi
        mov     qword ptr [rbp - 16], rsi
        mov     edi, 4
        call    alloc_expr(Expr_kind)
        mov     qword ptr [rbp - 24], rax
        mov     rcx, qword ptr [rbp - 8]
        mov     rax, qword ptr [rbp - 24]
        mov     qword ptr [rax + 8], rcx
        mov     rcx, qword ptr [rbp - 16]
        mov     rax, qword ptr [rbp - 24]
        mov     qword ptr [rax + 16], rcx
        mov     rax, qword ptr [rbp - 24]
        add     rsp, 32
        pop     rbp
        ret

dump_expr_opt(Expr*, int):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     qword ptr [rbp - 8], rdi
        mov     dword ptr [rbp - 12], esi
        mov     dword ptr [rbp - 16], 0
.LBB4_1:
        mov     eax, dword ptr [rbp - 16]
        cmp     eax, dword ptr [rbp - 12]
        jge     .LBB4_4
        lea     rdi, [rip + .L.str.2]
        mov     al, 0
        call    printf@PLT
        mov     eax, dword ptr [rbp - 16]
        add     eax, 1
        mov     dword ptr [rbp - 16], eax
        jmp     .LBB4_1
.LBB4_4:
        mov     rax, qword ptr [rbp - 8]
        mov     eax, dword ptr [rax]
        mov     qword ptr [rbp - 24], rax
        sub     rax, 5
        ja      .LBB4_12
        mov     rcx, qword ptr [rbp - 24]
        lea     rax, [rip + .LJTI4_0]
        movsxd  rcx, dword ptr [rax + 4*rcx]
        add     rax, rcx
        jmp     rax
.LBB4_5:
        jmp     .LBB4_6
.LBB4_6:
        mov     rax, qword ptr [rip + stderr@GOTPCREL]
        mov     rdi, qword ptr [rax]
        lea     rsi, [rip + .L.str.3]
        lea     rdx, [rip + .L.str.1]
        mov     ecx, 67
        lea     r8, [rip + .L.str.4]
        mov     al, 0
        call    fprintf@PLT
        call    abort@PLT
.LBB4_7:
        jmp     .LBB4_8
.LBB4_8:
        mov     rax, qword ptr [rip + stderr@GOTPCREL]
        mov     rdi, qword ptr [rax]
        lea     rsi, [rip + .L.str.3]
        lea     rdx, [rip + .L.str.1]
        mov     ecx, 71
        lea     r8, [rip + .L.str.5]
        mov     al, 0
        call    fprintf@PLT
        call    abort@PLT
.LBB4_9:
        lea     rdi, [rip + .L.str.6]
        mov     al, 0
        call    printf@PLT
        mov     rax, qword ptr [rbp - 8]
        mov     rdi, qword ptr [rax + 8]
        mov     esi, dword ptr [rbp - 12]
        add     esi, 1
        call    dump_expr_opt(Expr*, int)
        mov     rax, qword ptr [rbp - 8]
        mov     rdi, qword ptr [rax + 16]
        mov     esi, dword ptr [rbp - 12]
        add     esi, 1
        call    dump_expr_opt(Expr*, int)
        jmp     .LBB4_14
.LBB4_10:
        jmp     .LBB4_11
.LBB4_11:
        mov     rax, qword ptr [rip + stderr@GOTPCREL]
        mov     rdi, qword ptr [rax]
        lea     rsi, [rip + .L.str.7]
        lea     rdx, [rip + .L.str.1]
        mov     ecx, 80
        lea     r8, [rip + .L.str.8]
        mov     al, 0
        call    fprintf@PLT
        call    abort@PLT
.LBB4_12:
        jmp     .LBB4_13
.LBB4_13:
        mov     rax, qword ptr [rip + stderr@GOTPCREL]
        mov     rdi, qword ptr [rax]
        lea     rsi, [rip + .L.str.7]
        lea     rdx, [rip + .L.str.1]
        mov     ecx, 82
        lea     r8, [rip + .L.str.8]
        mov     al, 0
        call    fprintf@PLT
        call    abort@PLT
.LBB4_14:
        add     rsp, 32
        pop     rbp
        ret
.LJTI4_0:
        .long   .LBB4_5-.LJTI4_0
        .long   .LBB4_7-.LJTI4_0
        .long   .LBB4_12-.LJTI4_0
        .long   .LBB4_12-.LJTI4_0
        .long   .LBB4_9-.LJTI4_0
        .long   .LBB4_10-.LJTI4_0

main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48
        mov     dword ptr [rbp - 4], 0
        lea     rdi, [rip + .L.str.9]
        call    make_symbol(char const*)
        mov     qword ptr [rbp - 24], rax
        lea     rdi, [rip + .L.str.10]
        call    make_symbol(char const*)
        mov     qword ptr [rbp - 32], rax
        lea     rdi, [rip + .L.str.11]
        call    make_symbol(char const*)
        mov     qword ptr [rbp - 40], rax
        lea     rdi, [rip + .L.str.12]
        call    make_symbol(char const*)
        mov     qword ptr [rbp - 48], rax
        call    make_nil()
        mov     rdi, qword ptr [rbp - 48]
        mov     rsi, rax
        call    make_pair(Expr*, Expr*)
        mov     rdi, qword ptr [rbp - 40]
        mov     rsi, rax
        call    make_pair(Expr*, Expr*)
        mov     rdi, qword ptr [rbp - 32]
        mov     rsi, rax
        call    make_pair(Expr*, Expr*)
        mov     rdi, qword ptr [rbp - 24]
        mov     rsi, rax
        call    make_pair(Expr*, Expr*)
        mov     qword ptr [rbp - 16], rax
        mov     rdi, qword ptr [rbp - 16]
        xor     esi, esi
        call    dump_expr_opt(Expr*, int)
        xor     eax, eax
        add     rsp, 48
        pop     rbp
        ret

.L.str:
        .asciz  "expr"

.L.str.1:
        .asciz  "/app/example.cpp"

.L__PRETTY_FUNCTION__.alloc_expr(Expr_kind):
        .asciz  "Expr *alloc_expr(Expr_kind)"

.L.str.2:
        .asciz  "  "

.L.str.3:
        .asciz  "%s:%d: TODO: %s\n"

.L.str.4:
        .asciz  "Dsda"

.L.str.5:
        .asciz  "dasd"

.L.str.6:
        .asciz  "PAIR:\n"

.L.str.7:
        .asciz  "%s:%d: UNREACHABLE: %s\n"

.L.str.8:
        .asciz  "Invalid Expr Kind"

.L.str.9:
        .asciz  "1"

.L.str.10:
        .asciz  "2"

.L.str.11:
        .asciz  "3"

.L.str.12:
        .asciz  "4s"