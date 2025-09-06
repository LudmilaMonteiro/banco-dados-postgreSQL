-- Uso do INNER JOIN 
-- 1.1 Sintaxe canônica: Listar produto e nome da categoria correspondente
SELECT
  p.product_id,
  p.product_name,
  c.category_id,
  c.category_name
FROM products AS p 
INNER JOIN categories AS c
  ON p.category_id = c.category_id 
ORDER BY p.product_id;

-- 1.2 Usando aliases curtos para simplificar colunas em ORDER BY 
SELECT
  p.product_id AS pid,
  p.product_name AS nome_produto,
  c.category_id,
  c.category_name
FROM products AS p
INNER JOIN categories AS c
  ON p.category_id = c.category_id 
WHERE p.price > 100 -- filtrar só produtos caros 
ORDER BY pid;


-- INNER JOIN com junção múltipla
SELECT 
  o.order_id,
  o.customer_id,
  c.first_name || ' ' || c.last_name AS cliente,
  o.order_date,
  o.status,
  o.total_amount
 FROM orders AS o
 INNER JOIN customers AS c
    ON o.customer_id = c.customer_id -- coluna 1: vincula pedido -> cliente 
   AND o.order_date >= c.created_at -- coluna 2: garante que o pedido veio após a criação do cliente
  ORDER BY o.order_date DESC
  LIMIT 5; -- ver as 5 primeiras linhas


-- INNER JOIN com 3 ou mais tabelas
SELECT
    o.order_id,
    o.order_date,
    c.first_name || ' ' || c.last_name AS cliente,
    c.city,
    p.product_name, 
    oi.quantity,
    oi.unit_price, 
     (oi.quantity * oi.unit_price) AS subtotal
  FROM orders AS o
  INNER JOIN customers AS c ON o.customer_id = c.customer_id
  INNER JOIN order_items AS oi ON o.order_id = oi.order_id
  INNER JOIN products AS p ON oi.product_id = p.product_id 
  WHERE o.status = 'DELIVERED';

-- Seleção de Colunas Específicas e uso do DISTINCT
-- 1.1: ruim: SELECT * 
-- Melhor: 
SELECT c.first_name, c.last_name, o.order_date
   FROM customers AS c
   INNER JOIN orders AS o
     ON c.customer_id = o.customer_id; 

-- 1.2 DISTINCT 
SELECT DISTINCT c.city
   FROM customers AS c
   INNER JOIN orders AS o ON c.customer_id = o.customer_id;

-- 1.3 Listar nome completo de cada cliente e quantos pedidos ele fez (sem duplicar linhas de cliente)
SELECT
  c.customer_id,
  CONCAT(c.first_name, ' ', c.last_name) AS cliente,
  COUNT (o.order_id) AS total_pedidos
FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_pedidos DESC;

-- 1.4 Listar todas as cidades distintas de clientes que já fizeram pedidos
SELECT DISTINCT c.city
FROM customers AS c
INNER JOIN orders AS o
  ON c.customer_id = o.customer_id
ORDER BY c.city;

-- 1.5 Mostrar dados de pedido com nome completo do cliente e data formatada
SELECT
  o.order_id,
  CONCAT(c.first_name, ' ', c.last_name) AS cliente_completo,
  TO_CHAR(o.order_date, 'DD-Mon-YYYY') AS data_legivel
FROM orders AS o
INNER JOIN customers AS c
   ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;

-- Uso do LEFT JOIN
-- Exemplo 1:
SELECT
    p.product_id,
    p.product_name,
    oi.order_id
  FROM products AS p
  LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id; 

-- Exemplo 2:
SELECT
    p.product_id,
    p.product_name, 
    oi.order_id,
    COUNT(oi.order_item_id) AS total_vendas 
  FROM products AS p
  LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
  GROUP BY p.product_id, p.product_name, oi.order_id
  ORDER BY total_vendas DESC;

-- Exemplo 3: 
SELECT
    p.product_id,
    p.product_name
  FROM products AS p
  LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
  WHERE oi.order_item_id IS NULL
  ORDER BY p.product_name;

-- Uso do RIGHT JOIN 
-- Exemplo 1: 
SELECT
   c.customer_id,
   c.first_name, 
   c.last_name, 
   o.order_id
 FROM orders AS o
 RIGHT JOIN customers AS c
   ON o.customer_id = c.customer_id;

