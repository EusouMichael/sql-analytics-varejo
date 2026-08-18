-- Vendas mensais ao longo de toda a série.
SELECT
    strftime('%Y/%m', data_venda) AS ano_mes,
    COUNT(*) AS qtd_vendas
FROM vendas
GROUP BY ano_mes
ORDER BY ano_mes;

-- Comparação mensal por ano.
SELECT
    mes,
    SUM(CASE WHEN ano = '2020' THEN qtd_vendas ELSE 0 END) AS vendas_2020,
    SUM(CASE WHEN ano = '2021' THEN qtd_vendas ELSE 0 END) AS vendas_2021,
    SUM(CASE WHEN ano = '2022' THEN qtd_vendas ELSE 0 END) AS vendas_2022,
    SUM(CASE WHEN ano = '2023' THEN qtd_vendas ELSE 0 END) AS vendas_2023
FROM (
    SELECT
        strftime('%m', data_venda) AS mes,
        strftime('%Y', data_venda) AS ano,
        COUNT(*) AS qtd_vendas
    FROM vendas
    GROUP BY mes, ano
)
GROUP BY mes
ORDER BY mes;

-- Observação analítica: 2023 possui dados somente até outubro.
-- Para comparação anual justa, use Jan-Out nos quatro anos.
