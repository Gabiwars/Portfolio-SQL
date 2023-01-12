use portfolio;

-- 16% of the population in Brazil got COVID vs 29% in the USA
SELECT 
    location,
    date,
    population,
    total_cases,
    (total_cases / population) * 100 AS CasesPercentage
FROM
    coviddeaths
WHERE
    location IN ('Brazil' , 'United States')
ORDER BY 1 , 2;


-- Countries with highest infection rate compared to population
SELECT 
    location,
    population,
    MAX(total_cases) AS HighestInfec,
    MAX((total_cases / population)) * 100 AS CasesPercentage
FROM
    coviddeaths
WHERE
    location NOT IN ('World' , 'High income',
        'Upper middle income',
        'Europe',
        'North America',
        'Asia',
        'Lower middle income',
        'South America',
        'European Union',
        'Oceania',
        'International',
        'Africa',
        'Low income')
GROUP BY location , population
ORDER BY CasesPercentage DESC;


-- Countries with highest death count per population
SELECT 
    location, MAX(total_deaths) AS TotalDeathCount
FROM
    coviddeaths
WHERE
    location NOT IN ('World' , 'High income',
        'Upper middle income',
        'Europe',
        'North America',
        'Asia',
        'Lower middle income',
        'South America',
        'European Union',
        'Oceania',
        'International',
        'Africa',
        'Low income')
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- Continents only
SELECT 
    location, MAX(total_deaths) AS TotalDeathCount
FROM
    coviddeaths
WHERE
    location IN ('World' , 'Europe',
        'North America',
        'Asia',
        'South America',
        'European Union',
        'Oceania',
        'Africa')
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- Chance of death from COVID overall today 1.03%
SELECT 
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM
    coviddeaths
WHERE
    location NOT IN ('World' , 'High income',
        'Upper middle income',
        'Europe',
        'North America',
        'Asia',
        'Lower middle income',
        'South America',
        'European Union',
        'Oceania',
        'International')
ORDER BY 1 , 2;


-- Chance of death from COVID today (Brazil vs USA)
SELECT 
    location,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM
    coviddeaths
WHERE
    location IN ('Brazil' , 'United States')
GROUP BY location
ORDER BY 1 , 2;


-- Total Vaccines Applied and Avg of Vaccinations per Day
WITH CTE (continent, location, date, population, new_vaccinations, total_vacc_applied)
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over w AS total_vacc_applied
FROM coviddeaths dea
JOIN covidvacc vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.location NOT IN ('World', 'High income', 
                           'Upper middle income', 
                           'Europe', 'North America', 
                           'Asia', 'Lower middle income', 
                           'South America', 'European Union', 
                           'Oceania', 'International', 
                           'Africa', 'Low income')
window w AS (partition BY dea.location ORDER BY dea.location, dea.date)
)
SELECT *, (total_vacc_applied/1047)  AS avg_of_vacc_per_day
FROM CTE;


-- Total Vaccines Applied and Avg of Vaccinations per Day (Brazil and USA)
WITH CTE (continent, location, date, population, new_vaccinations, total_vacc_applied)
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over w AS total_vacc_applied
FROM coviddeaths dea
JOIN covidvacc vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.location IN ('Brazil', 'United States')
window w AS (partition BY dea.location ORDER BY dea.location, dea.date)
)
SELECT *, (total_vacc_applied/1047)  AS avg_of_vacc_per_day
FROM CTE;




-- Creating View to store data for later visualizations

-- Total Vaccines Applied and Avg of Vaccinations per Day
CREATE view avg_of_vaccines_per_day_world AS
WITH CTE (continent, location, date, population, new_vaccinations, total_vacc_applied)
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over w AS total_vacc_applied
FROM coviddeaths dea
JOIN covidvacc vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.location NOT IN ('World', 'High income', 
                           'Upper middle income', 
                           'Europe', 'North America', 
                           'Asia', 'Lower middle income', 
                           'South America', 'European Union', 
                           'Oceania', 'International', 
                           'Africa', 'Low income')
window w AS (partition BY dea.location ORDER BY dea.location, dea.date)
)
SELECT *, (total_vacc_applied/1047)  AS avg_of_vacc_per_day
FROM CTE;


-- Total Vaccines Applied and Avg of Vaccinations per Day (Brazil and USA)
CREATE view avg_of_vaccines_per_day_BRA_vs_USA AS
WITH CTE (continent, location, date, population, new_vaccinations, total_vacc_applied)
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over w AS total_vacc_applied
FROM coviddeaths dea
JOIN covidvacc vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.location IN ('Brazil', 'United States')
window w AS (partition BY dea.location ORDER BY dea.location, dea.date)
)
SELECT *, (total_vacc_applied/1047)  AS avg_of_vacc_per_day
FROM CTE;


-- Chance of death from COVID overall today 1.03%
CREATE VIEW chance_of_death_today_world AS
    SELECT 
        SUM(new_cases) AS total_cases,
        SUM(new_deaths) AS total_deaths,
        SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
    FROM
        coviddeaths
    WHERE
        location NOT IN ('World' , 'High income',
            'Upper middle income',
            'Europe',
            'North America',
            'Asia',
            'Lower middle income',
            'South America',
            'European Union',
            'Oceania',
            'International')
    ORDER BY 1 , 2;


-- Chance of death from COVID today (Brazil vs USA)
CREATE VIEW chance_of_death_today_BRA_vs_USA AS
    SELECT 
        location,
        SUM(new_cases) AS total_cases,
        SUM(new_deaths) AS total_deaths,
        SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
    FROM
        coviddeaths
    WHERE
        location IN ('Brazil' , 'United States')
    GROUP BY location
    ORDER BY 1 , 2;


-- 16% of the population in Brazil got COVID vs 29% in the USA
CREATE VIEW total_percentage_of_people_with_COVID_BRA_vs_USA AS
    SELECT 
        location,
        date,
        population,
        total_cases,
        (total_cases / population) * 100 AS CasesPercentage
    FROM
        coviddeaths
    WHERE
        location IN ('Brazil' , 'United States')
    ORDER BY 1 , 2;


-- Countries with highest infection rate compared to population
CREATE VIEW infection_rate_to_population AS
    SELECT 
        location,
        population,
        MAX(total_cases) AS HighestInfec,
        MAX((total_cases / population)) * 100 AS CasesPercentage
    FROM
        coviddeaths
    WHERE
        location NOT IN ('World' , 'High income',
            'Upper middle income',
            'Europe',
            'North America',
            'Asia',
            'Lower middle income',
            'South America',
            'European Union',
            'Oceania',
            'International',
            'Africa',
            'Low income')
    GROUP BY location , population
    ORDER BY CasesPercentage DESC;


-- Countries with highest death count per population
CREATE VIEW highest_death AS
    SELECT 
        location, MAX(total_deaths) AS TotalDeathCount
    FROM
        coviddeaths
    WHERE
        location NOT IN ('World' , 'High income',
            'Upper middle income',
            'Europe',
            'North America',
            'Asia',
            'Lower middle income',
            'South America',
            'European Union',
            'Oceania',
            'International',
            'Africa',
            'Low income')
    GROUP BY location
    ORDER BY TotalDeathCount DESC;
