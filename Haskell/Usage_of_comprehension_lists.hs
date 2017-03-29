--1. myMap
myMap :: (a -> b) -> [a] -> [b] 
myMap f l = [f x | x <- l]
--2. myFilter
myFilter :: (a -> Bool) -> [a] -> [a] 
myFilter f l = [x | x <- l, f x]
--3. myZipWith (MAL)
myZipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
myZipWith _ _ [] = []
myZipWith _ [] _ = []
myZipWith f l1 l2 = [f x y | (x,y) <- zip l1 l2]
--4. given two lists of integers, returns the list that pairs the elements if the element of the second list divides the one in the first list
thingify :: [Int] -> [Int] -> [(Int, Int)]
thingify l1 l2 = [(x,y) | x <- l1, y <- l2, x `mod` y == 0]
--5. factors
factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]