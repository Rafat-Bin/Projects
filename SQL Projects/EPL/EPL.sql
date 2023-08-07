SELECT * FROM EPL_20_21


--NUMBER of natonality
SELECT COUNT(DISTINCT nationality) FROM EPL_20_21


--natonality with most player
SELECT nationality, COUNT(nationality) FROM EPL_20_21
GROUP BY nationality
ORDER BY COUNT(nationality) DESC
LIMIT 5

--which club has the most players

SELECT club, COUNT(name) as player_number FROM EPL_20_21
GROUP BY club
ORDER BY player_number DESC LIMIT 5

--#which club has the most goals
SELECT club, SUM(goals) as num_goal FROM EPL_20_21
GROUP BY club
ORDER BY num_goal DESC LIMIT 5

--#which club has the most goals and assists
SELECT club, SUM(goals) as num_goal, SUM(assists) as num_assist FROM EPL_20_21
GROUP BY club
ORDER BY num_goal DESC LIMIT 5

--most goal scored by a player

SELECT Name, goals FROM EPL_20_21
ORDER by goals DESC LIMIT 5

--6. player with most penalty goals
SELECT Name, penalty_goals FROM EPL_20_21
ORDER by penalty_goals DESC LIMIT 5

--5. player with most assist.

SELECT Name, assists FROM EPL_20_21
ORDER by goals DESC LIMIT 5

--whih player played the most matches

SELECT Name, matches as matchees,goals FROM EPL_20_21
ORDER by matchees DESC LIMIT 5

--#most yello card by club
SELECT club, SUM(yellow_cards) as yello FROM EPL_20_21
GROUP BY club
ORDER by yello DESC LIMIT 5


--#most red card by club
SELECT club, SUM(red_cards) as red FROM EPL_20_21
GROUP BY club
ORDER by red DESC LIMIT 5

--#avg age of the players of the club
SELECT club,name,avg(age) as avg_age FROM EPL_20_21
GROUP by club
ORDER BY avg_age DESC LIMIT 5

--how many players in a club whos age is below 25

SELECT club, COUNT(name) as a  FROM EPL_20_21
WHERE age<25 
GROUP by club
ORDER BY a DESC LIMIT 5

--how many players in a club whos age is above 25

SELECT club, COUNT(name) as aa  FROM EPL_20_21
WHERE age>25 
GROUP by club
ORDER BY aa DESC LIMIT 5


---dividing players age into brackets

SELECT name, age,
CASE WHEN age > 35 THEN 'Old Aged Player'
WHEn age BETWEEN 25 and 35 THEN 'Middle Aged Player' 
ELSE 'Young Aged Player'
END as age_braket FROM EPL_20_21
ORDER by age DESC

---top goal scorer position

SELECT name, position, goals FROM EPL_20_21
ORDER by goals DESC LIMIT 10


--Key insights:
--1. clubs with most players
--2. clubs with most goals
--3. clubs with most red/yello card
--4. most valueable player
--5. player with most assist.
--6. player with most penalty goals
--7. position of the top scoere
--8. avg age of the players of each club