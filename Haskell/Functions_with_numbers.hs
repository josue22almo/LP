--absValu
absValue:: Int -> Int
absValue n
    | n < 0     = (-1) * n
    | otherwise = n
    
--power
power:: Int -> Int -> Int
power n m
    | m == 0    = 1
    | otherwise = n * power n (m-1)
    
--prime number function
isPrime:: Int -> Bool
isPrime n
    | n < 2     = False
    | n == 2    = True
    | otherwise = primeRec n 2
    
primeRec:: Int -> Int -> Bool
primeRec n m
    | mod n m == 0  = False
    | n == m * m    = False
    | n < m * m     = True
    | otherwise     = primeRec n (m+1)     
    
-- slowFib returns the n-th element of the Fibonacci     
slowFib:: Int -> Int 
slowFib n
    | n == 0    = 0
    | n == 1    = 1
    | otherwise = slowFib(n-1) + slowFib (n-2)
    
-- quickFib returns the n-th element of the Fibonacci     
quickFib:: Int -> Int
quickFib = fst . fib2

fib2 :: Int -> (Int,Int)
fib2 n
    | n == 0        = (0,1)
    | otherwise     = (f2,f2+f1)
    where (f1,f2)   = fib2 (n-1)
        
       
