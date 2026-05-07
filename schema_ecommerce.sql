-- criação do banco de dados para o cenário de e-commerce

CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- criar tabela cliente

CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    clientType ENUM('PF', 'PJ') NOT NULL DEFAULT 'PF',
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11),
    CNPJ CHAR(14),
    Address VARCHAR(80),

    CONSTRAINT uniq_cpf_client UNIQUE (CPF),
    CONSTRAINT uniq_cnpj_client UNIQUE (CNPJ),

    CONSTRAINT chk_client_pf_pj CHECK (
        (clientType = 'PF' AND CPF IS NOT NULL AND CNPJ IS NULL)
        OR
        (clientType = 'PJ' AND CNPJ IS NOT NULL AND CPF IS NULL)
        
            )
);

alter table clients auto_increment=1;

-- criar tabela produto
-- Size = dimensão do produto

CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(50) NOT NULL,
    Classification_kids BOOLEAN DEFAULT FALSE,
    Category ENUM('Eletrônico', 'Vestuário', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    Avaliacao FLOAT DEFAULT 0,
    Size VARCHAR(10)
);

alter table product auto_increment=1;

-- criar tabela pagamento
-- Um cliente pode ter mais de uma forma de pagamento cadastrada.

CREATE TABLE payments (
    idClient INT NOT NULL,
    idPayment INT AUTO_INCREMENT,
    typePayment ENUM('Boleto', 'Cartão', 'Dois cartões') NOT NULL,
    limitAvailable FLOAT,

    PRIMARY KEY (idPayment),
    
    CONSTRAINT fk_payments_client 
        FOREIGN KEY (idClient) REFERENCES clients(idClient)
);

-- criar tabela pedido

CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT NOT NULL,
    idPayment INT,
    orderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_orders_client 
        FOREIGN KEY (idOrderClient) REFERENCES clients(idClient),

    CONSTRAINT fk_orders_payment 
        FOREIGN KEY (idPayment) REFERENCES payments(idPayment)
);

alter table orders auto_increment=1;

-- criar tabela entrega
-- Entrega possui status e código de rastreio

CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL,
    deliveryStatus ENUM('Aguardando envio', 'Em transporte', 'Entregue', 'Atrasada', 'Cancelada') NOT NULL,
    trackingCode VARCHAR(50) UNIQUE,
    carrier VARCHAR(80),
    estimatedDeliveryDate DATE,
    deliveryDate DATE,

    CONSTRAINT fk_delivery_order
        FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- criar tabela estoque

CREATE TABLE productStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
  
);

-- criar tabela fornecedor

CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact VARCHAR(10) NOT NULL,
    
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
  
);

alter table supplier auto_increment=1;

-- criar tabela vendedor

CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    abstName VARCHAR(255),
    CNPJ CHAR(15) NOT NULL,
    CPF CHAR(9),
    location VARCHAR(255),
    contact VARCHAR(10) NOT NULL,    
    CONSTRAINT unique_CNPJ_supplier UNIQUE (CNPJ),
    CONSTRAINT unique_CPF_supplier UNIQUE (CPF)
  
);

alter table seller auto_increment=1;

-- criar tabela produto vendedor

CREATE TABLE productSeller (
    idPSeller INT ,
    idProduct INT ,
    quantity INT DEFAULT 1 ,
    PRIMARY KEY (idPSeller, idProduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPSeller) REFERENCES seller (idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idProduct) REFERENCES product (idProduct)
         
);


-- criar tabela pedido produto

CREATE TABLE productOrder (
    idPOproduct INT ,
    idPOorder INT ,
    poQuantity INT DEFAULT 1 ,
    poStatus ENUM ('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_seller FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
         
);

-- criar tabela produto em estoque

CREATE TABLE storageLocation (
    idLproduct INT ,
    idLstorage INT ,
    location VARCHAR(255) NOT NULL ,
    PRIMARY KEY (idLproduct, idLstorage),
   	CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
         
);

-- criar tabela produto fornecedor

CREATE TABLE productSupplier (
    idPsSupplier INT ,
    idPsProduct INT ,
    quantity INT NOT NULL ,
    PRIMARY KEY (idPsSupplier, idPsProduct),
   	CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
         
);

-- para conferir as chaves estrangeiras criadas

-- SELECT 
--     constraint_name,
--     table_name,
--     referenced_table_name
-- FROM information_schema.referential_constraints
-- WHERE constraint_schema = 'ecommerce';

