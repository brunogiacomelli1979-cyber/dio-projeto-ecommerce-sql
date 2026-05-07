-- =====================================================
-- QUERIES SQL — PROJETO E-COMMERCE
-- Desafio DIO — Modelagem Lógica de Banco de Dados
-- Banco de dados: ecommerce
-- =====================================================
-- Objetivo:
-- Criar consultas SQL para responder perguntas de negócio,
-- utilizando SELECT, WHERE, atributos derivados, ORDER BY,
-- GROUP BY, HAVING e JOIN.
-- =====================================================

USE ecommerce;

-- =====================================================
-- QUERY 1 — Recuperação simples com SELECT
-- Pergunta: Quais clientes estão cadastrados?
-- =====================================================

SELECT 
    idClient,
    clientType,
    Fname,
    Minit,
    Lname,
    CPF,
    CNPJ,
    Address
FROM clients;


-- =====================================================
-- QUERY 2 — Filtro com WHERE
-- Pergunta: Quais clientes são Pessoa Física?
-- =====================================================

SELECT 
    idClient,
    CONCAT(Fname, ' ', Lname) AS Cliente,
    CPF,
    Address
FROM clients
WHERE clientType = 'PF';


-- =====================================================
-- QUERY 3 — Produtos cadastrados ordenados por categoria
-- Pergunta: Quais produtos estão cadastrados e em quais categorias?
-- =====================================================

SELECT 
    idProduct,
    Pname AS Produto,
    Category AS Categoria,
    Classification_kids AS Produto_Infantil,
    Avaliacao,
    Size
FROM product
ORDER BY Category, Pname;


-- =====================================================
-- QUERY 4 — Clientes e formas de pagamento
-- Pergunta: Quais formas de pagamento estão cadastradas para cada cliente?
-- =====================================================

SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    p.idPayment,
    p.typePayment AS Tipo_Pagamento,
    p.paymentDescription AS Descricao_Pagamento,
    p.limitAvailable AS Limite_Disponivel,
    p.active AS Pagamento_Ativo
FROM clients c
JOIN payments p
    ON c.idClient = p.idClient
ORDER BY c.idClient;


-- =====================================================
-- QUERY 5 — Pedidos por cliente
-- Pergunta: Quais pedidos foram feitos por cada cliente?
-- =====================================================

SELECT 
    o.idOrder,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    o.orderStatus AS Status_Pedido,
    o.orderDescription AS Descricao_Pedido,
    o.sendValue AS Valor_Frete,
    o.paymentCash AS Pagamento_Dinheiro,
    p.typePayment AS Tipo_Pagamento
FROM orders o
JOIN clients c
    ON o.idOrderClient = c.idClient
LEFT JOIN payments p
    ON o.idPayment = p.idPayment
ORDER BY o.idOrder;


-- =====================================================
-- QUERY 6 — Quantidade de pedidos por cliente
-- Pergunta: Quantos pedidos foram feitos por cada cliente?
-- =====================================================

SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    COUNT(o.idOrder) AS Quantidade_Pedidos
FROM clients c
LEFT JOIN orders o
    ON c.idClient = o.idOrderClient
GROUP BY c.idClient, c.Fname, c.Lname
ORDER BY Quantidade_Pedidos DESC;


-- =====================================================
-- QUERY 7 — Clientes com mais de um pedido
-- Pergunta: Quais clientes realizaram mais de um pedido?
-- =====================================================

SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    COUNT(o.idOrder) AS Quantidade_Pedidos
FROM clients c
JOIN orders o
    ON c.idClient = o.idOrderClient
GROUP BY c.idClient, c.Fname, c.Lname
HAVING COUNT(o.idOrder) > 1
ORDER BY Quantidade_Pedidos DESC;


-- =====================================================
-- QUERY 8 — Produtos por pedido
-- Pergunta: Quais produtos fazem parte de cada pedido?
-- =====================================================

SELECT 
    o.idOrder,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    pr.Pname AS Produto,
    po.poQuantity AS Quantidade,
    po.poStatus AS Status_Produto,
    o.orderStatus AS Status_Pedido
FROM orders o
JOIN clients c
    ON o.idOrderClient = c.idClient
JOIN productOrder po
    ON o.idOrder = po.idPOorder
JOIN product pr
    ON po.idPOproduct = pr.idProduct
ORDER BY o.idOrder, pr.Pname;


-- =====================================================
-- QUERY 9 — Atributo derivado
-- Pergunta: Qual seria o valor estimado do frete com acréscimo operacional de 10%?
-- =====================================================

SELECT
    idOrder,
    orderStatus,
    sendValue AS Frete_Original,
    ROUND(sendValue * 1.10, 2) AS Frete_Com_Acrescimo_10
FROM orders
WHERE sendValue IS NOT NULL
ORDER BY Frete_Com_Acrescimo_10 DESC;


-- =====================================================
-- QUERY 10 — Relação de fornecedores e produtos
-- Pergunta: Quais produtos são fornecidos por quais fornecedores?
-- =====================================================

SELECT 
    s.socialName AS Fornecedor,
    p.Pname AS Produto,
    p.Category AS Categoria,
    ps.quantity AS Quantidade_Fornecida
FROM productSupplier ps
JOIN supplier s
    ON ps.idPsSupplier = s.idSupplier
JOIN product p
    ON ps.idPsProduct = p.idProduct
ORDER BY s.socialName, p.Pname;


-- =====================================================
-- QUERY 11 — Relação de produtos, fornecedores e estoques
-- Pergunta: Qual a relação entre produtos, fornecedores e estoques?
-- =====================================================

