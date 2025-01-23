        .section .text
        .global memset
        .align 2
        
memset:
        beqz a2, end
        
set_temporary_registers:
        mv t0, a0                       # Starting Address
        mv t1, a1                       # Byte to be set
        mv t2, a2                       # Number of bytes to be set
        li t3, 7
        
decide_branch:
        blt t2, t3, set_byte_in_memory  # Inital Branching Condition
        li t3, 4                        # Reset the register for comparison

check_if_memory_is_aligned:
        andi t4, t0, 3
        sub t4, t3, t4
        blt t4, t3, align_bytes_in_memory
        
calculate_word_from_byte:               # Duplicates byte 4 times
        mv t4, t1
        slli t4, t4, 8
        or t4, t4, t1
        slli t4, t4, 8
        or t4, t4, t1
        slli t4, t4, 8
        or t4, t4, t1
        
set_word_in_memory:
        sw t4, 0(t0)
        addi t0, t0, 4
        addi t2, t2, -4
        bge t2, t3, set_word_in_memory
        bnez t2, set_byte_in_memory     # Its highly likely that memory is aligned. 
        ret

set_byte_in_memory:
        sb t1, 0(t0)
        addi t0, t0, 1
        addi t2, t2, -1
        bnez t2, set_byte_in_memory
        ret

        
align_bytes_in_memory:
        sb t1, 0(t0)
        addi t0, t0, 1
        addi t2, t2, -1
        addi t4, t4, -1
        bnez t4, align_bytes_in_memory
        j calculate_word_from_byte

end:
        ret