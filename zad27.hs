import Data.Char (intToDigit)
import Numeric (showIntAtBase)

palindromeSum :: Int -> Int
palindromeSum n = sum [x | x <- [1..n], isPalindrome (show x) && isPalindrome (toBinary x)]
  where
    toBinary x = showIntAtBase 2 intToDigit x ""
    isPalindrome s = (s == reverse s)

main = do
  let n1 = 10
  let n2 = 15
  print (palindromeSum n1)
  print (palindromeSum n2)