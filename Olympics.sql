
-------------------------------------------------------------------120 YEARS OF OLYMPIC HISTORY : ATHLETES AND RESULTS
	
---------basic bio data on athletes and medal results from Athens 1896 to Rio 2016

---------This is a historical dataset on the modern Olympic Games, including all the Games from Athens 1896 to Rio 2016.

---------https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results

---------Dataset: https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results/download
	
---------Having this DATASET, I'll do some queries to practice my SQL skills, answering below 20 questions

----------------------------------------------------List of all these 20 queries mentioned below:
---1. How many olympics games have been held?
---2 List down all Olympics games held so far.
---3 Mention the total no of nations who participated in each olympics game?
---4 Which year saw the highest and lowest no of countries participating in olympics?
---5 Which nation has participated in all of the olympic games?
---6 Identify the sport which was played in all summer olympics.
---7 Which Sports were just played only once in the olympics?
---8 Fetch the total no of sports played in each olympic games.
---9 Fetch details of the oldest athletes to win a gold medal.
---10 Find the Ratio of male and female athletes participated in all olympic games.
---11 Fetch the top 5 athletes who have won the most gold medals.
---12 Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
---13 Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
---14 List down total gold, silver and broze medals won by each country.
---15 List down total gold, silver and broze medals won by each country corresponding to each olympic games.
---16 Identify which country won the most gold, most silver and most bronze medals in each olympic games.
---17 Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
---18 Which countries have never won gold medal but have won silver/bronze medals?
---19 In which Sport/event, India has won highest medals.
---20 Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.


---Identify the sport which was played in all summer olympics.

-------------   1. How many olympics games have been held?
select COUNT(distinct(games)) as TotalGames
from Olympics..athlete_event 



select COUNT(distinct(games)) as TotalGames
from Olympics..athlete_event 
where Season='Summer'

---------------- 2. List down all Olympics games held so far.
select distinct games
from Olympics..athlete_event 


----3. Mention the total no of nations who participated in each olympics game?

select distinct games, NOC
from Olympics..athlete_event
group by Games, NOC
order by Games

									-----BOTH ARE OK
select Games, nr.region
from Olympics..athlete_event Oae
join Olympics..noc_region nr on Oae.NOC=nr.NOC
group by Games, (nr.region)

------------  BUT WE WANT A NUMBER 

with howmany as 
	(select Games, nr.region
	from Olympics..athlete_event Oae
	join Olympics..noc_region nr on Oae.NOC=nr.NOC
	group by Games, (nr.region)
	)
select games, COUNT(1) as Total --COUNT(1) is used as a shorthand for counting the number of rows in a table or a result set
from howmany
group by Games
----------------------------OR

with howmany as
	(select distinct games, NOC
	from Olympics..athlete_event
	)
select games, COUNT(1) as Countries
from howmany
group by games
order by games


-- 4. Which year saw the highest and lowest no of countries participating 


with howmany as 
	(select Games, nr.region
	from Olympics..athlete_event Oae
	join Olympics..noc_region nr on Oae.NOC=nr.NOC
	group by Games, (nr.region)
	),
	totales as 
	(select games, COUNT(1) as Total --COUNT(1) is used as a shorthand for counting the number of rows in a table or a result set
	from howmany
	group by Games)
select games, Total,Qty
from 
	(select top 1 games,Total, 'Lowest' as Qty
	from totales
	order by Total
	union all
	select top 1 games,Total, 'Highest' as Qty
	from totales
	order by Total desc
	) as FirstLast

order by Total



---5. Which nation has participated in all of the olympic games

select  count(distinct Games) as TotalGames
from Olympics..athlete_event


select  distinct games, NOC
from Olympics..athlete_event
group by Games,NOC
order by Games


with howmany as
	(select distinct games, NOC
	from Olympics..athlete_event
	--group by Games, NOC
	--order by Games
	)
select NOC, COUNT(1) as Participations
from howmany
group by NOC
having COUNT(1)=51
order by NOC



---6. Identify the sport which was played in all summer olympics.

select  distinct games, Sport
from Olympics..athlete_event
where Season='Summer'
group by Games,Sport
order by Games


with howmany as
	(select distinct games, Sport
	from Olympics..athlete_event
	where Season='Summer'
	)
select top 10 Sport, COUNT(1) as Participations
from howmany
group by Sport
order by  Participations desc, Sport



--7. Which Sports were just played only once in the olympics.

with howmany as
	(select distinct games, Sport
	from Olympics..athlete_event
	--where Season='Summer'
	)
