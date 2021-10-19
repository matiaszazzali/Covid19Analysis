-- Covid 19 project. Queries to use when loading data in Tableau

-- Complete cases/deaths table of interest without the continents/world as locations
select continent, location, date, population, total_cases, cast(total_deaths as int) as total_deaths,(total_deaths)/population*100 as death_rate
from CovidProject..CovidDeaths
where continent is not NULL
order by continent, location,date

-- Complete vaccinations table of interest without the continents/world as locations
select dea.continent, dea.location, dea.date, dea.population, cast(people_vaccinated as float) as people_vaccinated, cast(people_fully_vaccinated as float) as people_fully_vaccinated, (people_vaccinated/dea.population)*100 as percentage_people_vaccinated, (people_fully_vaccinated/dea.population)*100 as percentage_people_fully_vaccinated
from CovidProject..CovidVaccinations as vac
	join CovidProject..CovidDeaths as dea
	on vac.date = dea.date
	and vac.location = dea.location
where dea.continent is not null
order by dea.location,dea.date

-- Complete cases/deaths table of interest globally
select location, population, date, total_cases, cast(total_deaths as int) as total_deaths, (total_deaths)/population*100 as death_rate
from CovidProject..CovidDeaths
where location like 'world'
order by continent, location,date

-- Complete vaccinations table of interest globally
select dea.location, dea.date, dea.population, cast(people_vaccinated as float) as people_vaccinated, cast(people_fully_vaccinated as float) as people_fully_vaccinated, (people_vaccinated/dea.population)*100 as percentage_people_vaccinated, (people_fully_vaccinated/dea.population)*100 as percentage_people_fully_vaccinated
from CovidProject..CovidVaccinations as vac
	join CovidProject..CovidDeaths as dea
	on vac.date = dea.date
	and vac.location = dea.location
where dea.location like 'world'
order by dea.location,dea.date
