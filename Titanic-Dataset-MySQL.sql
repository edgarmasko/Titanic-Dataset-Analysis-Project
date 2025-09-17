CREATE DATABASE titanic; -- Creates database
USE titanic; -- Lets MySQL know any updates will be in this database

CREATE TABLE titanic( -- creates table
	PassengerID int, -- int number variables
		survived boolean, -- boolean used as true/false - 0 = Didn't survive - 1 = survived
		pclass int,
		name varchar(255), -- varchar(255) text variables
		sex varchar(255),
		age int,
		sibSp int,
		parch int,
		ticket varchar(255),
		fare double,
		embarked varchar(255),
		hasCabin varchar(255),
		deck varchar(255),
		PRIMARY KEY(PassengerID) -- makes PassengerID the primary key
);

ALTER DATABASE titanic CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


DESCRIBE titanic; -- shows the type of data as well any additional information that describes

SELECT * FROM titanic; -- shows all entries inside of the table

SELECT COUNT(*) FROM titanic; -- check count matches up with rows inside of Excel sheet

-- 1. How many people survived/not survived?
SELECT survived, COUNT(*) AS total_passengers -- counts the amount of survived (1) or not survived (0) in total column
FROM titanic
GROUP BY survived; 

-- 2. How many people were travelling with family vs alone?
SELECT COUNT(*) as PassengerCount, -- counts all passengers
  CASE -- CASE STARTS
    WHEN SibSp = 0 AND Parch = 0 THEN 'Alone'
    ELSE 'With Family'
  END AS familyStatus -- CASE ENDS - stores as familyStatus
FROM titanic
GROUP BY 
  CASE -- CASE STARTS
    WHEN SibSp = 0 AND Parch = 0 THEN 'Alone' -- Stored as alone if SipSp & Parch = 0
    ELSE 'With Family' -- ELSE statement if SipSp & Parch = 0
END; -- CASE ENDS

-- 3. How many passengers embarked from each port, including survival counts?
SELECT COUNT(*) AS passenger_count, embarked, survived, 
  CASE 
    WHEN embarked = 'C' THEN 'Cherbourg'
    WHEN embarked = 'Q' THEN 'Queenstown'
    WHEN embarked = 'S' THEN 'Southampton'
  END AS embark_port
FROM titanic
WHERE embarked IN ('C', 'Q', 'S')  
GROUP BY embarked, embark_port, survived
ORDER BY embark_port, survived;

-- 4. What was the survival rate based on gender?
SELECT sex, survived, COUNT(*) AS total -- counts the amount of m/f & survived - displays total as column name
FROM titanic
GROUP BY sex, survived -- Used GROUP BY to showcase sex and survived result
ORDER BY sex desc; -- used ORDER BY to show the results more clearer - comparing men 0/1 - female 0/1

-- 5. What was the survival rate based on age? (Lowest to highest)
SELECT COUNT(*) as passenger_count, -- counts total passengers
AVG(survived) as survival_rate, -- calculates the survival rate
	Case -- CASE begins
		WHEN age >= 0 AND age < 12 THEN 'Child (0-12)' -- if under 12 = child
		WHEN age BETWEEN 12 AND 18 THEN 'Teenager (12-18)' -- if between 12 and 18 = teenager
		WHEN age BETWEEN 19 AND 25 THEN 'Young Adult (19-25)' 
        WHEN age > 25 THEN 'Adult (25+)' 
		ELSE 'Unknown age' -- else = unknown age
	END AS age_group -- CASE ends - stores it as age_group
FROM titanic
WHERE age IS NOT NULL
GROUP BY age_group
ORDER BY passenger_count ASC; -- sorts it in ascending result

-- 6. What was the survival rate of the passengers based on pclass and where they embarked from?
SELECT embarked, pclass, AVG(survived) as survival_rate, -- calculates the survival rate
COUNT(*) AS passenger_count -- counts all passengers
FROM titanic
WHERE embarked != 'Unknown'
GROUP BY embarked, pclass -- groups by embarked and pclass to calculate the result
ORDER BY embarked, pclass; -- orders them by embarked and pclass to make it look tidy

-- 7. What was the survival rate by deck?
SELECT deck, AVG(survived) as survival_rate, -- calculates the survival rate
COUNT(*) AS passenger_count -- counts all passengers
FROM titanic
WHERE deck != "n/a" -- deck not equal to string value
GROUP BY deck;

-- 8. Did a higher ticket fare correlate with survival?
SELECT COUNT(*) as total_passengers, -- counts all passengers
AVG(survived) as survival_rate, -- calculates the survival rate
	CASE -- CASE begins
		WHEN fare < 10 THEN 'Fare €0 - €10'
		WHEN fare BETWEEN 10 AND 30 THEN 'Fare €10 - €30'
        WHEN fare BETWEEN 30 AND 100 THEN 'Fare €30 - €100'
        WHEN fare > 100 THEN 'Fare €100+'
END AS fare_ranges -- CASE ends - stores as fare_ranges
FROM titanic
GROUP BY fare_ranges; -- groups by fare_ranges

