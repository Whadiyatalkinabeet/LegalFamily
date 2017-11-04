module Solve000001 exposing (..)

import Html

hit: Int -> Bool
hit x = (x%3==0) || (x%5==0)

main =
  Html.text (
    toString (
      (List.range 1 (1000-1)) |> List.filter hit |> List.sum
    )
  )

-- Looking for 233168 

-- These work for ding
--   Html.text (List.foldr (++) "" ((List.range 1 (1000-1)) |> List.map toString))
--   Html.text (toString ((List.range 1 (1000-1))))