select  Sport, COUNT(1) as Participations
from howmany
group by Sport
having COUNT(1)=1
order by  Participations , Sport



with howmany as
	(select distinct games, Sport
	from Olympics..athlete_event
	),
	Veces as
	(select Sport, count(1) as NoPres
	from howmany
	group by Sport
	)
select Veces.*, howmany.Games
from Veces
join howmany on howmany.Sport=Veces.Sport
where Veces.NoPres = 1
order by howmany.Sport




---8. Fetch the total no of sports played in each olympic games.


with howmany as
	(select distinct games, Sport
	from Olympics..athlete_event
	)
	select Games , COUNT(1) as Qty
	from howmany
	group by Games
	order by Games



--- 9. Fetch oldest athletes to win a gold medal

select Top 20 Name, Age
from Olympics..athlete_event
where Medal='Gold'
order by  Age desc



---10. Find the Ratio of male and female athletes participated in games.

SELECT 
	SUM(CASE WHEN Sex='M' THEN 1 ELSE 0 END) AS MaleCount,
	SUM(CASE WHEN Sex='F' THEN 1 ELSE 0 END) AS FemaleCount,
	ROUND(CAST(SUM(CASE WHEN Sex='M' THEN 1 ELSE 0 END) AS FLOAT) / SUM(CASE WHEN Sex='F' THEN 1 ELSE 0 END), 2) AS SexRatio
FROM Olympics..athlete_event



----11. Fetch the top 5 athletes who have won the most gold medals.


select Top 5 Name, COUNT(1) as Medals
	from Olympics..athlete_event
	where Medal<>'NA' and Medal in ('Gold')
	group by Name
	order by Medals desc



------12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).


select Top 5 Name, COUNT(1) as Medals
	from Olympics..athlete_event
	where Medal<>'NA' and Medal in ('Gold','Silver', 'Bronze' )
	group by Name
	order by Medals desc


----13. Fetch the top 5 most qty of medals won.

select Top 5 NOC, COUNT(1) as Medals
	from Olympics..athlete_event
	where Medal<>'NA' and Medal in ('Gold','Silver', 'Bronze' )
	group by NOC
	order by Medals desc



--14. List down total gold, silver and bronze medals won by each country.



select  NOC,
	 SUM(CASE WHEN Medal='Gold' THEN 1 ELSE 0 END) AS Gold,
	 SUM(CASE WHEN Medal='Silver' THEN 1 ELSE 0 END) AS Silver,
	 SUM(CASE WHEN Medal='Bronze' THEN 1 ELSE 0 END) AS Bronze
from Olympics..athlete_event 
group by  NOC
ORDER BY Gold desc, Silver desc, Bronze desc



--15. List down total gold, silver and bronze medals won by each country & Game


select Games, NOC,
	 SUM(CASE WHEN Medal='Gold' THEN 1 ELSE 0 END) AS Gold,
	 SUM(CASE WHEN Medal='Silver' THEN 1 ELSE 0 END) AS Silver,
	 SUM(CASE WHEN Medal='Bronze' THEN 1 ELSE 0 END) AS Bronze
from Olympics..athlete_event 
group by Games, NOC
ORDER BY Games


--16. Which country won most gold, silver and bronze medals in each games.

WITH A AS (
  SELECT Games, NOC,
         SUM(CASE WHEN Medal='Gold' THEN 1 ELSE 0 END) AS Gold,
         SUM(CASE WHEN Medal='Silver' THEN 1 ELSE 0 END) AS Silver,
         SUM(CASE WHEN Medal='Bronze' THEN 1 ELSE 0 END) AS Bronze
  FROM Olympics..athlete_event 
  GROUP BY Games, NOC
)
SELECT Games, NOC, Maxgold
FROM (
  SELECT *,
         MAX(Gold) OVER (PARTITION BY Games) AS Maxgold
  FROM A
) AS T
WHERE Gold = Maxgold;

--------------------------------------------------------


WITH A AS (
  SELECT Games, ae.NOC, region,
         SUM(CASE WHEN Medal='Gold' THEN 1 ELSE 0 END) AS Gold,
         SUM(CASE WHEN Medal='Silver' THEN 1 ELSE 0 END) AS Silver,
         SUM(CASE WHEN Medal='Bronze' THEN 1 ELSE 0 END) AS Bronze
  FROM Olympics..athlete_event ae
  join Olympics..noc_region noc on ae.NOC=noc.NOC 
  GROUP BY Games, region,ae.NOC
  ),
