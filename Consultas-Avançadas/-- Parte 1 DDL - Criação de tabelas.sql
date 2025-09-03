-- Parte 1: DDL - Criação de tabelas 

-- 1. Tabela de categorias de produtos
CREATE TABLE categories (
  category_id SERIAL PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL
);

-- 2. Tabela de produtos
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  product_name VARCHAR(150) NOT NULL,
  category_id INT REFERENCES categories(category_id),
  price NUMERIC(10,2) NOT NULL
);

-- 3. Tabela de clientes 
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  city VARCHAR(50),
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 4. Tabela de pedidos
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id),
  order_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL,
  total_amount NUMERIC(12,2) NOT NULL
);

-- 5. Tabela de itens de cada pedido 
CREATE TABLE order_items (
  order_item_id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(order_id),
  product_id INT REFERENCES products(product_id),
  quantity INT NOT NULL,
  unit_price NUMERIC(10,2) NOT NULL
);
