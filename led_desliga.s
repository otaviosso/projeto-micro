.global _LED_DESLIGA
_LED_DESLIGA:
### prologo
    addi sp, sp, -28
    stw ra, 24(sp)
    stw fp, 20(sp)
    stw r22, 16(sp)
    stw r12, 12(sp)
    stw r13, 8(sp)
    stw r14, 4(sp)
    stw r15, 0(sp)
    addi fp, sp, 20
###

.equ LED_R, 0x10000000
.equ UART, 0x10001000

movia r11, UART
movia r12, LED_R

    ldw r4, 16(sp)
    ldbu r14, 2(r4)         # r14 = Primeiro NÚMERO (comando)
    ldbu r15, 3(r4)         # r15 = Segundo NÚMERO (comando)
    movi r13, 10
    mul r14, r14, r13
    add r14, r14, r15
 
    movia r13, 0x00000001   # mascara para pegar o led que vai ser desligado
    sll r13, r13, r14
    ldwio r14, (r12)
    nor r13, r13,r13
    and r13, r13, r14       # desligar o led
    stwio r13, (r12)
    
### epilogo

    ldw ra, 24(sp)
    ldw fp, 20(sp)
    ldw r22, 16(sp)
    ldw r12, 12(sp)
    ldw r13, 8(sp)
    ldw r14, 4(sp)
    ldw r15, 0(sp)
    addi sp, sp, 28
###
    ret
###