T1 as
	(SELECT Games,CONCAT(region, '-' ,Maxgoldie) as CountryMaxGold
	FROM (
	SELECT *,MAX(Gold) OVER (PARTITION BY games) AS Maxgoldie
	FROM A
	) AS T
WHERE (Gold = Maxgoldie) 
),
T2 as
	(SELECT Games,CONCAT(region, '-' ,MaxSilverie) as CountryMaxSilver
	FROM (
	SELECT *,
		 MAX(Silver) OVER (PARTITION BY games) AS MaxSilverie
		 
	FROM A
	) AS T2
WHERE (Silver = MaxSilverie) 
),
T3 as
	(SELECT Games,CONCAT(region, '-' ,MaxBronze) as CountryMaxBonze
	FROM (
		  SELECT *, MAX(Bronze) OVER (PARTITION BY games) AS MaxBronze
		  FROM A
		) 
	AS T3
WHERE (Bronze = MaxBronze) 
)
select T3.Games,CountryMaxGold,CountryMaxSilver,CountryMaxBonze
from T3
join T2 on T3.Games=T2.Games 
join T1 on T1.Games=T3.Games;

--17. Most Total Medal winner per games.


WITH A AS (
  SELECT Games, ae.NOC, region, 
		 SUM(CASE WHEN Medal='Gold' THEN 1 ELSE 0 END) AS Gold,
         SUM(CASE WHEN Medal='Silver' THEN 1 ELSE 0 END) AS Silver,
         SUM(CASE WHEN Medal='Bronze' THEN 1 ELSE 0 END) AS Bronze
  FROM Olympics..athlete_event ae
  join Olympics..noc_region noc on ae.NOC=noc.NOC 
  GROUP BY Games, region,ae.NOC
  )
 ,
B as(
	SELECT *, (Gold + Silver + Bronze) as Suma,
		ROW_NUMBER() over (PARTITION by games order by (Gold + Silver + Bronze)desc) as rn
	FROM A 
	-- order by Suma desc
	)	
select Games, region, Suma
	from B
where rn=1



---18. Which countries have never won gold medal but have won silver/bronze medals?

SELECT
    noc.region,	
	SUM(CASE WHEN Medal='Gold' THEN 1 ELSE 0 END) AS Gold,
    SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
    SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze
FROM
    Olympics..athlete_event ae
	join Olympics..noc_region noc on ae.NOC=noc.NOC 
WHERE
    Medal IN ('Silver', 'Bronze')
    AND ae.NOC NOT IN (
        SELECT DISTINCT Noc
        FROM Olympics..athlete_event
        WHERE	Medal = 'Gold'
    )
GROUP BY noc.region , ae.NOC
order by noc.region 


--- 19. In which Sport/event, India has won highest medals.


with A as
	(
	 SELECT event,
			SUM(CASE WHEN Medal='Gold' THEN 1 ELSE 0 END) AS Gold,
			SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
			SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze
	 FROM Olympics..athlete_event ae
	 join Olympics..noc_region noc on ae.NOC=noc.NOC
	 where (region='India')
     group by Event
	 )
	,B as
	 (SELECT *, (Gold + Silver + Bronze) as Suma
	  FROM A 
	  )  	
select top 1 Event,  (MAX(Suma)) AS MaxSuma
from B
group by Event
order by MaxSuma desc

-------------------------
WITH A AS (
    SELECT event,
        SUM(CASE WHEN Medal IN ('Gold', 'Silver', 'Bronze') THEN 1 ELSE 0 END) AS Total
    FROM Olympics..athlete_event ae
        JOIN Olympics..noc_region noc ON ae.NOC = noc.NOC
    WHERE region = 'India'
    GROUP BY Event
	)
SELECT Top 1 Event, Total AS MaxSuma
FROM A
ORDER BY MaxSuma desc


--20. Break down all olympic games where India won medal for Hockey and how many medals in each olympic games

with A as
	(
	 SELECT Sport,Games,
			SUM(CASE WHEN Medal='Gold' THEN 1 ELSE 0 END) AS Gold,
			SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
			SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze
	 FROM Olympics..athlete_event ae
	 join Olympics..noc_region noc on ae.NOC=noc.NOC
	 where (Sport='Hockey' and region='India')
     group by Sport, Games
	 )
select Sport, Games, (Gold + Silver + Bronze) as Suma
from A
order by Suma desc



