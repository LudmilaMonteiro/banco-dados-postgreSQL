CREATE DATABASE rh;

-- Criação das Tabelas:
-- 1. Tabela Departments 
CREATE TABLE departments (
  department_id SERIAL PRIMARY KEY,
  department_name VARCHAR(100) NOT NULL 
);

-- 2. Tabela Positions
CREATE TABLE positions (
  position_id SERIAL PRIMARY KEY,
  position_name VARCHAR(100) NOT NULL 
);

-- 3. Tabela Employees
CREATE TABLE employees (
  employee_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL, 
  last_name VARCHAR(50) NOT NULL,
  department_id INT REFERENCES departments(department_id) ON DELETE SET NULL, 
  position_id INT REFERENCES positions(position_id) ON DELETE SET NULL, 
  hire_date DATE NOT NULL 
);

-- 4. Tabela Salaries 
CREATE TABLE salaries (
  salary_id SERIAL PRIMARY KEY,
  employee_id INT NOT NULL REFERENCES employees(employee_id) ON DELETE CASCADE,
  salary_amount NUMERIC(12, 2) NOT NULL, 
  effective_from DATE NOT NULL,
  effective_to DATE 
);