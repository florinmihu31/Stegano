%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .text
global main
main:
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    jmp done
    
    ; Bloc ce compara elementul din matrice cu o litera din cuvantul "revient"
cmp_revient:
    inc edx
    inc ecx
    cmp ebx, 'r'
    jne compare_edx_to_img_width
    
    cmp edx, [img_width]
    je reset_edx
    
    mov ebx, [img]
    mov ebx, [ebx + 4 * ecx]
    xor ebx, edi
    
    inc edx
    inc ecx
    cmp ebx, 'e'
    jne compare_edx_to_img_width
    
    cmp edx, [img_width]
    je reset_edx
    
    mov ebx, [img]
    mov ebx, [ebx + 4 * ecx]
    xor ebx, edi
    
    inc edx
    inc ecx
    cmp ebx, 'v'
    jne compare_edx_to_img_width
    
    cmp edx, [img_width]
    je reset_edx
    
    mov ebx, [img]
    mov ebx, [ebx + 4 * ecx]
    xor ebx, edi
    
    inc edx
    inc ecx
    cmp ebx, 'i'
    jne compare_edx_to_img_width
    
    cmp edx, [img_width]
    je reset_edx
    
    mov ebx, [img]
    mov ebx, [ebx + 4 * ecx]
    xor ebx, edi
    
    inc edx
    inc ecx
    cmp ebx, 'e'
    jne compare_edx_to_img_width
    
    cmp edx, [img_width]
    je reset_edx
    
    mov ebx, [img]
    mov ebx, [ebx + 4 * ecx]
    xor ebx, edi
    
    inc edx
    inc ecx
    cmp ebx, 'n'
    jne compare_edx_to_img_width
    
    cmp edx, [img_width]
    je reset_edx
    
    mov ebx, [img]
    mov ebx, [ebx + 4 * ecx]
    xor ebx, edi
    
    inc edx
    inc ecx
    cmp ebx, 't'
    jne compare_edx_to_img_width
    
    cmp edx, [img_width]
    je reset_edx

    mov esi, 1
    jmp compare_edx_to_img_width
    
    ; Functie ce stocheaza in registre valoarea cheii de decriptare si a liniei
    ; pe care a fost gasit mesajul
bruteforce_singlebyte_xor:
    push ebp ; Salvam vechiul base pointer
    mov ebp, esp ; Facem un nou stack frame
        
    ; Salvam in eax numarul de elemente
    mov eax, [img_width]
    mov ecx, [img_height]
    xor edx, edx
    imul ecx
    
    xor ecx, ecx ; Numarul elementului curent din matrice
    xor edi, edi ; Initializam cheia
    xor esi, esi ; Setam flagul de cuvant gasit pe 0

xor_matrix:
    ; Stocam elementul in ebx
    mov ebx, [img]
    mov ebx, [ebx + 4 * ecx]
    
    ; Aplicam cheia
    xor ebx, edi
        
    ; Daca flagul esi nu este setat, trecem la compararea elementelor cu
    ; literele cuvantului "revient"
    cmp esi, 1
    jne cmp_revient
    
    ; Daca am gasit terminatorul de sir, incheiem functia
    cmp ebx, 0
    je return
        
    inc edx ; Incrementam indexul elementului de pe linie
    inc ecx ; Incrementam indexul elementului din vector

compare_edx_to_img_width:
    cmp edx, [img_width]
    jge reset_edx
    
compare_to_matrix_size:
    cmp ecx, eax
    jl xor_matrix
    
    ; Daca dupa o parcurgere nu a fost gasit mesajul, resetam contoarele si
    ; trecem la urmatoarea cheie
    xor ecx, ecx
    xor edx, edx
    inc edi
    cmp edi, 255
    jl xor_matrix
    
return:
    leave ; Restaurarea stivei initiale
    ret
    
; Resetam valoarea contorului edx
reset_edx:
    xor edx, edx
    jmp compare_to_matrix_size

solve_task1:
    ; TODO Task1

    ; Apelam functia bruteforce_singlebyte_xor
    call bruteforce_singlebyte_xor
    
    mov eax, edx ; Salvam in eax indexul la care se termina mesajul
    sub ecx, edx ; Salvam in ecx indexul de la inceputul liniei

    push ecx ; Salvam ecx pe stiva
    xor edx, edx    
    
