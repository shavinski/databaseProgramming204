-- SQL queries for assignment

 -- #1 Display all contents of the Clients table
SELECT * FROM Client;

-- #2 First names, last names, ages and occupations of all clients
SELECT client_first_name, client_last_name, SUM(2024 - client_dob) AS client_age
FROM Client
    GROUP BY client_first_name, client_last_name;

-- #3 First and last names of clients that borrowed books in March 2018
SELECT C.client_first_name, C.client_last_name
FROM Borrower AS B
    JOIN Client AS C ON C.client_id = B.client_id
WHERE B.borrow_date >= '2018-03-01' AND B.borrow_date < '2018-04-01';

-- #4 First and last names of the top 5 authors clients borrowed in 2017
SELECT A.author_first_name, A.author_last_name, COUNT(*) as borrow_count_2017
FROM Borrower as Bor
    JOIN Book as B ON B.book_id = Bor.book_id
    JOIN Author as A ON A.author_id = B.author_id
WHERE Bor.borrow_date >= '2017-01-01' AND Bor.borrow_date < '2018-01-01'
    GROUP BY A.author_first_name, A.author_last_name
    ORDER BY borrow_count_2017 DESC
LIMIT 5;

-- #5 Nationalities of the least 5 authors that clients borrowed during the years 2015-2017
SELECT COUNT(A.author_id) as borrow_count, A.author_nationality, A.author_first_name, A.author_last_name
FROM Borrower as Bor
    JOIN Book as B ON B.book_id = Bor.book_id
    JOIN Author as A ON A.author_id = B.author_id
WHERE Bor.borrow_date >= '2015-01-01' AND Bor.borrow_date < '2018-01-01'
    GROUP BY A.author_nationality, A.author_first_name, A.author_last_name
    ORDER BY borrow_count ASC
LIMIT 5;

-- #6 The book that was most borrowed during the years 2015-2017
SELECT COUNT(Borrower.book_id) times_borrowed, B.book_title as most_borrowed_book
FROM Borrower
    JOIN Book AS B ON B.book_id = Borrower.book_id
WHERE borrow_date >= '2015-01-01' AND borrow_date < '2018-01-01'
    GROUP BY B.book_title
    ORDER BY times_borrowed DESC
LIMIT 1;

-- #7 Top borrowed genres for client born in years 1970-1980
SELECT COUNT(B.genre) as most_popular_genre, B.genre
FROM Borrower AS Bor
    JOIN Client AS C on C.client_id = Bor.client_id
    JOIN Book as B on B.book_id = Bor.borrow_id
WHERE C.client_dob >= 1970 AND C.client_dob <= 1980
    GROUP BY B.genre
    ORDER BY most_popular_genre DESC;

-- #8 Top 5 occupations that borrowed the most in 2016
SELECT COUNT(C.occupation) AS top_5_occupations, C.occupation
FROM Borrower AS Bor
    JOIN Client AS C ON C.client_id = Bor.client_id
WHERE Bor.borrow_date >= '2016-01-01' AND Bor.borrow_date < '2017-01-01'
    GROUP BY C.occupation
    ORDER BY top_5_occupations DESC
LIMIT 5;

-- #9 Average number of borrowed books by job title
SELECT occupation, AVG(books_borrowed) AS average_books_by_occupation
FROM  (
    SELECT C.occupation, COUNT(Bor.client_id) AS books_borrowed
    FROM Borrower AS Bor
        JOIN Client AS C ON C.client_id = Bor.client_id
    GROUP BY C.occupation, Bor.client_id
) AS subquery
GROUP BY occupation;

-- #10 Create a VIEW and display the titles that were borrowed by at least 20% of clients
CREATE VIEW borrowed_by_20_percent AS
SELECT B.book_title
FROM Borrower AS Bor
    JOIN Book AS B on B.book_id = Bor.book_id
GROUP BY B.book_title
HAVING COUNT(DISTINCT Bor.client_id) * 100 / (SELECT COUNT(client_id) FROM Client) >= 20
;

-- #11 The top month of borrows in 2017



