--1. ones OK
ones :: [Integer]
ones = 1:ones

--2. naturals OK
nats :: [Integer]
nats = nats' 0

nats' :: Integer -> [Integer]
nats' n = n:(nats' (n+1))

--3. integers 
ints :: [Integer]
ints = []

--4. triangulars OK 
triangulars :: [Integer]
triangulars = triangulars' 0
triangulars' n = (triangular n):(triangulars' (n+1))
triangular n = truncate ((n*(n+1))/2)

--5. factorials OK 
factorials :: [Integer]
factorials = factorials' 0
factorials' n= factorial n:(factorials' (n + 1))
factorial 0 = 1
factorial n = n * factorial (n-1)

--6. fibs OK
fibs :: [Integer]
fibs = 0:lfib 0 1

lfib n m = m:(lfib m (n+m))

--7. primes OK
primes :: [Integer]
primes = filter isPrime nats

--prime number function
isPrime:: Integer -> Bool
isPrime n
    | n < 2     = False
    | n == 2    = True
    | otherwise = primeRec n 2
    
primeRec:: Integer -> Integer -> Bool
primeRec n m
    | mod n m == 0  = False
    | n == m * m    = False
    | n < m * m     = True
    | otherwise     = primeRec n (m+1) 

--8. hammings
hammings :: [Integer]
hammings = []

--9. lookNsay
lookNsay :: [Int]
lookNsay = lNs 1


lNs n = look n ++ [(lNs (look n))]
look n = 
    let s = show n
    in digitToInt' (say s)

-- say :: String -> [Int]
   
say s 
    | null s   = []
    | otherwise =  
        let times = head (show (length (takeWhile (==h) s)))
            newS = dropWhile (==h) s
        in times:[h] ++ (say newS)
        where h = head s
        
          
digitToInt' :: [Char] -> Int
digitToInt' c = read c :: Int


--10. tartaglia
tartaglia :: [[Integer]]
tartaglia = triangle 0

triangle n = triangle_line n : triangle(n+1)
triangle_line n = [binomial x n | x <-[0..n]] 
binomial 0 _ = 1
binomial k n = truncate ((factorial n) / ((factorial k) * (factorial (n-k))))

