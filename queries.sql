-- SQL queries for assignment
-- #1 Display all contents of the Clients table
-- We start by selecting everything from Client table

SELECT *
FROM Client;

-- #2 First names, last names, ages and occupations of all clients
-- We select client first name, last name, and calculate the age pulling from Client table
-- We then group by everything to have non unique rows counted 

SELECT client_first_name,
    client_last_name,
    2024 - client_dob AS client_age
FROM Client
GROUP BY client_first_name,
    client_last_name,
    client_age;

-- #3 First and last names of clients that borrowed books in March 2018
-- We will want to return the clients first names and last names
-- We will join borrower and client table to get relevant info
-- We will then use where to find the names of people who borrowed books in the month of march in 2018

SELECT C.client_first_name,
    C.client_last_name
FROM Borrower AS B
    JOIN Client AS C ON C.client_id = B.client_id
WHERE B.borrow_date >= '2018-03-01'
    AND B.borrow_date < '2018-04-01';

-- #4 First and last names of the top 5 authors clients borrowed in 2017
-- We will be returning the authors first name, last name and the amount of time they were borrowed from in 2017
-- We will need to join borrower, book and author in order to get all relevant info
-- We then check if the borrow date is in 2017 and will group by authors first name and last name for unique rows
-- We will then order by the borrow count 2017 DESC to have most to least 
-- Then limit by 5 so we can select top 5 authors in 2017 that were borrowed from

SELECT A.author_first_name,
    A.author_last_name,
    COUNT(*) as borrow_count_2017
FROM Borrower as Bor
    JOIN Book as B ON B.book_id = Bor.book_id
    JOIN Author as A ON A.author_id = B.author_id
WHERE Bor.borrow_date >= '2017-01-01'
    AND Bor.borrow_date < '2018-01-01'
GROUP BY A.author_first_name,
    A.author_last_name
ORDER BY borrow_count_2017 DESC
LIMIT 5;

-- #5 Nationalities of the least 5 authors that clients borrowed during the years 2015-2017
-- We will return borrow count, author nationality, author first and last name as well
-- We will then need to join Borrower, Book and Author to get all relevant data
-- We will include a where to make sure we are getting the necessary years of 2015-2017
-- We will group by the author nationality, first and last name for uniqueness in rows
-- We will then order by the borrow count which will go from least to most
-- We will then select the top 5 from the list, which are the least borrowed from

SELECT COUNT(A.author_id) as borrow_count,
    A.author_nationality,
    A.author_first_name,
    A.author_last_name
FROM Borrower as Bor
    JOIN Book as B ON B.book_id = Bor.book_id
    JOIN Author as A ON A.author_id = B.author_id
WHERE Bor.borrow_date >= '2015-01-01'
    AND Bor.borrow_date < '2018-01-01'
GROUP BY A.author_nationality,
    A.author_first_name,
    A.author_last_name
ORDER BY borrow_count ASC
LIMIT 5;

-- #6 The book that was most borrowed during the years 2015-2017
-- We will need to return the amount a book was borrowed and the book name
-- We will join Borrower and Book to get all relevant data
-- We will use where to get correct years between 2015-2017
-- We will then group by the book title for uniqueness 
-- We will then order by the times borrowed from most - least 
-- We will limit this list to one to get the most borrowed book

SELECT COUNT(Borrower.book_id) times_borrowed,
    B.book_title as most_borrowed_book
FROM Borrower
    JOIN Book AS B ON B.book_id = Borrower.book_id
WHERE borrow_date >= '2015-01-01'
    AND borrow_date < '2018-01-01'
GROUP BY B.book_title
ORDER BY times_borrowed DESC
LIMIT 1;

-- #7 Top borrowed genres for client born in years 1970-1980
-- We will need to return most popular genre count and what genre
-- We will need to join Borrower, Client and Book
-- We will check the client ages and make sure the dob is between 1970 - 1980
-- We will group by genre for uniqueness in rows
-- We will then order by the most popular genre most - least popular to have top genres at top

SELECT COUNT(B.genre) as most_popular_genre,
    B.genre
FROM Borrower AS Bor
    JOIN Client AS C on C.client_id = Bor.client_id
    JOIN Book as B on B.book_id = Bor.borrow_id
WHERE C.client_dob >= 1970
    AND C.client_dob <= 1980
GROUP BY B.genre
ORDER BY most_popular_genre DESC;

