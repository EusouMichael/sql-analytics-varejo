-- Perfil inicial da base: volume, cobertura temporal e métricas gerais.
SELECT
    (SELECT COUNT(*) FROM vendas) AS qtd_vendas,
    (SELECT COUNT(*) FROM itens_venda) AS qtd_itens_venda,
    (SELECT COUNT(*) FROM produtos) AS qtd_produtos,
    (SELECT COUNT(*) FROM clientes) AS qtd_clientes,
    (SELECT COUNT(*) FROM fornecedores) AS qtd_fornecedores,
    (SELECT COUNT(*) FROM marcas) AS qtd_marcas,
    (SELECT COUNT(*) FROM categorias) AS qtd_categorias,
    MIN(data_venda) AS data_inicial,
    MAX(data_venda) AS data_final,
    ROUND(SUM(total_venda), 2) AS receita_registrada,
    ROUND(AVG(total_venda), 2) AS ticket_medio_venda
FROM vendas;

-- Distribuição das vendas por ano.
SELECT
    strftime('%Y', data_venda) AS ano,
    COUNT(*) AS qtd_vendas,
    ROUND(SUM(total_venda), 2) AS receita
FROM vendas
GROUP BY ano
ORDER BY ano;

-- Idade média dos clientes.
SELECT ROUND(AVG(idade), 2) AS idade_media_clientes
FROM clientes;
