-- Big Date e Bancos Relacionais 
-- Criar 100 autores
INSERT INTO authors (first_name, last_name, birth_date)
SELECT
  'Author' || i, 'Sobrenome' || i, DATE '1970-01-01' + (i % 100) * INTERVAL '365 days'
FROM generate_series(1, 100) AS s(i);

-- Criar 100 editoras
INSERT INTO publishers (name, address)
SELECT 'Editora ' || i, 'Endereço ' || i
FROM generate_series(1, 100) AS s(i);

-- Criar 10 gêneros 
INSERT INTO genres (name)
SELECT 'Gênero ' || i FROM generate_series(1,10) AS s(i);

-- Criar 10.000 livros 
INSERT INTO books (title, author_id, publisher_id, genre_id, pub_year, isbn)
SELECT
  'Livro' || i,
  (RANDOM() * 99 + 1)::INT,
  (RANDOM() * 99 + 1)::INT,
  (RANDOM() * 9 + 1)::INT,
  (RANDOM() * 30+ 1990)::INT,
  LPAD(i::TEXT, 13, '0')
FROM generate_series(1, 10000) AS s(i);

-- Criar 1.000 membros 
INSERT INTO members (full_name, email, phone, membership_start, membership_end)
SELECT
  'Membro ' || i,
  'email' || i || '@exemplo.com',
  '99999-000' || i, 
  CURRENT_DATE - (i % 365),
  CURRENT_DATE + (i % 365)
FROM generate_series(1, 1000) AS s(i);

-- Cada livro terá 2 cópias em média
INSERT INTO book_copies (book_id, branch_id)
SELECT
  (RANDOM() * 9999 + 1)::INT,
  1  -- supondo que a branch com ID 1 já exista
FROM generate_series(1, 20000);

-- Inserir 10 milhões de empréstimos (demorado!)
INSERT INTO loans (copy_id, member_id, loan_date, due_date)
SELECT
  (RANDOM() * 19999 + 1)::INT,
  (RANDOM() * 999 + 1)::INT,
  NOW() - (RANDOM() * 365 * INTERVAL '1 day'),
  NOW() + INTERVAL '15 days'
FROM generate_series(1, 1000000);

SELECT COUNT (*) FROM loans

SELECT * FROM pg_stat_activity WHERE datname = 'sistema_biblioteca_universitaria';

EXPLAIN ANALYZE
SELECT * FROM loans WHERE member_id = 10;
