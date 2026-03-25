# SQL Assignments Archive

A collection of SQL coursework completed in **90-838**, demonstrating progressive development in relational querying, database design, and PostgreSQL programming.

## Overview

This repository archives a sequence of SQL assignments covering core and intermediate database topics. Across these files, the work moves from foundational query writing to more advanced topics such as joins, aggregation, set operations, common table expressions (CTEs), window functions, schema design, constraints, triggers, and stored functions.

The assignments are written primarily in **PostgreSQL SQL syntax** and reflect hands-on practice with relational database concepts, query logic, and database programming.

## Topics Covered

### Foundational SQL querying
- `SELECT`, `WHERE`, `ORDER BY`, `DISTINCT`, and aliases
- Filtering with comparison, logical, and pattern-matching operators
- Basic computed columns and sorting strategies

### String, date, and null handling
- String formatting and parsing
- Date filtering and date-part extraction
- `COALESCE`, conditional labeling, and text construction

### Relational joins
- Inner joins and outer joins
- Multi-table queries across customers, orders, books, authors, and publishers
- Matching logic across related entities

### Aggregation and subqueries
- `COUNT`, `SUM`, `AVG`, `MIN`, and grouped summaries
- `GROUP BY` and `HAVING`
- Nested subqueries, `IN`, `NOT IN`, and `EXCEPT`

### Intermediate and advanced SQL
- `EXISTS` and correlated subqueries
- Common table expressions (CTEs)
- Window functions such as `RANK()`, `DENSE_RANK()`, `LAG()`, `LEAD()`, and running averages
- Analytical queries across time and grouped categories

### Database design and programming
- Table creation from existing relations
- Primary keys and foreign keys
- Schema normalization with lookup tables
- `ALTER TABLE`, `INSERT`, and `UPDATE`
- SQL functions and PL/pgSQL trigger functions
- Trigger-based updates for transactional and membership-status logic

## Files Included

- `assignment-1-atorbati.sql` — introductory querying, filtering, ordering, calculated fields, and basic aggregation
- `assignment-2-atorbati.sql` — string functions, date logic, pattern matching, null handling, and text parsing
- `assignment-3-atorbati.sql` — join-based querying across multiple relational tables
- `assignment-4-atorbati.sql` — grouped summaries, `HAVING`, subqueries, set operations, and practical reporting queries
- `assignment-5-atorbati.sql` — advanced querying with `EXISTS`, CTEs, ranking, lead/lag functions, and analytical SQL
- `assignment-8-atorbati.sql` — schema modification, foreign key design, normalization, SQL functions, PL/pgSQL triggers, and database programming

## Skills Demonstrated

- Writing clear SQL queries for relational data analysis
- Translating business or assignment prompts into executable SQL logic
- Using PostgreSQL-specific functions and syntax
- Building more complex analytical queries with reusable logic
- Designing and modifying relational database structures
- Implementing database-side automation with triggers and functions

## Suggested Repository Structure

```text
sql-assignments-archive/
├── README.md
├── assignment-1-atorbati.sql
├── assignment-2-atorbati.sql
├── assignment-3-atorbati.sql
├── assignment-4-atorbati.sql
├── assignment-5-atorbati.sql
└── assignment-8-atorbati.sql
```

## Notes

These assignments were completed as coursework and are preserved as an archive of SQL practice and database design work. They are useful as a reference for:
- relational query patterns
- PostgreSQL syntax examples
- database programming exercises
- progression from introductory to more advanced SQL topics

## Repository Description

Archive of PostgreSQL coursework demonstrating SQL querying, joins, aggregation, CTEs, window functions, schema design, constraints, triggers, and stored functions.
dated.md…]()
