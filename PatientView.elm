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
import PatientPageTypes exposing (Patient, Entry)

emptyPatient : Patient
emptyPatient = Patient 4000 "" "" "" [] []

emptyEntry : Entry
emptyEntry = Entry 0 "" "" PatientPageTypes.GP PatientPageTypes.Low False

patientView : Model -> Int -> Html Msg
patientView model id =
  let patient = (Maybe.withDefault emptyPatient) (D.get id model.patients)
      entries = patient.entries
  in div [] [ text patient.name, text "\n", entryIterator entries ]


entryIterator : List Entry -> Html Msg
entryIterator entries = 
    case entries of
      [] -> div [] []
      (x::xs) -> let entry = x
                 in div [] [ text entry.title, entryIterator xs]

