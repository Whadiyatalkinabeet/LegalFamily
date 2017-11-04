-- Unified Patient Records and Doctor View systems

-- Imports

import Html exposing (Html, text, h1, div, span, a)
import Html.Events exposing (onClick)
import Html.Attributes exposing (href, style, class)
import Json.Decode as JD
import Dict as D exposing (Dict, empty)
import Material.Layout as Layout
import Material
import Material.Scheme as Scheme
import Material.Button as Button
import Material.Options exposing (cs)  -- NB Avoiding inline css; use cs to select community.css classes 
import Material.List as Lists
import Material.Table as Table
import Material.Grid exposing (grid, size, cell, Device (..) )
import PatientPageTypes exposing (Doctype, Importance, Patient, Entry, Drug)
import Routing exposing (Route(..), parseLocation, patientPath, patientsPath)
import Navigation exposing (Location)

-- Model && Types

import PatientList exposing (..)
import Job exposing (..)
import JobList exposing (..)

bedList : List Int
bedList = List.range 1 24

type alias Model =
  { patients : Dict Int Patient
  , user : User
  , jobs : Dict Int Job
  , beds : List Int
  , currentPatient : Maybe Int
  , error : String
  , mdl : Material.Model
  , order : Maybe Table.Order
  , route : Route
}

type alias User =
  { id: Int
  , name: String
  , speciality: String
  , grade: String
  }

testUser : User
testUser = User 1 "Sean Harbison" "General Surgery" "FY2"

-- Main function

main : Program Never Model Msg
main =
  Navigation.program OnLocationChange
    { init = init
    , view = view
    , update = update
    , subscriptions = Material.subscriptions Mdl
    }

-- initialisation

init : Location -> (Model, Cmd Msg)
init location =
  let currentRoute = parseLocation location
  in (Model patientList testUser JobList.jobList bedList Nothing "" Material.model Nothing currentRoute, Material.init Mdl)


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
      ({model | currentPatient = Just patient.id }, Cmd.none)

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
      { header = [header model]
      , drawer = []
      , tabs = ([], [])
      , main = [ page model ]
    }

getPatientName: Patient->String
getPatientName patient = patient.name

header : Model -> Html Msg
header model =
  let title=case model.currentPatient of
     Just x -> getPatientName ((Maybe.withDefault emptyPatient) (D.get x model.patients))
     Maybe.Nothing -> "CommUnity"
  in
    grid [cs "fullwidth"] [
      cell [cs "title", size All 4] [ text title],
      cell [size All 4] [],
      cell [cs "righttext", size All 4] [ text (model.user.name++" "++model.user.speciality++" "++model.user.grade) ]
    ]

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
 grid [cs "centertext"] [
      cell [Material.Grid.size All 9]
        [ Html.h4 [] [text "Ward 6B"] ]
    , cell [Material.Grid.size All 3]
        [ Html.h4 [] [text "Jobs"] ]
    ]

emptyPatient : Patient
emptyPatient = Patient 4000 "" "" "" [] []

patientView : Model -> Int -> Html Msg
patientView model id =
  let patient = (Maybe.withDefault emptyPatient) (D.get id model.patients)
  in div [] [ text patient.name ]

wardView : Model -> Html Msg
wardView model =
  div [] [ subHeader,
              grid [] [ cell [Material.Grid.size All 9 ]
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
                                    [Table.numeric, cs "centertext"]
                                    [ text "Age" ]
                                , Table.th
                                    [cs "centertext"]
                                    [ text "DOB" ]
                                ]
                              ]
                            , Table.tbody []
                              ((zip bedList (List.map Tuple.second (D.toList model.patients)))
                                  |> List.map (\(bedNumber, patient) ->
                                    let path = patientPath patient.id
                                    in Table.tr []
                                        [ a [href path, style [("text-decoration", "none")]] [ Table.td [cs "centertext" ] [ text (toString bedNumber) ]
                                        , Table.td [cs "centertext"] [ text patient.name ]
                                        , Table.td [cs "centertext"] [ text patient.age ]
                                        , Table.td [cs "centertext"] [ text patient.dob ]]
                                        ]))

                            ]
                          ]
                        , cell [Material.Grid.size All 3]
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

notFoundView : Html Msg
notFoundView = div [] [text "404"]


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
