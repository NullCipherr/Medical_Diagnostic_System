# Medical_Diagnostic_System

Construa um protótipo de um sistema de diagnóstico médico o qual deve apresentar os seguintes módulos :

- Controle de pacientes possuindo :
  - Consulta ;
  - Inclusão ;
  - Alteração ;
  - Exclusão de pacientes em um arquivo de dados chamado pacientes.txt.

- Encontre na internet, livro ou qualquer outra fonte uma lista de doenças (no mínimo 10) e seus sintomas e adicione-as no código fonte em prolog. Juntamente a cada doença, deve ser armazenado o valor de probabilidade de cada doença. 

- Módulo de diagnóstico: crie uma IHC (Interface Humano Computador) para o sistema, de modo que ela interaja com o usuário solicitando informações de sintomas que o paciente esteja sentindo. Alguns exemplos são: náusea, vômito, febre, tempo de febre, intensidade da febre (baixa até 38 graus; alta acima de 39 graus), diarreia, dor no pescoço, etc.

- IHC de resultados: caso haja mais de um tipo de doença relacionada aos sintomas informados pelo paciente, o sistema deve apresentar os percentuais de probabilidade das possíveis doenças do paciente.

- Criar mecanismos para o usuário questionar o sistema:
  - Dado um diagnóstico final, por que o paciente tem a doença X? (qual regra derivou X).
  - Dado um diagnóstico final, por que o paciente não tem a doença Y, ao invés da X? (quais premissas de Y o paciente não tem de sintomas).
  - Por que foi perguntado se o paciente tem o sintoma A? (lista quais doenças tem o sintoma A)

- As doenças devem ser listadas por ordem da maior para a menor probabilidade.

- O sistema de diagnóstico deve apresentar o seguinte texto: o resultado do protótipo é apenas informativo e que o paciente deve consultar um médico para obter um diagnóstico correto e preciso.

- A IHC deve permitir que o usuário peça mais informações sobre o diagnóstico da doença, o sistema deve então mostrar quais sintomas da doença o paciente apresenta e quais outros sintomas da doença o usuário não informou.

- Criar testes unitários para as funcionalidades implementadas.
