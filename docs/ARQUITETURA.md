# Arquitetura do Medical Diagnostic System

## Objetivo Arquitetural

Organizar o projeto em camadas simples, com baixo acoplamento e facilidade de evolução para uso real.

## Camadas

1. `src/data/`
- Base de conhecimento estática (`sintomas.pl`, `doenca_probabilidade.pl`).
- Define o catálogo de sintomas/doenças e probabilidades iniciais.

2. `src/diagnosis/`
- Regras de diagnóstico e explicações (`sdm.pl`).
- Responsável por transformar sintomas em hipóteses diagnósticas.

3. `src/patients/`
- Gestão de pacientes e persistência em arquivo (`scp.pl`).
- Centraliza operações de CRUD e gravação/leitura de `data/pacientes.txt`.

4. `src/cli/`
- Ponto de entrada para interface de terminal (`main.pl`).

5. `src/web/`
- Ponto de entrada HTTP e renderização de UI (`web_ui.pl`).

6. `tests/`
- Testes de comportamento para regras e serviços.

## Fluxo da Aplicação Web

1. Usuário envia sintomas pela rota `/diagnostico`.
2. A camada web normaliza input e chama regras de diagnóstico.
3. Resultado é ordenado por probabilidade e exibido na UI.
4. Cadastro de paciente grava no arquivo de persistência central.

## Decisões Técnicas Relevantes

1. Persistência em arquivo para simplicidade e fácil inspeção manual.
2. Resolução de caminhos absolutos para robustez em diferentes diretórios de execução.
3. Docker Compose com serviços dedicados para CLI, Web e testes.

## Próximas Evoluções Arquiteturais

1. Extrair um serviço de diagnóstico puro (sem I/O) para aumentar testabilidade.
2. Introduzir camada de repositório de pacientes com contrato único.
3. Migrar persistência para banco relacional com versionamento.
4. Criar API REST para desacoplar front-end e domínio.
