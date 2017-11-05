module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)

type Route
    = WardRoute
    | DoctorRoute Int
    | DrugRoute Int
    | NotFoundRoute

matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ map WardRoute top
    , map DoctorRoute (s "patients" </> int)
    , map WardRoute (s "ward")
    , map DrugRoute (s "drugs" </> int)
    ]

patientsPath : String
patientsPath = "#patients"

patientPath : Int -> String
patientPath id = "#patients/" ++ (toString id)

drugPath : Int -> String
drugPath id = "#drugs/" ++ (toString id)

parseLocation : Location -> Route
parseLocation location =
  case (parseHash matchers location) of
    Just route ->
      route
    Nothing ->
      NotFoundRoute