-- 9. Each fare
SELECT age, fare, PassengerID
FROM titanic
WHERE age IS NOT NULL AND fare IS NOT NULL;

-- 10. What was the survival rate based on age? (Lowest to highest)
SELECT COUNT(*) as passenger_count, -- counts total passengers
AVG(survived) as survival_rate, -- calculates the survival rate
	Case -- CASE begins
		WHEN age >= 0 AND age < 10 THEN '0-10' 
		WHEN age BETWEEN 10 AND 20 THEN '10-20' 
        WHEN age BETWEEN 20 AND 30 THEN '20-30' 
        WHEN age BETWEEN 30 AND 40 THEN '30-40' 
        WHEN age BETWEEN 40 AND 50 THEN '40-50' 
        WHEN age BETWEEN 50 AND 60 THEN '50-60' 
        WHEN age BETWEEN 60 AND 70 THEN '60-70' 
		WHEN age BETWEEN 70 AND 80 THEN '70-80' 
        WHEN age > 80 THEN '80+' 
		ELSE 'Unknown age' -- else = unknown age
	END AS age_group -- CASE ends - stores it as age_group
FROM titanic
WHERE age IS NOT NULL
GROUP BY age_group
ORDER BY survival_rate ASC; -- sorts it in ascending result

-- 11. Average fare
SELECT AVG(fare) AS average_fare
FROM titanic;

-- 12. Average age
SELECT ROUND(AVG(age)) as average_age
FROM titanic;

-- 13. Total passengers
SELECT COUNT(*) AS total_passengers
FROM titanic;

-- 14. Gender
SELECT sex, COUNT(*) AS total_passengers
FROM titanic
GROUP BY sex;

-- 15. 
SELECT pclass, survived, COUNT(*) AS total_passengers
FROM titanic
GROUP BY pclass, survived
ORDER BY survived, pclass;

-- 16. What were the top 10 highest paid fares?
SELECT name, ticket, fare 
FROM titanic
ORDER BY fare DESC
LIMIT 10; -- limit 5 to get the top ten


-- 17. What was the survival rate based on people with and without family?
SELECT  
    CASE  
        WHEN SibSp > 0 OR Parch > 0 THEN 'Has Family'  
        ELSE 'Alone'  
    END AS family_status,  
    COUNT(*) AS passenger_count,  
    SUM(survived) AS survived_count,  
    AVG(survived) AS survival_rate  
FROM titanic  
GROUP BY family_status;

-- NON PowerBI ---------------------------------------------------------

-- Who paid the highest fare and did they survive?
SELECT name, fare, survived
FROM titanic
ORDER BY fare DESC -- sorts by descending
LIMIT 1; -- shows top 1

-- What was the average fare of someone with a cabin vs without a cabin?
SELECT hasCabin, ROUND(AVG(fare), 2) AS avg_fare -- calculates the average fare
FROM titanic
GROUP BY hasCabin;

-- What is the average age of the people on board?
SELECT ROUND(AVG(age)) as averageAge -- AVG gets the average age and makes a averageAge column -- ROUND makes the result a whole number
FROM titanic
WHERE age IS NOT NULL;

-- What is the average age of survived/not survived?
SELECT survived, ROUND(AVG(age)) AS avg_age -- used ROUND to get a whole number and stored average age as avg_age
FROM titanic
GROUP BY survived; -- displays by surivved

-- What was the average fare per embarkation point?
SELECT embarked, ROUND(AVG(fare), 2) AS avg_fare
FROM titanic
GROUP BY embarked;

-- How many people were in each class?
SELECT pclass, COUNT(*) as total -- counts the amount of people in each pclass and assigns it to the total column
FROM titanic
GROUP BY pclass; -- display by pclass

-- Which gender had to pay the higher average fare?
SELECT sex, AVG(fare) as avg_fare -- calculates the average fare
FROM titanic
GROUP BY sex; -- group by gender

-- Who is the oldest passenger onboard?
SELECT name, age -- select name and age 
FROM titanic
ORDER BY age DESC -- sorting by descending age to get the oldest 
LIMIT 1; -- limit 1 to just have the oldest one

-- What was the count of survived/not survived based on pclass and gender?
SELECT sex, pclass, survived, COUNT(*) AS count 
FROM titanic
GROUP BY sex, pclass, survived 
ORDER BY sex, pclass, survived; -- used order by to display them in order form to compare results easier

-- Did having a cabin improve the chance of survival?
SELECT hasCabin, 
AVG(survived) as survival_rate, -- gets % of survived
COUNT(*) as passenger_count -- counts all passengers
FROM titanic
GROUP BY hasCabin;  -- groups passengers on wether they had a cabin or not

-- What were the names of the five youngest survivors?
SELECT name, age, survived
FROM titanic
WHERE survived = 1 AND age IS NOT NULL -- where clause to get rid of any dead and NULL values
ORDER BY age ASC -- order by asc to get 
LIMIT 5; -- displays only the top 5

-- What were the average fares paid by survivors vs non survivors?
SELECT survived, ROUND(AVG(fare), 2) as avg_fare -- ROUND to get whole avg number to 2 decimal places
FROM titanic
GROUP BY survived;