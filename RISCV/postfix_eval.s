.section .rodata

output_fmt: .string "%lld\n"
input_fmt: .string "%s"

.section .bss

expr: .space 101

.section .text
.globl main

main:
    addi sp, sp, -8
    sd ra, 0(sp)

    la a0, input_fmt
    la a1, expr

    call scanf

    la s0, expr # s0 = &expr[0]

    addi s1, x0, 0 # s1 is stack length after ra
    addi s2, x0, 0 # s2 is the result accumulator

    addi s3, x0, 43 # s3 = '+'
    addi s4, x0, 45 # s4 = '-'
    addi s5, x0, 42 # s5 = '*'
    addi s6, x0, 47 # s6 = '/'

stackloop:
    lb t0, 0(s0) # t0 = *(&expr[i]) = expr[i]
    beq t0, x0, end

    beq t0, s3, plus
    beq t0, s4, minus
    beq t0, s5, multi
    beq t0, s6, divide

    j else

plus:
    ld t1, 0(sp)
    addi sp, sp, 8

    ld t2, 0(sp)
    addi sp, sp, 8

    add t3, t1, t2
    addi sp, sp, -8
    sd t3, 0(sp)

    addi s1, s1, -8
   
    j stackloop_after

minus:
    ld t1, 0(sp)
    addi sp, sp, 8

    ld t2, 0(sp)
    addi sp, sp, 8

    sub t3, t2, t1
    addi sp, sp, -8
    sd t3, 0(sp)

    addi s1, s1, -8
   
    j stackloop_after

multi:
    ld t1, 0(sp)
    addi sp, sp, 8

    ld t2, 0(sp)
    addi sp, sp, 8

    mul t3, t1, t2
    addi sp, sp, -8
    sd t3, 0(sp)
   
    addi s1, s1, -8

    j stackloop_after

divide:
    ld t1, 0(sp)
    addi sp, sp, 8

    ld t2, 0(sp)
    addi sp, sp, 8

    div t3, t2, t1
    addi sp, sp, -8
    sd t3, 0(sp)

    addi s1, s1, -8
   
    j stackloop_after

else:
    addi sp, sp, -8
    addi s1, s1, 8
    addi t0, t0, -48
    sd t0, 0(sp)
    j stackloop_after

stackloop_after:
    addi s0, s0, 1
    j stackloop

end:
    la a0, output_fmt
    ld a1, 0(sp)

    call printf

    add sp, sp, s1
    ld ra, 0(sp)
    addi sp, sp, 8

    ret
    


