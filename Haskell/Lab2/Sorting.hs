--1. insert and isort
--insert: given a sorted list and an element, correctly inserts the new element in the list.
--isort: implements insertion sort using the previous function.
insert::[Int] -> Int -> [Int] 
insert l x = p1 ++ [x] ++ p2
    where p1 = [n | n <- l, n <= x]
          p2 = [n | n <- l, n > x]
isort::[Int] -> [Int]
isort [] = []
isort (x:xs) = insert (isort xs) x

--2. remove and ssort
remove::[Int] -> Int -> [Int]
remove (x:xs) t 
    | x == t    = xs
    | otherwise = x:remove xs t
ssort::[Int] -> [Int] 
ssort [] = []
ssort (x:xs) = 
    let mini = minimum (x:xs)
        newl = remove (x:xs) mini
    in [mini] ++ ssort newl
        

--3. merge and msort
merge::[Int] -> [Int] -> [Int] 
merge x []  = x
merge [] x  = x  
merge l1@(x:xs) l2@(t:ts) 
    | x <= t    = x:(merge xs l2)
    | otherwise = t:(merge l1 ts)
msort::[Int] -> [Int]
msort []  = []
msort [x] = [x]
msort l   = 
    let l = msort (fst ll)
        r = msort (snd ll)
    in merge l r
    where n = (length l) `div` 2
          ll = splitAt n l

--4.Quick sort
qsort::[Int] -> [Int] 
qsort [] = []
qsort (x:xs) = 
    let smallS = qsort [t | t <- xs, t <= x]
        greaterS = qsort[t | t <- xs, t > x]
    in smallS ++ [x] ++ greaterS

--5. genQsort
genQsort::Ord a => [a] -> [a]
genQsort [] = []
genQsort [x] = [x]
genQsort (x:xs) = genQsort(fst (numb x xs)) ++ [x] ++ genQsort(snd (numb x xs))
    where
        numb :: Ord a => a -> [a] -> ([a],[a])
        numb _ [] = ([],[])
        numb n (y:ys)
            | y < n = (y:l1,l2)
            | otherwise = (l1,y:l2)
            where (l1,l2) = numb n ys