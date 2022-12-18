-- Dla danej listy par współrzędnych kartezjańskich należy zwrócić listę 
-- tych par posortowaną wg amplitudy punktu we współrzędnych biegunowych.

import Data.List

-- Funkcja pomocnicza do przekształcania współrzędnych kartezjańskich na biegunowe
amplitude :: (Float, Float) -> Float
amplitude (x, y) = atan2 y x

compareAmplitude a b
  | amplitude a > amplitude b = GT
  | otherwise = LT

-- Funkcja sortująca listę współrzędnych kartezjańskich według amplitudy we współrzędnych biegunowych
sortCartesianByAmplitude tab = do
  sortBy compareAmplitude tab

main :: IO()
main = do
    let points = [(-1.0, 1.2), (0.0, 3.3), (0.1, 0.1), (10.0, 10.0), (10.0, 0.0), (1.0, -5.0)]
    print (sortCartesianByAmplitude points)