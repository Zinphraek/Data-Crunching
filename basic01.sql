-- Creating a database named analysis
CREATE DATABASE analysis;

-- Creating a table named teachers
CREATE TABLE teachers (
    id bigserial,
    first_name varchar(25),
    last_name varchar(50),
    school varchar(50),
    hire_date date,
    salary numeric
);

-- Inserting data in the teachers table.
INSERT INTO teachers (first_name, last_name, school, hire_date, salary)
VALUES ('Janet', 'Smith', 'F.D. Roosevelt HS', '2011-10-30', 36200),
       ('Lee', 'Reynolds', 'F.D. Roosevelt HS', '1993-05-22', 65000),
       ('Samuel', 'Cole', 'Myers Middle School', '2005-08-01', 43500),
       ('Samantha', 'Bush', 'Myers Middle School', '2011-10-30', 36200),
       ('Betty', 'Diaz', 'Myers Middle School', '2005-08-30', 43500),
       ('Kathleen', 'Roush', 'F.D. Roosevelt HS', '2010-10-22', 38500);

-- Data selection
SELECT first_name, last_name, school
FROM teachers
WHERE first_name = 'Janet';

-- Finding teachers whose earning fall in a specific range including boundaries.
SELECT first_name, last_name, school, salary
FROM teachers
WHERE salary BETWEEN 40000 AND 65000;

-- Finding teachers whose earning fall in a specific range excluding the bioundaries.
SELECT first_name, last_name, school, salary
FROM teachers
WHERE salary > 40000 AND salary < 65000;

-- Finding teachers with case sensitive clause
SELECT first_name
FROM teachers
WHERE first_name LIKE 'sam%';

-- Finding teachers with case insensitive clause
SELECT first_name
FROM teachers
WHERE first_name ILIKE 'sam%';

-- Lists of the schools in alphabetical order along with teachers ordered by last name A–Z.
SELECT school, last_name
FROM teachers
ORDER BY school, last_name;

-- Finding the one teacher whose first name starts with the letter S and who earns more than $40,000.
SELECT first_name, last_name, salary
FROM teachers
WHERE first_name LIKE 'S%' AND salary > 40000;

-- Finding and ranking teachers hired since January 1, 2010, ordered by highest paid to lowest.
SELECT first_name, last_name, hire_date
FROM teachers
WHERE hire_date >= '2010-01-01'
ORDER BY salary DESC;
