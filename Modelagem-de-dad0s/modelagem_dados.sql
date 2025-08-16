-- INSERT
INSERT INTO cliente (cpf, nome, dt_nascimento, email)
VALUES 
  ('11122233344', 'João Silva', '1980-05-15', 'joao.silva@example.com'),
  ('55566677788', 'Maria Souza', '1992-10-30', 'maria.souza@example.com');


INSERT INTO endereco (rua, cep, cidade, estado, cpf)
VALUES 
  ('Av. Paulista, 1000', '01210-100', 'São Paulo', 'SP', '11122233344'),
  ('Rua das Flores, 123', '2040-020', 'Rio de Janeiro', 'RJ', '11122233344');


INSERT INTO pedido (cpf, data, status)
VALUES 
  ('11122233344', '2025-05-21', 'PENDENTE'),
  ('11122233344', DEFAULT, DEFAULT);


INSERT INTO produto (nome, descricao, preco_unitario)
VALUES 
  ('Camisa Polo', 'produto 1', 79.90),
  ('Calça Jeans', 'produto 2', 129.90);


-- UPDATE
UPDATE cliente
SET email ='joao.s.new@example.com'
WHERE cpf = '11122233344';


-- DELETE 
DELETE FROM cliente 
WHERE cpf = '55566677788';




SELECT * FROM cliente
SELECT * FROM endereco
SELECT * FROM pedido
SELECT * FROM produto