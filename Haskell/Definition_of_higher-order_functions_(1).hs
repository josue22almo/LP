-- 1. myFoldl
myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl f acc [] = acc
myFoldl f acc (x:xs) = myFoldl f (f acc x) xs
-- 2. myFoldr
myFoldr :: (a -> b -> b) -> b -> [a] -> b
myFoldr f acc [] = acc
myFoldr f acc (x:xs) = f x (myFoldr f acc xs)
-- 3. myIterate OK
myIterate :: (a -> a) -> a -> [a]
myIterate f a = a:(myIterate f (f a))
-- 4. myUntil OK
myUntil :: (a -> Bool) -> (a -> a) -> a -> a
myUntil f g x 
    | f x       = x
    | otherwise = myUntil f g (g x)
-- 5. myMap OK
myMap :: (a -> b) -> [a] -> [b]
myMap _ [] = []
myMap f l = [f x | x <- l]
-- 6. myFilter OK
myFilter :: (a -> Bool) -> [a] -> [a]
myFilter f l = [x | x <- l, f x]
-- 7. myAll OK
myAll :: (a -> Bool) -> [a] -> Bool
myAll f l = foldr (\x acc -> if not(f x) then False else acc) True l
-- 8. myAny OK
myAny :: (a -> Bool) -> [a] -> Bool
myAny f l = foldr (\x acc -> if f x then True else acc) False l
-- 9. myZip OK
myZip :: [a] -> [b] -> [(a, b)]
myzip [] [] = []
myZip _ []  = []
myZip [] _  = [] 
myZip (x:xs) (y:ys) = (x,y):(myZip xs ys)
-- 10. myZipWith OK
myZipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
myZipWith _ [] [] = []
myZipWith _ _ []  = []
myZipWith _ [] _  = [] 
myZipWith f l1 l2 = [f x y | (x,y) <- myZip l1 l2]