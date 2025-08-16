CREATE DATABASE sistema_ensino

-- Tabela Escola
CREATE TABLE escola (
  cnpj VARCHAR(20) PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  telefone_com VARCHAR(20) NOT NULL,
  rua VARCHAR(50),
  cep VARCHAR(10),
  cidade VARCHAR(50),
  estado VARCHAR(2)
);

-- Tabela Professor
CREATE TABLE professor (
  matricula SERIAL PRIMARY KEY,
  telefone_cel VARCHAR(20),
  cpf VARCHAR(15),
  rua VARCHAR(50),
  cep VARCHAR(10),
  cidade VARCHAR(50),
  estado VARCHAR(2),
  cnpj_escola VARCHAR(20) NOT NULL,
  CONSTRAINT fk_professor_escola
    FOREIGN KEY (cnpj_escola) REFERENCES escola(cnpj)
);

-- Tabela Turma
CREATE TABLE turma (
  codigo SERIAL PRIMARY KEY,
  sala VARCHAR(20) NOT NULL,
  turno VARCHAR(10) NOT NULL,
  cnpj_escola VARCHAR(20) NOT NULL,
  CONSTRAINT fk_turma_escola
    FOREIGN KEY (cnpj_escola) REFERENCES escola(cnpj)
);

-- Tabela Aluno
CREATE TABLE aluno (
  matricula SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cnpj_escola VARCHAR(20) NOT NULL,
  codigo_turma INT NOT NULL,
  CONSTRAINT fk_aluno_escola
    FOREIGN KEY (cnpj_escola) REFERENCES escola(cnpj),
  CONSTRAINT fk_aluno_turma
    FOREIGN KEY (codigo_turma) REFERENCES turma(codigo)
);

-- Tabela Disciplina
CREATE TABLE disciplina (
  codigo SERIAL PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  ementa TEXT NOT NULL,
  carga_horaria INT NOT NULL,
  matricula_professor INT NOT NULL,
  CONSTRAINT fk_disciplina_professor
    FOREIGN KEY (matricula_professor) REFERENCES professor(matricula)
);

-- Tabela Turma_Disciplina
CREATE TABLE turma_disciplina (
  codigo SERIAL PRIMARY KEY,
  codigo_turma INT NOT NULL,
  codigo_disciplina INT NOT NULL,
  dt_inicio DATE,
  dt_termino DATE,
  CONSTRAINT fk_td_turma
    FOREIGN KEY (codigo_turma) REFERENCES turma(codigo),
  CONSTRAINT fk_td_disciplina
    FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo)
);

-- Tabela Endereço
CREATE TABLE endereco (
  codigo SERIAL PRIMARY KEY,
  rua VARCHAR(50) NOT NULL,
  cep VARCHAR(10) NOT NULL,
  cidade VARCHAR(50) NOT NULL,
  estado VARCHAR(2),
  matricula INT NOT NULL,
  CONSTRAINT fk_endereco_aluno
    FOREIGN KEY (matricula) REFERENCES aluno(matricula)
);

-- Tabela Telefone
CREATE TABLE telefone (
  codigo SERIAL PRIMARY KEY,
  tel_cel VARCHAR(20) NOT NULL,
  tel_res VARCHAR(20),
  matricula INT NOT NULL,
  CONSTRAINT fk_telefone_aluno
    FOREIGN KEY (matricula) REFERENCES aluno(matricula)
);
