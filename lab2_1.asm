bits 32 ;assembling for the 32 bits architecture
global start 
; we ask the assembler to give global visibility to the symbol called start
;(the start label will be the entry point in the program)
extern exit ; we inform the assembler that the exit symbol is foreign; it exists even if we won't be
import exit msvcrt.dll ; we specify the external library that defines the symbol
 ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
; our variables are declared here (the segment is called data)
segment data use32 class=data
;(a+b)/(2-b*b+b/c)-x

    a dd 3
    b db -4          
    c db 2           
    x dq 10         

 
; ...
; the program code will be part of a segment called code
segment code use32 class=code
start:
    ;a+b
    mov eax, [a]     ; EAX = a 
    movsx ebx, byte [b]  ; EBX = b
    add eax, ebx     ; EAX = a + b
    mov edx, eax     ; EDX = a + b

    ;b * b
    movsx ecx, byte [b]  ; ECX = b
    imul ecx, ecx        ; ECX = b * b

    ; Load b into EAX and c into a temporary register 
    movsx eax, byte [b]  ; EAX = b 
    movsx ebx, byte [c]  ; EBX = c 

    ; Divide b by c: EAX = b, EBX = c 
    cdq                  ; EAX -> EDX:EAX
    idiv ebx             ; EAX = b / c

    ;b * b + (b / c) into ECX
    add ecx, eax         ; ECX = b * b + (b / c)

    ; Calculate 2 - (b * b + b / c)
    mov eax, 2           ; EAX = 2
    sub eax, ecx         ; EAX = 2 - (b * b + b / c)

    ; (a + b) / (2 - b * b + b / c)
    mov ebx, eax         ; EBX = 2 - (b * b + b / c) 
    mov eax, edx         ; EAX = a + b 
    cdq                  ; EAX -> EDX:EAX 
    idiv ebx             ; EAX = (a + b) / (2 - b * b + b / c)

    mov ecx, dword [x] 

    sub eax, ecx         ; EAX = (a + b) / (2 - b * b + b / c) - x

    
; ...
;here we will write the instructions to solve the problem
 ; call exit(0) ), 0 represents status code: SUCCESS
 push dword 0 ; saves on stack the parameter of the function exit
 call [exit] ; function exit is called in order to end the execution of the program