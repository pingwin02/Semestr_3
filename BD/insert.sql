USE CelestialObjects

-- Constellations
INSERT INTO Constellation (Name, Size, Declination, Right_ascension) VALUES
('Canis Major', 380, -21, '07h 00m'),
('Orion', 594, 0, '05h 30m'),
('Taurus', 797, 15, '04h 30m'),
('Ursa Major', 1280, 55, '11h 00m'),
('Aquila', 652, 3, '19h 30m'),
('Lyra', 286, 40, '19h 00m'),
('Boötes', 907, 30, '14h 30m'),
('Canis Minor', 182, 5, '07h 30m'),
('Virgo', 1294, 0, '13h 00m'),
('Ursa Minor', 256, 75, '15h 00m'),
('Ophiuchus', 948, -8, '17h 00m'),
('Hydra', 1303, -20, '10h 00m'),
('Cygnus', 804, 40, '20h 30m'),
('Centaurus', 1060, -50, '13h 00m');

-- Galaxies
INSERT INTO AstronomicalObject (Name, Type) VALUES
('Milky Way', 'galaxy'),
('Andromeda', 'galaxy'),
('Black Eye Galaxy', 'galaxy');

INSERT INTO Galaxy (Name, NGC, Type) VALUES
('Milky Way', 'NGC 0000',  'spiral'),
('Andromeda', 'NGC 0224',  'barred spiral'),
('Black Eye Galaxy', 'NGC 4826', 'spiral');

-- Stars
INSERT INTO AstronomicalObject (Name, Type) VALUES
('Proxima Centauri', 'star'),
('Sun', 'star'),
('Kepler-47', 'star'),
('Betelgeuse', 'star');

INSERT INTO Star (Name, Type, In_constellation, In_galaxy) VALUES 
('Proxima Centauri', 'red dwarf', 'Centaurus', 'Milky Way'),
('Sun', 'yellow dwarf', NULL, 'Milky Way'),
('Kepler-47', 'binary', 'Orion', 'Milky Way'),
('Betelgeuse', 'red dwarf', 'Orion', 'Milky Way');


-- Planets
INSERT INTO AstronomicalObject (Name, Type) VALUES
('Mercury', 'planet'),
('Venus', 'planet'),
('Mars', 'planet'),
('Kepler-47c', 'planet'),
('Makemake', 'planet');

INSERT INTO Planet (Name, Type, Orbital_period, Host_star) VALUES
('Mercury', 'terrestrial', 87.969 , 'Sun'),
('Venus', 'terrestrial', 224.701, 'Sun'),
('Mars', 'terrestrial', 686.980, 'Sun'),
('Kepler-47c', 'exoplanet', 300.137, 'Kepler-47'),
('Makemake', 'dwarf', 304.5, 'Sun');

-- Addresses
INSERT INTO Address (Street, City, Postal_code, Country) VALUES
('Trzy Lipy', 'Gdansk', '80-172', 'Poland'),
('Main Street', 'New York', '01-123', 'USA'),
('de l''Observatoire', 'Paris', '02-456', 'France'),
('123 Main St', 'New York', '01-234', 'USA'),
('456 Park Ave', 'Toronto', '15-253', 'Canada'),
('789 Oxford St', 'London', '98-101', 'UK'),
('321 Boulevard St', 'Paris', '75-001', 'France'),
('654 Avenue St', 'São Paulo', '34-567', 'Brazil'),
('987 Street St', 'Sydney', '20-000', 'Australia'),
('246 Road St', 'Tokyo', '34-456', 'Japan');

-- Observatories
INSERT INTO Observatory (Name, Address_ID) VALUES
('Observatory A', 1),
('Observatory B', 2),
('Observatory C', 3),
('Observatory D', 4),
('Observatory E', 5),
('Observatory F', 6),
('Observatory G', 7),
('Observatory H', 8),
('Observatory I', 9),
('Observatory J', 10);

-- Observation keepers
INSERT INTO ObservationKeeper (Workplace_adress, First_name, Last_name) VALUES
(1, 'Damian', 'Jankowski'),
(2, 'Jane', 'Doe'),
(3, 'James', 'Johnson'),
(4, 'Emily', 'Williams'),
(5, 'David', 'Brown'),
(6, 'Mary', 'Jones'),
(7, 'Michael', 'Miller'),
(8, 'Sarah', 'Davis'),
(9, 'Chris', 'Garcia'),
(10, 'Michelle', 'Rodriguez');;

-- Telescopes
INSERT INTO Telescope (Observatory_name, Observatory_address, Producer, Diameter, Magnification) VALUES
('Observatory A', 1, 'Orion', 8.0, 1150.0),
('Observatory B', 2, 'Celestron', 10.0, 2000.0),
('Observatory C', 3, 'Meade', 12.0, 2520.0),
('Observatory D', 4, 'Sky-Watcher', 14.0, 3000.0),
('Observatory E', 5, 'Vixen', 16.0, 4010.0),
('Observatory F', 6, 'Takahashi', 18.0, 1204.0),
('Observatory G', 7, 'William Optics', 20.0, 1240.0),
('Observatory H', 8, 'SVBONY', 22.0, 9500.0),
('Observatory I', 9, 'Bresser', 24.0, 1420.0),
('Observatory J', 10, 'Levenhuk', 26.0, 1020.0);