SELECT 
    p.Pname AS Produto,
    p.Category AS Categoria,
    s.socialName AS Fornecedor,
    ps.quantity AS Quantidade_Fornecedor,
    st.storageLocation AS Local_Estoque,
    st.quantity AS Quantidade_Estoque,
    sl.location AS Sigla_Localizacao
FROM product p
LEFT JOIN productSupplier ps
    ON p.idProduct = ps.idPsProduct
LEFT JOIN supplier s
    ON ps.idPsSupplier = s.idSupplier
LEFT JOIN storageLocation sl
    ON p.idProduct = sl.idLproduct
LEFT JOIN productStorage st
    ON sl.idLstorage = st.idProdStorage
ORDER BY p.Pname;


-- =====================================================
-- QUERY 12 — Produtos em estoque
-- Pergunta: Quais produtos estão relacionados a locais de estoque?
-- =====================================================

SELECT 
    p.idProduct,
    p.Pname AS Produto,
    ps.idProdStorage,
    ps.storageLocation AS Local_Estoque,
    ps.quantity AS Quantidade_Estoque,
    sl.location AS Sigla_Localizacao
FROM storageLocation sl
JOIN product p
    ON sl.idLproduct = p.idProduct
JOIN productStorage ps
    ON sl.idLstorage = ps.idProdStorage
ORDER BY p.idProduct;


-- =====================================================
-- QUERY 13 — Produtos por vendedor
-- Pergunta: Quais produtos estão associados a cada vendedor?
-- =====================================================

SELECT 
    s.socialName AS Vendedor,
    p.Pname AS Produto,
    ps.quantity AS Quantidade
FROM productSeller ps
JOIN seller s
    ON ps.idPSeller = s.idSeller
JOIN product p
    ON ps.idProduct = p.idProduct
ORDER BY s.socialName, p.Pname;


-- =====================================================
-- QUERY 14 — Algum vendedor também é fornecedor?
-- Pergunta: Existe algum vendedor que também aparece como fornecedor?
-- Critério: CNPJ do vendedor igual ao CNPJ do fornecedor.
-- =====================================================

SELECT 
    se.socialName AS Vendedor,
    se.CNPJ AS CNPJ_Vendedor,
    su.socialName AS Fornecedor,
    su.CNPJ AS CNPJ_Fornecedor
FROM seller se
JOIN supplier su
    ON se.CNPJ = su.CNPJ;


-- =====================================================
-- QUERY 15 — Status de entrega dos pedidos
-- Pergunta: Qual a situação de entrega de cada pedido?
-- =====================================================

SELECT 
    o.idOrder,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    o.orderStatus AS Status_Pedido,
    d.deliveryStatus AS Status_Entrega,
    d.trackingCode AS Codigo_Rastreio,
    d.carrier AS Transportadora,
    d.estimatedDeliveryDate AS Previsao_Entrega,
    d.deliveryDate AS Data_Entrega
FROM orders o
JOIN clients c
    ON o.idOrderClient = c.idClient
JOIN delivery d
    ON o.idOrder = d.idOrder
ORDER BY o.idOrder;


-- =====================================================
-- QUERY 16 — Pedidos em transporte
-- Pergunta: Quais pedidos estão em transporte?
-- =====================================================

SELECT 
    o.idOrder,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    d.deliveryStatus AS Status_Entrega,
    d.trackingCode AS Codigo_Rastreio,
    d.carrier AS Transportadora,
    d.estimatedDeliveryDate AS Previsao_Entrega
FROM orders o
JOIN clients c
    ON o.idOrderClient = c.idClient
JOIN delivery d
    ON o.idOrder = d.idOrder
WHERE d.deliveryStatus = 'Em transporte'
ORDER BY d.estimatedDeliveryDate;


-- =====================================================
-- QUERY 17 — Pedidos atrasados
-- Pergunta: Quais pedidos estão com entrega atrasada?
-- =====================================================

SELECT 
    o.idOrder,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    d.deliveryStatus AS Status_Entrega,
    d.trackingCode AS Codigo_Rastreio,
    d.carrier AS Transportadora,
    d.estimatedDeliveryDate AS Previsao_Entrega
FROM orders o
JOIN clients c
    ON o.idOrderClient = c.idClient
JOIN delivery d
    ON o.idOrder = d.idOrder
WHERE d.deliveryStatus = 'Atrasada'
ORDER BY d.estimatedDeliveryDate;


-- =====================================================
-- QUERY 18 — Resumo de pedidos por status
-- Pergunta: Quantos pedidos existem por status?
-- =====================================================

SELECT 
    orderStatus AS Status_Pedido,
    COUNT(*) AS Quantidade_Pedidos
FROM orders
GROUP BY orderStatus
ORDER BY Quantidade_Pedidos DESC;


-- =====================================================
-- QUERY 19 — Produtos por categoria
-- Pergunta: Quantos produtos existem em cada categoria?
-- =====================================================

SELECT 
    Category AS Categoria,
    COUNT(*) AS Quantidade_Produtos,
    ROUND(AVG(Avaliacao), 2) AS Avaliacao_Media
FROM product
GROUP BY Category
ORDER BY Quantidade_Produtos DESC;


-- =====================================================
-- QUERY 20 — Categorias com mais de um produto
-- Pergunta: Quais categorias possuem mais de um produto cadastrado?
-- =====================================================

SELECT 
    Category AS Categoria,
    COUNT(*) AS Quantidade_Produtos
FROM product
GROUP BY Category
HAVING COUNT(*) > 1
ORDER BY Quantidade_Produtos DESC;