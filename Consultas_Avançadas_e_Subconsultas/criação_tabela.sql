CREATE DATABASE loja_db;

-- Criação das Tabelas:
-- Tabela Clientes 
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  city VARCHAR(100);
  created_at TIMESTAMP DEFAULT NOW()
);


-- Tabela Pedidos
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id),
  order_date TIMESTAMP DEFAULT NOW(),
  total_amount NUMERIC(10,2);
  status VARCHAR(20) DEFAULT 'PENDING'
);


-- Tabela Itens do Pedido
CREATE TABLE order_items (
  order_item_id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(order_id),
  product_id INT REFERENCES products(product_id),
  quantity INT NOT NULL,
  price NUMERIC(10,2) NOT NULL
);



-- Tabela Categorias
CREATE TABLE categories (
  category_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL 
);


-- Tabela Produtos
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  category_id INT REFERENCES categories(category_id),
  product_name VARCHAR(100) NOT NULL,
  price NUMERIC(10,2) NOT NULL
);

-- Tabela Departamentos
CREATE TABLE departments (
  department_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL 
);



-- Tabela Cargos 
CREATE TABLE positions (
  position_id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL 
);



-- Tabela Funcionários
CREATE TABLE employees (
  employee_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  department_id INT REFERENCES departments(department_id),
  position_id INT REFERENCES positions(position_id),
  hire_date DATE DEFAULT CURRENT_DATE 
);



-- Tabela Salários
CREATE TABLE salaries (
  salary_id SERIAL PRIMARY KEY,
  employee_id INT REFERENCES employees(employee_id),
  amount NUMERIC(10,2) NOT NULL,
  start_date DATE DEFAULT CURRENT_DATE 
);
