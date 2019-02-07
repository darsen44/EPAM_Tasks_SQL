use StoredPr_DB;

-- 19.2
INSERT INTO post VALUES ('Manager'),
						('Pharmacist'),
                        ('Assistant');

INSERT INTO street VALUES 	('n.a. T. Shevchenka'),
							('n.a. L. Ukrainky'),
                            ('n.a. Ivan Franko');

INSERT INTO zone VALUES (1,'throat'),
						(2,'nose'),
                        (3,'heart'),
                        (4,'stomach');
                        

INSERT INTO medicine(name, ministry_code, recipe, narcotic, psychotropic) VALUES	
					('Strepsils','aa-111-11',1,0,0),
					('Vibrotsyl','bb-111-11',0,1,0),
					('Aflubin','cc-111-11',0,1,1),
                    ('Feminost','dd-111-11',1,0,0),
                    ('Cardiomagnil','ee-111-11',0,0,1);
                    
INSERT INTO medicine_zone (medicine_id, zone_id) 
	VALUES 
	('57', '1'),
	('58', '2'),
	('59', '1'),
	('60', '4'),
	('61', '3');


INSERT INTO pharmacy (name, building_number, www, work_time, saturday, sunday, street) 
					VALUES	("Pharmacy №1",45,'www.pharmacy1.com', '00:08:00',1,0,'n.a. Ivan Franko' ),
							("Pharmacy №2",33,'www.pharmacy2.com', '00:06:00',1,1,'n.a. L. Ukrainky' ),
                            ("Pharmacy №3",57,'www.pharmacy3.com', '00:07:00',0,1,'n.a. T. Shevchenka' );


INSERT INTO pharmacy (name, building_number, www, work_time, saturday, sunday, street) 
					VALUES	("Pharmacy №1",45,'www.pharmacy1.com', '00:08:00',1,0,'n.a. gg' );




INSERT INTO employee (surname,name,midle_name,identity_number,passport,experience,birthday,post,pharmacy_id)
					VALUES	('Homenick','Overpass ','Marvinburgh','5250330499','0499383401',5.5,'2000-04-25','Manager',1),
							('Johnny ','Gaylord '  ,'Marvinburgh','6178715698','6178715698',5.5,'2000-04-25','Assistant',1),
                            ('Nikolas ','Bailey'   ,' '          ,'1111222233','1111222233',5.5,'2000-04-25','Pharmacist',1),
                            ('Triston ','Kilback'  ,'           ','1111222233','1111222233',5.5,'2000-04-25','Manager',2),
                            ('Donny','Muller'      ,'           ','1111222233','1111222233',5.5,'2000-04-25','Assistant',2),
                            ('Tyreek','Price'      ,'           ','1111222233','1111222233',5.5,'2000-04-25','Manager',3),
                            ('Derick ','Kerluke '  ,'           ','1111222233','1111222233',5.5,'2000-04-25','Pharmacist',3);
                            
						
-- 19.3

					
DELIMITER //

CREATE TRIGGER BeforeUpdateIdentityNumber
	BEFORE INSERT 
	ON employee FOR EACH ROW
BEGIN
	IF (new.identity_number RLIKE('0{10}')) THEN
		SET new.identity_number = old.new.identity_number; -- ???
    ELSEIF (new.identity_number RLIKE ('00$')) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect format';
	END IF;
END;//
 
DELIMITER //
CREATE TRIGGER AfterInsertIdentityNumber
	AFTER INSERT
	ON employee FOR EACH ROW
    BEGIN
		IF(new.identity_number RLIKE ('00$')) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect format';
		END IF;
END//

DELIMITER //
CREATE TRIGGER AfterInsertMedicine
	AFTER INSERT
	ON medicine FOR EACH ROW
    BEGIN
		IF(new.ministry_code NOT RLIKE ('(?i)^[a-z&&[^mp]]{2}[[:hyphen:]]\\d{3}[[:hyphen:]]\\d{2}$')) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect format';
        END IF;
	END//
 
 DELIMITER //
CREATE TRIGGER AfterInsertPost
	AFTER INSERT
    ON post FOR EACH ROW
    BEGIN
		SIGNAL SQLSTATE'45000' SET MESSAGE_TEXT = 'Post can\'t be modifited';
END;//

DELIMITER //
CREATE TRIGGER AfterUpdatePost
	AFTER UPDATE
	ON post FOR EACH ROW
    BEGIN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Post can\'t be modified';
END;//

