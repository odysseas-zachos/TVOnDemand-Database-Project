-- Stored Procedures --

DROP PROCEDURE IF EXISTS last_names;

DELIMITER $

CREATE PROCEDURE last_names(IN lastname_a VARCHAR(255), IN lastname_b VARCHAR(255))
BEGIN
    SELECT first_name, last_name 
    FROM actor
    WHERE last_name >= CONCAT(lastname_a, '%') 
      AND last_name < CONCAT(lastname_b, '%')
    ORDER BY last_name ASC;
END $

DELIMITER ;


DROP PROCEDURE IF EXISTS same_last_names;

DELIMITER $

CREATE PROCEDURE same_last_names(IN surname VARCHAR(45))
BEGIN
    DECLARE lastname VARCHAR(45);
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE times INT;

    DECLARE curLastName CURSOR FOR
        SELECT COUNT(actor_id), last_name 
        FROM actor 
        WHERE last_name = surname 
        GROUP BY last_name;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN curLastName;

    REPEAT
        IF (NOT done) THEN
            FETCH curLastName INTO times, lastname;
        END IF;
    UNTIL done END REPEAT;

    CLOSE curLastName;

    SELECT CONCAT('Last name ', lastname, ' found ', times, ' times') AS Result;
END $

DELIMITER ;


-- Triggers for insert, delete, update on rental (Movies) --

DROP TRIGGER IF EXISTS trigger_movie_rental_insert;
DELIMITER $

CREATE TRIGGER trigger_movie_rental_insert BEFORE INSERT ON movie_rental
FOR EACH ROW
BEGIN
    DECLARE movie_rental_id INT;
    SET movie_rental_id = (SELECT rental_id FROM movie_rental WHERE rental_id = NEW.rental_id);
    IF movie_rental_id IS NULL THEN
        INSERT INTO logs VALUES (NULL, NEW.customer_id, NOW(), 'insert', 'movie_rental');
    END IF;
END $

DELIMITER ;


DROP TRIGGER IF EXISTS trigger_movie_rental_update;
DELIMITER $

CREATE TRIGGER trigger_movie_rental_update BEFORE UPDATE ON movie_rental
FOR EACH ROW
BEGIN
    IF NEW.rental_id = OLD.rental_id 
       AND NEW.rental_date = OLD.rental_date 
       AND NEW.inventory_id = OLD.inventory_id 
       AND NEW.customer_id = OLD.customer_id THEN
        SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'update failed due to duplicate fields in table movie_rental';
    ELSE
        INSERT INTO logs VALUES (NULL, NEW.customer_id, NOW(), 'update', 'movie_rental');
    END IF;
    
    IF (OLD.rental_id <> NEW.rental_id) THEN
        SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'update failed as rental_id must be unique';
    END IF;
END $

DELIMITER ;


DROP TRIGGER IF EXISTS trigger_movie_rental_delete;
DELIMITER $

CREATE TRIGGER trigger_movie_rental_delete BEFORE DELETE ON movie_rental
FOR EACH ROW
BEGIN
    INSERT INTO logs VALUES (OLD.customer_id, NOW(), 'delete', 'movie_rental');
END $

DELIMITER ;


-- Triggers for insert, update, delete on payment (Movies) --

DROP TRIGGER IF EXISTS trigger_movie_payment_insert;
DELIMITER $

CREATE TRIGGER trigger_movie_payment_insert BEFORE INSERT ON movie_payment
FOR EACH ROW
BEGIN
    DECLARE movie_payment_id INT;
    SET movie_payment_id = (SELECT payment_id FROM movie_payment WHERE payment_id = NEW.payment_id);
    IF movie_payment_id IS NULL THEN
        INSERT INTO logs VALUES (NEW.customer_id, NOW(), 'insert', 'movie_payment');
    END IF;
END $

DELIMITER ;


DROP TRIGGER IF EXISTS trigger_movie_payment_update;
DELIMITER $

CREATE TRIGGER trigger_movie_payment_update BEFORE UPDATE ON movie_payment
FOR EACH ROW
BEGIN
    IF NEW.payment_id = OLD.payment_id 
       AND NEW.customer_id = OLD.customer_id 
       AND NEW.rental_id = OLD.rental_id 
       AND NEW.amount = OLD.amount 
       AND NEW.payment_date = OLD.payment_date THEN
        SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'update failed due to duplicate fields in table movie_payment';
    ELSE
        INSERT INTO logs VALUES (NEW.customer_id, NOW(), 'update', 'movie_payment');
    END IF;
    
    IF (OLD.payment_id <> NEW.payment_id) THEN
        SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'update failed as payment_id must be unique';
    END IF;
END $

DELIMITER ;


DROP TRIGGER IF EXISTS trigger_movie_payment_delete;
DELIMITER $

CREATE TRIGGER trigger_movie_payment_delete BEFORE DELETE ON movie_payment
FOR EACH ROW
BEGIN
    INSERT INTO logs VALUES (OLD.customer_id, NOW(), 'delete', 'movie_payment');
END $

DELIMITER ;


-- Triggers for insert, delete, update on rental (Series) --

DROP TRIGGER IF EXISTS trigger_series_rental_insert;
DELIMITER $

CREATE TRIGGER trigger_series_rental_insert BEFORE INSERT ON series_rental
FOR EACH ROW
BEGIN
    DECLARE series_rental_id INT;
    SET series_rental_id = (SELECT series_rental_id FROM series_rental WHERE series_rental_id = NEW.series_rental_id);
    IF series_rental_id IS NULL THEN
        INSERT INTO logs VALUES (NEW.customer_id, NOW(), 'insert', 'series_rental');
    END IF;
END $

DELIMITER ;


DROP TRIGGER IF EXISTS trigger_series_rental_update;
DELIMITER $

CREATE TRIGGER trigger_series_rental_update BEFORE UPDATE ON series_rental
FOR EACH ROW
BEGIN
    IF NEW.series_rental_id = OLD.series_rental_id 
       AND NEW.rental_date = OLD.rental_date 
       AND NEW.inventory_id = OLD.inventory_id 
       AND NEW.customer_id = OLD.customer_id THEN
        SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'update failed due to duplicate fields in table series_rental';
    ELSE
        INSERT INTO logs VALUES (NEW.customer_id, NOW(), 'update', 'series_rental');
    END IF;
    
    IF (OLD.series_rental_id <> NEW.series_rental_id) THEN
        SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'update failed as rental_id must be unique';
    END IF;
END $

DELIMITER ;


DROP TRIGGER IF EXISTS trigger_series_rental_delete;
DELIMITER $

CREATE TRIGGER trigger_series_rental_delete BEFORE DELETE ON series_rental
FOR EACH ROW
BEGIN
    INSERT INTO logs VALUES (OLD.customer_id, NOW(), 'delete', 'series_rental');
END $

DELIMITER ;


-- Triggers for insert, update, delete on payment (Series) --

DROP TRIGGER IF EXISTS trigger_series_payment_insert;
DELIMITER $

CREATE TRIGGER trigger_series_payment_insert BEFORE INSERT ON series_payment
FOR EACH ROW
BEGIN
    DECLARE series_payment_id INT;
    SET series_payment_id = (SELECT series_payment_id FROM series_payment WHERE series_payment_id = NEW.series_payment_id);
    IF series_payment_id IS NULL THEN
        INSERT INTO logs VALUES (NEW.customer_id, NOW(), 'insert', 'series_payment');
    END IF;
END $

DELIMITER ;


DROP TRIGGER IF EXISTS trigger_series_payment_update;
DELIMITER $

