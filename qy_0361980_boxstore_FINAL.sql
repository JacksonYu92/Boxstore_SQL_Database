/*
 * Name: Qichun Yu
 * Date: 2022-04-22
 * Type: Boxstore
 * Asgn: SQL Final Project
 */


-- DROP/CREATE/USE database BLOCK
DROP DATABASE IF EXISTS qy_0361980_boxstore;
CREATE DATABASE IF NOT EXISTS qy_0361980_boxstore
CHARSET='utf8mb4'
COLLATE='utf8mb4_unicode_ci';

-- connects you into DATABASE 
USE qy_0361980_boxstore;

-- Table: people ----------------------------------------------------
DROP TABLE IF EXISTS people;
CREATE TABLE IF NOT EXISTS people (
	  p_id INT(11) AUTO_INCREMENT -- PK
	, full_name VARCHAR(100) NULL -- UK
	, PRIMARY KEY(p_id)
);

-- verify your table query works
SELECT * FROM people WHERE 1=1;

-- replace Instructor Name and Your Name with 
TRUNCATE TABLE people;
INSERT INTO people (full_name) VALUES ('Brad Vincelette');
INSERT INTO people (full_name) VALUES ('Qichun Yu');

SELECT * FROM people;

-- bulk import 10000 people list
SET GLOBAL local_infile=1;
LOAD DATA LOCAL INFILE 'C:/Users/jacks/OneDrive - Red River College/Documents/RRC/COMP-1701_Transferring_Data_to_Databases/_scripts/qy_0361980_boxstore_people-10000.txt'
INTO TABLE people
LINES TERMINATED BY '\r\n'
(full_name);

SELECT p.p_id, p.full_name
FROM people p;
-- verify number of import
SELECT COUNT(p_id) FROM people;

-- alter people table, add first_name, last_name columns
ALTER TABLE people
	  ADD COLUMN first_name VARCHAR(40) NULL
	, ADD COLUMN last_name  VARCHAR(60) NULL;
	
-- verify
SELECT p.p_id, p.full_name, p.first_name, p.last_name
FROM people p;

-- full_name: removed double with single spacing, trims end spaces
UPDATE people SET full_name = TRIM(REPLACE(full_name,'  ', ' '));

-- UPDATE people with first name & last name
UPDATE people
SET    first_name = TRIM(LEFT(full_name, INSTR(full_name, ' ')-1))
     , last_name = TRIM(SUBSTR(full_name
                          , INSTR(full_name, ' ')+1
                          , LENGTH(full_name) - INSTR(full_name, ' ')
                              ))
WHERE  1=1;

-- verify update
SELECT p.p_id, p.full_name, p.first_name, p.last_name
FROM people p;

-- alter people table, to drop full_name
ALTER TABLE people DROP COLUMN full_name;

-- get all rows, verify drop
SELECT * FROM people;

-- ALTER people table to add more columns
ALTER TABLE people
	  ADD COLUMN suite_num VARCHAR(10)
	, ADD COLUMN addr VARCHAR(75)
	, ADD COLUMN addr_mailcode VARCHAR(15)
	, ADD COLUMN addr_type_id SMALLINT -- FK
	, ADD COLUMN addr_info TEXT
	, ADD COLUMN tc_id INT -- FK
	, ADD COLUMN delivery_info TEXT
	, ADD COLUMN ph_home VARCHAR(25)
	, ADD COLUMN ph_cell VARCHAR(25)
	, ADD COLUMN ph_work VARCHAR(25)
	, ADD COLUMN ph_work_ext VARCHAR(10)
	, ADD COLUMN email VARCHAR(50)
	, ADD COLUMN password VARCHAR(32)
	, ADD COLUMN user_id INT NOT NULL DEFAULT 2
	, ADD COLUMN date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, ADD COLUMN active BIT NOT NULL DEFAULT 1;

SELECT * FROM people;

-- UPDATE infos to people table
UPDATE people
SET suite_num= NULL
  , addr='88 Heros Street'
  , addr_mailcode='R3T 8T8'
  , addr_type_id=1
  , addr_info='This is a house'
  , tc_id=1
  , delivery_info='Drop to the back, plz'
  , ph_home='2048888888'
  , ph_cell='2049999999'
  , ph_work='2047777777'
  , email='my@email.com'
  , password='123456'
WHERE p_id=2;

SELECT * FROM people;

UPDATE people
SET suite_num= NULL
  , addr='888 Hello Street'
  , addr_mailcode='R3T 1B8'
  , addr_type_id=1
  , addr_info='This is a house'
  , tc_id=1
  , delivery_info='Drop to the back, plz'
  , ph_home='2043333333'
  , ph_cell='2042222222'
  , ph_work='2041111111'
  , email='brad@email.com'
  , password='123456'
WHERE p_id=1;
SELECT * FROM people LIMIT 2;

-- verify your TABLE query
SELECT p.p_id, p.first_name, p.last_name, p.suite_num, p.addr, p.addr_mailcode
     , p.addr_type_id, p.addr_info, p.tc_id, p.delivery_info, p.ph_home
     , p.ph_cell, p.ph_work, p.ph_work_ext, p.email, p.password
     , p.user_id, p.date_mod, p.active
FROM people p;


-- Table: people_employee -------------------------------------------
DROP TABLE IF EXISTS people_employee;
CREATE TABLE IF NOT EXISTS people_employee (
	  pe_id INT AUTO_INCREMENT
	, p_id INT NOT NULL -- FK
	, p_id_mgr INT
	, pe_uri VARCHAR(75)
	, pe_employee_id CHAR(10)
	, pe_hired DATETIME
	, pe_salary DECIMAL(7,2)
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(pe_id)
);

TRUNCATE TABLE people_employee;
INSERT INTO people_employee
       (p_id, p_id_mgr, pe_uri, pe_employee_id, pe_hired, pe_salary)
VALUES (1, NULL, 'brad-vincelette', '1111100', '2022-01-31', 96200.00)
     , (2, 1, 'qichun-yu-0361980', '0361980', '2022-01-31', 56200.00);

SELECT pe.pe_id, pe.p_id, pe.p_id_mgr, pe.pe_uri
     , pe.pe_employee_id, pe.pe_hired, pe.pe_salary
	   , pe.user_id, pe.date_mod, pe.active
FROM people_employee pe;


-- Table: geo_address_type ------------------------------------------
DROP TABLE IF EXISTS geo_address_type;
CREATE TABLE IF NOT EXISTS geo_address_type (
	  addr_type_id SMALLINT AUTO_INCREMENT
	, addr_type VARCHAR(15)
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(addr_type_id)
);

TRUNCATE TABLE geo_address_type;
INSERT INTO geo_address_type (addr_type)
VALUES                       ('House'),('Apartment'),('Building'),('Warehouse');
						
SELECT gat.addr_type_id, gat.addr_type, gat.active
FROM geo_address_type gat;


-- Table: geo_country -----------------------------------------------
DROP TABLE IF EXISTS geo_country;
CREATE TABLE IF NOT EXISTS geo_country (
	  co_id MEDIUMINT AUTO_INCREMENT
	, co_name VARCHAR(100)
	, co_abbr CHAR(2)
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(co_id)
);

TRUNCATE TABLE geo_country;
INSERT INTO geo_country (co_name, co_abbr) VALUES ('Canada', 'CA');                     -- 1
INSERT INTO geo_country (co_name, co_abbr) VALUES ('Japan', 'JP');                      -- 2
INSERT INTO geo_country (co_name, co_abbr) VALUES ('South Korea', 'KR');                -- 3
INSERT INTO geo_country (co_name, co_abbr) VALUES ('United States of America', 'US');  

SELECT gc.co_id, gc.co_name, gc.co_abbr, gc.active
FROM geo_country gc;


-- Table: geo_region ------------------------------------------------
DROP TABLE IF EXISTS geo_region;
CREATE TABLE IF NOT EXISTS geo_region (
	  r_id INT AUTO_INCREMENT
	, r_name VARCHAR(75)
	, r_abbr CHAR(2)
	, co_id MEDIUMINT -- FK
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(r_id)
);

