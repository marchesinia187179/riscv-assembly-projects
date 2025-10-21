# INVERSION OF A STRING
# a0: string address
# t0: pointer from left to right
# t1: pointer from right to left
# t2: iterator - it starts from half string length
# t4: value read from pointer t0
# t5: value read from pointer t1
# t6: general container

initialization:
    buffer: .space 6

    la a0, buffer
    addi t6, zero, 0x48 # add temporarily 'H' into t6
    sb t6, 0(a0)    # add the byte saved in t6 into a0

    addi t6, zero, 0x45 # add temporarily 'E' into t6
    sb t6, 1(a0)

    addi t6, zero, 0x4c # add temporarily 'L' into t6
    sb t6, 2(a0)

    addi t6, zero, 0x4c # add temporarily 'L' into t6
    sb t6, 3(a0)

    addi t6, zero, 0x4f # add temporarily 'O' into t6
    sb t6, 4(a0)

    addi t6, zero, 0x00 # add temporarily '\0' into t6
    sb t6, 5(a0)

    mv t0, a0   # save the address into t0
    mv t1, a0   # save the address into t1
    addi t2, zero, 0

string_length:
    lbu t5, 0(t1)   # load byte from memory t1 into t5
    beq t5, zero, set_length_inversion_loop  # end loop
    addi t1, t1, 1  # increment the pointer t1 by 1 byte
    addi t2, t2, 1  # increment the iterator
    j string_length

set_length_inversion_loop:
    addi t6, zero, 2
    div t2, t2, t6   # calculate the half string length
    addi t1, t1, -1 # decrease t1 pointer by 1 byte to avoid the start from the null terminator

inversion:
    beq t2, zero, end   # end loop

    lbu t4, 0(t0)   # load byte from memory t0 into t4
    lbu t5, 0(t1)   # load byte from memory t1 into t5

    sb t5, 0(t0)    # store byte from memory t5 into t0
    sb t4, 0(t1)    # store byte from memory t4 into t1

    addi t0, t0, 1  # increment pointer t0 by 1 byte
    addi t1, t1, -1 # decrease pointer t1 by 1 byte

    addi t2, t2, -1 # decrease the t2 iterator
    j inversion

end:
