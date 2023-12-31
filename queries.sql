/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE name != 'Gabumon';

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN;

UPDATE animals
SET species = 'unspecified';
SELECT * FROM animals;

ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;
 
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals;

SELECT COUNT(*) AS total_animals FROM animals;
SELECT COUNT(*) AS never_escaped FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) AS average_weight FROM animals;
SELECT neutered, AVG(escape_attempts) FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

SELECT species.name, COUNT(animals.id) AS animal_count
FROM species
LEFT JOIN animals ON species.id = animals.species_id
GROUP BY species.name;

SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
JOIN owners ON animals.owner_id = owners.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

SELECT owners.full_name, COUNT(animals.id) AS animal_count
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.full_name
ORDER BY animal_count DESC
LIMIT 1;

SELECT animals.name AS last_animal_seen
FROM visits
JOIN animals ON visits.animal_id = animals.id
WHERE visits.vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher')
ORDER BY visits.visit_date DESC
LIMIT 1;

SELECT DISTINCT animals.name
FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez';

SELECT vets.*, species.name AS specialty_name
FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;

SELECT animals.name AS animal_name, visits.visit_date
FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez' AND visits.visit_date >= '2020-04-01' AND visits.visit_date <= '2020-08-30';

SELECT animals.name AS animal_name, COUNT(*) AS num_visits
FROM visits
JOIN animals ON visits.animal_id = animals.id
GROUP BY animals.name
ORDER BY num_visits DESC
LIMIT 1;

SELECT a.name AS animal_name, v.visit_date, vt.name AS vet_name 
FROM animals AS a 
JOIN visits AS v ON a.id = v.animal_id 
JOIN vets AS vt ON v.vet_id = vt.id 
WHERE vt.name = 'Maisy Smith' 
ORDER BY v.visit_date ASC 
LIMIT 1;

SELECT a.name AS animal_name, v.visit_date, vt.name AS vet_name 
FROM animals AS a  
JOIN  visits AS v ON a.id = v.animal_id 
JOIN vets AS vt ON v.vet_id=vt.id 
ORDER BY v.visit_date DESC 
LIMIT 1;

SELECT COUNT(*) 
FROM (
  SELECT specializations.species_id AS vet_specialization, animals.species_id
  FROM visits
  JOIN specializations
  ON visits.vet_id = specializations.vet_id
  JOIN animals
  ON visits.animal_id = animals.id
) AS comparative
WHERE vet_specialization <> species_id;

SELECT species.name AS species_name 
FROM visits 
JOIN animals ON visits.animal_id = animals.id 
JOIN vets ON visits.vet_id = vets.id 
JOIN species ON animals.species_id = species.id 
WHERE vets.name = 'Maisy Smith' 
GROUP BY species.name 
ORDER BY COUNT(*) DESC 
LIMIT 1;

SELECT COUNT(*) FROM visits where animal_id = 4;
SELECT * FROM visits where vet_id = 2;
SELECT * FROM owners where email = 'owner_18327@mail.com';

EXPLAIN ANALYZE SELECT COUNT(*) FROM visits WHERE animal_id = 4;
EXPLAIN ANALYZE SELECT animal_id, vet_id, visit_date FROM visits WHERE vet_id = 2;
EXPLAIN ANALYZE SELECT id, full_name, age, email FROM owners WHERE email = 'owner_18327@mail.com';