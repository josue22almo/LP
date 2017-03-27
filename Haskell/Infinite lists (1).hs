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
lookNsay :: [Integer]
lookNsay = []

--10. tartaglia
tartaglia :: [[Integer]]
tartaglia = []

triangle_line n   = (binomial n-1 n)
binomial r n = truncate ((factorial n) / ((factorial r) * (factorial (r-r))))
