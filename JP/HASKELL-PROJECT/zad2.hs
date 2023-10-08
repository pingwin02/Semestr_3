-- Filip Gołaś s188776 Damian Jankowski s188597 Maciej Szefler s188614

-- Dla danej listy par współrzędnych kartezjańskich należy zwrócić listę 
-- tych par posortowaną wg amplitudy punktu we współrzędnych biegunowych.

-- Funkcja pomocnicza do przekształcania współrzędnych kartezjańskich na biegunowe
amplitude :: (Float, Float) -> Float
amplitude (x, y) = atan2 y x

compareAmplitude :: (Float, Float) -> (Float, Float) -> Ordering
compareAmplitude a b
  | amplitude a >= amplitude b = GT
  | otherwise = LT

-- Funkcja sortująca listę współrzędnych kartezjańskich według amplitudy we współrzędnych biegunowych
sortByAmplitude :: [(Float, Float)] -> [(Float, Float)]
sortByAmplitude [] = []
sortByAmplitude (a:xs) = sortByAmplitude [b | b <- xs, compareAmplitude b a == LT] ++ [a] ++ sortByAmplitude [b | b <- xs, compareAmplitude b a == GT]

main :: IO()
main = do
    let points = [(-1.0, 1.2), (0.0, 3.3), (0.1, 0.1), (10.0, 10.0), (10.0, 0.0), (1.0, -5.0)]
    print (sortByAmplitude points)