--Write a solution to find the ids of products that are both low fat and recyclable.
--Return the result table in any order.
SELECT product_id 
FROM Products 
WHERE low_fats LIKE 'Y' AND recyclable LIKE 'Y'
ORDER BY 1 ASC;

--Find the names of the customer that are not referred by the customer with id = 2.
--Return the result table in any order.
Select name 
FROM Customer 
WHERE referee_id != 2 OR referee_id IS NULL;

--A country is big if:
--it has an area of at least three million (i.e., 3000000 km2), or
--it has a population of at least twenty-five million (i.e., 25000000).
--Write a solution to find the name, population, and area of the big countries.
--Return the result table in any order.
SELECT name, population, area 
FROM World
WHERE population >= 25000000 OR area >= 3000000;

--Write a solution to find all the authors that viewed at least one of their own articles.
--Return the result table sorted by id in ascending order. The result format is in the 
--following example.
SELECT author_id AS id 
FROM Views 
WHERE author_id = viewer_id 
GROUP BY 1;

--Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of 
--characters used in the content of the tweet is strictly greater than 15.
--Return the result table in any order.
SELECT tweet_id 
FROM Tweets
WHERE LENGTH(content) > 15;

--Write a solution to show the unique ID of each user, If a user does not have a unique ID replace 
--just show null. Return the result table in any order.
SELECT eu.unique_id, e.name
FROM Employees AS e 
LEFT JOIN EmployeeUNI AS eu ON e.id = eu.id;

--Write a solution to report the product_name, year, and price for each sale_id in the Sales table.
--Return the resulting table in any order.
Select p.product_name, s.year, s.price
FROM Sales AS s
LEFT JOIN Product AS p ON s.product_id = p.product_id
ORDER BY 2 ASC;

--Write a solution to find the IDs of the users who visited without making any transactions and 
--the number of times they made these types of visits. Return the result table sorted in any order.
SELECT v.customer_id, COUNT(customer_id) AS count_no_trans
FROM Visits AS v
LEFT JOIN Transactions AS t ON v.visit_id = t.visit_id
WHERE transaction_id IS NULL
GROUP BY 1 
ORDER BY 2 DESC;

--Write a solution to find all dates' Id with higher temperatures compared to its previous dates 
--(yesterday). Return the result table in any order.
WITH cte AS (
    SELECT *, LAG(recordDate) OVER (ORDER BY id ASC) AS previous_date, LAG(temperature) OVER (ORDER BY id ASC) AS previous_temp
FROM Weather 
)
SELECT id 
FROM cte 
WHERE recordDate > previous_date AND temperature > previous_temp
ORDER BY id ASC;

---There is a factory website that has several machines each running the same number of processes. 
--Write a solution to find the average time each machine takes to complete a process.
---The time to complete a process is the 'end' timestamp minus the 'start' timestamp. 
--The average time is calculated by the total time to complete every process on the machine divided 
--by the number of processes that were run.
---The resulting table should have the machine_id along with the average time as processing_time, 
--which should be rounded to 3 decimal places.
---Return the result table in any order.
Select a.machine_id, ROUND(AVG(b.timestamp::DECIMAL - a.timestamp::DECIMAL), 3) AS processing_time
FROM Activity AS a
JOIN Activity AS b ON a.machine_id = b.machine_id
                   AND a.process_id = b.process_id
                   AND a.activity_type = 'start'
                   AND b.activity_type = 'end'
GROUP BY a.machine_id
ORDER BY a.machine_id ASC;

--Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.
--Return the result table in any order.
SELECT e.name, b.bonus  
FROM Employee AS e
LEFT JOIN Bonus AS b ON b.empid = e.empid
WHERE b.bonus < 1000 OR  b.bonus IS NULL 
ORDER BY b.bonus ASC;

--Write a solution to find the number of times each student attended each exam.
--Return the result table ordered by student_id and subject_name.
SELECT s.student_id,s.student_name,sub.subject_name, COUNT(e.subject_name) AS attended_exams 
FROM  Students AS s
CROSS JOIN Subjects AS sub
LEFT JOIN Examinations AS e ON e.student_id = s.student_id 
                            AND sub.subject_name = e.subject_name
GROUP BY 1,2,3
ORDER BY s.student_id, sub.subject_name ASC;

--Write a solution to find managers with at least five direct reports.
--Return the result table in any order.
WITH cte AS (
    SELECT managerId, COUNT(managerId) 
FROM Employee
GROUP BY 1 
HAVING count(managerId) >= 5
)
SELECT name
FROM Employee AS e
JOIN cte ON cte.managerId = e.id;

--The confirmation rate of a user is the number of 'confirmed' messages divided by the total number 
--of requested confirmation messages. The confirmation rate of a user that did not request any 
--confirmation messages is 0. Round the confirmation rate to two decimal places.
--Write a solution to find the confirmation rate of each user. Return the result table in any order.
with cte AS (
    SELECT s.user_id, CASE
                           WHEN c.action LIKE 'confirmed' THEN 1
                           else 0
                       END AS no_of_confirmations
FROM Signups AS s 
LEFT JOIN Confirmations AS c ON c.user_id = s.user_id
)
SELECT user_id, ROUND(AVG(no_of_confirmations::DECIMAL), 2) AS confirmation_rate
FROM cte
GROUP BY 1;

--Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".
--Return the result table ordered by rating in descending order.
SELECT *
FROM Cinema 
WHERE id % 2 = 1 AND description != 'boring'
ORDER BY rating DESC;

