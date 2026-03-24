-- 90-838 ASSIGNMENT 4
-- Abigail Torbatian (Andrew ID: atorbati)

-- QUESTION 1:
SELECT o.orderdate AS orderdate, COUNT(DISTINCT o.orderno) AS ordercount, ROUND(SUM((oi.paideach-b.cost)*oi.quantity), 2) AS totalprofit
FROM orders AS o
JOIN orderitems AS oi ON oi.orderno = o.orderno
JOIN books AS b ON b.isbn = oi.isbn
WHERE o.orderdate >= DATE '2020-04-01'
AND o.orderdate < DATE '2020-05-01'
GROUP BY o.orderdate
ORDER BY orderdate ASC;

-- QUESTION 2: 
SELECT b.category, ROUND(AVG(b.retail-b.cost),2) AS avgprofit
FROM books AS b
JOIN publisher AS p ON p.pubid = b.pubid
WHERE p.name NOT ILIKE 'printing is us'
GROUP BY b.category 
HAVING COUNT(*)>1 AND AVG(b.retail-b.cost)>10
ORDER BY avgprofit DESC;

-- QUESTION 3
SELECT b.isbn, b.title, COALESCE (SUM(oi.quantity),0) AS copies_sold
FROM books AS b
LEFT JOIN orderitems AS oi ON oi.isbn = b.isbn
WHERE (b.retail-b.cost)/b.cost <0.55
GROUP BY b.isbn, b.title
ORDER BY copies_sold DESC;

-- QUESTION 4
-- tried out HAVING i might remove it and change it idk yet
SELECT c.firstname, c.lastname, ROUND(COALESCE(SUM(oi.paideach*oi.quantity),0),2) AS total_spending
FROM customers AS c
LEFT JOIN orders as o ON o.customerno=c.customerno
LEFT JOIN orderitems AS oi ON oi.orderno=o.orderno
WHERE c.state IN ('GA','FL')
GROUP BY c.customerno, c.firstname, c.lastname
HAVING COALESCE(SUM(oi.paideach*oi.quantity),0)<100
ORDER BY c.lastname ASC, c.firstname ASC;

-- QUESTION 5:
SELECT CASE WHEN (b.retail-b.cost)/b.cost >= 0.80 THEN 'HIGH'
WHEN (b.retail-b.cost)/b.cost < 0.55 THEN 'LOW'
ELSE 'MEDIUM'
END AS markup_tier, 
COUNT(*) AS book_count
FROM books AS b 
GROUP BY 
CASE WHEN(b.retail-b.cost)/b.cost >= 0.80 THEN 'HIGH'
WHEN (b.retail-b.cost)/b.cost < 0.55 THEN 'LOW'
ELSE 'MEDIUM'
END
ORDER BY book_count DESC;
-- I keep spelling medium as meedium i had to double check lol
-- oh my god medium needed to be all caps in both case when needs to be exactly the same... for future reference

-- QUESTION 6
-- subquery time woooo
SELECT DISTINCT c.customerno, c.firstname, c.lastname
FROM customers AS c
JOIN orders AS o ON o.customerno=c.customerno
JOIN orderitems AS oi ON oi.orderno=o.orderno
WHERE oi.isbn IN (
SELECT b1.isbn FROM books AS b1 WHERE b1.category = 'COMPUTER' AND b1.retail= (
SELECT MIN(b2.retail) FROM books AS b2 WHERE b2.category = 'COMPUTER'));

-- QUESTION 7:
SELECT b.category 
FROM books AS b
GROUP BY b.category
HAVING COUNT(*) > (SELECT COUNT(*) FROM books WHERE category = 'CHILDREN');
-- wait am i doing this right hmmm

-- QUESTION 8:
SELECT c.customerno, c.firstname, c.lastname, (c.address||', '||c.city||', '||c.state) AS full_address
FROM customers AS c
WHERE c.region = 'N' AND c.customerno NOT IN (
SELECT DISTINCT o.customerno
FROM orders AS o
WHERE o.orderdate >= DATE '2020-03-01'
AND o.orderdate < DATE '2020-04-01'
)
ORDER BY c.customerno ASC;

-- QUESTION 9:
SELECT b.isbn, b.title
FROM books AS b
WHERE b.isbn IN (
(SELECT oi.isbn
FROM orders AS o JOIN orderitems AS oi ON oi.orderno=o.orderno
WHERE o.orderdate >= DATE '2020-03-01'
AND o.orderdate < DATE '2020-04-01')
EXCEPT
(SELECT oi.isbn
FROM orders AS o
JOIN orderitems AS oi ON oi.orderno = o.orderno
WHERE o.orderdate >= DATE '2020-04-01'
AND o.orderdate < DATE '2020-05-01')
);

-- QUESTION 10
SELECT cl.name, ROUND(AVG(cl.duration),2) AS avg_duration_per_session,
SUM(cl.npost) AS total_posts
FROM CanvasLog AS cl 
WHERE cl.courseid = '90838-f25'
GROUP BY cl.andrewid, cl.name
HAVING COUNT(*) >= 10 AND AVG(cl.duration) >= 10 AND SUM(cl.npost) >= 10
ORDER BY total_posts DESC
LIMIT 5;

-- QUESTION 11
SELECT s.name, COUNT(*) AS total_courses,
SUM(c.units) AS total_units
FROM students AS s
JOIN enrollment AS e ON e.andrew=s.andrewid
JOIN courses AS c ON c.courseid=e.courseid
WHERE s.college = 'Heinz'
AND e.semester = 'F25'
GROUP BY s.andrewid, s.name
HAVING SUM(c.units) >=60
ORDER BY total_units DESC, s.andrewid ASC;

-- QUESTION 12
SELECT c.courseid, c.title
FROM courses AS c
WHERE c.units IN (9,12)
AND c.title ILIKE '%data%'
AND c.courseid NOT IN (
SELECT e.courseid
FROM enrollment AS e
WHERE e.semester = 'F25'
);
-- wooo I am done yaayyy happy fall break 