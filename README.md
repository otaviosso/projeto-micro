# Cronograma

## Alunos: Arnaldo, Edgar e Otávio

|Data	|Conteúdo           |
|-------|-------------------|
|26/05  |Planejamento e Uart|
|02/06  |LED                |
|09/06  |Animação           |
|16/06  |Cronômetro         |

# Projeto Micro

Este projeto é um sistema embarcado desenvolvido em Assembly para controlar LEDs, animações e um cronômetro em um hardware específico. A seguir, detalhamos todas as funcionalidades implementadas, suas abordagens e status de desenvolvimento.

---

## Funcionalidades

### 1. Ligar LED

- **Descrição:** Permite acender um LED específico de acordo com o comando recebido via UART.
- **Abordagem de Implementação:**  
  O comando é interpretado e, a partir dos dados recebidos, o endereço do LED é calculado. É aplicada uma máscara para ligar apenas o LED desejado, sem afetar os demais.  
  O valor do LED é lido, a máscara de ativação é aplicada usando um operador lógico OR, e o valor atualizado é escrito no registrador dos LEDs.

---

### 2. Apagar LED

- **Descrição:** Permite apagar um LED específico conforme comando.
- **Abordagem de Implementação:**  
  Similar ao processo de ligar, porém uma máscara inversa (NOR) é utilizada para garantir que apenas o LED selecionado seja apagado, preservando o estado dos demais LEDs. O valor atualizado é escrito de volta no registrador de saída.

---

### 3. Ligar Animação

- **Descrição:** Inicia uma animação sequencial nos LEDs, com variação de direção dependendo do estado de um switch.
- **Abordagem de Implementação:**  
  - Um switch define a direção (direita ou esquerda).
  - Caso nenhum LED esteja aceso, é inicializado o LED8.
  - A cada chamada, o valor corrente dos LEDs é lido e deslocado (shift) para a posição seguinte conforme a direção.
  - Quando atinge o fim, reinicia do outro extremo.

---

### 4. Parar Animação

- **Descrição:** Interrompe a sequência animada dos LEDs.
- **Abordagem de Implementação:**  
  - O flag `FLAG_ANIMA` é verificado periodicamente.
  - Se o flag for desativado, a rotina de animação não é chamada, mantendo o estado atual dos LEDs.

---

### 5. Ligar Cronômetro

- **Descrição:** Inicia a contagem do cronômetro, exibindo o valor em um display de 7 segmentos.
- **Abordagem de Implementação:**  
  - O cronômetro utiliza variáveis para unidade, dezena, centena e milhar.
  - A cada interrupção de tempo (timer), incrementa-se a unidade.
  - Caso haja overflow (valor 9), realiza-se o transbordo para a próxima ordem de grandeza (dezena, centena, milhar).
  - O valor composto é convertido usando uma tabela (`NUMBERS`) para cada dígito e enviado para o display de 7 segmentos.
  - O cronômetro só incrementa se o flag de pausa estiver desativado.

---

### 6. Parar Cronômetro

- **Descrição:** Interrompe a contagem e zera o cronômetro.
- **Abordagem de Implementação:**  
  - Ao receber o comando de parada, todas as variáveis do cronômetro são zeradas.
  - O display é também zerado para indicar a parada.
  - O flag de controle é ajustado para impedir incrementos até novo comando de início.

---

### 7. Pausa do Cronômetro (**Não Impleentado**)

- **Descrição:** Pausar a contagem do cronômetro, permitindo o retorno posterior.
- **Status:**  
  - **Não finalizado.** O código possui rascunhos e comentários sobre a lógica de pausa, mas ainda não está completamente implementado ou testado.
  - O flag de pausa (`PAUSA_CRONO`) é parcialmente tratado, mas a funcionalidade de retomar de onde parou não está operacional.

---

## Resumo Técnico das Abordagens

- **Comandos UART:** O sistema interpreta comandos recebidos via UART para acionar cada funcionalidade.
- **Flags de Controle:** Flags como `FLAG_ANIMA` e `FLAG_CRONO` controlam a execução das funcionalidades principais.
- **Manipulação de Bits:** Para o controle dos LEDs e exibição no display de 7 segmentos, são utilizadas operações de bitwise (AND, OR, NOR, SHIFT).
- **Timers & Interrupções:** O cronômetro depende de interrupções periódicas para incrementar a contagem.
- **Estrutura Modular:** Cada funcionalidade principal está separada em arquivos próprios.

---
