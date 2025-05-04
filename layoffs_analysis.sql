-- ==========================================
-- Project: World Layoffs Dataset
-- Phase 1: Data Cleaning & Preprocessing
-- ==========================================

 use world_layofffs;

select * from layoffs;
-- REMOVE DUPLICATES...
create  table layoffs1 like layoffs;

select * from layoffs1;

insert into layoffs1 
select * from layoffs;

with  duplicate_rows as 
(select  *, row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,'date', stage,country,funds_raised_millions)
as row_num from layoffs1)
select * from duplicate_rows   
where row_num>1;


 CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` bigint DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` bigint DEFAULT NULL,
    `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs2;

insert into layoffs2
select  *, row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,'date', stage,country,funds_raised_millions)
as row_num from layoffs1;

 delete from layoffs2
 where row_num>1;

-- STANDARDIZED THE DATA...
 select * from layoffs2;
 select distinct country 
 from layoffs2
 order by 1;

 select distinct country, trim(TRAILING '.' FROM country)
 FROM LAYOFFS2
 ORDER BY 1;

UPDATE layoffs2
set country=trim(TRAILING '.' FROM country) 
where country like 'united states%';


select distinct company,trim(company)
from layoffs2;
update layoffs2
set company=trim(company);
   
   
   
select * from layoffs2
where industry like 'Crypto%';

update layoffs2
set industry='Crypto'
where industry like 'Crypto%';


select `date` ,str_to_date(`date`,'%m/%d/%Y')
from layoffs2;

UPDATE layoffs2
set `date`=str_to_date(`date`,'%m/%d/%Y');

Alter table layoffs2
MODIFY COLUMN `date`DATE;

-- HANDLE NULL VALUES OR BLANK VALUES...

select * from layoffs2
where total_laid_off is null and
percentage_laid_off is null;
 
UPDATE layoffs2
set industry=null
where industry='';
 
select * from layoffs2
where industry is null 
or industry='';
select * from layoffs2
where company ='Airbnb';

select t1.industry,t2.industry from layoffs2 t1
join layoffs2 t2
   on t1.company=t2.company and
   t1.location=t2.location
where (t1.industry is null or t1.industry='')   
and t2.industry  is not null;

UPDATE layoffs2 t1
join layoffs2 t2
   on t1.company=t2.company 
   SET t1.industry=t2.industry
where t1.industry is null  
and t2.industry  is not null;

Delete  
from layoffs2
where total_laid_off is null and
percentage_laid_off is null;

select * from layoffs2;

-- REOMOVE EXTRA COLOUMN...
Alter Table layoffs2
Drop Column row_num;


-- ==========================================
-- Phase 2: Exploratory Data Analysis (EDA)
-- ==========================================

use world_layofffs;
select * from layoffs2;
 
select MAX(total_laid_off), MAX(percentage_laid_off) 
from layoffs2;             

select * from layoffs2
where percentage_laid_off=1
order by funds_raised_millions desc;

select company,SUM(total_laid_off) as totallaidoff 
from layoffs 
group by company
order by 2 desc;

select MIN(`date`), MAX(`date`) 
from layoffs2;

select YEAR(`date`),SUM(total_laid_off) as totallaidoff 
from layoffs2 
group by  YEAR(`date`)
order by 1 desc;


select stage,SUM(total_laid_off) as totallaidoff 
from layoffs 
group by stage
order by 2 desc;



select SUBSTRING(`date`,1,7) as `MONTH`,  SUM(total_laid_off) as totoallaidoff
from layoffs2
where SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY  `MONTH`
ORDER BY 1;

WITH ROLLING_TOTAL  AS (
select SUBSTRING(`date`,1,7) as `MONTH`,  SUM(total_laid_off) as totoallaidoff
from layoffs2
where SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY  `MONTH`
ORDER BY 1
)





select `MONTH`,totoallaidoff,
SUM(totoallaidoff) OVER(ORDER BY `MONTH`) AS rolling_total
FROM ROLLING_TOTAL;

select company,YEAR(`date`),SUM(total_laid_off) as totoallaidoff
from layoffs2
group by company,YEAR(`date`)
order by 3 desc;

with COMPANY_YEAR (company,years,total_laid_off) AS(
select company,YEAR(`date`),SUM(total_laid_off) as totoallaidoff
from layoffs2
group by company,YEAR(`date`)
), COMPANY_YEAR_RANK AS (
select *,DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS RANKING
from COMPANY_YEAR
where years IS NOT NULL)
SELECT * FROM COMPANY_YEAR_RANK 
WHERE RANKING<=5;