print_next_char:
    ; Afisam caracter cu caracter
    mov ebx, [img]
    mov ebx, [ebx + 4 * ecx]
    xor ebx, edi
    PRINT_CHAR ebx

    inc edx
    inc ecx
    cmp edx, eax
    jl print_next_char
    NEWLINE
    
    ; Afisam cheia
    PRINT_UDEC 1, edi
    NEWLINE
    
    pop ecx ; Restauram registrul ecx

    ; Calculam in eax linia la care se afla mesajul
    mov eax, ecx
    mov ecx, [img_width]
    xor edx, edx
    div ecx
    
    ; Afisam linia la care se afla mesajul
    PRINT_UDEC 4, eax
    NEWLINE
    
    jmp done

solve_task2:
    ; TODO Task2
    
    ; Apelam functia bruteforce_singlebyte_xor
    call bruteforce_singlebyte_xor
    
    ; Calculam numarul liniei la care se afla mesajul
    mov eax, ecx
    mov ecx, [img_width]
    xor edx, edx
    div ecx
    
    push eax ; Salvam numarul liniei pe stiva
    
    ; Calculam numarul elementelor
    mov eax, [img_width]
    mov ecx, [img_height]
    xor edx, edx
    imul ecx
    
    mov esi, eax ; Salvam numarul elementelor pe stiva in registrul esi
    
    xor edx, edx ; Indexul elementului curent
    
    ; Decriptam toata matricea folosind cheia veche
decrypt_matrix:
    mov ebx, [img]
    xor [ebx + 4 * edx], edi
    
    inc edx

    cmp edx, eax
    jl decrypt_matrix
    
    ; Calculam indexul de la care incepem sa stocam noul mesaj
    pop eax
    inc eax
    xor edx, edx
    imul dword [img_width]
    
    mov edx, eax ; Salvam in edx indexul de la care stocam mesajul

    ; Stocam fiecare litera din mesaj
    mov ebx, [img]
    mov dword [ebx + 4 * edx], 'C'
    inc edx
    
    mov dword [ebx + 4 * edx], "'"
    inc edx
    
    mov dword [ebx + 4 * edx], 'e'
    inc edx
    
    mov dword [ebx + 4 * edx], 's'
    inc edx
    
    mov dword [ebx + 4 * edx], 't'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    inc edx
    
    mov dword [ebx + 4 * edx], 'u'
    inc edx
    
    mov dword [ebx + 4 * edx], 'n'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    inc edx
    
    mov dword [ebx + 4 * edx], 'p'
    inc edx
    
    mov dword [ebx + 4 * edx], 'r'
    inc edx
    
    mov dword [ebx + 4 * edx], 'o'
    inc edx
    
    mov dword [ebx + 4 * edx], 'v'
    inc edx
    
    mov dword [ebx + 4 * edx], 'e'
    inc edx
    
    mov dword [ebx + 4 * edx], 'r'
    inc edx
    
    mov dword [ebx + 4 * edx], 'b'
    inc edx
    
    mov dword [ebx + 4 * edx], 'e'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    inc edx
    
    mov dword [ebx + 4 * edx], 'f'
    inc edx
    
    mov dword [ebx + 4 * edx], 'r'
    inc edx
    
    mov dword [ebx + 4 * edx], 'a'
    inc edx
    
    mov dword [ebx + 4 * edx], 'n'
    inc edx
    
    mov dword [ebx + 4 * edx], 'c'
    inc edx
    
    mov dword [ebx + 4 * edx], 'a'
    inc edx
    
    mov dword [ebx + 4 * edx], 'i'
    inc edx
    
    mov dword [ebx + 4 * edx], 's'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], 0
    inc edx
    
    ; Calculam noua cheie si o stocam in eax
    xor edx, edx
    mov eax, 2
    imul edi
    
    add eax, 3
    
    xor edx, edx
    mov ebx, 5
    div ebx
    
    sub eax, 4
    
    xor edx, edx
    
    ; Criptam intreaga matrice cu noua cheie
