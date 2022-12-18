-- Dla danej liczby naturalnej n podaj sumę wszystkich liczb ≤ n, 
-- które jednocześnie są palindromami w reprezentacji dziesiętnej
-- i binarnej.

palindromeSum :: Int -> Int
palindromeSum n = sum [x | x <- [1..n], isPalindrome (show x) && isPalindrome (toBinary x)]
  where
    isPalindrome s = s == reverse s

toBinary :: Int -> [Char]
toBinary 0 = []
toBinary 1 = show 1
toBinary n = toBinary n1 ++ d
   where
   r = mod n 2
   d = show r
   n1 = div n 2

main = do
  let n = 10
  print (palindromeSum n)