-- Unified Patient Records and Doctor View systems

-- Imports

import Html exposing (Html, text, h1, div)
import Html.Events exposing (onClick)
import Html.Attributes
import Json.Decode as JD
import Dict as D exposing (..)
import Material.Layout as Layout
import Material
import Material.Scheme as Scheme
import Material.Button as Button
import Material.Options exposing (css)
import Material.List as Lists
import Material.Table as Table
import Material.Grid exposing (..)
import PatientPageTypes exposing (Doctype, Importance, Patient, Entries, Drug)
import Routing exposing (Route, parseLocation)
import Navigation exposing (Locations)

-- Model && Types

import PatientList exposing (..)
import Job exposing (..)
import JobList exposing (..)

bedList : List Int
bedList = List.range 1 24

type alias Model =
  { patients : Dict Int Patient
  , jobs : Dict Int Job
  , beds : List Int
  , currentPatient : Int
  , error : String
  , mdl : Material.Model
  , order : Maybe Table.Order
  , route : Route
}
-- Firebase Location

firebaseDB : String
firebaseDB = "https://legalfamily-95414.firebaseio.com/"

-- Main function

main = Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = Material.subscriptions Mdl
  }

-- initialisation

init : Route -> (Model, Cmd Msg)
init route = (Model patientList JobList.jobList bedList 0 "" Material.model Nothing route, Material.init Mdl)


-- Msg and Update

type Msg
  = CreateJob Job
  | ClickPatient Patient
  | CompleteJob Int
  | Reorder
  | Mdl (Material.Msg Msg)
  | OnLocationChange Location


rotate : Maybe Table.Order -> Maybe Table.Order
rotate order =
  case order of
    Just Table.Ascending -> Just Table.Descending
    Just Table.Descending -> Nothing
    Nothing -> Just Table.Ascending


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    CreateJob job ->
      let jobList = D.toList model.jobs
          lengthList = List.length jobList
          newJobDict = D.fromList (((lengthList + 1), job) :: jobList)
      in ({model | jobs = newJobDict }, Cmd.none)

    ClickPatient patient ->
      ({model | currentPatient = patient.id }, Cmd.none)

    CompleteJob jobID ->
      ({model | jobs =
          D.fromList (List.map (updateJob jobID) (D.toList model.jobs))}, Cmd.none)

    Reorder ->
      { model | order = rotate model.order } ! []

    Mdl msg_ ->
      Material.update Mdl msg_ model

    OnLocationChange location ->
      let newRoute = parseLocation location
      in ({ model | route = newRoute}, Cmd.none)


updateJob : Int -> (Int, Job) -> (Int, Job)
updateJob id (jobID, job) =
  if id == jobID then (jobID, {job | completed = True})
  else (jobID, job)


-- View


view : Model -> Html Msg
view model =
  Layout.render Mdl
    model.mdl
      [ Layout.fixedHeader
      ]
      { header = [Html.h2 [ Html.Attributes.style [ ( "padding", "7px" ), ("text-align", "center"), ("margin", "12px") ] ] [ text "CommUnity"] ]
      , drawer = []
      , tabs = ([], [])
      , main = [ page model ]
    }

page : Model -> Html Msg
page model =
  case model.route of
    WardRoute ->
      wardView model
    PatientRoute id ->
      patientView model id
    NotFoundRoute ->
      notFoundView

subHeader : Html Msg
subHeader =
 grid [css "text-align" "center"] [
      cell [Material.Grid.size All 9]
        [ Html.h4 [] [text "Ward 6B"] ]
    , cell [Material.Grid.size All 3]
        [ Html.h4 [] [text "Jobs"] ]
    ]

patientView : Model -> Int -> Html Msg
patientView model id =
  let patient = D.get id model.patients
  in div [] [ text patient.name ]

wardView : Model -> Html Msg
wardView model =
  div [] [ subHeader,
              grid [] [ cell [Material.Grid.size All 9 ]
                        [ Table.table [css "width" "100%"]
                          [ Table.thead []
                              [ Table.tr []
                                [  Table.th
                                    [css "text-align" "center"]
                                    [ text "Bed Number"]
                                ,  Table.th
                                    [css "text-align" "center"]
                                    [ text "Name"]
                                , Table.th
                                    [Table.numeric, css "text-align" "center"]
                                    [ text "Age" ]
                                , Table.th
                                    [css "text-align" "center"]
                                    [ text "DOB" ]
                                ]
                              ]
                            , Table.tbody []
                              ((zip bedList (List.map Tuple.second (D.toList model.patients)))
                                  |> List.map (\(bedNumber, patient) ->
                                    Table.tr []
                                      [ Table.td [css "text-align" "center" ] [ text (toString bedNumber) ]
                                      , Table.td [css "text-align" "center"] [ text patient.name ]
                                      , Table.td [css "text-align" "center"] [ text patient.age ]
                                      , Table.td [css "text-align" "center"] [ text patient.dob ]]))

                            ]
                          ]
                        , cell [Material.Grid.size All 3]
                          [ Table.table [css "width" "100%"]
                            [ Table.thead []
                              [ Table.tr []
                                [ Table.th
                                  [ css "text-align" "center" ]
                                  [ text "Bed Number" ]
                                , Table.th
                                  [ css "text-align" "center" ]
                                  [ text "Job"]
                                ]
                              ]
                            , Table.tbody []
                              ((D.toList model.jobs) |>
                                List.map (\(_, job) ->
                                  Table.tr []
                                    [ Table.td [css "text-align" "center"] [text (toString job.patientID)]
                                    , Table.td [css "text-align" "center"] [text job.job]]))
                            ]
                          ]
                        ]
          ]



spanStyle : List (String, String)
spanStyle =
  [("padding", "15px"),
   ("margin-left", "15px")]

-- Firebase interaction

--getPatients : Cmd Msg
--getPatients =
--  Http.send FetchPatients (Http.get (firebaseDB ++"patients.json") patientDecoder)

zip : List a -> List b -> List (a, b)
zip xs ys =
  case (xs, ys) of
    ( x :: xBack, y :: yBack ) ->
      (x,y) :: zip xBack yBack
    (_, _) ->
      []


patientDecoder : JD.Decoder (List Patient)
patientDecoder =
  JD.list (JD.map3 Patient
            (JD.at ["name"] JD.string)
            (JD.at ["dob"] JD.string)
            (JD.at ["age"] JD.string)
          )
