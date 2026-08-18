-- Validação dos preços contra as faixas definidas no exercício.
-- Importante: este script NÃO altera a base.

WITH faixas AS (
    SELECT 'Bola de Futebol' AS nome_produto, 20.0 AS preco_min, 100.0 AS preco_max
    UNION ALL SELECT 'Chocolate', 10.0, 50.0
    UNION ALL SELECT 'Celular', 80.0, 5000.0
    UNION ALL SELECT 'Livro de Ficção', 10.0, 200.0
    UNION ALL SELECT 'Camisa', 80.0, 200.0
)
SELECT
    p.nome_produto,
    f.preco_min,
    f.preco_max,
    COUNT(*) AS qtd_registros,
    SUM(CASE WHEN p.preco < f.preco_min OR p.preco > f.preco_max THEN 1 ELSE 0 END) AS qtd_fora_faixa,
    ROUND(100.0 * SUM(CASE WHEN p.preco < f.preco_min OR p.preco > f.preco_max THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentual_fora_faixa,
    ROUND(MIN(p.preco), 2) AS menor_preco,
    ROUND(MAX(p.preco), 2) AS maior_preco
FROM produtos p
JOIN faixas f ON f.nome_produto = p.nome_produto
GROUP BY p.nome_produto, f.preco_min, f.preco_max
ORDER BY percentual_fora_faixa DESC;

-- Estratégia de tratamento deve ser definida de acordo com a regra de negócio.
-- Não execute um UPDATE automático sem validar a origem do erro.
-- Possibilidades: corrigir pela fonte, aplicar regra de negócio, marcar como inválido ou excluir da análise.
