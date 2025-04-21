-- Exploratory Data Analysis
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