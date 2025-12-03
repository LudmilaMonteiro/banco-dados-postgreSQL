-- Filtros Complexos
-- 1. Empréstimos atrasados: sem data de devolução e data de vencimento passada
SELECT * FROM loans 
WHERE return_date IS NULL
   AND due_date < CURRENT_DATE;


-- 2. Livros de gêneros específicos (Sci-Fi, Fantasy, Mystery = IDs 3,4,5)
SELECT b.title, g.name AS genre
FROM books b 
JOIN genres g USING(genre_id)
WHERE b.genre_id IN (3,4,5);


-- 3. Reservas em junho de 2025 ou ainda ativas
SELECT * FROM reservations 
WHERE reservations_date BETWEEN '2025-06-01' AND '2025-06-30'
   OR status = 'active';


-- 4. Membros cujo nome contenha "Ana" ou email termine em "@uni.edu", mas que tenham telefone cadastrado
SELECT * FROM members
WHERE (full_name ILIKE '%Ana%' OR email LIKE '%@uni.edu')
   AND phone IS NOT NULL;


-- 5. Livros que não são Fictions (genre_id != 1) e foram publicados entre 1990 e 2000
SELECT * FROM books
WHERE genre_id <> 1
   AND pub_year BETWEEN 1990 AND 2000;


-- 6. Autores cujo sobrenome começa com "Pe" (case-insensitive) e com data de nascimento conhecida
SELECT * FROM authors
WHERE last_name ILIKE 'Pe%'
   AND birth_date IS NOT NULL;


-- 7. Membros com assinatura ativa (membership_end no futuro) ou sem data de término definida 
SELECT * FROM members
WHERE membership_end > CURRENT_DATE
   OR membership_end IS NULL;


-- 8. Cópias que estão em determinadas filiais (branch_id em 1 ou 3) e que não estão disponíveis 
SELECT * FROM book_copies
WHERE branch_id IN (1,3)
   AND status <> 'available';


-- 9. Empréstimos sem devolução (`return_date` nulo) que venceram há mais de 7 dias
SELECT * FROM loans
WHERE return_date IS NULL
   AND due_date < CURRENT_DATE - INTERVAL '7 days';


-- 10. Livros cujo titulo contém "Data" ou "Science" (qualquer capitalização)
SELECT * FROM books
WHERE title ILIKE '%data%'
   OR title ILIKE '%science%';


-- 11. Reservas cujo status não está em ('fulfilled', 'cancelled') - usando `NOT IN`
SELECT * FROM reservations
WHERE status NOT IN ('fulfilled', 'cancelled');


-- 12. Livros que possuem ao menos 1 cópia perdida - usando `EXISTS`
SELECT b.* 
FROM books b
WHERE EXISTS (
  SELECT 1
  FROM book_copies bc
  WHERE bc.book_id = b.book_id
    AND bc.status = 'lost'
);


-- 13. Membros que já pegaram emprestado todos os livros de um autor específico (author_id = 5)
SELECT m.*
FROM members m
WHERE NOT EXISTS (
  SELECT 1
  FROM books b
  WHERE b.author_id = 5
    AND NOT EXISTS (
        SELECT 1
        FROM loans l
        JOIN book_copies bc ON bc.copy_id = l.copy_id
        WHERE bc.book_id = b.book_id 
           AND l.member_id = m.member_id 
    )
);


-- 14. Bibliotecários alocados em qualquer uma das filiais 2, 3 ou 4 (exemplo de `ANY`)
SELECT * FROM librarians
WHERE branch_id = ANY(ARRAY[2,3,4]);


-- 15. Livros cujo ISBN começa com '9780' e publicados depois de 2010
SELECT * FROM books
WHERE isbn LIKE '9780%'
   AND pub_year > 2010;


-- 16. Publicadoras cujo endereço contenha 'Av.' mas que não tenham sido deletadas
SELECT * FROM publishers
WHERE address LIKE '%Av.%'
  AND (is_active IS TRUE OR is_active IS NULL);


-- 17. Empréstimos feitos em fins de semana (sábado ou domingo)
SELECT * FROM loans
WHERE EXTRACT (DOW FROM loan_date) IN (0,6);


-- 18. Reservas feitas no último mês, mas apenas de membros cujo email termina em `.edu`
SELECT r.*
FROM reservations r
JOIN members m USING (member_id)
WHERE r.reservations_date >= (CURRENT_DATE - INTERVAL '1 month')
   AND m.email LIKE '%.edu';


-- 19. Livros cujo título não tenham espaços (títulos "one-word") - usando `NOT LIKE`
SELECT * FROM books
WHERE title NOT LIKE '% %';