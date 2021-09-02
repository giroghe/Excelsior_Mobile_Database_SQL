/*
Project 1: Excelsior Mobile Report
Jurgena Kerrci
*/

-- 0
USE [21WQ_BUAN4210_Lloyd_ExcelsiorMobile];

-- REPORT QUESTIONS WITH VISUALIZATIONS

-- 1 --
-- A
-- This query will return the minutes, data, text, and total bill by customer full name
SELECT CONCAT((S.FirstName), ' ' , LTRIM(S.LastName)) AS 'FullName', 
			LM.Minutes As MinUsage, 
			LM.Texts AS TextsUsage, 
			LM.DataInMB AS DataUsage, 
			B.Total AS ToalBill
FROM Subscriber AS S, LastMonthUsage AS LM, Bill AS B
WHERE S.MIN = LM.MIN AND S.MIN = B.MIN
ORDER BY FullName;

-- B
-- What is the avarage of the minutes, data, texts and total bill by city?
SELECT S.City,
	   AVG(Minutes) AS AvgMin,
	   AVG(LMU.DataInMB) AS AvgData,
	   AVG(Texts) AS AvgTexts,
	   AVG(Total) AS AvgTotBills
FROM LastMonthUsage AS LMU, Subscriber AS S, Bill AS B
WHERE LMU.MIN = B.MIN AND S.MIN = LMU.MIN
GROUP BY S.City;

-- C
-- This query will return the sum of minutes, data, texts and total bill by city
SELECT S.City,
	   SUM(Minutes) AS SumMin,
	   SUM(LMU.DataInMB) AS SumData,
	   SUM(Texts) AS SumTexts,
	   SUM(Total) AS SumTotBills
FROM LastMonthUsage AS LMU, Subscriber AS S, Bill AS B
WHERE LMU.MIN = B.MIN AND S.MIN = LMU.MIN
GROUP BY S.City;

-- D
-- What is the avarage of the minutes, data, texts and total bill by mobile plan?
SELECT S.PlanName AS 'Mobile Plan',
	   AVG(LMU.Minutes) AS AvgMin,
	   AVG(LMU.DataInMB) AS AvgData,
	   AVG(Texts) AS AvgTexts,
	   AVG(Total) AS AvgTotBills
FROM LastMonthUsage AS LMU, Subscriber AS S, MPlan AS MP, Bill AS B
WHERE S.PlanName = MP.PlanName AND LMU.MIN = B.MIN AND LMU.MIN = S.MIN 
GROUP BY S.PlanName;

-- E
-- What is the sum of minutes, texts, data and total bill by mobile plan?
SELECT S.PlanName AS 'Mobile Plan',
	   SUM(LMU.Minutes) AS SumMin,
	   SUM(LMU.DataInMB) AS SumData,
	   SUM(Texts) AS SumTexts,
	   SUM(Total) AS SumTotBills
FROM LastMonthUsage AS LMU, Subscriber AS S, MPlan AS MP, Bill AS B
WHERE S.PlanName = MP.PlanName AND LMU.MIN = B.MIN AND LMU.MIN = S.MIN 
GROUP BY S.PlanName;

-- REPORT QUESTIONS WITHOUT VISUALIZATION 

-- 1 -- 
-- A
-- This query will return the two cities that have the most customers in
SELECT TOP 2 City, COUNT(MIN) AS 'NumberOfCustomers'
FROM Subscriber
GROUP BY City
ORDER BY NumberOfCustomers DESC;

-- B
-- I first run this to see wich cities I have and the number of customer that each one has
SELECT  City, COUNT(City) AS 'NumberOfCustomers'
FROM Subscriber
GROUP BY City
ORDER BY NumberOfCustomers ASC;
-- Now I run this query so I have a tbel with only the cities with the least customers
SELECT TOP 3 City AS 'CitiesToIncreaseMarketingIn', COUNT(City) AS 'NumberOfCustomers'
FROM Subscriber
GROUP BY City
ORDER BY NumberOfCustomers ASC;

-- C
-- Witht this quesry we can identify the plans we should market the most
SELECT TOP 3 PlanName AS 'PlanToIncreaseMarketingIn', COUNT(PlanName) AS 'NumberOfCustomers'
FROM Subscriber
GROUP BY PlanName
ORDER BY NumberOfCustomers ASC;

-- 2 --
-- A
-- We want to see a list of the count of cell phones types used by our customer
-- By using count we can see which cell phone type is the most used
SELECT [Type] AS 'CellPhoneType', COUNT([Type]) AS 'NumberUsers'
FROM Device
GROUP BY [Type];

-- B
-- Now that we know that apple is the least used cell phone, 
-- we want to see the list of our customer that use apple 
SELECT CONCAT((S.FirstName), ' ' , LTRIM(S.LastName)) AS 'Customer', [Type] AS 'CellPhoneType'
FROM Device As D, Subscriber as S, DirNums AS DN
WHERE D.IMEI = DN.IMEI AND DN.MDN = S.MDN
AND D.[Type] = 'Apple'
ORDER BY Customer;

-- C
-- This query will return the list of customers that are using a phone 
-- befoer 2018 that was released 
SELECT CONCAT((S.FirstName), ' ' , LTRIM(S.LastName)) AS 'Customer', YearReleased AS PhoneYearReleased
FROM Device As D, Subscriber as S, DirNums AS DN
WHERE D.IMEI = DN.IMEI AND DN.MDN = S.MDN
AND D.YearReleased < 2018
ORDER BY Customer;

-- 3 --
-- We want to see which city from the top three data using cities where any 
-- of the customers is using unlimited data plan but stilluses a lot of data
SELECT TOP 1 S.City AS 'CitiesWithHighestDataUsage'
FROM LastMonthUsage AS LM, Subscriber AS S
WHERE LM.MIN = S.MIN
AND S.PlanName NOT LIKE 'Unl%'
ORDER BY DataInMB DESC;

-- 4 --
-- A
-- With this query we want to se the name of the customer with the monthly most expensive bill
SELECT TOP 1 CONCAT((S.FirstName), ' ' , LTRIM(S.LastName)) AS 'Customer', B.Total
FROM Bill AS B, Subscriber AS S 
WHERE B.MIN = S.MIN 
ORDER BY B.Total DESC;

-- B
-- Which is the most profitable mobile plan?
SELECT TOP 1 S.PlanName AS 'PlanWithMostRevenue'
FROM Subscriber AS S, Bill AS B
WHERE S.MIN = B.MIN
ORDER BY Total DESC;

-- 5 --
-- A
-- We want to return the area code that uses the most minutes
SELECT TOP 1 LEFT(MDN, 3) AS 'AreaCodeWithMostMinuts', SUM(Minutes) AS 'MinUsage'
FROM Subscriber AS S, LastMonthUsage AS LM
WHERE S.MIN = LM.MIN
GROUP BY LEFT(MDN, 3)
ORDER BY MinUsage DESC;

-- B 
-- This query will help us see which cities have the most variance in terms of minute usage
-- The range we use is customers who use less than 200 and more than 700 minutes
SELECT TOP 2 City, MIN(Minutes) AS 'MinMinutesUsage', MAX(Minutes) AS 'MaxMinutesUsage'
FROM Subscriber AS S, LastMonthUsage AS LM
WHERE S.MIN = LM.MIN
GROUP BY City
HAVING MIN(Minutes) < 200
AND  MAX(Minutes) > 700
