DELIMITER //    
CREATE TRIGGER AfterDeletePost
	AFTER DELETE
	ON post FOR EACH ROW
    BEGIN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Post can\'t be modified';
END;//

DELIMITER //
CREATE PROCEDURE InsertIntoEmployee(
	IN surname            VARCHAR(30),
    IN name          CHAR(30), 
    IN midle_name         VARCHAR(30),
    IN identity_number    CHAR(10),
    IN passport           CHAR(10),
    IN experience         DECIMAL(10, 1),
    IN birthday           DATE,
    IN post               VARCHAR(15),
    IN pharmacy_id        INT)
    BEGIN
    INSERT INTO employee VALUES (default,surname,name,midle_name,identity_number,passport,experience,birthday,post, pharmacy_id );
END; //
 
 DELIMITER //
 
CREATE FUNCTION minExperiance() RETURNS DECIMAL(10,1) DETERMINISTIC
	BEGIN
		RETURN (SELECT min(experience) from employee);
	END;//
SELECT minExperiance()//

DELIMITER //
CREATE FUNCTION getPfarmacyIndo(f_key int) RETURNS VARCHAR(60) DETERMINISTIC
		BEGIN
			RETURN (SELECT concat(p.name,'',p.building_number) as result from pharmacy p WHERE f_key = p.id);
END;//

SELECT *, getPfarmacyIndo(employee.pharmacy_id) as Info FROM employee;

-- TODO
DELIMITER //
-- 1
//
CREATE FUNCTION pharmacyExist(pharmacy_id int) RETURNS bool  DETERMINISTIC
		BEGIN
		RETURN EXISTS(SELECT * FROM pharmacy p WHERE pharmacy_id =  p.id);
	END //
    
    CREATE FUNCTION medicineExist(medicine_id int) RETURNS bool DETERMINISTIC
		BEGIN
		RETURN EXISTS(SELECT * FROM medicine m WHERE medicine_id =  m.id);
	END //
    
	CREATE FUNCTION zoneExist(zone_id int) RETURNS bool DETERMINISTIC
		BEGIN
		RETURN EXISTS(SELECT * FROM zone z WHERE zone_id =  z.id);
	END //
    
 	CREATE TRIGGER AfterInsertEpmloyee
 		AFTER INSERT 	
		ON employee FOR EACH ROW
		BEGIN
        IF(!pharmacyExist(new.pharmacy_id))
			THEN SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = 'Foreign key pharmacy not exist';
		END IF;
	END //
    CREATE TRIGGER BeforeUpdateEpmloyee
 		AFTER INSERT 	
		ON employee FOR EACH ROW
		BEGIN
		IF(!pharmacyExist(new.pharmacy_id))
			THEN SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = 'Foreign key pharmacy not exist';
		END IF;
	END //
    
    
	CREATE TRIGGER BeforeDeletePharmacy
 		BEFORE DELETE 	
		ON employee FOR EACH ROW
		BEGIN
		IF((SELECT COUNT(*) FROM employee WHERE employee.pharmacy_id = old.pharmacy_id)>0)
			THEN SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = 'Foreign key pharmacy not exist';
        END IF;
	END//
    
    CREATE TRIGGER AfterInsertPharmacyMedicine
		AFTER INSERT
        ON pharmacy_medicine FOR EACH ROW
        BEGIN
			IF(!(pharmacyExist(new.pharmacy_id) and medicineExist(new.medicine_id))) THEN
				 SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = 'Foreign key not exist';
			END IF;
	END; //
        
	CREATE TRIGGER BeforeUpdatePharmacyMedicine
		BEFORE UPDATE
        ON pharmacy_medicine FOR EACH ROW
        BEGIN
			IF(!(pharmacyExist(new.pharmacy_id) and medicineExist(new.medicine_id))) THEN
				 SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = 'Foreign key not exist';
			END IF;
	END; //
    
	CREATE TRIGGER AfterInsertMedicineZone
		AFTER INSERT
        ON medicine_zone FOR EACH ROW
        BEGIN
			IF(!(zoneExist(new.zone_id) and medicineExist(new.medicine_id))) THEN
				 SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = 'Foreign key not exist';
			END IF;
	END; //
    
	CREATE TRIGGER BeforeUpdatePharmacyMedicine
		BEFORE UPDATE
        ON medicine_zone FOR EACH ROW
        BEGIN
			IF(!(zoneExist(new.zone_id) and medicineExist(new.medicine_id))) THEN
				 SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = 'Foreign key not exist';
			END IF;
	END; //