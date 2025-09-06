-- Parte 2: DML - Inserção de dados de exemplo 

-- 2.1 Inserir categorias 
-- Popular 10 categorias fictícias
INSERT INTO categories(category_id, category_name) VALUES (1, 'Categoria 1');
INSERT INTO categories(category_id, category_name) VALUES (2, 'Categoria 2');
INSERT INTO categories(category_id, category_name) VALUES (3, 'Categoria 3');
INSERT INTO categories(category_id, category_name) VALUES (4, 'Categoria 4');
INSERT INTO categories(category_id, category_name) VALUES (5, 'Categoria 5');
INSERT INTO categories(category_id, category_name) VALUES (6, 'Categoria 6');
INSERT INTO categories(category_id, category_name) VALUES (7, 'Categoria 7');
INSERT INTO categories(category_id, category_name) VALUES (8, 'Categoria 8');
INSERT INTO categories(category_id, category_name) VALUES (9, 'Categoria 9');
INSERT INTO categories(category_id, category_name) VALUES (10, 'Categoria 10');

-- 2.2 Inserir produtos
-- Criar 10 produtos, cada um associado a uma categoria aleatória
-- Com preços entre R$10,00 e R$500,00
INSERT INTO products(product_id, product_name, category_id, price) VALUES (1, 'Produto 1', 7, 249.3);
INSERT INTO products(product_id, product_name, category_id, price) VALUES (2, 'Produto 2', 3, 456.2);
INSERT INTO products(product_id, product_name, category_id, price) VALUES (3, 'Produto 3', 1, 124.0);
INSERT INTO products(product_id, product_name, category_id, price) VALUES (4, 'Produto 4', 9, 330.1);
INSERT INTO products(product_id, product_name, category_id, price) VALUES (5, 'Produto 5', 2, 50.8);
INSERT INTO products(product_id, product_name, category_id, price) VALUES (6, 'Produto 6', 8, 405.2);
INSERT INTO products(product_id, product_name, category_id, price) VALUES (7, 'Produto 7', 10, 212.0);
INSERT INTO products(product_id, product_name, category_id, price) VALUES (8, 'Produto 8', 4, 89.67);
INSERT INTO products(product_id, product_name, category_id, price) VALUES (9, 'Produto 9', 6, 317.5);
INSERT INTO products(product_id, product_name, category_id, price) VALUES (10, 'Produto 10', 1, 10.0);

-- 2.3 Inserir clientes
-- Criar 10 clientes com nomes e cidades fictícias
-- Os emails são construídos a partir de nome.sobrenome{id}@exemplo.com
INSERT INTO customers(customer_id, first_name, last_name, email, city, created_at) VALUES 
(1, 'João', 'Silva', 'joao.silva1@exemplo.com', 'São Paulo', '2024-05-17'),
(2, 'Maria', 'Souza', 'maria.souza2@exemplo.com', 'Rio de Janeiro', '2024-11-04'),
(3, 'Pedro', 'Costa', 'pedro.costa3@exemplo.com', 'Belo Horizonte', '2024-02-21'),
(4, 'Ana', 'Oliveira', 'ana.oliveira4@exemplo.com', 'Porto Alegre','2024-09-10'),
(5, 'Carlos', 'Pereira', 'carlos.pereira5@exemplo.com', 'Curitiba', '2024-07-30'),
(6, 'Mariana', 'Rodrigues', 'mariana.rodrigues6@exemplo.com', 'Salvador', '2024-03-15'),
(7, 'Bruno', 'Almeida', 'bruno.almeira7@exemplo.com', 'Brasília', '2024-12-01'),
(8, 'Juliana', 'Nascimento', 'juliana.nascimento8@exemplo.com', 'Fortaleza', '2024-01-09'),
(9, 'Luiz', 'Lima', 'luiz.lima9@exemplo.com', 'Manaus', '2024-08-24'),
(10, 'Fernanda', 'Carvalho', 'fernanda.carvalo10@exemplo.com', 'Recife', '2024-06-13'),
(11, 'João', NULL, 'joao.silva11@exemplo.com', 'São Paulo', '2024-05-17');

-- 2.4 Inserir pedidos (orders) e itens de pedidos (order_items)
-- Inserir 10 pedidos, cada um referenciando um cliente aleatório 
-- Cada pedido terá de 1 a 5 itens, com produtos aleatórios e preços fictícios
-- 'status' como: PENDING, SHIPPED, DELIVERED, CANCELLED.
INSERT INTO orders(order_id, customer_id, order_date, status, total_amount) VALUES 
(1, 1, '2024-05-10', 'SHIPPED', 818.76),
(2, 2, '2024-07-29', 'PENDING', 217.47),
(3, 3, '2024-07-29', 'DELIVERED', 357.60),
(4, 4, '2024-01-16', 'CANCELLED', 48.22),
(5, 5, '2024-10-07', 'DELIVERED', 623.19),
(6, 6, '2024-03-21', 'SHIPPED', 442.55),
(7, 7, '2024-08-17', 'DELIVERED', 912.30),
(8, 8, '2024-11-24', 'PENDING', 135.44),
(9, 9, '2024-06-09', 'SHIPPED', 718.64),
(10, 10, '2024-09-02', 'DELIVERED', 718.64);

-- Itens do pedido 1 (5 itens de exemplo)
INSERT INTO order_items(order_item_id, order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 10, 2, 89.23),
(2, 1, 5, 1, 33.45),
(3, 1, 3, 3, 105.34),
(4, 1, 8, 1, 127.09),
(5, 1, 2, 2, 256.65);

-- Itens do pedido 2 (2 itens de exemplo)
INSERT INTO order_items(order_item_id, order_id, product_id, quantity, unit_price) VALUES 
(6, 2, 1, 1, 152.33),
(7, 2, 4, 5, 13.42);

-- Itens do pedido 3 (3 itens de exemplo)
INSERT INTO order_items(order_item_id, order_id, product_id, quantity, unit_price) VALUES
(8, 3, 6, 2, 75.20),
(9, 3, 7, 1, 113.10),
(10, 3, 9, 3, 56.80);

-- Itens do pedido 4 (1 item de exemplo)
INSERT INTO order_items(order_item_id, order_id, product_id, quantity, unit_price) VALUES
(11, 4, 2, 1, 48.22);

-- Itens do pedido 5 (4 itens de exemplo)
INSERT INTO order_items(order_item_id, order_id, product_id, quantity, unit_price) VALUES
(12, 5, 5, 2, 60.10),
(13, 5, 6, 1, 175.00),
(14, 5, 3, 1, 108.23),
(15, 5, 1, 1, 279.86);
