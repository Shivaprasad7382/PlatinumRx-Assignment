-- 02_Hotel_Queries.sql
-- 1) For every user: user_id and last booked room_no
SELECT u.user_id, b.room_no, b.booking_date
FROM users u
LEFT JOIN bookings b
  ON b.user_id = u.user_id
  AND b.booking_date = (
      SELECT MAX(b2.booking_date)
      FROM bookings b2
      WHERE b2.user_id = u.user_id
  );

-- 2) booking_id and total billing amount of bookings created in Nov 2021
SELECT bc.booking_id,
       SUM(i.item_rate * bc.item_quantity) AS total_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
JOIN bookings b ON bc.booking_id = b.booking_id
WHERE DATE(b.booking_date) BETWEEN '2021-11-01' AND '2021-11-30'
GROUP BY bc.booking_id;

-- 3) bill_id and bill amount of bills in Oct 2021 having bill amount > 1000
SELECT bc.bill_id,
       SUM(i.item_rate * bc.item_quantity) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE DATE(bc.bill_date) BETWEEN '2021-10-01' AND '2021-10-31'
GROUP BY bc.bill_id
HAVING SUM(i.item_rate * bc.item_quantity) > 1000;

-- 4) Determine the most and least ordered item of each month of 2021
-- Works in MySQL 8+ (uses window functions)
WITH item_monthly AS (
  SELECT DATE_FORMAT(bc.bill_date, '%Y-%m') AS month,
         bc.item_id,
         SUM(bc.item_quantity) AS total_qty
  FROM booking_commercials bc
  WHERE YEAR(bc.bill_date) = 2021
  GROUP BY month, bc.item_id
),
ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rn_desc,
         ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_qty ASC) AS rn_asc
  FROM item_monthly
)
SELECT m.month,
       (SELECT item_id FROM ranked r2 WHERE r2.month = m.month AND r2.rn_desc = 1) AS most_ordered_item,
       (SELECT item_id FROM ranked r3 WHERE r3.month = m.month AND r3.rn_asc = 1) AS least_ordered_item
FROM (SELECT DISTINCT month FROM item_monthly) m
ORDER BY m.month;

-- 5) Customers with the second highest bill value of each month of 2021
WITH bill_values AS (
  SELECT DATE_FORMAT(bc.bill_date, '%Y-%m') AS month,
         b.user_id,
         bc.bill_id,
         SUM(i.item_rate * bc.item_quantity) AS total_bill
  FROM booking_commercials bc
  JOIN items i ON bc.item_id = i.item_id
  JOIN bookings b ON b.booking_id = bc.booking_id
  WHERE YEAR(bc.bill_date) = 2021
  GROUP BY month, b.user_id, bc.bill_id
),
ranked AS (
  SELECT *,
         DENSE_RANK() OVER (PARTITION BY month ORDER BY total_bill DESC) AS bill_rank
  FROM bill_values
)
SELECT month, user_id, bill_id, total_bill
FROM ranked
WHERE bill_rank = 2
ORDER BY month;
