# 🏥 Medical_Diagnostic_System
Este repositório contém um protótipo de um sistema de diagnóstico médico com vários módulos, incluindo módulo de pacientes e módulo de diagnóstico.

## 🎯 Objetivo
O objetivo deste projeto é construir um protótipo de um sistema de diagnóstico médico que interage com o usuário para identificar possíveis doenças com base nos sintomas informados.

## 📋 Módulo de Controle de Pacientes
O sistema possui um módulo de controle de pacientes que permite a consulta, inclusão, alteração e exclusão de pacientes em um arquivo de dados chamado pacientes.txt. 

## 🤖 Módulo de Diagnóstico
O sistema possui uma Interface Humano-Computador (IHC) que interage com o usuário solicitando informações sobre os sintomas que o paciente está sentindo.

## 📚 Lista de Doenças
O código fonte em Prolog inclui uma lista de doenças e seus sintomas, juntamente com o valor de probabilidade de cada doença. 

## 📊 IHC de Resultados
Se houver mais de um tipo de doença relacionada aos sintomas informados pelo paciente, o sistema apresentará os percentuais de probabilidade das possíveis doenças do paciente. 

## ❓ Mecanismos de Questionamento
O sistema permite que o usuário questione o diagnóstico final, fornecendo explicações sobre por que o paciente tem a doença X, por que o paciente não tem a doença Y, e por que foi perguntado se o paciente tem o sintoma A. 🧐

## 📖 Informações Adicionais
A IHC permite que o usuário peça mais informações sobre o diagnóstico da doença, mostrando quais sintomas da doença o paciente apresenta e quais outros sintomas da doença o usuário não informou. 

## 🧪 Testes Unitários
O repositório inclui testes unitários para as funcionalidades implementadas. 

## ⚙️ Como utilizar
Este programa foi desenvolvido em Prolog e deve ser executado no SWI-Prolog. Aqui estão as etapas para utilizá-lo:

- Instale o SWI-Prolog: Se você ainda não tem o SWI-Prolog instalado, você pode baixá-lo do site oficial: SWI-Prolog.
- Clone o repositório: Clone o repositório do Medical_Diagnostic_System para o seu computador local.
- Abra o arquivo no SWI-Prolog: Navegue até a pasta do projeto clonado e abra o arquivo principal do programa (por exemplo, main.pl) no SWI-Prolog.
- Execute o programa: No SWI-Prolog, digite "consult('main.pl')", para carregar o arquivo e em seguida "main." para executar o programa carregado.
- Interaja com o programa: O programa solicitará informações sobre os sintomas que o paciente está sentindo. Insira as informações conforme solicitado.
- Veja os resultados: Após inserir todas as informações necessárias, o programa fornecerá um diagnóstico baseado nos sintomas informados.

Lembre-se, este é apenas um protótipo de um sistema de diagnóstico médico. Sempre consulte um profissional de saúde para um diagnóstico preciso.
