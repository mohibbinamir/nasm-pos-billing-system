; ============================================================
; Mini Point of Sales Billing System
; Module: Computer System Low Level Techniques
; Assembler: NASM
; Architecture: x86 32-bit Linux
; ============================================================

section .data
    titleMsg db 10, "===== MINI POS BILLING SYSTEM =====", 10
    titleLen equ $ - titleMsg

    menuMsg db 10, "1. Burger        - RM5.00", 10
            db "2. Fries         - RM3.00", 10
            db "3. Drink         - RM2.00", 10
            db "4. Chicken Wrap  - RM7.00", 10
            db "5. Coffee        - RM4.00", 10
            db "6. Ice Cream     - RM3.50", 10
            db "7. Checkout", 10
            db "8. Exit", 10
            db "Enter your choice: "
    menuLen equ $ - menuMsg

    qtyMsg db "Enter quantity: "
    qtyLen equ $ - qtyMsg

    addedMsg db "Item added. Current subtotal: RM"
    addedLen equ $ - addedMsg

    invalidMsg db "Invalid choice. Please try again.", 10
    invalidLen equ $ - invalidMsg

    checkoutMsg db 10, "===== FINAL BILL =====", 10
    checkoutLen equ $ - checkoutMsg

    subtotalMsg db "Subtotal: RM"
    subtotalLen equ $ - subtotalMsg

    discountMsg db 10, "Discount: RM"
    discountLen equ $ - discountMsg

    taxMsg db 10, "Tax 6%: RM"
    taxLen equ $ - taxMsg

    totalMsg db 10, "Final Total: RM"
    totalLen equ $ - totalMsg

    thanksMsg db 10, "Thank you for using the POS system!", 10
    thanksLen equ $ - thanksMsg

    exitMsg db 10, "Program exited.", 10
    exitLen equ $ - exitMsg

    newline db 10
    dot db "."
    zero db "0"

section .bss
    inputBuffer resb 16
    numBuffer resb 12

    subtotal resd 1
    discount resd 1
    tax resd 1
    finalTotal resd 1

section .text
    global _start

; ------------------------------------------------------------
; Macro to print messages
; ------------------------------------------------------------
%macro PRINT 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

; ------------------------------------------------------------
; Program starts here
; ------------------------------------------------------------
_start:
    mov dword [subtotal], 0
    mov dword [discount], 0
    mov dword [tax], 0
    mov dword [finalTotal], 0

main_menu:
    PRINT titleMsg, titleLen
    PRINT menuMsg, menuLen

    call read_int

    cmp eax, 1
    je order_burger

    cmp eax, 2
    je order_fries

    cmp eax, 3
    je order_drink

    cmp eax, 4
    je order_wrap

    cmp eax, 5
    je order_coffee

    cmp eax, 6
    je order_icecream

    cmp eax, 7
    je checkout

    cmp eax, 8
    je exit_program

    PRINT invalidMsg, invalidLen
    jmp main_menu

; ------------------------------------------------------------
; Burger price = RM5.00 = 500 cents
; ------------------------------------------------------------
order_burger:
    PRINT qtyMsg, qtyLen
    call read_int

    mov ebx, 500
    mul ebx

    add [subtotal], eax

    PRINT addedMsg, addedLen
    mov eax, [subtotal]
    call print_money
    PRINT newline, 1

    jmp main_menu

; ------------------------------------------------------------
; Fries price = RM3.00 = 300 cents
; ------------------------------------------------------------
order_fries:
    PRINT qtyMsg, qtyLen
    call read_int

    mov ebx, 300
    mul ebx

    add [subtotal], eax

    PRINT addedMsg, addedLen
    mov eax, [subtotal]
    call print_money
    PRINT newline, 1

    jmp main_menu

; ------------------------------------------------------------
; Drink price = RM2.00 = 200 cents
; ------------------------------------------------------------
order_drink:
    PRINT qtyMsg, qtyLen
    call read_int

    mov ebx, 200
    mul ebx

    add [subtotal], eax

    PRINT addedMsg, addedLen
    mov eax, [subtotal]
    call print_money
    PRINT newline, 1

    jmp main_menu

; ------------------------------------------------------------
; Chicken Wrap price = RM7.00 = 700 cents
; ------------------------------------------------------------
order_wrap:
    PRINT qtyMsg, qtyLen
    call read_int

    mov ebx, 700
    mul ebx

    add [subtotal], eax

    PRINT addedMsg, addedLen
    mov eax, [subtotal]
    call print_money
    PRINT newline, 1

    jmp main_menu

