-- 90-838 ASSIGNMENT 5
-- ABIGAIL TORBATIAN (Andrew ID: atorbati)
-- I confirmed all the tables are working yay
-- QUESTION 1:
SELECT category
FROM books
GROUP BY category
HAVING COUNT(*) > ANY (
SELECT COUNT(*)
FROM books
GROUP BY category
)
ORDER BY category;

-- QUESTION 2:
SELECT b.isbn, b.title
FROM books AS b 
WHERE EXISTS(
SELECT 1
FROM orderitems AS oi
JOIN orders AS o ON o.orderno = oi.orderno
WHERE oi.isbn = b.isbn
GROUP BY oi.isbn
HAVING COUNT(*) FILTER (
WHERE o.orderdate >= DATE '2020-03-01' AND o.orderdate < DATE '2020-04-01'
) > 0
AND COUNT(*) FILTER(
WHERE o.orderdate >= DATE '2020-04-01' AND o.orderdate < DATE '2020-05-01'
) = 0
) 
ORDER BY b.isbn;

-- QUESTION 3:
WITH book_freq AS (
SELECT oi.isbn, COUNT(DISTINCT oi.orderno) AS freq
FROM orderitems oi
GROUP BY oi.isbn
),
maxf AS (
SELECT MAX(freq) AS max_freq
FROM book_freq
)
SELECT a.fname, a.lname, b.title
FROM book_freq AS bf
JOIN maxf AS m ON bf.freq = m.max_freq
JOIN books AS b ON b.isbn = bf.isbn
JOIN bookauthor AS ba ON ba.isbn = b.isbn
JOIN author AS a ON a.authorid = ba.authorid
ORDER BY a.lname, a.fname, b.title;

-- QUESTION 4:
SELECT
  c.customerno,
  c.firstname,
  c.lastname
FROM customers AS c
JOIN orders      AS o  ON o.customerno = c.customerno
JOIN orderitems  AS oi ON oi.orderno   = o.orderno
JOIN bookauthor  AS ba ON ba.isbn      = oi.isbn
JOIN author      AS a  ON a.authorid   = ba.authorid
WHERE a.fname = 'JAMES'
  AND a.lname = 'AUSTIN'
GROUP BY c.customerno, c.firstname, c.lastname
HAVING COUNT(DISTINCT oi.isbn) = (
  SELECT COUNT(DISTINCT ba2.isbn)
  FROM bookauthor ba2
  JOIN author a2 ON a2.authorid = ba2.authorid
  WHERE a2.fname = 'JAMES'
    AND a2.lname = 'AUSTIN'
)
ORDER BY c.customerno;

-- QUESTION 5:
SELECT
  (a.authorid || ': ' || INITCAP(a.fname) || ' ' || INITCAP(a.lname)) AS author,
  (
    SELECT MIN(p2.name)
    FROM bookauthor ba2
    JOIN books b2     ON b2.isbn = ba2.isbn
    JOIN publisher p2 ON p2.pubid = b2.pubid
    WHERE ba2.authorid = a.authorid
  ) AS publisher
FROM author a
JOIN bookauthor ba ON ba.authorid = a.authorid
JOIN books b       ON b.isbn      = ba.isbn
GROUP BY a.authorid, a.fname, a.lname
HAVING COUNT(DISTINCT b.isbn) >= 2
   AND COUNT(DISTINCT b.pubid) = 1
ORDER BY a.authorid;
-- more than one book with same publisher... noooo cte
-- QUESTION 6a:
SELECT c.courseid, c.title
FROM courses AS c
WHERE EXISTS (
  SELECT 1
  FROM enrollment AS e
  JOIN students s ON s.andrewid = e.andrewid
  WHERE e.courseid = c.courseid
  GROUP BY e.courseid
  HAVING COUNT(*) > 0 AND COUNT(*) FILTER (WHERE s.college <> 'Heinz') = 0
)
ORDER BY c.courseid;

-- QUESTION 6b:
SELECT c.courseid, c.title
FROM courses AS c
JOIN (
  SELECT
    e.courseid,
    COUNT(DISTINCT e.andrewid) AS n_total,
    COUNT(DISTINCT e.andrewid) FILTER (WHERE s.college='Heinz') AS n_heinz
  FROM enrollment AS e
  JOIN students s ON s.andrewid = e.andrewid
  GROUP BY e.courseid) x ON x.courseid = c.courseid
WHERE x.n_total = x.n_heinz
ORDER BY c.courseid;

