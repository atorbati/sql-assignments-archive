-- 90-838 ASSIGNMENT 8
-- Abigail Torbatian (Andrew ID: atorbati)

-- QUESTION 1:

-- (a) Your answer below:
CREATE TABLE books2 AS
SELECT *
FROM books;

-- (b) Your answer below:
ALTER TABLE books2
ADD CONSTRAINT books2_pk PRIMARY KEY (isbn);

-- (c) Your answer below:
CREATE TABLE category(
catcode CHAR(3) PRIMARY KEY,
catdesc TEXT NOT NULL
);

-- (d) Your answer below:
INSERT INTO category (catcode, catdesc) VALUES
('BUS', 'BUSINESS'),
('CHN', 'CHILDREN'),
('COK', 'COOKING'),
('COM', 'COMPUTER'),
('FAL', 'FAMILY LIFE'),
('FIT', 'FITNESS'),
('SEH', 'SELF HELP'),
('LIT', 'LITERATURE');

-- (e) Your answer below:
ALTER TABLE books2
ADD COLUMN catcode CHAR(3);

ALTER TABLE books2
ADD CONSTRAINT books2_catcode_fk
FOREIGN KEY (catcode) REFERENCES category(catcode);

-- (f)

-- ALTER TABLE Books2 ALTER COLUMN catcode SET NOT NULL;
-- i put the dashes in front of this line after doing it so i dont have to deal with the error popping up
/*
Your answer below:
(1) This statement tries to enforce that every row in Books2 must have a non-NULL
    value for catcode...
(2) When catcode was first added, all existing rows copied from Books had catcode = NULL,
    so setting NOT NULL at that time would cause issues aka violate or maybe cause an error to pop up because the constraint and PostgreSQL errors out.

Hopefully I am writing this correctly oops...?

*/

-- (g) Your answer below:
UPDATE books2 b
SET catcode = (
SELECT c.catcode
FROM category c 
WHERE UPPER(c.catdesc) = UPPER(b.category)
);

-- (h)

SELECT isbn, category, catcode
  FROM books2;


-- testing.. ignore this
UPDATE category
SET catdesc = 'BUSINESS'
WHERE catcode = 'BUS';
-- i misspelled something so im doing this as a repair...
UPDATE books2 b
SET catcode = (
  SELECT c.catcode
  FROM category c
  WHERE UPPER(c.catdesc) = UPPER(b.category)
);
SELECT COUNT(*)
FROM books2
WHERE catcode IS NULL;
-- done editing please ignore everything between the word testing and this...

-- (i) 
ALTER TABLE Books2 
ALTER COLUMN catcode SET NOT NULL;

-- (j) Your answer below:
ALTER TABLE books2
DROP COLUMN category;


-- (k) Your answer below:
INSERT INTO category (catcode, catdesc)
VALUES ('TRV', 'TRAVEL GUIDE');

INSERT INTO books2 (title, isbn, pubid, pubdate, cost, retail, catcode)
VALUES ('UNLONELY PLANET JAPAN', '1788683811', 3, DATE '2022-02-28', 17.50, 25.49, 'TRV');

-- (l) Your answer below:
SELECT b.title, p.name AS publisher_name, c.catdesc AS category_description 
FROM books2 b
JOIN publisher p ON p.pubid = b.pubid
JOIN category c ON c.catcode = b.catcode
WHERE b.isbn = '1788683811';

  

-- QUESTION 2:  
-- Your answer below:
-- reminder this is a reason it out i dont have to actually execute it... it doesnt exist..
-- this is a reminder for future me when i highlight everything and execute it to see if there are any errors this will not work
-- ignore the errors in this section lol... none of this is in justlee books data
WITH counts AS (
  SELECT m.mid, m.title, m.genre,
         COUNT(DISTINCT w.uid) AS usercount
  FROM movies m
  JOIN watchrecords w ON w.mid = m.mid
  GROUP BY m.mid, m.title, m.genre
),
ranked AS (
  SELECT *,
         DENSE_RANK() OVER (PARTITION BY genre ORDER BY usercount DESC) AS rnk
  FROM counts
)
SELECT mid, title, genre, usercount
FROM ranked
WHERE rnk = 1;




-- QUESTION 3:

-- run these lines first if you need to delete and recreate the tables
DROP TABLE IF EXISTS CheckWD, Account;

