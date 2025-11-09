-- Step 1: Insert authors (no dependencies)
INSERT INTO authors (author_name, birth_year, country) VALUES
  ('J.K. Rowling', 1965, 'United Kingdom'),
  ('George Orwell', 1903, 'United Kingdom'),
  ('Jane Austen', 1775, 'United Kingdom'),
  ('Haruki Murakami', 1949, 'Japan'),
  ('Gabriel García Márquez', 1927, 'Colombia'),
  ('Toni Morrison', 1931, 'United States'),
  ('Chinua Achebe', 1930, 'Nigeria'),
  ('Isabel Allende', 1942, 'Chile'),
  ('Agatha Christie', 1890, 'United Kingdom'),
  ('Stephen King', 1947, 'United States');

-- Step 2: Insert members (no dependencies)
INSERT INTO members (first_name, last_name, email, phone, address, join_date, membership_type, status) VALUES
  ('Alice', 'Johnson', 'alice.j@email.com', '555-0101', '123 Main St', DATE_SUB(CURDATE(), INTERVAL 400 DAY), 'premium', 'active'),
  ('Bob', 'Smith', 'bob.smith@email.com', '555-0102', '456 Oak Ave', DATE_SUB(CURDATE(), INTERVAL 300 DAY), 'standard', 'active'),
  ('Carol', 'Davis', 'carol.d@email.com', '555-0103', '789 Pine Rd', DATE_SUB(CURDATE(), INTERVAL 200 DAY), 'student', 'active'),
  ('David', 'Wilson', 'david.w@email.com', '555-0104', '321 Elm St', DATE_SUB(CURDATE(), INTERVAL 500 DAY), 'standard', 'suspended'),
  ('Emma', 'Brown', 'emma.b@email.com', '555-0105', '654 Maple Dr', DATE_SUB(CURDATE(), INTERVAL 100 DAY), 'premium', 'active'),
  ('Frank', 'Miller', 'frank.m@email.com', '555-0106', '987 Cedar Ln', DATE_SUB(CURDATE(), INTERVAL 600 DAY), 'standard', 'expired'),
  ('Grace', 'Taylor', 'grace.t@email.com', '555-0107', '147 Birch Way', DATE_SUB(CURDATE(), INTERVAL 250 DAY), 'student', 'active'),
  ('Henry', 'Anderson', 'henry.a@email.com', '555-0108', '258 Spruce Ct', DATE_SUB(CURDATE(), INTERVAL 150 DAY), 'standard', 'active'),
  ('Isabel', 'Martinez', 'isabel.m@email.com', '555-0109', '369 Willow Pl', DATE_SUB(CURDATE(), INTERVAL 350 DAY), 'premium', 'active'),
  ('Jack', 'Garcia', 'jack.g@email.com', '555-0110', '741 Ash Blvd', CURDATE(), 'student', 'active'),
  ('Karen', 'Rodriguez', 'karen.r@email.com', '555-0111', '852 Poplar St', DATE_SUB(CURDATE(), INTERVAL 180 DAY), 'standard', 'active'),
  ('Leo', 'Lee', 'leo.lee@email.com', '555-0112', '963 Hickory Ave', DATE_SUB(CURDATE(), INTERVAL 270 DAY), 'premium', 'active'),
  ('Maria', 'Lopez', 'maria.l@email.com', '555-0113', '159 Magnolia Dr', DATE_SUB(CURDATE(), INTERVAL 90 DAY), 'student', 'active'),
  ('Nathan', 'White', 'nathan.w@email.com', '555-0114', '357 Dogwood Ln', DATE_SUB(CURDATE(), INTERVAL 420 DAY), 'standard', 'active'),
  ('Olivia', 'Harris', 'olivia.h@email.com', '555-0115', '486 Redwood Way', DATE_SUB(CURDATE(), INTERVAL 310 DAY), 'premium', 'active'),
  ('Paul', 'Clark', 'paul.c@email.com', '555-0116', '624 Sequoia Ct', DATE_SUB(CURDATE(), INTERVAL 220 DAY), 'student', 'active'),
  ('Quinn', 'Lewis', 'quinn.l@email.com', '555-0117', '735 Cypress Pl', DATE_SUB(CURDATE(), INTERVAL 130 DAY), 'standard', 'active'),
  ('Rachel', 'Walker', 'rachel.w@email.com', '555-0118', '846 Fir Blvd', DATE_SUB(CURDATE(), INTERVAL 440 DAY), 'premium', 'active'),
  ('Sam', 'Hall', 'sam.h@email.com', '555-0119', '957 Beech St', DATE_SUB(CURDATE(), INTERVAL 60 DAY), 'standard', 'active'),
  ('Tina', 'Young', 'tina.y@email.com', '555-0120', '168 Cherry Ave', DATE_SUB(CURDATE(), INTERVAL 510 DAY), 'student', 'expired');

