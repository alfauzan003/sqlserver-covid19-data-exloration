-- Covid19 Data Exploration

-- Death percentage in Indonesia
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT)/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE location like '%indonesia%' AND
    continent IS NOT NULL AND
    total_cases IS NOT NULL AND
    total_deaths IS NOT NULL
ORDER BY date

-- Percentage of population infected in Indonesia
SELECT location, date, population, total_cases, (CAST(total_cases AS FLOAT)/population)*100 as InfectedPercentage
FROM CovidDeaths
WHERE location like '%indonesia%' AND
    continent IS NOT NULL AND
    population IS NOT NULL AND
    total_cases IS NOT NULL
ORDER BY date

-- Countries with the highest infection rate
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((CAST(total_cases AS FLOAT)/population)*100) AS highest_infection_rate
FROM CovidDeaths
WHERE continent IS NOT NULL AND
    population IS NOT NULL AND
    total_cases IS NOT NULL
GROUP BY location, population
ORDER BY highest_infection_rate DESC

-- Countries with the highest death count
SELECT location, MAX(total_deaths) AS highest_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL AND
    population IS NOT NULL AND
    total_deaths IS NOT NULL
GROUP BY location
ORDER BY highest_death_count DESC

-- Continent with the highest death count
SELECT continent, MAX(total_deaths) AS highest_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL AND
    population IS NOT NULL AND
    total_deaths IS NOT NULL
GROUP BY continent
ORDER BY highest_death_count DESC

-- Percentage of population vaccinated
SELECT dea.location, dea.date, dea.population, dea.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,
     ((SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)) / CAST(dea.population AS FLOAT)) * 100 AS VaccinationPercentage
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location AND
        dea.date = vac.date
WHERE -- dea.location like '%indonesia%' AND
    dea.continent IS NOT NULL AND
    dea.population IS NOT NULL AND
    vac.new_vaccinations IS NOT NULL
ORDER BY dea.location, dea.date