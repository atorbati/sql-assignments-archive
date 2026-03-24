-- 90-838 ASSIGNMENT 2
-- Abigail Torbatian (Andrew ID: atorbati)

-- NEED TO CAPITALIZE SELECT etc and make sure there is a "river" 
-- also dont forget to separate select from where and order by dont do just one long line

-- QUESTION 1:
SELECT title, category, pubdate
FROM books
WHERE (category <> 'COMPUTER' AND category <> 'CHILDREN') AND (pubdate < '01-01-2014' OR pubdate > '12-31-2015')
ORDER BY pubdate ASC;

-- QUESTION 2:
SELECT title, pubdate
FROM books
WHERE (category <> 'COMPUTER') AND (pubdate BETWEEN '01-01-2015' AND '12-31-2015' )
ORDER BY pubdate DESC;
-- most recent means the latest publication so closer to the end of 2015... right?

-- QUESTION 3: 
SELECT title, category, pubdate
FROM books
WHERE category NOT IN ('COMPUTER','CHILDREN') AND EXTRACT(YEAR FROM pubdate) NOT IN (2014,2015)
ORDER BY pubdate ASC;

-- QUESTION 4: 
SELECT isbn, title
FROM books
WHERE title LIKE '_A_N%'
ORDER BY title ASC;

-- QUESTION 5: 
SELECT UPPER(LEFT(fname, 1)) || LOWER((SUBSTRING(fname FROM 2)))||' '|| UPPER(lname) AS "Full Name"
FROM author
WHERE lname ILIKE '%a%r%'
ORDER BY authorid ASC;
-- Am I overthinking this because it says in the question im supposed to have the first letter of the first name capitalized
-- unless I am supposed to use something like INICAP but I dont remember if we learn about that yet?

-- QUESTION 6:
SELECT firstname, lastname, COALESCE(referred, 9999) AS "referrer"
FROM customers
WHERE region='SE';

-- QUESTION 7: 
SELECT firstname, lastname, COALESCE(CASE WHEN referred IS NOT NULL THEN 'Referred' ELSE NULL END, 'Not Referred') AS "Referred?"
FROM customers
WHERE region='SE';

-- QUESTION 8:
SELECT 'Customer ' ||customerno||': '||UPPER(firstname)||' '||UPPER(lastname)||', referred by Customer '|| referred AS RESULT
FROM customers
WHERE STATE = 'CA' AND referred IS NOT NULL

-- QUESTION 9:
SELECT isbn, title, pubdate
FROM books
WHERE EXTRACT(MONTH FROM pubdate)>= 1 AND EXTRACT(MONTH FROM pubdate)<= 3
ORDER BY pubdate DESC;

-- QUESTION 10: 
SELECT title, pubdate, (EXTRACT(YEAR FROM AGE(CURRENT_DATE, pubdate)) * 12 + EXTRACT(MONTH FROM AGE (CURRENT_DATE, pubdate))) AS agebookmonth
FROM books
WHERE category ='COMPUTER' 
ORDER BY agebookmonth DESC;
-- for some reason I kept getting a syntax error when running this without highlighting the queary for this question only 
-- so make sure to highlight and run ONLY this question if that makes sense

-- QUESTION 11:
SELECT DISTINCT SUBSTRING(email FROM POSITION('@'IN email)+1) AS emailservice
FROM customers
WHERE email IS NOT NULL
ORDER BY emailservice ASC;
-- NOTE TO SELF - make sure to use '' around the @ symbol lol or else you will get an error
-- hopefully this is correct 

-- QUESTION 12: 
SELECT shipstreet, SUBSTRING(shipstreet FROM 1 FOR POSITION(' ' IN shipstreet)-1) AS housenumber
FROM orders
WHERE shipstate = 'FL';
-- make sure to add a space in the ''
-- also make sure to do -1 not +1 that is not correct lol
-- same problem make sure to highlight only this question for it to run correctly and not give you a syntax error...