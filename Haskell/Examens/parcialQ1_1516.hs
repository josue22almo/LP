
--problema 1
--1.1
quadrats :: [Integer]
quadrats = map (\x -> x*x) [1..]

--1.2
sumQuadrats :: Integer -> Bool
sumQuadrats n = n `elem` sums
    where sums = [sum $ take x quadrats | x <- [1..]]

    
-- merge:: [Int] -> [Int] -> [Int]  
merge [] l = l
merge l [] = l
merge l1@(x:xs) l2@(y:ys) 
    | x < y = x:merge xs l2
    | x > y = y:merge l1 ys
    | otherwise = x:merge xs ys
    
mergeList:: [[Int]] -> [Int]
mergeList = foldl merge []




-- mults l = 1:(mergeList (map (+1) (mults l))  )


