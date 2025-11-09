-- 6.1 Members with Above-Average Total Unpaid Fines
SELECT m_fines.first_name, m_fines.last_name, total_fines, fine_count
FROM (
  SELECT m.member_id, m.first_name, m.last_name,
    SUM(f.fine_amount) AS total_fines,
    COUNT(f.fine_id) AS fine_count
  FROM members m
  JOIN loans l ON m.member_id = l.member_id
  JOIN fines f ON l.loan_id = f.loan_id AND f.paid = FALSE
  GROUP BY m.member_id
) AS m_fines
WHERE total_fines > (SELECT AVG(fine_amount) FROM fines)
ORDER BY total_fines DESC;

-- 6.2 Books More Popular Than Average (Loans)
SELECT 
    b.title, 
    a.author_name, 
    bl.loan_count as total_loans,
    avg_data.avg_loan_count AS average_loans
FROM (
    SELECT 
        bc.book_id, 
        COUNT(l.loan_id) AS loan_count
    FROM book_copies bc
    LEFT JOIN loans l ON bc.copy_id = l.copy_id
    GROUP BY bc.book_id
) AS bl
JOIN books b ON bl.book_id = b.book_id
JOIN authors a ON b.author_id = a.author_id
CROSS JOIN (
    SELECT AVG(sub.loan_count) AS avg_loan_count
    FROM (
        SELECT 
            bc.book_id,
            COUNT(l.loan_id) AS loan_count
        FROM book_copies bc
        LEFT JOIN loans l ON bc.copy_id = l.copy_id
        GROUP BY bc.book_id
    ) AS sub
) AS avg_data
WHERE bl.loan_count > avg_data.avg_loan_count
ORDER BY bl.loan_count DESC;

-- 6.3 CTE Example: Member Borrowing Summary
WITH total_loans AS (
  SELECT member_id, COUNT(*) AS loans_count
  FROM loans
  GROUP BY member_id
), unpaid_fines AS (
  SELECT l.member_id, COALESCE(SUM(f.fine_amount), 0) AS total_fines
  FROM loans l
  LEFT JOIN fines f ON l.loan_id = f.loan_id AND f.paid = FALSE
  GROUP BY l.member_id
), active_loans AS (
  SELECT member_id, COUNT(*) AS active_loans_count
  FROM loans
  WHERE status = 'active'
  GROUP BY member_id
)
SELECT m.first_name, m.last_name, tl.loans_count as total_loans,al.active_loans_count, af.total_fines ,m.status
FROM members m
LEFT JOIN total_loans tl ON m.member_id = tl.member_id
LEFT JOIN unpaid_fines af ON m.member_id = af.member_id
LEFT JOIN active_loans al ON m.member_id = al.member_id
ORDER BY tl.loans_count DESC;

-- 6.4 Books Never Loaned (Subquery)
SELECT b.title, a.author_name, b.genre, b.total_copies
FROM books b
JOIN authors a ON b.author_id = a.author_id
WHERE b.book_id NOT IN (
  SELECT DISTINCT bc.book_id
  FROM book_copies bc
  JOIN loans l ON bc.copy_id = l.copy_id
);

-- 6.5 Members Who Attended All Book Club Events
SELECT 
    m.first_name, 
    m.last_name, 
    COUNT(DISTINCT e.event_id) AS events_attended
FROM members m
JOIN event_registrations er ON m.member_id = er.member_id
JOIN events e ON er.event_id = e.event_id
WHERE e.event_type = 'book_club'
GROUP BY m.member_id, m.first_name, m.last_name
HAVING COUNT(DISTINCT e.event_id) = (
    SELECT COUNT(*) 
    FROM events 
    WHERE event_type = 'book_club'
)
ORDER BY m.first_name, m.last_name;

