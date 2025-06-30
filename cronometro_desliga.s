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

    movia r16, UNI_VALUE
    stb r0, (r16)

    movia r16, DEZ_VALUE
    stb r0, (r16)

    movia r16, CENT_VALUE
    stb r0, (r16)

    movia r16, MIL_VALUE
    stb r0, (r16)
#epilogo

    ldw ra, 12(sp)
    ldw fp, 8(sp)
    ldw r11, 4(sp)
    ldw r22, 0(sp)
    addi sp, sp, 16
    ###
ret

.org 0x500


END:
    br END
.end