-- (a) Your answer below:
CREATE TABLE account (
  acno INT PRIMARY KEY,
  acname VARCHAR(50) NOT NULL,
  balance NUMERIC(12,2) NOT NULL,
  overdraft BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE checkwd (
  checkno INT PRIMARY KEY,
  acno INT NOT NULL REFERENCES account(acno),
  amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
  status VARCHAR(10) NOT NULL CHECK (status IN ('pending','cleared'))
);


 
-- (b) Your answer below:
INSERT INTO account (acno, acname, balance, overdraft) VALUES
  (9251, 'Bob', 2870.26, FALSE),
  (1347, 'Jill', 604.50, FALSE);

INSERT INTO checkwd (checkno, acno, amount, status) VALUES
  (2574655, 9251, 300.00, 'cleared'),
  (2607484, 1347, 2000.28, 'cleared');



-- (c)
-- run this line first if you need to delete and recreate your function
DROP FUNCTION IF EXISTS project_balance( INT, NUMERIC);

-- Your answer below:
CREATE FUNCTION project_balance(p_acno INT, p_amount NUMERIC)
RETURNS NUMERIC
LANGUAGE SQL AS
$$
  SELECT balance - p_amount
  FROM account
  WHERE acno = p_acno;
$$;



-- (d)

SELECT project_balance(1347, 800); 

-- (e)
-- run this line first if you need to delete and recreate your function and trigger
DROP FUNCTION IF EXISTS fn_new_checkwd () CASCADE;

-- Your answer below:
CREATE FUNCTION fn_new_checkwd()
RETURNS TRIGGER
LANGUAGE plpgsql AS
$$
DECLARE
  proj_bal NUMERIC;
BEGIN
  proj_bal := project_balance(NEW.acno, NEW.amount);

  IF proj_bal >= 0 THEN
    UPDATE account
    SET balance = proj_bal
    WHERE acno = NEW.acno;

    UPDATE checkwd
    SET status = 'cleared'
    WHERE checkno = NEW.checkno;
  ELSE
    UPDATE account
    SET overdraft = TRUE
    WHERE acno = NEW.acno;
  END IF;

  RETURN NULL;
END
$$;
-- i think i am doing this right my brain is so melted... I am ready for thanksgiving lol


-- (f) Your answer below:
CREATE TRIGGER tr_new_checkwd
AFTER INSERT ON checkwd
FOR EACH ROW
EXECUTE FUNCTION fn_new_checkwd();



-- (g) Your answer below:
INSERT INTO checkwd (checkno, acno, amount, status)
VALUES (3334444, 9251, 500.00, 'pending');

SELECT * FROM checkwd;
SELECT * FROM account;



-- after inserting the record, run code below to verify contents of both tables 

SELECT * FROM checkwd;
SELECT * FROM account;

-- (h) Your answer below:
INSERT INTO checkwd (checkno, acno, amount, status)
VALUES (5556666, 1347, 700.00, 'pending');

SELECT * FROM checkwd;
SELECT * FROM account;



-- after inserting the record, run code below to verify contents of both tables 

SELECT * FROM checkwd;
SELECT * FROM account;



-- QUESTION 4:

-- (a)
-- run these lines first if you need to delete and recreate the tables
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS member_status;
DROP TABLE IF EXISTS unit_price;
DROP TABLE IF EXISTS purchases;

-- Your answer below: 

CREATE TABLE members (
  name   TEXT,
  status TEXT
);

CREATE TABLE member_status (
  status   TEXT,
  minspent NUMERIC
);

CREATE TABLE unit_price (
  pid   INTEGER,
  price NUMERIC
);

CREATE TABLE purchases (
  name TEXT,
  pid  INTEGER,
  qty  NUMERIC
);


-- (b) Your answer below: 
INSERT INTO members (name) VALUES
  ('Jack'),
  ('Jill'),
  ('Bob');

INSERT INTO member_status (status, minspent) VALUES
  ('Platinum', 10000),
  ('Gold',     5000),
  ('Silver',    500),
  ('Bronze',      0);

INSERT INTO unit_price (pid, price) VALUES
  (101,  49.99),
  (102, 1199.99),
  (103, 369.99),
  (105, 299.99);

INSERT INTO purchases (name, pid, qty) VALUES
  ('Jack', 102, 10),
  ('Jack', 105,  1),
  ('Jill', 102,  2),
  ('Jack', 101,  8);
-- insert 0 4 (yay??? i think that is correct)


-- (c) 
-- run this line first if you need to delete and recreate your function
DROP FUNCTION IF EXISTS compute_status(TEXT);

-- Your answer below: 
CREATE FUNCTION compute_status(p_name TEXT)
RETURNS TEXT
LANGUAGE SQL AS
$$
  SELECT ms.status
  FROM member_status ms
  WHERE ms.minspent <= COALESCE(
        (SELECT SUM(p.qty * u.price)
         FROM purchases p
         JOIN unit_price u ON u.pid = p.pid
         WHERE p.name = p_name),
        0)
  ORDER BY ms.minspent DESC
  LIMIT 1;
$$;




-- (d)

SELECT compute_status('Jack');
SELECT compute_status('Jill');
SELECT compute_status('Bob');
 
-- (e) Your answer below:
UPDATE members m
SET status = compute_status(m.name);


-- after updating, run code below to verify contents of members table 
SELECT * FROM members;

-- (f) 
-- run this line first if you need to delete and recreate your function and trigger
DROP FUNCTION IF EXISTS fn_assign_curstatus () CASCADE;

-- Your answer below:
CREATE FUNCTION fn_assign_curstatus()
RETURNS TRIGGER
LANGUAGE plpgsql AS
$$
DECLARE
  new_status TEXT;
BEGIN
  new_status := compute_status(NEW.name);

  IF NOT EXISTS (SELECT 1 FROM members WHERE name = NEW.name) THEN
    INSERT INTO members(name, status)
    VALUES (NEW.name, new_status);
  ELSE
    IF (SELECT status FROM members WHERE name = NEW.name)
         IS DISTINCT FROM new_status THEN
      UPDATE members
      SET status = new_status
      WHERE name = NEW.name;
    END IF;
  END IF;

  RETURN NULL;
END
$$;



-- (g) Your answer below:
CREATE TRIGGER tr_assign_curstatus
AFTER INSERT ON purchases
FOR EACH ROW
EXECUTE FUNCTION fn_assign_curstatus();



-- (h) Your answer below:

INSERT INTO purchases (name, pid, qty) VALUES
  ('Bob', 103, 1),
  ('Jill', 105, 9),
  ('Kate', 102, 1);



-- after updating, run code below to verify contents of members table 
SELECT * FROM members;

 -- all done?
