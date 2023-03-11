section .data

section .bss
    input   resb 8
    upper   resb 4
    lower   resb 4
    isprime resb 1

section .text
    global _start


; ~~ RUNS THE PROGRAM ~~
_start:
    call    _getInput
    call    _getNum
    mov     dword[lower], 2 ; Set 'lower' as outer loop count [2]
outerLoop:
    mov     edx, [lower]    ; Copy lower to D register for comparison
    cmp     edx, [upper]    ; Compare lower to upper bound
    ja      outerEnd        ; Jump to end if lower is greater
    mov     byte[isprime], 1; Set prime flag to true [1]
    mov     ecx, 2          ; Set register C as inner loop count [2]
innerLoop:
    mov     edx, ecx        ; Copy C value to D register
    imul    edx, ecx        ; Multiply D by C for comparison
    cmp     edx, [lower]    ; Compare lower bound to D count
    jae     innerEnd        ; Jump to inner end if lower is greater
innerEnd:

outerEnd: 
    call    _test
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
    xor     ebx, ebx        ; Clear B register to store int
    mov     ecx, input      ; Use C register to store string
parseLoop:
    movzx   eax, byte[ecx]  ; Store next character to register A
    cmp     al, 0           ; Compare value in A to null [0000 0000]
    je      done            ; Jump to end if match
    sub     al, '0'         ; Convert char in A to digit
    imul    ebx, 10         ; Shift num in B by a tenth
    add     ebx, eax        ; Add digit in A to B
    inc     ecx             ; Increment C register by one
    jmp     parseLoop       ; Jump to beginning of loop again
done:
    mov     [upper], ebx    ; Move integer in B to memory address of 'upper'
    ret

    
_test:
    mov eax, 1
    mov edi, 1
    mov esi, isprime
    mov edx, 1
    syscall
    mov esi, isprime
    mov edx, 1
    syscall
    ret