
--problema 1
allsets :: a -> [[a]]
allsets n = [take x (iterate id n) | x <- [0,1..]]

--problema 2 
allDivisors :: Int -> [[Int]]
allDivisors n = [take (divTimes n m) (iterate id m) | m <- divisors n] 

divisors:: Int -> [Int]
divisors n = [x | x <- [2,3..n], n `mod` x == 0]

divTimes :: Int -> Int -> Int
divTimes n m 
    | n `mod` m /= 0 = 0
    | n `mod` m == 0  = 1 + (divTimes (n `div` m) m)
    
--problema 3
--3.1

data Expr a = Var String | Const a | Func String [Expr a] deriving Show

--3.2 
constLeaf:: Expr a -> [a]
constLeaf (Var a) = []
constLeaf (Const a) = [a]
constLeaf (Func _ l) = foldl (\acc x -> acc ++ (constLeaf x)) [] l

--3.3 
instance Functor Expr where
    fmap _ (Var a) = Var a
    fmap f (Const a) = Const (f a)
    fmap f (Func id1 l) = Func id1 (map (fmap f) l)
    
getList:: Expr a -> [Expr a]
getList (Func _ l) = l  

--problema 4
type Pair a = (String,a)
 
join :: Eq a => [Pair a] -> [Pair a] -> Maybe ([Pair a])
join l [] = Just l
join [] l = Just l
join l1 l2
    | result /= [] = Just result
    | otherwise = Nothing
    where result = join' l1 l2
	
join':: Eq a => [Pair a] -> [Pair a] -> [Pair a]
join' l1@(x:x2) l2@(y:ys) =
    if allDiferents l1 l2 
       then merge l1 l2
       else []
       
allDiferents :: Eq a => [Pair a] -> [Pair a] -> Bool
-- allDiferents l [] = True
-- allDiferents [] l = True
allDiferents l1 l2 = foldl (\acc x -> acc && (func x l2)) True l1

func :: Eq a => Pair a -> [Pair a] -> Bool
func s l = 
        if member /= Nothing &&  Just (snd s) == member
           then True
           else if member == Nothing 
           then True
           else False
    where member = lookup (fst s) l
          

merge :: Eq a => [Pair a] -> [Pair a] -> [Pair a]
merge l1 [] = l1
merge [] l2 = l2
merge l1@(x:xs) l2@(y:ys) 
    | (fst x) < (fst y) = x: merge xs l2
    | otherwise = y: merge l1 ys

    
