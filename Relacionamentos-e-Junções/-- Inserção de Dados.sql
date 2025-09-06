-- Inserção de Dados 
-- 1. Inserir departamentos
INSERT INTO departments (department_name) VALUES 
('Recursos Humanos'),
('Financeiro'),
('Tecnologia da Informação'),
('Marketing'),
('Vendas'),
('Jurídico'),
('Logística'),
('Atendimento ao Cliente'),
('Pesquisa e Desenvolvimento'),
('Administração');

-- 2. Inserir cargos 
INSERT INTO positions (position_name) VALUES 
('Estagiário'),
('Analista'),
('Coordenador'),
('Gerente'),
('Diretor');


-- 3. Inserir Funcionários 
INSERT INTO employees (first_name, last_name, department_id, position_id, hire_date) VALUES 
('Ana', 'Silva', 1, 2, '2024-01-15'),
('Bruno', 'Souza', 2, 3, '2024-03-10'),
('Carla', 'Oliveira', 3, 4, '2014-07-01'),
('Diego', 'Santos', 4, 2, '2024-06-12'),
('Eduardo', 'Pereira', 5, 1, '2024-02-20'),
('Fernanda', 'Costa', 6, 5, '2024-11-05'),
('Gustavo', 'Almeida', 7, 3, '2024-12-30'),
('Helena', 'Rodrigues', 8, 2, '2024-05-14'),
('Igor', 'Fernandes', 9, 4, '2024-09-23'),
('Juliana', 'Mendes', 10, 1, '2024-04-18'),
('Kaique', 'Lima', 1, 2, '2024-08-09'),
('Laura', 'Barbosa', 2, 3, '2024-11-11'),
('Marcos', 'Ribeiro', 3, 4, '2024-10-21'),
('Natália', 'Carvalho', 4, 1, '2024-07-07'),
('Otávio', 'Martins', 5, 2, '2024-01-01'),
('Paula', 'Araújo', 6, 5, '2024-02-28'),
('Rafael', 'Gonçalves', 7, 3, '2024-06-06'),
('Sofia', 'Batista', 8, 2, '2024-12-12'),
('Thiago', 'Dias', 9, 4, '2024-04-04'),
('Úrsula', 'Nascimento', 10, 1, '2024-03-03'),
('Victor', 'Moreira', 1, 2, '2024-09-09'),
('Wesley', 'Teixeira', 2, 3, '2024-01-15'),
('Xavier', 'Monteiro', 3, 4, '2014-08-19'),
('Yasmin', 'Rezende', 4, 2, '2014-05-22'),
('Zeca', 'Cunha', 5, 1, '2024-11-30');


-- 4. Inserir salários
INSERT INTO salaries (employee_id, salary_amount, effective_from, effective_to) VALUES
(1, 3500.00, '2024-01-15', NULL),
(2, 4800.00, '2024-03-10', NULL),
(3, 7200.00, '2024-07-01', NULL),
(4, 4100.00, '2024-06-12', NULL),
(5, 1800.00, '2024-02-20', NULL),
(6, 15000.00, '2024-11-05', NULL),
(7, 5300.00, '2024-12-30', NULL),
(8, 3900.00, '2024-05-14', NULL),
(9, 6800.00, '2024-09-23', NULL),
(10, 1600.00, '2024-04-18', NULL),
(11, 3700.00, '2024-08-09', NULL),
(12, 5100.00, '2024-11-11', NULL),
(13, 7500.00, '2024-10-21', NULL),
(14, 2000.00, '2024-07-07', NULL),
(15, 3600.00, '2024-01-01', NULL),
(16, 14500.00, '2024-02-28', NULL),
(17, 5200.00, '2024-06-06', NULL),
(18, 4000.00, '2024-12-12', NULL),
(19, 7000.00, '2024-04-04', NULL),
(20, 1900.00, '2024-03-03', NULL),
(21, 3800.00, '2024-09-09', NULL),
(22, 5000.00, '2024-01-15', NULL),
(23, 7400.00, '2024-08-19', NULL),
(24, 4200.00, '2024-05-22', NULL),
(25, 1700.00, '2024-11-30', NULL);


SELECT * FROM departments;
SELECT * FROM positions;
SELECT * FROM employees;
SELECT * FROM salaries;