-- ===============================================
-- GOAL 9: Create Stored Procedures and Functions
-- ===============================================

-- -------------------------------------------------
-- Procedure 9.1: CheckoutBook
-- -------------------------------------------------
DELIMITER //
CREATE PROCEDURE CheckoutBook(
  IN p_member_id INT,
  IN p_copy_id INT,
  OUT p_due_date DATE,
  OUT p_message VARCHAR(200)
)
proc_checkout: BEGIN
  DECLARE member_exists INT DEFAULT 0;
  DECLARE member_status VARCHAR(20);
  DECLARE is_on_loan INT DEFAULT 0;
  DECLARE loan_period INT DEFAULT 14;

  -- Check if member exists and is active
  SELECT COUNT(*), status INTO member_exists, member_status
  FROM members
  WHERE member_id = p_member_id
  GROUP BY status
  LIMIT 1;

  IF member_exists = 0 THEN
    SET p_message = 'Member does not exist.';
    LEAVE proc_checkout;
  END IF;

  IF member_status <> 'active' THEN
    SET p_message = 'Member is not active.';
    LEAVE proc_checkout;
  END IF;

  -- Check if the book copy is available
  SELECT COUNT(*) INTO is_on_loan
  FROM loans
  WHERE copy_id = p_copy_id AND status = 'active';

  IF is_on_loan > 0 THEN
    SET p_message = 'Book copy is already on loan.';
    LEAVE proc_checkout;
  END IF;

  -- Insert loan record
  SET p_due_date = DATE_ADD(CURDATE(), INTERVAL loan_period DAY);
  INSERT INTO loans(member_id, copy_id, loan_date, due_date, status)
  VALUES (p_member_id, p_copy_id, CURDATE(), p_due_date, 'active');

  -- Success message
  SET p_message = CONCAT('Book checked out successfully. Due on ', p_due_date);
END //
DELIMITER ;

-- Test it:
CALL CheckoutBook(1, 5, @due, @msg);
SELECT @due, @msg;


-- -------------------------------------------------
-- Procedure 9.2: ReturnBook
-- -------------------------------------------------
DELIMITER //
CREATE PROCEDURE ReturnBook(
  IN p_loan_id INT,
  OUT p_fine_amount DECIMAL(10,2),
  OUT p_message VARCHAR(200)
)
proc_return: BEGIN
  DECLARE v_due_date DATE;
  DECLARE v_days_overdue INT DEFAULT 0;
  DECLARE v_exists INT DEFAULT 0;

  -- Initialize
  SET p_fine_amount = 0;

  -- Check if loan exists and is active
  SELECT COUNT(*), due_date INTO v_exists, v_due_date
  FROM loans
  WHERE loan_id = p_loan_id AND status = 'active'
  GROUP BY due_date
  LIMIT 1;

  IF v_exists = 0 THEN
    SET p_message = 'Invalid or inactive loan.';
    LEAVE proc_return;
  END IF;

  -- Update loan return date and status
  UPDATE loans
  SET return_date = CURDATE(), status = 'returned'
  WHERE loan_id = p_loan_id;

  -- Calculate fine
  SET v_days_overdue = DATEDIFF(CURDATE(), v_due_date);

  IF v_days_overdue > 0 THEN
    SET p_fine_amount = v_days_overdue * 0.25;
    INSERT INTO fines(loan_id, fine_amount, paid)
    VALUES (p_loan_id, p_fine_amount, FALSE);
    SET p_message = CONCAT('Book returned. Fine: $', p_fine_amount);
  ELSE
    SET p_message = 'Book returned on time. No fine.';
  END IF;
END //
DELIMITER ;

-- Test it:
CALL ReturnBook(3, @fine, @msg);
SELECT @fine, @msg;


-- -------------------------------------------------
-- Function 9.3: CalculateFineDays
-- -------------------------------------------------
DELIMITER //
CREATE FUNCTION CalculateFineDays(
  p_due_date DATE,
  p_return_date DATE
) RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE days_late INT;
  SET days_late = DATEDIFF(p_return_date, p_due_date);
  IF days_late < 0 THEN
    RETURN 0;
  ELSE
    RETURN days_late;
  END IF;
END //
DELIMITER ;

-- Test it:
SELECT title, CalculateFineDays(due_date, CURDATE()) AS days_overdue
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
WHERE l.status = 'active';


-- -------------------------------------------------
-- Procedure 9.4: GenerateMemberReport
-- -------------------------------------------------
DELIMITER //
CREATE PROCEDURE GenerateMemberReport(IN p_member_id INT)
BEGIN
  -- Result Set 1: Member info
  SELECT first_name, last_name, email, membership_type, status
  FROM members 
  WHERE member_id = p_member_id;
  
  -- Result Set 2: Current loans
  SELECT b.title, l.loan_date, l.due_date
  FROM loans l
  JOIN book_copies bc ON l.copy_id = bc.copy_id
  JOIN books b ON bc.book_id = b.book_id
  WHERE l.member_id = p_member_id AND l.status = 'active';
  
  -- Result Set 3: Unpaid fines
  SELECT SUM(fine_amount) AS total_unpaid
  FROM fines f
  JOIN loans l ON f.loan_id = l.loan_id
  WHERE l.member_id = p_member_id AND f.paid = FALSE;
  
  -- Result Set 4: Registered events
  SELECT e.event_name, e.event_date
  FROM event_registrations er
  JOIN events e ON er.event_id = e.event_id
  WHERE er.member_id = p_member_id AND e.event_date >= CURDATE();
END //
DELIMITER ;

-- Test it:
CALL GenerateMemberReport(1);
