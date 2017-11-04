module Routing exposing (Route, parseLocation)

import Navigation exposing (Location)
import UrlParser exposing (..)

type Route
    = WardView
    | PatientView Int
    | NotFoundRoute

matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ map WardView top
    , map PatientView (s "patients" </> string)
    , map WardView (s "ward")
    ]

parseLocation : Location -> Route
parseLocation location =
  case (parseHash matchers location) of
    Just route ->
      route
    Nothing ->
      NotFoundRoute
