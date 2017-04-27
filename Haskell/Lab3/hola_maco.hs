main :: IO()
main = do
    name <- getLine
    putStrLn $ hola_maco name
       
hola_maco :: String -> String
hola_maco s 
    | dona s    = "Hola maca!"
    | otherwise = "Hola maco!"
    
dona s = l == 'a' || l == 'A'
    where l = last s
          
          
main2 :: IO()
main2 = getLine >>= \name -> putStrLn $ hola_maco name

main3 :: IO()
main3 = do
    name <- getLine
    sexe <- iohola_maco name
    putStrLn sexe
    
iohola_maco :: String -> IO String
iohola_maco s 
    | dona s    = return $ "Hola maco!"
    | otherwise = return $ "Hola maca!"
