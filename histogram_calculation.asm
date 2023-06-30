.data
    # sinal com 36 valores inteiros de 0 a 10:
    signal: .word 9, 5, 7, 5, 3, 4, 0, 2, 6, 4, 2, 5, 4, 1, 2, 1, 6, 2, 2, 3, 6, 3, 0, 0, 7, 8, 3, 4, 5, 4, 0, 5, 2, 9, 8, 7
    
    # histograma que conterá a quantidade de vezes que cada valor aparece no sinal (4*10 bytes):
    histogram: .space 40

    # Caracter para separação no momento da impressão
    virg: .asciiz  ", " 

.text
    # primeiramente vamos inicializar o histograma. Para isso, vamos percorrer o array e preencher com zeros.
    
    # variaveis auxiliares: contador, endereço do array histograma e tamanho do array 'histogram'
    li $t0, 0
    la $t1, histogram
    li $t2, 10

    # inicialização do histograma:
    fill_zeros:
        sw $zero, ($t1)          # para cada posição, preencheremos com $zero.
        addiu $t0, $t0, 1        # incrementamos o contador marcando uma iteração
        addiu $t1, $t1, 4        # caminhamos para a próxima posição de memória (do array de 4 em 4 bytes)
        bne $t0, $t2, fill_zeros # se não chegou no máximo de iterações esperadas (10), continuamos

    # Com o histograma inicializado, vamos calcular a quantidade de vezes que cada valor aparece no sinal:
    # variaveis auxiliares: contador, endereço do array histograma e tamanho do array 'signal'
    li $t0, 0
    la $t1, histogram
    li $t2, 36
    la $t3, signal

    calculate_histogram:
        lw $t4, ($t3)     # capturamos o valor atual do sinal para cada iteração
        sll $t4, $t4, 2   # multiplicamos por 4 para conseguir a posição na memória relativa
        add $t5, $t1, $t4 # adicionamos esta posição relativa ao endereço do histograma para conseguir a posição na memória relativa ao valor
        lw $s0, ($t5)     # carregamos a contagem atual desse valor
        addiu $s0, $s0, 1 # Incrementamos a contagem marcando mais uma aparição desse valor
        sw $s0, ($t5)     # guardamos o valor incrementado de volta naquela posição, sobrepondo o valor anterior
        addiu $t3, $t3, 4 # seguimos a implementação partindo para o próximo elemento do sinal
        addiu $t0, $t0, 1 # incrementamos o contador do loop
        bne $t0, $t2, calculate_histogram # se não chegou em 36, continuamos o loop até o limite

    # após inicialização e calculo do histograma, vamos imprimir o resultado:
    # variaveis auxiliares: contador e tamanho do array 'histogram'
    li $t0, 0  # contador
    li $t2, 10 # tamanho do histograma
    show_histogram:
    	li $v0, 1     # imprimir inteiro
      lw $a0, ($t1) # carregar o valor da iteração atual
      syscall       # chamada do sistema para execução da impressão
      
      li $v0, 4     # imprimir string
      la $a0, virg  # carregar a string de separação definida no segmento de data
      syscall       # chamada do sistema para execução da impressão
      
      addiu $t1, $t1, 4 # partimos para a próxima posição de memória do histograma
      addiu $t0, $t0, 1 # incrementar contador para seguirmos o loop
      bne $t0, $t2, show_histogram # se não chegou em 10, continuamos o loop

    li $v0, 10 # código para finalização do programa
    syscall    # chamada do sistema para finalização do algorítmo