CREATE DATABASE PortfolioProject;

SELECT *
FROM layoffs;

-- create a copy of original table, incase something happens
CREATE TABLE layoffs_copy
LIKE layoffs;

INSERT layoffs_copy
SELECT * FROM layoffs;

SELECT *
FROM layoffs_copy;

-- Data Cleaning
-- Step 1: Check for duplicates and remove any

SELECT *
FROM
	(SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM 
		layoffs_copy) AS duplicates
       WHERE row_num > 1 ;
       
SELECT company, industry, total_laid_off, date, location, stage, country, funds_raised_millions, percentage_laid_off,
COUNT(*) AS row_num
FROM layoffs_copy
GROUP BY company, industry, total_laid_off, date, location, stage, country, funds_raised_millions, percentage_laid_off
HAVING COUNT(*) > 1;

SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		layoffs_copy
) duplicates
WHERE 
	row_num > 1;
    
-- delete duplicate rows
-- to be able to delete duplicates, while still keeping one copy of the values, I will create a Unique ID for my table, in a new column

ALTER TABLE layoffs_copy 
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

SELECT *
FROM layoffs_copy;

SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		layoffs_copy
) duplicates
WHERE 
	row_num > 1;
    
SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY company, industry, total_laid_off, date, location, stage, country, funds_raised_millions, percentage_laid_off
           ORDER BY id
         ) AS row_num
  FROM layoffs_copy
) ranked
WHERE row_num > 1;

-- I'll use a CTE to delete the duplicates
WITH duplicate_cte AS (
  SELECT 
    id,
    ROW_NUMBER() OVER (
      PARTITION BY company, industry, total_laid_off, `date`, location, stage, country, funds_raised_millions, percentage_laid_off
      ORDER BY id
    ) AS row_num
  FROM layoffs_copy
  )
DELETE FROM layoffs_copy
 WHERE id IN (
  SELECT id
  FROM duplicate_cte
  WHERE row_num > 1
 );

SET SQL_SAFE_UPDATES = 1;

-- Standardize Table
SELECT *
FROM layoffs_copy;

SELECT DISTINCT industry
FROM layoffs_copy
ORDER BY 1;

SELECT *
FROM layoffs_copy
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_copy
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_copy
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

UPDATE layoffs_copy
SET industry = NULL
WHERE industry = '';

SELECT company, trim(company)
FROM layoffs_copy;

UPDATE layoffs_copy
SET company = trim(company);

SET SQL_SAFE_UPDATES = 0;

SELECT DISTINCT country
FROM layoffs_copy
WHERE country LIKE 'United State%';

UPDATE layoffs_copy
SET country = 'United States'
WHERE country LIKE 'United State%';

-- format date column
SELECT date,
str_to_date(date, '%m/%d/%Y') AS clean_date
FROM layoffs_copy;

UPDATE layoffs_copy
SET date = str_to_date(date, '%m/%d/%Y');

SELECT date
FROM layoffs_copy;

ALTER TABLE layoffs_copy
MODIFY COLUMN date DATE;

-- remove unnecessary columns and rows
SELECT *
FROM layoffs_copy
WHERE total_laid_off IS NULL
OR percentage_laid_off IS NULL;

SELECT *
FROM layoffs_copy
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM layoffs_copy
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_copy;
