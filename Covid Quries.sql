/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT * FROM `googel-342016.Covid_Deaths.Covid_Death`
order by 3,4
Limit 1000;

#Slecting the data that we are going to Start with
SELECT location, date, total_cases, new_cases,total_deaths, population
 FROM `googel-342016.Covid_Deaths.Covid_Death`
order by 1,2;

 #Looking at total_cases vs total_deaths of India
 SELECT location, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathPercentage
 FROM  `googel-342016.Covid_Deaths.Covid_Death`
 where location = "India"
order by 1,2;

 #Looking at Total cases vs Population of India
 #shows what percentage of population got covid
 select location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage 
 FROM `googel-342016.Covid_Deaths.Covid_Death`
 where location = "India"
order by 1,2; 
#Looking at countries with highest Infection rate compated to population
 select location, Max(total_cases) as HighestInfection, population, 
 MAX((total_cases/population)*100) as TotalInfectedPercentage 
 FROM `googel-342016.Covid_Deaths.Covid_Death`
group by location, population
order by TotalInfectedPercentage  desc;

#showing countries with hightest death count
 select location, Max(cast(total_deaths as int)) as Totaldeathcount
 FROM `googel-342016.Covid_Deaths.Covid_Death`
 where continent is not null
group by location
order by Totaldeathcount desc;

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From `googel-342016.Covid_Deaths.Covid_Death`
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc;

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From `googel-342016.Covid_Deaths.Covid_Death`
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From `googel-342016.Covid_Deaths.Covid_Death` as dea
Join `googel-342016.Covid_Deaths.covid_vaccination` as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;

create or replace table `googel-342016.Covid_Deaths.RollingPeopleVaccinated`
(Continent String(255),
Location String(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric);
insert into  `googel-342016.Covid_Deaths.RollingPeopleVaccinated`
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From `googel-342016.Covid_Deaths.Covid_Death`as dea
Join `googel-342016.Covid_Deaths.covid_vaccination` as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null ;
--order by 2,3;
select*, (RollingPeopleVaccinated/population)*100 as vaccinated_percentage
from  `googel-342016.Covid_Deaths.RollingPeopleVaccinated` ;
 
 -- Creating view to store data for later visualisation

 create view if not exists `googel-342016.Covid_Deaths.PercentPopulationVaccinated` as
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From `googel-342016.Covid_Deaths.Covid_Death` as dea
Join `googel-342016.Covid_Deaths.covid_vaccination` as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;

create view if not exists `googel-342016.Covid_Deaths.globalnumbers` as
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From `googel-342016.Covid_Deaths.Covid_Death`
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc;

create view if not exists `googel-342016.Covid_Deaths.Infection_Rate` as 
 select location, Max(total_cases) as HighestInfection, population, 
 MAX((total_cases/population)*100) as TotalInfectedPercentage 
 FROM `googel-342016.Covid_Deaths.Covid_Death`
group by location, population
order by TotalInfectedPercentage  desc;
