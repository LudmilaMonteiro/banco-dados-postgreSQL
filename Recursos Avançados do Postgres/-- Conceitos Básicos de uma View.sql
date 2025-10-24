-- Conceitos Básicos de uma View
-- Exemplo 1: View que lista produtos com categoria e preço acima de R$200
CREATE VIEW vw_produtos_caros AS 
SELECT
   p.product_id,
   p.name AS product_name,
   c.name AS category_name,
   p.price
 FROM products p
 JOIN categories c ON p.category_id = c.category_id
 WHERE p.price > 200;

SELECT * FROM vw_produtos_caros
ORDER BY price DESC
LIMIT 10;


UPDATE vw_produtos_caros     -- Só funciona se view for simples e não envolver agregações:
SET price = price * 0.9
WHERE category_name = 'Categoria 3';


DROP VIEW IF EXISTS vw_produtos_caros;   -- para remover a view

-- Exemplo 2:
CREATE VIEW vw_pedidos_grandes AS
SELECT
  o.order_id,
  c.name AS nome_cliente,
  SUM(oi.quantity * oi.price) AS total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.name
HAVING SUM(oi.quantity * oi.price) > 500;

SELECT * FROM vw_pedidos_grandes ORDER BY total_amount DESC;

-- Exemplo 3:
CREATE VIEW vw_resumo_vendas_mensal AS 
SELECT
   date_trunc('month', o.order_date) AS mes,
   COUNT(DISTINCT o.order_id) AS total_pedidos,
   SUM(oi.quantity * oi.price) AS valor_total 
 FROM orders o
 JOIN order_items oi ON o.order_id = oi.order_id
 GROUP BY 1
 ORDER BY mes;


SELECT * FROM vw_resumo_vendas_mensal  -- consulta dados de maio de 2024
WHERE mes = '2024-05-01';


-- Exemplo 4:
CREATE VIEW vw_itens_pedido_detalhado AS 
SELECT
   o.order_id,
   p.name AS product_name,
   oi.quantity,
   oi.price AS unit_price,
   (oi.quantity * oi.price) AS subtotal,
   o.order_date 
  FROM order_items oi
  JOIN orders o  ON oi.order_id = o.order_id
  JOIN products p  ON oi.product_id = p.product_id;

SELECT viewname FROM pg_views WHERE schemaname = 'public';


-- MATERIALIZED VIEW e Performance 
-- Exemplo 1:
CREATE MATERIALIZED VIEW mv_resumo_vendas_mensal AS 
SELECT 
  date_trunc('month', o.order_date) AS mes,
  COUNT(DISTINCT o.order_id) AS total_pedidos,
  SUM(oi.quantity * oi.price) AS valor_total
 FROM orders o
 JOIN order_items oi ON o.order_id = oi.order_id
 GROUP BY 1;

SELECT * FROM mv_resumo_vendas_mensal WHERE mes = '2024-05-01'

SELECT * FROM vw_resumo_vendas_mensal

REFRESH MATERIALIZED VIEW mv_resumo_vendas_mensal;

CREATE INDEX idx_mv_vendas_mes ON mv_resumo_vendas_mensal(mes);

SELECT * FROM mv_resumo_vendas_mensal
WHERE mes BETWEEN '2024-01-01' AND '2024-06-01';

-- Exeplo 2:
CREATE MATERIALIZED VIEW mv_top_clientes_2024 AS 
SELECT 
  c.customer_id,
  c.name AS nome_cliente,
  SUM(oi.quantity * oi.price) AS total_gasto 
 FROM customers c
 JOIN orders o ON c.customer_id = o.customer_id
 JOIN order_items oi ON o.order_id = oi.order_id
 WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
 GROUP BY c.customer_id, c.name
 HAVING SUM(oi.quantity * oi.price) > 1000
 ORDER BY total_gasto DESC;


-- Introdução a Tabelas Temporárias
-- Exemplo 1: Criar tabela temporária de vendas do mes de junho//2024
CREATE TEMPORARY TABLE tmp_pedidos_junho AS
SELECT 
  o.order_id,
  o.customer_id,
  o.order_date,
  o.status,
  SUM(oi.quantity * oi.price) AS total_amount
FROM public.orders o
JOIN public.order_items oi ON o.order_id = oi.order_id
WHERE o.order_date BETWEEN '2024-06-01' AND '2024-06-30'
GROUP BY o.order_id, o.customer_id, o.order_date, o.status;

