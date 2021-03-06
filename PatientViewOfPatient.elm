module PatientViewOfPatient exposing (patientViewOfPatient)

import Models exposing (Model)
import Html exposing (Html, text, h1, div, span, a, input)
import Html.Attributes exposing (style, class)
import Html.Events exposing (onInput)
import Routing exposing (patientPath)
import Material
import Material.Scheme as Scheme
import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Options as Options
import Material.Options exposing (css, cs, onClick, attribute)  -- NB Avoiding inline css; use cs to select community.css classes
import Material.List as Lists
import Material.Table as Table
import Material.Grid exposing (offset, grid, size, cell, Device (..) )
import Dict as D exposing (get)
import PatientPageTypes exposing (Patient, Entry, Drug, Appointment, emptyPatient, Doctype(..))
import Routing exposing (drugPath)
import Msgs exposing (Msg(..))


white : Options.Property c m
white =
  Color.text Color.white

-- whole view

patientViewOfPatient : Model -> Html Msg
patientViewOfPatient model =
  let patient = (Maybe.withDefault emptyPatient) (D.get 7 model.patients)
      appointmentView = List.map viewAppointment patient.appointments
      drugView = List.map viewDrug patient.medications
      letterView = List.map viewLetter patient.entries
  in div [] [ div [] ([div [class "patient-view-titles"] [text "Appointment"]] ++ appointmentView)
            , div [] [ div [class "patient-view-titles"] [text "Medications"]]
                     , grid []
                        [cell [offset All 2, size All 10]
                          [ Table.table [cs "semi-width"]
                            [ Table.thead []
                              [ Table.tr []
                                [ Table.th [] [ text "Drug" ]
                                , Table.th [] [ text "Morning" ]
                                , Table.th [] [ text "Lunchtime"]
                                , Table.th [] [ text "Dinner"]
                                , Table.th [] [ text "Bedtime"]
                                ]
                              ]
                            ]
                          , Table.tbody []
                              (patient.medications |>
                                  List.map (\drug ->
                                  Table.tr [onClick (ClickPatient patient)]
                                    [ Table.td [cs "centertext"] [ text drug.name ]
                                    ]))
                          ]
                        ]
              , div [] ([div [class "patient-view-titles"] [text "Letters"]] ++ letterView)
              ]




-- Appointments View


viewAppointment : Appointment -> Html Msg
viewAppointment appointment =
  grid [Options.css "height" "150px", Options.css "padding-bottom" "1px"] [ cell [offset All 2, size All 10]
          [Card.view [ Options.css "height" "inherit", Options.css "width" "inherit", Color.background (Color.color Color.Blue Color.S500)]
            [ Card.title [] [ Card.head [ white ] [span [class "appointment-span"] [text appointment.speciality], span [class "appointment-span"] [text appointment.date], span [class "appointment-span"] [text appointment.time]]]
            ]
          ]
        ]

-- Letter View

viewLetter : Entry -> Html Msg
viewLetter entry =
  case entry.docType of
    Letter ->
      grid [Options.css "height" "150px", Options.css "padding-bottom" "1px"] [ cell [offset All 2, size All 10]
           [Card.view [Card.expand, Options.css "height" "inherit", Options.css "width" "inherit", Color.background (Color.color Color.Blue Color.S500)]
           [Card.title [] [ Card.head [ white ] [ text entry.title ] ] , Card.text [] [ text entry.text ]]]]
    _ -> div [] []


-- Drugs View
viewDrug : Drug -> Html Msg
viewDrug drug =
  Table.tr []
        [ Table.th [] [ text drug.name]
        , Table.th [] []
        , Table.th [] []
        , Table.th [] []
        , Table.th [] []
        ]