TRUNCATE TABLE geo_region;
INSERT INTO geo_region (r_name, r_abbr, co_id) VALUES ('Manitoba', 'MB', 1);            -- 1,1
INSERT INTO geo_region (r_name, r_abbr, co_id) VALUES ('Tokyo', NULL, 2);               -- 2,2
INSERT INTO geo_region (r_name, r_abbr, co_id) VALUES ('Osaka', NULL, 2);               -- 3,2
INSERT INTO geo_region (r_name, r_abbr, co_id) VALUES ('Gyeonggi', NULL, 3);            -- 4,3
INSERT INTO geo_region (r_name, r_abbr, co_id) VALUES ('California', 'CA', 4);          -- 5,4
INSERT INTO geo_region (r_name, r_abbr, co_id) VALUES ('Texas', 'TX', 4);               -- 6,4
INSERT INTO geo_region (r_name, r_abbr, co_id) VALUES ('Washington', 'WA', 4);  

SELECT gr.r_id, gr.r_name, gr.r_abbr, gr.co_id, gr.active
FROM geo_region gr;


-- Table: geo_towncity ----------------------------------------------
DROP TABLE IF EXISTS geo_towncity;
CREATE TABLE IF NOT EXISTS geo_towncity (
	  tc_id INT AUTO_INCREMENT
	, tc_name VARCHAR(50)
	, r_id INT -- FK
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(tc_id)
);

TRUNCATE TABLE geo_towncity;
INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Winnipeg', 1);                        -- 1,1,1
INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Chiyoda', 2);                         -- 2,2,2
INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Minato', 2);                          -- 3,2,2
INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Kadoma', 3);                          -- 4,3,2
INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Suwon', 4);                           -- 5,4,3
INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Seoul', 4);                           -- 6,4,3
INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Lost Altos', 5);                      -- 7,5,4
INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Santa Clara', 5);                     -- 8,5,4
INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Round Rock', 6);                      -- 9,6,4
INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Redmond', 7);

SELECT gtc.tc_id, gtc.tc_name, gtc.r_id, gtc.active
FROM geo_towncity gtc;

-- JOIN:geo_country & geo_region & geo_towncity
SELECT gtc.tc_id, gtc.tc_name, gtc.r_id
     , gr.r_name, gr.co_id
     , gc.co_name
FROM geo_towncity gtc
     JOIN geo_region gr ON gtc.r_id=gr.r_id 
     JOIN geo_country gc ON gr.co_id=gc.co_id;

-- UPDATE people with JOIN to derived query
-- used a z__ prefix, to put the table to the very end of the listing
DROP TABLE IF EXISTS z__street;
CREATE TABLE IF NOT EXISTS z__street(street_name VARCHAR(25));

-- inserting street_name records, regex in notepad++
INSERT INTO z__street VALUES('Second Ave');
INSERT INTO z__street VALUES('Third Ave');
INSERT INTO z__street VALUES('First Ave');
INSERT INTO z__street VALUES('Fourth Ave');
INSERT INTO z__street VALUES('Park Blvd');
INSERT INTO z__street VALUES('Fifth Ave');
INSERT INTO z__street VALUES('Main Blvd');
INSERT INTO z__street VALUES('Sixth Ave');
INSERT INTO z__street VALUES('Oak Blvd');
INSERT INTO z__street VALUES('Seventh Ave');
INSERT INTO z__street VALUES('Pine St');
INSERT INTO z__street VALUES('Maple St');
INSERT INTO z__street VALUES('Cedar Blvd');
INSERT INTO z__street VALUES('Eighth Ave');
INSERT INTO z__street VALUES('Elk Blvd');
INSERT INTO z__street VALUES('View Blvd');
INSERT INTO z__street VALUES('Washington Blvd');
INSERT INTO z__street VALUES('Ninth Ave');
INSERT INTO z__street VALUES('Lake St');
INSERT INTO z__street VALUES('Hill Blvd');

SELECT * FROM z__street;

-- massive update of people table (remove first_name, last_name from SELECT and GROUP BY)

UPDATE people p
       JOIN (
       
  SELECT p.p_id
       , MIN(
             CONCAT(
                 CASE WHEN RAND() < 0.25 THEN CONVERT(RAND()*100,INT)
                      WHEN RAND() < 0.50 THEN CONVERT(RAND()*1000,INT)
                      WHEN RAND() < 0.75 THEN CONVERT(RAND()*10000,INT)
                                         ELSE CONVERT(RAND()*10,INT) END+10
                 ,' ',zs.street_name
             )
       ) AS addr
       , 'ROH HOH' AS addr_mailcode
       , CASE WHEN RAND() < 0.50 THEN 1 ELSE 2 END AS addr_type_id
       , CONCAT('204-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS ph_home
       , CONCAT('204-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS ph_cell
       , CONCAT('204-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS ph_work
       , LEFT(CONVERT(RAND()*10000000,INT),4) AS ph_work_ext
       , CONCAT(LOWER(LEFT(p.first_name,1)),LOWER(p.last_name),'@'
           , CASE WHEN RAND() < 0.25 THEN 'google.com'
                  WHEN RAND() < 0.50 THEN 'outlook.com'
                  WHEN RAND() < 0.75 THEN 'live.com'
                                     ELSE 'rocketmail.com' END) AS email
       , MD5(RAND()) AS password
       , NOW() AS date_mod
FROM people p, z__street zs
GROUP BY p.p_id     
       
       ) dt ON p.p_id = dt.p_id
SET p.addr = dt.addr
  , p.addr_mailcode = dt.addr_mailcode
  , p.addr_type_id = dt.addr_type_id
  , p.tc_id = 1
  , p.ph_home = dt.ph_home
  , p.ph_cell = dt.ph_cell
  , p.ph_work = dt.ph_work
  , p.ph_work_ext = dt.ph_work_ext
  , p.email = dt.email
  , p.password = dt.password
  , p.date_mod = dt.date_mod;

-- verify your TABLE query works
SELECT p.p_id, p.first_name, p.last_name
     , p.suite_num, p.addr, p.addr_mailcode, p.addr_type_id, p.addr_info, p.tc_id
     , p.ph_home, p.ph_cell, p.ph_work, p.ph_work_ext, p.email, p.password
     , p.user_id, p.date_mod, p.active
FROM people p;

-- turf the z__street table
DROP TABLE IF EXISTS z__street;

-- JOIN: people & geo_address_type & geo_country & geo_region & geo_towncity
SELECT p.p_id, p.first_name, p.last_name
     , p.suite_num, p.addr, p.addr_mailcode, p.addr_type_id, p.tc_id
     , p.ph_home, p.ph_cell, p.ph_work, p.ph_work_ext, p.email, p.password
     , gat.addr_type
     , gtc.tc_name, gtc.r_id
     , gr.r_name, gr.co_id
     , gc.co_name 
FROM people p
     JOIN geo_address_type gat ON p.addr_type_id = gat.addr_type_id
     JOIN geo_towncity gtc     ON p.tc_id = gtc.tc_id
     JOIN geo_region gr        ON gtc.r_id = gr.r_id
     JOIN geo_country gc       ON gr.co_id = gc.co_id;

-- Table: category --------------------------------------------------
DROP TABLE IF EXISTS category;
CREATE TABLE IF NOT EXISTS category (
	  cat_id MEDIUMINT AUTO_INCREMENT
	, cat_name VARCHAR(60)
	, cat_id_parent MEDIUMINT -- FK
	, cat_uri VARCHAR(60)
	, cat_abbr VARCHAR(10)
	, hashtag VARCHAR(50)
	, taxonomy VARCHAR(15)
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(cat_id)
);

TRUNCATE TABLE category;
-- departments > people ---------------------------------------------
INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy) -- 1
VALUES               ('Staff', NULL, 'staff', NULL, 'departments');

INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy) -- 2
VALUES               ('Sales', 1, 'sales', NULL, 'departments');

INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy) -- 3
VALUES               ('Warehouse', 1, 'warehouse', NULL, 'departments');

-- general > item ---------------------------------------------------
INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy) -- 4,5,6,7
VALUES  ('Televisions', NULL,'televisions', 'TV', 'general')
      , ('Portable Electronics', NULL,'portable-electronics', 'PE', 'general')
      , ('Kitchen Appliances', NULL,'kitchen-appliances', 'KA', 'general')
      , ('Large Appliances', NULL,'large-appliances', 'LA', 'general');

-- item subcategories
INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy) -- 8 thru 16
VALUES   ('70" & Up',4,'70-up',NULL,'general')
       , ('60" - 69"',4,'60-69',NULL,'general')
       , ('55" & Down',4,'55-down',NULL,'general')
       , ('Smartphones',5,'smartphones',NULL,'general')
       , ('Tablets',5,'tablets',NULL,'general')
       , ('Blender',6,'blender',NULL,'general')
       , ('Coffee & Tea',6,'coffee-tea',NULL,'general') -- 14
       , ('Washer',7,'washer',NULL,'general')
       , ('Dryer',7,'dryer',NULL,'general');

