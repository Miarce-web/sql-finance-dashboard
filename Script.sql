-- Manual data entry
INSERT INTO accounts (account_name, account_type) values
('Barclays Current', 'checking'),
('Barclays Savings', 'savings'),
('Visa Credit Card', 'credit');
INSERT INTO transactions (account_id, category_id, transaction_date, amount, description) VALUES
(1, 1, '2024-01-01', 3000.00, 'Monthly Salary'),
(1, 2, '2024-01-02', -1200.00, 'Rent Payment'),
(1, 3, '2024-01-05', -85.50, 'Tesco Groceries'),
(1, 4, '2024-01-06', -32.00, 'Bus Pass'),
(1, 5, '2024-01-08', -45.00, 'Dinner with friends'),
(1, 3, '2024-01-12', -92.30, 'Sainsburys Groceries'),
(1, 6, '2024-01-15', -14.99, 'Netflix'),
(1, 7, '2024-01-18', -120.00, 'Electric Bill'),
(1, 1, '2024-02-01', 3000.00, 'Monthly Salary'),
(1, 2, '2024-02-02', -1200.00, 'Rent Payment'),
(1, 3, '2024-02-07', -78.20, 'Tesco Groceries'),
(1, 5, '2024-02-14', -60.00, 'Valentines Dinner');
INSERT INTO categories (category_name, category_type) VALUES
('Salary', 'income'),
('Rent', 'expense'),
('Groceries', 'expense'),
('Transport', 'expense'),
('Eating Out', 'expense'),
('Entertainment', 'expense'),
('Utilities', 'expense');

Select * from categories;
select * from accounts;
select * from transactions;
SELECT current_database();
select * from categories, accounts, transactions -- show all colums on all 3 tables
select * from 
select table_name, column_name, data_type
from information_schema.columns
where table_schema = 'public'
order by table_name;

--show data from specific table
select description, amount, transaction_date
from transactions;

-- show data with filter (where)
select description, amount, transaction_date
from transactions
where amount < 0

-- Show all transactions in January 2024
SELECT description, amount, transaction_date
FROM transactions
WHERE transaction_date >= '2024-01-01' 
AND transaction_date <= '2024-01-31';

--Group By groups all rows into same
select category_id, sum(amount) as total
from transactions
where amount < 0
group by category_id
order by total asc;

select c.category_name, sum(t.amount) as total
from transactions t
join categories c on t.category_id = c.category_id
where t.amount < 0
group by c.category_name order by total asc

-- total spending per category per month
SELECT EXTRACT(MONTH FROM t.transaction_date) AS month, c.category_name, SUM(t.amount) AS total FROM transactions t JOIN categories c ON t.category_id = c.category_id WHERE t.amount < 0 GROUP BY EXTRACT(MONTH FROM t.transaction_date), c.category_name ORDER BY month, total ASC;

-- Income vs Expenses by month
SELECT EXTRACT(MONTH FROM transaction_date) AS month, SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS income, SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS expenses, SUM(amount) AS net FROM transactions GROUP BY EXTRACT(MONTH FROM transaction_date) ORDER BY month;


-- Running balance over time
SELECT 
    transaction_date,
    description,
    amount,
    SUM(amount) OVER (ORDER BY transaction_date) AS running_balance
FROM transactions
ORDER BY transaction_date;

-- Rank categories by total spending
SELECT 
    c.category_name,
    SUM(t.amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(t.amount) desc) AS rank
FROM transactions t
JOIN categories c ON t.category_id = c.category_id
WHERE t.amount < 0
GROUP BY c.category_name
ORDER BY rank;

