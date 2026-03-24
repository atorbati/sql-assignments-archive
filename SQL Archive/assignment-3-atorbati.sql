-- 90-838 ASSIGNMENT 3
-- Abigail Torbatian (Andrew ID: atorbati)

-- QUESTION 1:
SELECT o.orderno AS "Order Number", o.orderdate AS "Order Date",
INITCAP(c.firstname) ||' '|| INITCAP(c.lastname) AS "Customer Name",
COALESCE(c.email, 'No Email') AS "Customer Email"
FROM orders AS o JOIN customers AS c ON o.customerno = c.customerno
WHERE o.shipdate IS NULL
ORDER BY o.orderdate ASC;


-- QUESTION 2:
SELECT o.orderdate AS "Order Date", b.title AS "Book Title", oi.quantity as "Quantity", (oi.paideach - b.cost) AS "Unit Profit", (oi.quantity * (oi.paideach - b.cost)) AS "Total Profit"
FROM customers as c JOIN orders as o ON c.customerno = o.customerno JOIN orderitems AS oi ON o.orderno = oi.orderno JOIN books AS b ON oi.isbn = b.isbn
WHERE c.firstname = 'TAMMY' AND c.lastname = 'GIANA'
ORDER BY "Total Profit" DESC;

-- QUESTION 3:
SELECT b.title AS "Book Title", b.retail AS "Retail Price", p.gift AS "Gift"
FROM author AS a JOIN bookauthor AS ba ON a.authorid = ba.authorid JOIN books AS b ON ba.isbn = b.isbn JOIN promotion AS p ON b.retail BETWEEN p.minretail AND p.maxretail
WHERE a.fname = 'JANICE'
AND a.lname = 'JONES'
AND p.gift = 'BOOK LABELS';

-- QUESTION 4:
SELECT DISTINCT c.customerno, c.lastname ||', '|| LEFT(c.firstname, 1) ||'.' AS "customer name", p.name AS "publisher"
FROM customers AS c JOIN orders AS o ON o.customerno = c.customerno JOIN orderitems AS oi ON oi.orderno = o.orderno JOIN books AS b ON b.isbn = oi.isbn JOIN publisher AS p ON p.pubid = b.pubid 
WHERE p.name ILIKE '%publish%'
ORDER BY "publisher" ASC, c.customerno ASC;

-- QUESTION 5:
SELECT c.customerno, c.firstname, c.lastname
FROM customers AS c LEFT JOIN orders AS o ON o.customerno = c.customerno AND o.shipstreet = c.address AND o.shipcity = c.city AND o.shipstate = c.state AND o.shipzip = c.zip
WHERE c.region = 'SE' AND o.orderno IS NULL
ORDER BY c.lastname ASC, c.firstname ASC;

-- QUESTION 6:
SELECT b.isbn, b.title AS "book title", p.name AS "publisher", p.contact AS "contact"
FROM publisher as p JOIN books AS b on b.pubid = p.pubid LEFT JOIN orderitems as oi ON oi.isbn = b.isbn
WHERE oi.orderno IS NULL
ORDER BY b.title ASC;

-- QUESTION 7:
SELECT c.customerno, c.firstname, c.lastname, o.orderno, b.title AS "book title", p.name AS "publisher"
FROM customers as c LEFT JOIN orders as o ON o.customerno = c.customerno
LEFT JOIN orderitems AS oi ON oi.orderno = o.orderno
LEFT JOIN books AS b ON b.isbn = oi.isbn
LEFT JOIN publisher AS p ON p.pubid = b.pubid
ORDER BY c.customerno ASC, o.orderno ASC;

-- QUESTION 8: 
-- so close to being done augh
SELECT a.authorid ||': '|| a.fname || ' '|| a.lname AS "author info", COALESCE(c.firstname ||' '|| c.lastname, 'No match') AS "name-matched customer" 
FROM author AS a LEFT JOIN customers AS c ON UPPER(c.lastname) = UPPER(a.lname)
ORDER BY a.authorid ASC, "name-matched customer" ASC;
-- my output isnt matching the result shown in the assignment hrrrmmmm.... >:\
-- ohmygod all I had to do was check that c.lastname and a.lname was in the correct spots... woooww

-- QUESTION 9:
SELECT DISTINCT c.customerno, c.firstname, c.lastname
FROM customers AS c JOIN orders AS o ON o.customerno = c.customerno
JOIN orders AS oo ON oo.customerno = c.customerno
WHERE o.orderdate >= DATE '2020-03-01' AND oo.orderdate < DATE '2020-04-01'
AND o.orderdate >= DATE '2020-04-01' AND oo.orderdate < DATE '2020-05-01'
ORDER BY c.lastname ASC;
-- o is for March oo is for April

-- question 10:
-- dont actually try this code out please it will mess up
-- dont test any of the questions past this one actually they are all rhetorical aka fake
SELECT
  mov.title AS "Movie Title",
  mov.genre AS "Genre",
  act.name  AS "Nominated Leading Actor"
FROM movie     AS mov
JOIN starring  AS star ON star.mid = mov.mid AND star.leading = 'Yes'
JOIN actor     AS act ON act.aid = star.aid AND act.nominated = 'Yes'
WHERE mov.release_date >= DATE '2017-01-01'
  AND mov.release_date <  DATE '2018-01-01'
ORDER BY mov.release_date ASC, mov.title ASC, act.name ASC;
-- i usually only do one letter for AS but I think this is easier for me to read
-- im assuming it doesnt change anything... hopefully

-- Question 11:
SELECT s.nation
FROM silver AS s 
JOIN bronze AS b ON b.nation = s.nation LEFT JOIN gold AS g ON g.nation = s.nation
WHERE s.count > b.count AND g.nation IS NULL; 
-- i forget should I order by something I dont think so??? I think i did this right i cant check

-- Question 12 FINALLY:
-- oh my god this is a lot
SELECT c1.team AS team, c1.year AS f_year, c2.year AS s_year
FROM champs AS c1 JOIN champs as c2 ON c2.team = c1.team AND c2.year = c1.year + 1
-- I think i am on the right track
-- now i need to left join but im so confused is champs the only thing i can use
LEFT JOIN champs AS c_prevyear ON c_prevyear.team = c1.team AND c_prevyear.team = c1.year - 1
LEFT JOIN champs AS c_nextyear ON c_nextyear.team = c1.team AND c_nextyear.team = c2.year + 1
WHERE c_prevyear.year IS NULL AND c_nextyear.year IS NULL
-- I regret putting year after prev and next but it still is easier for me to remember it doesnt have to do with teams
ORDER BY c1.team ASC, c1.year ASC;

-- I think I did it right I am so tired and ready to sleep thank you for dealing with my silly notes
