CREATE DATABASE StoredPr_DB
CHARACTER SET utf8 
COLLATE utf8_general_ci;

USE StoredPr_DB; 

CREATE TABLE employee(
    id                 INT               AUTO_INCREMENT,
    surname            VARCHAR(30)       NOT NULL,
    name               CHAR(30)          NOT NULL,
    midle_name         VARCHAR(30),
    identity_number    CHAR(10),
    passport           CHAR(10),
    experience         DECIMAL(10, 1),
    birthday           DATE,
    post               VARCHAR(15)       NOT NULL,
    pharmacy_id        INT,
    PRIMARY KEY (id)
)ENGINE=INNODB;

CREATE TABLE medicine(
    id               INT            AUTO_INCREMENT,
    name             VARCHAR(30)    NOT NULL,
    ministry_code    CHAR(10),
    recipe           BIT(1),
    narcotic         BIT(1),
    psychotropic     BIT(1),
    PRIMARY KEY (id)
)ENGINE=INNODB;

CREATE TABLE medicine_zone(
    medicine_id    INT    NOT NULL,
    zone_id        INT    NOT NULL,
    PRIMARY KEY (medicine_id, zone_id)
)ENGINE=INNODB;

CREATE TABLE pharmacy(
    id                 INT            AUTO_INCREMENT,
    name               VARCHAR(15)    NOT NULL,
    building_number    VARCHAR(10),
    www                VARCHAR(40),
    work_time          TIME,
    saturday           BIT(1),
    sunday             BIT(1),
    street             VARCHAR(25),
    PRIMARY KEY (id)
)ENGINE=INNODB;

CREATE TABLE pharmacy_medicine(
    pharmacy_id    INT    NOT NULL,
    medicine_id    INT    NOT NULL,
    PRIMARY KEY (pharmacy_id, medicine_id)
)ENGINE=INNODB;

CREATE TABLE post(
    post    VARCHAR(15)    NOT NULL,
    PRIMARY KEY (post)
)ENGINE=INNODB;

CREATE TABLE street(
    street    VARCHAR(25)    NOT NULL,
    PRIMARY KEY (street)
)ENGINE=INNODB;

CREATE TABLE zone(
    id      INT            AUTO_INCREMENT,
    name    VARCHAR(25)    NOT NULL,
    PRIMARY KEY (id)
)ENGINE=INNODB;