-- Step 3: Insert books (depends on authors)
INSERT INTO books (title, author_id, isbn, publication_year, genre, total_copies) VALUES
  ('Harry Potter and the Philosopher''s Stone', 1, '9780747532699', 1997, 'Fiction', 3),
  ('1984', 2, '9780451524935', 1949, 'Fiction', 2),
  ('Pride and Prejudice', 3, '9780141439518', 1813, 'Fiction', 2),
  ('Norwegian Wood', 4, '9780375704024', 1987, 'Fiction', 1),
  ('One Hundred Years of Solitude', 5, '9780060883287', 1967, 'Fiction', 2),
  ('Beloved', 6, '9781400033416', 1987, 'Fiction', 1),
  ('Things Fall Apart', 7, '9780385474542', 1958, 'Fiction', 2),
  ('The House of the Spirits', 8, '9781501117015', 1982, 'Fiction', 1),
  ('Murder on the Orient Express', 9, '9780062693662', 1934, 'Fiction', 2),
  ('The Shining', 10, '9780307743657', 1977, 'Fiction', 2),
  ('Harry Potter and the Chamber of Secrets', 1, '9780439064873', 1998, 'Fiction', 2),
  ('Animal Farm', 2, '9780451526342', 1945, 'Fiction', 2),
  ('Emma', 3, '9780141439587', 1815, 'Fiction', 1),
  ('Kafka on the Shore', 4, '9781400079278', 2002, 'Fiction', 1),
  ('Love in the Time of Cholera', 5, '9780307389732', 1985, 'Fiction', 1),
  ('The Bluest Eye', 6, '9780307278449', 1970, 'Fiction', 1),
  ('No Longer at Ease', 7, '9780385474559', 1960, 'Fiction', 1),
  ('Paula', 8, '9780062564689', 1994, 'Biography', 1),
  ('And Then There Were None', 9, '9780062073488', 1939, 'Fiction', 2),
  ('The Stand', 10, '9780307743688', 1978, 'Fiction', 2),
  ('A Brief History of Time', 1, '9780553380163', 1988, 'Science', 1),
  ('Sapiens: A Brief History of Humankind', 2, '9780062316097', 2011, 'History', 2),
  ('Educated', 3, '9780399590504', 2018, 'Biography', 2),
  ('The Very Hungry Caterpillar', 3, '9780399226908', 1969, 'Children', 3),
  ('Where the Wild Things Are', 5, '9780060254926', 1963, 'Children', 2);