-- #8 Top 5 occupations that borrowed the most in 2016
-- We will need count of the top 5 occupations, and will need to display the occupation
-- We will join Borrower on Client in order to get all relevant info
-- We will check and make sure the dates are only in 2016
-- We will group by occupation for uniqueness 
-- We will order by the count of the occupations from most - least
-- We will then limit by 5 to get the most borrowed occupations in 2016

SELECT COUNT(C.occupation) AS top_5_occupations,
    C.occupation
FROM Borrower AS Bor
    JOIN Client AS C ON C.client_id = Bor.client_id
WHERE Bor.borrow_date >= '2016-01-01'
    AND Bor.borrow_date < '2017-01-01'
GROUP BY C.occupation
ORDER BY top_5_occupations DESC
LIMIT 5;

-- #9 Average number of borrowed books by job title
-- We will need to get occupations, and average the books borrowed by these occupations
-- We will start a sub query
    --We will need to query for the count of borrows a client id has
    -- We will join Borrower on Client for all relevant info
    -- We will then group by occupation and client id for uniqueness
-- We will then group by occupation so that we total up all the occupations that appear

SELECT occupation,
    AVG(books_borrowed) AS average_books_by_occupation
FROM (
        SELECT C.occupation,
            COUNT(Bor.client_id) AS books_borrowed
        FROM Borrower AS Bor
            JOIN Client AS C ON C.client_id = Bor.client_id
        GROUP BY C.occupation,
            Bor.client_id
    ) AS subquery
GROUP BY occupation;

-- #10 Create a VIEW and display the titles that were borrowed by at least 20% of clients
-- We will first create view 
-- We will then get the info we want to place in the view 
-- We will want to get the book title that has been borrowed by 20% of clients
-- We will join the Borrower and Book tables for all relevant info
-- We will group by the book title 
-- We will then only want the book titles that 20% of all clients have borrowed
    -- We will get the number of times a distinct client has checked out the book and times 100 (for later conversion to percentage)
    -- We will then divide this by the actual total count of all clients in the database by querying the whole Client table to get all clients
    -- We will then have a checker to make sure the percentage is over 20%

CREATE VIEW borrowed_by_20_percent AS
SELECT B.book_title
FROM Borrower AS Bor
    JOIN Book AS B on B.book_id = Bor.book_id
GROUP BY B.book_title
HAVING COUNT(DISTINCT Bor.client_id) * 100 / (
        SELECT COUNT(client_id)
        FROM Client
    ) >= 20;

-- #11 The top month of borrows in 2017
-- We will need to get the the total borrow count and the time of month of how many borrows occurred
-- We will check that the year of borrows is in 2017
-- We will then group by months
-- We will order the borrow count by most - least, so that the month with most borrows is at top
-- Limit by one to get the top month

SELECT COUNT(*) as borrow_count,
    EXTRACT(
        month
        FROM borrow_date
    ) as month
FROM Borrower
WHERE borrow_date >= '2017-01-01'
    AND borrow_date < '2018-01-01'
GROUP BY month
ORDER BY borrow_count DESC
LIMIT 1;

-- #12 Average number of borrows by age
-- We will need to get get client ages, then the average amount of borrows from these ages
    -- We will create a subquery to go total client ages and count up the amount of borrows 
    -- We will join Client on Borrower
    -- We will then group by client age 
-- We will then group by client age
-- We will then order by age to so that it is least - greatest

SELECT client_age,
    AVG(num_borrows) AS avg_borrows
FROM (
        SELECT 2024 - C.client_dob AS client_age,
            COUNT(Bor.borrow_id) as num_borrows
        FROM Client AS C
            JOIN Borrower AS Bor ON Bor.client_id = C.client_id
        GROUP BY client_age
    ) AS client_borrows
GROUP BY client_age
ORDER BY client_age;

-- #13 The oldest and the youngest clients of the library
-- We will use the MAX and MIN aggregate functions to get the oldest and youngest ages

SELECT MAX(2024 - client_dob) AS oldest,
    MIN(2024 - client_dob) AS youngest
FROM Client;

-- #14 First and last names of authors that wrote books in more than one genre
-- We will need the author first name, last name and the total count of genres they have written
-- We will join Author on Book
-- We will then make sure that each author will have a count of genre that is equal or more than 2

SELECT A.author_first_name,
    A.author_last_name,
    COUNT(B.genre) AS genre_count
FROM Author AS A
    JOIN Book AS B ON B.author_id = A.author_id
GROUP BY A.author_first_name, A.author_last_name
HAVING COUNT(B.genre) >= 2;