crypt_matrix:
    mov ebx, [img]
    xor dword [ebx + 4 * edx], eax
    
    inc edx
    
    cmp edx, esi
    jl crypt_matrix

    ; Apelarea functiei de afisare a matricei
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    
    jmp done
    
morse_encrypt:
    push ebp ; Salvam vechiul base pointer
    mov ebp, esp ; Facem un nou stack frame
    
    push edx ; Stocam valoarea indexului pe stiva
    
    mov ebx, [ebp + 8] ; Salvam in ebx sirul dat ca argument
    
    mov esi, [ebp + 8] ; Salvam in esi sirul ce va fi codificat
    
    pop edx ; Restauram registrul edx
    
    jmp get_element

    ; Codificarea MORSE pentru fiecare litera
morse_code_A:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
       
morse_code_B:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
             
morse_code_C:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_D:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx

    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
       
morse_code_E:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
       
morse_code_F:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_G:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element

morse_code_H:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_I:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx

    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_J:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element

morse_code_K:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_L:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_M:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_N:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element    
    
morse_code_O:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_P:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_Q:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_R:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_S:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_T:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_U:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_V:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_W:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '.'
    inc edx

    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_X:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx

    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx

    mov dword [ebx + 4 * edx], '-'
    inc edx
            
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_Y:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx

    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx

    mov dword [ebx + 4 * edx], '-'
    inc edx
            
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_Z:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx

    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx

    mov dword [ebx + 4 * edx], '.'
    inc edx
            
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element
    
morse_code_comma:
    mov ebx, [img]
    mov dword [ebx + 4 * edx], '-'
    inc edx

    mov dword [ebx + 4 * edx], '-'
    inc edx
    
    mov dword [ebx + 4 * edx], '.'
    inc edx

    mov dword [ebx + 4 * edx], '.'
    inc edx
    
    mov dword [ebx + 4 * edx], '-'
    inc edx

    mov dword [ebx + 4 * edx], '-'
    inc edx
            
    mov dword [ebx + 4 * edx], ' '
    
    inc esi
    jmp next_element

    ; Compararea literei curente cu literele alfabetului                                                                                                                                                          
test_letter:
    
    cmp byte [esi], 'A'
    je morse_code_A
    
    cmp byte [esi], 'B'
    je morse_code_B
    
    cmp byte [esi], 'C'
    je morse_code_C
    
    cmp byte [esi], 'D'
    je morse_code_D
    
    cmp byte [esi], 'E'
    je morse_code_E
    
    cmp byte [esi], 'F'
    je morse_code_F
    
    cmp byte [esi], 'G'
    je morse_code_G
    
    cmp byte [esi], 'H'
    je morse_code_H
    
    cmp byte [esi], 'I'
    je morse_code_I
    
    cmp byte [esi], 'J'
    je morse_code_J
    
    cmp byte [esi], 'K'
    je morse_code_K
    
    cmp byte [esi], 'L'
    je morse_code_L
    
    cmp byte [esi], 'M'
    je morse_code_M
    
    cmp byte [esi], 'N'
    je morse_code_N
    
    cmp byte [esi], 'O'
    je morse_code_O
    
    cmp byte [esi], 'P'
    je morse_code_P
    
    cmp byte [esi], 'Q'
    je morse_code_Q
    
    cmp byte [esi], 'R'
    je morse_code_R
    
    cmp byte [esi], 'S'
    je morse_code_S
    
    cmp byte [esi], 'T'
    je morse_code_T
    
    cmp byte [esi], 'U'
    je morse_code_U
    
    cmp byte [esi], 'V'
    je morse_code_V
    
    cmp byte [esi], 'W'
    je morse_code_W
    
    cmp byte [esi], 'X'
    je morse_code_X
    
    cmp byte [esi], 'Y'
    je morse_code_Y
    
    cmp byte [esi], 'Z'
    je morse_code_Z
    
    cmp byte [esi], ','
    je morse_code_comma
    
    cmp byte [esi], 0
    je add_null_character
    
    inc esi
    jmp next_element

    ; Trecem prin elementele matricii de la indexul curent
