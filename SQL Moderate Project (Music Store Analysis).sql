---Moderate--
--Write a query to return the email, first name, last name and genre of all rock music listeners.
--Return the list ordered alphabetically by email starting with A.
SELECT customer.customer_id, customer.email, customer.first_name, customer.last_name, 
	genre.name AS genre_name
FROM customer
INNER JOIN invoice ON invoice.customer_id = customer.customer_id
INNER JOIN invoice_line AS il ON il.invoice_id = invoice.invoice_id
INNER JOIN track ON track.track_id = il.track_id
INNER JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY 1,5
ORDER BY 2 ASC;

--Q2--Let's invite the artists who have written the most rock music in our dataset. Write a query 
--that returns the artist name and total track count of the top 10 rock bands.
SELECT artist.artist_id, artist.name, COUNT(track.track_id) AS track_count, genre.name AS genre
FROM artist
INNER JOIN album ON album.artist_id = artist.artist_id
INNER JOIN track ON track.album_id = album.album_id
INNER JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY 1,4
ORDER BY 3 DESC
LIMIT 10;

--Q3--Return all the track names that have a song length longer than the average song length.
--Return the name and milliseconds for each track. Order by the song length with the longest songs 
--listed first.
SELECT track_id, name, milliseconds 
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) 
                      FROM track)
ORDER BY milliseconds DESC;


