.equ UART, 0x10001000
.global _start

_start:
    # --- Usa r16 para o endereço base da UART ---
    movia r16, UART
    movia sp, 0x100000

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
    br send_response

case_11:
    movi r18, 0x44          # 'D'
    br send_response

case_20:
    movi r18, 0x45          # 'E'
    br send_response

case_21:
    movi r18, 0x46          # 'F'
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

FIM:
    br FIM

BUFFER:
    .skip 100 # buffer de entrada

