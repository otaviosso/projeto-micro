.global _LED_LIGA
_LED_LIGA:
#prologo
    addi sp, sp, -32
    stw ra, 28(sp)
    stw fp, 24(sp)
    stw r22, 20(sp)
    stw r12, 16(sp)
    stw r13, 12(sp)
    stw r14, 8(sp)
    stw r15, 4(sp)
    stw r4, 0(sp)
    addi fp, sp, 24
###

.equ UART, 0x10001000
.equ LED_R, 0x10000000      # endereco led vermelho
movia r11, UART
movia r12, LED_R

    ldw r4, 20(sp)           # carregar buffer
    ldbu r14, 2(r4)         # r14 = Primeiro NÚMERO (comando)
    ldbu r15, 3(r4)         # r15 = Segundo NÚMERO (comando)
    movi r13, 10
    mul r14, r14, r13
    add r14, r14, r15
 
    movia r13, 0x00000001 # mascara para pegar o led que vai ser ligado
    sll r13, r13, r14
    ldwio r14, (r12)
    or r13, r13, r14      # ligar o led 
    stwio r13, (r12)
    

#epilogo
    ldw ra, 28(sp)
    ldw fp, 24(sp)
    ldw r22, 20(sp)
    ldw r12, 16(sp)
    ldw r13, 12(sp)
    ldw r14, 8(sp)
    ldw r15, 4(sp)
    ldw r4, 0(sp)
    addi sp, sp, 32
    ret
###