-- Calculos agregados com base na tabela temporária
SELECT 
  COUNT(*) AS qtd_pedidos,
  SUM(total_amount) AS soma_total,
  AVG(total_amount) AS media_valor
FROM tmp_pedidos_junho;

-- Exemplo 2:
CREATE TEMPORARY TABLE tmp_clientes_ativos AS 
SELECT DISTINCT
  c.customer_id,
  c.name AS nome_completo
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date BETWEEN '2024-04-01' AND '2024-06-30';

SELECT
  t.nome_completo,
  COUNT(o.order_id) AS total_pedidos
  FROM tmp_clientes_ativos t
  JOIN orders o ON t.customer_id = o.customer_id 
  GROUP BY t.nome_completo
  ORDER BY total_pedidos DESC;


-- Casos de Uso Combinados e Boas Práticas
-- Exemplo 1:
CREATE TEMPORARY TABLE tmp_vendas_2024 AS 
SELECT 
  o.order_id,
  o.customer_id,
  o.order_date,
  o.status,
  SUM(oi.quantity * oi.price) AS total_amount
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_date >= '2024-01-01'
GROUP BY o.order_id, o.customer_id, o.order_date, o.status;

CREATE OR REPLACE VIEW vw_summary_2024 AS 
SELECT
   date_trunc('quarter', order_date) AS trimestre,
   COUNT(*) AS qtd_pedidos,
   SUM(total_amount) AS total_vendas
FROM tmp_vendas_2024
GROUP BY 1
ORDER BY trimestre;


SELECT *
FROM vw_summary_2024
ORDER BY trimestre;


-- Introdução às Funções
-- Exemplo 1:
CREATE OR REPLACE FUNCTION fn_fullname(c_id INT)
RETURNS TEXT AS $$
DECLARE 
   v_first VARCHAR;
   v_last VARCHAR;
BEGIN 
  SELECT first_name, last_name
     INTO v_first, v_last
  FROM customers
  WHERE customer_id = c_id;

  RETURN v_first || ' ' || v_last;
END;
$$ LANGUAGE plpgsql;

SELECT fn_fullname(42) AS nome_completo;


-- Conceitos Avançados de Funções
-- Exemplo 1:
CREATE OR REPLACE FUNCTION fn_order_total(o_id INT)
RETURNS NUMERIC AS $$
DECLARE 
    v_total NUMERIC;
BEGIN 
   SELECT SUM(quantity * price)
      INTO v_total
   FROM order_items
   WHERE order_id = o_id;

   RETURN COALESCE(v_total, 0);
END;
$$ LANGUAGE plpgsql;

SELECT fn_order_total(496) AS total_pedido;

-- Exemplo 2:
CREATE OR REPLACE FUNCTION fn_order_items(o_id INT)
RETURNS TABLE(
  product_name VARCHAR,
  qty INT,
  subtotal NUMERIC 
) AS $$ 
BEGIN 
   RETURN QUERY 
   SELECT
      p.product_name, 
      oi.quantity,
      oi.quantity * oi.unit_price AS subtotal
   FROM order_items oi

SELECT * FROM fn_order_items(496);


-- INSERT, UPDATE e DELETE em Funções
-- Exemplo 1:
CREATE OR REPLACE FUNCTION fn_add_customer(
  p_name VARCHAR,
  p_email VARCHAR,
  p_phone VARCHAR
)
RETURNS INT AS $$
DECLARE 
  v_id INT;
BEGIN 
  INSERT INTO customers (name, email, phone)
  VALUES (p_name, p_email, p_phone)
  RETURNING customer_id INTO v_id;

  RETURN v_id;
END;
$$ LANGUAGE plpgsql;

SELECT fn_add_customer('Ana Silva', 'ana@exemplo.com', '(51)99999-9999');

-- Exemplo 2:
CREATE OR REPLACE FUNCTION fn_update_email(c_id INT, novo_email TEXT)
RETURNS BOOLEAN AS $$
BEGIN 
   UPDATE customers
   SET email = novo_email
   WHERE customer_id = c_id;

   IF FOUND THEN 
     RETURN TRUE; 
   ELSE 
     RETURN FALSE;
   END IF;
END;
$$ LANGUAGE plpgsql;

SELECT fn_update_email (202, 'ana@teste.com') AS result

