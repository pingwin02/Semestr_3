USE CelestialObjects

DROP TABLE Planet
DROP TABLE Star
DROP TABLE Galaxy
DROP TABLE Constellation
DROP TABLE Measurement
DROP TABLE DonationObservation
DROP TABLE Observation
DROP TABLE Donation
DROP TABLE AstronomicalObject
DROP TABLE Telescope
DROP TABLE ObservationKeeper
DROP TABLE Observatory
DROP TABLE Address

DROP VIEW [Most prestige Observation Keepers]

/*
DELETE FROM ObservationKeeper
 WHERE ObservationKeeper.First_name = 'Damian' AND ObservationKeeper.Last_name = 'Jankowski'

DELETE FROM Constellation
 WHERE Constellation.Name = 'Centaurus'

UPDATE Observatory
SET Observatory.Name = 'First observatory'
WHERE Observatory.Name = 'Observatory A';
*/