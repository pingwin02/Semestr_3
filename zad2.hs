--Dla danej listy par współrzędnych kartezjańskich należy zwrócić listę tych par posortowaną wg
--amplitudy punktu we współrzędnych biegunowych.
import Data.List

amplituda :: (Float, Float) -> Float
amplituda w = sqrt (fst w * fst w + snd w * snd w)

porownanieAmplitudy a b
  | amplituda a > amplituda b = GT
  | amplituda a < amplituda b = LT
  
sortWgAmplitudy :: [(Float, Float)] -> [(Float, Float)]
sortWgAmplitudy lista = sortBy porownanieAmplitudy lista

main :: IO()
main = do
    let points = [(1.0, 1.2), (0.0, 3.3), (0.1, 0.1), (10.0, 10.0), (10.0, 0.0)]
    print (sortWgAmplitudy points)