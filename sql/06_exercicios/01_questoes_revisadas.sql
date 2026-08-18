/*
Exercícios revisados a partir das atividades do estudo.
A nomenclatura "itens de venda" é usada quando a métrica conta registros de itens_venda.
*/

-- 01 - Número de clientes.
SELECT COUNT(*) AS qtd_clientes
FROM clientes;

-- 02 - Itens de venda registrados em 2022.
SELECT COUNT(*) AS qtd_itens_venda_2022
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
WHERE strftime('%Y', v.data_venda) = '2022';

-- 03 - Categoria com mais itens de venda em 2022.
SELECT
    c.nome_categoria AS categoria,
    COUNT(*) AS qtd_itens_venda
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN categorias c ON c.id_categoria = p.categoria_id
WHERE strftime('%Y', v.data_venda) = '2022'
GROUP BY categoria
ORDER BY qtd_itens_venda DESC
LIMIT 1;

-- 04 - Primeiro ano disponível.
SELECT MIN(strftime('%Y', data_venda)) AS primeiro_ano
FROM vendas;

-- 05 - Fornecedor com mais itens de venda no primeiro ano.
WITH primeiro_ano AS (
    SELECT MIN(strftime('%Y', data_venda)) AS ano
    FROM vendas
)
SELECT
    f.nome AS fornecedor,
    COUNT(*) AS qtd_itens_venda
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
CROSS JOIN primeiro_ano pa
WHERE strftime('%Y', v.data_venda) = pa.ano
GROUP BY fornecedor
ORDER BY qtd_itens_venda DESC
LIMIT 1;

-- 06 - Quantidade do fornecedor líder no primeiro ano.
WITH primeiro_ano AS (
    SELECT MIN(strftime('%Y', data_venda)) AS ano
    FROM vendas
), ranking AS (
    SELECT
        f.nome AS fornecedor,
        COUNT(*) AS qtd_itens_venda
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
    CROSS JOIN primeiro_ano pa
    WHERE strftime('%Y', v.data_venda) = pa.ano
    GROUP BY fornecedor
)
SELECT fornecedor, qtd_itens_venda
FROM ranking
ORDER BY qtd_itens_venda DESC
LIMIT 1;

-- 07 - Duas categorias com maior volume no período completo.
SELECT
    c.nome_categoria AS categoria,
    COUNT(*) AS qtd_itens_venda
FROM itens_venda iv
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN categorias c ON c.id_categoria = p.categoria_id
GROUP BY categoria
ORDER BY qtd_itens_venda DESC
LIMIT 2;

-- 08 - Evolução mensal das duas categorias líderes.
WITH ranking AS (
    SELECT
        c.nome_categoria AS categoria,
        COUNT(*) AS qtd_itens_venda
    FROM itens_venda iv
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN categorias c ON c.id_categoria = p.categoria_id
    GROUP BY categoria
    ORDER BY qtd_itens_venda DESC
    LIMIT 2
),
base AS (
    SELECT
        strftime('%Y/%m', v.data_venda) AS ano_mes,
        c.nome_categoria AS categoria,
        COUNT(*) AS qtd_itens_venda
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN categorias c ON c.id_categoria = p.categoria_id
    WHERE c.nome_categoria IN (SELECT categoria FROM ranking)
    GROUP BY ano_mes, categoria
)
SELECT
    ano_mes,
    SUM(CASE WHEN categoria = (SELECT categoria FROM ranking ORDER BY qtd_itens_venda DESC LIMIT 1)
             THEN qtd_itens_venda ELSE 0 END) AS categoria_lider,
    SUM(CASE WHEN categoria = (SELECT categoria FROM ranking ORDER BY qtd_itens_venda ASC LIMIT 1)
             THEN qtd_itens_venda ELSE 0 END) AS segunda_categoria
FROM base
GROUP BY ano_mes
ORDER BY ano_mes;

-- 09 - Participação das categorias no total de itens de venda de 2022.
WITH total_2022 AS (
    SELECT COUNT(*) AS total_itens_venda
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    WHERE strftime('%Y', v.data_venda) = '2022'
),
por_categoria AS (
    SELECT
        c.nome_categoria AS categoria,
        COUNT(*) AS qtd_itens_venda
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN categorias c ON c.id_categoria = p.categoria_id
    WHERE strftime('%Y', v.data_venda) = '2022'
    GROUP BY categoria
)
SELECT
    pc.categoria,
    pc.qtd_itens_venda,
    ROUND(100.0 * pc.qtd_itens_venda / t.total_itens_venda, 2) AS participacao_percentual
FROM por_categoria pc
CROSS JOIN total_2022 t
ORDER BY pc.qtd_itens_venda DESC;

-- 10 - Quanto a melhor categoria vendeu a mais que a pior em 2022.
-- Fórmula: (melhor - pior) / pior * 100.
WITH por_categoria AS (
    SELECT
        c.nome_categoria AS categoria,
        COUNT(*) AS qtd_itens_venda
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN categorias c ON c.id_categoria = p.categoria_id
    WHERE strftime('%Y', v.data_venda) = '2022'
    GROUP BY categoria
), limites AS (
    SELECT MIN(qtd_itens_venda) AS pior_vendas,
           MAX(qtd_itens_venda) AS melhor_vendas
    FROM por_categoria
)
SELECT
    melhor_vendas,
    pior_vendas,
    ROUND(100.0 * (melhor_vendas - pior_vendas) / pior_vendas, 2) AS melhor_sobre_pior_percentual
FROM limites;
