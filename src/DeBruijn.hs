module DeBruijn where

import System.IO
import System.Exit
import System.Environment
import Data.List
import Data.Dynamic

convert line = (map (:[]) line)

makeListPair tmp list new size
    | (length list) == 0    = reverse new
    | (length list) < size  = makeListPair tmp (tail list) (((intercalate "" list) ++ (intercalate "" (fst (splitAt (size - (length list)) tmp)))) : new) size
    | (length list) >= size = makeListPair tmp (tail list) ((intercalate "" (fst (splitAt size list))) : new) size

makeListTmp list new size
    | (length list) >= size = makeListTmp (tail list) ((intercalate "" (fst (splitAt size list))) : new) size
    | otherwise             = new

allDifferent list = case list of
    []      -> True
    (x:xs)  -> x `notElem` xs && allDifferent xs

areEqual a b = sort a == sort b

checkList lst size alph = do
    let isOk = areEqual lst (mapM (const alph) [1..size])
    if isOk then do putStrLn "OK"
    else do putStrLn "KO"

checkIfElem x l 
    | x `elem` l    = True
    | otherwise     = False

generateNumBis :: [String] -> Int -> String -> String -> String -> String -> String
generateNumBis lst pos alph new ret tot
    | (pos == (length alph)) = do 
        let tmp = (alph!!0) : new
        if (checkIfElem (reverse tmp) lst) == True then do
            tot
        else do
            reverse (tmp ++ ret)
    | otherwise             = do
        let tmp = (alph!!pos) : new
        if (checkIfElem (reverse tmp) lst) == True then do
            generateNumBis lst (pos + 1) alph new ret tot
        else do
            reverse (tmp ++ ret)

generateNum :: String -> Int -> String -> Int -> String
generateNum line sizeMax alph size
    | sizeMax == 0      = line 
    | sizeMax /= 0      = do
        let tmp = makeListTmp (convert line) [] size
        let tpl = splitAt (size - 1) (reverse line)
        generateNum (generateNumBis tmp 1 alph (fst tpl) (snd tpl) line) (sizeMax - 1) alph size

generateSequence :: String -> Int -> String
generateSequence alph size = do
    let sizeMax = (length alph) ^ size
    fst (splitAt sizeMax (generateNum (map (const (head alph)) [1..size]) sizeMax alph size))