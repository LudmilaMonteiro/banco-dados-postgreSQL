CREATE DATABASE commerce; 

-- Criação das Tabelas
-- Tabela Categorias 
CREATE TABLE categories (
  category_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- Tabela Departamentos
CREATE TABLE departments (
  department_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL 
);

-- Tabela Cargos 
CREATE TABLE positions (
  position_id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  department_id INT REFERENCES departments(department_id)
);

-- Tabela Funcionarios 
CREATE TABLE employees (
  employee_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  hire_date DATE NOT NULL,
  position_id INT REFERENCES positions(position_id)
);

-- Tabela Salários
CREATE TABLE salaries (
  salary_id SERIAL PRIMARY KEY,
  employee_id INT REFERENCES employees(employee_id),
  amount NUMERIC(10,2) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE 
);

-- Tabela Clientes
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100),
  phone VARCHAR(20)
);

-- Tabela Produtos
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  category_id INT REFERENCES categories(category_id),
  price NUMERIC(10,2) NOT NULL,
  stock INT NOT NULL 
);

-- Tabela Pedidos
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id),
  order_date DATE NOT NULL,
  status VARCHAR(50)
);

-- Tabela Itens Pedidos 
CREATE TABLE order_items (
  order_item_id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(order_id),
  product_id INT REFERENCES products(product_id),
  quantity INT NOT NULL,
  price NUMERIC(10,2) NOT NULL 
);






