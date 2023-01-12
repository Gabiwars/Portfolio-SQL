use portfolio;

# 16% of the population in Brazil got COVID vs 29% in the USA
select location, date, population, total_cases, (total_cases/population)*100 as CasesPercentage
from coviddeaths
where location in  ('Brazil', 'United States' )
order by 1,2;


# Countries with highest infection rate compared to population
select location, population, max(total_cases) as HighestInfec, max((total_cases/population))*100 as CasesPercentage
from coviddeaths
where location not in ('World', 'High income', 'Upper middle income', 'Europe', 'North America', 'Asia', 'Lower middle income', 'South America', 'European Union', 'Oceania', 'International', 'Africa', 'Low income')
group by location, population
order by CasesPercentage desc;


# Countries with highest death count per population
select location, max(total_deaths) as TotalDeathCount
from coviddeaths
where location not in ('World', 'High income', 'Upper middle income', 'Europe', 'North America', 'Asia', 'Lower middle income', 'South America', 'European Union', 'Oceania', 'International', 'Africa', 'Low income')
group by location 
order by TotalDeathCount desc;

# Continents only
select location, max(total_deaths) as TotalDeathCount
from coviddeaths
where location in ('World', 'Europe', 'North America', 'Asia', 'South America', 'European Union', 'Oceania', 'Africa')
group by location 
order by TotalDeathCount desc;


# Chance of death from COVID overall today 1.03%
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)* 100 as DeathPercentage
from coviddeaths
where location not in ('World', 'High income', 'Upper middle income', 'Europe', 'North America', 'Asia', 'Lower middle income', 'South America', 'European Union', 'Oceania', 'International')
order by 1,2;

# Chance of death from COVID today (Brazil vs USA)
select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)* 100 as DeathPercentage
from coviddeaths
where location in ('Brazil','United States')
group by location
order by 1,2;


# Total Vaccines Applied and Avg of Vaccinations per Day
with CTE (continent, location, date, population, new_vaccinations, total_vacc_applied)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over w as total_vacc_applied
from coviddeaths dea
join covidvacc vac on dea.location = vac.location and dea.date = vac.date
where dea.location not in ('World', 'High income', 'Upper middle income', 'Europe', 'North America', 'Asia', 'Lower middle income', 'South America', 'European Union', 'Oceania', 'International', 'Africa', 'Low income')
window w as (partition by dea.location order by dea.location, dea.date)
)
select *, (total_vacc_applied/1047)  as avg_of_vacc_per_day
from CTE;


# Total Vaccines Applied and Avg of Vaccinations per Day (Brazil and USA)
with CTE (continent, location, date, population, new_vaccinations, total_vacc_applied)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over w as total_vacc_applied
from coviddeaths dea
join covidvacc vac on dea.location = vac.location and dea.date = vac.date
where dea.location in ('Brazil', 'United States')
window w as (partition by dea.location order by dea.location, dea.date)
)
select *, (total_vacc_applied/1047)  as avg_of_vacc_per_day
from CTE;




# Creating View to store data for later visualizations

# Total Vaccines Applied and Avg of Vaccinations per Day
create view avg_of_vaccines_per_day_world as
with CTE (continent, location, date, population, new_vaccinations, total_vacc_applied)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over w as total_vacc_applied
from coviddeaths dea
join covidvacc vac on dea.location = vac.location and dea.date = vac.date
where dea.location not in ('World', 'High income', 'Upper middle income', 'Europe', 'North America', 'Asia', 'Lower middle income', 'South America', 'European Union', 'Oceania', 'International', 'Africa', 'Low income')
window w as (partition by dea.location order by dea.location, dea.date)
)
select *, (total_vacc_applied/1047)  as avg_of_vacc_per_day
from CTE;


# Total Vaccines Applied and Avg of Vaccinations per Day (Brazil and USA)
create view avg_of_vaccines_per_day_BRA_vs_USA as
with CTE (continent, location, date, population, new_vaccinations, total_vacc_applied)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over w as total_vacc_applied
from coviddeaths dea
join covidvacc vac on dea.location = vac.location and dea.date = vac.date
where dea.location in ('Brazil', 'United States')
window w as (partition by dea.location order by dea.location, dea.date)
)
select *, (total_vacc_applied/1047)  as avg_of_vacc_per_day
from CTE;


# Chance of death from COVID overall today 1.03%
create view chance_of_death_today_world as
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)* 100 as DeathPercentage
from coviddeaths
where location not in ('World', 'High income', 'Upper middle income', 'Europe', 'North America', 'Asia', 'Lower middle income', 'South America', 'European Union', 'Oceania', 'International')
order by 1,2;


# Chance of death from COVID today (Brazil vs USA)
create view chance_of_death_today_BRA_vs_USA as
select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)* 100 as DeathPercentage
from coviddeaths
where location in ('Brazil','United States')
group by location
order by 1,2;


# 16% of the population in Brazil got COVID vs 29% in the USA
create view total_percentage_of_people_with_COVID_BRA_vs_USA as
select location, date, population, total_cases, (total_cases/population)*100 as CasesPercentage
from coviddeaths
where location in  ('Brazil', 'United States' )
order by 1,2;


# Countries with highest infection rate compared to population
create view infection_rate_to_population as
select location, population, max(total_cases) as HighestInfec, max((total_cases/population))*100 as CasesPercentage
from coviddeaths
where location not in ('World', 'High income', 'Upper middle income', 'Europe', 'North America', 'Asia', 'Lower middle income', 'South America', 'European Union', 'Oceania', 'International', 'Africa', 'Low income')
group by location, population
order by CasesPercentage desc;


# Countries with highest death count per population
create view highest_death as
select location, max(total_deaths) as TotalDeathCount
from coviddeaths
where location not in ('World', 'High income', 'Upper middle income', 'Europe', 'North America', 'Asia', 'Lower middle income', 'South America', 'European Union', 'Oceania', 'International', 'Africa', 'Low income')
group by location 
order by TotalDeathCount desc;
