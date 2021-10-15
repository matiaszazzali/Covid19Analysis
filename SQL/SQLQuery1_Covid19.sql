SELECT *
FROM CovidProject..CovidDeaths
where continent is not null
ORDER BY 3,4

-- Select the data that I'm going to use
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidProject..CovidDeaths
where continent is not null
ORDER BY location, date

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if contracting covid
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate
FROM CovidProject..CovidDeaths
WHERE location like '%argentina%'
ORDER BY location, date


-- Looking at total cases vs population
-- Shows what percentage of population got covid
SELECT location, date, population,total_cases, (total_cases/population)*100 as percent_population_infected 
FROM CovidProject..CovidDeaths
WHERE location like '%argentina%'
ORDER BY location, date

-- Looking at countries with the highest infection rates compared to population
SELECT location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as percent_population_infected 
FROM CovidProject..CovidDeaths
where continent is not null
GROUP BY location, population
ORDER BY percent_population_infected DESC

-- Showing the countries with the highest death count per population
SELECT location, max(cast(total_deaths as int)) as total_death_count
From CovidProject..CovidDeaths
where continent is not null
group by location
Order by total_death_count desc

-- Showing amount of deaths by continent
SELECT location, max(cast(total_deaths as int)) as total_death_count
From CovidProject..CovidDeaths
where continent is null
group by location
Order by total_death_count desc

-- Showing current death percentage globally
SELECT location,
		max(date) as date,
		max(total_cases) as total_cases, 
		max(cast(total_deaths as int)) as total_deaths,
		(max(cast(total_deaths as int))/max(total_cases))*100 as death_percentage
FROM CovidProject..CovidDeaths
WHERE location like '%World%'
group by location


-- Looking at rolling vaccination sum
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location 
												order by dea.location, dea.date) as total_vaccinations
FROM CovidProject..CovidDeaths AS dea
JOIN CovidProject..CovidVaccinations AS vac
	on dea.location = vac.location 
	and dea.date=vac.date
WHERE dea.continent is not null
ORDER BY dea.location, dea.date

-- Using a CTE to look at vaccinations vs population
with PopvsVac (continent,location,date,population,new_vaccinations,total_vaccinations)
as(
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location 
													order by dea.location, dea.date) as total_vaccinations
	FROM CovidProject..CovidDeaths AS dea
	JOIN CovidProject..CovidVaccinations AS vac
		on dea.location = vac.location 
		and dea.date=vac.date
	WHERE dea.continent is not null
)
SELECT *,(total_vaccinations/population)*100 as vaccination_percentage
FROM PopvsVac
ORDER BY location, date


-- Creating View to store date for later visualization

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location 
												order by dea.location, dea.date) as total_vaccinations
FROM CovidProject..CovidDeaths AS dea
JOIN CovidProject..CovidVaccinations AS vac
	on dea.location = vac.location 
	and dea.date=vac.date
WHERE dea.continent is not null


