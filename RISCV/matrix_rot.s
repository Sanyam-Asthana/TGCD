.section .rodata

input_fmt: .string "%lld"
output_fmt: .string "%lld "
newline: .string "\n"

.section .bss

row: .space 8
col: .space 8
matrix: .space 800

.section .text
.globl main

main:
    addi sp, sp, -16
    sd ra, 0(sp)

    la a0, input_fmt
    la a1, row

    call scanf

    la t0, row
    ld s0, 0(t0) # s0 = number of rows

    la a0, input_fmt
    la a1, col

    call scanf

    la t0, col
    ld s1, 0(t0) # s1 = number of cols
   
    mul s2, s0, s1 # s2 = row x col (number of elements in matrix)
    addi s3, s2, 0 # s3 = s2

    la s4, matrix
    addi s5, x0, 0 # t1 is the input iteration

    addi s9, x0, 2

input_loop:
    beq s2, x0, i_loop_start

    la a0, input_fmt
    add s7, s5, s4
    addi a1, s7, 0

    call scanf

    addi s5, s5, 8
    addi s2, s2, -1
    j input_loop

i_loop_start:
    addi s5, x0, 0 # s5 = iter of outer loop
    j i_loop

i_loop:
    beq s5, s1, i_loop_start2
    addi s2, s0, 0 # s2 = number of cols
    addi s6, s5, 1 # s6 = iter of inner loop 
    j j_loop

j_loop:
    beq s6, s1, i_loop_end
    mul t0, s5, s1      # Use s1 (cols), not s2 (which is 0)
    add t1, t0, s6 
    slli t1, t1, 3 
    add t1, t1, s4

    mul t2, s6, s1      # Use s1
    add t3, t2, s5 
    slli t3, t3, 3 
    add t3, t3, s4

    ld t4, 0(t1)
    ld t5, 0(t3)
    sd t5, 0(t1)
    sd t4, 0(t3)

    addi s6, s6, 1
    j j_loop

i_loop_end:
    addi s5, s5, 1
    j i_loop


i_loop_start2:
    addi s5, x0, 0 # s5 = iter of outer loop
    j i_loop2

i_loop2:
    beq s5, s1, print_loop_i_start
    addi s6, x0, 0      # j must start at 0 for every row (FIXED)
    div s8, s1, s9      # Use s1 / 2
    j j_loop2

j_loop2:
    bge s6, s8, i_loop_end2
    
    # M[i][j]
    mul t0, s5, s1
    add t0, t0, s6
    slli t1, t0, 3
    add t1, t1, s4

    # M[i][n-1-j]
    sub t0, s1, s6
    addi t0, t0, -1
    mul t2, s5, s1
    add t2, t2, t0
    slli t3, t2, 3
    add t3, t3, s4

    ld t4, 0(t1)
    ld t6, 0(t3)
    sd t6, 0(t1)
    sd t4, 0(t3)

    addi s6, s6, 1
    j j_loop2

i_loop_end2:
    addi s5, s5, 1
    j i_loop2

print_loop_i_start:
    addi s3, x0, 0 # s3 = iter of outer loop
    j print_loop_i
   
print_loop_i:
    beq s3, s1, end
    addi s5, x0, 0 # s5 = iter of inner loop

    j print_loop_j

print_loop_j:
    beq s5, s1, print_loop_i_end
    
    mul t0, s1, s3 # t0 = i x n
    add t0, t0, s5 # t0 = i x n + j
    slli t0, t0, 3
    add t0, t0, s4

    la a0, output_fmt
    ld t1, 0(t0)
    addi a1, t1, 0

    call printf
    addi s5, s5, 1

    j print_loop_j

print_loop_i_end:
    la a0, newline
    call printf

    addi s3, s3, 1
    j print_loop_i

end:
    ld ra, 0(sp)
    addi sp, sp, 16
    ret



