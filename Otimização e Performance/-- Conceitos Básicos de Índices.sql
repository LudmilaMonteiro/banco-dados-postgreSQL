-- Conceitos Básicos de Índices
-- EXPLAIN ANALYZE:
EXPLAIN ANALYZE 
SELECT *
FROM products
WHERE price BETWEEN 100 AND 200;

-- Exemplo: 
CREATE INDEX idx_products_price
  ON products(price);

EXPLAIN ANALYZE 
SELECT *
FROM products
WHERE price BETWEEN 100 AND 200;


-- Índices e Árvores B-Tree vs. Hash vs. GiST vs. GIN
-- Exemplo 1: HASH
CREATE INDEX idx_products_price_hash
   ON products USING HASH(price);

EXPLAIN ANALYZE
SELECT *
FROM products
WHERE price = 249.37;

-- Exemplo 2 GIN:
ALTER TABLE products
   ADD COLUMN tags TEXT[];
UPDATE products
   SET tags = ARRAY['promo', 'novo']
   WHERE product_id % 5 = 0;


CREATE INDEX idx_products_tags_gin
   ON products USING GIN(tags);

-- Busca produtos com tag 'promo'
EXPLAIN ANALYZE
SELECT *
FROM products
WHERE tags @> ARRAY['promo'];


-- Escolha e Criação de Índices
-- Exemplo 1: Índices não únicos:
CREATE INDEX idx_products_category
   ON products(category_id);

CREATE UNIQUE INDEX idx_department_name_unq
  ON departments(department_name);

-- Exemplo 2: Índice parcial:
CREATE INDEX idx_orders_pending
   ON orders(order_date)
   WHERE status = 'PENDING';


-- Exemplo 3: Busca case-insensitive em email:
CREATE INDEX idx_customers_low_email
    ON customers (LOWER(email));


-- Exemplo 4: Índices concorrentes:
CREATE INDEX CONCURRENTLY index_name ON table_name using btree (column);

-- Exemplo 5: Índices com várias colunas:
CREATE INDEX index_name ON table_name (column1, column2);
CREATE INDEX idx_products_name_price ON products (product_name, price);

SELECT COUNT (*) FROM products WHERE product_name LIKE '%P%' AND price > 100

-- Exemplo 6: para limpar espaços:
VACUUM (ANALYZE) products;


-- Explain e Análise de Planos de Execução
-- Exemplo 1:
EXPLAIN ANALYSE SELECT * FROM customers WHERE customer_id = 101;

-- Exemplo 2: Apenas mostrar o plano estimado (sem executar):
EXPLAIN
SELECT * FROM products WHERE price > 300;

-- Exemplo 3: Executa a consulta e exibe tempo real + plano:
EXPLAIN ANALYZE 
SELECT * FROM products WHERE price > 300;

-- EXPLAIN
-- Exemplo 1:
CREATE INDEX idx_price ON products(price);

EXPLAIN ANALYZE 
SELECT * FROM products WHERE price > 300;

SET enable_seqscan = off;

EXPLAIN ANALYZE 
SELECT * FROM products WHERE price > 300;

SET enable_seqscan = on;   -- Depois reative


-- Exemplo 2:
EXPLAIN ANALYZE
SELECT o.order_id, c.first_name, c.last_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'SHIPPED';


-- Otimizando Consultas Completas
-- Exemplo 1:
SELECT
   o.order_id,
   COUNT (oi.order_id) AS itens 
  FROM orders o
  LEFT JOIN order_items oi ON o.order_id = oi.order_id
  WHERE o.status = 'DELIVERED'
  GROUP BY o.order_id;


-- Otimização com pré-agregação
WITH soma_itens AS (
  SELECT order_id, SUM(quantity * unit_price) AS subtotal
  FROM order_items
  GROUP BY order_id 
)
SELECT
   o.order_id, o.total_amount, si.subtotal
 FROM orders o
 JOIN soma_itens si ON si.order_id = o.order_id 
 WHERE o.status = 'DELIVERED';


-- Uso do PARTITION 
CREATE TABLE orders_part (
  order_id INT NOT NULL,
  customer_id INT,
  order_date DATE NOT NULL,
  status VARCHAR(20),
  total_amount NUMERIC(12,2),
  PRIMARY KEY (order_date, order_id)
) PARTITION BY RANGE (order_date);


CREATE TABLE orders_2024_01 PARTITION OF orders_part
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE orders_2024_02 PARTITION OF orders_part
  FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

INSERT INTO orders_part (order_id, customer_id, order_date, status, total_amount)
VALUES (200, 123, '2024-01-15', 'SHIPPED', 250.00);

SELECT * FROM orders_part 
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31';
