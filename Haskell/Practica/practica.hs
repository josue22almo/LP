
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
