-- 7.1 All People in the System (Members and Authors)
SELECT member_id AS id, CONCAT(first_name, ' ', last_name) AS name, email, 'Member' AS type
FROM members
UNION
SELECT author_id AS id, author_name AS name, NULL AS email, 'Author' AS type
FROM authors
ORDER BY type, name;

-- 7.2 Comprehensive Activity Log (Loans, Events, Registrations)
SELECT 'Loan' AS activity_type, loan_date AS activity_date, b.title AS description
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
UNION ALL
SELECT 'Event' AS activity_type, event_date AS activity_date, event_name AS description
FROM events
UNION ALL
SELECT 'Registration' AS activity_type, registration_date AS activity_date,  e.event_name AS description
FROM event_registrations er
JOIN members m ON er.member_id = m.member_id
JOIN events e ON er.event_id = e.event_id
ORDER BY activity_date DESC
LIMIT 50;

-- 7.3 Books Available vs Currently Loaned
SELECT b.title, 'Available' AS status, COUNT(*) AS count
FROM book_copies bc
JOIN books b ON bc.book_id = b.book_id
WHERE bc.copy_id NOT IN (SELECT copy_id FROM loans WHERE status = 'active')
GROUP BY b.book_id
UNION
SELECT b.title, 'On Loan' AS status, COUNT(*) AS count
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
WHERE l.status = 'active'
GROUP BY b.book_id
ORDER BY title, status;

-- 7.4 Members with Issues (Overdue, Fines, Suspended)
SELECT 
    m.member_id, 
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    'Overdue' AS issue,
    COUNT(*) AS issue_count
FROM members m
JOIN loans l ON m.member_id = l.member_id
WHERE l.status = 'active' 
  AND l.due_date < CURDATE()
GROUP BY m.member_id, m.first_name, m.last_name, m.email

UNION

SELECT 
    m.member_id, 
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    'Unpaid Fines' AS issue,
    COUNT(*) AS issue_count
FROM members m
JOIN loans l ON m.member_id = l.member_id
JOIN fines f ON l.loan_id = f.loan_id
WHERE f.paid = FALSE
GROUP BY m.member_id, m.first_name, m.last_name, m.email

UNION

SELECT 
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    'Suspended' AS issue,
    1 AS issue_count
FROM members m
WHERE m.status = 'suspended'

ORDER BY member_name, issue;

-- 7.5 Popular vs Unpopular Books
(
  SELECT 
      b.title,
      a.author_name AS author,
      'Popular' AS category,
      COUNT(l.loan_id) AS loan_count
  FROM books b
  JOIN authors a ON b.author_id = a.author_id
  JOIN book_copies bc ON b.book_id = bc.book_id
  JOIN loans l ON bc.copy_id = l.copy_id
  GROUP BY b.book_id, b.title, a.author_name
  ORDER BY loan_count DESC
  LIMIT 10
)
UNION
(
  SELECT 
      b.title,
      a.author_name AS author,
      'Unpopular' AS category,
      COUNT(l.loan_id) AS loan_count
  FROM books b
  JOIN authors a ON b.author_id = a.author_id
  JOIN book_copies bc ON b.book_id = bc.book_id
  JOIN loans l ON bc.copy_id = l.copy_id
  GROUP BY b.book_id, b.title, a.author_name
  ORDER BY loan_count ASC
  LIMIT 10
)
ORDER BY category, loan_count;