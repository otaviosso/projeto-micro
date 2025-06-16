.global _CRONOMETRO_LIGA

#logica de pausa
#desligar???
_CRONOMETRO_LIGA:
#prologo
    addi sp, sp, -36
    stw ra, 32(sp)
    stw fp, 28(sp)
    stw r11, 24(sp)
    stw r12, 20(sp)
    stw r13, 16(sp)
    stw r15, 12(sp)
    stw r16, 8(sp)
    stw r17, 4(sp)
    stw r18, 0(sp)
    addi fp, sp, 28
###
.equ SEG7,   0x10000020
/*
.equ KEY,    0x10000050

    movia r13, KEY
    movia r12, PAUSA_CRONO
    movia r14, 0b10
    ldwio r13, (r13)
    andi r13, r13, 0b10
*/
    ldw r13, 16(sp)
    bne r13, r14, NAO_ZERAR
    ldb r12, (r12)
    beq r12, r14, DRAW

NAO_ZERAR:
    movia r12, UNI_VALUE #incrementando crono_value
    ldb r13, (r12)          #pega valor UNIDADE
    movia r11, 0x9

    beq r11, r13, TRANSBORDA_UNI
    addi r13, r13, 0x1 
    stb r13, (r12)
    br DRAW

TRANSBORDA_UNI:
    stb r0, (r12)
    movia r12, DEZ_VALUE
    ldb r13, (r12)
    beq r11, r13, TRANSBORDA_DEZ

    addi r13, r13, 0x1 
    stb r13, (r12)
    br DRAW

TRANSBORDA_DEZ:
    stb r0, (r12)
    movia r12, CENT_VALUE #incrementando crono_value
    ldb r13, (r12)          #pega valor UNIDADE
    movia r11, 0x9

    beq r11, r13, TRANSBORDA_CENT
    addi r13, r13, 0x1 
    stb r13, (r12)
    br DRAW

TRANSBORDA_CENT:
    stb r0, (r12)
    movia r12, MIL_VALUE #incrementando crono_value
    ldb r13, (r12)          #pega valor UNIDADE
    movia r11, 0x9

    beq r11, r13, TRANSBORDA_MIL
    addi r13, r13, 0x1 
    stb r13, (r12)
    br DRAW

TRANSBORDA_MIL:
    movia r12, MIL_VALUE
    stb r0, (r12) 

    movia r12, CENT_VALUE
    stb r0, (r12)

    movia r12, DEZ_VALUE
    stb r0, (r12)

    movia r12, UNI_VALUE
    stb r0, (r12)

DRAW:


    movia r11, SEG7 # endereco dos 7seg
    movia r15, NUMBERS


    movia r16, UNI_VALUE
    ldb r16, (r16)
    add r17, r16, r15 #qual NUMBERS vamos pegar
    ldb r18, (r17)

    movia r16, DEZ_VALUE
    ldb r16, (r16)
    add r17, r16, r15 #qual NUMBERS vamos pegar
    ldb r19, (r17)
    slli r19, r19, 0x8
    or r18, r18, r19

    movia r16, CENT_VALUE
    ldb r16, (r16)
    add r17, r16, r15 #qual NUMBERS vamos pegar
    ldb r19, (r17)
    slli r19, r19, 16
    or r18, r18, r19

    movia r16, MIL_VALUE
    ldb r16, (r16)
    add r17, r16, r15 #qual NUMBERS vamos pegar
    ldb r19, (r17)
    slli r19, r19, 24
    or r18, r18, r19
    /*    
    
    ldb r22, (r15)      #r22 = NUMBERS
    stbio r22, (r11) # salvando 7seg     

    carregar UNI_VALUE -> r1 
    r1 + (NUMBERS) -> r2
    slli r2, 0x8
*/

    stwio r18,(r11)

# epílogo
    ldw ra, 32(sp)
    ldw fp, 28(sp)
    ldw r11, 24(sp)
    ldw r12, 20(sp)
    ldw r13, 16(sp)
    ldw r15, 12(sp)
    ldw r16, 8(sp)
    ldw r17, 4(sp)
    ldw r18, 0(sp)
    addi sp, sp, 36
###
ret
.org 0x500


UNI_VALUE:
    .byte 0
DEZ_VALUE:
    .byte 0
CENT_VALUE:
    .byte 0
MIL_VALUE:
    .byte 0
NUMBERS:
.byte 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f # numeros 7 seg 0 - 9

END:
    br END
.end


