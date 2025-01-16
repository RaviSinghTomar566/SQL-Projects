---Easy-- 
--Q1--Who is the senior most employee based on the job title?
SELECT levels, employee_id, first_name, last_name, title
FROM employee
ORDER BY levels DESC
LIMIT 1;

--Q2--Which country has the most invoices?
SELECT billing_country, COUNT(total) AS total_invoice
FROM invoice
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--Q3--What are the top 3 values of total invoices?
SELECT total, billing_country, billing_city
FROM invoice
ORDER BY total DESC
LIMIT 3;

--Q4--Which city has the best customers? We would like to throw a promotional music festival in the
--city we made the most money. Write a query that returns one city that has the highest SUM of 
--invoice total. Return both the city name and the sum of all invoices total?
SELECT billing_city, SUM(total) AS invoice_total 
FROM invoice
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--Q5--Who is the best customer? The customer who has spent the most money will be declared as the 
--best customer. Write a query that returns the person who has spent the most money.
SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total) AS total_spent
FROM customer AS c
INNER JOIN invoice AS i ON c.customer_id = i.customer_id
GROUP BY 1 
ORDER BY 4 DESC
LIMIT 1;

