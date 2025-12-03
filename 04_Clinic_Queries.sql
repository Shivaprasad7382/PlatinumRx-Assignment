-- 04_Clinic_Queries.sql

-- 1) Revenue from each sales channel in a given year (replace 2021 with desired year)
SELECT sales_channel, SUM(amount) AS revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel
ORDER BY revenue DESC;

-- 2) Top 10 most valuable customers for a given year
SELECT cs.uid, SUM(cs.amount) AS total_spent
FROM clinic_sales cs
WHERE YEAR(cs.datetime) = 2021
GROUP BY cs.uid
ORDER BY total_spent DESC
LIMIT 10;

-- 3) Month-wise revenue, expense, profit and status for a given year
WITH revenue AS (
  SELECT DATE_FORMAT(datetime, '%Y-%m') AS month, SUM(amount) AS revenue
  FROM clinic_sales
  WHERE YEAR(datetime) = 2021
  GROUP BY month
),
expense AS (
  SELECT DATE_FORMAT(datetime, '%Y-%m') AS month, SUM(amount) AS expense
  FROM expenses
  WHERE YEAR(datetime) = 2021
  GROUP BY month
)
SELECT r.month,
       COALESCE(r.revenue,0) AS revenue,
       COALESCE(e.expense,0) AS expense,
       COALESCE(r.revenue,0) - COALESCE(e.expense,0) AS profit,
       CASE WHEN COALESCE(r.revenue,0) - COALESCE(e.expense,0) > 0 THEN 'profitable' ELSE 'not-profitable' END AS status
FROM (SELECT DISTINCT DATE_FORMAT(datetime,'%Y-%m') month FROM clinic_sales WHERE YEAR(datetime)=2021
      UNION
      SELECT DISTINCT DATE_FORMAT(datetime,'%Y-%m') month FROM expenses WHERE YEAR(datetime)=2021) months
LEFT JOIN revenue r ON months.month = r.month
LEFT JOIN expense e ON months.month = e.month
ORDER BY months.month;

-- 4) For each city find the most profitable clinic for a given month (example: '2021-09')
WITH clinic_revenue AS (
  SELECT c.cid, c.city, SUM(cs.amount) AS revenue
  FROM clinics c
  JOIN clinic_sales cs ON c.cid = cs.cid
  WHERE DATE_FORMAT(cs.datetime,'%Y-%m') = '2021-09'
  GROUP BY c.cid, c.city
),
clinic_expense AS (
  SELECT e.cid, SUM(e.amount) AS expense
  FROM expenses e
  WHERE DATE_FORMAT(e.datetime,'%Y-%m') = '2021-09'
  GROUP BY e.cid
),
clinic_profit AS (
  SELECT cr.city, cr.cid, COALESCE(cr.revenue,0) - COALESCE(ce.expense,0) AS profit
  FROM clinic_revenue cr
  LEFT JOIN clinic_expense ce ON cr.cid = ce.cid
)
SELECT city, cid, profit
FROM (
  SELECT cp.*, ROW_NUMBER() OVER (PARTITION BY city ORDER BY profit DESC) AS rn
  FROM clinic_profit cp
) t
WHERE rn = 1;

-- 5) For each state find the second least profitable clinic for a given month (example: '2021-09')
WITH clinic_revenue AS (
  SELECT c.cid, c.state, SUM(cs.amount) AS revenue
  FROM clinics c
  JOIN clinic_sales cs ON c.cid = cs.cid
  WHERE DATE_FORMAT(cs.datetime,'%Y-%m') = '2021-09'
  GROUP BY c.cid, c.state
),
clinic_expense AS (
  SELECT e.cid, SUM(e.amount) AS expense
  FROM expenses e
  WHERE DATE_FORMAT(e.datetime,'%Y-%m') = '2021-09'
  GROUP BY e.cid
),
clinic_profit AS (
  SELECT cr.state, cr.cid, COALESCE(cr.revenue,0) - COALESCE(ce.expense,0) AS profit
  FROM clinic_revenue cr
  LEFT JOIN clinic_expense ce ON cr.cid = ce.cid
)
SELECT state, cid, profit
FROM (
  SELECT cp.*, DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
  FROM clinic_profit cp
) t
WHERE rnk = 2;
