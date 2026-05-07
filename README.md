# Projeto Lógico de Banco de Dados — E-commerce

Projeto desenvolvido como parte do desafio de modelagem lógica de banco de dados da DIO.

O objetivo foi replicar e refinar um modelo lógico para um cenário de e-commerce, aplicando conceitos de banco de dados relacional, criação de tabelas, definição de chaves primárias e estrangeiras, constraints, relacionamentos e consultas SQL para análise dos dados.

Este projeto tem finalidade educacional e foi construído como parte do meu processo de aprendizagem em SQL, modelagem de dados e estruturação de projetos para portfólio.

---

## Objetivo do desafio

O desafio propõe a criação de um esquema lógico de banco de dados para um cenário de e-commerce, considerando os principais elementos envolvidos em uma operação de venda online.

Além da criação das tabelas, o projeto também deveria contemplar refinamentos específicos solicitados no enunciado:

- Cliente Pessoa Física ou Pessoa Jurídica;
- Cliente com mais de uma forma de pagamento cadastrada;
- Entrega com status e código de rastreio;
- Criação de queries SQL com diferentes cláusulas e recursos;
- Publicação do projeto em um repositório no GitHub.

---

## Contexto do projeto

O banco de dados representa um cenário simplificado de e-commerce, onde:

- clientes realizam pedidos;
- pedidos podem possuir uma forma de pagamento;
- pedidos possuem informações de entrega;
- produtos podem estar associados a pedidos;
- produtos podem estar relacionados a fornecedores;
- produtos podem estar relacionados a vendedores;
- produtos podem estar disponíveis em locais de estoque.

A modelagem busca representar essas relações de forma organizada, utilizando tabelas principais e tabelas associativas para os relacionamentos muitos para muitos.

---

## Banco de dados utilizado

O banco criado para este projeto foi:

```sql

ecommerce
Estrutura dos arquivos
projeto-ecommerce-sql/
├── schema_ecommerce.sql
├── inserts_ecommerce.sql
├── queries_ecommerce.sql
└── README.md

schema_ecommerce.sql

Arquivo responsável pela criação do banco de dados e das tabelas do projeto.

inserts_ecommerce.sql

Arquivo responsável pela inserção dos dados fictícios utilizados para testes.

queries_ecommerce.sql

Arquivo responsável pelas consultas SQL criadas para responder perguntas de negócio.

README.md

Arquivo de documentação geral do projeto.

Como executar o projeto

Execute os arquivos SQL na seguinte ordem:

1. Criar banco e tabelas
schema_ecommerce.sql

2. Inserir dados fictícios
inserts_ecommerce.sql

3. Executar consultas
queries_ecommerce.sql

Ferramentas utilizadas
MySQL
DBeaver
Visual Studio Code
GitHub

Aprendizados do projeto

Durante o desenvolvimento deste projeto, foram praticados conceitos como:

criação de banco de dados;
criação de tabelas;
definição de chaves primárias;
definição de chaves estrangeiras;
uso de constraints;
relacionamento 1:N;
relacionamento N:N;
criação de tabelas associativas;
inserção de dados fictícios;
consultas com SELECT;
filtros com WHERE;
ordenação com ORDER BY;
agrupamentos com GROUP BY;
filtros de grupos com HAVING;
junções com JOIN;
criação de atributos derivados;
documentação de projeto SQL para GitHub.
Considerações finais

Este projeto foi desenvolvido como exercício prático de modelagem lógica de banco de dados.

A construção do modelo permitiu compreender melhor como transformar um cenário conceitual de e-commerce em um esquema relacional, respeitando regras de negócio, relacionamentos entre entidades e requisitos de consulta.

O projeto também contribui para o desenvolvimento de um portfólio voltado à área de dados, SQL, banco de dados e business intelligence.