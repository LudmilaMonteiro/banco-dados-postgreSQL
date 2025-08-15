INSERT INTO clientes (
  idade,
  quantidade_compras,
  pontos_acumulados,
  ticket_medio,
  desconto_medio, 
  estado,
  nome,
  observacoes,
  ativo,
  data_nascimento,
  hora_cadastro,
  notas,
  tags,
  informacoes_extras
) VALUES (
  30,                                                -- idade
  12,                                                -- quantidade_compras
  1500,                                              -- pontos acumulados
  250.75,                                            -- ticket_medio
  10.00,                                             -- desconto_medio
  'PE',                                              -- estado
  'Carlos Silva',                                    -- nome
  'Cliente frequente com histórico de boas compras', -- observacoes
  TRUE,                                              -- ativo
  '1994-05-21',                                      -- data_nascimento
  '14:30:00',                                        -- hora_cadastro
  ARRAY[8, 9, 10],                                   -- notas (array de inteiros)
  ARRAY['vip', 'newsletter'],                        -- tags (array de textos)
  '{"preferencias": "email", "idioma": "pt-BR", "aceita_promomcoes": true}'  -- informacoes_extras
);