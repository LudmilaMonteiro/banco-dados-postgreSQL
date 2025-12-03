-- Funções de Agregação 
-- 1. Total de empréstimos por livro 
SELECT b.title,
     COUNT(*) AS total_loans
FROM loans l
JOIN book_copies bc USING(copy_id)
JOIN books b USING(book_id)
GROUP BY b.title;


-- 2. Data mais antiga e mais recente de empréstimo
SELECT MIN(loan_date) AS first_loan,
       MAX(loan_date) AS last_loan 
FROM loans; 


-- 3. Duração média de um empréstimo (em dias)
SELECT AVG((due_date - loan_date)) AS avg_loan_duration_days
FROM loans
WHERE return_date IS NOT NULL;


-- 4. Soma total de reservas "active"
SELECT SUM(
  CASE WHEN status = 'active' THEN 1 ELSE 0 END
  ) AS total_active_reservations
FROM reservations;


-- Ordenação e Agrupamento 
-- 1. Top 5 livros mais emprestados 
SELECT b.title,
       COUNT(*) AS times_loaned
FROM loans l
JOIN book_copies bc USING(copy_id)
JOIN books b USING(book_id)
GROUP BY b.title
ORDER BY times_loaned DESC
LIMIT 5; 


-- 2. Número de reservas por membro, em ordem decrescente 
SELECT m.full_name,
       COUNT(r.*) AS reservations_count
FROM members m
LEFT JOIN reservations r USING(member_id)
GROUP BY m.full_name
ORDER BY reservations_count DESC;


-- 3. Filiais com mais cópias disponíveis 
SELECT lb.name,
       COUNT(*) AS available_copies
FROM book_copies bc
JOIN library_branches lb USING(branch_id)
WHERE bc.status = 'available'
GROUP BY lb.name
ORDER BY available_copies DESC;


-- INNER JOIN: conectando tabelas relacionadas 
-- 1. Listar cada livro com seu autor e editora
SELECT 
   b.title,
   a.first_name || ' ' || a.last_name AS author,
   p.name AS publisher
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
INNER JOIN publishers p ON b.publisher_id = p.publisher_id; 


-- 2 Mostrar todas as cópias emprestadas com título do livro e nome do membro 
SELECT
   bc.copy_id,
   b.title,
   m.full_name AS member,
   l.loan_date,
   l.due_date
FROM loans l
INNER JOIN book_copies bc ON l.copy_id = bc.copy_id
INNER JOIN books b ON bc.book_id = b.book_id
INNER JOIN members m ON l.member_id = m.member_id;


-- 3. Exibir reservas ativas com nome do livro, filial e data de reserva
SELECT
   r.reservation_id,
   b.title,
   lb.name AS branch,
   r.reservations_date 
FROM reservations r
INNER JOIN book_copies bc ON r.copy_id = bc.copy_id
INNER JOIN books b ON bc.book_id = b.book_id
INNER JOIN library_branches lb ON bc.branch_id = lb.branch_id
WHERE r.status = 'active';



-- LEFT, RUGHT e FULL JOIN: junções externas 
-- 1. LEFT JOIN: listar todos os membros e, se houver, quantos empréstimos fizeram 
SELECT
   m.member_id,
   m.full_name, 
   COUNT(l.loan_id) AS total_loans
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
GROUP BY m.member_id, m.full_name
ORDER BY total_loans DESC;


-- 2. RIGHT JOIN: mostrar todas as cópias e, se houver, dados de empréstimo
SELECT
   bc.copy_id,
   b.title, 
   l.loan_id, 
   l.loan_date
FROM book_copies bc
RIGHT JOIN loans l ON bc.copy_id = l.copy_id
JOIN books b ON bc.book_id = b.book_id
LIMIT 20;


-- 3. FULL JOIN: combinar empréstimos e reservas para ver todos os movimentos 
SELECT
   COALESCE(l.loan_id, r.reservation_id) AS movement_id,
   l.loan_date,
   r.reservations_date,
   CASE
     WHEN l.loan_id IS NOT NULL THEN 'loan'
     WHEN r.reservation_id IS NOT NULL THEN 'reservation'
     ELSE 'unknown'
   END AS type
FROM loans l
FULL JOIN reservations r ON l.copy_id = r.copy_id
   AND l.member_id = r.member_id
ORDER BY movement_id
LIMIT 50;


-- Consultas com múltiplas tabelas 
-- 1. Top 5 membros que mais reservaram livros, com título mais reservado
WITH member_reservations AS (
  SELECT
     m.member_id,
     m.full_name,
     COUNT(r.reservation_id) AS reservations_count
  FROM members m
  JOIN reservations r USING(member_id)
  GROUP BY m.member_id, m.full_name
)
SELECT
   mr.full_name,
   mr.reservations_count,
   b.title AS most_reserved_title
