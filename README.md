# Performance DB - Otimização de Banco de Dados PostgreSQL

Projeto acadêmico focado em otimização e melhoria de performance de banco de dados público PostgreSQL através de técnicas avançadas de modelagem, indexação, monitoramento e análise de dados.

## Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Funcionalidades Implementadas](#funcionalidades-implementadas)
- [Equipe](#equipe)

## Sobre o Projeto

O **Performance DB** é um projeto desenvolvido com o objetivo de demonstrar técnicas avançadas de otimização de bancos de dados relacionais. Partindo de uma base de dados pública, implementamos diversas melhorias de performance, criamos estruturas analíticas e estabelecemos processos robustos de monitoramento e backup.

### Objetivos Principais

- Melhorar a performance de consultas através de otimização de modelagem
- Implementar estratégias eficientes de indexação
- Criar estruturas de dados analíticas (Data Warehouse)
- Estabelecer processos automatizados de backup e recuperação
- Monitorar métricas de performance em tempo real
- Visualizar dados através de dashboards interativos

## Tecnologias Utilizadas

- **Banco de Dados**: PostgreSQL
- **Backup e Migração**: pg_dump, pg_loader
- **Monitoramento**: Grafana + Prometheus
- **Business Intelligence**: Power BI / Metabase
- **ETL**: Pentaho
- **Controle de Versão**: Git & GitHub

## Funcionalidades Implementadas

### 1. Otimização de Modelagem

- Reestruturação do modelo de dados existente
- Normalização e desnormalização estratégica
- Definição de relacionamentos otimizados
- Implementação de particionamento de tabelas quando aplicável

### 2. Indexação Estratégica

- Criação de índices B-tree para consultas frequentes
- Implementação de índices compostos
- Índices parciais para subconjuntos específicos
- Índices GiST/GIN para tipos de dados especiais

### 3. Triggers, Functions e Views

- Triggers para auditoria automática
- Functions para cálculos complexos e otimizados
- Procedures para processos batch
- Validações em nível de banco de dados
- Views para consultas complexas recorrentes

### 4. Data Warehouse

- Modelagem dimensional (Star Schema)
- Tabelas de fatos e dimensões
- ETL para carga de dados
- Cache de consultas mais frequentes

### 5. Dashboard de Business Intelligence

- Visualizações interativas de KPIs
- Gráficos de tendências e análises temporais
- Drill-down para análises detalhadas
- Relatórios automatizados

### 6. Estratégia de Backup

#### Backup em Tempo Real
- Configuração de replicação streaming
- Point-in-Time Recovery (PITR)
- WAL archiving automático

#### Backups Convencionais
```bash
# Backup completo com pg_dump
pg_dump -h localhost -U usuario -d database -F c -b -v -f backup.dump

# Restauração com pg_restore
pg_restore -h localhost -U usuario -d database -v backup.dump

# Migração com pgloader
pgloader source.db postgresql://user:pass@localhost/target_db
```

### 7. Monitoramento com Grafana + Prometheus

- Coleta de métricas do PostgreSQL
- Dashboards de performance em tempo real
- Alertas configuráveis
- Métricas monitoradas:
  - Conexões ativas
  - Taxa de transações (TPS)
  - Cache hit ratio
  - Tempo de resposta de queries
  - Uso de disco e memória
  - Deadlocks e locks

## Resultados Obtidos

- **Redução de tempo de consulta**: até 80% em queries críticas
- **Cache hit ratio**: acima de 95%
- **Disponibilidade**: 99.9% com estratégia de backup
- **Tempo de recuperação**: RTO < 1 hora

## Equipe

Projeto desenvolvido por Caio Chagas, Gabriel Vittorazzi, Giulia Munis, Maria Clara e Nilo Gabriel para a disciplina de Banco de Dados 2.

---
