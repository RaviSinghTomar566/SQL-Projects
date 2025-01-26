--Q1(a): Find the list of employees whose salary ranges between 200,000 to 300,000.
SELECT *
FROM employee
WHERE salary BETWEEN 200000 AND 300000;

--Q1(b): Write a query to retrieve the list of employees from the same city.
SELECT a.empid, a.empname, a.city, a.salary
FROM employee as a
JOIN employee as b ON a.empid != b.empid
WHERE a.city = b.city ;

--Q1(c): Query to find the null values in the employee table.
SELECT *
FROM employee 
WHERE empid IS NULL;

--Q2(a): Query to find the cumulative sum of employee’s salary.
SELECT EmpID, Salary, SUM(Salary) OVER (ORDER BY EmpID) AS CumulativeSum
FROM Employee;

--Q2(b): What’s the male and female employees ratio?
SELECT
ROUND(COUNT(*) FILTER (WHERE Gender = 'M') * 100.0 / COUNT(*),2) AS Male,
ROUND(COUNT(*) FILTER (WHERE Gender = 'F') * 100.0 / COUNT(*),2) AS Female
FROM Employee;

--Q2(c): Write a query to fetch 50% records from the Employee table.
SELECT * FROM Employee
WHERE EmpID <= (SELECT COUNT(EmpID)/2 from Employee);

--Q3: Show the employee with the highest salary for each project.
WITH cte AS (	
SELECT *, ROW_NUMBER() OVER (PARTITION BY ed.project ORDER BY e.salary DESC) AS row_no    
FROM employee as e    
JOIN employeedetail as ed ON e.empid = ed.empid
)
SELECT project, salary, empname
FROM cte 
WHERE row_no <=1;

--Q4: Query to find the total count of employees joined each year.
SELECT EXTRACT(year from doj) AS joining_year, COUNT(empid)
FROM employeedetail
GROUP BY 1
ORDER BY 1 ASC;

--Q5: Create 3 groups based on salary columns, salary less than 1 Lakh is low, between 1 to 2 lakh is medium and above 2 lakh is high.
SELECT   *,	
    CASE	
       WHEN salary > 200000 THEN 'High'	
       WHEN salary BETWEEN 100000 AND 200000 THEN 'Medium'
       WHEN salary < 100000 THEN 'Low'	
    END
FROM employee;

--Q6: query to retrieve the list of employees working in same project.
WITH cte AS   ( 	
        SELECT e.empid, e.empname, ed.project    
        FROM employee as e    
        INNER JOIN employeedetail as ed ON ed.empid = e.empid
)
SELECT a.empid, a.empname, b.empid, b.empname, a.project
FROM cte as a
JOIN cte as b ON a.empid != b.empid
WHERE a.empid < b.empid AND a.project = b.project;

--Q7: Write a query to fetch even and odd rows from the employee table.
--for even rows--
SELECT *
FROM employee
WHERE empid % 2 = 0;

--for odd rows--
SELECT *
FROM employee
WHERE empid % 2 = 1;

--Q8: Query to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’
i.e 12345 will be 123XX.

SELECT *, CONCAT(SUBSTRING(salary::text, 1, LENGTH(salary::text)-2),'XX') AS masked_numbers
FROM employee;

--Q9(a): Write a query to find all the Employee names whose names:
• Begin with ‘A’
• Contains ‘A’ alphabet at second place
• Contains ‘Y’ alphabet at second last place
• Ends with ‘L’ and contains 4 alphabets
• Begins with ‘V’ and ends with ‘A’

SELECT * FROM employee WHERE empname LIKE 'A%’;
SELECT * FROM employee WHERE empname LIKE '_a%’;
SELECT * FROM employee WHERE empname LIKE '%y_’;
SELECT * FROM employee WHERE empname LIKE ‘_ _ _l’;
SELECT * FROM employee WHERE empname LIKE 'V%a';









