--data we need it 
select *
from CovidDeaths$
order by 3,4


--lokaing at totalDeaths vs totalcases
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathprecentage 
from CovidDeaths$
where location like '%egypt%'  and  continent is not null

order by 1,2

--looking at total cases vs population 
select  location,date,total_cases,population,(total_cases/population) *100 as populationpercentage
from CovidDeaths$ 
where continent is not null
order by 1,2

--lokaing at countries with highest infection rate compare to population
select  location,population,max(total_cases) as highestinfectioncount,max((total_cases/population)) *100 as PerecentPopulationInfacted
from CovidDeaths$ 
where continent is not null
group by location ,population
order by PerecentPopulationInfacted  desc

---looking at contient with highest death count 
select continent,max(cast(total_deaths as int)) as HighestDeathCount 
from CovidDeaths$
where continent is  not null
group by continent
order by HighestDeathCount desc

---Golabl numbers
select date ,sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totalDeath, sum(cast(new_deaths as int))/ sum(new_cases)*100 as deathpercentage
from CovidDeaths$
where continent is not null
group by date
order by 1,2
----- join table vac 
select dea.continent,dea.location,dea.date,dea.population,cast(vac.new_vaccinations as bigint) as newVac , sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by
dea.location ,dea.date  ) as RollingPeopleVaccinated
from CovidDeaths$ as dea join CovidVac$ as vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3
---temp table

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location  nvarchar(255), 
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)
insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,cast(vac.new_vaccinations as bigint) as newVac , sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by
dea.location ,dea.date  ) as RollingPeopleVaccinated
from CovidDeaths$ as dea join CovidVac$ as vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3 

----creat view to store data for later visualizations
create view PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,cast(vac.new_vaccinations as bigint) as newVac , sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by
dea.location ,dea.date  ) as RollingPeopleVaccinated
from CovidDeaths$ as dea join CovidVac$ as vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3 












 