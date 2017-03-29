--1. myLength -> returns the length of a list         
myLength:: [Int] -> Int
myLength l = sum[1 | _ <-l]

--2. myMaximum -> returns the maximum of a list
myMaximum:: [Int] -> Int
myMaximum[x] = x
myMaximum (x:xs) = max x (myMaximum xs)

--3. average
average:: [Int] -> Float
average l = (fromIntegral(sumList l)) / (fromIntegral(myLength l))

sumList::[Int] -> Int
sumList [] = 0
sumList (x:xs) = x +(sumList xs)

--4. buildPalindrome
buildPalindrome:: [Int] -> [Int]
buildPalindrome l = r ++ l
    where r = reverse l
          
--5. Remove
remove:: [Int] -> [Int] -> [Int]
remove first second = [x | x <- first, x `notElem` second]    

--6. Flatten
flatten:: [[Int]] -> [Int]
flatten [] = []
flatten (x:xs) = x ++ (flatten xs)

--7. oddsNevens
oddsNevens:: [Int]-> ([Int],[Int])
oddsNevens l = (od, ev)
    where od = [x | x <- l, odd x]
          ev = [x | x <- l, even x]
          
--8. primeDivisors
primeDivisors:: Int -> [Int]
primeDivisors n = [x | x <- [2..(n)], isPrime x, n `mod` x == 0]

--prime number function
isPrime:: Int -> Bool
isPrime n
    | n < 2     = False
    | n == 2    = True
    | otherwise = primeRec n 2

primeRec:: Int -> Int -> Bool
primeRec n m
    | mod n m == 0  = False
    | n == m * m    = False
    | n < m * m     = True
    | otherwise     = primeRec n (m+1)     
    
