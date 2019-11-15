--Query Dates
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

--Retirement Eligibilty
	-- looking for employees born between 1952 and 1955, who were also hired between 1985 and 1988
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- the Queries(number of employees retiring)
SELECT (first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Create New Tables with Previous Queries Using the SELECT INTO statement
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info


--Recreate the retirement_info Table with the emp_no Column. 1st DROP table
--		DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

--Use Inner Join for Departments and dept-manager Tables
SELECT departments.dept_name,
	   dept_manager.emp_no,
	   dept_manager.from_date,
	   dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;


-- Use Left Join to Capture retirement-info Table
-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	   retirement_info.first_name,
	   retirement_info.last_name,
	   department_employees.to_date
FROM retirement_info
LEFT JOIN department_employees
ON retirement_info.emp_no = department_employees.emp_no;

--Use Aliases for Code Readability
SELECT dm.dept_name,
	   dmg.emp_no,
	   dmg.from_date,
	   dmg.to_date
FROM departments as dm
INNER JOIN dept_manager as dmg
ON dm.dept_no = dmg.dept_no;
		
		
SELECT (*) FROM "department_employees"
DROP TABLE "department_employees"

-- "schema.sql" - i.e. SQL creates tables / columns / relationships; "DDL" - *definition*
-- "queries.sql" -i.e. SQL that manipulates data / makes queries ; etc -- "DML" - *manipulation*
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4)NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);


DROP TABLE current_emp;
-- "idempotent" - scripts can be re-run, without error, 
-- and always producing the same result that you expect

 --Use Left Join for retirement_info and dept_emp tables
SELECT r.emp_no,
	   r.first_name,
	   r.last_name,
	   d.to_date
INTO current_emp
FROM retirement_info as r
LEFT JOIN dept_emp as d
ON r.emp_no = d.emp_no
-- filter for current employees only
WHERE d.to_date = ('9999-01-01');
-- 33,118

SELECT * FROM current_emp
--SELECT (*) FROM "current_emp";
--SELECT COUNT(*) FROM "employees";

-- Left Join the current_emp and dept_emp tables to organize data before using Group By
-- we want the total number of employees first
	-- Note question asked for a list of how many employees per department were leaving,
	--so the only columns we need for this list are the emp_no amd dep_no

SELECT COUNT(cur.emp_no), 
			 de.dept_no
--INTO total_numemp_dept
FROM current_emp as cur
LEFT JOIN dept_emp as de
ON cur.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM total_numemp_dept



--Create Additional Lists
-- List 1: Employee Information (Here’s everything we need: Emp_no, first_name, last_name
--		Gender, to_date, Salary)
---		Filter/sort for most recent date on list first

SELECT * FROM salaries
ORDER BY to_date DESC;

-- Employees hired at the current time from the employees table. Table filtered to get 
-- the current employees only
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Now lets INNER JOIN emp_info (as e) table to the salaries (as s)table 
SELECT e.emp_no,
	   e.first_name,
	   e.last_name,
	   e.gender,
	   s.salary,
	   de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON e.emp_no = s.emp_no
INNER JOIN department_employees as de
ON e.emp_no = de.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');

--List 2: Management
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        cur.last_name,
        cur.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS cur
        ON (dm.emp_no = cur.emp_no);


--List 3: Department Retirees
SELECT cur.emp_no,
	   cur.first_name,
	   cur.last_name,
	   d.dept_name	
-- INTO dept_info
FROM current_emp as cur
INNER JOIN department_employees AS de
ON (cur.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);



-- Create a Tailored List
-- (What’s going on with the salaries?, Why are there only five active managers for nine departments?,
--	Why are some employees appearing twice?)

SELECT re.emp_no,
	   re.first_name,
	   re.last_name,
	   d.dept_name
--INTO salesdept_retirees
FROM retirement_info as re
INNER JOIN dept_emp as de
ON re.emp_no = de.emp_no
INNER JOIN departments as d
ON d.dept_no = de.dept_no
WHERE d.dept_name = 'Sales'


--Retirees for the Sales & Development depts
SELECT re.emp_no,
	   re.first_name,
	   re.last_name,
	   d.dept_name
--INTO salesanddev_retirees
FROM retirement_info as re
INNER JOIN dept_emp as de
ON re.emp_no = de.emp_no
INNER JOIN departments as d
ON d.dept_no = de.dept_no
--Hint: You’ll need to use the IN condition with the WHERE clause, to compare character values:
WHERE d.dept_name IN ('Sales',  'Development');
