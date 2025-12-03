CREATE DATABASE sistema_biblioteca_universitaria

-- Criação das Tabelas
-- 1. Autores
CREATE TABLE authors (
  author_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  birth_date DATE
);

-- 2. Editoras
CREATE TABLE publishers (
  publisher_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  address TEXT
);


-- 3. Gênero
CREATE TABLE genres (
  genre_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

-- 4. Livros
CREATE TABLE books (
  book_id SERIAL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  author_id INT NOT NULL REFERENCES authors(author_id),
  publisher_id INT NOT NULL REFERENCES publishers(publisher_id),
  genre_id INT NOT NULL REFERENCES genres(genre_id),
  pub_year INT,
  isbn CHAR(13) UNIQUE
);

-- 5. Unidades da Biblioteca
CREATE TABLE library_branches (
  branch_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  address TEXT
);

-- 6. Cópias de Livros
CREATE TABLE book_copies (
  copy_id SERIAL PRIMARY KEY,
  book_id INT NOT NULL REFERENCES books(book_id),
  branch_id INT NOT NULL REFERENCES library_branches(branch_id),
  status VARCHAR(20) NOT NULL DEFAULT 'available'
      -- valores possíveis: 'available', 'loaned', 'reserved', 'lost'
);

-- 7. Usuários (Membros)
CREATE TABLE members (
  member_id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  membership_start DATE NOT NULL,
  membership_end DATE
);

-- 8. Empréstimos 
CREATE TABLE loans (
  loan_id SERIAL PRIMARY KEY,
  copy_id INT NOT NULL REFERENCES book_copies(copy_id),
  member_id INT NOT NULL REFERENCES members(member_id),
  loan_date TIMESTAMP NOT NULL DEFAULT now(),
  due_date DATE NOT NULL,
  return_date DATE
);

-- 9. Reservas
CREATE TABLE reservations (
  reservation_id SERIAL PRIMARY KEY,
  copy_id INT NOT NULL REFERENCES book_copies(copy_id),
  member_id INT NOT NULL REFERENCES members(member_id),
  reservations_date TIMESTAMP NOT NULL DEFAULT now(),
  status VARCHAR(20) NOT NULL DEFAULT 'active'
    -- valores possíveis: 'active', 'fulfilled', 'cancelled'
);

-- 10. Funcionários (Bibliotecários)
CREATE TABLE librarians (
  librarian_id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  branch_id INT NOT NULL REFERENCES library_branches(branch_id)
);
