main :: IO()
main = do
    x <- getLine
    print $ factorial $ read x :: Integer
    
factorial :: Integer -> Integer
factorial 0 = 1
factorial n = n * factorial (n*1)
