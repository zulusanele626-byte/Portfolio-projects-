SELECT * 
FROM portfolioproject..CovidDeaths



--SELECT * 
--FROM portfolioproject..CovidVaccinations
--order by 3,4

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM portfolioproject..CovidDeaths
order by 1,2;


SELECT location,date,population, total_cases,(total_cases/population)*100as PercentagePopulationInfected 
FROM portfolioproject..CovidDeaths
where location like '%south africa%'
order by 1,2

SELECT location,population, max (total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentagePopulationInfected 
FROM portfolioproject..CovidDeaths
---where location like '%south africa%'
group by location, population
order by PercentagePopulationInfected desc

--showing the countries death count 

SELECT location, max (total_deaths ) as totalDeathCount
FROM portfolioproject..CovidDeaths
--where location like '%south africa%'
group by location
order by totalDeathCount  desc


SELECT location, max (cast(total_deaths as int)) as totalDeathCount
FROM portfolioproject..CovidDeaths
where location like '%south africa%'
group by location
--where continent is not null
order by totalDeathCount  desc


SELECT continent, max (cast(total_deaths as int)) as totalDeathCount
FROM portfolioproject..CovidDeaths
--where location like '%south africa%'
where continent is not null
group by continent 
order by totalDeathCount  desc


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert (int,vac.new_vaccinations ))over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccination,
---(rollingpeoplevaccinated/population)*100
from Portfolioproject..covidDeaths dea
join portfolioproject..covidvaccinations  vac
             on dea.location =vac.location
			 and dea.date = vac.date 
where dea.continent is not null
 order by 1,2,3


 with popvsvac (continent, location,date,population,new_vaccinations, rollingpeoplevaccinated)
 as
 (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert (int,vac.new_vaccinations ))over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
---(rollingpeoplevaccinated/population)*100
from Portfolioproject..covidDeaths dea
join portfolioproject..covidvaccinations  vac
             on dea.location =vac.location
			 and dea.date = vac.date 
where dea.continent is not null
---order by 1,2,3
)

drop table if exists #percentpopultionvaccinated 
create table #percentpopultionvaccinated 
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)
insert into #percentpopultionvaccinated 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert (int,vac.new_vaccinations ))over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
---(rollingpeoplevaccinated/population)*100
from Portfolioproject..covidDeaths dea
join portfolioproject..covidvaccinations  vac
             on dea.location =vac.location
			 and dea.date = vac.date 
--where dea.continent is not null
---order by 1,2,3
select*, (rollingpeoplevaccinated/population)*100
from #percentpopultionvaccinated 


create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert (int,vac.new_vaccinations ))over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
---(rollingpeoplevaccinated/population)*100
from Portfolioproject..covidDeaths dea
join portfolioproject..covidvaccinations  vac
             on dea.location =vac.location
			 and dea.date = vac.date 
where dea.continent is not null
--order by 2,3

 select *
 from  PercentPopulationVaccinated