--Write a solution to find the average selling price for each product. 
--"average_price" should be rounded to 2 decimal places. Return the result table in any order.
SELECT p.product_id,ROUND(SUM(p.price * u.units)::DECIMAL / SUM(u.units)::DECIMAL, 2) AS average_price
FROM Prices AS p 
JOIN UnitsSold AS u ON p.product_id = u.product_id 
                    AND u.purchase_date BETWEEN p.start_date AND p.end_date 
GROUP BY 1 
ORDER BY 1 ASC;

--Write an SQL query that reports the average experience years of all the employees for each project
--, rounded to 2 digits. Return the result table in any order.
SELECT p.project_id, ROUND(AVG(e.experience_years)::DECIMAL, 2) AS average_years
FROM Project AS p
LEFT JOIN Employee AS e ON p.employee_id = e.employee_id
GROUP BY p.project_id
ORDER BY 1 ASC;

--Write a solution to find the percentage of the users registered in each contest rounded to 
--two decimals. Return the result table ordered by percentage in descending order. 
--In case of a tie, order it by contest_id in ascending order.
SELECT Register.contest_id, ROUND(COUNT(Register.user_id)::DECIMAL * 100 / (SELECT COUNT(Users.user_id) FROM Users)::DECIMAL, 2) AS percentage
FROM Register
GROUP BY Register.contest_id 
ORDER BY 2 DESC, Register.contest_id ASC;

--We define query quality as:
---The average of the ratio between query rating and its position.
--We also define poor query percentage as:
---The percentage of all queries with rating less than 3.
--Write a solution to find each query_name, the quality and poor_query_percentage.
--Both quality and poor_query_percentage should be rounded to 2 decimal places.
--Return the result table in any order.
SELECT query_name, ROUND(AVG(rating::DECIMAL/position::DECIMAL), 2) AS quality,
       ROUND(COUNT(*) FILTER (WHERE rating < 3) * 100 / COUNT(*)::DECIMAL, 2) AS poor_query_percentage 
FROM Queries 
WHERE query_name IS NOT NULL
GROUP BY query_name
ORDER BY query_name DESC;

--Write a solution to calculate the number of unique subjects each teacher teaches in the university.
--Return the result table in any order.
SELECT  teacher_id, COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY 1
ORDER BY 1 ASC;

--Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 
--inclusively. A user was active on someday if they made at least one activity on that day.
--Return the result table in any order.
SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY 1
ORDER BY 1 ASC;

--Write a solution to select the product id, year, quantity, and price for 
--the first year of every product sold. Return the resulting table in any order.
with result as (
    select product_id,min(year) as min_year
from sales
group by product_id
)
select s.product_id,s.year as first_year,s.quantity,s.price 
from sales s 
join result r on s.product_id = r.product_id and s.year = r.min_year;

--Write a solution to find all the classes that have at least five students.
--Return the result table in any order.
WITH cte AS (
    SELECT class, COUNT(class) 
FROM Courses 
GROUP BY class 
HAVING COUNT(class) >= 5
)
SELECT class 
FROM cte ;

--Write a solution that will, for each user, return the number of followers.
--Return the result table ordered by user_id in ascending order.
SELECT user_id, COUNT(follower_id) AS followers_count
FROm Followers
GROUP BY 1
ORDER BY 1 ASC;

--A single number is a number that appeared only once in the MyNumbers table.
--Find the largest single number. If there is no single number, report null.
WITH SingleNumbers AS (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(num) = 1
)
SELECT MAX(num) AS num
FROM SingleNumbers;

--Write a solution to report the customer ids from the Customer table that bought all 
--the products in the Product table. Return the result table in any order.
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (
    SELECT COUNT(*)
    FROM Product
);

--Write a solution to fix the names so that only the first character is uppercase and 
--the rest are lowercase. Return the result table ordered by user_id.
SELECT user_id, CONCAT(UPPER(left(name, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users
ORDER BY 1 ASC;

--Write a solution to find the patient_id, patient_name, and conditions of the patients 
--who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix.
--Return the result table in any order.
select * from patients 
where conditions like 'DIAB1%' or conditions like '% DIAB1%';

--Write a solution to find the second highest salary from the Employee table. 
--If there is no second-highest salary, return null.
SELECT 
  (SELECT DISTINCT salary
   FROM Employee
   ORDER BY salary DESC
   LIMIT 1 OFFSET 1) AS SecondHighestSalary;

--Write a solution to find for each date the number of different products sold and their names.
--The sold product names for each date should be sorted lexicographically.
--Return the result table ordered by sell_date.
SELECT sell_date, COUNT( DISTINCT product) AS num_sold, STRING_AGG( DISTINCT product, ',') AS products
FROM Activities
GROUP BY sell_date 
ORDER BY 1 ASC;

--Write a solution to get the names of products that have at least 100 units ordered in 
--February 2020 and their amount. Return the result table in any order.
SELECT
    p.product_name,
    SUM(o.unit) AS unit
FROM Orders o
INNER JOIN Products p ON o.product_id = p.product_id
WHERE order_date >= '2020-02-01' AND order_date <= '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

--Write a solution to find the users who have valid emails.
--A valid e-mail has a prefix name and a domain where:
--The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. The prefix name must start with a letter.
--The domain is '@leetcode.com'.
--Return the result table in any order.
SELECT *
FROM Users
WHERE mail ~ '^[a-zA-Z]+[a-zA-Z0-9_.-]*@leetcode\.com$';
