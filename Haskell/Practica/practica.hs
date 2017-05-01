
type ID = String
               
data Command a = Copy a a | CAssign ID a | TAssign ID a 
                | Split a a a | Input a 
                | Print a | Draw a | Seq [a] | Cond a (Command a) (Command a) | Loop a (Command  a)
                | DeclareVector ID a | Push ID ID | Pop ID ID deriving (Show)    
               

data BExpr = And BExpr BExpr | Or BExpr BExpr | Not BExpr 
           | Gt NExpr NExpr | Lt NExpr NExpr  | Eq NExpr NExpr 
           | Full ID | Empty ID deriving (Show)    
           
data NExpr = Var ID | Const Integer | Diameter ID | Length ID 
           |Plus NExpr NExpr | Minus NExpr NExpr | Times NExpr NExpr deriving (Show)    

data TExpr = TVar ID | Tube NExpr NExpr | Merge TExpr CExpr TExpr deriving (Show)        
data CExpr = CVar ID | Connector NExpr deriving (Show)    



