-- 4.1 Count Members by Membership Type with Percentage
SELECT membership_type, COUNT(*) AS member_count,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM members), 2) AS percentage
FROM members
GROUP BY membership_type
ORDER BY member_count DESC;

-- 4.2 Total Fines Collected vs Outstanding
SELECT paid,
  SUM(fine_amount) AS total_amount,
  COUNT(*) AS fine_count
FROM fines
GROUP BY paid WITH ROLLUP;

-- 4.3 Most Popular Genres (Top 5)
SELECT genre,
  COUNT(DISTINCT book_id) AS titles,
  SUM(total_copies) AS copies
FROM books
GROUP BY genre
ORDER BY copies DESC
LIMIT 5;

-- 4.4 Average Loan Duration by Member Type (Returned Only)
SELECT m.membership_type,
  ROUND(AVG(DATEDIFF(l.return_date, l.loan_date)), 2) AS avg_days,
  COUNT(*) AS loans_count
FROM loans l
JOIN members m ON l.member_id = m.member_id
WHERE l.status = 'returned'
GROUP BY m.membership_type
ORDER BY avg_days DESC;

-- 4.5 Books Never Borrowed
SELECT b.title, a.author_name, b.genre, MIN(bc.acquisition_date) as earliest_acquisition
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN book_copies bc ON b.book_id = bc.book_id
LEFT JOIN loans l ON bc.copy_id = l.copy_id
WHERE l.loan_id IS NULL
GROUP BY b.book_id
ORDER BY earliest_acquisition;

-- 4.6 Member Borrowing Activity (Top 10)
SELECT CONCAT(m.first_name, ' ', m.last_name) AS member_name,
  COUNT(*) AS total_loans,
  SUM(CASE WHEN l.status = 'active' THEN 1 ELSE 0 END) AS active_loans,
  COALESCE(SUM(f.fine_amount), 0) AS unpaid_fines
FROM members m
JOIN loans l ON m.member_id = l.member_id
LEFT JOIN fines f ON l.loan_id = f.loan_id AND f.paid = FALSE
GROUP BY m.member_id
HAVING total_loans > 0
ORDER BY total_loans DESC
LIMIT 10;

-- 4.7 Monthly Loan Statistics (Last 6 Months)
SELECT YEAR(loan_date) AS year, MONTH(loan_date) AS month,
  COUNT(*) AS total_loans,
  COUNT(DISTINCT member_id) AS unique_borrowers,
  COUNT(DISTINCT copy_id) AS unique_books
FROM loans
WHERE loan_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY year, month
ORDER BY year DESC, month DESC
LIMIT 6;

-- 4.8 Event Registration Summary (Future Events)
SELECT e.event_name, e.event_date, COUNT(er.registration_id) AS registrations,
  e.max_attendees,
  ROUND(100.0 * COUNT(er.registration_id) / e.max_attendees, 2) AS capacity_percentage
FROM events e
LEFT JOIN event_registrations er ON e.event_id = er.event_id
WHERE e.event_date > CURDATE()
GROUP BY e.event_id
ORDER BY capacity_percentage DESC;