.equ UART, 0x10001000
.equ TEMPO, 0x10002000
.equ BUTAO, 0x10000050
.global _start
.global PAUSA_CRONO

.org 0x20

RTI:
    ###
    #prologo
    addi sp, sp, -52
    stw ra, 48(sp)
    stw fp, 44(sp)
    stw r8, 40(sp)
    stw r9, 36(sp)
    stw r10, 32(sp)
    stw r16, 28(sp)
    stw r17, 24(sp)
    stw r18, 20(sp)
    stw r19, 16(sp)
    stw r20, 12(sp)
    stw r21, 8(sp)
    stw r22, 4(sp)
    stw r23, 0(sp)
    addi fp, sp, 44
    ###

    rdctl et, ipending
    beq et, r0, END_RTI
    subi ea, ea, 4
    andi r13, et, 1
    beq r13, r0, END_RTI
    
    call TIMER

END_RTI:
    #epilogo

    ldw ra, 48(sp)
    ldw fp, 44(sp)
    ldw r8, 40(sp)
    ldw r9, 36(sp)
    ldw r10, 32(sp)
    ldw r16, 28(sp)
    ldw r17, 24(sp)
    ldw r18, 20(sp)
    ldw r19, 16(sp)
    ldw r20, 12(sp)
    ldw r21, 8(sp)
    ldw r22, 4(sp)
    ldw r23, 0(sp)
    addi sp, sp, 52

    eret
    ###
###
TIMER:

    ###
    #prologo
    addi sp, sp, -52
    stw ra, 48(sp)
    stw fp, 44(sp)
    stw r8, 40(sp)
    stw r9, 36(sp)
    stw r10, 32(sp)
    stw r16, 28(sp)
    stw r17, 24(sp)
    stw r18, 20(sp)
    stw r19, 16(sp)
    stw r20, 12(sp)
    stw r21, 8(sp)
    stw r22, 4(sp)
    stw r23, 0(sp)
    addi fp, sp, 44
    ###

    .equ KEY,    0x10000050

    movia r13, KEY
    movia r12, PAUSA_CRONO
    movia r14, 0b10
    ldwio r13, (r13)
    andi r13, r13, 0b10
    stb r13, (r12)


    movia r10, 0x10002000   #resetar TO do TIMER
   
    #contar 5 interrupções de 200ms cada
    movia r12, CRONO_COUNTER
    ldw r15, (r12)
    movi r14, 0x4 
    beq r14, r15, ZERAR_CRONOMETRO_COUNTER # r12 < 4?
    addi r15, r15, 0x1
    stw r15, (r12)
    br CRONOMETRO_LESSTHAN5

# 1000ms -> atualizar 7 segmentos
ZERAR_CRONOMETRO_COUNTER:
    movi r14, 0x0
    stw r14, (r12)

# ??? 
CRONOMETRO_LESSTHAN5:
    movia r12, FLAG_CRONO
    ldw r15, (r12)
    beq r15, r0, CRONOMETRO_DESLIGADO:

    call _CRONOMETRO_LIGA
    br ANIMACAO

CRONOMETRO_DESLIGADO:
    call _CRONOMETRO_DESLIGA

ANIMACAO: 
    stwio r0, (r10)
    movia r10, FLAG_ANIMA
    ldw r10, (r10)
    bne r10, r0, CALL_ANIMA_LIGA
    br FORA

    CALL_ANIMA_LIGA:
        call _ANIMACAO_LIGA
        br END_RTI
FORA:
      #epilogo

    ldw ra, 48(sp)
    ldw fp, 44(sp)
    ldw r8, 40(sp)
    ldw r9, 36(sp)
    ldw r10, 32(sp)
    ldw r16, 28(sp)
    ldw r17, 24(sp)
    ldw r18, 20(sp)
    ldw r19, 16(sp)
    ldw r20, 12(sp)
    ldw r21, 8(sp)
    ldw r22, 4(sp)
    ldw r23, 0(sp)
    addi sp, sp, 52
    ###
ret

_start:
    # --- Usa r16 para o endereço base da UART ---
    movia r16, UART
    movia sp, 0x100000
    movia r8, TEMPO

    movia r9, 50000000 
    andi r10, r9, 0xFFFF
    stwio r10, 8(r8)

    srli r9, r9, 16
    stwio r9, 12(r8)
    # Inicializar interrupção
    
    movi r9, 0b111
    stwio r9, 4(r8)

    movi r9, 1
    wrctl ienable, r9
    wrctl status, r9

