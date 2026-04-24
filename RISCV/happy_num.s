.section .rodata

output_fmt: .string "%d\n"
input_fmt: .string "%d"

.section .bss

n: .space 8

.section .text
.globl main

main:
    addi sp, sp, -16
    sd ra, 0(sp)

    la a0, input_fmt
    la a1, n

    call scanf

    la a1, n
    ld s0, 0(a1) # s0 = value of n
    ld s3, 0(a1) # s3 = gold standard

    addi s1, x0, 10 # s1 = 10
    addi s4, x0, 1 # s4 = 1 (for checking)

    addi s5, x0, 0 # s5 is the number of iter
    addi s6, x0, 100 # for checking for 100th iter
    
    addi s2, x0, 0 # s2 = 0. s2 holds the accumulated result

process_digit:
    beq s0, x0, recurse
    addi s5, s5, 1

    rem t1, s0, s1
    mul t1, t1, t1

    add s2, s2, t1
    div s0, s0, s1 # s0 /= 10

    j process_digit

recurse:
    beq s5, s6, false
    beq s2, s4, true

    addi s0, s2, 0
    addi s2, x0, 0
    j process_digit

false:
    la a0, output_fmt
    addi a1, x0, 0

    call printf
    j end

true:
    la a0, output_fmt
    addi a1, x0, 1

    call printf
    j end

end:
    ld ra, 0(sp)
    addi sp, sp, 16
    ret



