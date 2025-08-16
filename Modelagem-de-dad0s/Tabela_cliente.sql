-- 1. Tabela Clientes
CREATE TABLE cliente (
  cpf VARCHAR(20) PRIMARY KEY, 
  nome VARCHAR(100) NOT NULL, 
  dt_nascimento DATE,
  email VARCHAR(50) UNIQUE,                           -- cada e-mail só pode aparecer uma vez
  criado_em TIMESTAMP NOT NULL DEFAULT now(),         -- marca quando o cliente foi cadastrado
  atualizado_em TIMESTAMP NOT NULL DEFAULT now()      -- marca quando foi atualizado
);

-- 2. Tabela Produto
CREATE TABLE produto (
  codigo SERIAL PRIMARY KEY,                 
  nome VARCHAR(50) NOT NULL UNIQUE,          -- nomes não se repetem
  descricao TEXT NOT NULL,                   -- descricao
  preco_unitario DECIMAL(10,2) NOT NULL DEFAULT 0.00    
);

-- 3. Tabela Categoria 
CREATE TABLE categoria (
  codigo SERIAL PRIMARY KEY,
  nome VARCHAR(50) NOT NULL UNIQUE           -- nomes de categorias únicos
);

-- 4. Tabela Endereço
CREATE TABLE endereco (
  codigo SERIAL PRIMARY KEY,
  rua VARCHAR(50) NOT NULL,
  cep VARCHAR(9) NOT NULL, 
  cidade VARCHAR(100) NOT NULL,
  estado VARCHAR(2) NOT NULL DEFAULT 'PE',     -- valor padrão de estado
  cpf VARCHAR(20) NOT NULL,
  CONSTRAINT fk_endereco_cliente
    FOREIGN KEY (cpf) REFERENCES cliente(cpf)
);

-- 5. Tabela Pedido 
CREATE TABLE pedido (
  numero SERIAL PRIMARY KEY,
  data DATE NOT NULL DEFAULT CURRENT_DATE,         -- data padrão de hoje
  status VARCHAR(20) NOT NULL DEFAULT 'PENDENTE',  -- status inicial
  cpf VARCHAR(20) NOT NULL,
  CONSTRAINT fk_pedido_cliente
    FOREIGN KEY (cpf) REFERENCES cliente(cpf)
);

-- 6. Tabela Item_Pedido
CREATE TABLE item_pedido (
  codigo SERIAL PRIMARY KEY,
  qtd INT NOT NULL DEFAULT 1,                  -- quantidade padrão = 1
  total DECIMAL(10,2) NOT NULL DEFAULT 0.00,   -- total inicial zero
  codigo_produto INT NOT NULL,
  numero_pedido INT NOT NULL,
  CONSTRAINT fk_itempedido_produto
    FOREIGN KEY(codigo_produto) REFERENCES produto(codigo),
  CONSTRAINT fk_itempedido_pedido
    FOREIGN KEY(numero_pedido) REFERENCES pedido(numero)
);

-- 7. Tabela Produto_Categoria
CREATE TABLE produto_categoria (
  codigo SERIAL PRIMARY KEY,
  codigo_produto INT NOT NULL,
  codigo_categoria INT NOT NULL,
  CONSTRAINT fk_prodcat_produto
    FOREIGN KEY(codigo_produto) REFERENCES produto(codigo),
  CONSTRAINT fk_prodcat_categoria
    FOREIGN KEY(codigo_categoria) REFERENCES categoria(codigo),
  CONSTRAINT uq_produto_categoria UNIQUE (codigo_produto, codigo_categoria) -- cada par produto_categoria só aparece uma vez
);