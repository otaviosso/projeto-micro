.global _CRONOMETRO_DESLIGA

#logica de pausa
#desligar???
_CRONOMETRO_DESLIGA:
 #prologo
    addi sp, sp, -16
    stw ra, 12(sp)
    stw fp, 8(sp)
    stw r11, 4(sp)
    stw r22, 0(sp)
    addi fp, sp, 8
    ###
    .equ SEG7, 0x10000020
    movia r11, SEG7 # endereco dos 7seg
    ldw r22, (r0)
    stwio r22, (r11) # salvando 7seg     

#epilogo

    ldw ra, 12(sp)
    ldw fp, 8(sp)
    ldw r11, 4(sp)
    ldw r22, 0(sp)
    addi sp, sp, 16
    ###
ret

.org 0x500
NUMBERS:
.byte 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f # numeros 7 seg 0 - 9


END:
    br END
.end


