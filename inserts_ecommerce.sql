-- inserção de dados e queries
use ecommerce;

show tables;

-- idClient, Fname, Minit, Lname, CPF, Address

INSERT INTO clients (clientType, Fname, Minit, Lname, CPF, CNPJ, Address) 
VALUES
('PF', 'Maria', 'M', 'Silva', '12346789001', NULL, 'rua silva de prata 29, Carangola - Cidade das flores'),
('PF', 'Matheus', 'O', 'Pimentel', '98765432100', NULL, 'rua alameda 289, Centro - Cidade das flores'),
('PF', 'Ricardo', 'F', 'Silva', '45678913000', NULL, 'avenida alameda vinha 1009, Centro - Cidade das flores'),
('PF', 'Julia', 'S', 'França', '78912345600', NULL, 'rua laranjeiras 861, Centro - Cidade das flores'),
('PF', 'Roberta', 'G', 'Assis', '98745631000', NULL, 'avenida koller 19, Centro - Cidade das flores'),
('PF', 'Isabela', 'M', 'Cruz', '65478912300', NULL, 'rua alameda das flores 28, Centro - Cidade das flores');

SELECT * FROM clients;

-- inserir dados de pagamento

INSERT INTO payments 
(idClient, typePayment, paymentDescription, limitAvailable, active)
VALUES
(1, 'Boleto', 'Boleto bancário', 1000, TRUE),
(2, 'Cartão de Crédito', 'Cartão cadastrado', 5000, TRUE),
(3, 'Dois Cartões', 'Pagamento dividido em dois cartões', 8000, TRUE),
(4, 'Cartão de Débito', 'Cartão cadastrado', 3000, TRUE),
(5, 'Pix', 'Chave Pix cadastrada', 1200, TRUE),
(6, 'Cartão de Crédito', 'Cartão cadastrado', 2500, TRUE);

SELECT * FROM payments;

-- idProduct, Pname, classification_kids boolean, category('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis'), avaliação, size

INSERT INTO product (Pname, classification_kids, category, avaliacao, size) 
VALUES
('Fone de ouvido', FALSE, 'Eletrônico', 4, NULL),
('Barbie Elsa', TRUE, 'Brinquedos', 3, NULL),
('Body Carters', TRUE, 'Vestuário', 5, NULL),
('Microfone Vedo', FALSE, 'Eletrônico', 4, NULL),
('Sofá retrátil', FALSE, 'Móveis', 3, '3x57x80'),
('Farinha arroz', FALSE, 'Alimentos', 2, NULL),
('Fire Stick', FALSE, 'Eletrônico', 3, NULL);

SELECT * FROM product;

-- idOrder, idOrderClient, orderStatus, orderDescription, sendValue, paymentCash

INSERT INTO orders 
(idOrderClient, idPayment, orderStatus, orderDescription, sendValue, paymentCash) 
VALUES 
(1, 1, DEFAULT, 'compra via aplicativo', NULL, 1),
(2, 2, DEFAULT, 'compra via aplicativo', 50, 0),
(3, 3, 'Confirmado', NULL, NULL, 1),
(4, 4, DEFAULT, 'compra via web site', 150, 0);

SELECT * FROM orders;

SELECT 
    o.idOrder,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    o.orderStatus,
    o.orderDescription,
    o.sendValue,
    o.paymentCash,
    p.typePayment,
    p.limitAvailable
FROM orders o
JOIN clients c
    ON o.idOrderClient = c.idClient
LEFT JOIN payments p
    ON o.idPayment = p.idPayment
ORDER BY o.idOrder;

-- idPOproduct, idPOorder, poQuantity, poStatus

INSERT INTO productOrder 
(idPOproduct, idPOorder, poQuantity, poStatus) 
VALUES
(1, 1, 2, DEFAULT),
(2, 1, 1, DEFAULT),
(3, 2, 1, DEFAULT),
(4, 3, 1, DEFAULT),
(5, 4, 1, DEFAULT);

SELECT * FROM productOrder;

SELECT 
    o.idOrder,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    p.Pname AS Produto,
    po.poQuantity AS Quantidade,
    po.poStatus AS StatusProduto,
    o.orderStatus AS StatusPedido
