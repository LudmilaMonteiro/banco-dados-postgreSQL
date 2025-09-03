-- Uso do WHERE
SELECT * FROM customers WHERE first_name = 'Pedro'
SELECT * FROM customers WHERE email = 'ana.oliveira4@exemplo.com'
SELECT * FROM customers WHERE city = 'Porto Alegre'

-- Uso do maior que
SELECT product_id, product_name, price
  FROM products 
  WHERE price > 100; -- filtra produtos com preço maior que 100

-- Uso do caractere espaço
SELECT customer_id, first_name || ' ' || last_name AS full_name, city 
  FROM customers  
  WHERE city = 'São Paulo'; 

-- Uso do igual a 
SELECT product_id, product_name, category_id
  FROM products 
  WHERE category_id = 3; 

-- Uso do diferente de 
SELECT order_id, status
  FROM orders 
  WHERE status <> 'DELIVERED'; -- diferente de 'Delivered'

-- Uso do antes de 
SELECT customer_id, created_at
  FROM customers 
  WHERE created_at < '2024-06-01'; -- data de cadastro antes de junho/2024

-- Uso do menor igual a 
SELECT product_id, price 
  FROM products
  WHERE price <= 50; -- preço menor ou igual a 50

-- Uso do NULL e NOT NULL
SELECT * FROM customers WHERE last_name IS NULL
SELECT * FROM customers WHERE last_name IS NOT NULL

-- Uso do AND
SELECT customer_id, first_name, last_name, city 
  FROM customers
  WHERE city = 'São Paulo' AND created_at >= '2024-01-01'; -- clientes em SP cadastrados em/apos jan/2024

-- Uso do OR
SELECT product_id, product_name, price 
  FROM products
  WHERE price < 50
  OR price > 400; -- produtos com preço menor que 50 ou maior que 400

-- Uso do AND e OR
SELECT order_id, total_amount, status
  FROM orders
  WHERE (status = 'DELIVERED' OR status = 'SHIPPED')
  AND total_amount > 300; -- primeiro avalia o status, depois total_amount > 300

-- Uso do IN
SELECT order_id, status 
  FROM orders
  WHERE status IN ('PENDING', 'SHIPPED'); -- status PENDING ou SHIPPED

SELECT product_id, category_id 
  FROM products
  WHERE category_id IN (1, 3, 5);  -- categorias 1, 3 ou 5

SELECT customer_id  
  FROM customers
  WHERE city IN ('Manaus', 'Recife', 'Fortaleza');

-- Uso do NOT IN
SELECT product_id, product_name, category_id
  FROM products
  WHERE category_id NOT IN (2, 4, 6); -- exclui categorias 2, 4 e 6

-- Uso do BETWEEN e AND
SELECT product_id, price
  FROM products
  WHERE price BETWEEN 150 AND 300; -- inclusive: preço entre 150 e 300

SELECT order_id, order_date
  FROM orders
  WHERE order_date BETWEEN '2024-05-01' AND '2024-05-31'; --pedidos em maio/2024

-- Uso do Like
SELECT customer_id, first_name 
  FROM customers
  WHERE first_name LIKE 'Ju%'; -- nome começa com 'Ju'

SELECT customer_id, first_name, last_name
  FROM customers
  WHERE last_name LIKE '%Silva'; -- sobrenome termina com 'Silva'

SELECT product_id, product_name
  FROM products
  WHERE product_name LIKE '_roduto 1%'; --"_" representa um caractere qualquer: corresponde a "Produto 1", "Zroduto 1"

-- Uso do COUNT 
-- 1.1 COUNT(*) conta todas as linhas, mesmo com NULL
SELECT COUNT(*) AS total_pedido
  FROM orders; -- total de pedidos (inclui todos os registros)

-- 1.2 COUNT(coluna) conta somente valores não nulos na coluna
SELECT COUNT (o.total_amount) AS total_amount_nao_nulos 
  FROM orders o; -- conta quantos registros tem toal_amount não NULL

-- 1.3 COUNT(DISTINCT coluna) conta valores distintos
-- Quantos clientes únicos fizeram pedido 
SELECT COUNT(DISTINCT o.customer_id) AS clientes_unicos
  FROM orders o;

SELECT COUNT(DISTINCT customers.last_name) AS total_customers_nao_nulos
  FROM customers; -- traz registros não repitidos

-- 1.4 Gestão de valores nulos em contagens 
-- Exibir quantos produtos têm preço definido (price não é NULL)
SELECT COUNT(price) AS produtos_com_preco
  FROM products; -- ignora linhas onde price é NULL

-- Uso do SUM, AVG
-- 1.1 SUM(coluna) soma valores numéricos (ignora NULL)
-- Calcular faturamento total de todos os pedidos
SELECT SUM(total_amount) AS faturamento_geral
  FROM orders;

-- 1.2 AVG(coluna) calcula média dos valores (ignora NULL)
-- Média de valor de pedidos
SELECT AVG(total_amount) AS media_pedidos
  FROM orders;

