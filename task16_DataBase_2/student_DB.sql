DROP DATABASE Student;
CREATE DATABASE Student;
USE Student;
DROP TABLE student;
CREATE TABLE IF NOT EXISTS student (
	id INT  AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    middle_name VARCHAR(45),
    autobiography VARCHAR(255),
    group_id INT NULL,
    date_of_birth DATE NOT NULL,
    address VARCHAR(50) NOT NULL,
    rating INT DEFAULT 0 CHECK(rating BETWEEN 0 AND 100),
    scholarship INT generated ALWAYS AS -- TODO
                        (CASE rating
                        WHEN rating < 71 THEN 0
                        WHEN rating >= 88 THEN 1800
                        WHEN rating >= 71 THEN 1300
                        END)
);

CREATE TABLE  IF NOT EXISTS student_group(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    specialty_id INT,
    entry_year INT(4) NOT NULL
);
-- 3
CREATE TABLE IF NOT EXISTS specialty(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS discipline(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    lecturer_id INT
);
CREATE TABLE IF NOT EXISTS lecturer(
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    second_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20)
);
CREATE TABLE  IF NOT EXISTS results_of_disciplines(
	discipline_id INT,
    student_id INT,
	module_1 FLOAT NOT NULL,
    module_2 FLOAT NOT NULL,
    type_of_control enum('exam', 'test'),
    mark_in_100 FLOAT GENERATED ALWAYS AS (module_1 + module_2),
    mark_in_5 INT generated ALWAYS AS -- TODO
                        (CASE mark_in_100
                        WHEN mark_in_100 < 50 THEN 2
                        WHEN mark_in_100 >= 50 AND mark_in_100 < 71 THEN 3
                        WHEN mark_in_100 >= 71 AND mark_in_100 < 88 THEN 4
                        WHEN mark_in_100 >= 88 THEN 5
                        END),
    term int
);
ALTER TABLE student
	ADD FOREIGN KEY (group_id)
    REFERENCES student_group(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
;
ALTER TABLE student_group
	ADD FOREIGN KEY (specialty_id)
    REFERENCES specialty(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
;
ALTER TABLE discipline
	ADD FOREIGN KEY (lecturer_id)
    REFERENCES lecturer(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
;
ALTER TABLE results_of_disciplines
	ADD FOREIGN KEY (discipline_id)
    REFERENCES discipline(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
;
ALTER TABLE results_of_disciplines
	ADD FOREIGN KEY (student_id)
    REFERENCES student(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
;
-- ALTER TABLE student MODIFY autobiography VARCHAR(255);

INSERT INTO specialty VALUES(1,"KI");

INSERT INTO student_group VALUES(1,"KI-15",1,2014);

INSERT INTO student (first_name,last_name,middle_name,autobiography,group_id,date_of_birth,address,rating)
 VALUES ("DAR6","SEN","YAR","LOVE EPAM",1, now(),"VV69",99.0),
		("DAR2","SEN","YAR","LOVE EPAM",1, now(),"VV69",51.0),
        ("DAR3","SEN","YAR","LOVE EPAM",1, now(),"VV69",49.0),
        ("DAR4","SEN","YAR","LOVE EPAM",1, now(),"VV69",88.0),
        ("DAR5","SEN","YAR","LOVE EPAM",1, now(),"VV69",87.0)
;
INSERT INTO lecturer VALUES(1,"AA","BB","CC");

INSERT INTO discipline VALUES (1,"OOP",1);

INSERT INTO results_of_disciplines (discipline_id, student_id, module_1, module_2, type_of_control, term) VALUES (1,1,35,45,"exam",1);

SELECT lecturer.first_name, discipline.name, student.first_name from lecturer,discipline,results_of_disciplines, student 
						WHERE lecturer.id = discipline.lecturer_id
						AND discipline.id = results_of_disciplines.discipline_id
                        AND results_of_disciplines.student_id = student.id;






 

