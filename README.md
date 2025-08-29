# global_layoffs_sql_analysis
## Project Overview
This project explores global layoffs data using SQL only.
The goal is to clean, standardize, and analyze the dataset to uncover layoff trends across multiple companies, industries, and countries.
I used SQL to detect and fix data quality issues (nulls, blanks, duplicates, inconsistent formats), standardize fields (dates, text, percentages), build queries to understand patterns over time, industry behavior, company rankings, and much more.

### Data & Schema
Source: ([AlexTheAnalyst](https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv))

### Tools & Requirements

Database: MySQL 8.x

Workbench: MySQL Workbench (Safe Updates mode ON by default)

*This project is divided into two parts: Data Cleaning and Exploratory Data Analysis, contained in 2 separate files*

### Import & Setup
To import the dataset into MySQL Workbench, I first created a database with the query:

CREATE DATABASE Portfolioproject;

Then, right-click on the new database and follow the "Data Table Import Wizard" steps to import your dataset into MySQL Workbench.

### Data Cleaning
Before making any changes to the dataset, I made a copy of my original by creating a table and inserting the values in the original dataset into the new table.

Data cleaning steps included:
- Checking for duplicates and removing them (making sure to keep at least one copy of the values!)
- Standardizing the data by checking for inconsistencies like "Crypto" and "Cryptocurrency"
- Trimming for whitespaces and checking for Null values
- Formatting the date column using the str_to_date(date, '%m/%d/%Y') function.
- Removing unnecessary columns and rows

### Exploratory Data Analysis
EDA involved querying the data to answer these questions:
- Companies with the biggest single layoff
- Total layoffs by company, country, industry, location, and year. I went on to 'order' in descending order and 'limit' to show the top values at a time.
- Using a common table expression (CTE), I compared companies with the highest number of layoffs per year.
- Layoff trends over time
- Total layoffs per month

### Results
The top five companies with the largest single layoff events are Google, Meta, Microsoft, Amazon, and Ericsson.
Google leads the pack with a staggering 12,000 employees laid off in one round.

However, when looking at total layoffs across all events, Amazon tops the list with 18,150 employees laid off overall.