-- QUESTION 7:
SELECT 
  team,
  ROUND(100.0 * COUNT(*) / COUNT(*) OVER (), 2) AS "Win Share %",
  RANK() OVER (ORDER BY COUNT(*) DESC) AS "Win Rank"
FROM champs
GROUP BY team
ORDER BY "Win Share %" DESC, team ASC;

-- QUESTION 8:
SELECT
  team,
  year AS "Last Win",
  LEAD(year) OVER (PARTITION BY team ORDER BY year) AS "Subsequent Win",
  LEAD(year) OVER (PARTITION BY team ORDER BY year) - year AS "Winless Gap"
FROM champs
ORDER BY "Winless Gap" DESC NULLS LAST, team
LIMIT 10;

-- QUESTION 9:
WITH four_years AS (
  SELECT
    year,
    team,
    LAG(team, 1)  OVER (ORDER BY year) AS prev_team,  
    LEAD(team, 1) OVER (ORDER BY year) AS next_team,   
    LEAD(team, 2) OVER (ORDER BY year) AS next2_team   
  FROM champs
)
SELECT
  team,
  COUNT(*) AS times_exact_two_in_a_row
FROM four_years
WHERE
  team = next_team           
  AND team <> prev_team AND team <> next2_team      
  AND next_team IS NOT NULL  
  AND next2_team IS NOT NULL
GROUP BY team
ORDER BY times_exact_two_in_a_row DESC, team;

-- QUESTION 10:
-- Q10: Top 10 ranked movies by IMDB rating (no 'type' column)
WITH ranked AS (
  SELECT
    title,
    year,
    imdbrating,
    imdbvotes,
    RANK() OVER (ORDER BY imdbrating DESC) AS rank
  FROM imdbtitles
)
SELECT
  title,
  year,
  imdbrating,
  imdbvotes,
  rank
FROM ranked
WHERE rank <= 10
ORDER BY rank ASC, imdbvotes DESC;

-- QUESTION 11:
-- this one stumped me for a while
WITH ranked AS (
  SELECT
    title,
    year,
    imdbrating,
    imdbvotes,
    country,
    (imdbrating * imdbvotes) AS popularity,
    RANK() OVER (ORDER BY (imdbrating * imdbvotes) DESC) AS overall_rank,
    RANK() OVER (PARTITION BY country ORDER BY (imdbrating * imdbvotes) DESC) AS country_rank
  FROM imdbtitles
)
SELECT
  title,
  year,
  imdbrating,
  imdbvotes,
  country,
  country_rank,
  overall_rank
FROM ranked
WHERE country IN ('USA', 'UK', 'Japan')
  AND country_rank <= 3
ORDER BY country, country_rank, overall_rank;

-- QUESTION 12:
SELECT
  title,
  year,
  AVG(imdbrating) OVER (
    ORDER BY year
    ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
  ) AS "Running Avg (Before)",
  imdbrating AS "Current Rating",
  AVG(imdbrating) OVER (
    ORDER BY year
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS "Running Avg (Through Current)"
FROM imdbtitles
WHERE title ILIKE 'Harry Potter%'
ORDER BY year;
-- wow that is a lot of purple highlighted words...
-- QUESTION 13:
-- woo almost done...
-- Step oneeee
SELECT
  country,
  year,
  COUNT(*) AS nmovie
FROM imdbtitles
WHERE year BETWEEN 2005 AND 2014
  AND country IN ('USA', 'UK', 'Japan')
  AND imdbvotes >= 100
  AND imdbrating >= 5.0
GROUP BY country, year
ORDER BY country, year;

-- step 2 yaayy im done
WITH moviecounts AS (
  SELECT
    country,
    year,
    COUNT(*) AS nmovie
  FROM imdbtitles
  WHERE year BETWEEN 2005 AND 2014
    AND country IN ('USA', 'UK', 'Japan')
    AND imdbvotes >= 100
    AND imdbrating >= 5.0
  GROUP BY country, year
)
SELECT
  country,
  year,
  nmovie,
  nmovie - LAG(nmovie, 1, 0) OVER (PARTITION BY country ORDER BY year) AS yoy_delta,
  AVG(nmovie) OVER (
    PARTITION BY country
    ORDER BY year
    ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
  ) AS ma5,
  AVG(nmovie) OVER (
    PARTITION BY country
    ORDER BY year
    ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING
  ) AS cma5
FROM moviecounts
ORDER BY country, year;
