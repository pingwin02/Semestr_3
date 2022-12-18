-- Bibliografia: https://hhr-m.de/period/

-- Dla danej liczby naturalnej n istnieje ciąg ułamków od 1/2, 1/3, …, 1/n. 
-- Wskaż którego okres w reprezentacji dziesiętnej jest najdłuższy.

-- Podzial na liczby pierwsze
dzielNaPierwsze :: Integer -> Integer -> [Integer]
dzielNaPierwsze _ 1 = [1]
dzielNaPierwsze dzielnik liczba
    | dzielnik * dzielnik > liczba = [liczba] -- liczba wieksza od sqrt(liczba) nie moze byc jej dzielnikiem
    | rem liczba dzielnik == 0 = dzielnik : dzielNaPierwsze dzielnik (div liczba dzielnik)
    | otherwise = dzielNaPierwsze (dzielnik + 1) liczba

podzialNaPierwsze :: Integer -> [Integer]
podzialNaPierwsze = dzielNaPierwsze 2


-- Obliczanie okresu liczby pierwszej 
okresLp :: Integer -> Integer -> Integer
okresLp q k
    | rem ((10^k)-1) q == 0 = k
    | otherwise = okresLp q (k+1)

-- funkcja "interfejs" obslugujaca szczegolne przypadki (2, 5) 
-- i ustawiajaca domyslny argument dla funkcji "okresLp"
dlugoscOkresuPierwszej :: Integer -> Integer
dlugoscOkresuPierwszej 2 = 0
dlugoscOkresuPierwszej 5 = 0
dlugoscOkresuPierwszej n = okresLp n 1

-- dlugosc okresu rozwiniecia dziesietnego liczby 1/k jest rowna najdluzszemu z 
-- rozwiniec liczb 1/p_i gdzie p_i jest i-ta liczba calkowita wchodzaca w sklad podzialu 
-- liczby k na liczby pierwsze
dlugoscOkresuDowolnej :: Integer -> Integer
dlugoscOkresuDowolnej n = maximum (map dlugoscOkresuPierwszej (podzialNaPierwsze n))

-- zlozenie wszystkiego w calosc
maksRozwiniecie1_n :: Integer -> [Integer]
maksRozwiniecie1_n n = map dlugoscOkresuDowolnej [1 .. n]

zadanie n = do
    let m = maksRozwiniecie1_n n
    map fst $ filter (\(_, x) -> x == maximum m) $ zip [1..] m


main :: IO()
main = do
  print (zadanie 10)