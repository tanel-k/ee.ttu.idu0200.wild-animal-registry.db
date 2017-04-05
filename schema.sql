/* Drop schema */
DROP TABLE IF EXISTS species CASCADE;
DROP TABLE IF EXISTS sighting CASCADE;
DROP TABLE IF EXISTS animal CASCADE;

/* Create tables */
CREATE TABLE species(
	id BIGSERIAL NOT NULL,
	vernacular_name VARCHAR(255) NOT NULL,

	/* constraints */
	/* keys*/
	CONSTRAINT pk_species_id PRIMARY KEY (id)
);

CREATE TABLE sighting(
	id BIGSERIAL NOT NULL,
	dttm TIMESTAMP NOT NULL,
	latitude REAL NOT NULL,
	longitude REAL NOT NULL,
	
	/* foreign keys */
	animal_id BIGINT NOT NULL,

	/* constraints */
	/* keys*/
	CONSTRAINT pk_sighting_id
		PRIMARY KEY (id),

	/* logic */
	CONSTRAINT chk_latitude_valid 
		CHECK (latitude >= -90.0 AND latitude <= 90.0),
	CONSTRAINT chk_longitude_valid 
		CHECK (longitude >= -180.0 AND longitude <= 180.0)
);

CREATE TABLE animal(
	id BIGSERIAL NOT NULL,
	name VARCHAR(100) NOT NULL,
	
	/* foreign keys */
	species_id BIGINT NOT NULL,

	/* constraints */
	/* keys*/
	CONSTRAINT pk_animal_id
		PRIMARY KEY (id)
);

/* Create table relationships */
ALTER TABLE animal
ADD CONSTRAINT fk_animal_species
FOREIGN KEY (species_id)
	REFERENCES species (id);

ALTER TABLE sighting
ADD CONSTRAINT fk_sighting_animal
	FOREIGN KEY (animal_id)
		REFERENCES animal (id);

/* Create indexes */
/* Foreign-key indexes */
CREATE INDEX idx_animal_species ON animal (species_id);
CREATE INDEX idx_sighting_animal ON sighting (animal_id);

/* Function-based indexes */
CREATE INDEX idx_species_vernacular_name ON species USING GIN (to_tsvector('english', vernacular_name));

CREATE UNIQUE INDEX ak_animal_name ON animal (UPPER(name));
CREATE UNIQUE INDEX ak_species_vernacular_name ON species (UPPER(vernacular_name));