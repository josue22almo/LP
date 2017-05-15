
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
    
func = [(x,y) | x <- [1..5] , y <- [1..5], y `mod` x == 0]