global _start;
[bits 32]

_start:
    [extern my_start_kernel] ; Define calling point. Must have same name as kernel.c 'main' function
    call my_start_kernel ; Calls the C function. The linker will know where it is placed in memory
    jmp $