SELECT c.cat_id, c.cat_name, c.cat_id_parent, c.cat_uri, c.cat_abbr, c.taxonomy
     , c.user_id, c.date_mod, c.active
FROM category c;

-- SELF JOIN: category parent to child
SELECT CONCAT('/categories/',IFNULL(CONCAT(c0.cat_uri,'/'),''),IFNULL(CONCAT(c1.cat_uri,'/'),'')) AS cat_uri_full
      , c0.cat_name, c1.cat_name
FROM category c1
     JOIN category c0 ON c1.cat_id_parent = c0.cat_id
WHERE c0.taxonomy = 'general';


-- Table: people_category -------------------------------------------
DROP TABLE IF EXISTS people_category;
CREATE TABLE IF NOT EXISTS people_category (
	  pc_id INT AUTO_INCREMENT
	, p_id INT -- FK
	, cat_id MEDIUMINT -- FK
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(pc_id)
);

TRUNCATE TABLE people_category;
INSERT INTO people_category(p_id, cat_id)
VALUES                     (1, 2), (2, 3);

SELECT pc.pc_id, pc.p_id, pc.cat_id, pc.user_id, pc.date_mod, pc.active
FROM people_category pc;


-- Table: manufacturer ----------------------------------------------
DROP TABLE IF EXISTS manufacturer;
CREATE TABLE IF NOT EXISTS manufacturer (
	  m_id MEDIUMINT AUTO_INCREMENT
	, man_name VARCHAR(75)
	, addr VARCHAR(75)
	, addr_mailcode VARCHAR(15)
	, addr_type_id SMALLINT
	, addr_info TEXT
	, tc_id INT -- FK
	, ph_main VARCHAR(25)
	, ph_sales VARCHAR(25)
	, ph_sales_ext VARCHAR(10)
	, ph_inv VARCHAR(25)
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(m_id)
);

TRUNCATE TABLE manufacturer;
INSERT INTO manufacturer (man_name
                        , addr, addr_mailcode
                        , addr_type_id, addr_info, tc_id
                        , ph_main, ph_sales, ph_sales_ext, ph_inv)
VALUES                   ('Mysql Inc.'
                        , '520 Mysql Street', 'R3T 2N1'
                        , 1, 'This is a building', 1
                        , '2045656666', '2048988888', '021', '2047577777');
-- Bulk insert 9 records
INSERT INTO manufacturer (m_id, man_name, addr, addr_mailcode, addr_type_id, addr_info, tc_id)
VALUES (2 ,'Apple Inc.'         ,'260-17 First St','PO Box: 26017',3,NULL,7)
      ,(3 ,'Samsung Electronics','221-6 Second St','PO Box: 24355',3,NULL,5)
      ,(4 ,'Dell Technologies'  ,'90-62 Third St' ,'PO Box: 26017',3,NULL,9)
      ,(5 ,'Hitachi'            ,'88-42 Fourth St','PO Box: 26017',3,NULL,2)
      ,(6 ,'Sony'               ,'80-92 Fifth St' ,'PO Box: 26017',3,NULL,3)
      ,(7 ,'Panasonic'          ,'74-73 Sixth St' ,'PO Box: 26017',3,NULL,4)
      ,(8 ,'Intel'              ,'71-9 Seventh St','PO Box: 26017',3,NULL,8)
      ,(9 ,'LG Electronics'     ,'54-39 Eighth St','PO Box: 26017',3,NULL,6)
      ,(10,'Microsoft'          ,'100-10 Ninth St','PO Box: 26017',3,NULL,10);

SELECT m.m_id, m.man_name, m.addr, m.addr_mailcode, m.addr_type_id, m.addr_info, m.tc_id
FROM manufacturer m;
    
