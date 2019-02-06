-- Написання SQL-запитів SELECT (WHERE, JOIN, ORDER BY)

-- 1. (вибірка з одної таблиці з простою умовою)
#1 
SELECT maker,type from Product ORDER BY maker;
#2
SELECT model, ram, screen, price from Laptop 
	WHERE price > 1000 ORDER BY ram, price DESC;
#3
SELECT * from Printer WHERE color = 'y' ORDER BY price DESC;
#4
SELECT model, speed, hd, cd, price from PC WHERE (cd = "12x" OR cd = "24x") AND price < 600;
#6
SELECT * from PC WHERE speed >= 500 AND price < 800;
#6*
SELECT * from PC WHERE speed >= 500 AND price < 800 UNION SELECT * from Laptop WHERE speed >= 500 AND price < 800;
#7
SELECT * FROM Printer WHERE type != "Matrix" AND price < 300 ORDER BY type; 
#20
SELECT name,launched from Ships WHERE launched > 1920 AND launched < 1942;
#25
SELECT trip_no, plane, town_from, town_to from Trip WHERE plane = "TU-134" order by time_out;


-- 2. (вибірка з одної таблиці з простою умовою)
#1
SELECT * from PC WHERE model Like '%1%1%';
SELECT * from PC WHERE model RLIKE '1{2}';
#4
SELECT * from Ships WHERE name RLIKE '^W'AND name RLIKE 'n$'; 
#5
SELECT * from Ships where name RLIKE 'e{2}';
#6
SELECT* from Ships WHERE name RLIKE '[^a]$'; 
#8
SELECT * from Trip WHERE hour(time_out) >= 12 AND hour(time_out) <= 17;
SELECT * from Trip WHERE hour(time_out) BETWEEN 12 AND 17;
#10
SELECT * from Pass_in_trip WHERE place RLIKE '1[a-d]'; 
#11
SELECT * from Pass_in_trip WHERE place RLIKE '[1-9]c';
#12
SELECT * from Passenger WHERE name RLIKE '[[:space:]]C';
#13
SELECT * from Passenger WHERE name NOT RLIKE '[[:space:]]J';
-- 3. (Вибірка з 2х таблиць з простою умовою)
#1
SELECT maker,type, speed, hd from Product,PC WHERE hd <= 8;
#2
SELECT maker from Product,PC WHERE PC.speed >= 600;
#9
SELECT maker, price,PC.model from Product,PC;
#11
SELECT name, displacement from Ships,Classes WHERE Classes.class = Ships.class; 
#12
SELECT ship, name,date,result from Battles JOIN Outcomes ON  result = "OK" AND name = battle;
#13
SELECT name,country from Classes,Ships WHERE Classes.class = Ships.class;
#14
SELECT  DISTINCT name,plane from Company,Trip WHERE plane = "Boeing" AND Trip.ID_comp = Company.ID_comp;
-- 4 (Використ підзапитів у конструкції WHERE з викор. IN, ANY,ALL)
SELECT count(*) as QTY from PC,Product WHERE maker = 'A' AND PC.model = Product.model; 
#1
SELECT DISTINCT maker from Product,PC WHERE Product.model = PC.model AND Product.model NOT IN (SELECT model from Laptop);
#2
SELECT DISTINCT maker from Product,PC WHERE Product.model = PC.model AND Product.model != ALL (SELECT model from Laptop);
#3
SELECT DISTINCT maker from Product,PC WHERE Product.model = PC.model AND Product.model != ANY (SELECT model from Laptop);
#4
SELECT DISTINCT maker from Product WHERE Product.maker IN (SELECT maker from Product,PC WHERE Product.model = PC.model)
 AND Product.maker IN (SELECT maker from Laptop,Product WHERE Product.model = Laptop.model );
#6
SELECT DISTINCT maker from Product WHERE Product.maker = ANY (SELECT maker from Product,PC WHERE Product.model = PC.model)
 AND Product.maker = ANY (SELECT maker from Laptop,Product WHERE Product.model = Laptop.model );

-- 5 (Використання підзапитів з лог. операцією EXISTS)
#1
#?
#2 
SELECT DISTINCT maker from Product WHERE EXISTS(SELECT Product.model from Product,PC WHERE Product.model = PC.model AND PC.speed >= 750);
SELECT DISTINCT maker from Product WHERE EXISTS(SELECT Product.model from Product,PC WHERE Product.type = "PC" AND PC.speed >= 750);
SELECT DISTINCT maker from Product WHERE EXISTS(SELECT model from PC WHERE speed >= 750);
#3?
SELECT DISTINCT maker From Product as Lap_pr WHERE type = "Laptop"AND  AND EXISTS (SELECT maker from Product)