-- 6.6 CTE Monthly Revenue Report (Fines + Memberships)
WITH fines_revenue AS (
    SELECT 
        YEAR(payment_date) AS year,
        MONTH(payment_date) AS month,
        SUM(fine_amount) AS total_fines
    FROM fines
    WHERE paid = TRUE 
      AND payment_date IS NOT NULL
    GROUP BY year, month
),
memberships_revenue AS (
    SELECT 
        YEAR(join_date) AS year,
        MONTH(join_date) AS month,
        SUM(
            CASE membership_type
                WHEN 'standard' THEN 20
                WHEN 'premium' THEN 50
                WHEN 'student' THEN 10
                ELSE 0
            END
        ) AS total_membership
    FROM members
    GROUP BY year, month
)
SELECT 
    COALESCE(fr.year, mr.year) AS year,
    COALESCE(fr.month, mr.month) AS month,
    IFNULL(fr.total_fines, 0) AS fine_revenue,
    IFNULL(mr.total_membership, 0) AS membership_revenue,
    (IFNULL(fr.total_fines, 0) + IFNULL(mr.total_membership, 0)) AS total_revenue
FROM fines_revenue fr
LEFT JOIN memberships_revenue mr 
    ON fr.year = mr.year AND fr.month = mr.month
UNION
SELECT 
    COALESCE(fr.year, mr.year) AS year,
    COALESCE(fr.month, mr.month) AS month,
    IFNULL(fr.total_fines, 0) AS fine_revenue,
    IFNULL(mr.total_membership, 0) AS membership_revenue,
    (IFNULL(fr.total_fines, 0) + IFNULL(mr.total_membership, 0)) AS total_revenue
FROM memberships_revenue mr
LEFT JOIN fines_revenue fr 
    ON fr.year = mr.year AND fr.month = mr.month
ORDER BY year DESC, month DESC
LIMIT 12;

-- 6.7 Correlated Subquery: Latest Loan per Book
SELECT 
    b.title,
    a.author_name,
    (
        SELECT MAX(l.loan_date)
        FROM loans l
        JOIN book_copies bc ON l.copy_id = bc.copy_id
        WHERE bc.book_id = b.book_id
    ) AS most_recent_loan_date,
    (
        SELECT CONCAT(m.first_name, ' ', m.last_name)
        FROM loans l
        JOIN book_copies bc ON l.copy_id = bc.copy_id
        JOIN members m ON l.member_id = m.member_id
        WHERE bc.book_id = b.book_id
        ORDER BY l.loan_date DESC
        LIMIT 1
    ) AS borrower_name
FROM books b
JOIN authors a ON b.author_id = a.author_id
WHERE EXISTS (
    SELECT 1
    FROM loans l
    JOIN book_copies bc ON l.copy_id = bc.copy_id
    WHERE bc.book_id = b.book_id
)
ORDER BY most_recent_loan_date DESC;

-- 6.8 Book Recommendation Engine (Simplified)
WITH favorite_genres AS (
  SELECT m.member_id, b.genre, COUNT(*) AS genre_count,
    RANK() OVER (PARTITION BY m.member_id ORDER BY COUNT(*) DESC) AS genre_rank
  FROM loans l
  JOIN members m ON l.member_id = m.member_id
  JOIN book_copies bc ON l.copy_id = bc.copy_id
  JOIN books b ON bc.book_id = b.book_id
  GROUP BY m.member_id, b.genre
), recommended_books AS (
  SELECT fg.member_id, b.book_id, b.title, b.genre
  FROM favorite_genres fg
  JOIN books b ON fg.genre = b.genre
  WHERE fg.genre_rank = 1
)
SELECT m.first_name, m.last_name, rb.genre, rb.title
FROM recommended_books rb
JOIN members m ON rb.member_id = m.member_id
WHERE NOT EXISTS (
  SELECT 1 FROM loans l 
  JOIN book_copies bc ON l.copy_id = bc.copy_id
  WHERE l.member_id = rb.member_id AND bc.book_id = rb.book_id
)
ORDER BY m.member_id, rb.title
LIMIT 5;