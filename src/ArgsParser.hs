module ArgsParser where

import System.Console.GetOpt
import System.Environment
import System.Exit
import Control.Monad
import System.IO
import Data.List
import Data.Char
import DeBruijn
import Flags

help = usageInfo "Usage: ./deBruijn n [a] [--check|--unique|--clean]" options

checkParams :: [String] -> Bool
checkParams x = True

mergeOpts :: Options -> [String] -> Options
mergeOpts (Options l alph flag) (x:y:_) = Options (read x :: Int) y flag
mergeOpts (Options l alph flag) [x] = Options (read x :: Int) alph flag
mergeOpts o [] = o

execOptions :: Options -> [String] -> IO ()
execOptions _ [] = exitWithUsage
execOptions opts args = case flag of
    Check   -> checkFlag opts'
    Unique  -> uniqueFlag opts'
    Clean   -> cleanFlag opts'
    _       -> putStrLn (generateSequence alph l )
    where opts'@(Options l alph flag) = mergeOpts opts args


exitWithUsage :: IO ()
exitWithUsage = do
    hPutStrLn stderr help
    exitWith (ExitFailure 84)

argsParser :: IO ()
argsParser = do
    argv <- getArgs
    case getOpt Permute options argv of
        (flags,params,[]) -> do
            if checkParams params == False
                then exitWithUsage
                else case foldM (flip id) startOptions flags of
                    Right opts -> do
                        execOptions opts params
                        exitWith ExitSuccess
                    Left errorMessage -> do
                        hPutStrLn stderr errorMessage
                        exitWithUsage
        _ -> exitWithUsage