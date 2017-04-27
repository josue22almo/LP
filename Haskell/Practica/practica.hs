
data Command a = Copy a | TAssign a | CAssign a | Split a | Input a 
               | Print a | Draw a | Seq [Command a] | Cond a | Loop a 
               | DeclareVector a | Push a | Pop a