module Flags where

import System.Console.GetOpt
import System.Environment
import System.Exit
import Control.Monad
import System.IO
import Data.List
import DeBruijn

data Flag
    = Check
    | Unique
    | Clean
    | Help
    deriving (Eq,Ord,Enum,Show)


data Options = Options  { lenghtWord    :: Int
                        , alphabet      :: String
                        , flag          :: Flag
                        }

startOptions :: Options
startOptions = Options  { lenghtWord    = 3
                        , alphabet      = "01"
                        , flag          = Help
                        }


options :: [ OptDescr (Options -> Either String Options) ]
options =
    [ Option "c" ["check"]
        (NoArg
            (\opts-> Right opts { flag = Check}))
        "check if a sequence is a de Bruijn sequencence"

    , Option "u" ["unique"]
        (NoArg
            (\opts-> Right opts { flag = Unique}))
        "check if 2 sequences are distinct de Bruijn sequences"

    , Option "" ["clean"]
        (NoArg
            (\opts-> Right opts { flag = Clean}))
        "list cleaning"

    , Option "h" ["help"]
        (NoArg
            (\opts-> Right opts { flag = Help}))
        "Show help"
    ]

checkFlag :: Options -> IO ()
checkFlag (Options l alph flag) = do
    line <- getLine
    let listPair = (makeListPair (convert line) (convert line) [] (l))
    checkList listPair (l) (alph)

checkList' lst size alph = areEqual lst (mapM (const alph) [1..size])

rotate :: Int -> [a] -> [a]
rotate n xs = take (length xs) (drop n (cycle xs))

cycleCompareSeq' :: String -> String -> Int -> Bool
cycleCompareSeq' a b 0 = False
cycleCompareSeq' a b n = do
    if a == b then True
    else cycleCompareSeq' a (rotate 1 b) (n-1)

cycleCompareSeq :: String -> String -> Bool
cycleCompareSeq a b = length a == length b && cycleCompareSeq' a b (length b)

uniqueFlag :: Options -> IO ()
uniqueFlag (Options l alph flag) = do
    fstLine <- getLine
    sndLine <- getLine
    let fstLinePair = (makeListPair (convert fstLine) (convert fstLine) [] (l))
    let sndLinePair = (makeListPair (convert sndLine) (convert sndLine) [] (l))
    if checkList' fstLinePair l alph && checkList' sndLinePair l alph && cycleCompareSeq fstLine sndLine
        then putStrLn "OK"
        else
            putStrLn "KO"

cleanFlag :: Options -> List -> IO ()
cleanFlag (Options l alph flag) = undefined