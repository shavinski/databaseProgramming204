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
