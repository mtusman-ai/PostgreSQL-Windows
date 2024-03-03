
/*
Below commands work on Bash Shell only

Start / Stop POSTGRESQL Server:
sudo systemctl start postgresql
sudo systemctl stop postgresql
sudo systemctl restart postgresql
sudo systemctl status postgresql

Login to POSTGRESQL:
sudo -u postgres psql

*/

-- create special character database staring with numeric value

DROP DATABASE IF EXISTS "7dbs";
CREATE DATABASE "7dbs";

CREATE DATABASE IF NOT EXISTS "7dbs";


/* countries table*/

CREATE TABLE countries(country_code char(2) PRIMARY KEY, country_name text UNIQUE);
INSERT INTO countries (country_code, country_name) VALUES ('us', 'United States');
INSERT INTO countries(country_code, country_name) VALUES('mx', 'Mexico'), ('au', 'Australia');
INSERT INTO countries(country_code, country_name) VALUES('gb', 'United Kingdom'), ('de', 'Germany');
SELECT * FROM countries;
INSERT INTO countries(country_code, country_name) VALUES('ll', 'Loompaland');

/* Below command should give error*/
INSERT INTO countries(country_code, country_name) VALUES('uk', 'United Kingdom');

/* cities table */
CREATE TABLE cities (name text NOT NULL,postal_code varchar(9) CHECK (postal_code <> ''),country_code char(2) REFERENCES countries(country_code),PRIMARY KEY (country_code, postal_code));
INSERT INTO cities VALUES('Portland', '87200', 'us');
UPDATE cities SET postal_code = '97206' WHERE name = 'Portland';
SELECT * FROM cities;

/* venues table */

 CREATE TABLE venues (venue_id SERIAL PRIMARY KEY, name varchar (255), street_address text, type char(7) CHECK (type in ('public', 'private')) DEFAULT 'public', postal_code varchar(9),country_code char(2), FOREIGN KEY (country_code, postal_code) REFERENCES cit
ies (country_code, postal_code) MATCH FULL);

INSERT INTO venues(name, postal_code, country_code) VALUES('Crystal Ballroom', '97206', 'us');

INSERT INTO venues(name, country_code, postal_code) VALUES ('Voodoo Doughnut', 'us', '97206') RETURNING venue_id;


/* events table */
CREATE TABLE events (event_id SERIAL PRIMARY KEY, title text, starts TIMESTAMP, ends TIMESTAMP, venue_id INT REFERENCES venues
(venue_id));

INSERT INTO events(title, starts, ends, venue_id) VALUES ('Fight Club', '2018-02-15 17:30:00', '2018-02-15 17:30:00', 2);
INSERT INTO events(title, starts, ends) VALUES ('April Fools Day', '2018-04-15 17:30:00', '2018-04-15 17:30:00');
INSERT INTO events(title, starts, ends) VALUES ('Christmas Day', '2018-06-15 16:30:00', '2018-06-15 18:30:00');
UPDATE events SET event_id = 2 WHERE title = 'April Fools Day';
UPDATE events SET event_id = 3 WHERE title = 'Christmas Day';
SELECT * FROM events;



/* help function*/

\h CREATE DATABASE
\? MATCH FULL


/* Joins */

SELECT cities.*, country_name FROM cities JOIN countries ON cities.country_code = countries.country_code;

SELECT v.venue_id, v.name, c.name FROM venues v INNER JOIN cities c ON v.postal_code=c.postal_code AND v.country_code=c.countr
y_code;

SELECT v.venue_id, v.name AS venue, c.name AS city FROM venues v INNER JOIN cities c ON v.postal_code=c.postal_code AND v.coun
try_code=c.country_code;

SELECT v.venue_id, v.name AS venue, c.name AS city FROM venues v INNER JOIN cities c ON v.postal_code=c.postal_code AND v.country_code=c.country_code;

-- Inner Join is given below:
SELECT e.title, v.name FROM events e JOIN venues v ON e.venue_id = v.venue_id;