-- Uso do MAX e MIN
-- 1.1 MAX(coluna) retorna maior valor; MIN(coluna) retorna menor valor
-- Encontrar o preço máximo e o preço mínimo entre todos os produtos
SELECT MAX(price) AS preco_maximo,
       MIN(price) AS preco_minimo
  FROM products;

-- 1.2 Exemplo: "data mínima de registro" em customers (primeiro cliente cadastrado)
SELECT MIN(created_at) AS primeira_data_cadastro
  FROM customers;

SELECT MAX(created_at) AS ultima_data_cadastro
  FROM customers; -- ultimo cliente cadastrado

-- Uso do ORDER BY
-- 1.1 Sintaxe básica: ordernar produtos pelo preço em ordem ascendente e descendente
SELECT product_id, product_name, price
  FROM products
  ORDER BY price ASC; -- preços do menor para o maior

SELECT product_id, product_name, price 
  FROM products
  ORDER BY price DESC; -- preços do maior para o menor

-- 1.2 Ordenação por múltiplas colunas: pedido por status e depois por data (ascendente)
SELECT order_id, status, order_date
  FROM orders
  ORDER BY status ASC, order_date ASC; -- primeiro ordena por status, depois por data

-- Uso do GROUP BY 
-- 1.1 Exemplo básico: agrupar itens de pedidos por product_id e contar quantas vezes cada produto foi vendido
SELECT product_id,
       COUNT(*) AS total_vendas
  FROM order_items
  GROUP BY product_id;

-- 1.2 Regras: todas as colunas não agregadas precisam estar no GROUP BY
-- Exibir product_id e SUN(quantity) por produto 
SELECT product_id,
       SUM(quantity) AS total_quantidade
  FROM order_items
  GROUP BY product_id; 

SELECT status,
       COUNT(*) AS qtde_pedidos 
  FROM orders
  GROUP BY status; -- Agrupa pedidos por status e contar quantos pedidos existem em cada status 

SELECT city, 
       COUNT(*) AS total_clientes 
   FROM customers
  GROUP BY city; -- Agrupar clientes por cidade e exibir quantos clientes em cada cidade

-- Uso do HAVING 
-- 1.1 Exibir categorias que têm mais de 5 produtos 
SELECT category_id,
       COUNT(*) AS qtde_produtos 
   FROM products
  GROUP BY category_id
HAVING COUNT(*) > 5; -- Filtra grupos com mais de 5 produtos

-- 1.2 Mostrar clientes que fizeram pedidos em 2024 e cujo total de pedidos > 3
SELECT o.customer_id,
       COUNT(o.order_id) AS total_pedidos_2024
    FROM orders o 
   WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
   GROUP BY o.customer_id 
HAVING COUNT(o.order_id) > 3; -- somente clientes com mais de 3 pedidos em 2024

-- 1.3 mostrar produtos (product_id) cujo total de unidades vendidas (SUN(quantity)) > 100
SELECT oi.product_id, 
       SUM(oi.quantity) AS unidades_vendidas
     FROM order_items oi
  GROUP BY oi.product_id
HAVING SUM(oi.quantity) > 100; -- produtos com mais de 100 unidades vendidas

-- Uso de Agregações e LIMIT
-- 1.1 Ordenar resultados de um GROUP BY: top 3 produtos por quantidade vendida
SELECT oi.product_id, 
       SUM(oi.quantity) AS qtd_total 
    FROM order_items oi
  GROUP BY oi.product_id 
  ORDER BY SUM(oi.quantity) DESC 
  LIMIT 3; -- traz os 3 produtos mais vendidos 

-- 1.2 Top 5 clientes por faturamento (soma total_amount)
SELECT o.customer_id,
       SUM(o.total_amount) AS faturamento_total
    FROM orders o
  GROUP BY o.customer_id 
  ORDER BY faturamento_total DESC -- utiliza alias em ORDER BY 
  LIMIT 5; -- top 5 clientes por faturamento

-- Manipulação de String 
-- 1.1 CONCAT e operador || para concatenar nome e sobrenome de clientes
SELECT customer_id, 
       CONCAT(first_name, ' ', last_name) AS nome_concatenado1,
       first_name || ' ' || last_name AS nome_concatenado2
   FROM customers
  LIMIT 5; -- mostra 5 linhas de exemplo

-- 1.2 LENGTH / CHAR_LENGTH para obter tamanho de string (usando last_name)
SELECT customer_id,
       last_name,
       CHAR_LENGTH(last_name) AS tamanho_sobrenome
   FROM customers
  LIMIT 5;

-- 1.3 UPPER e LOWER para padronização de caixa
SELECT customer_id,
       UPPER(first_name) AS nome_maiusculo, 
       LOWER(last_name) AS sobrenome_minusculo
   FROM customers
  LIMIT 5;

-- 1.4 TRIM, LTRIM, RTRIM para remover espaços indesejados
-- Criar um dado de exemplo com espaços 
SELECT '  Carlos  ' AS texto_original,
       TRIM('  Carlos  ') AS texto_trim, -- tira todos os espaços indesejados
       LTRIM('  Carlos   ') AS texto_ltrim, -- tira os espaços indesejados da parte da esquerda
       RTRIM('Carlos   ' ) AS texto_rtrim; -- tira os espaços indesejados da parte da direita

