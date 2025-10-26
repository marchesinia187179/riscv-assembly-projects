# TRIANGULAR NUMBERS
# S0 = 0; S1 = 1; S2 = 3;
# Sn = 3 * S{n-1} - 3 * S{n-2} + S{n-3}
# n: [0;8]

# CODE WRITTEN IN C
# int triangular_numbers(int n) {
#   if (n == 0) return 0
#   if (n == 1) return 1
#   if (n == 2) return 3
#   return 3*triangular_numbers(n-1) - 3*triangular_numbers(n-2) + triangular_numbers(n-3)
# }

# REGISTERS
# a2: n
# a3: value of n-number
# t0: general container

# STACK
# [ra]
# [a2]  =   [n]
# [a3]  =   [S{n-1}]
# [a3]  =   [S{n-2}]

main:
    li a2, 3
    call check_input

    addi sp, sp, -4
    sw ra, 0(sp)
    
    call triangular_numbers

    lw ra, 0(sp)
    addi sp, sp, 4

    call end

check_input:
    # check if n is in [0;8]
    bltz a2, invalid_input
    li t0, 8
    bgt a2, t0, invalid_input
    ret

triangular_numbers:
    li t0, 2
    ble a2, t0, base_case

    # allocate stack space for: ra, n, S{n-1}, S{n-2}
    addi sp, sp, -16
    sw ra, 12(sp)
    sw a2, 8(sp)

    # first recursive call: S{n-1}
    addi a2, a2, -1
    call triangular_numbers

    # save the result of S{n-1}
    li t0, 3
    mul a3, a3, t0
    sw a3, 4(sp)

    # second recursive call: S{n-2}
    lw a2, 8(sp)
    addi a2, a2, -2
    call triangular_numbers

    # save the result of S{n-2}
    li t0, -3
    mul a3, a3, t0
    sw a3, 0(sp)

    # third recursive call: S{n-3}
    lw a2, 8(sp)
    addi a2, a2, -3
    call triangular_numbers

    # combine results: 3 * S{n-1} - 3 * S{n-2} + S{n-3}
    lw t0, 4(sp)
    add a3, a3, t0
    lw t0, 0(sp)
    add a3, a3, t0

    lw ra, 12(sp)
    addi sp, sp, 16
    ret

base_case:
    beqz a2, first
    li t0, 1
    beq a2, t0, second   
    li t0, 2
    beq a2, t0, third

first:
    li a3, 0
    ret

second:
    li a3, 1
    ret

third:
    li a3, 3
    ret

invalid_input:
    addi a0, x0, 17
    addi a1, x0, 1
    ecall

end:
    # print the result
    li a0, 1
    mv a1, a3
    ecall

    # print new line
    li a0, 4
    li t0, 0x0a
    sb t0, 0(a1)
    ecall

    li a0, 10
    ecall