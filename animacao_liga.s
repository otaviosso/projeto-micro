

.global _ANIMACAO_LIGA
.equ LED_R, 0x10000000      # endereco led vermelho
_ANIMACAO_LIGA:
# prologo
###
    addi sp, sp, -28
    stw ra, 24(sp)
    stw fp, 20(sp)
    stw r18, 16(sp)
    stw r14, 12(sp)
    stw r15, 8(sp)
    stw r16, 4(sp)
    stw r17, 0(sp)
    addi fp, sp, 20
###

    movia r15, LED_R 
    movia r14, 0x10000040 # ENDERECO dos switches
    ldwio r14, (r14)
    andi r14, r14, 0x01 # separa o sw0

    #se nenhum led aceso, acende um led
    ldwio r16, (r15)
    bne r16, r0, ZERO_
    movia r17, 0b10000000
    stwio r17, (r15)
ZERO_:
    beq r14, r0, DIREITA # acende sentido direita
    br ESQUERDA # acende sentido esquerda

DIREITA:
    ldwio r16, (r15)
    movi r18, 0x1
    bne r16, r18, CA 
    movia r17, 0b100000000000000000
    stwio r17, (r15)
    br SAI_ANIMACAO 
CA:
    srli r16,r16, 0x1
    stwio r16, (r15) 

    br SAI_ANIMACAO


ESQUERDA:
    ldwio r16 ,(r15)
    movia r18, 0b100000000000000000
    bne r16, r18, LA 
    movia r17, 0b000000000000000001
    stwio r17, (r15) 
    br SAI_ANIMACAO
LA:
    slli r16,r16, 0x1
    stwio r16, (r15) 

SAI_ANIMACAO:
### epilogo
    ldw ra, 24(sp)
    ldw fp, 20(sp)
    ldw r18, 16(sp)
    ldw r14, 12(sp)
    ldw r15, 8(sp)
    ldw r16, 4(sp)
    ldw r17, 0(sp)
    addi sp, sp, 28
###
ret
