CREATE TABLE IF NOT EXISTS Author (
    author_id INT PRIMARY KEY,
    author_first_name VARCHAR(50),
    author_last_name VARCHAR(50),
    author_nationality VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Book (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(50),
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES Author(author_id)
);

CREATE TABLE IF NOT EXISTS Client (
    client_id INT PRIMARY KEY,
    client_first_name VARCHAR(50),
    client_last_name VARCHAR(50),
    client_dob INT,
    occupation VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Borrower (
    borrow_id INT PRIMARY KEY,
    client_id INT,
    book_id INT,
    borrow_date DATE,
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);