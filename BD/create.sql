-- CREATE DATABASE CelestialObjects

USE CelestialObjects

CREATE TABLE Constellation (
	Name varchar(50) PRIMARY KEY,
	Size float CHECK(Size >= 60 AND Size <= 1400) NOT NULL,
	Declination float CHECK(Declination >= -90 AND Declination <= 90) NOT NULL,
	Right_ascension varchar(7) CHECK(Right_ascension like '[0-9][0-9]h [0-9][0-9]m') NOT NULL,
)

CREATE TABLE AstronomicalObject (
	Name varchar(50) PRIMARY KEY,
    Type varchar(6) CHECK(Type in ('star', 'planet', 'galaxy')) NOT NULL,
)

CREATE TABLE Galaxy (
	Name varchar(50) PRIMARY KEY FOREIGN KEY REFERENCES AstronomicalObject(Name) ON DELETE CASCADE ON UPDATE CASCADE,
	NGC varchar(10) UNIQUE CHECK(NGC like 'NGC [0-7][0-9][0-9][0-9]'),
	Type varchar(50) NOT NULL
)

CREATE TABLE Star (
	Name varchar(50) PRIMARY KEY FOREIGN KEY REFERENCES AstronomicalObject(Name) ON DELETE CASCADE ON UPDATE CASCADE,
	Type varchar(50) NOT NULL,
	In_constellation varchar(50) FOREIGN KEY REFERENCES Constellation(Name) ON DELETE CASCADE ON UPDATE CASCADE,
	In_galaxy varchar(50) FOREIGN KEY REFERENCES Galaxy(Name)
)

CREATE TABLE Planet (
	Name varchar(50) PRIMARY KEY FOREIGN KEY REFERENCES AstronomicalObject(Name) ON DELETE CASCADE ON UPDATE CASCADE,
	Type varchar(50) NOT NULL,
	Orbital_period float CHECK(Orbital_period > 0 AND Orbital_period <= 999999),
	Host_star varchar(50) FOREIGN KEY REFERENCES Star(Name)
)

CREATE TABLE Address (
	ID int IDENTITY(1,1) PRIMARY KEY,
	Street varchar(20) NOT NULL,
	City varchar(30) NOT NULL,
	Postal_code varchar(6) CHECK(Postal_code like '[0-9][0-9]-[0-9][0-9][0-9]') NOT NULL,
	Country varchar(15) NOT NULL
)

CREATE TABLE Observatory (
	Name varchar(30) NOT NULL,
	Address_ID int FOREIGN KEY REFERENCES Address(ID) NOT NULL,
	PRIMARY KEY (Name, Address_ID)
)

CREATE TABLE ObservationKeeper (
	ID int IDENTITY(1,1) PRIMARY KEY,
	Workplace_adress int FOREIGN KEY REFERENCES Address(ID) NOT NULL,
	First_name varchar(30) NOT NULL,
	Last_name varchar(30) NOT NULL
)

CREATE TABLE Telescope (
	ID int IDENTITY(1,1) NOT NULL,
	Observatory_name varchar(30) NOT NULL,
	Observatory_address int NOT NULL,
	FOREIGN KEY (Observatory_name, Observatory_address) 
		REFERENCES Observatory(Name, Address_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	Producer varchar(30) NOT NULL,
	Diameter float CHECK(Diameter > 0 AND Diameter <= 40) NOT NULL,
	Magnification float CHECK(Magnification > 0 AND Magnification <= 9999) NOT NULL
	PRIMARY KEY (ID, Observatory_Name, Observatory_address)
)

CREATE TABLE Observation (
	ID int IDENTITY(1,1) PRIMARY KEY,
	Object_name varchar(50) FOREIGN KEY REFERENCES AstronomicalObject(Name) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	Description varchar(150) NOT NULL,
	Start_date date DEFAULT GETDATE() NOT NULL,
	End_date date,
	Keeper_ID int FOREIGN KEY REFERENCES ObservationKeeper(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	Telescope_ID int NOT NULL,
	Telescope_observatory_name varchar(30) NOT NULL,
	Telescope_observatory_address int NOT NULL,
	FOREIGN KEY (Telescope_ID, Telescope_observatory_name, Telescope_observatory_address) REFERENCES
		Telescope(ID, Observatory_name, Observatory_address) ON DELETE CASCADE ON UPDATE CASCADE,
	CHECK (End_date IS NULL OR (End_date IS NOT NULL AND Start_date < End_date))
)

CREATE TABLE Measurement (
	ID int IDENTITY(1,1) PRIMARY KEY,
	Observation_ID int FOREIGN KEY REFERENCES Observation(ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	Distance float CHECK(Distance > 0 AND Distance <= 999999999) NOT NULL,
	Magnitude float CHECK(Magnitude >= -27 AND Magnitude <= 32),
	Radius float CHECK(Radius > 0 AND Radius <= 999999999),
	Mass float CHECK(Mass > 0 AND Mass <= 999999999),
	Temperature float CHECK(Temperature > 0 AND Temperature <= 300000),
	Time datetime DEFAULT GETDATE() NOT NULL
)

CREATE TABLE Donation (
	ID int IDENTITY(1,1) PRIMARY KEY,
	Amount float CHECK (Amount > 0 AND Amount <= 999999999) NOT NULL,
	Source varchar(50) NOT NULL,
	Goal varchar(100) NOT NULL,
	Date date DEFAULT GETDATE() NOT NULL
)

CREATE TABLE DonationObservation (
	Donation_ID int FOREIGN KEY REFERENCES Donation(ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	Observation_ID int FOREIGN KEY REFERENCES Observation(ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	PRIMARY KEY (Observation_ID, Donation_ID)
)