-- Step 4: Insert book copies (depends on books)
INSERT INTO book_copies (book_id, copy_number, `condition`, acquisition_date) VALUES
  (1, 1, 'good', '2020-01-15'),
  (1, 2, 'excellent', '2021-05-20'),
  (1, 3, 'fair', '2019-03-10'),
  (2, 1, 'excellent', '2020-06-01'),
  (2, 2, 'good', '2021-02-14'),
  (3, 1, 'good', '2019-11-20'),
  (3, 2, 'fair', '2018-07-15'),
  (4, 1, 'excellent', '2021-03-22'),
  (5, 1, 'good', '2020-08-10'),
  (5, 2, 'good', '2021-01-05'),
  (6, 1, 'excellent', '2020-10-12'),
  (7, 1, 'good', '2019-09-18'),
  (7, 2, 'fair', '2018-12-03'),
  (8, 1, 'good', '2021-04-07'),
  (9, 1, 'excellent', '2020-02-28'),
  (9, 2, 'good', '2021-06-15'),
  (10, 1, 'good', '2019-08-22'),
  (10, 2, 'excellent', '2020-12-01'),
  (11, 1, 'excellent', '2021-07-10'),
  (11, 2, 'good', '2020-05-18'),
  (12, 1, 'good', '2019-10-25'),
  (12, 2, 'fair', '2018-11-30'),
  (13, 1, 'excellent', '2021-01-20'),
  (14, 1, 'good', '2020-09-14'),
  (15, 1, 'excellent', '2021-02-28'),
  (16, 1, 'good', '2020-07-19'),
  (17, 1, 'fair', '2019-05-22'),
  (18, 1, 'excellent', '2021-03-15'),
  (19, 1, 'good', '2020-11-08'),
  (19, 2, 'excellent', '2021-05-25'),
  (20, 1, 'good', '2019-12-14'),
  (20, 2, 'fair', '2018-10-20'),
  (21, 1, 'excellent', '2021-08-05'),
  (22, 1, 'good', '2020-04-12'),
  (22, 2, 'excellent', '2021-09-30'),
  (23, 1, 'excellent', '2021-06-18'),
  (23, 2, 'good', '2020-03-22'),
  (24, 1, 'good', '2019-07-14'),
  (24, 2, 'excellent', '2020-08-26'),
  (24, 3, 'fair', '2018-09-08'),
  (25, 1, 'excellent', '2021-04-20'),
  (25, 2, 'good', '2020-10-15');

-- Step 5: Insert events (no dependencies)
INSERT INTO events (event_name, event_date, event_type, max_attendees, description) VALUES
  ('Mystery Book Club - November', DATE_ADD(CURDATE(), INTERVAL 10 DAY), 'book_club', 15, 'Monthly mystery book discussion'),
  ('Children''s Story Time', DATE_ADD(CURDATE(), INTERVAL 3 DAY), 'reading_program', 20, 'Weekly story time for kids aged 3-7'),
  ('Meet Author Stephen King', DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'author_visit', 50, 'Q&A session with famous author'),
  ('Digital Literacy Workshop', DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'workshop', 12, 'Learn basic computer skills'),
  ('Teen Summer Reading Program', DATE_ADD(CURDATE(), INTERVAL 15 DAY), 'reading_program', 25, 'Summer reading challenge for teens'),
  ('Classic Literature Book Club', DATE_ADD(CURDATE(), INTERVAL 20 DAY), 'book_club', 15, 'Discussing Jane Austen novels'),
  ('Poetry Writing Workshop', DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'workshop', 10, 'Creative writing session'),
  ('Science Fiction Book Club', DATE_ADD(CURDATE(), INTERVAL 25 DAY), 'book_club', 15, 'Discussing 1984 by George Orwell');

