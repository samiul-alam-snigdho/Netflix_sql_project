-- Netflix project
drop Table if exists netflix; 
Create Table  netflix
(
	show_id    VARCHAR(6),
	type       varchar(10),  
	title      varchar(150),
	director   VARCHAR(209),
	casts       varchar(1000),
	country    varchar(150),
	date_added   varchar(50),
	release_year int,
	rating       varchar(10), 
	duration     varchar(15),
	listed_in    varchar(100),
	description  varchar(250)
);

select * from netflix;

select 
	count(*) as total_content
from netflix;	

select 
	distinct type 
from netflix;	




--1. count the number of movies vs tv shows

select 
	type,
	count(*) as total_content
from netflix
GROUP BY TYPE;

-- 2. find the most common rating for movies and tv shows 
select 
	type,
	rating,
	count(*),
	RANK() OVER(PARTITION BY type  ORDER BY COUNT(*) DESC) as ranking 
from netflix	
	GROUP BY 1,2;


-- 3. List all movies released in a specific year (e.g. 2020)

select * from netflix
WHERE 
	 type = 'Movie'
	 AND
	 release_year= 2020;

-- 4 Find the top 5 countries with the most content on netflix

select 
	  unnest (String_to_array(country,',')) as new_country,
	  count(show_id) as total_count
from netflix
Group By 1
order by 2 desc 
limit 5 ;

	
-- 5.Identify the longest movie?
select * from netflix
where 
	type = 'Movie'
	AND
	duration = (select max(duration )from netflix);
-- 6.Find content added in the last 5  years 

select 
*
from netflix
where 
	TO_DATE(date_added, 'Month DD, YYYY' ) >= current_date - Interval '5 years';
	
-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
select * from netflix
where 
director ILike '%Rajib chilaka%';

--8. List All TV Shows with More Than 5 Seasons
select * from netflix
where 
	type = 'TV Show'
	AND
	Split_part(duration ,' ', 1):: INT >5;

--9. Count the Number of Content Items in Each Genre
select 
	unnest(string_to_array(listed_in , ',')) as genre,
	count(*) as total_content
 from netflix
 Group by 1;

--10. List All Movies that are Documentaries
select * from netflix
where
	listed_in like '%Documentaries';

--11. Find All Content Without a Director
select * from netflix
where
	director is NULL;

--12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
select * from netflix
where
	casts ilike '%Salman Khan%'
	AND
	release_year> Extract(year from current_date) - 10;

--13. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
	
select 
	unnest(string_to_array(casts, ',')) as actor,
	count(*)
from netflix
where country ilike '%INDIA%'
group by 1
order by 2 desc
limit 10;

--14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
with new_table
As(
select 
*,
	case
	when 
		description ilike '%kills%' or
		description ilike '%violence%' then 'Bad content'
		else 'good content'
	end category
from netflix	
)
select 
	category,
	count(*) as total_content
from new_table
group by 1
order by 2 desc

	