FROM member_reservations mr 
JOIN (
  SELECT 
     r.member_id,
     r.copy_id,
     COUNT(*) AS cnt
  FROM reservations r
  GROUP BY r.member_id, r.copy_id
  ORDER BY cnt DESC
  LIMIT 5
) top5 USING(member_id)
JOIN book_copies bc ON top5.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
ORDER BY mr.reservations_count DESC; 


-- 2. Inventário por gênero e filial: quantas cópias disponíveis existem 
SELECT
   g.name AS genre,
   lb.name AS branch,
   COUNT(bc.*) AS available_copies 
FROM genres g
JOIN books b USING(genre_id)
JOIN book_copies bc ON b.book_id = bc.book_id
JOIN library_branches lb ON bc.branch_id = lb.branch_id
WHERE bc.status = 'available'
GROUP BY g.name, lb.name
ORDER BY g.name, lb.name;


-- 3. Histórico de empréstimos por bibliotecários: quantos empréstimos ocorridos na filial de cada
SELECT
   lib.full_name AS librarian,
   lb.name AS branch,
   COUNT(l.loan_id) AS loans_processed
FROM librarians lib
JOIN library_branches lb USING(branch_id)
JOIN book_copies bc ON bc.branch_id = lb.branch_id
JOIN loans l ON l.copy_id = bc.copy_id
GROUP BY lib.full_name, lb.name
ORDER BY loans_processed DESC
LIMIT 10;


-- Consultas avançadas e subconsultas 
-- 1. Selecionar livros que já foram emprestados mais de 10 vezes 
SELECT * FROM books b
WHERE (
  SELECT COUNT(*)
  FROM loans l
  JOIN book_copies bc ON l.copy_id = bc.copy_id
  WHERE bc.book_id = b.book_id
) > 10;


-- 2. Listar membros que nunca fizeram empréstimos
SELECT * FROM members m
WHERE NOT EXISTS (
  SELECT 1
  FROM loans l
  WHERE l.member_id = m.member_id 
);


-- 3. Mostrar cópias cuja última movimentação (empréstimo ou reserva) foi há mais de 60 dias 
SELECT * FROM book_copies bc
WHERE GREATEST (
  COALESCE((SELECT MAX(loan_date) FROM loans WHERE copy_id = bc.copy_id), '1900-01-01'),
  COALESCE((SELECT MAX(reservations_date) FROM reservations WHERE copy_id = bc.copy_id), '1900-01-01')
) < CURRENT_DATE - INTERVAL '60 days';


-- 4. CTE aninhada: primeiro filtra reservas ativas, depois conta por membro 
WITH active_res AS (
  SELECT member_id
  FROM reservations
  WHERE status = 'active'
),
res_counts AS (
  SELECT member_id, COUNT(*) AS cnt
  FROM active_res
  GROUP BY member_id
)
SELECT m.full_name, rc.cnt
FROM res_counts rc
JOIN members m ON m.member_id = rc.member_id
ORDER BY rc.cnt DESC; 


-- UNION, INTERSECT e EXCEPT
-- 1. UNION: todos os membros que têm empréstimos ou reservas 
SELECT member_id, full_name, 'loan' AS activity
FROM members WHERE member_id IN (SELECT DISTINCT member_id FROM loans)
UNION 
SELECT member_id, full_name, 'reservations' AS activity
FROM members WHERE member_id IN (SELECT DISTINCT member_id FROM reservations);


-- 2. INTERSECT: membros que fizeram empréstimos e também reserva 
SELECT member_id
FROM loans
INTERSECT
SELECT member_id
FROM reservations;


-- 3. EXCEPT: membros que reservaram mas não emprestaram 
SELECT member_id
FROM reservations
EXCEPT
SELECT member_id
FROM loans;


-- Window Functions (ROW_NUMBER, RANK)
-- 1. Numeração dos empréstios por membro (ordem cronológica)
SELECT
   l.loan_id,
   l.member_id,
   l.loan_date,
   ROW_NUMBER() OVER (PARTITION BY l.member_id ORDER BY l.loan_date) AS rn
 FROM loans l;


-- 2. Ranking de livros por total de empréstimos
SELECT
   b.book_id,
   b.title,
   COUNT(*) AS total_loans,
   RANK() OVER (ORDER BY COUNT(*) DESC) AS loan_rank
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
GROUP BY b.book_id, b.title; 


--- LAG e LEAD: analisando dados sequenciais
-- 1. Para cada empréstimo, mostrar data do empréstimo anterior do mesmo membro
SELECT
   loan_id,
   member_id,
   loan_date,
   LAG(loan_date) OVER (PARTITION BY member_id ORDER BY loan_date) AS prev_loan_date
FROM loans;


