module PatientViewOfPatient exposing (patientViewOfPatient)

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
import Material.Icons as Icons
import Material.Options as Options
import Material.Options exposing (css, cs, onClick, attribute)  -- NB Avoiding inline css; use cs to select community.css classes
import Material.List as Lists
import Material.Table as Table
import Material.Grid exposing (offset, grid, size, cell, Device (..) )
import Dict as D exposing (get)
import PatientPageTypes exposing (Patient, Entry, Drug, Appointment)
import Routing exposing (drugPath)
import Msgs exposing (Msg(..))


-- whole view

patientViewOfPatient : Model -> Html Msg
patientViewOfPatient model =
  div []
    (patient.appointments |>
      List.map viewAppointments)


















-- Appointments View


viewAppointments : Appointment -> Html Msg
viewAppointments appointment =
  grid [Options.css "height" "150px", Options.css "padding-bottom" "1px"] [ cell [offset All 2, size All 10]
          [Card.view [ Options.css "height" "inherit", Options.css "width" "inherit", Color.background (Color.color Color.Blue Color.S500)]
            [ Card.title [] [ Card.head [ white ] [span [] [text appointment.speciality], span [] [text appointment.date], span [] [text appointment.time]]]
            ]
          ]


















-- Letter View



















-- Drugs View

viewDrug : Drug -> Html Msg
viewDrug drug ->
  Table.table []
    [ Table.head []
      [ Table.tr []
        [ Table.th [] [ text "Drug" ]
        , Table.th [] [ text "Morning" ]
        , Table.th [] [ text "Lunchtime"]
        , Table.th [] [ text "Dinner"]
        , Table.th [] [ text "Bedtime"]
        ]
      , Table.tr []
        [ Table.th [] [ text drug.name]
        , Table.th [] [ Icons.i "done"]
        , Table.th [] []
        , Table.th [] []
        , Table.th [] []
        ]
      ]
    ]
