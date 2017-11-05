module DoctorViewOfPatient exposing (doctorViewOfPatient)

import Models exposing (Model)
import Html exposing (Html, text, h1, div, span, a, input)
import Html.Attributes exposing (style, type_, placeholder)
import Html.Events exposing (onInput)
import Routing exposing (patientPath)
import Material
import Material.Scheme as Scheme
import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Chip as Chip
import Material.Options as Options
import Material.Options exposing (css, cs, onClick, attribute)  -- NB Avoiding inline css; use cs to select community.css classes
import Material.List as Lists
import Material.Table as Table
import Material.Grid exposing (offset, grid, size, cell, Device (..) )
import Dict as D exposing (get, empty)
import PatientPageTypes exposing (Patient, Entry, Drug)
import Routing exposing (drugPath)
import Routing exposing (letterPath)
import Msgs exposing (Msg(..))

emptyPatient : Patient
emptyPatient = Patient 4000 "" "" "" [] []

emptyEntry : Entry
emptyEntry = Entry 0 "" "" PatientPageTypes.GP PatientPageTypes.Low False D.empty

white : Options.Property c m
white =
  Color.text Color.white


doctorViewOfPatient : Model -> Int -> Html Msg
doctorViewOfPatient model id =
  let patient = (Maybe.withDefault emptyPatient) (D.get id model.patients)
      entries = patient.entries
      viewEntries = List.map entryView entries
      drugpath = drugPath id
      letterpath = letterPath id
  in div [] [ div [] [ Button.render Mdl [0] model.mdl [Button.link drugpath] [text "Drugs"], 
                       Button.render Mdl [0] model.mdl [Button.link letterpath] [text "Letters"],
                       (newEntryInput model id),text "\n", div [style [("width", "100%")]] viewEntries]]

entryView : Entry -> Html Msg
entryView entry =
  let cardColor =
    case entry.importance of
      PatientPageTypes.High -> Color.Red
      PatientPageTypes.Intermediate -> Color.Amber
      PatientPageTypes.Low -> Color.Blue
  in grid [Options.css "height" "150px", Options.css "padding-bottom" "1px"] [ cell [offset All 2, size All 10]
          [text "13:34", Card.view [ Options.css "height" "inherit", Options.css "width" "inherit", Color.background (Color.color cardColor Color.S500)]
            [Card.title [] [ Card.head [ white ] [ text entry.title ] ] , Card.text [] [ text entry.text ]]]]

newEntryInput : Model -> Int -> Html Msg
newEntryInput model id =
  grid [Options.css "height" "150px", Options.css "padding-bottom" "1px"] [ cell [offset All 2, size All 10]
          [Card.view [ Options.css "height" "inherit", Options.css "width" "inherit", Color.background (Color.color Color.Blue Color.S500)]
            [ Card.title [] [ Card.head [ white ]
                [ input [type_ "text", placeholder "Title", onInput Title] [] ] ]
            , Card.text []
                [ input [type_ "text", onInput Text ] []]
            , Card.media []
                [Button.render Mdl [1] model.mdl
                  [ Button.ripple
                  , Button.raised
                  , Options.onClick (SubmitEntry id)
                  ]
                  [ text "Submit Entry"]
                  ]
              ]
            ]
          ]