-- 2. Para cada livro emprestado, mostrar qual será a próxima data de devolução prevista 
SELECT 
   l.loan_id,
   bc.book_id,
   l.loan_date,
   l.due_date,
   LEAD(due_date) OVER (PARTITION BY bc.book_id ORDER BY l.loan_date) AS next_due_date
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id;


-- Otimização e Performance 
-- 1. Índice para acelerar buscas por data de empréstimo
CREATE INDEX idx_loans_loan_date
   ON loans(loan_date);

-- 2. Índice composto para filtrar por status e filial rapidamente 
CREATE INDEX idx_copies_status_branch
   ON book_copies(status, branch_id);

-- 3. Índice para buscas por gênero e ordenação por título
CREATE INDEX idx_books_genre_title
   ON books(genre_id, title);

-- 4. Índice para consultas em members(email) - busca de login ou notificação
CREATE INDEX idx_members_email
   ON members(email);


-- VIEWS 
-- 1. View: livros disponíveis por filial
CREATE VIEW available_copies_per_branch AS
SELECT
   lb.name AS branch,
   b.title,
   COUNT(*) AS available_count
FROM book_copies bc
JOIN books b USING(book_id)
JOIN library_branches lb USING(branch_id)
WHERE bc.status = 'available'
GROUP BY lb.name, b.title;

SELECT * FROM available_copies_per_branch       -- uso da view 
WHERE available_count > 5
ORDER BY branch, available_count DESC;


-- 2. Tabela temporária: estatísticas de empréstimos do dia 
CREATE TEMP TABLE today_loan_stats AS
SELECT 
   COUNT(*) AS total_loans,
   COUNT(DISTINCT member_id) AS distinct_members,
   MIN(loan_date) AS first_loan, 
   MAX(loan_date) AS last_loan
FROM loans
WHERE loan_date::date = CURRENT_DATE

SELECT * FROM today_loan_stats;     -- uso da temp table


-- Triggers e Funções 
-- 1. Função que marca uma cópia como "loaned" após inserir empréstimo
CREATE FUNCTION fn_mark_loaned() RETURNS trigger AS $$ 
BEGIN
   UPDATE book_copies
   SET status = 'loaned'
   WHERE copy_id = NEW.copy_id;
   RETURN NEW; 
END;
$$ LANGUAGE plpgsql; 


-- 2. Trigger que chama a função após insert em loans
CREATE TRIGGER trg_after_insert_loan
   AFTER INSERT ON loans
   FOR EACH ROW
   EXECUTE FUNCTION fn_mark_loaned();

INSERT INTO loans (copy_id, member_id, loan_date, due_date, return_date)
VALUES (2, 1, NOW(), CURRENT_DATE + INTERVAL '14 days', NULL);


-- 3. Função que impede reserva se a cópia não estiver "available"
CREATE FUNCTION fn_check_reserve() RETURNS trigger AS $$
BEGIN
   IF (SELECT status FROM book_copies WHERE copy_id = NEW.copy_id) <> 'available' THEN
     RAISE EXCEPTION 'Cópia % não está disponível para reserva', NEW.copy_id; 
   END IF; 
   RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_before_insert_reservation
   BEFORE INSERT ON reservations
   FOR EACH ROW
   EXECUTE FUNCTION fn_check_reserve();

INSERT INTO reservations (copy_id, member_id, reservations_date, status)
VALUES (2, 1, NOW(), 'active');


-- Stored Procedure e Transações
-- 1. Procedure para criar empréstimos completo (insere loan + atualiza cópia)
CREATE PROCEDURE sp_create_loan(
  p_copy_id INT,
  p_member_id INT,
  p_days INT
)
LANGUAGE plpgsql
AS $$ 
BEGIN 
   INSERT INTO loans(copy_id, member_id, loan_date, due_date)  -- inicia transação implícita
   VALUES (p_copy_id, p_member_id, NOW(), NOW() + (p_days || ' days')::interval);

   UPDATE book_copies
   SET status = 'loaned'
   WHERE copy_id = p_copy_id;
END;
$$; 

CALL sp_create_loan(124, 46, 14);  -- chamada


-- 2. Exemplo de transação manual com SAVEPOINT e ROLLBACK parcial
BEGIN;
   INSERT INTO loans(copy_id, member_id, loan_date, due_date)   -- insere um empréstimo
   VALUES (198, 11, NOW(), NOW() + INTERVAL '14 days');

   SAVEPOINT sp_after_loan;

   UPDATE book_copies    -- tentar atualizar cópia 
   SET status = 'loaned'
   WHERE copy_id = 198;


   -- simula erro
   -- RAISE EXCEPTION 'Erro simulado';

COMMIT;  -- se algo falhar entre BEGIN e COMMIT, todo o bloco é desfeito (atomicidade)