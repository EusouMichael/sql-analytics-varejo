-- Participação das categorias no total de itens de venda.
WITH vendas_categoria AS (
    SELECT
        c.nome_categoria AS categoria,
        COUNT(*) AS qtd_itens_venda
    FROM itens_venda iv
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN categorias c ON c.id_categoria = p.categoria_id
    GROUP BY categoria
),
total AS (
    SELECT COUNT(*) AS total_itens_venda FROM itens_venda
)
SELECT
    vc.categoria,
    vc.qtd_itens_venda,
    ROUND(100.0 * vc.qtd_itens_venda / t.total_itens_venda, 2) AS participacao_percentual
FROM vendas_categoria vc
CROSS JOIN total t
ORDER BY vc.qtd_itens_venda DESC;

-- Participação das marcas no total de itens de venda.
WITH vendas_marca AS (
    SELECT
        m.nome AS marca,
        COUNT(*) AS qtd_itens_venda
    FROM itens_venda iv
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN marcas m ON m.id_marca = p.marca_id
    GROUP BY marca
),
total AS (
    SELECT COUNT(*) AS total_itens_venda FROM itens_venda
)
SELECT
    vm.marca,
    vm.qtd_itens_venda,
    ROUND(100.0 * vm.qtd_itens_venda / t.total_itens_venda, 2) AS participacao_percentual
FROM vendas_marca vm
CROSS JOIN total t
ORDER BY vm.qtd_itens_venda DESC;
