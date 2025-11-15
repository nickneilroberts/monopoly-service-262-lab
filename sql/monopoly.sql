--
-- This SQL script builds a monopoly database, deleting any pre-existing version.
--
-- HW assigned by:
-- kvlinden
-- @version Summer, 2015
--
-- Completed by:
-- @author nnr3

-- Drop previous versions of the tables if they they exist, in reverse order of foreign keys.
DROP TABLE IF EXISTS OwnedProperty;
DROP TABLE IF EXISTS PlayerGame;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Game;

-- Create the schema.
CREATE TABLE Game (
	ID integer PRIMARY KEY,
	time timestamp
	);

CREATE TABLE Player (
	ID integer PRIMARY KEY, 
	emailAddress varchar(50) NOT NULL,
	name varchar(50)
	);

CREATE TABLE PlayerGame (
	gameID integer REFERENCES Game(ID), 
	playerID integer REFERENCES Player(ID),
	score integer,
	piece varchar(50),
	boardPosition integer,
	cash integer,
	PRIMARY KEY (gameID, playerID)
	);

CREATE TABLE Property (
	ID integer PRIMARY KEY,
	name varchar(50),
	price integer,
	houseCost integer,
	baseRent integer,
	rent1House integer,
	rent2House integer,
	rent3House integer,
	rentHotel integer,
	boardPosition integer
	);

CREATE TABLE OwnedProperty (
	ID integer PRIMARY KEY,
	gameID integer,
	playerID integer,
	propertyID integer REFERENCES Property(ID),
	houses integer,
	hasHotel boolean,
	FOREIGN KEY (gameID, playerID) REFERENCES PlayerGame(gameID, playerID)
	);

-- Allow users to select data from the tables.
GRANT SELECT ON Game TO PUBLIC;
GRANT SELECT ON Player TO PUBLIC;
GRANT SELECT ON PlayerGame TO PUBLIC;
GRANT SELECT ON Property TO PUBLIC;
GRANT SELECT ON OwnedProperty TO PUBLIC;

-- Add sample records.
INSERT INTO Game VALUES (1, '2006-06-27 08:00:00');
INSERT INTO Game VALUES (2, '2006-06-28 13:20:00');
INSERT INTO Game VALUES (3, '2025-10-31 18:41:00');

INSERT INTO Player(ID, emailAddress) VALUES (1, 'me@calvin.edu');
INSERT INTO Player VALUES (2, 'king@gmail.edu', 'The King');
INSERT INTO Player VALUES (3, 'dog@gmail.edu', 'Dogbreath');
INSERT INTO Player VALUES (4, 'void@gmail.edu', NULL);
INSERT INTO Player VALUES (5, 'lowscore@gmail.edu', 'Low Scorer');



-- Note the score and cash look similair here because score is likely computed from cash and other factors
INSERT INTO PlayerGame VALUES (1, 1, 0, 'tophat', 1, 0);
INSERT INTO PlayerGame VALUES (2, 1, 1000, 'tophat', 11, 1000);
INSERT INTO PlayerGame VALUES (1, 2, 300, 'car', 1, 300);
INSERT INTO PlayerGame VALUES (2, 2, 200, 'car', 12, 200);
INSERT INTO PlayerGame VALUES (3, 2, 0, 'car', 13, 0);
INSERT INTO PlayerGame VALUES (1, 3, 2350, 'dog', 11, 2350);
INSERT INTO PlayerGame VALUES (2, 3, 500, 'dog', 12, 500);
INSERT INTO PlayerGame VALUES (3, 3, 5500, 'dog', 13, 5500);

INSERT INTO Property VALUES (1, 'Boardwalk', 400, 200, 50, 200, 600, 1400, 2000, 39);
INSERT INTO OwnedProperty VALUES (1, 1, 1, 1, 0, FALSE);


--LAB 8 INSTRUCTIONS
--Exercise 8.1:
-- Retrieve a list of all the games, ordered by date with the most recent game coming first.
SELECT Game.ID
FROM Game
ORDER BY Game.time ASC;

-- Retrieve all the games that occurred in the past week.
SELECT Game.ID
FROM Game
WHERE Game.time > CURRENT_DATE - INTERVAL '7 days';

-- Retrieve a list of players who have (non-NULL) names.
SELECT Player.name
FROM Player
WHERE Player.name IS NOT NULL;

-- Retrieve a list of IDs for players who have some game score larger than 2000.
SELECT PlayerGame.playerID
FROM PlayerGame
WHERE PlayerGame.score > 2000
GROUP BY PlayerGame.playerID;

--Retrieve a list of players who have GMail accounts.
SELECT Player.ID
FROM Player
WHERE Player.emailAddress IS NOT NULL;

--Exercise 8.2:

-- Retrieve all “The King”’s game scores in decreasing order.
SELECT PlayerGame.score
FROM PlayerGame, Player
WHERE Player.ID = PlayerGame.PlayerID
AND Player.name = 'The King'
ORDER BY PlayerGame.score DESC;

-- Retrieve the name of the winner of the game played on 2006-06-28 13:20:00.
-- NOTE: The winner here IS NULL because they have no name. This is okay.
SELECT Player.name
FROM Player
JOIN PlayerGame ON Player.ID = PlayerGame.PlayerID
JOIN Game ON PlayerGame.GameID = Game.ID
WHERE Game.time = '2006-06-28 13:20:00'
ORDER BY PlayerGame.score DESC
LIMIT(1);

-- So what does that P1.ID < P2.ID clause do in the last example query (i.e., the from SQL Examples)?
-- NOTE: Here is the statement
SELECT P1.name
FROM Player AS P1, Player AS P2
WHERE P1.name = P2.name
AND P1.ID < P2.ID;
-- ANSWER: That singular clause line will return an ID from P1 that is less than the ID of P2.
--          Since we have grabbed this table from itself, it will show us the player ID's of players with the same name

-- The query that joined the Player table to itself seems rather contrived. Can you think of a realistic situation in which you’d want to join a table to itself?
--ANSWER: Yes! If you wanted to make sure that a given field like "emailAddress" is correctly assigned to only one person in your Player table, you can use this
--         to see if there are multiple entries of the same emailAddress across different Player ID's. 
--          (Perhaps you are shifting the rules of this monopoly site so that Players may no longer share the same email as another)