module PatientView exposing (patientView)

import Models exposing (Model)
import Html exposing (Html, text, h1, div, span, a)
import Material
import Material.Scheme as Scheme
import Material.Button as Button
import Material.Options exposing (cs)  -- NB Avoiding inline css; use cs to select community.css classes
import Material.List as Lists
import Material.Table as Table
import Material.Grid exposing (grid, size, cell, Device (..) )
import Dict as D exposing (..)
import Msgs exposing (Msg(..))
import PatientPageTypes exposing (Patient)

emptyPatient : Patient
emptyPatient = Patient 4000 "" "" "" [] []

patientView : Model -> Int -> Html Msg
patientView model id =
  let patient = (Maybe.withDefault emptyPatient) (D.get id model.patients)
  in div [] [ text patient.name ]
