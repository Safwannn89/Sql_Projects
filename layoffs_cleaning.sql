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
