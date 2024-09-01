-- Joinning tables
-- Creating department table
CREATE TABLE departments (
    dept_id integer,
    dept text,
    city text,
    CONSTRAINT dep_key PRIMARY KEY (dept_id),
    CONSTRAINT dep_city_unique UNIQUE (dept, city)
);

-- Creating employees table
CREATE TABLE employees (
    emp_id integer,
    first_name text,
    last_name text,
    salary numeric(10, 2),
    dep_id integer REFERENCES departments (dept_id),
    CONSTRAINT emp_key PRIMARY KEY (emp_id)
);

-- Inserting data in department table
INSERT INTO departments
VALUES
    (1, 'Tax', 'Alabama'),
    (2, 'IT', 'Boston');

-- Inserting data in employees table
INSERT INTO employees
VALUES
    (1, 'Julia', 'Reyes', 115300, 1),
    (2, 'Janet', 'King', 98000, 1),
    (3, 'Arthur', 'Pappas', 72700, 2),
    (4, 'Michael', 'Taylor', 89500, 2);

-- Viewing the tables with a join statement
SELECT *
FROM employees JOIN departments
ON employees.dep_id = departments.dept_id
ORDER BY employees.dep_id;