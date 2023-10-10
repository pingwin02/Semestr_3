USE CelestialObjects

--1. Gazeta chce zrobić artykuł na temat najbardziej prestiżowych astronomów. 
--	Utwórz zestawienie imion i nazwisk opiekunów obserwacji 
--	i sumy otrzymanych na ich obserwacje grantów, posortuj po sumie grantów od najwyższej do najniższej.

	DROP VIEW [Most prestige Observation Keepers]

	CREATE VIEW [Most prestige Observation Keepers] AS
	SELECT ObservationKeeper.First_name, ObservationKeeper.Last_name, SUM(Donation.Amount) AS Sum FROM DonationObservation
	JOIN Donation ON DonationObservation.Donation_ID = Donation.ID
	JOIN Observation ON DonationObservation.Observation_ID = Observation.ID
	JOIN ObservationKeeper ON Observation.Keeper_ID = ObservationKeeper.ID
	GROUP BY ObservationKeeper.First_name, ObservationKeeper.Last_name
	GO 
	SELECT * FROM [Most prestige Observation Keepers]
	ORDER BY Sum DESC;

--2. Kanał naukowy na serwisie youtube chce utworzyć materiał na temat największych znanych ludzkości gwiazd.
--	Zrób zestawienie znanych nazw gwiazd i jej pomiarów (tylko najnowszych w miarę możliwości), sortujac malejąco po promieniu.

	SELECT Name, Measurement.* FROM Measurement JOIN
	(SELECT AstronomicalObject.Name, Max(Measurement.Time) AS NewestDate FROM Measurement
	JOIN Observation ON Measurement.Observation_ID = Observation.ID
	JOIN AstronomicalObject ON AstronomicalObject.Name = Observation.Object_name
	WHERE AstronomicalObject.Type = 'star'
	GROUP BY AstronomicalObject.Name) AS NewestStarMeasurement
	ON Measurement.Time = NewestStarMeasurement.NewestDate
	ORDER BY Measurement.Radius DESC

--3. Zespół astronomów bada supernowe. Potrzebują listy gwiazd, które mogą w najbliższym czasie się w nie przekształcić. 
--	Podaj listę wszystkich gwiazd, które mają masę większą niż masa 8 słońc, a ich ostatni pomiar był wcześniej niż rok temu.

	DECLARE @AvgSunMass AS INT
	SET @AvgSunMass = (SELECT AVG(Measurement.Mass) FROM Measurement 
	JOIN Observation ON Measurement.Observation_ID = Observation.ID
	JOIN AstronomicalObject ON AstronomicalObject.Name = Observation.Object_name
	WHERE AstronomicalObject.Name = 'Sun' )

	SELECT Name, AVG(Mass) AS Avg_Mass FROM Measurement
	JOIN Observation ON Measurement.Observation_ID = Observation.ID
	JOIN AstronomicalObject ON AstronomicalObject.Name = Observation.Object_name
	WHERE AstronomicalObject.Type = 'star' and Measurement.Mass > (8 * @AvgSunMass) and Measurement.Time < DATEADD(year, -1, GETDATE())
	GROUP BY Name

--4. Utwórz zestawienie teleskopów obserwujących planety, zestawienie posortuj rosnąco wg rozmiaru teleskopów.
--	(Obserwatorzy chcą sprawdzić jakie planety są obserwowane przez jakie teleskopy)

	SELECT Telescope.*, Object_name FROM Observation
	JOIN AstronomicalObject ON AstronomicalObject.Name = Observation.Object_name
	JOIN Telescope ON Telescope.ID = Observation.Telescope_ID
	WHERE AstronomicalObject.Type = 'planet'
	ORDER BY Telescope.Diameter ASC

--5. Podaj przez ile dni i w jakim obserwatorium obserwowano wszystkie obiekty. Posortuj malejąco.
--  (Obserwatorzy chcą sprawdzić jakie obserwacje są lub były prowadzone najdłużej)

	SELECT Object_Name, DATEDIFF(day, Observation.Start_Date, CASE WHEN Observation.End_date IS NULL THEN GETDATE() ELSE Observation.End_date END) AS Days, 
	CASE WHEN Observation.End_date IS NULL THEN 'No' ELSE 'Yes' END AS Ended, Observatory.Name, Observation.Description FROM Observation
	JOIN Telescope ON Observation.Telescope_ID = Telescope.ID
	JOIN Observatory ON Observation.Telescope_observatory_name = Observatory.Name
	ORDER BY Days DESC

--6. Pod jakim adresem znajduje się obserwatorium z którego dokonano najbardziej odległego pomiaru?
--	(Obserwatorzy planują pobić rekord w odległości pomiaru, w tym celu szukają najlepszego miejsca)

	SELECT TOP 1 Address.*, Max_Distance, Observation.Object_name FROM Observation JOIN 
	(SELECT Observation_ID, Max(Distance) AS Max_Distance FROM Measurement
	GROUP BY Measurement.Observation_ID) AS FarthestMeasurement
	ON Observation.ID = FarthestMeasurement.Observation_ID
	JOIN Address ON Observation.Telescope_observatory_address = Address.ID
	ORDER BY Max_Distance DESC

-- 7. Studenckie koło naukowe prowadzi własne pomiary wybranego obiektu i chciałoby je porównać z tymi uzyskanymi w danym okresie przez teleskopy z tego samego kraju.
-- Podaj wszystkie pomiary obiektu X, w okresie Y z obserwacji prowadzonych przez teleskopy znajdujących się w obserwatoriach w kraju Z.

	SELECT Object_name, Measurement.*, Address.Country FROM Measurement
	JOIN Observation ON Observation.ID = Measurement.Observation_ID
	JOIN Address ON Address.ID = Observation.Telescope_observatory_address
	WHERE Observation.Object_name = 'Venus' AND Address.Country = 'Poland' AND Measurement.Time > '2006' AND Measurement.Time < '2007'


-- 8. Student chce sprawdzić, do jakiej konstelacji należy najwięcej gwiazd
-- Podaj ile gwiazd należy do każdej konstelacji. Posortuj malejąco po ilości

	SELECT Constellation.Name, COUNT(Star.Name) AS Number_Of_Stars FROM Star
	RIGHT JOIN Constellation ON Constellation.Name = Star.In_constellation
	GROUP BY Constellation.Name
	ORDER BY Number_Of_Stars DESC

-- 9. NASA chce zrobić ranking obserwatorów obserwacji.
-- Podaj ilość obserwacji dla każdego opiekuna. Posortuj malejąco

	SELECT ObservationKeeper.First_name, ObservationKeeper.Last_name, COUNT (Observation.ID) AS No_Of_Observations FROM ObservationKeeper
	JOIN Observation ON Observation.Keeper_ID = ObservationKeeper.ID
	GROUP BY ObservationKeeper.First_name, ObservationKeeper.Last_name
	ORDER BY No_Of_Observations DESC