-- adjust the phone_numbers  
UPDATE manufacturer m0 JOIN (
  SELECT m_id
       , CONCAT('800-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS ph_main
       , CONCAT('855-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS ph_sales
       , LEFT(CONVERT(RAND()*10000000,INT),4) AS ph_sales_ext
       , CONCAT('888-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS ph_inv
  FROM manufacturer m
) m1 ON m0.m_id=m1.m_id
SET m0.ph_main=m1.ph_main
  , m0.ph_sales=m1.ph_sales
  , m0.ph_sales_ext=m1.ph_sales_ext
  , m0.ph_inv=m1.ph_inv;

SELECT m.m_id, m.man_name, m.addr, m.addr_mailcode, m.addr_type_id, m.addr_info
     , m.tc_id, m.ph_main, m.ph_sales, m.ph_sales_ext, m.ph_inv
     , m.user_id, m.date_mod, m.active
FROM manufacturer m;

-- manufacturer to geo info
SELECT m.m_id, m.man_name, m.addr, m.addr_mailcode, m.addr_info
     , gat.addr_type, gtc.tc_name, gr.r_name, gr.r_abbr
FROM manufacturer m
     JOIN geo_address_type gat ON m.addr_type_id = gat.addr_type_id
     JOIN geo_towncity gtc     ON m.tc_id = gtc.tc_id
     JOIN geo_region gr        ON gtc.r_id = gr.r_id
     JOIN geo_country gc       ON gr.co_id = gc.co_id;

/*Table structure for table `z__orders_items_csv` */

DROP TABLE IF EXISTS `z__orders_items_csv`;

CREATE TABLE `z__orders_items_csv` (
  `m_id` INT(11) DEFAULT NULL,
  `order_num` INT(11) DEFAULT NULL,
  `order_date` DATE DEFAULT NULL,
  `item_type` VARCHAR(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_modelno` VARCHAR(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_barcode` INT(11) DEFAULT NULL,
  `cat_name` VARCHAR(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cat_id` INT(11) DEFAULT NULL,
  `item_name_new` VARCHAR(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_qty` INT(11) DEFAULT NULL,
  `item_price` DECIMAL(7,2) DEFAULT NULL,
  `extra` VARCHAR(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `z__orders_items_csv` */

INSERT  INTO `z__orders_items_csv`(`m_id`,`order_num`,`order_date`,`item_type`,`item_modelno`,`item_barcode`,`cat_name`,`cat_id`,`item_name_new`,`order_qty`,`item_price`,`extra`) VALUES 
(6,1160,'2021-05-18','product','6PRI0299999203',99999203,'55\" & Down',10,'50\" HDTV',3,2100.00,'6PRI02'),
(10,1026,'2021-01-13','product','2BRE1100066001',66001,'55\" & Down',10,'50\" HDTV',2,2100.00,'2BRE11'),
(10,1057,'2021-01-18','product','2BRE1000056014',56014,'55\" & Down',10,'50\" HDTV',2,2605.00,'2BRE10'),
(4,1091,'2021-02-17','product','3FPT0100051287',51287,'60\" - 69\"',9,'65\" HDTV',4,6065.33,'3FPT01'),
(4,1091,'2021-02-17','product','3FPT0100051281',51281,'60\" - 69\"',9,'65\" HDTV',1,6665.33,'3FPT01'),
(4,1091,'2021-02-17','product','3FPT0100051286',51286,'60\" - 69\"',9,'65\" HDTV',1,6665.33,'3FPT01'),
(5,1060,'2021-01-18','product','6LID0100051166',51166,'60\" - 69\"',9,'65\" HDTV',2,5502.67,'6LID01'),
(9,1174,'2021-05-19','product','2SUR1100056001',56001,'60\" - 69\"',9,'65\" HDTV',3,5000.00,'2SUR11'),
(6,1160,'2021-05-18','product','6PRI0299999197',99999197,'70\" & Up',8,'75\" HDTV',2,20013.33,'6PRI02'),
(6,1160,'2021-05-18','product','6PRI0299999198',99999198,'70\" & Up',8,'75\" HDTV',2,20013.33,'6PRI02'),
(4,1044,'2021-01-18','product','3SKY0111164009',11164009,'Blender',13,'20 ounce Blender',3,69.53,'3SKY01'),
(4,1044,'2021-01-18','product','3SKY0142542001',42542001,'Blender',13,'20 ounce Blender',3,89.41,'3SKY01'),
(5,1021,'2021-01-13','product','4MAR0120815001',20815001,'Blender',13,'20 ounce Blender',3,54.35,'4MAR01'),
(6,1254,'2022-01-28','product','4SOD0100001009',1009,'Blender',13,'20 ounce Blender',5,89.00,'4SOD01'),
(8,1040,'2021-01-18','product','2SUR1108413009',8413009,'Blender',13,'20 ounce Blender',3,50.75,'2SUR11'),
(1,1003,'2021-01-13','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',2,100.00,'1GQD02'),
(1,1180,'2021-05-20','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',1,100.00,'1GQD02'),
(1,1239,'2021-01-13','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',1,100.00,'1GQD02'),
(1,1030,'2021-01-13','product','1GQD0200001012',1012,'Coffee & Tea',14,'Barista Express',1,133.17,'1GQD02'),
(2,1173,'2021-05-18','product','7BOC0244563001',44563001,'Coffee & Tea',14,'Barista Express',4,199.80,'7BOC02'),
(3,1151,'2021-04-28','product','3BRI0300001012',1012,'Coffee & Tea',14,'Barista Express',3,133.17,'3BRI03'),
(5,1195,'2021-05-24','product','4HEL0141994001',41994001,'Coffee & Tea',14,'Barista Express',3,124.38,'4HEL01'),
(5,1054,'2021-01-18','product','4HEL0140182001',40182001,'Coffee & Tea',14,'Barista Express',3,172.63,'4HEL01'),
(7,1031,'2021-01-14','product','7SPP0105618009',5618009,'Coffee & Tea',14,'Barista Express',4,199.80,'7SPP01'),
(8,1040,'2021-01-18','product','2SUR1103820009',3820009,'Coffee & Tea',14,'Barista Express',1,104.50,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115323121',15323121,'Coffee & Tea',14,'Barista Express',1,144.18,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115384001',15384001,'Coffee & Tea',14,'Barista Express',3,152.74,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115199001',15199001,'Coffee & Tea',14,'Barista Express',3,174.05,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1104929009',4929009,'Coffee & Tea',14,'Barista Express',2,184.80,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1108718009',8718009,'Coffee & Tea',14,'Barista Express',3,189.61,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1108255009',8255009,'Coffee & Tea',14,'Barista Express',3,196.60,'2SUR11'),
(5,1049,'2021-01-18','product','7HAN0200008359',8359,'Dryer',16,'Dryer',1,710.00,'7HAN02'),
(5,1117,'2021-03-04','product','7HYU0200008359',8359,'Dryer',16,'Dryer',1,710.00,'7HYU02'),
(5,1119,'2021-03-04','product','7SMS0100008359',8359,'Dryer',16,'Dryer',1,710.00,'7SMS01'),
(5,1228,'2021-01-15','product','7SPP0100008359',8359,'Dryer',16,'Dryer',1,710.00,'7SPP01'),
(7,1229,'2021-02-23','product','7SPP0100041409',41409,'Dryer',16,'Dryer',4,716.67,'7SPP01'),
(10,1225,'2020-01-28','product','2BRE1500012590',12590,'Dryer',16,'Dryer',2,666.67,'2BRE15'),
(10,1225,'2020-01-28','product','2BRE1400012576',12576,'Dryer',16,'Dryer',2,783.33,'2BRE14'),
(1,1120,'2021-03-04','product','1GQD0240880001',40880001,'Smartphones',11,'Actually a Flipper',5,238.06,'1GQD02'),
(2,1173,'2021-05-18','product','7BOC0200002293',2293,'Smartphones',11,'Actually a Flipper',3,207.79,'7BOC02'),
(2,1168,'2021-05-18','product','4DAI0200002260',2260,'Smartphones',11,'Actually a Flipper',3,264.74,'4DAI02'),
(3,1137,'2021-04-06','product','3BRI0400002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'3BRI04'),
(3,1046,'2021-01-18','product','7DAE0400012490',12490,'Smartphones',11,'Really Smartphone',4,1250.00,'7DAE04'),
(4,1048,'2021-01-18','product','3TEC0350864001',50864001,'Smartphones',11,'Really Smartphone',1,1090.91,'3TEC03'),
(5,1054,'2021-01-18','product','4HEL0140184001',40184001,'Smartphones',11,'Actually a Flipper',5,226.07,'4HEL01'),
(5,1049,'2021-01-18','product','7HAN0200013563',13563,'Smartphones',11,'Really Smartphone',2,1170.00,'7HAN02'),
(6,1254,'2022-01-28','product','4SOD0100001011',1011,'Smartphones',11,'Actually a Flipper',2,299.70,'4SOD01'),
(6,1160,'2021-05-18','product','6PRI0299999177',99999177,'Smartphones',11,'Not-as Smartphone',3,332.97,'6PRI02'),
(6,1160,'2021-05-18','product','6PRI0299999178',99999178,'Smartphones',11,'Really Smartphone',2,1333.33,'6PRI02'),
(7,1031,'2021-01-14','product','7SPP0120983041',20983041,'Smartphones',11,'Not-as Smartphone',4,332.97,'7SPP01'),
(7,1031,'2021-01-14','product','7SPP0120983081',20983081,'Smartphones',11,'Not-as Smartphone',1,332.97,'7SPP01'),
(8,1040,'2021-01-18','product','2SUR1106484009',6484009,'Smartphones',11,'Not-as Smartphone',3,321.23,'2SUR11'),
(8,1201,'2021-05-24','product','2SUR1199999114',99999114,'Smartphones',11,'Not-as Smartphone',1,363.64,'2SUR11'),
(8,1043,'2021-01-18','product','2SUR1101100321',1100321,'Smartphones',11,'Really Smartphone',3,1272.00,'2SUR11'),
(8,1178,'2021-05-20','product','2SUR1101100321',1100321,'Smartphones',11,'Really Smartphone',4,1272.00,'2SUR11'),
(9,1114,'2021-03-08','product','2SUR1100002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'2SUR11'),
(9,1042,'2021-01-18','product','2SUR1151463001',51463001,'Smartphones',11,'Really Smartphone',1,1040.00,'2SUR11'),
(9,1111,'2021-02-26','product','2SUR1100041398',41398,'Smartphones',11,'Really Smartphone',5,1200.00,'2SUR11'),
(10,1089,'2021-02-24','product','2BRE1200002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'2BRE12'),
(10,1242,'2021-06-09','product','2BRE1600013212',13212,'Smartphones',11,'Really Smartphone',3,1000.00,'2BRE16'),
(10,1033,'2021-01-14','product','2BRE0100008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE01'),
(10,1036,'2021-01-18','product','2BRE0200008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE02'),
(10,1225,'2020-01-28','product','2BRE1300008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE13'),
(10,1058,'2021-01-18','product','2BRE0600013628',13628,'Smartphones',11,'Really Smartphone',3,1350.00,'2BRE06'),
(10,1157,'2021-05-17','product','2BRE0700013628',13628,'Smartphones',11,'Really Smartphone',5,1350.00,'2BRE07'),
(10,1177,'2021-05-20','product','2BRE0900013628',13628,'Smartphones',11,'Really Smartphone',3,1350.00,'2BRE09'),
(1,1046,'2021-01-18','product','1GQD0200008335',8335,'Tablets',12,'Super Tablet',4,1435.00,'1GQD02'),
(1,1090,'2021-02-24','product','3ADA0100008360',8360,'Tablets',12,'Super Tablet',4,2000.00,'3ADA01'),
(2,1170,'2021-05-18','product','4DAI0200002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'4DAI02'),
(2,1211,'2021-05-26','product','4DAI0200002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'4DAI02'),
(2,1171,'2021-05-18','product','4DAI0200002123',2123,'Tablets',12,'Mini Tablet',3,424.58,'4DAI02'),
(3,1169,'2021-05-18','product','3BRI0400002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'3BRI04'),
(3,1111,'2021-02-26','product','7DAE0400008335',8335,'Tablets',12,'Super Tablet',1,1435.00,'7DAE04'),
(4,1105,'2021-02-26','product','3OCE0108211010',8211010,'Tablets',12,'Mini Tablet',3,499.50,'3OCE01'),
(4,1182,'2021-05-20','product','7UNI0400008355',8355,'Tablets',12,'Super Tablet',5,1435.00,'7UNI04'),
(5,1054,'2021-01-18','product','4HEL0105850009',5850009,'Tablets',12,'Mini Tablet',2,448.25,'4HEL01'),
(5,1031,'2021-01-14','product','7HYU0200041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7HYU02'),
(6,1052,'2021-01-18','product','7SAK0100008355',8355,'Tablets',12,'Super Tablet',3,1435.00,'7SAK01'),
(6,1117,'2021-03-04','product','7SMS0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SMS01'),
(7,1119,'2021-03-04','product','7SPP0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SPP01'),
(7,1228,'2021-01-15','product','7SPP0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SPP01'),
(8,1150,'2021-04-27','product','2SUR1100008294',8294,'Tablets',12,'Super Tablet',3,1414.11,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002137',2137,'Tablets',12,'Mini Tablet',3,394.61,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002137',2137,'Tablets',12,'Mini Tablet',3,394.61,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002143',2143,'Tablets',12,'Mini Tablet',3,419.58,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002143',2143,'Tablets',12,'Mini Tablet',3,419.58,'2SUR11'),
(9,1064,'2021-01-19','product','2SUR1100008335',8335,'Tablets',12,'Super Tablet',5,1435.00,'2SUR11'),
(9,1056,'2021-01-18','product','2SUR1100011577',11577,'Tablets',12,'Super Tablet',1,1842.00,'2SUR11'),
(10,1056,'2021-01-18','product','2SUR1100041491',41491,'Tablets',12,'Super Tablet',1,1991.00,'2SUR11'),
(1,1090,'2021-02-24','product','3ADA0100004335',4335,'Washer',15,'Washer',5,500.00,'3ADA01'),
(3,1034,'2021-01-14','product','3BRI3505804084',5804084,'Washer',15,'Washer',3,504.69,'3BRI35'),
(3,1051,'2021-01-18','product','3DAE0106096009',6096009,'Washer',15,'Washer',3,553.95,'3DAE01');


SELECT * FROM `z__orders_items_csv`;


-- Table: item ------------------------------------------------------
DROP TABLE IF EXISTS item;
CREATE TABLE IF NOT EXISTS item (
	  i_id BIGINT AUTO_INCREMENT
	, item_type VARCHAR(20)
	, item_name VARCHAR(75) NOT NULL
	, item_modelno VARCHAR(25) NOT NULL
	, item_barcode VARCHAR(20)
	, item_uri VARCHAR(75)
	, item_size DECIMAL(9,4)
	, item_uom VARCHAR(25)
	, item_price DECIMAL(9,2)
	, image_uri VARCHAR(75)
	, item_status VARCHAR(25)
	, m_id MEDIUMINT -- FK
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(i_id)
);

TRUNCATE TABLE item;
INSERT INTO item (item_type, item_name, item_modelno, item_barcode
                , item_uri, item_size, item_uom, item_price
                , image_uri, item_status, m_id)
VALUES           ('Product','Barista Express', 'BES800', '34568'
                , 'barista-express-bes800', 51, 'Medium', 6.65
                , '/images/barista-express-bes800.png', 'available', 1);
-- Bulk item INSERT -------------------------------------------------
-- DELETE FROM item WHERE i_id>1;
INSERT INTO item  (item_type, item_name, item_modelno, item_barcode
                  , item_uri, item_size, item_uom, item_price
                  , image_uri, item_status, m_id)
SELECT item_type, CONCAT(m.man_name,' - ',item_name_new), item_modelno, item_barcode
       , NULL, 1, 'Unit', item_price
       , NULL, 'Available', z.m_id
FROM z__orders_items_csv z JOIN manufacturer m ON z.m_id=m.m_id
GROUP BY item_type, CONCAT(m.man_name,' - ',item_name_new), item_modelno, item_barcode, item_price, m_id;

-- verify insert
SELECT i.i_id, i.item_type, i.item_name, i.item_modelno, i.item_barcode
     , i.item_uri, i.item_size, i.item_uom, i.item_price
  	 , i.image_uri, i.item_status, i.m_id, i.user_id, i.date_mod, i.active
FROM item i;


-- Table: item_detail -----------------------------------------------
DROP TABLE IF EXISTS item_detail;
CREATE TABLE IF NOT EXISTS item_detail (
    id_id BIGINT AUTO_INCREMENT
  , i_id BIGINT -- FK
  , id_label VARCHAR(50)
  , id_detail VARCHAR(50)
  , user_id INT NOT NULL DEFAULT 2
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(id_id)
);

TRUNCATE TABLE item_detail;
INSERT INTO item_detail (i_id, id_label, id_detail)
VALUES                  (1, 'Height', '30cm')
                      , (1, 'Width', '20cm');

SELECT id.id_id, id.i_id, id.id_label, id.id_detail, id.user_id, id.date_mod, id.active
FROM item_detail id;


-- Table: item_meta -------------------------------------------------
DROP TABLE IF EXISTS item_meta;
CREATE TABLE IF NOT EXISTS item_meta (
    im_id BIGINT AUTO_INCREMENT
  , i_id BIGINT -- FK
  , im_desc TEXT
  , user_id INT NOT NULL DEFAULT 2
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(im_id)
);

TRUNCATE TABLE item_meta;
INSERT INTO item_meta (i_id, im_desc)
VALUES                (1, 'Crema Coffeemaker with absolute Heat Intelligence');

SELECT im.im_id, im.i_id, im.im_desc, im.user_id, im.date_mod, im.active
FROM item_meta im;


-- Table: item_price ------------------------------------------------
DROP TABLE IF EXISTS item_price;
CREATE TABLE IF NOT EXISTS item_price (
	  ip_id BIGINT AUTO_INCREMENT
	, ip_beg DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, ip_end DATETIME
	, i_id BIGINT -- FK
	, ip_price DECIMAL(9,2)
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(ip_id)
);

TRUNCATE TABLE item_price;
INSERT INTO item_price (ip_beg, ip_end, i_id, ip_price)
VALUES                 ('2022-01-05 10:22:45', NULL, 1, 22.90);

INSERT INTO item_price (ip_beg, ip_end, i_id, ip_price)
SELECT                  '2022-01-05 00:00:00', NULL, i.i_id, i.item_price
FROM item i
     LEFT JOIN item_price ip ON i.i_id = ip.i_id
WHERE ip.ip_id IS NULL;

SELECT ip.ip_id, ip.ip_beg, ip.ip_end, ip.i_id, ip.ip_price
     , ip.user_id, ip.date_mod, ip.active
FROM item_price ip;


-- Table: item_category ---------------------------------------------
DROP TABLE IF EXISTS item_category;
CREATE TABLE IF NOT EXISTS item_category (
	  ic_id BIGINT AUTO_INCREMENT
	, i_id BIGINT -- FK
	, cat_id MEDIUMINT -- FK
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(ic_id)
);

TRUNCATE TABLE item_category;
INSERT INTO item_category (i_id, cat_id)
VALUES                    (1, 14);
-- item_category INSERT ---------------------------------------------
-- DELETE FROM item_category WHERE i_id>1;
INSERT INTO item_category (i_id, cat_id)
SELECT i.i_id, z.cat_id
FROM z__orders_items_csv z 
    JOIN manufacturer m ON z.m_id=m.m_id
  JOIN item i ON i.item_modelno=z.item_modelno
GROUP BY i.i_id, z.cat_id;

SELECT ic.ic_id, ic.i_id, ic.cat_id, ic.user_id, ic.date_mod, ic.active
FROM item_category ic;


-- Table: tax -------------------------------------------------------
DROP TABLE IF EXISTS tax;
CREATE TABLE IF NOT EXISTS tax (
	  tax_id SMALLINT AUTO_INCREMENT
	, tax_type CHAR(3)
	, tax_beg DATE
	, tax_end DATE
	, tax_perc DECIMAL(4,2)
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(tax_id)
);

TRUNCATE TABLE tax;
INSERT INTO tax(tax_type, tax_beg, tax_end, tax_perc)
VALUES         ('GST', '2017-02-16', NULL, 5.00)
             , ('PST', '2016-02-16', NULL, 7.00);

SELECT t.tax_id, t.tax_type, t.tax_beg, t.tax_end, t.tax_perc
     , t.user_id, t.date_mod, t.active
FROM tax t;


-- Table: orders ----------------------------------------------------
DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders (
	  o_id BIGINT AUTO_INCREMENT
	, order_num INT
	, order_date DATETIME NOT NULL
	, order_notes TEXT
	, order_credit DECIMAL(7,2)
	, order_cr_uom CHAR(1)
	, p_id INT -- FK
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(o_id)
);

TRUNCATE TABLE orders;
INSERT INTO orders (order_num, order_date, order_notes
                  , order_credit, order_cr_uom, p_id)
VALUES             (1, '2022-01-14 11:11:11', 'This is a new order.'
                  , 25.01, '$', 1);
-- Bulk orders INSERT -----------------------------------------------
-- DELETE FROM orders WHERE o_id>1;
INSERT INTO orders  (o_id, order_num, order_date, order_notes
                    , order_credit, order_cr_uom, p_id)
SELECT (l.order_num_interv*numlist.p_id)+z.order_num AS o_id
     , (l.order_num_interv*numlist.p_id)+z.order_num AS order_num
     , DATE_ADD(z.order_date, INTERVAL ((-numlist.p_id)/2)+1 DAY) AS order_date_new
     , NULL
     , 0, '$'
   , CONVERT(FLOOR(1 + RAND() * (l.p_id_lmt - 1 + 1)),INT) AS p_id_rnd
FROM z__orders_items_csv z
  JOIN manufacturer m ON z.m_id=m.m_id
  JOIN item i ON i.item_modelno=z.item_modelno
  JOIN (
    SELECT 10002 AS p_id_lmt
       , 10000 AS order_num_interv
       , -100 AS od_val 
  ) l
  , (SELECT p_id-1 AS p_id FROM people ORDER BY p_id) numlist
GROUP BY (l.order_num_interv*numlist.p_id)+z.order_num
  , DATE_ADD(z.order_date, INTERVAL ((-numlist.p_id)/2)+1 DAY), l.p_id_lmt, l.order_num_interv, l.od_val;

SELECT o.o_id, o.order_num, o.order_date, o.order_notes, o.order_credit
     , o.order_cr_uom, o.p_id, o.user_id, o.date_mod, o.active
FROM orders o;


-- Table: orders_item -----------------------------------------------
DROP TABLE IF EXISTS orders_item;
CREATE TABLE IF NOT EXISTS orders_item (
	  oi_id BIGINT AUTO_INCREMENT
	, o_id BIGINT -- FK
	, i_id BIGINT -- FK
	, oi_return_date DATETIME
	, oi_status VARCHAR(25)
	, oi_qty SMALLINT
	, oi_override DECIMAL(9,2)
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(oi_id)
);

TRUNCATE TABLE orders_item;
INSERT INTO orders_item (o_id, i_id, oi_return_date, oi_status
                       , oi_qty, oi_override)
VALUES                  (1, 1, '2022-02-01 05:05:45', 'replacements'
                       , 35, 22.90);
-- orders_item INSERT -----------------------------------------------
-- DELETE FROM orders_item WHERE o_id>1;
INSERT INTO orders_item  (o_id, i_id, oi_return_date, oi_status
                         , oi_qty, oi_override)
SELECT o.o_id, i.i_id, NULL, 'Sold', z.order_qty, 0
FROM z__orders_items_csv z 
     JOIN manufacturer m ON z.m_id=m.m_id
     JOIN item i ON i.item_modelno=z.item_modelno
     JOIN orders o ON RIGHT(o.o_id,4)=z.order_num
GROUP BY o.o_id, i.i_id, z.order_qty;

SELECT oi.oi_id, oi.o_id, oi.i_id, oi.oi_return_date, oi.oi_status, oi.oi_qty, oi.oi_override
     , oi.user_id, oi.date_mod, oi.active
FROM orders_item oi;

-- DROP z__orders_items_csv

DROP TABLE z__orders_items_csv;

-- Table: transactions ----------------------------------------------
DROP TABLE IF EXISTS transactions;
CREATE TABLE IF NOT EXISTS transactions (
    t_id BIGINT AUTO_INCREMENT
  , t_num CHAR(20)
  , t_date DATETIME
  , t_mid CHAR(15)
  , t_acct BIGINT
  , t_type CHAR(2)
  , t_amount DECIMAL(9,2)
  , user_id INT NOT NULL DEFAULT 2
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(t_id)
);

TRUNCATE TABLE transactions;
INSERT INTO transactions (t_num, t_date, t_mid
                        , t_acct, t_type, t_amount)
VALUES                   ('T27116723', '2022-02-22 09:45:45', 'Visa'
                        , 12345678986756, 'CR', 260.68);

SELECT tx.t_id, tx.t_num, tx.t_date, tx.t_mid, tx.t_acct, tx.t_type, tx.t_amount
     , tx.user_id, tx.date_mod, tx.active
FROM transactions tx;

SELECT tx.t_id, tx.t_num, tx.t_date, tx.t_mid, tx.t_acct, tx.t_type, tx.t_amount
     , tx.user_id, tx.date_mod, tx.active
FROM transactions tx;

-- Table: orders_transactions ---------------------------------------
DROP TABLE IF EXISTS orders_transactions;
CREATE TABLE IF NOT EXISTS orders_transactions (
	  ot_id BIGINT AUTO_INCREMENT
	, o_id BIGINT -- FK
	, t_id BIGINT -- FK
	, p_id INT -- FK
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(ot_id)
);

TRUNCATE TABLE orders_transactions;
INSERT INTO orders_transactions (o_id, t_id, p_id)
VALUES                          (1, 1, 1);

SELECT otx.ot_id, otx.o_id, otx.t_id, otx.p_id, otx.user_id, otx.date_mod, otx.active
FROM orders_transactions otx;

-- building the insert to transactions
SELECT -- o.o_id, o.p_id, o.order_num, 
        CONVERT(FLOOR(1 + RAND() * (100000000000 - 1 + 1)),INT)             AS t_num
      , o.order_date                                                        AS t_date
      , 'Visa'                                                              AS t_mid
      , CONCAT('2',CONVERT(FLOOR(1 + RAND() * (100000000000 - 1 + 1)),INT)) AS t_acct
      , 'CR'                                                                AS t_type
      , ROUND(    SUM(oi.oi_qty*i.item_price)*t.tax_calc    ,2)             AS t_amount_sum
      , o.o_id                                                              AS user_id
      , tx.t_amount
FROM orders o
     LEFT JOIN orders_transactions otx ON o.o_id = otx.o_id
     LEFT JOIN transactions tx         ON tx.t_id = otx.t_id
     JOIN orders_item oi               ON o.o_id = oi.o_id
     JOIN item i                       ON i.i_id = oi.i_id
     , (
         SELECT (SUM(tax_perc)/100)+1 AS tax_calc
         FROM tax t
         WHERE t.tax_end IS NULL AND tax_beg <= NOW()
     ) t
WHERE tx.t_id IS NULL
GROUP BY o.o_id, o.order_date, t.tax_calc -- , o.p_id, o.order_num, tx.t_amount
ORDER BY t_amount_sum DESC, o.o_id
-- LIMIT 0,1
;

-- 580116 rows inserted ---------------------------------------------
INSERT INTO transactions (t_num, t_date, t_mid, t_acct, t_type, t_amount, user_id)
SELECT CONVERT(FLOOR(1 + RAND() * (100000000000 - 1 + 1)),INT)             AS t_num
     , o.order_date                                                        AS t_date
     , 'Visa'                                                              AS t_mid
     , CONCAT('2',CONVERT(FLOOR(1 + RAND() * (100000000000 - 1 + 1)),INT)) AS t_acct
     , 'CR'                                                                AS t_type
     , ROUND(    SUM(oi.oi_qty*i.item_price)*t.tax_calc    ,2)             AS t_amount
     , o.o_id                                                              AS user_id
      -- , tx.t_amount
FROM orders o
     LEFT JOIN orders_transactions otx ON o.o_id = otx.o_id
     LEFT JOIN transactions tx         ON tx.t_id = otx.t_id
     JOIN orders_item oi               ON o.o_id = oi.o_id
     JOIN item i                       ON i.i_id = oi.i_id
     , (
         SELECT (SUM(tax_perc)/100)+1 AS tax_calc
         FROM tax t
         WHERE t.tax_end IS NULL AND tax_beg <= NOW()
     ) t
WHERE tx.t_id IS NULL -- 1 that FIRST insert
GROUP BY o.o_id, o.order_date, t.tax_calc -- , o.p_id, o.order_num, tx.t_amount
ORDER BY o.o_id;

-- Bulk orders_transactions INSERT ----------------------------------
DESCRIBE orders_transactions; 
SELECT * FROM orders_transactions;

-- build query
SELECT t.t_id, t.user_id, o.o_id, o.p_id 
FROM transactions t
     JOIN orders o ON t.user_id=o.o_id
WHERE o_id<>1;

-- 580116 rows inserted
INSERT INTO orders_transactions (o_id, t_id, p_id)
SELECT o.o_id, t.t_id, o.p_id 
FROM transactions t
     JOIN orders o ON t.user_id=o.o_id
WHERE o_id<>1;

-- verify
SELECT ot_id, o_id, t_id, p_id
FROM orders_transactions otx;

-- return user_id=2 from being temp o_id stored field
UPDATE transactions SET user_id=2;
SELECT user_id FROM transactions WHERE user_id<>2;

-- transactions SELECT (completed) ----------------------------------
SELECT tx.t_id, tx.t_num, tx.t_date, tx.t_mid, tx.t_acct, tx.t_type, tx.t_amount, tx.user_id
       , o.o_id, o.p_id, o.order_num -- , i.i_id, i.item_name
FROM orders o
     JOIN orders_transactions otx ON o.o_id = otx.o_id
     JOIN transactions tx         ON tx.t_id = otx.t_id
     -- JOIN orders_item oi          ON o.o_id = oi.o_id
     -- JOIN item i                  ON i.i_id = oi.i_id
ORDER BY o.o_id
LIMIT 0, 100;

-- --------------------------------------------------------------- --
-- JOINs
-- JOIN to find matching 
-- people to category, with people's names, and category name
SELECT p.p_id, p.first_name, p.last_name, p.ph_cell
     , pe.pe_id, pe.p_id, pe.pe_uri, pe.pe_salary
     , pc.pc_id, pc.p_id, pc.cat_id
     , c.cat_id, c.cat_name
FROM people p
     JOIN people_employee pe ON p.p_id = pe.p_id
     JOIN people_category pc ON p.p_id = pc.p_id
     JOIN category c         ON pc.cat_id = c.cat_id;

-- LEFT JOIN to find matching and unmatching
SELECT p.p_id, p.first_name, p.last_name, p.ph_cell
     , pe.pe_id, pe.p_id, pe.pe_uri, pe.pe_salary
     , pc.pc_id, pc.p_id, pc.cat_id
     , c.cat_id, c.cat_name
FROM people p
     LEFT JOIN people_employee pe ON p.p_id = pe.p_id
     LEFT JOIN people_category pc ON p.p_id = pc.p_id
     LEFT JOIN category c         ON pc.cat_id = c.cat_id
;

-- people to orders & item
SELECT p.first_name, p.last_name, p.ph_cell
     , o.order_num, o.order_date, o.order_notes, o.o_id
     , i.item_modelno, i.item_name, i.item_price
     , ip.ip_price
FROM people p
     JOIN orders o       ON p.p_id = o.p_id
     JOIN orders_item oi ON o.o_id = oi.o_id
     JOIN item i         ON oi.i_id = i.i_id
     JOIN item_price ip  ON i.i_id = ip.i_id;

SELECT COUNT(*) FROM orders; -- 580117
SELECT COUNT(*) FROM orders_item; -- 940189
SELECT COUNT(*) FROM item; -- 87

-- orders to item detail
SELECT COUNT(*) FROM (

SELECT o.o_id, o.order_num, o.order_date
     #, oi.o_id, oi.i_id
     , i.i_id, i.item_name, i.item_price, i.m_id
     , ip.ip_beg, ip.ip_end, ip.ip_price
     , m.man_name
     #, id.id_label, id.id_detail
     #, im.im_desc
FROM orders o
     JOIN orders_item oi      ON o.o_id = oi.o_id
     JOIN item i              ON oi.i_id = i.i_id
     JOIN item_price ip       ON i.i_id = ip.i_id
     JOIN manufacturer m      ON i.m_id = m.m_id
     LEFT JOIN item_detail id ON i.i_id = id.i_id
     LEFT JOIN item_meta im   ON i.i_id = im.i_id

   ) dt;

-- item thru category
SELECT c0.taxonomy, c0.cat_id, c0.cat_name
     , c1.cat_id_parent, c1.cat_id, c1.cat_name
FROM category c0
     LEFT JOIN category c1 ON c0.cat_id = c1.cat_id_parent
WHERE c0.cat_id_parent IS NULL AND c0.taxonomy = 'general';

-- people thru category
SELECT c0.taxonomy, c0.cat_id, c0.cat_name
     , c1.cat_id_parent, c1.cat_id, c1.cat_name
FROM category c0
     LEFT JOIN category c1 ON c0.cat_id = c1.cat_id_parent
WHERE c0.cat_id_parent IS NULL AND c0.taxonomy = 'departments';

-- category full uri
SELECT c0.taxonomy, c0.cat_id, c0.cat_name
     , c1.cat_id_parent, c1.cat_id, c1.cat_name
     , CONCAT('/categories/', c0.cat_uri, '/', c1.cat_uri, '/') AS cat_uri_full
FROM category c0
     JOIN category c1 ON c0.cat_id = c1.cat_id_parent
WHERE c0.cat_id_parent IS NULL AND c0.taxonomy = 'general';

-- category to people_category/people
SELECT c.cat_id, c.cat_name, c.cat_uri,c.taxonomy
     , pc.pc_id, p.p_id, p.first_name, p.last_name
     , p.addr, p.ph_home
FROM category c
     JOIN people_category pc ON c.cat_id = pc.cat_id
     JOIN people p           ON pc.p_id = p.p_id
WHERE c.taxonomy = 'departments';

-- category to item_category/item
SELECT c.cat_id, c.cat_name, c.cat_uri, c.taxonomy
     , i.item_type, i.item_name, i.item_modelno, i.item_barcode
     , i.item_uri, i.item_size, i.item_uom, i.item_price
     , i.image_uri, i.item_status
FROM category c
     JOIN item_category ic ON c.cat_id = ic.cat_id
     JOIN item i           ON ic.i_id = i.i_id
WHERE c.taxonomy = 'general';

-- item to manufacture/item detail/category
SELECT i.i_id, i.item_name
     , m.m_id, m.man_name
     , ip.ip_price
     , im.im_desc
     , id.id_label, id.id_detail
     , c.cat_name
FROM item i
     JOIN manufacturer m   ON i.m_id = m.m_id 
     JOIN item_price ip    ON i.i_id = ip.i_id
     JOIN item_category ic ON i.i_id = ic.i_id
     LEFT JOIN item_meta im     ON i.i_id = im.i_id
     LEFT JOIN item_detail id   ON i.i_id = id.i_id
     JOIN category c       ON ic.cat_id = c.cat_id
WHERE c.taxonomy='general';

-- orders to transactions
SELECT o.order_num, o.order_date
     , i.item_name, i.item_price * oi.oi_qty
     , tx.t_amount -- 260.68
FROM orders o
     JOIN orders_item oi          ON o.o_id = oi.o_id
     JOIN item i                  ON oi.i_id = i.i_id
     JOIN orders_transactions otx ON o.o_id = otx.o_id
     JOIN transactions tx         ON otx.t_id = tx.t_id;

-- orders to item/orders/transactions
SELECT o.order_num, o.order_date, i.item_name
     , i.item_price * oi.oi_qty * t.tax_calc
     , tx.t_amount
FROM orders o
     JOIN orders_item oi          ON o.o_id = oi.o_id
     JOIN item i                  ON oi.i_id = i.i_id
     JOIN orders_transactions otx ON o.o_id = otx.o_id
     JOIN transactions tx         ON otx.t_id = tx.t_id
     JOIN (
           SELECT (SUM(tax_perc)/100)+1 AS tax_calc -- SUBQUERY
           FROM tax t
           WHERE t.tax_end IS NULL AND tax_beg <= NOW()
     ) t;
	 
-- --------------------------------------------------------------- --
-- AGGREGATE QUERIES ------------------------------------------------

-- COUNT # of item, totel item_price, averge price, max & min price
DESCRIBE item;

SELECT COUNT(i_id), SUM(item_price)
  , AVG(item_price), SUM(item_price)/COUNT(i_id)
  , MAX(item_price), MIN(item_price)
FROM item;

SELECT i_id, item_uri, i.*
FROM item i;

SELECT COUNT(*) FROM item;

SELECT COUNT(*), COUNT(i_id), COUNT(item_uri)
FROM item;

UPDATE item SET item_type=LOWER(item_type);
SELECT i_id, item_uri, i.*
FROM item i;

-- show distinct first_name
SELECT DISTINCT first_name
FROM people
ORDER BY first_name;

-- count distinct first name
SELECT COUNT(DISTINCT first_name) AS first_name_dst_cnt
FROM   people;

-- /commentary/guest-articles/more-than-just-sdg-12-how-circular-economy-can-bring-holistic-wellbeing/

--  1234567890123456789012345678901234567890
--  Aidan

-- count number of same first name higher or equal to 10
SELECT first_name, COUNT(first_name) AS first_name_cnt
FROM people
WHERE SUBSTR(first_name,2,1) = 'i'
GROUP BY first_name
HAVING COUNT(first_name)>=10
ORDER BY first_name_cnt DESC, first_name;

-- count number of orders
SELECT COUNT(*) FROM orders; -- 580117

-- count number of order from different people
SELECT o.p_id
     , COUNT(o.o_id) AS orders_cnt
     , SUM(i.item_price*oi.oi_qty) AS order_subtot
FROM orders o 
     JOIN orders_item oi ON o.o_id=oi.o_id
     JOIN item i         ON oi.i_id=i.i_id
GROUP BY o.p_id;

-- --------------------------------------------------------------- --
-- CONSTRAINT -------------------------------------------------------

-- FOREIGN KEY FK

-- people_employee pe -----------------------------------------------
-- pe_p_id
-- ALTER TABLE people_employee DROP CONSTRAINT pe_p_id_FK;

ALTER TABLE people_employee
ADD CONSTRAINT pe_p_id_FK FOREIGN KEY (p_id) REFERENCES people(p_id);

-- pe_p_id_mgr
-- ALTER TABLE people_employee DROP CONSTRAINT pe_p_id_mgr_FK;
ALTER TABLE people_employee
ADD CONSTRAINT pe_p_id_mgr_FK FOREIGN KEY (p_id_mgr) REFERENCES people(p_id);

-- people p ---------------------------------------------------------
-- addr_type_id
-- ALTER TABLE people DROP CONSTRAINT p_addr_type_id_FK;

ALTER TABLE people
ADD CONSTRAINT p_addr_type_id_FK FOREIGN KEY (addr_type_id) REFERENCES geo_address_type(addr_type_id);

-- tc_id
-- ALTER TABLE people DROP CONSTRAINT p_tc_id_FK;

ALTER TABLE people
ADD CONSTRAINT p_tc_id_FK FOREIGN KEY (tc_id) REFERENCES geo_towncity(tc_id);

-- user_id
-- ALTER TABLE people DROP CONSTRAINT p_user_id_FK;

ALTER TABLE people
ADD CONSTRAINT p_user_id_FK FOREIGN KEY (user_id) REFERENCES people(p_id);

-- people_category pc -----------------------------------------------
-- p_id
-- ALTER TABLE people_category DROP CONSTRAINT pc_p_id_FK;

ALTER TABLE people_category
ADD CONSTRAINT pc_p_id_FK FOREIGN KEY (p_id) REFERENCES people(p_id);

-- cat_id
-- ALTER TABLE people_category DROP CONSTRAINT pc_cat_id_FK;

ALTER TABLE people_category
ADD CONSTRAINT pc_cat_id_FK FOREIGN KEY (cat_id) REFERENCES category(cat_id);

-- category c -------------------------------------------------------
-- cat_id_parent
-- ALTER TABLE category DROP CONSTRAINT c_cat_id_parent_FK;

ALTER TABLE category
ADD CONSTRAINT c_cat_id_parent_FK FOREIGN KEY (cat_id_parent) REFERENCES category(cat_id);

-- item_category ic -------------------------------------------------
-- i_id
-- ALTER TABLE item_category DROP CONSTRAINT ic_i_id_FK;

ALTER TABLE item_category
ADD CONSTRAINT ic_i_id_FK FOREIGN KEY (i_id) REFERENCES item(i_id);

-- cat_id
-- ALTER TABLE item_category DROP CONSTRAINT ic_cat_id_FK;

ALTER TABLE item_category
ADD CONSTRAINT ic_cat_id_FK FOREIGN KEY (cat_id) REFERENCES category(cat_id);

-- geo_towncity gtc -------------------------------------------------
-- r_id
-- ALTER TABLE geo_towncity DROP CONSTRAINT gtc_r_id_FK;

ALTER TABLE geo_towncity
ADD CONSTRAINT gtc_r_id_FK FOREIGN KEY (r_id) REFERENCES geo_region(r_id);

-- geo_region gr ----------------------------------------------------
-- co_id
-- ALTER TABLE geo_region DROP CONSTRAINT gr_co_id_FK;

ALTER TABLE geo_region
ADD CONSTRAINT gr_co_id_FK FOREIGN KEY (co_id) REFERENCES geo_country(co_id);

-- manufacturer m ---------------------------------------------------
-- addr_type_id
-- ALTER TABLE manufacturer DROP CONSTRAINT m_addr_type_id_FK;

ALTER TABLE manufacturer
ADD CONSTRAINT m_addr_type_id_FK FOREIGN KEY (addr_type_id) REFERENCES geo_address_type(addr_type_id);

-- tc_id
-- ALTER TABLE manufacturer DROP CONSTRAINT m_tc_id_FK;

ALTER TABLE manufacturer
ADD CONSTRAINT m_tc_id_FK FOREIGN KEY (tc_id) REFERENCES geo_towncity(tc_id);

-- item i -----------------------------------------------------------
-- m_id
-- ALTER TABLE item DROP CONSTRAINT i_m_id_FK;

ALTER TABLE item
ADD CONSTRAINT i_m_id_FK FOREIGN KEY (m_id) REFERENCES manufacturer(m_id);

-- item_detail id ---------------------------------------------------
-- i_id
-- ALTER TABLE item_detail DROP CONSTRAINT id_i_id_FK;

ALTER TABLE item_detail
ADD CONSTRAINT id_i_id_FK FOREIGN KEY (i_id) REFERENCES item(i_id);

-- item_price ip ----------------------------------------------------
-- i_id
-- ALTER TABLE item_price DROP CONSTRAINT ip_i_id_FK;

ALTER TABLE item_price
ADD CONSTRAINT ip_i_id_FK FOREIGN KEY (i_id) REFERENCES item(i_id);

-- item_meta im -----------------------------------------------------
-- i_id
-- ALTER TABLE item_meta DROP CONSTRAINT im_i_id_FK;

ALTER TABLE item_meta
ADD CONSTRAINT im_i_id_FK FOREIGN KEY (i_id) REFERENCES item(i_id);

-- orders_item oi ---------------------------------------------------
-- i_id
-- ALTER TABLE orders_item DROP CONSTRAINT oi_i_id_FK;

ALTER TABLE orders_item
ADD CONSTRAINT oi_i_id_FK FOREIGN KEY (i_id) REFERENCES item(i_id);

-- o_id
-- ALTER TABLE orders_item DROP CONSTRAINT oi_o_id_FK;

ALTER TABLE orders_item
ADD CONSTRAINT oi_o_id_FK FOREIGN KEY (o_id) REFERENCES orders(o_id);

-- orders o ---------------------------------------------------------
-- p_id
-- ALTER TABLE orders DROP CONSTRAINT o_p_id_FK;

ALTER TABLE orders
ADD CONSTRAINT o_p_id_FK FOREIGN KEY (p_id) REFERENCES people(p_id);

-- orders_transactions otx ------------------------------------------
-- o_id
-- ALTER TABLE orders_transactions DROP CONSTRAINT otx_o_id_FK;

ALTER TABLE orders_transactions
ADD CONSTRAINT otx_o_id_FK FOREIGN KEY (o_id) REFERENCES orders(o_id);

-- t_id
-- ALTER TABLE orders_transactions DROP CONSTRAINT otx_t_id_FK;

ALTER TABLE orders_transactions
ADD CONSTRAINT otx_t_id_FK FOREIGN KEY (t_id) REFERENCES transactions(t_id);

-- p_id
-- ALTER TABLE orders_transactions DROP CONSTRAINT otx_p_id_FK;

ALTER TABLE orders_transactions
ADD CONSTRAINT otx_p_id_FK FOREIGN KEY (p_id) REFERENCES people(p_id);

-- --------------------------------------------------------------- --
-- Unique Key UK
-- ALTER TABLE people DROP CONSTRAINT p_email_UK;
-- ALTER TABLE people ADD CONSTRAINT p_email_UK UNIQUE (email);

-- Check Constraint
-- ALTER TABLE people DROP CONSTRAINT p_addr_ph_email_CK;
ALTER TABLE people ADD CONSTRAINT p_addr_ph_email_CK CHECK (
addr IS NOT NULL OR ph_cell IS NOT NULL OR email IS NOT NULL
);