CREATE TRIGGER trigger_series_payment_update BEFORE UPDATE ON series_payment
FOR EACH ROW
BEGIN
    IF NEW.series_payment_id = OLD.series_payment_id 
       AND NEW.customer_id = OLD.customer_id 
       AND NEW.series_rental_id = OLD.series_rental_id 
       AND NEW.amount = OLD.amount 
       AND NEW.payment_date = OLD.payment_date THEN
        SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'update failed due to duplicate fields in table series_payment';
    ELSE
        INSERT INTO logs VALUES (NEW.customer_id, NOW(), 'update', 'series_payment');
    END IF;
END $

DELIMITER ;


DROP TRIGGER IF EXISTS trigger_series_payment_delete;
DELIMITER $

CREATE TRIGGER trigger_series_payment_delete BEFORE DELETE ON series_payment
FOR EACH ROW
BEGIN
    INSERT INTO logs VALUES (OLD.customer_id, NOW(), 'delete', 'series_payment');
END $

DELIMITER ;


-- Discount & Customer Validation Triggers --

DROP TRIGGER IF EXISTS trigger_movie_payment_discount_insert;
DELIMITER $

CREATE TRIGGER trigger_movie_payment_discount_insert BEFORE INSERT ON movie_payment
FOR EACH ROW
BEGIN
    DECLARE discount DECIMAL(5,2);
    IF (SELECT COUNT(customer_id) FROM movie_rental WHERE customer_id = NEW.customer_id AND DATE(rental_date) = CURRENT_DATE()) > 2 THEN
        SET discount = NEW.amount / 2;
        SET NEW.amount = discount;
    END IF;
END $

DELIMITER ;


DROP TRIGGER IF EXISTS trigger_customer_validation;
DELIMITER $

CREATE TRIGGER trigger_customer_validation AFTER UPDATE ON customer
FOR EACH ROW
BEGIN
    IF (OLD.customer_id <> NEW.customer_id) THEN
        SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'Customer id can not be changed due to not having the required privileges!';
    END IF;
    
    IF (OLD.create_date <> NEW.create_date) THEN
        SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'Creation date can not be changed!';
    END IF;
    
    IF (OLD.active = 1) THEN
        IF (OLD.active <> NEW.active) THEN
            SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'Status can not be changed to zero since user is active!';
        END IF;
    END IF;
END $

DELIMITER ;


DROP TRIGGER IF EXISTS trigger_movie_payment_discount_update;
DELIMITER $

CREATE TRIGGER trigger_movie_payment_discount_update AFTER UPDATE ON movie_payment
FOR EACH ROW
BEGIN
    DECLARE discount DECIMAL(5,2);
    DECLARE discount_date VARCHAR(10);
    DECLARE rental_count INT;
    DECLARE rental_amount DECIMAL(5,2);
    
    IF EXISTS (SELECT 1 FROM movie_rental WHERE SUBSTRING(rental_date, 1, 10) LIKE SUBSTRING(CURRENT_TIMESTAMP, 1, 10)) THEN
        SET discount_date = SUBSTRING(CURRENT_TIMESTAMP, 1, 10);
    END IF;
    
    SET rental_count = (SELECT COUNT(customer_id) FROM movie_rental WHERE customer_id = NEW.customer_id GROUP BY customer_id);
    
    IF (rental_count > 2 AND SUBSTRING(NEW.payment_date, 1, 10) LIKE discount_date) THEN
        SET rental_amount = OLD.amount;
        SET discount = rental_amount / 2;
        INSERT INTO logs VALUES (NEW.customer_id, CURRENT_TIMESTAMP, 'discount_applied', 'movie_payment');
    END IF;
END $

DELIMITER ;


-- Procedure Calls --

CALL most_rents_on_dates('m', 5, '2000-12-31', '2021-12-31');
CALL monthly_earnings('GILBERT.SLEDGE@sakilacustomer.org', '2005-06-19');
CALL most_rents_on_date_of_customer();
CALL last_names('ay', 'be');
CALL same_last_names('DAVIS');
