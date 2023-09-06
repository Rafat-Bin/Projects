SELECT * FROM fifaa

SELECT COUNT(*) FROM fifaa


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------DATA CLEANING----------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------List of data cleaning task performed

---1. We will remove some unnesecary Columns--- LongName, photoUrl and playerUrl 
---2. Removing cm from value and converting inch and feet values to cm to make sure all values is in cm  and change the data type to int
---3. Removing Kg and lbs from value and converting lbs to Kg from Weight Column and it data type to int
---4. Removing M and K from value and converting K  to M from Value Column and it data type to float
---5. Removing K and € from value and converting K  to M from Wage Column and it data type to float
---6. Removing K and € from value and converting K  to M from Release_Clause Column and it data type to float
---7. Removing '★' from W_F, SM, IR Columns
---8. Converting Joined column to DATA data type
---9. Spliting Contract  column to Start_Date and End_Date
---10. Creating contract len column



---1. Droping unnesecary Columns---

ALTER TABLE fifaa
DROP COLUMN LongName

ALTER TABLE fifaa
DROP COLUMN photoUrl,playerUrl
---------------------------------------------

---2. Removing cm from value and converting inch and feet values to cm from Height Column and it data type to int--
SELECT DISTINCT(Height) FROM fifaa


SELECT
    Height,
    CASE
        WHEN Height LIKE '%cm' THEN
            CAST(SUBSTRING(Height, 1, LEN(Height) - 2) AS INT)
        ELSE
            (CAST(SUBSTRING(Height, 1, CHARINDEX('''', Height) - 1) AS INT) * 12 +
             CAST(SUBSTRING(Height, CHARINDEX('''', Height) + 1, CHARINDEX('"', Height) - CHARINDEX('''', Height) - 1) AS INT)) * 2.54
    END AS bb
FROM fifaa;

---updating Height Column---
UPDATE fifaa
SET Height = CASE
        WHEN Height LIKE '%cm' THEN
            CAST(SUBSTRING(Height, 1, LEN(Height) - 2) AS INT)
        ELSE
            (CAST(SUBSTRING(Height, 1, CHARINDEX('''', Height) - 1) AS INT) * 12 +
             CAST(SUBSTRING(Height, CHARINDEX('''', Height) + 1, CHARINDEX('"', Height) - CHARINDEX('''', Height) - 1) AS INT)) * 2.54
    END 

---Changing Column Name---
EXEC sp_rename 'fifaa.[Height]', 'Height_cm', 'COLUMN';

SELECT Height_cm FROM fifaa
---------------------------------------------


---3. Removing Kg and lbs from value and converting lbs  to Kg from Weight Column and it data type to int---

SELECT DISTINCT(Weight) FROM fifaa

SELECT
    Weight,
    CASE
        WHEN Weight LIKE '%kg' THEN
            CAST(SUBSTRING(Weight, 1, LEN(Weight) - 2) AS INT)
        ELSE
            CAST(SUBSTRING(Weight, 1, LEN(Weight) - 3) AS INT)*.454
    END 
FROM fifaa;

---Updating weight Column--- 

UPDATE fifaa
SET Weight =CASE
        WHEN Weight LIKE '%kg' THEN
            CAST(SUBSTRING(Weight, 1, LEN(Weight) - 2) AS INT)
        ELSE
            CAST(SUBSTRING(Weight, 1, LEN(Weight) - 3) AS INT)*.454
    END 


---Changing Column Name---
EXEC sp_rename 'fifaa.[Weight]', 'Weight_kg', 'COLUMN';

SELECT Weight_kg FROM fifaa
---------------------------------------------


---4. Removing M and K from value and converting K  to M from Value Column and it data type to float---
SELECT DISTINCT(Value) FROM fifaa   

SELECT
    Value,
    CASE
        WHEN Value LIKE '%M' THEN
            CAST(SUBSTRING(Value, 2, LEN(Value) - 2) AS FLOAT)
        ELSE
            CAST(SUBSTRING(Value, 2, LEN(Value) - 2) AS FLOAT)/1000
    END 
FROM fifaa 

UPDATE fifaa
SET  Value_M =CASE
        WHEN Value_M LIKE '%M' THEN
            CAST(SUBSTRING(Value_M, 2, LEN(Value_M) - 2) AS FLOAT)
        ELSE
            CAST(SUBSTRING(Value_M, 2, LEN(Value_M) - 2) AS FLOAT)/1000
    END  

EXEC sp_rename 'fifaa.[Value]', 'Value_M', 'COLUMN';

SELECT Value_M FROM fifaa
---------------------------------------------



---5. Removing K and € from value and converting K  to M from wage Column and it data type to float---
SELECT DISTINCT(Wage) FROM fifaa   

SELECT Wage, (CAST(SUBSTRING(Wage, 2, LEN(Wage) - 2) AS FLOAT))/1000
    
FROM fifaa 

UPDATE fifaa
SET  Wage = (CAST(SUBSTRING(Wage, 2, LEN(Wage) - 2) AS FLOAT))/1000

EXEC sp_rename 'fifaa.[Wage]', 'Wage_M', 'COLUMN';

SELECT Wage_M FROM fifaa
---------------------------------------------



---6. Removing K and € from value and converting K  to M from Release_Clause Column and it data type to float---

SELECT DISTINCT(Release_Clause) FROM fifaa

SELECT
    Release_Clause,
    CASE
        WHEN Release_Clause LIKE '%M' THEN
            CAST(SUBSTRING(Release_Clause, 2, LEN(Release_Clause) - 2) AS FLOAT)
        ELSE
            CAST(SUBSTRING(Release_Clause, 2, LEN(Release_Clause) - 2) AS FLOAT)/1000
    END 
FROM fifaa

 UPDATE fifaa
SET  Release_Clause =CASE
        WHEN Release_Clause LIKE '%M' THEN
            CAST(SUBSTRING(Release_Clause, 2, LEN(Release_Clause) - 2) AS FLOAT)
        ELSE
            CAST(SUBSTRING(Release_Clause, 2, LEN(Release_Clause) - 2) AS FLOAT)/1000
    END  

EXEC sp_rename 'fifaa.[Release_Clause]', 'Release_Clause_M', 'COLUMN';

SELECT Release_Clause_M FROM fifaa
---------------------------------------------



---7. Removing  '★' from W_F, SM, IR Columns---

SELECT DISTINCT(W_F) FROM fifaa
SELECT DISTINCT(SM) FROM fifaa
SELECT DISTINCT(IR) FROM fifaa  

UPDATE fifaa SET  W_F =SUBSTRING(W_F,1, LEN(W_F)-1)
UPDATE fifaa SET  SM =SUBSTRING(SM,1, LEN(SM)-1)
UPDATE fifaa SET  IR =SUBSTRING(IR,1, LEN(IR)-1)
---------------------------------------------



---8. Converting Joined column to DATA data type---
SELECT * FROM fifaa

SELECT Joined, CAST(Joined AS DATE) FROM fifaa

UPDATE fifaa SET  Joined =CAST(Joined AS DATE)
---------------------------------------------


---9. Spliting Contract  column to Start_Date and End_Date---

SELECT DISTINCT(Contract) FROM fifaa


SELECT Contract, CAST(REPLACE(SUBSTRING(Contract,1,CHARINDEX('~',Contract)),'~','')AS INT) AS Start_date,
CAST(SUBSTRING(Contract,CHARINDEX('~',Contract)+1,LEN(Contract))AS INT) AS END_DATE
FROM fifaa
WHERE NOT (Contract LIKE '%On Loan%' OR Contract LIKE 'Free')


---Creating new column---
ALTER TABLE fifaa
ADD Start_date INT,
    END_DATE INT


UPDATE fifaa
SET Start_date = CAST(REPLACE(SUBSTRING(Contract, 1, CHARINDEX('~', Contract)), '~', '') AS INT),
    END_DATE = CAST(SUBSTRING(Contract, CHARINDEX('~', Contract) + 1, LEN(Contract)) AS INT)
WHERE NOT (Contract LIKE '%On Loan%' OR Contract LIKE 'Free');

EXEC sp_rename 'fifaa.[END_DATE]', 'End_date', 'COLUMN'
---------------------------------------------


---10. Creating contract len column---

---Creating new column---
ALTER TABLE fifaa
ADD Contract_len INT
    
SELECT (End_date-Start_date) as Contract_len
FROM fifaa

UPDATE fifaa
SET Contract_len =(End_date-Start_date)
 
 
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------EXPLORATORY DATA ANALYSIS--------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------KEY INSIGHTS-----------------

---1. Total Number of players-- 18979
---2. Top 3 Nationality With Most Players--- ENGLAND, GERMANY, SPAIN
---3. Top 3 Clubs With Most Players---  No club, Hertha BSC, Angers SCO
---4. Top 3 Nationality From Which Player Did Not Get A Club--- India, Ecuador, Uruguay
---5. Top 3 Players With Highest Wages--- L. Messi, K. De Bruyne, E. Hazard
---6. Top 3 Players With Highest Value- M. de Ligt, Bernardo Silva, G. Donnarumma
---7. Top 3 Age Group With Max Wage- 33,29,32
---8. Top 3 clubs with Highest Avg age---      Shanghai Greenland Shenhua FC,  Qingdao Huanghai F.C., Sivasspor (29)
---9. Top 3 Players with Highest overall--- L. Messi, Cristiano Ronaldo, K. De Bruyne
---10. Position Wise AVG overall--- CF,LW,CM
---11. All Posotion Wise Best Overall Player--- L. Messi (RW), Cristiano Ronaldo (ST), K. De Bruyne (CAM)
---12. Number of Players by Position--- CB 3686, ST 2680, 2299
---13. Top 3 Players With Highest Contact Lenght-- H. Sogahata	23,  I. Khune	21, I. Akinfeev	20


SELECT TOP 5 * FROM fifaa 

---1. Total Number of players--- 18979

SELECT COUNT(ID) AS Total_num_players FROM fifaa

---2. Top 3 Nationality With Most Players --- ENGLAND, GERMANY, SPAIN
SELECT TOP 3 Nationality, COUNT(ID) AS Total_num_players
FROM fifaa
GROUP BY Nationality
ORDER BY Total_num_players DESC

---3. Top 3 Clubs With Most Players--  No club, Hertha BSC, Angers SCO
SELECT TOP 3 Club, COUNT(ID) AS Total_num_players
FROM fifaa
GROUP BY Club
ORDER BY Total_num_players DESC

---4. Top 3 Nationality From Which Player Did Not Get A Club--- India, Ecuador, Uruguay
SELECT TOP 3 Nationality, COUNT(ID) AS Total_num_players
FROM fifaa  WHERE Club = 'No Club'
GROUP BY Nationality
ORDER BY Total_num_players DESC

---5. Top 3 Players With Highest Wages--- L. Messi, K. De Bruyne, E. Hazard
SELECT TOP 3 Name, MAX(Wage_M) AS Max_Wage_in_M
FROM fifaa 
GROUP BY Name
ORDER BY Max_Wage_in_M DESC

---6. Top 3 Players With Highest Value- M. de Ligt, Bernardo Silva, G. Donnarumma
SELECT TOP 3 Name, MAX(Value_M) AS Max_Value_in_M
FROM fifaa 
GROUP BY Name
ORDER BY Max_Value_in_M DESC


---7. Top 3 Age Group With Max Wage- 33,29,32
SELECT TOP 3 Age, MAX(Wage_M) AS Max_Wage_in_M
FROM fifaa 
GROUP BY Age
ORDER BY Max_Wage_in_M DESC


---8. Top 3 clubs with Highest Avg age---      Shanghai Greenland Shenhua FC,  Qingdao Huanghai F.C., Sivasspor

SELECT TOP 3 Club, Avg(Age)
FROM fifaa 
GROUP BY Club
ORDER BY  Avg(Age) DESC

---9. Top 3 Players with Highest overall--- L. Messi, Cristiano Ronaldo, K. De Bruyne

SELECT TOP 3 Name, MAX(OVA) as max_ova
FROM fifaa 
GROUP BY Name
ORDER BY max_ova DESC

---10. Position Wise AVG overall--- CF,LW,CM


SELECT TOP 3 Best_Position, AVG(OVA) as avg_ova
FROM fifaa 
GROUP BY Best_Position
ORDER BY avg_ova DESC

---11. All Posotion Wise Best Overall Player--- L. Messi (RW), Cristiano Ronaldo (ST), K. De Bruyne (CAM)
SELECT TOP 3 Name, Best_Position, MAX(OVA) 
FROM fifaa 
GROUP BY Name, Best_Position
ORDER BY  MAX(OVA)  DESC

---12. Number of Players by Position--- CB 3686, ST 2680, 2299

SELECT TOP 3  Best_Position, COUNT(ID) total_player
FROM fifaa 
GROUP BY  Best_Position
ORDER BY  total_player  DESC


---13. Top 3 Players With Highest Contact Lenght-- H. Sogahata	23,  I. Khune	21, I. Akinfeev	20

SELECT TOP 3  Name, max(Contract_len) as max_contract_len
FROM fifaa 
GROUP BY  Name
ORDER BY  max_contract_len  DESC