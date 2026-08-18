-- Black Friday: no contexto desta base, novembro é usado como proxy do período.
-- A base termina em 31/10/2023; portanto, não há novembro/Black Friday de 2023.

-- 1. Itens de venda por categoria em novembro.
SELECT
    strftime('%Y', v.data_venda) AS ano,
    c.nome_categoria AS categoria,
    COUNT(*) AS qtd_itens_venda
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN categorias c ON c.id_categoria = p.categoria_id
WHERE strftime('%m', v.data_venda) = '11'
GROUP BY ano, categoria
ORDER BY ano, qtd_itens_venda DESC;

-- 2. Itens de venda por fornecedor em novembro.
SELECT
    strftime('%Y', v.data_venda) AS ano,
    f.nome AS fornecedor,
    COUNT(*) AS qtd_itens_venda
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
WHERE strftime('%m', v.data_venda) = '11'
GROUP BY ano, fornecedor
ORDER BY ano, qtd_itens_venda DESC;

-- 3. Total de itens de venda por fornecedor no período de novembro.
SELECT
    f.nome AS fornecedor,
    COUNT(*) AS qtd_itens_venda
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
WHERE strftime('%m', v.data_venda) = '11'
GROUP BY fornecedor
ORDER BY qtd_itens_venda DESC;

-- 4. Evolução mensal da NebulaNetworks.
SELECT
    strftime('%Y/%m', v.data_venda) AS ano_mes,
    COUNT(*) AS qtd_itens_venda
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
WHERE f.nome = 'NebulaNetworks'
GROUP BY ano_mes
ORDER BY ano_mes;

-- 5. Comparação mensal entre três fornecedores.
WITH base AS (
    SELECT
        strftime('%Y/%m', v.data_venda) AS ano_mes,
        f.nome AS fornecedor,
        COUNT(*) AS qtd_itens_venda
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
    WHERE f.nome IN ('NebulaNetworks', 'HorizonDistributors', 'AstroSupply')
    GROUP BY ano_mes, fornecedor
)
SELECT
    ano_mes,
    SUM(CASE WHEN fornecedor = 'NebulaNetworks' THEN qtd_itens_venda ELSE 0 END) AS nebulanetworks,
    SUM(CASE WHEN fornecedor = 'HorizonDistributors' THEN qtd_itens_venda ELSE 0 END) AS horizondistributors,
    SUM(CASE WHEN fornecedor = 'AstroSupply' THEN qtd_itens_venda ELSE 0 END) AS astrosupply
FROM base
GROUP BY ano_mes
ORDER BY ano_mes;
