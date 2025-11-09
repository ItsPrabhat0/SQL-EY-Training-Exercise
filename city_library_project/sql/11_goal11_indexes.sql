
SELECT b.title, a.author_name, COUNT(*) AS loan_count
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
JOIN authors a ON b.author_id = a.author_id
GROUP BY b.book_id
ORDER BY loan_count DESC;



CREATE INDEX idx_loans_member_id              ON loans(member_id);
CREATE INDEX idx_loans_copy_id                ON loans(copy_id);
CREATE INDEX idx_loans_status                 ON loans(status);
CREATE INDEX idx_loans_status_due             ON loans(status, due_date);
CREATE INDEX idx_books_genre                  ON books(genre);
CREATE INDEX idx_book_copies_book_id          ON book_copies(book_id);
CREATE INDEX idx_fines_paid                   ON fines(paid);
CREATE INDEX idx_events_date                  ON events(event_date);
CREATE INDEX idx_registrations_event_member   ON event_registrations(event_id, member_id);


EXPLAIN
SELECT m.first_name, m.last_name, COUNT(*) AS loan_count
FROM members m
JOIN loans l ON m.member_id = l.member_id
WHERE l.status = 'active'
GROUP BY m.member_id;


EXPLAIN
SELECT m.first_name, m.last_name, COUNT(*) AS loan_count
FROM members m
JOIN loans l ON m.member_id = l.member_id
WHERE l.status = 'active'
GROUP BY m.member_id;




SELECT b.title,
  (SELECT COUNT(*) 
   FROM loans l 
   JOIN book_copies bc ON l.copy_id = bc.copy_id 
   WHERE bc.book_id = b.book_id) AS total_loans,
  (SELECT COUNT(*) 
   FROM loans l 
   JOIN book_copies bc ON l.copy_id = bc.copy_id 
   WHERE bc.book_id = b.book_id AND l.status = 'active') AS active_loans
FROM books b;


SELECT b.title,
  COUNT(l.loan_id) AS total_loans,
  SUM(CASE WHEN l.status = 'active' THEN 1 ELSE 0 END) AS active_loans
FROM books b
LEFT JOIN book_copies bc ON b.book_id = bc.book_id
LEFT JOIN loans l ON bc.copy_id = l.copy_id
GROUP BY b.book_id;



SHOW INDEXES FROM loans;
SHOW INDEXES FROM books;
SHOW INDEXES FROM members;

EXPLAIN
SELECT * 
FROM loans
WHERE status = 'active' AND due_date < CURDATE();
