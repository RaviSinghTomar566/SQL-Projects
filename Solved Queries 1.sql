--Question-- Find monthly sales and sort it by descending order.
SELECT EXTRACT(year from order_date) AS year, to_char(order_date, 'Mon') AS month,  SUM(sales) AS sales
FROM monthly_sales
GROUP BY 1,2
ORDER BY sales DESC;

--Question- Find the candidates best suited for an open Data Science job. Find proficient candidates in "Python, SQL, and Power BI". Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.
SELECT candidate_id, COUNT(skills) AS skill_count
FROM applications
WHERE skills IN ('Power BI', 'Python', 'SQL')
GROUP BY 1
HAVING COUNT(skills) = 3
ORDER BY 2 DESC;

--Question- List all the matches between teams, if matches are played once
WITH cte AS (	
            SELECT *, ROW_NUMBER() OVER (ORDER BY team ASC) AS id
            FROM teams_list
            )
SELECT a.team  AS  A_Team, b.team  AS  B_Team
FROM cte as a
JOIN cte as b   ON a.id != b.id
WHERE a.id < b.id;

----Question- Write the query to get the output.
WITH cte AS (	
         SELECT CONCAT(id, ' ', name) AS con, NTILE(4) OVER (ORDER BY id ASC) AS groups    
         FROM emp
)
SELECT STRING_AGG(con, ', ') AS result, groups
FROM cte
GROUP BY groups
ORDER BY groups ASC;

