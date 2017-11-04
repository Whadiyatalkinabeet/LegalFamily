module Solve000002 exposing (..)

import Html

fibsTo: Int -> List Int -> List Int
fibsTo m s = (
  let n = List.sum (List.take 2 s) in
    if (n>m) then s else (fibsTo m (n::s))
  )

isEven: Int -> Bool
isEven x = (x%2==0)

main =
  Html.text (
    toString (
      (fibsTo 4000000 [1,1]) |> List.filter isEven |> List.sum
    )
  )

-- Looking for 4613732
