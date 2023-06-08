.section .text
.global _start
.align 4


_start:
    ldr r0, [r1]
    cmp r0, #2
    blne not_enough_arguments
    ldr r0, [r1, #8]
    bl puts
    bl exit


/* void not_enough_arguments(void) */
not_enough_arguments:
    ldr r0, =error_message
    bl puts
    mov r7, #1
    mov r0, #1
    swi #0


/* int puts(char* restrict string) */
puts:
    push { lr }
    push { r1 - r2 }
    mov r7, #4
    mov r1, r0
    bl strlen
    mov r2, r0
    mov r0, #1
    swi #0
    push { r2 }
    ldr r1, =newline
    mov r2, #1
    mov r0, #1
    swi #0
    pop { r0 }
    pop { r1 - r2 }
    pop { pc }


/* int strlen(char* restrict string) */
strlen:
    push { lr }
    push { r1 - r3 }
    mov r1, #0
    bl strlen_loop
    mov r0, r1
    pop { r1 - r3 }
    pop { pc }


strlen_loop:
    add r2, r0, r1
    ldrb r3, [r2]
    cmp r3, #0
    moveq pc, lr
    strb r3, [r2]
    add r1, #1
    b strlen_loop


/* void exit(int code) */
exit:
    mov r7, #1
    swi #0


.section .data

error_message:
    .string "one argument is required. exit."

newline:
    .string "\n"
