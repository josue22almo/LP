data Tree a = Node a (Tree a) (Tree a) 
            | Empty deriving (Show)
--1
size:: Tree a -> Int
size Empty = 0
size (Node a a1 a2) = 1 + size a1 + size a2
--2
height:: Tree a -> Int 
height Empty = 0
height (Node a a1 a2) = 1 + (max (height a1) (height a2))
--3
equal::Eq a => Tree a -> Tree a -> Bool
equal Empty Empty = True
equal Empty _ = False
equal _ Empty = False
equal (Node a a1 a2) (Node b b1 b2) = (a == b) && (equal a1 b2) && (equal a2 b2)
--4
isomorphic::Eq a=> Tree a -> Tree a -> Bool
isomorphic Empty Empty = True
isomorphic Empty _ = False
isomorphic _ Empty = False
isomorphic (Node a a1 a2) (Node b b1 b2) = False
--5
preOrder:: Tree a -> [a]
preOrder Empty = []
preOrder (Node a a1 a2) = a:preOrder a1 ++ preOrder a2
--6
postOrder:: Tree a -> [a]
postOrder Empty = []
postOrder (Node a a1 a2) = postOrder a1 ++ postOrder a2 ++ [a]
--7
inOrder:: Tree a -> [a]
inOrder Empty = []
inOrder (Node a a1 a2) = inOrder a1 ++ [a] ++ inOrder a2
--8
breadthFirst::  Tree a -> [a]
breadthFirst Empty = []
breadthFirst (Node a Empty Empty) = [a]
breadthFirst (Node a Empty a2) = a:breadthFirst a2
breadthFirst (Node a a1 Empty)= a:breadthFirst a1
breadthFirst (Node a a1 a2) = a:breadthFirst' [a1,a2]

breadthFirst':: [Tree a] -> [a]
breadthFirst' [] = []
breadthFirst 

--9
build::Eq a => [a] -> [a] -> Tree a
build (x:[]) (y:[]) = Node x Empty Empty

--10
overlap:: (a->a->a)-> Tree a -> Tree a -> Tree a
overlap _ Empty a = a
overlap _ a Empty = a
overlap f (Node a a1 a2) (Node b b1 b2) = Node (f a b) (overlap f a1 b1) (overlap f a2 b2)
