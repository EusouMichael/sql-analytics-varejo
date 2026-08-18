# SQL Analytics — Retail Sales

> **Estudo prático de SQL aplicado à análise de dados e perguntas de negócio**

Projeto desenvolvido durante os estudos de **SQL e Análise de Dados**, utilizando uma base fictícia de varejo em SQLite.

A proposta foi evoluir de consultas SQL básicas para análises que respondem perguntas de negócio: desempenho de vendas, qualidade dos dados, sazonalidade, Black Friday, participação por categoria/marca, métricas percentuais e comparação de fornecedores.

## 🎯 Objetivos

- Explorar a estrutura e o perfil da base;
- Praticar `JOIN`, `GROUP BY`, `ORDER BY`, `COUNT`, `SUM`, `AVG` e `strftime`;
- Trabalhar análise temporal e sazonalidade;
- Identificar inconsistências de qualidade nos preços;
- Analisar o comportamento das vendas em novembro como proxy de Black Friday;
- Construir métricas com CTEs (`WITH`);
- Calcular participação percentual;
- Transformar perguntas de negócio em consultas SQL reproduzíveis;
- Revisar consultas e validar a interpretação das métricas.

## 🗄️ Base de dados

A base contém:

| Entidade | Registros |
|---|---:|
| Vendas | 50.000 |
| Itens de venda | 150.034 |
| Produtos | 10.000 |
| Clientes | 10.000 |
| Fornecedores | 10 |
| Marcas | 10 |
| Categorias | 5 |

**Período:** 01/01/2020 a 31/10/2023.

**Receita registrada na tabela `vendas`:** R$ 150.556.075,72.

**Ticket médio por registro de venda:** R$ 3.011,12.

> **Importante:** `itens_venda` não possui uma coluna `quantidade`. Por isso, métricas baseadas em `COUNT(*)` representam **registros de itens de venda**, e não necessariamente unidades físicas vendidas.

## 🧩 Modelo lógico

```text
clientes ──< vendas ──< itens_venda >── produtos
                                      │
                         ┌────────────┼────────────┐
                         ▼            ▼            ▼
                    categorias     marcas     fornecedores
```

## 📁 Estrutura

```text
sql-analytics-varejo/
├── database/
│   └── banco_de_dados_vendas.db
├── data/
├── docs/
├── resultados/
├── sql/
│   ├── 01_exploracao/
│   ├── 02_data_quality/
│   ├── 03_analise_temporal/
│   ├── 04_black_friday/
│   ├── 05_metricas/
│   ├── 06_exercicios/
│   └── originais/
└── README.md
```

## 🔎 Principais análises

### 1. Perfil da base

A exploração inicial confirmou o volume de dados, a cobertura temporal e métricas gerais. A base possui 50 mil vendas e 150.034 registros em `itens_venda`, com dados de janeiro de 2020 a outubro de 2023.

### 2. Qualidade dos dados

Foi identificada uma inconsistência relevante nos preços dos produtos. Aplicando as faixas propostas no exercício, grande parte dos registros fica fora do intervalo esperado em algumas categorias.

| Produto | Fora da faixa |
|---|---:|
| Bola de Futebol | 1.929 / 2.004 |
| Chocolate | 1.968 / 2.014 |
| Livro de Ficção | 1.844 / 2.050 |
| Camisa | 1.842 / 1.956 |
| Celular | 58 / 1.976 |

A revisão **não altera automaticamente os valores**: primeiro é necessário definir a regra de negócio e a origem da inconsistência.

### 3. Sazonalidade

A análise mensal permite comparar o comportamento das vendas entre os anos. Como 2023 termina em outubro, comparações anuais devem utilizar períodos equivalentes, como **Jan–Out**, para evitar comparar um ano parcial com anos completos.

### 4. Black Friday

Neste estudo, novembro foi utilizado como proxy do período de Black Friday. A base não possui novembro de 2023 porque o último registro é de 31/10/2023.

A quantidade de registros de venda em novembro foi:

| Ano | Vendas |
|---|---:|
| 2020 | 1.628 |
| 2021 | 2.471 |
| 2022 | 3.200 |

A análise também compara fornecedores e categorias durante novembro.

### 5. Métrica de comparação

Foi utilizada uma CTE para comparar novembro de 2022 com a média de novembro dos anos anteriores, calculando a variação percentual:

```text
(Atual − Média anterior) / Média anterior × 100
```

Esse padrão demonstra como CTEs podem tornar uma análise mais legível e reutilizável.

### 6. Categorias

No período completo, as duas categorias com maior volume de registros em `itens_venda` foram:

1. **Eletrônicos:** 43.446
2. **Vestuário:** 41.274

Em 2022, os volumes foram:

1. **Eletrônicos:** 15.675
2. **Vestuário:** 14.873

## 🧠 Aprendizados técnicos

- Exploração e profiling de uma base relacional;
- `JOIN` entre múltiplas tabelas;
- agregações e agrupamentos;
- `strftime` para análise temporal no SQLite;
- CTEs com `WITH`;
- `CASE WHEN` para transformação e comparação;
- cálculo de participação percentual;
- validação de qualidade dos dados;
- comparação entre períodos;
- interpretação de métricas de negócio;
- diferença entre **vendas**, **itens de venda** e **faturamento**;
- importância de validar a métrica antes de interpretar o resultado.

## 🔧 Revisões realizadas

O diretório `sql/originais/` preserva os scripts produzidos durante o estudo.

Os diretórios numerados contêm versões revisadas para melhorar:

- nomenclatura;
- legibilidade;
- consistência dos filtros;
- uso de CTEs;
- interpretação das métricas;
- documentação das limitações da base.

### Exemplo de correção conceitual

Na questão sobre a diferença percentual entre a melhor e a pior categoria, a fórmula revisada é:

```text
(Melhor − Pior) / Pior × 100
```

Isso responde diretamente à pergunta "quanto a melhor categoria vendeu a mais em relação à pior".

## ⚠️ Limitações

- A tabela `itens_venda` não contém quantidade física por item.
- `COUNT(*)` em `itens_venda` mede registros de itens de venda.
- Novembro foi utilizado como proxy de Black Friday; a base não identifica explicitamente o evento.
- 2023 é um período parcial, com dados somente até outubro.
- Os limites de preço são regras propostas pelo exercício, não necessariamente regras reais de negócio.
- Não foi aplicado um `UPDATE` automático nos preços sem uma regra de correção validada.

## 🚀 Próximos passos

- Criar análises de faturamento por categoria e fornecedor usando `SUM(total_venda)` quando a granularidade permitir;
- adicionar métricas de ticket médio por cliente/categoria;
- analisar crescimento mês a mês e ano contra ano;
- explorar clientes e recorrência;
- construir uma camada de visualização em Power BI;
- documentar um modelo analítico para transformar o estudo em case de BI.

## 🛠️ Tecnologias

`SQL` · `SQLite` · `CTE` · `JOIN` · `Data Quality` · `Time Series Analysis` · `Business Intelligence`

---

**Projeto educacional:** registro da evolução prática em SQL, com foco em transformar consultas em análises orientadas a perguntas de negócio.
