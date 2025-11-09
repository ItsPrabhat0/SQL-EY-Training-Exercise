-- 5.1 Complete Loan History with Member and Book Info
SELECT m.first_name, m.last_name, m.email, b.title, a.author_name, l.loan_date, l.due_date, l.return_date, l.status
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
JOIN authors a ON b.author_id = a.author_id
ORDER BY l.loan_date DESC
LIMIT 20;

-- 5.2 Books Currently On Loan (Active)
SELECT b.title, a.author_name, bc.copy_number, m.first_name, m.last_name, l.loan_date, l.due_date,
  DATEDIFF(l.due_date, CURDATE()) AS days_until_due
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
JOIN authors a ON b.author_id = a.author_id
JOIN members m ON l.member_id = m.member_id
WHERE l.status = 'active'
ORDER BY l.due_date ASC;

-- 5.3 Members with Overdue Books and Unpaid Fines
SELECT m.first_name, m.last_name, m.email, m.phone,
  COUNT(DISTINCT CASE WHEN l.due_date < CURDATE() AND l.status = 'active' THEN l.loan_id END) AS overdue_books,
  COALESCE(SUM(f.fine_amount), 0) AS total_unpaid_fines
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
LEFT JOIN fines f ON l.loan_id = f.loan_id AND f.paid = FALSE
GROUP BY m.member_id
HAVING total_unpaid_fines > 0 OR overdue_books > 0
ORDER BY total_unpaid_fines DESC, overdue_books DESC;

-- 5.4 Book Availability Report: Total vs On Loan Copies
SELECT b.title, a.author_name,
  COUNT(DISTINCT bc.copy_id) AS total_copies,
  COUNT(DISTINCT CASE WHEN l.status = 'active' THEN l.copy_id END) AS copies_on_loan,
  (COUNT(DISTINCT bc.copy_id) - COUNT(DISTINCT CASE WHEN l.status = 'active' THEN l.copy_id END)) AS available_copies
FROM books b
JOIN authors a ON b.author_id = a.author_id
LEFT JOIN book_copies bc ON b.book_id = bc.book_id
LEFT JOIN loans l ON bc.copy_id = l.copy_id AND l.status = 'active'
GROUP BY b.book_id
ORDER BY available_copies ASC;

-- 5.5 Event Attendance List for Future Events
SELECT e.event_name, e.event_date, m.first_name, m.last_name, m.email, er.registration_date
FROM events e
JOIN event_registrations er ON e.event_id = er.event_id
JOIN members m ON er.member_id = m.member_id
WHERE e.event_date > CURDATE()
ORDER BY e.event_date, m.last_name, m.first_name;

-- 5.6 Author Popularity Report by Loans
SELECT a.author_name,
  COUNT(DISTINCT b.book_id) AS book_count,
  COUNT(l.loan_id) AS total_loans,
  ROUND(COUNT(l.loan_id) / COUNT(DISTINCT b.book_id), 2) AS avg_loans_per_book
FROM authors a
JOIN books b ON a.author_id = b.author_id
LEFT JOIN book_copies bc ON b.book_id = bc.book_id
LEFT JOIN loans l ON bc.copy_id = l.copy_id
GROUP BY a.author_id
HAVING total_loans > 0
ORDER BY total_loans DESC
LIMIT 10;

-- 5.7 Members Who Never Borrowed a Book
SELECT m.first_name, m.last_name, m.email, m.join_date, m.membership_type
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
WHERE l.loan_id IS NULL
ORDER BY m.join_date ASC;

-- 5.8 Self-Join: Members Living at the Same Address
SELECT DISTINCT m1.first_name AS member1_firstname, m1.last_name AS member1_lastname,
  m2.first_name AS member2_firstname, m2.last_name AS member2_lastname,
  m1.address
FROM members m1
JOIN members m2 ON m1.address = m2.address AND m1.member_id <> m2.member_id
ORDER BY m1.address;