-- Tabela: authors 
-- 2 INSERTs
INSERT INTO authors (first_name, last_name, birth_date)
VALUES ('João', 'Silva', '1975-04-12');
INSERT INTO authors (first_name, last_name, birth_date)
VALUES ('Maria', 'Oliveira', '1980-11-30');

-- 1 UPDATE 
UPDATE authors 
SET last_name = 'Pereira'
WHERE author_id = 1;

-- 1 DELETE 
DELETE FROM authors
WHERE author_id = 2;

DELETE FROM books
WHERE author_id = 2;

-- 1 SELECT 
SELECT * FROM books WHERE author_id = 2;


-- Tabela: publishers 
-- 2 INSERTs
INSERT INTO publishers (name, address)
VALUES ('Editora Alfa', 'Rua das Flores, 123');
INSERT INTO publishers (name, address)
VALUES ('Beta Publicações', 'Av. Brasil, 456');

-- 1 UPDATE 
UPDATE publishers 
SET address = 'Av. das Américas, 789'
WHERE publisher_id = 1;

-- 1 DELETE 
DELETE FROM publishers 
WHERE publisher_id = 2;

-- 1 SELECT
SELECT * FROM publishers; 


-- Tabela: genres 
-- 2 INSERTs 
INSERT INTO genres (name) VALUES ('Thriller');
INSERT INTO genres (name) VALUES ('Autoajuda');

-- 1 UPDATE 
UPDATE genres 
SET name = 'Biografia'
WHERE genre_id = 1;

-- 1 DELETE 
DELETE FROM genres
WHERE genre_id = 2;

-- 1 SELECT
SELECT * FROM genres;


-- Tabela: books 
-- 2 INSERTs 
INSERT INTO books (title, author_id, publisher_id, genre_id, pub_year, isbn)
VALUES ('Aprendendo SQL', 1, 1, 3, 2021, '978123456890');
INSERT INTO books (title, author_id, publisher_id, genre_id, pub_year, isbn)
VALUES ('Design Ptterns', 3, 2, 1, 2018, '9780987654321');

-- 1 UPDATE 
UPDATE books
SET pub_year = 2022
WHERE book_id = 1;

-- 1 DELETE 
DELETE FROM books
WHERE book_id = 2; 

-- 1 SELECT 
SELECT * FROM books;


-- Tabela: library_branches 
-- 2 INSERTs 
INSERT INTO library_branches (name, address)
VALUES ('North Branch', 'Rua Norte, 100');
INSERT INTO library_branches (name, address)
VALUES ('South Branch', 'Rua Sul, 200');

-- 1 UPDATE 
UPDATE library_branches 
SET address = 'Av. Central, 300'
WHERE branch_id = 1;

-- 1 DELETE 
DELETE FROM library_branches
WHERE branch_id = 2;

-- 1 SELECT 
SELECT * FROM library_branches;


-- Tabela: book_copies 
-- 2 INSERTs 
INSERT INTO book_copies (book_id, branch_id, status)
VALUES (1, 1, 'available');
INSERT INTO book_copies (book_id, branch_id, status)
VALUES (3, 1, 'available');

-- 1 UPDATE 
UPDATE book_copies 
SET status = 'lost'
WHERE copy_id = 1;

-- 1 DELETE 
DELETE FROM book_copies
WHERE copy_id = 2

-- 1 SELECT
SELECT * FROM book_copies;


-- Tabela: members 
-- 2 INSERTs 
INSERT INTO members (full_name, email, phone, membership_start, membership_end)
VALUES ('Ana Costa', 'ana.costa@uni.edu', '555-0101', '2024-01-15', '2025-01-14');
INSERT INTO members (full_name, email, phone, membership_start, membership_end)
VALUES ('Carlos Lima', 'c.lima@uni.edu', '555-0102', '2024-02-01', '2025-01-31');

-- 1 UPDATE 
UPDATE members 
SET phone = '555-0202'
WHERE member_id = 1; 

-- 1 DELETE 
DELETE FROM members 
WHERE member_id = 2

-- 1 SELECT 
SELECT * FROM members;


-- Tabela: loans 
INSERT INTO loans (copy_id, member_id, loan_date, due_date, return_date)
VALUES (1, 1, NOW(), CURRENT_DATE + INTERVAL '14 days', NULL);
INSERT INTO loans (copy_id, member_id, loan_date, due_date, return_date)
VALUES (3, 1, NOW() - INTERVAL '7 days', CURRENT_DATE + INTERVAL '7 days', NULL);

-- 1 UPDATE 
UPDATE loans 
SET return_date = CURRENT_DATE 
WHERE loan_id = 1; 

-- 1 DELETE 
DELETE FROM loans