START_NEW_COMMAND:
    movia r22, BUFFER       # r22 = Ponteiro para o início do buffer

POLLING:
    # --- Ler um caractere ---
    # Usa r16 como base para ler da UART
    ldwio r23, (r16)         # Lê Data/Status
    andi r17, r23, 0x8000    # Testa RVALID (bit 15)
    beq r17, r0, POLLING    # Espera se não houver char
    andi r19, r23, 0xFF      # r19 = Caractere lido (ASCII)

    # --- Ecoar (Opcional, mas recomendado) ---
    # Se você adicionar uma função UART_PUTCHAR,
    # certifique-se que ela também use r16 ou que
    # r16 seja salvo/restaurado se PUTCHAR o modificar.
    # Exemplo:
    # mov r5, r19
    # call UART_PUTCHAR

    # --- Verificar se é Enter (0x0A) ---
    movi r17, 0x0A          # Valor ASCII para Enter (Line Feed)
    beq r19, r17, SAI       # Se for Enter, pula para SAI

    # --- Converter para número e guardar ---
    subi r17, r19, 0x30     # Converte ASCII '0'-'9' para 0-9. r17 = número
    stb r17, (r22)          # Salva o NÚMERO no buffer
    addi r22, r22, 1        # Avança o ponteiro do buffer
    br POLLING              # Volta a ler o próximo caractere

SAI:
    movia r22, BUFFER       # Reseta o ponteiro para o início do buffer
    ldbu r20, (r22)         # r20 = Primeiro NÚMERO (comando)
    ldbu r21, 1(r22)
    movi r23, 10
    mul r20, r20, r23
    add r20, r20, r21

    # --- Switch Case (baseado no primeiro número) ---
    movi r18, 00             # Compara com 0
    beq r20, r18, case_00

    movi r18, 01
    beq r20, r18, case_01

    movi r18, 10             # Compara com 1
    beq r20, r18, case_10

    movi r18, 11             # Compara com 1
    beq r20, r18, case_11

    movi r18, 20             # Compara com 2
    beq r20, r18, case_20

    movi r18, 21             # Compara com 1
    beq r20, r18, case_21
    br case_DEFAULT         # Se nenhum, vai para default

case_00:
    movi r18, 0x41          # 'A'
    call _LED_LIGA
    br send_response

case_01:
    movi r18, 0x42          # 'B'
    call _LED_DESLIGA
    br send_response

case_10:
    movi r18, 0x43          # 'C'
    movia r17, FLAG_ANIMA
    movia r19, 0x1
    stw r19, (r17)
  #  call RTI
    br send_response

case_11:
    movi r18, 0x44          # 'D'
    movia r17, FLAG_ANIMA
    movia r19, 0x0
    stw r19, (r17)
    br send_response

case_20:
    movi r18, 0x45          # 'E'
    movia r17, FLAG_CRONO
    movia r19, 0x1
    stw r19, (r17)
    br send_response

case_21:
    movi r18, 0x46          # 'F'
    movia r17, FLAG_CRONO
    movia r19, 0x0
    stw r19, (r17)
    br send_response

case_DEFAULT:
    movi r18, 0x3F          # '?'
    # br send_response      # Cai direto em send_response

send_response:
    # --- Enviar o caractere de resposta (r18) ---
    # Usa r16 como base para escrever na UART

POLLING_ENVIO:
    ldwio r19, 4(r16)       # Lê Control/Status (usa r16)
    andhi r17, r19, 0xFFFF  # Testa WSPACE
    beq r17, r0, POLLING_ENVIO # Espera se não houver espaço

    stwio r18, (r16)        # Envia o caractere r18 (usa r16)

    # --- Loop ---
    br START_NEW_COMMAND    # Volta ao início para um novo comando



FLAG_ANIMA:
    .word 0
FLAG_CRONO:
    .word 0
CRONO_COUNTER:
    .word 0
PAUSA_CRONO:
    .byte 0

FIM:
    br FIM

BUFFER:
    .skip 100 # buffer de entrada