-- Step 6: Insert loans (depends on members and book_copies)
INSERT INTO loans (member_id, copy_id, loan_date, due_date, return_date, status) VALUES
  -- Active loans (not returned yet)
  (1, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 9 DAY), NULL, 'active'),
  (2, 4, DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_ADD(CURDATE(), INTERVAL 4 DAY), NULL, 'active'),
  (3, 8, DATE_SUB(CURDATE(), INTERVAL 3 DAY), DATE_ADD(CURDATE(), INTERVAL 11 DAY), NULL, 'active'),
  (5, 11, DATE_SUB(CURDATE(), INTERVAL 7 DAY), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, 'active'),
  (7, 15, DATE_SUB(CURDATE(), INTERVAL 2 DAY), DATE_ADD(CURDATE(), INTERVAL 12 DAY), NULL, 'active'),
  (9, 21, DATE_SUB(CURDATE(), INTERVAL 8 DAY), DATE_ADD(CURDATE(), INTERVAL 6 DAY), NULL, 'active'),
  (11, 25, DATE_SUB(CURDATE(), INTERVAL 4 DAY), DATE_ADD(CURDATE(), INTERVAL 10 DAY), NULL, 'active'),
  
  -- Overdue loans (past due date, not returned)
  (2, 6, DATE_SUB(CURDATE(), INTERVAL 30 DAY), DATE_SUB(CURDATE(), INTERVAL 16 DAY), NULL, 'active'),
  (4, 9, DATE_SUB(CURDATE(), INTERVAL 25 DAY), DATE_SUB(CURDATE(), INTERVAL 11 DAY), NULL, 'active'),
  (6, 13, DATE_SUB(CURDATE(), INTERVAL 40 DAY), DATE_SUB(CURDATE(), INTERVAL 26 DAY), NULL, 'active'),
  (8, 17, DATE_SUB(CURDATE(), INTERVAL 35 DAY), DATE_SUB(CURDATE(), INTERVAL 21 DAY), NULL, 'active'),
  (10, 20, DATE_SUB(CURDATE(), INTERVAL 22 DAY), DATE_SUB(CURDATE(), INTERVAL 8 DAY), NULL, 'active'),
  
  -- Returned loans (completed)
  (1, 2, DATE_SUB(CURDATE(), INTERVAL 60 DAY), DATE_SUB(CURDATE(), INTERVAL 46 DAY), DATE_SUB(CURDATE(), INTERVAL 50 DAY), 'returned'),
  (3, 5, DATE_SUB(CURDATE(), INTERVAL 50 DAY), DATE_SUB(CURDATE(), INTERVAL 36 DAY), DATE_SUB(CURDATE(), INTERVAL 38 DAY), 'returned'),
  (5, 7, DATE_SUB(CURDATE(), INTERVAL 45 DAY), DATE_SUB(CURDATE(), INTERVAL 31 DAY), DATE_SUB(CURDATE(), INTERVAL 32 DAY), 'returned'),
  (7, 10, DATE_SUB(CURDATE(), INTERVAL 55 DAY), DATE_SUB(CURDATE(), INTERVAL 41 DAY), DATE_SUB(CURDATE(), INTERVAL 42 DAY), 'returned'),
  (9, 12, DATE_SUB(CURDATE(), INTERVAL 70 DAY), DATE_SUB(CURDATE(), INTERVAL 56 DAY), DATE_SUB(CURDATE(), INTERVAL 55 DAY), 'returned'),
  (11, 14, DATE_SUB(CURDATE(), INTERVAL 65 DAY), DATE_SUB(CURDATE(), INTERVAL 51 DAY), DATE_SUB(CURDATE(), INTERVAL 48 DAY), 'returned'),
  (13, 16, DATE_SUB(CURDATE(), INTERVAL 80 DAY), DATE_SUB(CURDATE(), INTERVAL 66 DAY), DATE_SUB(CURDATE(), INTERVAL 67 DAY), 'returned'),
  (15, 18, DATE_SUB(CURDATE(), INTERVAL 90 DAY), DATE_SUB(CURDATE(), INTERVAL 76 DAY), DATE_SUB(CURDATE(), INTERVAL 75 DAY), 'returned'),
  (17, 22, DATE_SUB(CURDATE(), INTERVAL 100 DAY), DATE_SUB(CURDATE(), INTERVAL 86 DAY), DATE_SUB(CURDATE(), INTERVAL 84 DAY), 'returned'),
  (19, 24, DATE_SUB(CURDATE(), INTERVAL 110 DAY), DATE_SUB(CURDATE(), INTERVAL 96 DAY), DATE_SUB(CURDATE(), INTERVAL 95 DAY), 'returned'),
  
  -- Returned late (with fines)
  (2, 3, DATE_SUB(CURDATE(), INTERVAL 120 DAY), DATE_SUB(CURDATE(), INTERVAL 106 DAY), DATE_SUB(CURDATE(), INTERVAL 100 DAY), 'returned'),
  (4, 19, DATE_SUB(CURDATE(), INTERVAL 130 DAY), DATE_SUB(CURDATE(), INTERVAL 116 DAY), DATE_SUB(CURDATE(), INTERVAL 110 DAY), 'returned'),
  (6, 23, DATE_SUB(CURDATE(), INTERVAL 140 DAY), DATE_SUB(CURDATE(), INTERVAL 126 DAY), DATE_SUB(CURDATE(), INTERVAL 118 DAY), 'returned'),
  (8, 26, DATE_SUB(CURDATE(), INTERVAL 150 DAY), DATE_SUB(CURDATE(), INTERVAL 136 DAY), DATE_SUB(CURDATE(), INTERVAL 130 DAY), 'returned'),
  
  -- Lost book
  (12, 27, DATE_SUB(CURDATE(), INTERVAL 180 DAY), DATE_SUB(CURDATE(), INTERVAL 166 DAY), NULL, 'lost'),
  
  -- Additional recent loans
  (14, 28, DATE_SUB(CURDATE(), INTERVAL 6 DAY), DATE_ADD(CURDATE(), INTERVAL 8 DAY), NULL, 'active'),
  (16, 30, DATE_SUB(CURDATE(), INTERVAL 9 DAY), DATE_ADD(CURDATE(), INTERVAL 5 DAY), NULL, 'active'),
  (18, 32, DATE_SUB(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 13 DAY), NULL, 'active');

