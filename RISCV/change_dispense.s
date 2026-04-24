.section .rodata

input_fmt: .string "%d %d"
output_fmt: .string "%d %d %d %d\n"
debug_fmt: .string "%d\n"

.section .bss

price: .space 8
total: .space 8

.section .text
.globl main

prints3:
   add sp, sp, -16
   sd ra, 0(sp)
   sd s3, 8(sp)

   la a0, debug_fmt
   addi a1, s3, 0 
   call printf

   ld ra, 0(sp)
   ld s3, 8(sp)
   add sp, sp, 16
   ret

main:
   add sp, sp, -128
   sd ra, 0(sp)
   sd s1, 8(sp)
   sd s2, 16(sp)
   sd s3, 24(sp)
   sd s4, 32(sp)
   sd s5, 40(sp)
   sd s6, 48(sp)
   sd s7, 56(sp)

   la a0, input_fmt
   la a1, price
   la a2, total


   call scanf

   la a1, price
   la a2, total

   ld s1, 0(a1) # s1 = price value
   ld s2, 0(a2) # s2 = total value

   sub s3, s2, s1  # s3 = total value - price value
  
   addi s4, x0, 0 # s4 = no. of 25 coins
   addi s5, x0, 0 # s5 = no. of 10 coins
   addi s6, x0, 0 # s6 = no. of 5 coins
   addi s7, x0, 0 # s7 = no. of 1 coins

   addi t1, x0, 25
   addi t2, x0, 10
   addi t3, x0, 5
   addi t4, x0, 1

loop25:
   # call prints3
   blt s3, t1, loop10
   addi s3, s3, -25
   addi s4, s4, 1
   j loop25

loop10:
   # call prints3
   blt s3, t2, loop5
   addi s3, s3, -10
   addi s5, s5, 1
   j loop10

loop5:
   # call prints3
   blt s3, t3, loop1
   addi s3, s3, -5
   addi s6, s6, 1
   j loop5

loop1:
   # call prints3
   blt s3, t4, afterloops
   addi s3, s3, -1
   addi s7, s7, 1
   j loop1

afterloops:
   la a0, output_fmt
   add a1, x0, s4
   add a2, x0, s5
   add a3, x0, s6
   add a4, x0, s7

   call printf

   ld ra, 0(sp)
   ld s1, 8(sp)
   ld s2, 16(sp)
   ld s3, 24(sp)
   ld s4, 32(sp)
   ld s5, 40(sp)
   ld s6, 48(sp)
   ld s7, 56(sp)
   add sp, sp, 128
   ret