SELECT DISTINCT maker
FROM Product AS Lap_product
WHERE type = 'Laptop' AND NOT EXISTS
       (SELECT maker
       FROM Product
       WHERE type = 'Printer' AND maker = Lap_product.maker);

-- 6 (Конкатенація стрічок чи мат. обчислення чи робота з датами)
#1
SELECT AVG(price) AS 'середня ціна =' from Laptop;
#2
SELECT concat('Model:',model) AS concat from PC;
#6
SELECT *,concat('from ',town_from,' to ',town_to) as info from Trip;

-- 7 (Статистичні функції та робота з групами)
#1
SELECT * from Printer WHERE price = (SELECT MAX(price) from Printer);
#2
SELECT * from Laptop WHERE speed < (SELECT MIN(speed) from PC);
#3
SELECT * from Printer,Product WHERE price = (SELECT MIN(price) from Printer) AND Printer.model = Product.model;
#4
SELECT maker, count(DISTINCT model) as count from Product WHERE Product.type = 'PC' GROUP BY maker HAVING count >=2;  
#5
SELECT  avg(PC.hd) from PC,Product WHERE Product.model = PC.model AND Product.maker IN (SELECT maker from Product WHERE type = 'Printer'); 
-- 8 (Підзапити у якості обчислювальних стовпців)
#1
SELECT maker,
	   			(SELECT COUNT(*) FROM  PC JOIN Product pr ON PC.model = pr.model WHERE maker = Product.maker) as pc,
 	 			(SELECT COUNT(*) FROM  Laptop JOIN Product pr ON Laptop.model = pr.model WHERE maker = Product.maker) as laptop,
 				(SELECT COUNT(*) FROM  Printer JOIN Product pr ON Printer.model = pr.model WHERE maker = Product.maker) as printer,
                (SELECT sum(pc) + sum(laptop) + sum(printer)) as suma
  FROM Product  GROUP  BY  maker; 
#2
SELECT maker, AVG(screen) from Laptop,Product WHERE Laptop.model = Product.model GROUP BY maker;
#3
SELECT maker, MAX(price)  from PC,Product WHERE PC.model = Product.model GROUP BY maker;
#4
SELECT maker, MIN(price)  from PC,Product WHERE PC.model = Product.model GROUP BY maker;          
#5
SELECT speed, AVG(price) from PC WHERE PC.speed = speed GROUP BY speed HAVING speed > 600;
-- 9 (Оператор CASE)
#1
 SELECT p.maker, case When (SELECT COUNT(*) FROM  PC JOIN Product pr ON PC.model = pr.model WHERE pr.maker = p.maker)>0 
 THEN CONCAT('YES(',FORMAT((SELECT COUNT(*) FROM  PC JOIN Product pr ON PC.model = pr.model WHERE pr.maker = p.maker),'E'),')') 
 ELSE 'NO' END  as pc FROM Product p group by maker;  
 
-- 10 (Об’єднання UNION)
#1 
SELECT maker,Product.model,type,price from PC,Product WHERE Product.maker = 'B' AND Product.model = PC.model
UNION SELECT maker,Product.model,type,price from Laptop,Product  WHERE Product.maker = 'B' AND Product.model = Laptop.model
UNION SELECT maker,Product.model,Product.type,price from Printer,Product  WHERE Product.maker = 'B' AND Product.model = Printer.model;
#2
SELECT maker,Product.model, Product.type, MAX(price) as max from PC,Product WHERE  Product.model = PC.model GROUP BY Product.model
UNION SELECT maker,Product.model,Product.type, MAX(price) as max from Laptop,Product  WHERE  Product.model = Laptop.model GROUP BY Product.model
UNION SELECT maker,Product.model,Product.type, MAX(price) as max from Printer,Product  WHERE Product.model = Printer.model GROUP BY Product.model;
#3
SELECT AVG(price) AS Середня_ціна from (SELECT price from PC,Product p WHere PC.model = p.model AND p.maker = 'A'
						UNION 
                        SELECT price from Laptop,Product p WHere Laptop.model = p.model AND p.maker = 'A') as Result;
#4
SELECT name, class from Ships WHERE class=name 
	UNION 
SELECT ship, ship from Outcomes WHERE EXISTS(SELECT * FROM Ships WHERE Outcomes.ship = Ships.class); 


