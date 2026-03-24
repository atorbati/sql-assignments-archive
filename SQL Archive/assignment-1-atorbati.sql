-- 90-838 ASSIGNMENT 1
-- Abigail Torbatian (Andrew ID: atorbati)

-- QUESTION 1:
SELECT customerno, state, city
FROM customers
ORDER BY state ASC, city ASC;

-- QUESTION 2: 
SELECT firstname, lastname
FROM customers
WHERE state IN ('NJ')
ORDER BY customerno DESC;

-- QUESTION 3:
SELECT orderno, itemno,
(paideach * quantity) AS subtotal
FROM orderitems
WHERE (paideach * quantity) > 60
ORDER BY subtotal DESC, orderno ASC;
-- to answer your question yes i can use alias in the order by but not the where clause 

-- QUESTION 4: 
SELECT title, 
((retail-cost)/cost * 100) AS "Profit Margin %"
FROM books
WHERE pubid = 3 
ORDER BY "Profit Margin %" ASC;

-- QUESTION 5:
SELECT 
(name) AS "Publisher",
(contact) AS "Contact Person",
(phone) AS "Contact Number"
FROM publisher;

-- QUESTION 6:
SELECT customerno, orderno, orderdate, shipstate
FROM orders
WHERE shipstate='TX'
LIMIT 1;

-- QUESTION 7:
SELECT DISTINCT pubid, MIN(retail)
FROM books
WHERE retail>=50
GROUP BY pubid;

-- QUESTION 8: 
SELECT firstname, lastname, address
FROM customers
WHERE state = 'CA' AND city = 'SANTA MONICA'
ORDER BY lastname ASC;

-- QUESTION 9: 
SELECT orderno, orderdate, customerno
FROM orders
WHERE shipstate = 'NJ' AND orderdate > '2020-04-02';

-- QUESTION 10:
SELECT title, category
FROM books
WHERE category= 'CHILDREN' OR category='COOKING';

-- QUESTION 11:
SELECT title, pubdate 
FROM books
WHERE category != ('COMPUTER')
AND pubdate >='2015-01-01'
AND pubdate <='2016-01-01'
ORDER BY pubdate DESC;

-- QUESTION 12: 
SELECT orderno, shipdate, shipcost
FROM orders
WHERE shipcost >= 3
AND shipstate IN ('GA', 'FL', 'TX')
ORDER BY shipcost DESC;