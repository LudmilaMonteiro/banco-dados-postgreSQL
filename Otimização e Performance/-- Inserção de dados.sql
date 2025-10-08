-- Inserção de dados 
-- Categorias
INSERT INTO categories (name) VALUES 
('Eletrônicos'), ('Móveis'), ('Acessórios'), ('Informática');

-- Departamentos 
INSERT INTO departments (name) VALUES 
('Vendas'), ('RH'), ('TI'), ('Financeiro');

-- Cragos 
INSERT INTO positions (title, department_id) VALUES 
('Vendedor', 1),
('Gerente de RH', 2),
('Desenvolvedor', 3),
('Analista Financeiro', 4);

-- Funcionários
INSERT INTO employees (first_name, last_name, email, hire_date, position_id) VALUES 
('Ana', 'Silva', 'ana.silva@empresa.com', '2024-01-15', 1),
('Bruno', 'Souza', 'bruno.souza@empresa.com', '2024-03-20', 2),
('Carla', 'Mendes', 'carla.mendes@empresa.com', '2024-06-10', 3),
('Diego', 'Ferreira', 'diego.ferreira@empresa.com', '2024-11-05', 4);

-- Salários
INSERT INTO salaries (employee_id, amount, start_date, end_date) VALUES 
(1, 2500.00, '2024-01-15', NULL),
(2, 5000.00, '2024-03-20', NULL),
(3, 4000.00, '2024-06-10', NULL),
(4, 4500.00, '2024-11-05', NULL);

-- Clientes 
INSERT INTO customers(name, email, phone) VALUES 
('João Pereira', 'joao.pereira@email.com', '11999999999'),
('Maria Oliveira', 'maria.oliveira@email.com', '11888888888'),
('Pedro Santos', 'pedro.santos@email.com', '11777777777');

-- Produtos
INSERT INTO products (name, category_id, price, stock) VALUES 
('Notebook Gamer', 4, 4500.00, 10),
('Mouse Sem Fio', 3, 120.00, 50),
('Teclado Mecânico', 3, 250.00, 30),
('Cadeira Gamer', 2, 899.90, 5),
('Monitor 27"', 1, 1500.00, 20);

-- Pedidos
INSERT INTO orders (customer_id, order_date, status) VALUES 
(1, '2024-08-01', 'Finalizado'),
(2, '2024-08-05', 'Pendente'), 
('3', '2024-08-10', 'Finalizado');

-- Itens pedidos
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 4500.00),
(1, 2, 2, 240.00),
(2, 4, 1, 899.90),
(3, 3, 1, 250.00),
(3, 5, 1, 1500.00);
