import Data.Maybe


--2. Representació
type ID = String
               
data Command a = Copy ID ID | CAssign ID (CExpr a) | TAssign ID (TExpr a) | Split ID ID ID | Input ID 
                | Print (NExpr a) | Draw (TExpr a) | Seq [Command a] | Cond (BExpr a) (Command a) (Command a) 
                | Loop (BExpr a) (Command  a) | DeclareVector ID (NExpr a) | Push ID ID | Pop ID ID   
               

data BExpr a = And (BExpr a) (BExpr a) | Or (BExpr a) (BExpr a) | Not (BExpr a) 
           | Gt (NExpr a) (NExpr a) | Lt (NExpr a) (NExpr a) | Eq (NExpr a) (NExpr a)
           | Full ID | Empty ID 
           
data NExpr a = Var ID | Const a | Diameter ID | Length ID 
           | Plus (NExpr a) (NExpr a) | Minus (NExpr a) (NExpr a) | Times (NExpr a) (NExpr a)    

data TExpr a = TVar ID | Tube (NExpr a) (NExpr a) | Merge (TExpr a) (CExpr a) (TExpr a)        
data CExpr a = CVar ID | Connector (NExpr a) 



instance Show a => Show (Command a) where 
    show (Copy id1 id2) = id1 ++ " = " ++ id2 ++ "\n"
    show (CAssign id cexpr) = id ++ " = CONNECTOR " ++ show cexpr ++ "\n" 
    show (TAssign id texpr) = id ++ " = TUBE " ++ show texpr ++ "\n"
    show (Split id1 id2 id3) = "(" ++ id1 ++ "," ++ id2 ++ ") = SPLIT " ++ id3 ++ "\n"
    show (Input id) = "INPUT " ++ id ++ "\n"
    show (Print nexpr) = "PRINT " ++ show nexpr ++ "\n"
    show (Draw texp) = "DRAW TUBE" ++ show texp ++ "\n" 
    show (Seq l) = foldl (\ acc x -> acc ++ show x) "" l
    show (Cond cond cert false) = "IF " ++ show cond ++ "\n" ++ "ELSE" ++ "\n" ++ show false ++ "ENDIF \n"
    show (Loop cond commands) = "WHILE" ++ show cond ++ "\n" ++ show commands 
    show (DeclareVector id nexpr) = id ++ " = " ++ show nexpr ++ "\n" 
    show (Push id1 id2) = "PUSH " ++ id1 ++ " " ++ id2 ++ "\n" 
    show (Pop id1 id2) = "POP " ++ id1 ++ " " ++ id2 ++ "\n" 

instance Show a => Show (BExpr a) where
    show (And e1 e2) = "(" ++ show e1 ++ " AND " ++ show e2 ++ ")"
    show (Or e1 e2) = "(" ++ show e1 ++ " OR " ++ show e2 ++ ")"
    show (Not e) = "NOT " ++ show e
    show (Gt n1 n2) = show n1 ++ " > " ++ show n2
    show (Lt n1 n2) = show n1 ++ " < " ++ show n2
    show (Eq n1 n2) = show n1 ++ " == " ++ show n2
    show (Full id) = "FULL " ++ id
    show (Empty id) = "EMPTY " ++ id
    
instance Show a => Show (NExpr a) where
    show (Var id) = id
    show (Const c) =  (show c) 
    show (Diameter id) = "DIAMETER(" ++ id ++ ")"
    show (Length id) = "LENGTH(" ++ id ++ ")"
    show (Plus n1 n2) = (show n1) ++ " + " ++ (show n2)  
    show (Minus n1 n2) = (show n1) ++ " - " ++ (show n2)
    show (Times n1 n2) = (show n1) ++ " * " ++ (show n2)
    
instance Show a => Show (TExpr a) where
    show (TVar id) = id
    show (Tube n1 n2) = show n1 ++ " " ++ (show n2)    
    show (Merge t1 c t2) = "MERGE " ++ show t1 ++ " " ++ show c ++ " " ++ show t2
    
instance Show a =>  Show (CExpr a) where
    show (CVar id) = id
    show (Connector nexpr) = show nexpr
    
--3. Interpret
class SymTable m where 
    update:: m a -> String -> Val a -> m a  
    value:: m a -> String -> Maybe (Val a)
    start:: m a 
    
data Val a = VTube a a | VConnector a | VVector a | VVar a    deriving (Show,Eq)
   
type Pair a = (String, Val a) 

data ListMem a = LEmpty | LMem {getList:: [Pair a]} deriving Show

append:: ListMem a -> String -> Val a -> [Pair a]
append LEmpty s val = [(s,val)]
append (LMem []) s val = [(s,val)]
append (LMem mem@(l:ls)) s val  
     | fst l < s = l:(append (LMem ls) s val)
     | fst l == s = (s,val):ls
     | otherwise = (s,val):mem
            
binSearch:: [Pair a] -> String -> Int -> Int -> Maybe (Val a)
binSearch mem s l r 
     | l > r = Nothing
     | (fst (mem!!mid)) < s = binSearch mem s (mid+1) r
     | (fst (mem!!mid)) > s = binSearch mem s l (mid-1)
     | otherwise = Just $ snd $ mem!!mid
     where
          mid = (r+l) `div` 2

         
instance SymTable ListMem where
    update LEmpty s val = LMem [(s,val)]
    update mem s val = LMem $ append mem s val
    value LEmpty _ = Nothing
    value (LMem []) _ = Nothing
    value (LMem mem) s = binSearch mem s 0  ((length mem) -1)
    start = LEmpty
    
data BinSearchTree a = BEmpty | BNode (Pair a) (BinSearchTree a) (BinSearchTree a) deriving Show

instance SymTable BinSearchTree where
    update BEmpty s val = BNode (s,val) BEmpty BEmpty
    update (BNode a hi hd) s val 
        | fst a == s = BNode (s,val) hi hd
        | fst a > s = BNode a (update hi s val) hd
        | otherwise = BNode a hi (update hd s val)
    value BEmpty _ = Nothing
    value (BNode r hi hd) s 
        | fst r == s = Just (snd r)
        | fst r < s = value hi s
        | otherwise = value hd s
    start = BEmpty

--     data Command a = Copy ID ID | CAssign ID (CExpr a) | TAssign ID (TExpr a) | Split ID ID ID | Input ID 
--                 | Print (NExpr a) | Draw (TExpr a) | Seq [Command a] | Cond (BExpr a) (Command a) (Command a) 
--                 | Loop (BExpr a) (Command  a) | DeclareVector ID (NExpr a) | Push ID ID | Pop ID ID 
    
interpretCommand :: (Num a, Ord a, SymTable m) => m a -> [a] -> Command a -> ((Either String [a]), m a, [a])
interpretCommand mem l@(x:xs) (Copy id1 id2) = 
    if newValue /= (VVar 0) 
    then ((Right []), update mem id1 newValue , xs)
    else (Left ("Variable " ++ id2 ++ " is not available"), mem, l)
    where newValue = maybe2Val $ value mem id2 
-- interpretCommand mem l@(x:xs) (CAssign id (CVar id2)) =  
--     if valID2 /=
interpretCommand mem l@(x:xs) (Input id) = ((Right []), update mem id (VVar x) , xs)

maybe2Val:: (Num a, Ord a) => Maybe (Val a) -> Val a
maybe2Val = fromMaybe (VVar 0)