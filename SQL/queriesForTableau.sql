-- Covid 19 project. Queries to use when loading data in Tableau

-- Complete table of interest without the continents/world as locations
select dea.continent, dea.location, dea.date, dea.population, total_cases, cast(total_deaths as int) as total_deaths, new_cases, cast(new_deaths as int) as new_deaths,(cast(total_deaths as int)/total_cases)*100 as death_rate, cast(new_vaccinations as int) as new_vaccinations,cast(people_vaccinated as float) as people_vaccinated, cast(people_fully_vaccinated as float) as people_fully_vaccinated, (people_vaccinated/dea.population)*100 as percentage_people_vaccinated, (people_fully_vaccinated/dea.population)*100 as percentage_people_fully_vaccinated
from CovidProject..CovidVaccinations as vac
	join CovidProject..CovidDeaths as dea
	on vac.date = dea.date
	and vac.location = dea.location
where dea.continent is not null
order by dea.location,dea.date

-- Complete table of interest globally
select dea.date, dea.population, total_cases, new_cases, cast(new_deaths as int) as new_deaths, cast(total_deaths as int) as total_deaths, (cast(total_deaths as int)/total_cases)*100 as death_rate, cast(people_vaccinated as float) as people_vaccinated, cast(new_vaccinations as int) as new_vaccinations,cast(people_fully_vaccinated as float) as people_fully_vaccinated, (people_vaccinated/dea.population)*100 as percentage_people_vaccinated, (people_fully_vaccinated/dea.population)*100 as percentage_people_fully_vaccinated
from CovidProject..CovidVaccinations as vac
	join CovidProject..CovidDeaths as dea
	on vac.date = dea.date
	and vac.location = dea.location
where dea.location like 'world'
order by dea.location,dea.date
