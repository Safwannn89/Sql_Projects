#  World Layoffs Data Analysis Project

---

##  Project Overview

This project demonstrates comprehensive data cleaning and exploratory data analysis using SQL to analyze global layoff data. The project transforms raw, messy data into clean, standardized information and extracts meaningful business insights about layoff trends across companies, industries, and time periods.

---

##  Dataset Description

The dataset contains information about layoffs from companies worldwide, including:

- Company names and locations  
- Industry classifications  
- Number of employees laid off (total and percentage)  
- Dates of layoffs  
- Company funding stages  
- Countries and funds raised  

---

##  Project Structure

The project is divided into two main phases:

###  Phase 1: Data Cleaning & Preprocessing (`laysoff_cleaning.sql`)
Focuses on preparing raw data for analysis by addressing common data quality issues.

###  Phase 2: Exploratory Data Analysis (`laysoff_EDA.sql`)
Explores cleaned data to uncover patterns, trends, and insights about global layoff patterns.

---

##  Data Cleaning Process

###  Duplicate Removal
- Created a staging table (`layoffs1`)  
- Used `ROW_NUMBER()` to detect duplicates  
- Removed records with `row_num > 1` to ensure data integrity  

###  Data Standardization
- Used `TRIM()` to clean white spaces and periods in names  
- Standardized country, industry, and date formats using:

  ```sql
  TRIM(TRAILING '.' FROM country)
  STR_TO_DATE(date_column, '%m/%d/%Y')
  ```

###  Handling Null & Blank Values
- Converted empty strings to `NULL`  
- Recovered missing industry data using **self-joins**  
- Removed rows where both `total_laid_off` and `percentage_laid_off` were null  

###  Removing Temporary Columns
- Dropped `row_num` after duplicate cleanup to keep the dataset clean  

---

##  Exploratory Data Analysis

### Key Areas Explored:
- Companies with **maximum layoffs**  
- Companies with **100% layoffs (shutdowns)**  
- **Top ranked companies** by total layoffs  
- **Yearly and monthly** layoff trends  
- Patterns by **company stage** and **industry**  
- **Rolling sums** and `DENSE_RANK()` to track cumulative layoffs over time  

---

##  Technical Implementation

### SQL Techniques Used:

- **Window Functions**: `ROW_NUMBER()`, `DENSE_RANK()`, `SUM() OVER()`  
- **CTEs (Common Table Expressions)**: For modular queries  
- **Data Manipulation**: `UPDATE`, `ALTER TABLE`, string/date functions  
- **Joins**: Self-joins for data completion and conditional joins  

---

##  Key Insights Generated

- Identified the **most affected companies and industries**  
- Found **seasonal trends** in layoffs (monthly/yearly)  
- Explored the **impact of funding stages** on layoff severity  
- Highlighted companies consistently appearing in top layoff rankings  

---

##  Files in This Repository

| File Name       | Description                             |
|-----------------|-----------------------------------------|
| `laysoff_cleaning.sql` | Data cleaning and preprocessing scripts |
| `laysoff_EDA.sql` | Exploratory data analysis queries       |
| `README.md`     | This documentation file                 |

---

##  Usage Instructions

1. **Setup Database**  
   ```sql
   USE world_layofffs;
   ```

2. **Run Data Cleaning**  
   - Open `laysoff_cleaning.sql` in MySQL Workbench  
   - Execute queries sequentially  

3. **Perform Analysis**  
   - Open `laysoff_EDA.sql`  
   - Run queries to generate insights  

---

##  Learning Outcomes

You will gain hands-on experience in:

- Real-world **data quality assessment**  
- Advanced **SQL querying**  
- **Statistical analysis** using SQL  
- Turning data into **business intelligence**  
- Practical **database optimization**

---

##  Technical Requirements

- **MySQL** or compatible SQL database  
- Dataset with layoff info (company, location, industry, total_laid_off, percentage_laid_off,date, stage, country, funds_raised_millions)  

---

 *This project showcases the practical application of SQL for real-world data analysis challenges — demonstrating both technical proficiency and business insight generation.*
