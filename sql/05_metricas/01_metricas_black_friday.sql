-- Comparação da Black Friday de 2022 com a média de novembro dos anos anteriores.
-- Aqui "vendas" significa quantidade de registros em vendas, não faturamento em R$.

WITH vendas_novembro AS (
    SELECT
        strftime('%Y', data_venda) AS ano,
        COUNT(*) AS qtd_vendas
    FROM vendas
    WHERE strftime('%m', data_venda) = '11'
    GROUP BY ano
),
media_anteriores AS (
    SELECT AVG(qtd_vendas) AS media_qtd_vendas
    FROM vendas_novembro
    WHERE ano < '2022'
),
venda_2022 AS (
    SELECT qtd_vendas AS qtd_vendas_2022
    FROM vendas_novembro
    WHERE ano = '2022'
)
SELECT
    ROUND(ma.media_qtd_vendas, 2) AS media_novembro_anteriores,
    v22.qtd_vendas_2022,
    ROUND(
        100.0 * (v22.qtd_vendas_2022 - ma.media_qtd_vendas) / ma.media_qtd_vendas,
        2
    ) AS variacao_percentual
FROM media_anteriores ma
CROSS JOIN venda_2022 v22;
