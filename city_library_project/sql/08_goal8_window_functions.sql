-- 8.1 Rank Members by Borrowing Activity
SELECT
  RANK() OVER (ORDER BY total_loans DESC) AS rank_num,
  DENSE_RANK() OVER (ORDER BY total_loans DESC) AS dense_rank_num,
  m2.first_name,
  m2.last_name,
  total_loans
FROM (
  SELECT 
    m.member_id,
    m.first_name,
    m.last_name,
    COUNT(l.loan_id) AS total_loans
  FROM members m
  JOIN loans l ON m.member_id = l.member_id
  GROUP BY m.member_id, m.first_name, m.last_name
) AS m2
ORDER BY total_loans DESC;

-- 8.2 Running Total of Fines Collected
SELECT
  payment_date,
  fine_amount,
  SUM(fine_amount) OVER (ORDER BY payment_date) AS running_total
FROM fines
WHERE paid = TRUE
ORDER BY payment_date;

-- 8.3 Rank Books by Genre
SELECT genre, title, loans, genre_rank
FROM (
    SELECT 
        b.genre,
        b.title,
        COUNT(l.loan_id) AS loans,
        RANK() OVER (PARTITION BY b.genre ORDER BY COUNT(l.loan_id) DESC) AS genre_rank
    FROM books b
    LEFT JOIN book_copies bc ON b.book_id = bc.book_id
    LEFT JOIN loans l ON bc.copy_id = l.copy_id
    GROUP BY b.book_id, b.genre, b.title
) AS ranked_books
WHERE genre_rank <= 3
ORDER BY genre, genre_rank;

-- 8.4 Loan Frequency Comparison per Member
WITH monthly_loans AS (
  SELECT
    member_id,
    YEAR(loan_date) AS year,
    MONTH(loan_date) AS month,
    COUNT(*) AS loans_this_month
  FROM loans
  GROUP BY member_id, year, month
)
SELECT
  member_id,
  year,
  month,
  loans_this_month,
  LAG(loans_this_month) OVER (PARTITION BY member_id ORDER BY year, month) AS previous_month_loans,
  loans_this_month - LAG(loans_this_month) OVER (PARTITION BY member_id ORDER BY year, month) AS change
FROM monthly_loans
ORDER BY member_id, year, month;

-- 8.5 Next Event for Each Member
WITH NextEvents AS (
    SELECT
        M.first_name,
        M.last_name,
        E.event_name,
        E.event_date,
        ROW_NUMBER() OVER (PARTITION BY M.member_id ORDER BY E.event_date ASC) AS rn
    FROM
        members M
    JOIN
        event_registrations ER ON M.member_id = ER.member_id
    JOIN
        events E ON ER.event_id = E.event_id
    WHERE
        E.event_date >= CURDATE()
)
SELECT
    first_name,
    last_name,
    event_name AS next_event_name,
    event_date
FROM
    NextEvents
WHERE
    rn = 1
ORDER BY
    event_date ASC;

-- 8.6 Moving Average of Loans (7-day)
WITH DailyLoans AS (
    SELECT
        DATE(loan_date) AS loan_day,
        COUNT(loan_id) AS loans_that_day
    FROM
        loans
    GROUP BY
        loan_day
)
SELECT
    loan_day,
    loans_that_day,
    AVG(loans_that_day) OVER (ORDER BY loan_day ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS seven_day_moving_avg
FROM
    DailyLoans
ORDER BY
    loan_day DESC
LIMIT 30;

-- 8.7 Percentile Ranking of Fines
SELECT
    M.first_name,
    M.last_name,
    F.fine_amount,
    ROUND(PERCENT_RANK() OVER (ORDER BY F.fine_amount ASC) * 100, 2) AS percentile_rank_pct
FROM
    fines F
JOIN
    loans L ON F.loan_id = L.loan_id
JOIN
    members M ON L.member_id = M.member_id
WHERE
    F.paid = FALSE
ORDER BY
    percentile_rank_pct DESC;

-- 8.8 Gap Analysis - Days Between Loans
SELECT
    M.first_name,
    M.last_name,
    L.loan_date,
    LAG(L.loan_date) OVER (PARTITION BY M.member_id ORDER BY L.loan_date) AS previous_loan_date,
    DATEDIFF(L.loan_date, LAG(L.loan_date) OVER (PARTITION BY M.member_id ORDER BY L.loan_date)) AS days_gap
FROM
    members M
JOIN
    loans L ON M.member_id = L.member_id
ORDER BY
    M.last_name, L.loan_date;