-- INSERTS
-- 1. escola
INSERT INTO escola (cnpj, nome, telefone_com, rua, cep, cidade, estado)
VALUES 
  ('12345678901234', 'Escola Alfa', '(11) 4000-1234', 'Rua das Flores, 100', '01234-00', 'São Paulo', 'SP'),
  ('98765432109876', 'Escola Beta', '(21) 3000-5678', 'Av. Central, 200', '21000-000', 'Rio de Janeiro', 'RJ');
SELECT * FROM escola;

-- 2. professor
INSERT INTO professor (telefone_cel, cpf, rua, cep, cidade, estado, cnpj_escola)
VALUES 
  ('(11) 91234-0001', '11122233344', 'Rua das Flores, 100', '01234-000', 'São Paulo', 'SP', '12345678901234'),
  ('(21) 99876-0002', '55566677788', 'Av. Central, 200', '21000-000', 'Rio de Janeiro', 'RJ', '98765432109876');
SELECT * FROM professor;

-- 3. turma
INSERT INTO turma (sala, turno, cnpj_escola)
VALUES 
  ('A101', 'Matutino', '12345678901234'),
  ('B202', 'Vespertino', '98765432109876');
SELECT * FROM turma;

-- 4. aluno
INSERT INTO aluno (nome, cnpj_escola, codigo_turma)
VALUES 
  ('Maria Souza', '12345678901234', 1),
  ('José Silva', '98765432109876', 2);
SELECT * FROM aluno;

-- 5. disciplina
INSERT INTO disciplina (nome, ementa, carga_horaria, matricula_professor)
VALUES 
  ('Matemática Básica', 'Aritmética, Álgebra linear', 60, 3),
  ('História do Brasil', 'Colonização até Contemporaneidade', 45, 4);
SELECT * FROM disciplina;


-- 6. turma_disciplina
INSERT INTO turma_disciplina (codigo_turma, codigo_disciplina, dt_inicio, dt_termino)
VALUES 
  (1, 5, '2025-03-01', '2025-07-31'),
  (2, 6, '2025-03-01', '2025-07-31');
SELECT * FROM turma_disciplina;


-- 7. endereço
INSERT INTO endereco (rua, cep, cidade, estado, matricula)
VALUES 
  ('Rua das Flores, 100', '01234-00', 'São Paulo', 'SP', 1),
  ('AV. Central, 200', '21000-000', 'Rio de Janeiro', 'RJ', 2);
SELECT * FROM endereco;


-- 8. telefone
INSERT INTO telefone (tel_cel, tel_res, matricula)
VALUES 
  ('(11) 91234-111', NULL, 1),
  ('(21) 99876-2222', '(21) 3232-333', 2);
SELECT * FROM telefone;