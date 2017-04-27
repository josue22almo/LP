
main :: IO()
main = do
    line <- getLine
--     let [x1,x2,x3] = words line
--     let imc = indexMassaCorporal x2 x3   
--     putStrLn $ persona x1 imc
    if line /= "*" then do
        let [x1,x2,x3] = words line
        let imc = indexMassaCorporal x2 x3   
        putStrLn x1 ++ " " ++ imc

indexMassaCorporal m h 
    | imc < 18              = "magror"
    | imc >= 18 && imc < 25 = "corpulència normal"
    | imc >= 25 && imc < 30 = "sobrepès"
    | imc >= 30 && imc < 40 = "obesitat"
    | otherwise = " obesitat mòbida"
    where imc = m / (h*h)

persona x1 imc = x1 ++ " " ++ imc 
