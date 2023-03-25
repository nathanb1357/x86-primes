section .data
    format  db ", ", 2

section .bss
    input   resb 8
    upper   resb 4
    lower   resb 4
    isprime resb 1
    buffer  resb 8

section .text
    global _start

; ~~ RUNS THE PROGRAM ~~
_start:
    call    _getInput
    call    _getNum
    mov     dword[lower], 2 ; Set 'lower' as outer loop count [2]
outerLoop:
    mov     edx, [lower]    ; Copy 'lower' to D register for comparison
    cmp     edx, [upper]    ; Compare 'lower' to upper bound
    ja      end             ; Jump to end if 'lower' is greater
    mov     byte[isprime], 1; Set 'isprime' to true [1]
    mov     ecx, 2          ; Set register C as inner loop count [2]
innerLoop:
    mov     edx, ecx        ; Copy C value to D register
    imul    edx, ecx        ; Multiply D by C for comparison
    cmp     edx, [lower]    ; Compare 'lower' to register D
    ja      innerEnd        ; Jump to inner end if greater
    call    _checkDiv       ; Set 'isprime' to 0 if divisible
    inc     ecx             ; Increment C count by 1
    jmp     innerLoop       ; Jump to inner loop start
innerEnd:
    cmp     byte[isprime], 1; Check if 'isprime' is true [1]
    jne     outerEnd        ; Increment if not equal
    call    _printNum       ; Print 'lower' if prime
outerEnd:
    inc     dword[lower]    ; Increment outer count by 1
    jmp     outerLoop       ; Jump to outer loop start
end:
    mov     eax, 60         ; Set syscall to 60 [EXIT]
    mov     edi, 0          ; Set exit code
    syscall


; ~~ READS USER INPUT NUMBER ~~
_getInput:
    mov     eax, 0          ; Set syscall to 0 [READ]
    mov     edi, 0          ; Set file descriptor to 0
    mov     esi, input      ; Set input to be used as buffer
    mov     edx, 8          ; Set number of bytes to be read
    syscall
    ret


; ~~ CONVERTS INPUT STRING TO INTEGER ~~
_getNum:
    mov     ebx, 0          ; Clear B register to store int
    mov     ecx, input      ; Use C register to store string
parseLoop:
    movzx   eax, byte[ecx]  ; Store next character to register A
    cmp     al, 0           ; Compare value in A to null [0000 0000]
    je      numEnd          ; Jump to end if match
    sub     al, '0'         ; Convert char in A to digit
    imul    ebx, 10         ; Shift num in B by a tenth
    add     ebx, eax        ; Add digit in A to B
    inc     ecx             ; Increment C register by one
    jmp     parseLoop       ; Jump to beginning of loop again
numEnd:
    mov     [upper], ebx    ; Move integer in B to memory address of 'upper'
    ret


; ~~ CHECKS IF TWO NUMBERS ARE DIVISIBLE ~~
_checkDiv:
    mov     eax, [lower]    ; Copy value in 'lower' to register A for division
    cdq                     ; Zero extend value in register A
    idiv    ecx             ; Divide value in A with value in C, storing the remainder in D
    cmp     edx, 0          ; Compare remainder with 0
    jne     divEnd          ; Jump to end if not equal
    mov     byte[isprime], 0; Set 'isprime' to 0
divEnd:
    ret


; ~~ PRINTS A NUMBER TO THE OUTPUT ~~
_printNum:
    mov     eax, 1
    mov     edi, 1
    mov     esi, lower
    mov     edx, 2
    syscall
    mov     eax, 1
    mov     edi, 1
    mov     esi, format
    mov     edx, 2
    syscall
    ret


; ~~ CONVERTS NUMBER TO A STRING ~~
_getString:
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    rsi
    mov     rbx, 10         ; Set divisor to 10 for decimal conversion
    mov     rsi, rdi        ; Move the address of the buffer to RSI
    mov     rdx, 0          ; Clear RDX register for division
convertLoop:
    xor     rdx, rdx        ; Clear RDX register for division
    div     rbx             ; Divide RAX by RBX
    add     rdx, '0'        ; Add ASCII '0' to remainder to get ASCII digit
    mov     byte[rsi], dl   ; Store the digit in the buffer
    inc     rsi             ; Move the buffer pointer
    test    rax, rax        ; Check if RAX is zero
    jnz     convertLoop     ; Jump if not zero
    mov     byte[rsi], 0    ; Store null terminator
    pop     rsi             ; Restore RSI register
    pop     rbx             ; Restore RBX register
    mov     rsp, rbp        ; Restore the stack pointer
    pop     rbp             ; Restore the base pointer
    ret                     ; Return from function