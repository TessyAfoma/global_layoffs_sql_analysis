-- layoffs EDA
SELECT *
FROM layoffs_copy;

SELECT max(total_laid_off), min(total_laid_off)
FROM layoffs_copy
WHERE total_laid_off IS NOT NULL;

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_copy
WHERE  percentage_laid_off IS NOT NULL;

SELECT *
FROM layoffs_copy
WHERE percentage_laid_off = 1;

SELECT *
FROM layoffs_copy
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Top 5 Companies with the biggest single layoffs
SELECT company, total_laid_off
FROM layoffs_copy
ORDER BY 2 DESC
LIMIT 5;

-- Top 5 with highest Total layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_copy
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- By location
SELECT location, SUM(total_laid_off)
FROM layoffs_copy
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- By country
SELECT country, SUM(total_laid_off)
FROM layoffs_copy
GROUP BY country
ORDER BY 2 DESC
LIMIT 10;

-- By year
SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_copy
GROUP BY YEAR(date)
ORDER BY 1 ASC;

-- By industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_copy
GROUP BY industry
ORDER BY 2 DESC
LIMIT 10;

-- use CTE to compare companies with the most layoffs per year

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_copy
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS
(  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- compare total layoffs per month
SELECT SUBSTRING(date,1,7) AS dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy
GROUP BY dates
ORDER BY dates ASC;

-- use CTE to calculate the rolling total of layoffs over time
WITH DATE_CTE AS
(SELECT SUBSTRING(date,1,7) AS dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates  ASC;