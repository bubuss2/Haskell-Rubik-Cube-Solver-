module SolveYellowFace where

import Rotations
import Types
import Utils
import Prelude hiding (Left, Right)

{-- Phase 4
solve Yellow face --}

solveYellowFace :: CubeWithMoves -> CubeWithMoves
solveYellowFace cube = positionYellowEdges $ positionYellowCorners $ solveYellowCorners $ solveYellowCross cube

{-- Phase 4.1
solve white cross --}

solveYellowCross :: CubeWithMoves -> CubeWithMoves
solveYellowCross cube = if checkYellowCross cube then cube else solveYellowCross $ fixYellowCross cube

checkYellowCross :: CubeWithMoves -> Bool
checkYellowCross cube =
  down !! 1 == Yellow
    && down !! 3 == Yellow
    && down !! 5 == Yellow
    && down !! 7 == Yellow
  where
    down = getSide Down (fst cube)

fixYellowCross :: CubeWithMoves -> CubeWithMoves
fixYellowCross cube
  | down !! 1 == Yellow && down !! 3 == Yellow = makeMoveAndNoteWhiteDown Back [F, U, R, U', R', F'] cube
  | down !! 1 == Yellow && down !! 5 == Yellow = makeMoveAndNoteWhiteDown Left [F, U, R, U', R', F'] cube
  | down !! 5 == Yellow && down !! 7 == Yellow = makeMoveAndNoteWhiteDown Front [F, U, R, U', R', F'] cube
  | down !! 3 == Yellow && down !! 7 == Yellow = makeMoveAndNoteWhiteDown Right [F, U, R, U', R', F'] cube
  | down !! 1 == Yellow && down !! 7 == Yellow = makeMoveAndNoteWhiteDown Left [F, U, R, U', R', F'] cube
  | down !! 3 == Yellow && down !! 5 == Yellow = makeMoveAndNoteWhiteDown Front [F, U, R, U', R', F'] cube
  | otherwise = makeMoveAndNoteWhiteDown Front [F, U, R, U', R', F'] cube
  where
    down = getSide Down (fst cube)

{-- Phase 4.2
solve Yellow corners --}

solveYellowCorners :: CubeWithMoves -> CubeWithMoves
solveYellowCorners cube = if checkYellowFace cube then cube else solveYellowCorners $ fixYellowCorners cube

fixYellowCorners :: CubeWithMoves -> CubeWithMoves
fixYellowCorners cube
  | down !! 2 == Yellow && (countYellowCorners cube == 1) = makeMoveAndNoteWhiteDown Front [R, U, R', U, R, U, U, R'] cube
  | right !! 6 == Yellow && (countYellowCorners cube == 0) = makeMoveAndNoteWhiteDown Front [R, U, R', U, R, U, U, R'] cube
  | front !! 8 == Yellow && (countYellowCorners cube == 2) = makeMoveAndNoteWhiteDown Front [R, U, R', U, R, U, U, R'] cube
  | otherwise = makeMoveAndNoteWhiteUp Front [D] cube
  where
    (front, left, back, right, up, down) = getSides (fst cube)

checkYellowFace :: CubeWithMoves -> Bool
checkYellowFace cube =
  down !! 0 == Yellow
    && down !! 1 == Yellow
    && down !! 2 == Yellow
    && down !! 3 == Yellow
    && down !! 5 == Yellow
    && down !! 6 == Yellow
    && down !! 7 == Yellow
    && down !! 8 == Yellow
  where
    down = getSide Down (fst cube)

countYellowCorners :: CubeWithMoves -> Int
countYellowCorners cube = foldl (\acc index -> if down !! index == Yellow then acc + 1 else acc) 0 [0, 2, 6, 8]
  where
    down = getSide Down (fst cube)

{-- Phase 4.3
position corners--}

positionYellowCorners :: CubeWithMoves -> CubeWithMoves
positionYellowCorners cube = if checkYellowCorners cube then cube else positionYellowCorners $ positionYellowCorners' cube

checkYellowCorners :: CubeWithMoves -> Bool
checkYellowCorners cube =
  front !! 6 == Red && front !! 8 == Red
    && left !! 6 == Green
    && left !! 8 == Green
    && right !! 6 == Blue
    && right !! 8 == Blue
    && back !! 6 == Orange
    && back !! 8 == Orange
  where
    (front, left, back, right, up, down) = getSides (fst cube)

positionYellowCorners' :: CubeWithMoves -> CubeWithMoves
positionYellowCorners' cube
  | back !! 6 == Orange && back !! 8 == Orange = makeMoveAndNoteWhiteDown Front [R', F, R', B, B, R, F', R', B, B, R, R] cube
  | front !! 6 == Red && front !! 8 == Red = makeMoveAndNoteWhiteDown Back [R', F, R', B, B, R, F', R', B, B, R, R] cube
  | right !! 6 == Blue && right !! 8 == Blue = makeMoveAndNoteWhiteDown Left [R', F, R', B, B, R, F', R', B, B, R, R] cube
  | left !! 6 == Green && left !! 8 == Green = makeMoveAndNoteWhiteDown Right [R', F, R', B, B, R, F', R', B, B, R, R] cube
  | isTwoCorrectCorners cube = makeMoveAndNoteWhiteDown Front [R', F, R', B, B, R, F', R', B, B, R, R] cube
  | otherwise = makeMoveAndNoteWhiteUp Front [D] cube
  where
    (front, left, back, right, up, down) = getSides (fst cube)

isTwoCorrectCorners :: CubeWithMoves -> Bool
isTwoCorrectCorners cube =
  ( front !! 6 == Red && left !! 8 == Green
      && back !! 6 == Orange
      && right !! 8 == Blue
  )
    || ( front !! 8 == Red && right !! 6 == Blue
           && back !! 8 == Orange
           && left !! 6 == Green
       )
  where
    (front, left, back, right, up, down) = getSides (fst cube)

{-- Phase 4.4
Position yellow edges --}

positionYellowEdges :: CubeWithMoves -> CubeWithMoves
positionYellowEdges cube = if checkYellowEdges cube then cube else positionYellowEdges $ positionYellowEdges' cube

checkYellowEdges :: CubeWithMoves -> Bool
checkYellowEdges cube =
  front !! 7 == Red
    && left !! 7 == Green
    && right !! 7 == Blue
    && back !! 7 == Orange
  where
    (front, left, back, right, up, down) = getSides (fst cube)

positionYellowEdges' :: CubeWithMoves -> CubeWithMoves
positionYellowEdges' cube
  | isSideSolved cube Front = makeMoveAndNoteWhiteDown Back [F, F, U, L, R', F, F, L', R, U, F, F] cube
  | isSideSolved cube Right = makeMoveAndNoteWhiteDown Left [F, F, U, L, R', F, F, L', R, U, F, F] cube
  | isSideSolved cube Back = makeMoveAndNoteWhiteDown Front [F, F, U, L, R', F, F, L', R, U, F, F] cube
  | isSideSolved cube Left = makeMoveAndNoteWhiteDown Right [F, F, U, L, R', F, F, L', R, U, F, F] cube
  | otherwise = makeMoveAndNoteWhiteDown Front [F, F, U, L, R', F, F, L', R, U, F, F] cube
  where
    (front, left, back, right, up, down) = getSides (fst cube)

isSideSolved :: CubeWithMoves -> Side -> Bool
isSideSolved cube side =
  colors !! 0 == targetColor
    && colors !! 1 == targetColor
    && colors !! 2 == targetColor
    && colors !! 3 == targetColor
    && colors !! 5 == targetColor
    && colors !! 6 == targetColor
    && colors !! 7 == targetColor
    && colors !! 8 == targetColor
  where
    colors = getSide side (fst cube)
    targetColor = getTargetSideColor side