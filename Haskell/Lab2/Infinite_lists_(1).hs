--1. ones OK
ones :: [Integer]
ones = 1:ones

--2. naturals OK
nats :: [Integer]
nats = nats' 0

nats' :: Integer -> [Integer]
nats' n = n:(nats' (n+1))

--3. integers OK
ints :: [Integer]
ints = 0:createIntList 1 1 

createIntList n p 
    | odd p     = n:(createIntList n (p+1))
    | otherwise = ((-1)*n):(createIntList (n+1) (p+1))

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
hammings = 1 : weave hammings hammings hammings
  where
    weave (x2:x2s) (x3:x3s) (x5:x5s) = minX : weave x2s' x3s' x5s'
      where
        (x2',x3',x5') = (2*x2,3*x3,5*x5)
        minX = minimum [x2', x3', x5']
        x2s' = if x2' <= minX then x2s else x2:x2s
        x3s' = if x3' <= minX then x3s else x3:x3s
        x5s' = if x5' <= minX then x5s else x5:x5s



--9. lookNsay OK
lookNsay :: [Integer]
lookNsay = lNs 1
lNs n = n:(lNs (look n))

look n = 
    let ln = tail (reverse (convertToList n))
    in createInt (reverse (say ln))
say ln 
    | null ln   = []
    | otherwise =
        let times = fromIntegral (length (takeWhile (==h) ln)) 
            newln = dropWhile (==h) ln
        in times:[h] ++ (say newln)
    where h = head ln

--convert a Int to a list of digits
convertToList 0 = [0]
convertToList n = (n `mod` 10):(convertToList (n `div` 10))
--create Integer number from a list of digits
createInt = foldr (\ x acc -> addDigit acc x) 0 
addDigit a b = a * 10 + b
          
digitToInt' :: [Char] -> Int
digitToInt' c = read c :: Int


--10. tartaglia OK
tartaglia :: [[Integer]]
tartaglia = triangle 0

triangle n = triangle_line n : triangle(n+1)
triangle_line n = [binomial x n | x <-[0..n]] 
binomial 0 _ = 1
binomial k n = truncate ((factorial n) / ((factorial k) * (factorial (n-k))))

