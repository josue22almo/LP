--problema 1
merge:: Ord a => [a] -> [a] -> [a]
merge [] s = s
merge s [] = s 
merge l1@(x:xs) l2@(l:ls) 
    | x < l = x: merge xs l2
    | x > l = l: merge l1 ls
    | otherwise = x:merge xs ls
    
mergeList:: Ord a => [[a]] -> [a]
mergeList = foldl merge []

--problema 2
-- mults :: [Integer] -> [Integer]
-- mults l = mergeList (\x )

--problema 3
--3.1
data Procs a = End | Skip (Procs a) | Unary (a -> a) (Procs a) | Binary (a -> a -> a) (Procs a) 

--3.2
exec:: [a] -> (Procs a) -> [a]
exec [] _ = []
exec l End = l
exec (x:xs) (Skip procs) = x:(exec xs procs )
exec (x:xs) (Unary f procs) = exec ((f x):xs) procs 
exec (x1:[]) (Binary f procs) = [f x1 x1]
exec (x1:x2:xs) (Binary f procs) = exec ((f x1 x2):xs) procs

--problema 4
--4.1
class Container c where
    emptyC :: c a -> Bool
    lengthC :: c a -> Int
    firstC :: c a -> a
    popC :: c a -> c a

--4.2
instance Container [] where
    emptyC = null
    lengthC = length
    firstC = head
    popC = tail
    
data Tree a = Empty | Node a [Tree a] deriving Show

instance Container Tree where
    emptyC Empty = True
    emptyC _ = False
    lengthC Empty = 0
    lengthC (Node a fills) = 1 + (foldl (\acc x -> acc + lengthC x) 0 fills)
    firstC (Node a fills) = a
    popC (Node a ((Node f1 fills):xs)) = (Node f1 (fills++xs))
    
iterator :: Container c => c a -> [a]
iterator cont = (firstC cont):(iterator (popC cont))
    