-- 1.5 SUBTRING para extrair parte do texto (extrair 3 primeiros caracteres de product_name)
SELECT product_id, 
       product_name,
       SUBSTRING(product_name FROM 1 FOR 3) AS primeiros_3_caracteres
   FROM products
  LIMIT 5;

-- 1.6 POSITION para localizar substrings (posição de "Silva" em last_name)
SELECT customer_id,
       last_name, 
       POSITION('Silva' IN last_name) AS posicao_silva
   FROM customers
  WHERE last_name LIKE '%Silva%';

-- 1.7 REPLACE para substituição de trechos (trocar "Silva" por "S.")
SELECT customer_id,
       last_name, 
       REPLACE(last_name, 'Silva', 'S.') AS sobrenome_abreviado
    FROM customers
  WHERE last_name LIKE '%Silva%'; 

-- Manipulação de Números 
SELECT product_id,
       price, 
       ROUND(price, 0) AS price_arredondado_inteiro,
       ROUND(price, 1) AS price_arredondado_1_casa,
       ROUND(price, 2) AS price_arredondado_2_casas
   FROM products
 LIMIT 5;

-- 1.2 TRUNCATE (PostgreSQL usa TRUNC) para trucar valores
SELECT product_id, 
       price, 
       TRUNC(price, 0) AS price_truncado_inteiro,
       TRUNC(price, 1) AS price_truncado_1_casa
    FROM products
  LIMIT 5;

-- 1.3 CEIL e FLOOR para teto e piso numérico
SELECT product_id,
       price, 
       CEIL(price) AS price_ceil, -- menor inteiro >= price
       FLOOR(price) AS price_floor -- maior inteiro <= price
   FROM products
  LIMIT 5;

-- 1.4 ABS, POWER, SQRT para operações matemáticas
SELECT product_id,
       price,
       ABS(price * -1) AS valor_absoluto, -- valor absoluto
       POWER(price, 2) AS price_ao_quadrado, -- price^2
       SQRT(price) AS raiz_quadrada_price -- sqrt(price)
   FROM products
  LIMIT 5;

-- 1.5 MOD para resto de divisão
SELECT product_id,
       price, 
       MOD(CAST(price AS INT), 7) AS resto_divisao_por_7 -- resto de price/7
   FROM products
 LIMIT 5;

-- Conversões com CAST
-- 1.1 CAST(coluna AS tipo): converter price para inteiro
SELECT product_id,
       price, 
       CAST(price AS INT) AS price_inteiro
   FROM products
 LIMIT 5;

-- 1.2 CAST para converter data em texto 
SELECT customer_id,
       created_at, 
       CAST(created_at AS VARCHAR(20)) AS created_at_text
    FROM customers
  LIMIT 5;

-- 1.3 Converter texto em número (exemplo fictício: converter string '123' em inteiro)
SELECT '123' AS texto_original,
      CAST('123' AS INT) + 10 AS soma_exemplo -- 123 + 10 = 133

-- Subconsultas, EXISTS IN e NOT EXISTS
-- 1.1 Exemplo simples: mostrar todos os pedidos feitos por clientes que moram em 'São Paulo'
SELECT 
  o.order_id,
  o.customer_id,
  o.order_date,
  o.total_amount
FROM orders AS o
WHERE o.customer_id IN (
  SELECT c.customer_id
  FROM customers AS c
  WHERE c.city = 'São Paulo'
)
ORDER BY o.order_date; 

-- 1.2 Exemplo: listar todos os clientes que tem ao menos um pedido com status 'DELIVERED'
SELECT 
  c.customer_id,
  c.first_name, 
  c.last_name
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
    AND o.status = 'DELIVERED'
)
ORDER BY c.customer_id;

-- 1.3 Exemplo: listar produtos que ainda nunca foram vendidos (não aparecem em nenhum order_items)
SELECT
  p.product_id,
  p.product_name
FROM products p
WHERE NOT EXISTS (
  SELECT 1
  FROM order_items oi
  WHERE oi.product_id = p.product_id
)
ORDER BY p.product_id;

-- CASE e FILTER 
-- 1.1 exemplo: total faturado por status (usando CASE)
SELECT
  o.status,
  SUM(CASE WHEN o.status = 'DELIVERED' THEN o.total_amount ELSE 0 END) AS total_entregue,
  SUM(CASE WHEN o.status = 'PENDING' THEN o.total_amount ELSE 0 END) AS total_pendente, 
  SUM(o.total_amount) AS total_geral
FROM orders o
GROUP BY o.status;

-- 1.2 Exemplo: total de faturamento pago e pendente por mês (usando FILTER)
SELECT
  DATE_TRUNC('month', o.order_date) AS mes,
  SUM(o.total_amount) AS total_geral,
  SUM(o.total_amount) FILTER (WHERE o.status = 'DELIVERED') AS total_entregue,
  SUM(o.total_amount) FILTER (WHERE o.status = 'PENDING') AS total_pendente
FROM orders o
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY mes;