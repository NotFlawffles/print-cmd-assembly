.section .data

usage_message:
    .string "Expected only 1 argument.\n"


newline:
    .string "\n"

.section .text
.global _start


// int _start(void **__args)
_start:
    ldr r0, [sp]
    cmp r0, #2
    bne usage
    ldr r0, [r1, #8]
    bl print
    ldr r0, =newline
    bl print
    mov r0, #0 // exit code (0)
    bl exit


// void usage(void)
usage:
    ldr r0, =usage_message
    bl print
    mov r0, #1
    bl exit


// unsigned int print(char *string)
print:
    push { lr }
    push { r1 - r3 }
    mov r7, #4
    mov r1, r0
    bl length
    mov r2, r0
    mov r0, #1
    swi #0
    mov r0, #0
    pop { r1 - r3 }
    pop { pc }


// unsigned int length(char *string)
length:
    push { lr }
    push { r1 - r3 }
    mov r2, #0
    bl length_loop
    mov r0, r2
    pop { r1 - r3 }
    pop { pc }


length_loop:
    add r1, r2, r0
    ldrb r3, [r1]
    cmp r3, #0
    moveq pc, lr
    add r2, r2, #1
    b length_loop


// void exit(int code)
exit:
    mov r7, #1
    swi #0
