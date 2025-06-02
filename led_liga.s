_LED_LIGA:
#prologo
    addi sp, sp, -12
    stw ra, 8(sp)
    stw fp, 4(sp)
    stw r19, 0(sp)
    addi fp, sp, 12
###
    



###

#epilogo

    ldw r19, 0(sp)
    ldw fp, 4(sp)
    ldw ra, 8(sp)
    addi sp, sp, 12
    ret
    