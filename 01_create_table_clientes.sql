CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Criar a tabela clientes
CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,                                -- ID autoincremento
  codigo_uuid UUID DEFAULT uuid_generate_v4(),          -- UUID automático
  idade SMALLINT,                                       -- Idade do cliente
  quantidade_compras INTEGER,                           -- Número de compras realizadas
  pontos_acumulados BIGINT,                             -- Pontuação do programa fidelidade
  ticket_medio NUMERIC(10, 2),                          -- Valor médio de compra
  desconto_medio DECIMAL (5, 2),                        -- Desconto aplicado
  estado CHAR(2),                                       -- Sigla do estado (UF)
  nome VARCHAR(100),                                    -- Nome do cliente
  observacoes TEXT,                                     -- Observações ou histórico do cliente
  ativo BOOLEAN,                                        -- Se o cliente está ativo
  data_nascimento DATE,                                 -- Data de nascimento
  hora_cadastro TIME,                                   -- Hora do cadastro
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,        -- Quando foi criado
  atualizado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,  -- Quando foi atualizado
  notas INTEGER[],                                      -- Notas de avaliações do cliente
  tags TEXT[],                                          -- Tags (ex: "vip", "inadimplente")
  informacoes_extras JSONB                              -- Dados adicionais estruturados
);