get_element:
    mov ebx, [img]
    mov ebx, [ebx + 4 * edx]
    
    jmp test_letter

    ; Sarim la urmatorul element cat timp ecx este mai mare decat 0
next_element:
    inc edx
    jmp get_element
    
    ; Stocam terminatorul de sir
add_null_character:
    dec edx
    mov ebx, [img]
    mov dword [ebx + 4 * edx], 0

    leave ; Restaurarea stivei initiale
    ret
    
solve_task3:
    ; TODO Task3
        
    ; Trecem din ASCII in numarul intreg indexul dat ca argument
    mov eax, [ebp + 12]
    mov ebx, [eax + 16]
    push ebx
    call atoi
    add esp, 4
    
    mov edx, eax ; Salvam in edx indexul
    
    ; Salvam in ebx sirul ce trebuie codificat si apelam functia
    mov eax, [ebp + 12]
    mov ebx, [eax + 12]
    push ebx
    call morse_encrypt
    add esp, 4

    ; Apelarea functiei de afisare a matricei
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12

    jmp done

lsb_encode:
    push ebp ; Salvam vechiul base pointer
    mov ebp, esp ; Facem un nou stack frame
    
    mov eax, [ebp + 8] ; Salvam sirul ce trebuie criptat
    ; Salvam indexul de la care vom incepe criptarea
    mov edx, [ebp + 12]
    dec edx
    ; Salvam in ecx o masca ce ne va ajuta la testarea bitilor
    mov ecx, 0b10000000
    
    mov ebx, [img]
    
    ; Resetam masca in caz de aceasta devine 0
reset_ecx:
    cmp ecx, 0
    jne get_bit
    cmp byte [eax], 0 ; Daca am ajuns la terminatorul de sir oprim functia
    je end_lsb_encode
    inc eax
    mov ecx, 0b10000000
    
    ; Verificam valoarea bitului curent
get_bit:
    mov edi, [eax]
    and edi, ecx

    cmp edi, 0
    je bit_value_0
    jne bit_value_1
    
bit_value_0:
    test dword [ebx + 4 * edx], 1
    jne odd_number ; Testam daca numarul este impar
    inc edx
    shr ecx, 1
    jmp reset_ecx
    
    ; Daca bitul este 0 si numarul este impar decrementam numarul
odd_number:
    dec dword [ebx + 4 * edx]
    inc edx
    shr ecx, 1
    jmp reset_ecx
    
bit_value_1:
    test dword [ebx + 4 * edx], 1
    je even_number ; Testam daca numarul este par
    inc edx
    shr ecx, 1
    jmp reset_ecx
    
    ; Daca bitul este 1 si numarul este par incrementam numarul
even_number:
    inc dword [ebx + 4 * edx]
    inc edx
    shr ecx, 1
    jmp reset_ecx
    
end_lsb_encode:
    leave ; Restaurarea stivei initiale
    ret

solve_task4:
    ; TODO Task4
    
    ; Salvam in ebx sirul ce va fi criptat
    mov eax, [ebp + 12]
    mov ebx, [eax + 12]
    
    ; Salvam in eax indexul de la care vom incepe criptarea
    mov ecx, [eax + 16]
    push ecx
    call atoi
    add esp, 4
    
    ; Apelam functia de criptare LSB
    push eax
    push ebx
    call lsb_encode
    add esp, 8
    
    ; Apelarea functiei de afisare a matricei
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    
    jmp done

lsb_decode:
    push ebp ; Salvam vechiul base pointer
    mov ebp, esp ; Facem un nou stack frame
    
    ; Salvam in edx indexul de la care vom incepe extragerea bitilor
    mov edx, [ebp + 8]
    dec edx
    
decode_new_byte:
    mov ecx, 8 ; Contor folosit la fiecare byte
    xor eax, eax ; Registrul in care vom retine valoarea byte-ului
    
    ; Calculam in eax numarul format la fiecare 8 biti
add_bit:
    mov ebx, [img]
    mov ebx, [ebx + 4 * edx]
    and ebx, 1 ; Stocam ultimul bit
    
    shl eax, 1 ; Shiftam la stanga cu 1
    add eax, ebx ; Adaugam valoarea bitului obtinut
    inc edx
    loop add_bit
    
    ; Daca numarul este diferit de 0, afisam caracterul si continuam procesul
    ; in caz contrar, functia se opreste
    cmp eax, 0
    je end_lsb_decode
    
    PRINT_CHAR eax
    
    jmp decode_new_byte
    