-- Step 7: Insert fines (depends on loans)
INSERT INTO fines (loan_id, fine_amount, fine_reason, paid, payment_date) VALUES
  -- Overdue fines (unpaid)
  (8, 4.00, 'overdue', FALSE, NULL),   -- 16 days late
  (9, 2.75, 'overdue', FALSE, NULL),   -- 11 days late
  (10, 6.50, 'overdue', FALSE, NULL),  -- 26 days late
  (11, 5.25, 'overdue', FALSE, NULL),  -- 21 days late
  (12, 2.00, 'overdue', FALSE, NULL),  -- 8 days late
  
  -- Late return fines (paid)
  (21, 1.50, 'overdue', TRUE, DATE_SUB(CURDATE(), INTERVAL 99 DAY)),  -- 6 days late, paid
  (22, 1.50, 'overdue', TRUE, DATE_SUB(CURDATE(), INTERVAL 109 DAY)), -- 6 days late, paid
  (23, 2.00, 'overdue', TRUE, DATE_SUB(CURDATE(), INTERVAL 117 DAY)), -- 8 days late, paid
  (24, 1.50, 'overdue', TRUE, DATE_SUB(CURDATE(), INTERVAL 129 DAY)), -- 6 days late, paid
  
  -- Lost book fine (unpaid)
  (25, 25.00, 'lost', FALSE, NULL);

-- Step 8: Insert event registrations (depends on events and members)
INSERT INTO event_registrations (event_id, member_id, registration_date) VALUES
  -- Mystery Book Club
  (1, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
  (1, 2, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
  (1, 5, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
  (1, 9, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
  (1, 15, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
  
  -- Children's Story Time
  (2, 3, DATE_SUB(CURDATE(), INTERVAL 7 DAY)),
  (2, 7, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
  (2, 13, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
  
  -- Stephen King Event
  (3, 1, DATE_SUB(CURDATE(), INTERVAL 10 DAY)),
  (3, 2, DATE_SUB(CURDATE(), INTERVAL 9 DAY)),
  (3, 5, DATE_SUB(CURDATE(), INTERVAL 8 DAY)),
  (3, 9, DATE_SUB(CURDATE(), INTERVAL 7 DAY)),
  (3, 11, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
  (3, 15, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
  (3, 18, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
  
  -- Digital Literacy Workshop
  (4, 3, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
  (4, 7, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
  (4, 10, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
  
  -- Teen Summer Reading
  (5, 3, DATE_SUB(CURDATE(), INTERVAL 8 DAY)),
  (5, 7, DATE_SUB(CURDATE(), INTERVAL 7 DAY)),
  (5, 13, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
  (5, 16, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
  
  -- Classic Literature Club
  (6, 1, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
  (6, 5, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
  (6, 9, DATE_SUB(CURDATE(), INTERVAL 2 DAY));

-- Step 9: Insert audit log entries (no dependencies)
INSERT INTO audit_log (table_name, action, record_id, description) VALUES
  ('members', 'INSERT', 1, 'New member registration: Alice Johnson'),
  ('loans', 'UPDATE', 13, 'Book returned: Harry Potter copy 2'),
  ('fines', 'INSERT', 1, 'Overdue fine created for loan 8'),
  ('members', 'UPDATE', 4, 'Member status changed to suspended due to unpaid fines'),
  ('loans', 'UPDATE', 25, 'Book marked as lost after 180 days');







   set foreign_key_checks =1;
   set foreign_key_checks =0;