-- Observations
INSERT INTO Observation (Object_name, Description, Start_date, End_date, Keeper_ID, Telescope_ID, Telescope_observatory_name, Telescope_observatory_address) VALUES
('Milky Way', 'Observation of the Milky Way''s center', '2015-11-11', NULL, 1, 1, 'Observatory A', 1),
('Andromeda', 'Observation of Andromeda galaxy', '2018-07-10', '2018-12-12', 2, 2, 'Observatory B', 2),
('Sun', 'Observation of Sun', '1990-01-01', NULL, 3, 3, 'Observatory C', 3),
('Black Eye Galaxy', 'Observation of Black Eye Galaxy', '2017-04-04', '2022-05-05', 4, 4, 'Observatory D', 4),
('Proxima Centauri', 'Observation of Proxima Centauri', '2021-12-01', NULL, 5, 5, 'Observatory E', 5),
('Kepler-47', 'Observation of Kepler-47', '2012-10-10', '2022-01-12', 6, 6, 'Observatory F', 6),
('Mercury', 'Observation of Mercury atmosphere', '2018-01-01', '2022-01-01', 7, 7, 'Observatory G', 7),
('Mars', 'Observation of Mars surface', '2005-12-16', NULL, 8, 8, 'Observatory H', 8),
('Kepler-47c', 'Observation of Kepler-47c', '2003-12-18', '2010-09-09', 9, 9, 'Observatory I', 9),
('Makemake', 'Observation of Makemake', '2001-11-13', NULL, 10, 10, 'Observatory J', 10),
('Venus', 'Observation of Venus surface', '2005-01-01', '2007-05-11', 1, 1, 'Observatory A', 1),
('Betelgeuse', 'Observation of Betelgeuse surface', '1998-11-10', '2020-01-21', 1, 2, 'Observatory B', 2);

-- Measurements
INSERT INTO Measurement (Observation_ID, Distance, Magnitude, Radius, Mass, Temperature, Time) VALUES 
(1, 800000000, -5, 830000000, 115000000, 150000, '2015-12-12 12:00:00'),
(1, 793500000, -5.5, 840000000, 114000000, 160000, '2016-10-18 13:25:00'),
(1, 827700000, -4, 830000000, 113000000, 164000, '2018-10-10 14:25:00'),

(2, 766125000, -21, 211000000, 160000000, 240000, '2018-10-04 11:00:00'),
(2, 765000000, -21.5, 264000000, 150000000, 254100, '2018-11-01 23:25:10'),
(2, 764951000, -22, 254000000, 140000000, 262948, '2018-12-01 14:15:15'),

(3, 1, -27, 695700, 20077500, 5772, '1991-01-01 14:59:59'),
(3, 1, -27, 696342, 19800500, 5800, '1999-10-13 10:11:12'),
(3, 1, -27, 695000, 19004099, 5750, '2004-11-12 11:12:13'),

(4, 124240000, 8.5, 152000000, 250000000, 262948, '2017-10-04 08:07:06'),
(4, 125401000, 8.24, 145200000, 24270000, 260000, '2018-11-01 05:06:07'),
(4, 134001220, 9, 145750000, 21000000, 250000, '2019-12-01 01:02:02'),

(5, 665101200, 13, 43322102, 720473200, 245210, '2021-12-10 09:09:09'),
(5, 664104622, 14.5, 47722120, 715332738, 242400, '2022-05-11 04:03:01'),
(5, 664104622, 14.5, 45522140, 718332738, 245000, '2022-10-13 03:02:04'),

(6, 154000000, 12.4, 19294191, 15410, 250198, '2015-11-01 01:02:00'),
(6, 154125000, 12, 19204040, 14570, 275198, '2018-10-04 18:12:12'),
(6, 154951000, 13, 12494112, 19801, 270198, '2021-12-01 20:14:20'),

(7, 1.20, 20, 695700, 170100, 12300, '2019-01-01 17:12:12'),
(7, 1.21, 21, 696342, 170003, 12300, '2020-10-13 19:10:10'),
(7, 1.22, 20, 695000, 180100, 13000, '2021-11-12 17:00:00'),

(8, 124240000, 1, 5200000, 82500000, 88976, '2006-10-04 19:10:10'),
(8, 125401000, 1.5, 4520000, 8242000, 98976, '2007-11-01 16:14:12'),
(8, 134001220, 2, 4575000, 8210000, 88976, '2008-12-01 13:16:17'),

(9, 21500, -10, 25795130, 1440022, 3212, '2004-01-01 17:12:12'),
(9, 21532, -10.5, 25795120, 1440022, 3140, '2005-10-13 19:19:17'),
(9, 31700, -10.2, 25795000, 1440020, 3450, '2009-11-12 12:10:20'),

(10, 123000, 29, 331520000, 4250000, 24053, '2001-10-04 15:12:31'),
(10, 126000, 28, 331452000, 4242700, 22053, '2002-11-01 21:30:31'),
(10, 120000, 28, 331457500, 4210000, 21053, '2010-12-01 23:49:49'),

(11, 1.14, NULL, 1520000, NULL, 243, '2005-10-04 00:01:03'),
(11, 1.15, NULL, 1124000, NULL, 223, '2006-11-01 14:14:10'),
(11, 1.13, NULL, 1457000, NULL, 253, '2007-04-01 21:37:00'),

(12, 15454, 0.5, 520000000, 194511400, 3600, '1999-10-04 00:11:03'),
(12, 15400, 0.4, 494000000, 194451000, 3550, '2015-11-01 15:14:10'),
(12, 14000, 0.6, 487000000, 194451000, 3700, '2019-04-01 20:17:00');

-- Donations
INSERT INTO Donation (Amount, Source, Goal, Date) VALUES
(1250000, 'NASA', 'For stars exploring', '2020-06-05'),
(1000000, 'ONZ', 'For searching aliens', '2012-04-01'),
(50000, 'POLSA', 'For better equipment', '2018-12-01');

INSERT INTO DonationObservation(Donation_ID, Observation_ID) VALUES
(1, 3),
(1, 5),
(1, 6),
(1, 12),
(2, 8),
(3, 1),
(3, 2),
(3, 4),
(3, 5),
(3, 6),
(3, 7);