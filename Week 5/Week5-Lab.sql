--1) Get a list of all books, including the author's names (duplicate books are okay, if the book has multiple authors).*/
SELECT
    books.book_id,
    books.title,
    books.genre,
    authors.first_name,
    authors.last_name
FROM
    books
    JOIN (authorship)
    ON (authorship.book_id = books.book_id)
    JOIN (authors)
    ON (authorship.author_id = authors.author_id);

-- 2)Get a list of all books withdrawn by people with the initials 'B.W.'.
-- Show a column for the first name, last name, initials,
-- and the title of the book. Remember: keep things concise.
SELECT
    w.book_id,
    w.member_id,
    m.first_name,
    m.last_name,
    CONCAT(
        SUBSTRING(m.first_name, 1, 1),
        '.',
        SUBSTRING(m.last_name, 1, 1),
        '.'
    ) AS initials
FROM
    withdrawals w
    JOIN (members m)
    ON (w.member_id = m.member_id);

--3)Get the number of books written by each American author.Include the first and last names of the author.
-- Note that America might be represented in the 'country' column in more than one way
-- - always check your results table to make sure you're getting the expected results.
SELECT
    COUNT(b.book_id),
    authors.first_name,
    authors.last_name,
    authors.country
FROM
    books b
    JOIN (authorship)
    ON (authorship.book_id = b.book_id)
    JOIN (authors)
    ON (authorship.author_id = authors.author_id)
WHERE
    authors.country IN ('USA', 'U.S.')
GROUP BY
    authors.author_id;

-- 4)For any book withdrawn in October, get the member's first name, last name,
-- the withdrawal date and the book's title.
--Hint: Try getting the month from a date using the scalar function MONTH()
SELECT
    DISTINCT(m.member_id),
    b.title,
    w.withdrawal_date,
    m.first_name,
    m.last_name
FROM
    withdrawals w
    JOIN (members m)
    ON (w.member_id = m.member_id)
    JOIN (books b)
    ON (b.book_id = w.book_id)
WHERE
    MONTH(w.withdrawal_date) = 10;

--5) Get a list of people who have ever returned overdue books
--(i.e. any withdrawal where the return date is greater than the due date).
--Remember that, unless otherwise specified, lists shouldn't contain duplicate rows.
SELECT
    DISTINCT(w.member_id),
    m.first_name,
    m.last_name
FROM
    withdrawals w
    JOIN (members m)
    ON w.member_id = m.member_id
WHERE (w.return_date > w.due_date);

-- 6)Get a list of all authors, and the books they wrote.
-- Include authors multiple times if they wrote multiple books.
-- Also include authors who don't have any books in the database.
-- Hint: this is a tricky one - think back on why right joins exist in the first place.
SELECT
    a.author_id,
    authors.first_name,
    authors.last_name,
    b.title
FROM
    authors
    LEFT JOIN (authorship a)
    ON (a.author_id = authors.author_id)
    LEFT JOIN (books b)
    ON (a.book_id = b.book_id);

-- 7) Get a list of members who've never withdrawn a book.
-- Hint: outer joins return rows with null values if there is no match between the tables.
SELECT
    DISTINCT (members.member_id),
    members.first_name,
    members.last_name,
    w.withdrawal_id
FROM
    members
    LEFT JOIN (withdrawals w)
    ON (members.member_id = w.member_id)
WHERE
    withdrawal_id IS NULL;

-- 8) Rewrite the above query as the opposite join (if you used a left join, rewrite it as a right join;
-- if you used a right join, rewrite it as a left join).
-- The results table should contain the same data.
SELECT
    DISTINCT (members.member_id),
    members.first_name,
    members.last_name,
    w.withdrawal_id
FROM
    withdrawals w
    RIGHT JOIN (members)
    ON (members.member_id = w.member_id)
WHERE
    withdrawal_id IS NULL;

-- 9) Cross join books and authors. Isn't that ridiculous? In this case it is,
-- but there is use cases where cross joint could help.
-- For instance: Imagine you have a consolidated table which sums the total order which ocorred
-- in a time span of one hour for each vendor. If there were no sales no row will be generated
-- Now if you are going to create a graph per hour, all vendores would need to have a register
-- for each hour. Then you could use cross join to create for each vendor who hasn`t sold anything
-- a row with their sales and after that transform null values to 0 COALESCE.
SELECT
    *
FROM
    authors
    CROSS JOIN books;

--10) Get a list of all members who have the same first name as other members.
--Sort it by first name so you can verify the data.
SELECT
DISTINCT (a.member_id),
a.first_name
FROM
    members a
    JOIN (members b)
    ON a.first_name = b.first_name
    AND a.member_id  <> b.member_id  
    ORDER BY first_name;
