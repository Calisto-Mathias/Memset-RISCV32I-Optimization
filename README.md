# Overall Comparison Between the Unoptimized and Optimized `memset` Definitions

This optimization in the `memset` function results in a **75% reduction** in the number of instructions required by the RISC-V CPU to perform a `memset` operation. The key factor behind this improvement lies in handling memory in multiples of 4 bytes. When the number of bytes to be set is divisible by 4, the algorithm uses word-sized operations, allowing the CPU to set multiple bytes at once, significantly reducing the total number of iterations and instructions. This approach minimizes the overhead involved in checking and setting individual bytes, especially in cases where memory is aligned, resulting in faster and more efficient execution.

---

## Unoptimized `memset` Function Execution

The unoptimized `memset` function performs the following operations:

- `mv t1, a0`: 1 instruction  
- `beqz a2, 2f`: 1 instruction (conditional branch)  
- Inside the loop (when n > 0):
  - `sb a1, 0(t1)`: 1 instruction  
  - `add a2, a2, -1`: 1 instruction  
  - `add t1, t1, 1`: 1 instruction  
  - `bnez a2, 1b`: 1 instruction (branch if `a2 != 0`)  
- After the loop:
  - `ret`: 1 instruction (return)

The total number of instructions executed depends on the value of `n`, the number of bytes to be set:

### Number of Instructions

- When `n > 0`, the setup instructions (2 instructions) are executed, the loop runs for `n` iterations (4 instructions per iteration), and the return instruction is executed once.  
  Thus, the total number of instructions is:  
  `f(n) = 3 + 4n` for `n > 0`  

- When `n = 0`, only the setup instructions (2 instructions) and the return instruction are executed.  
  Thus, the total number of instructions is:  
  `f(0) = 3`

---

## Definition of `f(n)` for the Unoptimized `memset`

The number of instructions run by the unoptimized `memset` function is:

`f(n) = 3 + 4n`

---

## Case-wise Study of the Optimized `memset` Function

The optimized `memset` function can be analyzed in different cases based on the value of the register `a2`, which stores the number of bytes to be set in memory. Below, we will provide explanations for two cases: when `a2` is zero and when `a2` is less than 7.

### Case 1: `a2` is 0

In this case, the value of `a2` is zero, meaning no bytes need to be set. The function executes as follows:

- The first branching condition `beqz a2, end` is executed, which checks if `a2` is zero. Since it is zero, the function immediately jumps to the `end` label.  
- Only the return instruction `ret` is executed after the jump.

Hence, the total number of instructions executed is 2, consisting of:  
`f(0) = 2`

---

### Case 2: The Number of Bytes to be Set is Less than 7

In this case, the number of bytes to be set (`a2`) is less than 7, so the following sequence of instructions is executed:

- The first branching instruction `blt t2, t3, set byte in memory` is evaluated. Since `a2` is less than 7, this results in no branching, and the code continues to the next section. This is the first instruction executed.
- The temporary registers are then set, which involves **4 instructions** under the `set temporary registers` label.
- The branching instruction `blt t2, t3, set byte in memory` is executed again, which branches to the `set byte in memory` label.
- The `set byte in memory` label runs a loop, where **4 instructions** are executed for each byte set. This loop runs for each byte, so for `n` bytes, the total number of instructions is `4n`.
- Finally, the function executes a `ret` instruction to return.

Therefore, the total number of instructions executed in this case is:  
`f(n) = 1 + 4 + 1 + 4n + 1 = 7 + 4n`  
`f(n) = 7 + 4n`

---

### Case 3: Memory is aligned and Number of Bytes is `4α + β` where `β < 4`

We analyze the total number of instructions executed, `f(n)`, for the provided assembly program in the following scenario:

- The starting address is aligned to a 4-byte memory boundary.  
- The number of bytes to set is expressed as `4α + β`, where `β < 4`.

---

#### Total Instruction Count

Summing up all the instructions:  

`f(n) = 1 + 4 + 5 + 7 + (4α + 1) + 4β + 1`  
Simplifying:  
`f(n) = 4α + 4β + 19`

---

### Final Piecewise Definition of `f(n)`

```math
f(n) =
\begin{cases} 
2 & \text{if } n = 0, \\
7 + 4n & \text{if } n < 7, \\
4 \lfloor \frac{n}{4} \rfloor + 4(n \bmod 4) + 19 & \text{if } n \geq 7.
\end{cases}
