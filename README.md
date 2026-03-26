# Medical Diagnostic System

Protótipo em Prolog para apoio ao diagnóstico por sintomas e gestão de pacientes, com interface web moderna, execução via Docker e testes automatizados.

## Visão Geral

O projeto possui dois blocos funcionais:

1. Diagnóstico: cruza sintomas informados com a base de conhecimento de doenças e probabilidades.
2. Pacientes: cadastro, consulta, alteração, exclusão e persistência em arquivo.

A aplicação pode ser utilizada em modo CLI (terminal) ou Web (navegador).

## Estrutura do Projeto

```text
.
├── data/
│   └── pacientes.txt
├── docs/
│   ├── ARQUITETURA.md
│   └── ROADMAP.md
├── src/
│   ├── cli/
│   │   └── main.pl
│   ├── data/
│   │   ├── doenca_probabilidade.pl
│   │   └── sintomas.pl
│   ├── diagnosis/
│   │   └── sdm.pl
│   ├── patients/
│   │   └── scp.pl
│   └── web/
│       └── web_ui.pl
├── tests/
│   └── tests.pl
├── Dockerfile
└── docker-compose.yml
```

## Como Executar (Docker)

Pré-requisitos: Docker e Docker Compose.

1. Build das imagens:

```bash
docker compose build
```

2. Executar interface web:

```bash
docker compose up mds-web
```

Acesse:

```text
http://localhost:8081
```

Se a porta `8081` estiver em uso:

```bash
MDS_WEB_PORT=8090 docker compose up mds-web
```

3. Executar testes:

```bash
docker compose run --rm mds-tests
```

4. Executar modo CLI:

```bash
docker compose run --rm mds
```

## Como Executar (Sem Docker)

Pré-requisito: SWI-Prolog.

1. Interface web:

```prolog
consult('src/web/web_ui.pl').
start_web.
```

2. CLI:

```prolog
consult('src/cli/main.pl').
start.
```

3. Testes:

```prolog
consult('tests/tests.pl').
run_tests.
```

## Interface Web

A interface web inclui:

1. Sidebar com navegação por função.
2. Dashboard com visão geral do sistema.
3. Diagnóstico com formulário e lista de sintomas da base.
4. Cadastro de paciente com feedback visual de sucesso/erro.
5. Lista de pacientes em tabela responsiva.

## Diagnóstico Técnico e Melhorias Prioritárias

Análise do estado atual do código:

Pontos fortes:

1. Regras de diagnóstico explícitas e legíveis.
2. Testes automatizados cobrindo funções centrais.
3. Interface web funcional para uso demonstrável.
4. Persistência simples e transparente em arquivo.

Gaps para tornar o projeto mais relevante:

1. Separar regras de domínio do modo de interação (CLI/Web) em camadas mais claras.
2. Padronizar nomenclatura e acentuação para evitar ambiguidades entre átomos de sintomas.
3. Evoluir persistência para banco de dados (SQLite/PostgreSQL) com versionamento de schema.
4. Criar estratégia de validação de entrada e tratamento de erro orientado ao usuário.
5. Adicionar CI (GitHub Actions) para rodar testes automaticamente a cada push/PR.
6. Incluir testes de integração para fluxo web (rotas e persistência).
7. Publicar documentação de API/contratos e guia de contribuição.

Detalhamento de arquitetura e próximos ciclos em:

- `docs/ARQUITETURA.md`
- `docs/ROADMAP.md`

## Aviso Importante

Este sistema é um protótipo para fins acadêmicos e de demonstração técnica. Não substitui avaliação médica profissional.
