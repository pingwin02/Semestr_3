--Bibliografia: https://hhr-m.de/period/

-- Podzial na liczby pierwsze
dziel_na_pierwsze :: Integer -> Integer -> [Integer]
dziel_na_pierwsze _ 1 = [] 
dziel_na_pierwsze dzielnik liczba 
    | dzielnik * dzielnik > liczba = [liczba] -- liczba wieksza od sqrt(liczba) nie moze byc jej dzielinkiem
    | rem liczba dzielnik == 0 = dzielnik : dziel_na_pierwsze dzielnik (div liczba dzielnik)
    | otherwise = dziel_na_pierwsze (dzielnik + 1) liczba

podzial_na_pierwsze :: Integer -> [Integer]
podzial_na_pierwsze n = dziel_na_pierwsze 2 n



-- Obliczanie okresu liczby pierwszej 
okres_lp :: Integer -> Integer -> Integer
okres_lp q k
    | rem ((10^k)-1) q == 0 = k
    | otherwise = okres_lp q (k+1)

-- funkcja "interfejs" obslugujaca szczegolne przypadki (2, 5) i ustawiajaca domyslny argument dla funkcji "okres_lp"
dlugosc_okresu_pierwszej :: Integer -> Integer
dlugosc_okresu_pierwszej 2 = 0
dlugosc_okresu_pierwszej 5 = 0
dlugosc_okresu_pierwszej n = (okres_lp n 1)
    
    
-- inne   
maks_z_listy :: [Integer] -> Integer
maks_z_listy [] = 0
maks_z_listy (x:xs) = max x (maks_z_listy xs)


-- dlugosc okresu rozwiniecia dziesietnego liczby 1/k jest rowna najdluzszemu z rozwiniec liczb 1/pi gdzie pi jest i-ta liczba calkowita wchodzaca w sklad podzialu liczby k na liczby pierwsze
dlugosc_okresu_dowolnej :: Integer -> Integer
dlugosc_okresu_dowolnej n = maks_z_listy (map dlugosc_okresu_pierwszej (podzial_na_pierwsze n))

-- zlozenie wszystkiego w calosc
maks_rozwiniecie_1_n n = maks_z_listy (map dlugosc_okresu_dowolnej [1 .. n])

zadanie n = do
    let m = maks_rozwiniecie_1_n n
    filter (\x -> dlugosc_okresu_dowolnej x == m) ([1 .. n])


main :: IO()
main = do
  print (zadanie 123)