; ------------------------------------------------------------
; Coffee price = RM4.00 = 400 cents
; ------------------------------------------------------------
order_coffee:
    PRINT qtyMsg, qtyLen
    call read_int

    mov ebx, 400
    mul ebx

    add [subtotal], eax

    PRINT addedMsg, addedLen
    mov eax, [subtotal]
    call print_money
    PRINT newline, 1

    jmp main_menu

; ------------------------------------------------------------
; Ice Cream price = RM3.50 = 350 cents
; ------------------------------------------------------------
order_icecream:
    PRINT qtyMsg, qtyLen
    call read_int

    mov ebx, 350
    mul ebx

    add [subtotal], eax

    PRINT addedMsg, addedLen
    mov eax, [subtotal]
    call print_money
    PRINT newline, 1

    jmp main_menu

; ------------------------------------------------------------
; Checkout calculation
; Discount: 10% if subtotal >= RM50.00
; Tax: 6% after discount
; ------------------------------------------------------------
checkout:
    PRINT checkoutMsg, checkoutLen

    PRINT subtotalMsg, subtotalLen
    mov eax, [subtotal]
    call print_money

    ; If subtotal is less than RM50.00, no discount
    ; RM50.00 = 5000 cents
    mov eax, [subtotal]
    cmp eax, 5000
    jl no_discount

    ; discount = subtotal / 10
    xor edx, edx
    mov ebx, 10
    div ebx
    mov [discount], eax
    jmp calculate_tax

no_discount:
    mov dword [discount], 0

calculate_tax:
    PRINT discountMsg, discountLen
    mov eax, [discount]
    call print_money

    ; amount after discount = subtotal - discount
    mov eax, [subtotal]
    sub eax, [discount]

    ; tax = amount after discount * 6 / 100
    mov ebx, 6
    mul ebx

    xor edx, edx
    mov ebx, 100
    div ebx

    mov [tax], eax

    PRINT taxMsg, taxLen
    mov eax, [tax]
    call print_money

    ; final total = subtotal - discount + tax
    mov eax, [subtotal]
    sub eax, [discount]
    add eax, [tax]
    mov [finalTotal], eax

    PRINT totalMsg, totalLen
    mov eax, [finalTotal]
    call print_money

    PRINT thanksMsg, thanksLen

    jmp exit_program_no_msg

; ------------------------------------------------------------
; Read integer input from keyboard
; Converts ASCII input into integer
; Result is returned in EAX
; ------------------------------------------------------------
read_int:
    mov eax, 3
    mov ebx, 0
    mov ecx, inputBuffer
    mov edx, 16
    int 0x80

    mov esi, inputBuffer
    xor eax, eax

parse_loop:
    mov bl, [esi]

    cmp bl, 10
    je parse_done

    cmp bl, 13
    je parse_done

    cmp bl, '0'
    jb parse_done

    cmp bl, '9'
    ja parse_done

    sub bl, '0'

    imul eax, eax, 10
    movzx ebx, bl
    add eax, ebx

    inc esi
    jmp parse_loop

parse_done:
    ret

; ------------------------------------------------------------
; Print integer stored in EAX
; ------------------------------------------------------------
print_int:
    mov edi, numBuffer + 11
    mov byte [edi], 0

    cmp eax, 0
    jne convert_loop

    dec edi
    mov byte [edi], '0'
    mov ecx, edi
    mov edx, 1
    call write_buffer
    ret

convert_loop:
    mov ebx, 10
    xor ecx, ecx

digit_loop:
    xor edx, edx
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl

    inc ecx

    cmp eax, 0
    jne digit_loop

    mov edx, ecx
    mov ecx, edi
    call write_buffer
    ret

; ------------------------------------------------------------
; Print money value
; Example: 550 cents becomes 5.50
; EAX contains amount in cents
; ------------------------------------------------------------
print_money:
    xor edx, edx
    mov ebx, 100
    div ebx

    push edx

    call print_int

    PRINT dot, 1

    pop eax
    call print_two_digits

    ret

; ------------------------------------------------------------
; Print two digits after decimal point
; This fixes values like RM0.00 and RM10.00 correctly
; ------------------------------------------------------------
print_two_digits:
    cmp eax, 10
    jae print_cent_value

    push eax
    PRINT zero, 1
    pop eax

print_cent_value:
    call print_int
    ret

; ------------------------------------------------------------
; Write buffer to screen
; ECX = message address
; EDX = message length
; ------------------------------------------------------------
write_buffer:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

; ------------------------------------------------------------
; Exit with message
; ------------------------------------------------------------
exit_program:
    PRINT exitMsg, exitLen
    mov eax, 1
    xor ebx, ebx
    int 0x80

; ------------------------------------------------------------
; Exit without extra message after checkout
; ------------------------------------------------------------
exit_program_no_msg:
    mov eax, 1
    xor ebx, ebx
    int 0x80
