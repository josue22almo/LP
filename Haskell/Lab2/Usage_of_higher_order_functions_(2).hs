--1. flaten
flatten :: [[Int]] -> [Int]
flatten = foldl (\acc x -> acc ++ x) []

--2. myLength
myLength :: String -> Int 
myLength = foldl (\acc x -> acc + 1) 0

--3. myReverse
myReverse :: [Int] -> [Int] 
myReverse = foldr (\x acc -> acc ++ [x]) []

--4. countln 
countIn :: [[Int]] -> Int -> [Int] 
countIn l n = foldr (\x acc -> (count x n):acc) [] l
    where count x n = length (filter (==n) x)
--5. firstWord
firstWord :: String -> String
firstWord s = takeWhile (/=' ') s1
    where s1 = dropWhile (==' ') s 