-- Uso do FULL JOIN
-- Exemplo 1: Listar todos os produtos e todas as categorias, mesmo que não haja correspondência entre eles
SELECT
   p.product_id, 
   p.product_name,
   c.category_id, 
   c.category_name 
 FROM products AS p
 FULL JOIN categorias AS c
   ON p.category_id = c.category_id
 ORDER BY c.category_id, p.product_id;

-- Exemplo 2: Mostrar todos os pedidos e todos os clientes, mesmo que haja pedidos sem cliente ou clientes sem pedido
SELECT
   o.order_id,
   o.customer_id AS pedido_customer_id,
   o.order_date,
   o.status, 
   c.customer_id AS cliente_customer_id,
   c.first_name || ' ' || c.last_name AS cliente, 
   c.city
 FROM orders AS o
 FULL JOIN customers AS c
   ON o.customer_id = c.customer_id
 ORDER BY o.order_date DESC;

-- Uso do COALESCE 
-- Exemplo 1:
SELECT
   COALESCE(c.first_name, 'SEM NOME') AS primeiro_nome,
   COALESCE(c.last_name, 'DESCONHECIDO') AS sobrenome
 FROM customers AS c;

-- Exemplo 2:
SELECT
    c.customer_id,
    COALESCE(c.first_name, 'SEM NOME') AS primeiro_nome,
    COALESCE(c.last_name, 'DESCONHECIDO') AS sobrenome,
    COALESCE(o.total_amount, 0) AS total_ultimo_pedido
 FROM customers AS c
 LEFT JOIN (
   SELECT
      customer_id, 
      SUM(total_amount) AS total_amount
    FROM orders 
    WHERE order_date >= '2024-01-01'
    GROUP BY customer_id
 ) AS o ON c.customer_id = o.customer_id;

-- Filtros Pós-Junção e Precedência 
-- Subconjunto 
 SELECT *
FROM (
   SELECT
     p.product_id, 
     p.product_name,
     oi.order_id,
     oi.quantity
   FROM products AS p
   LEFT JOIN order_items AS oi
     ON p.product_id = oi.product_id 
) AS subq 
WHERE subq.quantity > 5 OR subq.quantity IS NULL;

-- Subconsultas Correlacionadas e Não Correlacionadas
-- Exemplo 1: Subconsulta Não Correlacionadas:
SELECT product_id, product_name 
  FROM products
 WHERE price > (
  SELECT AVG(price) FROM products
 );

-- Exemplo 2: Subconsulta Correlacionada:
SELECT
   c.customer_id,
   c.first_name,
   c.last_name,
    (SELECT COUNT(*)
       FROM orders o
      WHERE o.customer_id = c.customer_id 
  ) AS total_pedidos
 FROM customers AS c;

-- Exemplo 3: 
-- Subconsulta correlacionada:
SELECT
   c.customer_id, 
   c.first_name,
    (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id) AS total_pedidos
 FROM customers AS c;

-- Reescrita com JOIN + GROUP BY (para mehorar)
SELECT
   c.customer_id, 
   c.first_name, 
   COUNT(o.order_id) AS total_pedidos
 FROM customers AS c
 LEFT JOIN orders AS o
   ON c.customer_id = o.customer_id
 GROUP BY c.customer_id, c.first_name;

-- Junções com Três ou Mais Tabelas com Condição Adicional 
-- Exemplo 1:
SELECT
   cli.customer_id, 
   CONCAT(cli.first_name, ' ', cli.last_name) AS nome_cliente,
   pd.order_id,
   TO_CHAR(pd.order_date, 'DD/MM/YYYY') AS data_pedido,
   pr.product_id, 
   pr.product_name,
   ip.quantity,
   ip.unit_price, 
    (ip.quantity * ip.unit_price) AS subtotal
 FROM customers AS cli
-- 1 - Cliente <-> Pedido
INNER JOIN orders AS pd ON cli.customer_id = pd.customer_id
-- 2 - Pedido <-> Itens do Pedido
INNER JOIN order_items AS ip ON pd.order_id = ip.order_id
-- 3 - Itens <-> Produto 
INNER JOIN products AS pr ON ip.product_id = pr.product_id
WHERE pd.status = 'DELIVERED' 
ORDER BY cli.customer_id, pd.order_date;
