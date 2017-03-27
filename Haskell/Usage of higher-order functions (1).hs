--1. equal
eql :: [Int] -> [Int] -> Bool 
eql l1 l2 = l1 == l2
--2. prod
prod :: [Int] -> Int 
-- prod [x]    = x
prod = foldl (*) 1 
--3. prodOfEvens 
prodOfEvens :: [Int] -> Int
prodOfEvens l  = prod (filter even l)
--4. powersOf2
powersOf2 :: [Int] 
powersOf2 = iterate (*2) 1
--5. scalarProduct
scalarProduct :: [Float] -> [Float] -> Float 
scalarProduct [] _  = 0
scalarProduct _ []  = 0
scalarProduct l1 l2
    | lg1 /= lg2    = 0
    | otherwise     = sum(zipWith (*) l1 l2)
    where lg1 = length l1
          lg2 = length l2
 