-- below left join fetches values where venue_id is Null
SELECT e.title, v.name FROM events e LEFT JOIN venues v ON e.venue_id = v.venue_id;

-- below right join fetches values from right column while left will be only where join matches
SELECT e.title, v.name FROM events e RIGHT JOIN venues v ON e.venue_id = v.venue_id;

-- full join fetches values from both tables based on the query
SELECT e.title, v.name FROM events e FULL JOIN venues v ON e.venue_id = v.venue_id;


/* Creating Indexes and analyzing postgres queries */

-- Check performance of queries before and after the indexing

 EXPLAIN SELECT * FROM events WHERE title = 'Christmas Day';
 EXPLAIN ANALYZE SELECT * FROM events WHERE title = 'Christmas Day';

EXPLAIN ANALYZE SELECT * FROM events WHERE starts >= '2018-04-01';


-- Hash indexes are useful for queries like SELECT * FROM events WHERE event_id = 2;
CREATE INDEX events_title ON events USING hash (title);

-- In order to create greater or lesser e.g. SELECT * FROM some_table WHERE some_number >= 102;
CREATE INDEX events_starts ON events USING btree (starts);



 -- Hash function example: 'Hello' - ASCII = 72 + 101 + 108 + 108 + 111 = 500
 SELECT HASHTEXT('Hello');

/* Day - 2 of the Book */

INSERT INTO cities VALUES('Lahore', '60000', 'PK'), ('Bombay', '80000', 'ID'), ('Dubai', '5000', 'AE'), ('Makkah', '3000', 'KS
'), ('Doha', '45000', 'QR');

INSERT INTO venues(name, street_address, postal_code, country_code)VALUES('Jumeriah Golf Club', 'Ras Al Khor', '5000', 'AE');

INSERT INTO events (title, starts, ends, venue_id) VALUES ('Moby', '2018-02-06 21:00', '2018-02-06 23:00', (SELECT venue_id FR
OM venues WHERE name = 'Crystal Ballroom'));

-- Add venue column to the events table
ALTER TABLE events ADD COLUMN venue text;

INSERT INTO events (title, starts, ends, venue) VALUES ('Wedding', '2018-02-26 21:00', '2018-02-26 23:00', 'Voodoo Doughnut'),
('Dinner with Mom', '2018-02-26 18:00', '2018-02-26 20:30', 'My Place'),('Valentine''s Day', '2018-02-14 00:00', '2018-02-14 23:59','Beach Resort');

-- Get count of values from the table
SELECT count(title) FROM events WHERE title LIKE '%Day%';

-- Select Min, Max Values from table and combine with Join
SELECT min(starts), max(ends) FROM events INNER JOIN venues ON events.venue_id = venues.venue_id WHERE venues.name = 'Crystal
Ballroom';

/* Grouping Functions in PostgreSQL */

-- count & group by functions together
SELECT venue_id, count(*) FROM events GROUP BY venue_id;

-- choose popular destinations within the dataset
SELECT venue_id FROM events GROUP BY venue_id HAVING count(*) >= 1 AND venue_id IS NOT NULL;

-- grouping without aggregate function
SELECT venue_id FROM events GROUP BY venue_id;

-- Distinct keyword is the shortcut to the as per previous command
SELECT DISTINCT venue_id FROM events;

/* Window Functions */

-- window functions are similar to group by function, however window functions show all rows

-- let's compare with two commands:
SELECT venue_id, count(*) FROM events GROUP BY venue_id ORDER BY venue_id;

-- below is window function OVER(PARTITION BY)
SELECT venue_id, count(*) OVER (PARTITION BY venue_id) FROM events ORDER BY venue_id;

-- PARTITION BY could be thought of similar to GROUP BY, but returns results OVER a PARTITION of the result set
SELECT title, count(*) OVER (PARTITION BY venue_id) FROM events;

##############################################################################################################







