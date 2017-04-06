--1. countIf
countIf :: (Int -> Bool) -> [Int] -> Int
countIf f l = sum [1 | x<-l, f x]

--2. pam
pam :: [Int] -> [Int -> Int] -> [[Int]]
pam l funcs = [ map f l | f <-funcs]

--3. pam2
pam2 :: [Int] -> [Int -> Int] -> [[Int]]
pam2 l funcs = [[f x | f <- funcs] | x <- l]

--4. filterFoldl
filterFoldl :: (Int -> Bool) -> (Int -> Int -> Int) -> Int -> [Int] -> Int 
filterFoldl pd func ini l = foldl (\acc x -> func acc x) ini parser_list
    where parser_list = [x | x <- l, pd x]
          
--5. insert & insertSort
insert :: (Int -> Int -> Bool) -> [Int] -> Int -> [Int] 
insert pd l n = 
    let left = [x | x <- l, pd x n]
        rigth = [x | x <- l, not(pd x n)]
    in left ++  [n] ++ rigth
     
insertionSort :: (Int -> Int -> Bool) -> [Int] -> [Int] 
insertionSort pd [] = []
insertionSort pd l = foldl (\acc x -> insert pd acc x) [] l

