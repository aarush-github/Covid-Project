/*
Queries used for Tableau Project
*/

--1
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From `googel-342016.Covid_Deaths.Covid_Death`
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2;

--2
Select location, Sum(cast(new_deaths as int)) as TotalDeathCount
From `googel-342016.Covid_Deaths.Covid_Death`
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc;

--3
select location, Max(total_cases) as HighestInfection, population, 
 MAX((total_cases/population)*100) as TotalInfectedPercentage 
 FROM `googel-342016.Covid_Deaths.Covid_Death`
group by location, population
order by TotalInfectedPercentage  desc;

--4
select location, date,  Max(total_cases) as HighestInfection, population, 
 MAX((total_cases/population)*100) as TotalInfectedPercentage 
 FROM `googel-342016.Covid_Deaths.Covid_Death`
group by location, population, date
order by TotalInfectedPercentage  desc;
