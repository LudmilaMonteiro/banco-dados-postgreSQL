-- Consultas 
-- 1. 
SELECT 
   e.employee_id,
   e.first_name || ' ' || e.last_name AS nome,
   d.department_name,
   p.position_name 
 FROM employees AS e 
INNER JOIN departments AS d ON e.department_id = d.department_id 
INNER JOIN positions AS p ON e.position_id = p.position_id;


-- 2. 
SELECT
    d.department_name,
    COUNT(e.employee_id) AS total_funcionarios 
  FROM departments AS d
  LEFT JOIN employees AS e
    ON d.department_id = e.department_id 
  GROUP BY d.department_name 
  ORDER BY total_funcionarios DESC;

-- 3. 
SELECT 
   s.employee_id,
   s.salary_amount 
 FROM salaries AS s
 WHERE s.effective_to IS NULL;

-- 4. 
SELECT
   p.position_name, 
   AVG(s.salary_amount) AS media_salarial
 FROM positions AS p
 INNER JOIN employees AS e
   ON p.position_id = e.position_id
 INNER JOIN (
  SELECT employee_id, salary_amount
  FROM salaries
  WHERE effective_to IS NULL
 ) AS s
  ON e.employee_id = s.employee_id
 GROUP BY p.position_name 
 ORDER BY media_salarial DESC;