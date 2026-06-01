# 💰 Personal Finance Dashboard — SQL Project

A beginner-to-intermediate SQL project built with PostgreSQL, modelling a personal finance tracking system. This project demonstrates core SQL skills relevant to the financial services industry.

---

## 📋 Project Overview

This project builds a relational database to track personal finances — accounts, spending categories, and transactions — and uses SQL queries to analyse spending patterns, income vs expenses, and running balances.

---

## 🗄️ Database Schema

Three linked tables form the foundation of the dashboard:

```
accounts
├── account_id    (PK)
├── account_name
└── account_type  (checking / savings / credit)

categories
├── category_id   (PK)
├── category_name
└── category_type (income / expense)

transactions
├── transaction_id   (PK)
├── account_id       (FK → accounts)
├── category_id      (FK → categories)
├── transaction_date
├── amount
└── description
```

---

## 🔍 Queries Included

### 1. Total Spending by Category
```sql
SELECT c.category_name, SUM(t.amount) AS total
FROM transactions t
JOIN categories c ON t.category_id = c.category_id
WHERE t.amount < 0
GROUP BY c.category_name
ORDER BY total ASC;
```

### 2. Monthly Spending Breakdown
```sql
SELECT EXTRACT(MONTH FROM t.transaction_date) AS month, c.category_name, SUM(t.amount) AS total
FROM transactions t
JOIN categories c ON t.category_id = c.category_id
WHERE t.amount < 0
GROUP BY EXTRACT(MONTH FROM t.transaction_date), c.category_name
ORDER BY month, total ASC;
```

### 3. Income vs Expenses by Month
```sql
SELECT 
    EXTRACT(MONTH FROM transaction_date) AS month,
    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS income,
    SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS expenses,
    SUM(amount) AS net
FROM transactions
GROUP BY EXTRACT(MONTH FROM transaction_date)
ORDER BY month;
```

### 4. Running Balance (Window Function)
```sql
SELECT 
    transaction_date,
    description,
    amount,
    SUM(amount) OVER (ORDER BY transaction_date) AS running_balance
FROM transactions
ORDER BY transaction_date;
```

### 5. Category Spending Rank (Window Function)
```sql
SELECT 
    c.category_name,
    SUM(t.amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(t.amount) ASC) AS rank
FROM transactions t
JOIN categories c ON t.category_id = c.category_id
WHERE t.amount < 0
GROUP BY c.category_name
ORDER BY rank;
```

---

## 🛠️ Tools Used

- **PostgreSQL 18**
- **DBeaver** (SQL client)

---

## 💡 SQL Concepts Demonstrated

| Concept | Used In |
|---|---|
| CREATE TABLE, PRIMARY KEY, FOREIGN KEY | Schema setup |
| INSERT INTO | Sample data |
| SELECT, WHERE, ORDER BY | Basic querying |
| JOIN | Linking tables |
| GROUP BY, SUM, COUNT | Aggregations |
| CASE WHEN | Conditional logic |
| EXTRACT | Date functions |
| RANK(), SUM() OVER() | Window functions |

---

## 🚀 How to Run

1. Install PostgreSQL and DBeaver
2. Create a database called `finance_dashboard`
3. Run `schema.sql` to create the tables
4. Run `data.sql` to insert sample data
5. Run any query from `queries.sql`

---

## 👤 Author

Built as part of a self-directed SQL learning programme focused on financial services applications.
