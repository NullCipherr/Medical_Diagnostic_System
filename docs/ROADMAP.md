# Roadmap do Projeto

## Fase 1 - Estabilização Técnica (curto prazo)

1. Cobrir com testes os fluxos web principais.
2. Padronizar termos de sintomas (normalização, aliases e validações).
3. Corrigir inconsistências de UX e mensagens de erro.
4. Configurar lint/format e pipeline CI no GitHub Actions.

## Fase 2 - Produto MVP (médio prazo)

1. Expor API HTTP para diagnóstico e pacientes.
2. Migrar armazenamento para SQLite com camada de acesso dedicada.
3. Adicionar autenticação básica para acesso administrativo.
4. Implementar histórico de alterações por paciente.

## Fase 3 - Projeto Relevante para Portfólio (médio/longo prazo)

1. Dashboard com métricas de uso e qualidade de dados.
2. Explicabilidade do diagnóstico (rastrear quais sintomas influenciaram cada hipótese).
3. Internacionalização de interface e documentação.
4. Pacote de deployment (Docker + CI/CD + ambiente de demonstração).

## Critérios de Qualidade para GitHub

1. README completo com arquitetura, execução e roadmap.
2. Cobertura mínima de testes definida e monitorada.
3. Issues e milestones públicas priorizadas.
4. Releases versionadas com changelog.
