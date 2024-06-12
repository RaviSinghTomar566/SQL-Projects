--Advance--
--Q1--Find how much amount spent by each customer on artists. Write a query to return customer
--name, artist name and total spent?
with top_artists AS (
	SELECT artist.artist_id, artist.name, SUM(il.unit_price*il.quantity) AS total_earning
FROM artist
INNER JOIN album ON album.artist_id = artist.artist_id
INNER JOIN track ON track.album_id = album.album_id
INNER JOIN invoice_line AS il ON il.track_id = track.track_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1
)
SELECT customer.customer_id, customer.first_name, customer.last_name, top_artists.artist_id,
    top_artists.name, SUM(il.unit_price*il.quantity) AS total_earning
FROM customer 
INNER JOIN invoice ON invoice.customer_id = customer.customer_id
INNER JOIN invoice_line AS il ON il.invoice_id = invoice.invoice_id
INNER JOIN track ON track.track_id = il.track_id
INNER JOIN album ON album.album_id = track.album_id 
INNER JOIN artist ON artist.artist_id = album.artist_id
INNER JOIN top_artists ON top_artists.artist_id = artist.artist_id
GROUP BY 1,4,5
ORDER BY 6 DESC;

--Q2--We want to find out the most popular music genre for each country. We determine the most
--popular genre as the genre with the highest amount of purchases. Write a query that returns each 
--country along with the top genre.
WITH top_genre AS (
	SELECT invoice.billing_country, COUNT(il.quantity) AS no_of_puchases, genre.name AS genre, 
	row_number() OVER (partition by billing_country order by COUNT(il.quantity) DESC) AS row_no
FROM invoice 
INNER JOIN invoice_line AS il ON il.invoice_id = invoice.invoice_id
INNER JOIN track ON track.track_id = il.track_id
INNER JOIN genre ON genre.genre_id = track.genre_id
GROUP BY 1,3
ORDER BY 1 ASC,2 DESC
)
SELECT * 
FROM top_genre
WHERE row_no = 1;

--Q3--Write a query that determines the customer that has spent the most on music for each country.
--Write a query that returns the country along with the top customer and how much they spent.
With top_customer AS (
	SELECT customer.customer_id, customer.first_name, customer.last_name, invoice.billing_country,
	SUM(invoice.total) AS total_spent, 
	row_number() OVER (partition by invoice.billing_country order by SUM(invoice.total) DESC) AS row_no
FROM customer 
INNER JOIN invoice ON invoice.customer_id = customer.customer_id
GROUP BY 1,4
ORDER BY 4 ASC, 5 DESC
)
SELECT * 
FROM top_customer
WHERE row_no = 1 ;


