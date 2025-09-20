-- Inserindo dados:
-- 1. Categorias
INSERT INTO categories (name) VALUES 
('Eletrônicos'),
('Roupas'),
('Livros');


-- 2. Produtos
INSERT INTO products (category_id, name, price) VALUES 
(1, 'Notebook', 3500.00),
(1, 'Smartphone', 2000.00),
(2, 'Camiseta', 50.00),
(3, 'Livro Calculo Avançado', 120.00);


-- 3. Clientes 
INSERT INTO customers (first_name, last_name, email) VALUES 
('Juliana', 'Nascimento', 'juliana@email.com'),
('Camila', 'Rodrigues', 'camila@email.com'),
('Thiago', 'Almeida', 'thiago@email.com'),
('Maria', 'Souza', 'maria@email.com'),
('Larissa', 'Oliveira', 'larissa@email.com');


-- 4. Pedidos
INSERT INTO orders (customer_id, status) VALUES 
(1, 'COMPLETED'),
(2, 'PENDING'),
(3, 'COMPLETED'),
(4, 'COMPLETED');


-- 5. Itens do pedido
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 3500.00),
(1, 3, 2, 100.00),
(2, 2, 1, 200.00),
(3, 4, 1, 120.00),
(4, 3, 3, 150.00);

-- 6. Departamentos
INSERT INTO departments (name) VALUES 
('TI'),
('Vendas'),
('RH');

-- 7. Cargos 
INSERT INTO positions (title) VALUES 
('Desenvolvedor'),
('Analista de vendas'),
('Gerente de RH');


-- 8. Funcionarios
INSERT INTO employees (first_name, last_name, department_id, position_id) VALUES 
('Rafael', 'Silva', 1, 1),
('Carla', 'Mendes', 2, 2),
('Paulo', 'Lima', 3, 3);


-- 9. Salarios
INSERT INTO salaries (employee_id, amount) VALUES 
(1, 5000.00),
(2, 3500.00),
(3, 7000.00);



-- 
UPDATE customers SET city = 'São Paulo' WHERE customer_id = 1;
UPDATE customers SET city = 'Rio de Janeiro' WHERE customer_id = 2;
UPDATE customers SET city = 'Belo Horizonte' WHERE customer_id = 3;
UPDATE customers SET city = 'Curitiba' WHERE customer_id = 4;
UPDATE customers SET city = 'Porto Alegre' WHERE customer_id = 5;