-- Exemplo 2:
CREATE OR REPLACE FUNCTION fn_delete_customer(c_id INT)
RETURNS TEXT AS $$
BEGIN 
   IF EXISTS (
     SELECT 1 FROM orders WHERE customer_id = c_id 
   ) THEN 
    RETURN 'Erro: cliente possui pedido.';
   ELSE 
     DELETE FROM customers WHERE customer_id = c_id;
     RETURN 'Cliente excluido com sucesso!';
   END IF;
END;
$$ LANGUAGE plpgsql;

SELECT fn_delete_customer (202) AS result


-- Exemplo 3:
CREATE OR REPLACE FUNCTION fn_create_order(
  p_customer_id INT,
  p_items JSON
)
RETURNS TEXT AS $$
DECLARE 
   v_order_id INT;
   v_item JSON;
BEGIN 
   -- Cria o pedido
   INSERT INTO orders (customer_id, order_date, status)
   VALUES (p_customer_id, NOW(), 'PENDING')
   RETURNING order_id INTO v_order_id;

   -- Insere os itens
   FOR v_item IN SELECT * FROM json_array_elements(p_items)
   LOOP
     INSERT INTO order_items (order_id, product_id, quantity, price)
     VALUES (
         v_order_id,
         (v_item->>'product_id')::INT,
         (v_item->>'quantity')::INT,
         (v_item->>'unit_price')::NUMERIC
     );
   END LOOP;

   RETURN FORMAT('Pedido %s criado com sucesso.', v_order_id);

EXCEPTION 
   WHEN OTHERS THEN 
       RAISE NOTICE 'Erro ao criar pedido. Revertendo...';
       RAISE;
END;
$$ LANGUAGE plpgsql;

SELECT fn_create_order(
  2,
  '[
     {"product_id": 1, "quantity": 2, "unit_price": 4500.00},
     {"product_id": 2, "quantity": 1, "unit_price": 120.00},
     {"product_id": 3, "quantity": 4, "unit_price": 250.00}
  ]'::json
) AS resultado;


-- Introdução às TRIGGERS 
-- Exemplo 1:
-- criação da tabela:
CREATE TABLE orders_audit (
  audit_id SERIAL PRIMARY KEY,
  order_id INT,
  action VARCHAR(10),
  action_time TIMESTAMP 
);


CREATE OR REPLACE FUNCTION tg_audit_order()
RETURNS TRIGGER AS $$
BEGIN 
   INSERT INTO orders_audit(order_id, action, action_time)
   VALUES (
       COALESCE(NEW.order_id, OLD.order_id),
       TG_OP,
       NOW()
   );
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_order_audit
AFTER INSERT OR UPDATE OR DELETE
ON orders
FOR EACH ROW
EXECUTE FUNCTION tg_audit_order();

-- fazendo uma alteração para testar
UPDATE orders
SET status = 'SHIPPED'
WHERE order_id = 42;

-- verificando o log da auditoria
SELECT * FROM orders_audit WHERE order_id = 42;


-- Operações Avançadas com Triggers 
-- Exemplo 1:
CREATE OR REPLACE FUNCTION tg_validate_product_price()
RETURNS TRIGGER AS $$
BEGIN
   IF NEW.price < 0 THEN
     RAISE EXCEPTION 'Preço não pode ser negativo. Valor informado: %', NEW.price;
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_price
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION tg_validate_product_price();

INSERT INTO products (product_name, category_id, price) VALUES ('Teste Trigger', 9, 20)

-- Introdução às Stored Procedures
-- Exemplo 1:
CREATE OR REPLACE PROCEDURE sp_update_product_price(
  p_product_id INT,
  p_new_price NUMERIC 
)
LANGUAGE plpgsql AS $$ 
BEGIN 
  UPDATE products
     SET price = p_new_price
  WHERE product_id = p_product_id;

  IF NOT FOUND THEN 
    RAISE EXCEPTION 'Produto % não existe', p_product_id;
  END IF;
END;
$$;

CALL sp_update_product_price(3, 199.90);

-- Exemplo 2:
CREATE OR REPLACE PROCEDURE sp_cancel_order(
  p_order_id INT 
)
LANGUAGE plpgsql AS $$
BEGIN
 DELETE FROM order_items WHERE order_id = p_order_id;
 DELETE FROM orders WHERE order_id = p_order_id;

 IF NOT FOUND THEN 
   RAISE NOTICE 'Pedido % não encontrado', p_order_id;
 ELSE 
   RAISE NOTICE 'Pesiso % e itens removidos', p_order_id;
 END IF;
END;
$$;

CALL sp_cancel_order(2);