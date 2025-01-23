
.section .text                # Code section
.global _start                # Export the main function
.align  2                     # Align the function to a 4-byte boundary

.equ BUFFER_SIZE, 2048         # Symbolic constant for buffer size
.equ SET_BYTES, 2048           # Symbolic constant for bytes to set

_start:
    # Set up arguments for memset
    la a0, buffer             # Address of the buffer
    li a1, 0xcc               # Byte to set (0xCC)
    li a2, SET_BYTES          # Number of bytes to set

    # Call memset
    call memset

    # Write buffer contents to a file (output the buffer)
    li a7, 64                 # Syscall: write
    li a0, 1                  # File descriptor: stdout
    la a1, buffer             # Address of the buffer
    li a2, BUFFER_SIZE        # Number of bytes to write
    ecall

    # Exit program
    li a7, 93                 # Syscall: exit
    li a0, 0                  # Exit code 0
    ecall

.section .data
buffer:
    .space BUFFER_SIZE        # Allocate BUFFER_SIZE bytes of uninitialized space