end_lsb_decode:
    NEWLINE

    leave ; Restaurarea stivei initiale
    ret

solve_task5:
    ; TODO Task5
    
    ; Salvam in eax indexul de la care vom extrage mesajul
    mov eax, [ebp + 12]
    mov ecx, [eax + 12]
    push ecx
    call atoi
    add esp, 4
    
    ; Apelam functia de decriptare LSB
    push eax
    call lsb_decode
    add esp, 4
    
    jmp done

blur:
    push ebp ; Salvam vechiul base pointer
    mov ebp, esp ; Facem un nou stack frame
    
    mov esi, 5 ; Valoarea la care vom imparti suma elementelor
    mov edx, [img_width]
    inc edx ; Stocam in edx indexul de la care vom incepe parcurgerea
    mov ecx, 2 ; Numarul coloanei in care se afla elementul
    mov edi, 2 ; Numarul liniei in care se afla elementul
    
compute_new_element:
    ; Daca numarul coloanei este 1, trecem la urmatorul element
    cmp ecx, 1
    je get_next_element
    
    ; Daca ne aflam pe ultima coloana, trecem la urmatorul element
    cmp ecx, [img_width]
    je get_next_element

    ; Stocam in eax elementul curent
    mov ebx, [ebp + 8]
    mov eax, [ebx + 4 * edx]
    
    ; Stocam in eax suma elementelor vecine
    add eax, [ebx + 4 * edx - 4]
    add eax, [ebx + 4 * edx + 4]
    
    sub edx, [img_width]
    add eax, [ebx + 4 * edx]
    
    add edx, [img_width]
    add edx, [img_width]
    add eax, [ebx + 4 * edx]
    
    sub edx, [img_width]
    
    ; Impartim suma elementelor vecine la 5
    push edx
    xor edx, edx
    div esi
    pop edx
    
    ; Salvam noua valoare pe stiva
    push eax

get_next_element:   
    inc edx
    inc ecx
    
    ; Trecem la urmatoare coloana
    cmp ecx, [img_width]
    jl compute_new_element

    ; Trecem la urmatoarea linie
    mov ecx, 1
    inc edx
    inc edi
    cmp edi, [img_height]
    jl compute_new_element
    
    ; Parcurgerea in ordine inversa a matricei
    ; Calculam numarul total de elemente
    mov ebx, [ebp + 8]
    mov eax, [img_width]
    mov ecx, [img_height]
    xor edx, edx
    imul ecx
    
    ; Salvam in edx indexul ultimului element
    mov edx, eax
    dec edx

    mov ecx, [img_width] ; Salvam numarul coloanei
    mov edi, [img_height] ; Salvam nuamrul liniei
    
store_new_values:
    ; Daca ne aflam pe prima coloana, trecem la urmatorul element
    cmp ecx, 1
    je get_the_next_element
    
    ; Daca ne aflam pe ultima coloana, trecem la urmatorul element
    cmp ecx, [img_width]
    je get_the_next_element
    
    ; Daca ne aflam pe ultima linie trecem la urmatorul element
    cmp edi, [img_height]
    je get_the_next_element
    
    ; Stocam ultima valoare de pe stiva in matrice
    mov ebx, [ebp + 8]
    pop eax
    mov [ebx + 4 * edx], eax

get_the_next_element:  
    dec edx
    dec ecx
    
    ; Cat timp numarul coloanei este mai mare decat 1, trecem la urmatorul element
    cmp ecx, 1
    jg store_new_values
    
    ; Trecem la urmatoarea linie cat timp edi este mai mare decat 1
    mov ecx, [img_width]
    dec edx
    dec edi
    cmp edi, 1
    jg store_new_values
    
    leave ; Restaurarea stivei initiale
    ret

solve_task6:
    ; TODO Task6
    
    push dword [img]
    call blur
    add esp, 4
    
    ; Apelarea functiei de afisare a matricei
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    