FROM orders o
JOIN clients c 
    ON o.idOrderClient = c.idClient
JOIN productOrder po 
    ON o.idOrder = po.idPOorder
JOIN product p 
    ON po.idPOproduct = p.idProduct
ORDER BY o.idOrder;

-- storageLocation,quantity

INSERT INTO productStorage (storageLocation, quantity) 
VALUES 
('Rio de Janeiro', 1000),
('Rio de Janeiro', 500),
('São Paulo', 10),
('São Paulo', 100),
('São Paulo', 10),
('Brasília', 60);

SELECT * FROM productStorage;

-- idLproduct, idLstorage, location

INSERT INTO storageLocation 
(idLproduct, idLstorage, location) 
VALUES
(1, 2, 'RJ'),
(2, 6, 'DF');

SELECT * FROM storageLocation;

SELECT 
    p.idProduct,
    p.Pname AS Produto,
    ps.idProdStorage,
    ps.storageLocation AS LocalEstoque,
    ps.quantity AS QuantidadeEstoque,
    sl.location AS SiglaLocalizacao
FROM storageLocation sl
JOIN product p 
    ON sl.idLproduct = p.idProduct
JOIN productStorage ps 
    ON sl.idLstorage = ps.idProdStorage
ORDER BY p.idProduct;

-- idSupplier, SocialName, CNPJ, contact

INSERT INTO supplier 
(socialName, CNPJ, contact) 
VALUES 
('Almeida e filhos', '123456789123456', '21985474'),
('Eletrônicos Silva', '854519649143457', '21985484'),
('Eletrônicos Valma', '934567893934695', '21975474');
                            
select * from supplier;

-- idPsSupplier, idPsProduct, quantity

INSERT INTO productSupplier 
(idPsSupplier, idPsProduct, quantity) 
VALUES
(1, 1, 500),
(1, 2, 400),
(2, 4, 633),
(3, 3, 5),
(2, 5, 10);

SELECT * FROM productSupplier;

SELECT 
    s.socialName AS Fornecedor,
    p.Pname AS Produto,
    ps.quantity AS Quantidade
FROM productSupplier ps
JOIN supplier s
    ON ps.idPsSupplier = s.idSupplier
JOIN product p
    ON ps.idPsProduct = p.idProduct
ORDER BY s.socialName, p.Pname;

-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact

INSERT INTO seller 
(socialName, AbstName, CNPJ, CPF, location, contact) 
VALUES 
('Tech eletronics', NULL, '123456789456321', NULL, 'Rio de Janeiro', '219946287'),
('Botique Durgas', NULL, NULL, '123456783', 'Rio de Janeiro', '219567895'),
('Kids World', NULL, '456789123654485', NULL, 'São Paulo', '1198657484');

select * from seller;

-- idPseller, idPproduct, prodQuantity

INSERT INTO productSeller 
(idPSeller, idProduct, quantity) 
VALUES 
(1, 6, 80),
(2, 7, 10);

select * from productSeller;

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

INSERT INTO delivery
(idOrder, deliveryStatus, trackingCode, carrier, estimatedDeliveryDate, deliveryDate)
VALUES
(1, 'Em transporte', 'BR202400001', 'Correios', '2024-12-20', NULL),
(2, 'Entregue', 'BR202400002', 'Jadlog', '2024-12-18', '2024-12-17'),
(3, 'Aguardando envio', 'BR202400003', 'Total Express', '2024-12-22', NULL),
(4, 'Atrasada', 'BR202400004', 'Correios', '2024-12-15', NULL);

SELECT * FROM delivery;

SELECT 
    o.idOrder,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    o.orderStatus AS StatusPedido,
    d.deliveryStatus AS StatusEntrega,
    d.trackingCode AS CodigoRastreio,
    d.carrier AS Transportadora,
    d.estimatedDeliveryDate AS PrevisaoEntrega,
    d.deliveryDate AS DataEntrega
FROM orders o
JOIN clients c
    ON o.idOrderClient = c.idClient
JOIN delivery d
    ON o.idOrder = d.idOrder
ORDER BY o.idOrder;

