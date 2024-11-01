bits 32 ;assembling for the 32 bits architecture
global start 
; we ask the assembler to give global visibility to the symbol called start
;(the start label will be the entry point in the program)
extern exit ; we inform the assembler that the exit symbol is foreign; it exists even if we won't be
import exit msvcrt.dll ; we specify the external library that defines the symbol
 ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
; our variables are declared here (the segment is called data)
segment data use32 class=data


    a db -3          ; 8-bit signed byte
    b db 9          ; 8-bit signed byte
    c db 5           ; 8-bit signed byte
    d dw 10          ; 16-bit signed word

 
; ...
; the program code will be part of a segment called code
segment code use32 class=code
start:
; [(d/2)*(c+b)-a*a]/b

    movsx eax, word [d]   ; eax=d 
    mov ebx, 2            ;
    cdq                   ; eax->edx:eax,Doubleword to Quadword
    idiv ebx              ; EAX = d / 2

  
    movsx ebx, byte [b]   ;  ebx = b
    movsx ecx, byte [c]   ; ecx = c
    add ecx, ebx          ; ecx = c + b

    
    imul eax, ecx         ; eax = (d/2) * (c + b)

   
    movsx edx, byte [a]   ;  edx= a
    imul edx, edx         ; edx = a * a

  
    sub eax, edx          ; eax= (d/2)*(c + b) - a*a

    
    movsx ebx, byte [b]   ;  ebx=b
    cdq                   ; Doubleword to Quadword
    idiv ebx              ; eax = eax / b 

 
; ...
;here we will write the instructions to solve the problem
 ; call exit(0) ), 0 represents status code: SUCCESS
 push dword 0 ; saves on stack the parameter of the function exit
 call [exit] ; function exit is called in order to end the execution of the program
