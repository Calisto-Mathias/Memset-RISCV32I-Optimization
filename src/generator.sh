#!/bin/bash

# Template for the assembly program
asm_template='
.section .text                # Code section
.global _start                # Export the main function
.align  2                     # Align the function to a 4-byte boundary

.equ BUFFER_SIZE, %d         # Symbolic constant for buffer size
.equ SET_BYTES, %d           # Symbolic constant for bytes to set

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
'

# Output directory for the generated files
output_dir="generated_cases"
mkdir -p "$output_dir"

# Function to generate an assembly file
generate_case() {
    local buffer_size=$1
    local set_bytes=$2
    local file_name="$output_dir/case_buffer_${buffer_size}_set_${set_bytes}.s"
    printf "$asm_template" "$buffer_size" "$set_bytes" > "$file_name"
    echo "Generated: $file_name"
}

# Generate 5 cases where buffer size == bytes to set
for size in 128 256 512 1024 2048; do
    generate_case "$size" "$size"
done

# Generate 5 cases where bytes to set are not a multiple of 4
for size in 100 250 500 750 1020; do
    generate_case "$size" "$((size - 3))"
done

echo "Assembly files generated in directory: $output_dir"
