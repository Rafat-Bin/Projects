-----creating table----
CREATE TABLE hrdata
(
	emp_no int8 PRIMARY KEY,
	gender varchar(50) NOT NULL,
	marital_status varchar(50),
	age_band varchar(50),
	age int8,
	department varchar(50),
	education varchar(50),
	education_field varchar(50),
	job_role varchar(50),
	business_travel varchar(50),
	employee_count int8,
	attrition varchar(50),
	attrition_label varchar(50),
	job_satisfaction int8,
	active_employee int8
)


-------------------------------------
SELECT * FROM hrdata
-------------------------------------
--total number of employee--
SELECT SUM(employee_count) FROM hrdata

--number of active employee-- 1233
SELECT COUNT(active_employee) FROM hrdata
WHERE active_employee= 1

--number of ex employee--237
SELECT COUNT(active_employee) FROM hrdata
WHERE active_employee= 0
-------------------------------------

--avg age of the employees-- 37
SELECT ROUND(AVG(age)) FROM hrdata

--number of empoyees by age group-- most employess age is around 35 and 34, lowest 60 and 57
SELECT age, count(age) as num_emp  FROM hrdata
GROUP BY age
ORDER BY num_emp DESC

--attrition Rate by Gender for different age Group--
--most male and female employess age group is 25-34--
SELECT age_band,gender, count(attrition) as num_of_emp,   
round((cast(count(attrition) as numeric) / (select count(attrition) from hrdata where attrition = 'Yes')) * 100,2)
as percen_of_emp 
FROM hrdata
WHERE attrition= 'Yes' 
GROUP BY age_band, gender
ORDER BY age_band, gender DESC
-------------------------------------

--attrition count total: ex employess-- 
--so far 237 employess left--
SELECT COUNT(attrition) FROM hrdata
WHERE attrition='Yes'

--attrition Rate-- 16.12%
select 
 ((select count(attrition) from hrdata where attrition='Yes')/ 
sum(employee_count)) * 100
from hrdata


--attrition count by gender-- 
--Male employees mostly leave their jobs--
SELECT gender, COUNT(attrition) FROM hrdata
WHERE attrition='Yes'
GROUP BY gender
ORDER BY COUNT(attrition) DESC
-------------------------------------

--department wise attrition-- 
--Employees from R&D mostly leave their jobs--
select department, count(attrition), round((cast (count(attrition) as numeric) / 
(select count(attrition) from hrdata where attrition= 'Yes')) * 100, 2) as percet from hrdata
where attrition='Yes'
group by department 
order by count(attrition) desc;

--job role wise attrition--
--Employees as Lab technicians and sales executive mostly leave their jobs--
SELECT job_role, COUNT(attrition) as total_attrition   FROM hrdata
WHERE attrition='Yes'
GROUP BY job_role
ORDER BY total_attrition DESC


--education wise attrition--
--Employees from edu field Life science and medical mostly leave their jobs--
SELECT education_field, COUNT(attrition) as total_attrition  FROM hrdata
WHERE attrition='Yes'
GROUP BY education_field
ORDER BY total_attrition DESC


--Business travel wise attrition--
--Employees who travels rarely mostly leave their jobs--
SELECT business_travel, COUNT(attrition) as total_attrition  FROM hrdata
WHERE attrition='Yes'
GROUP BY business_travel
ORDER BY total_attrition DESC

-------------------------------------

--Job Role that travels most-- sales executive and research scientist
SELECT job_role, COUNT(business_travel) as most_travel  FROM hrdata
WHERE business_travel='Travel_Frequently' 
GROUP BY job_role
ORDER BY most_travel DESC


-------------------------------------
SELECT * FROM hrdata


--Total Ratings by Job Role-- 
--Sales Executive and Research Scientist Highest--
SELECT job_role, COUNT(job_satisfaction) as rating_count 
FROM hrdata
GROUP BY job_role
ORDER BY rating_count DESC


--Number of different Ratings for each job Role--
--Sales Executive and Research Scientist Highest--

CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT *
FROM crosstab(
  'SELECT job_role, job_satisfaction, sum(employee_count)
   FROM hrdata
   GROUP BY job_role, job_satisfaction
   ORDER BY job_role, job_satisfaction'
	) AS ct(job_role varchar(50), one numeric, two numeric, three numeric, four numeric)
ORDER BY job_role ;
