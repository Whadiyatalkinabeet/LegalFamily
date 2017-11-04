module WardView exposing (wardView)

import Models exposing (Model)
import Html exposing (Html, text, h1, div, span, a)
import Html.Attributes exposing (href, style, class)
import Material
import Material.Scheme as Scheme
import Material.Button as Button
import Material.Options exposing (css, cs, onClick, attribute)  -- NB Avoiding inline css; use cs to select community.css classes
import Material.List as Lists
import Material.Table as Table
import Material.Grid exposing (grid, size, cell, Device (..) )
import Dict as D exposing (toList)
import Msgs exposing (Msg(..))
import Routing exposing (patientPath)

wardView : Model -> Html Msg
wardView model =
  div [] [ subHeader,
              grid [] [ cell [size All 9 ]
                        [ Table.table [cs "fullwidth"]
                          [ Table.thead []
                              [ Table.tr []
                                [  Table.th
                                    [cs "centertext"]
                                    [ text "Bed Number"]
                                ,  Table.th
                                    [cs "centertext"]
                                    [ text "Name"]
                                , Table.th
                                    [cs "centertext"]
                                    [ text "Age" ]
                                , Table.th
                                    [cs "centertext"]
                                    [ text "DOB" ]
                                , Table.th
                                    []
                                    []
                                ]
                              ]
                            , Table.tbody []
                              ((zip model.beds (List.map Tuple.second (D.toList model.patients)))
                                  |> List.map (\(bedNumber, patient) ->
                                    let path = patientPath patient.id
                                    in Table.tr [onClick (ClickPatient patient)]
                                        [ Table.td [cs "centertext" ] [ text (toString bedNumber) ]
                                        , Table.td [cs "centertext"] [ text patient.name ]
                                        , Table.td [cs "centertext"] [ text patient.age ]
                                        , Table.td [cs "centertext"] [ text patient.dob ]
                                        , Table.td [] [
                                          Button.render Mdl [0] model.mdl
                                            [ Button.raised
                                            , Button.ripple
                                            , Button.link path
                                            ]
                                            [ text "View Patient"]
                                            ]
                                        ]))

                            ]
                          ]
                        , cell [size All 3]
                          [ Table.table [cs "fullwidth"]
                            [ Table.thead []
                              [ Table.tr []
                                [ Table.th
                                  [ cs "centertext" ]
                                  [ text "Bed Number" ]
                                , Table.th
                                  [ cs "centertext" ]
                                  [ text "Job"]
                                ]
                              ]
                            , Table.tbody []
                              ((D.toList model.jobs) |>
                                List.map (\(_, job) ->
                                  Table.tr []
                                    [ Table.td [cs "centertext"] [text (toString job.patientID)]
                                    , Table.td [cs "centertext"] [text job.job]]))
                            ]
                          ]
                        ]
          ]

subHeader : Html Msg
subHeader =
 grid [cs "centertext", css "background-color" "aliceblue"] [
      cell [size All 9]
        [ Html.h4 [] [text "Ward 6B"] ]
    , cell [size All 3]
        [ Html.h4 [] [text "Jobs"] ]
    ]

zip : List a -> List b -> List (a, b)
zip xs ys =
  case (xs, ys) of
    ( x :: xBack, y :: yBack ) ->
      (x,y) :: zip xBack yBack
    (_, _) ->
      []
