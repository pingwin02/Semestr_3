-- Dla danej liczby naturalnej n podaj sumę wszystkich liczb ≤ n, 
-- które jednocześnie są palindromami w reprezentacji dziesiętnej
-- i binarnej.

import Data.Char (intToDigit)
import Numeric (showIntAtBase)

palindromeSum :: Int -> Int
palindromeSum n = sum [x | x <- [1..n], isPalindrome (show x) && isPalindrome (toBinary x)]
  where
    toBinary x = showIntAtBase 2 intToDigit x ""
    isPalindrome s = s == reverse s

main = do
  let n = 10
  print (palindromeSum n)