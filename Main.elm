-- Unified Patient Records and Doctor View systems

-- Imports

import Debug exposing (log)
import Html exposing (Html, text, h1, div, span, a)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, class)
import Json.Decode as JD
import Dict as D exposing (Dict, empty, update)
import Material.Layout as Layout exposing (href)
import Material
import Material.Scheme as Scheme
import Material.Button as Button
import Material.Options exposing (cs, css)  -- NB Avoiding inline css; use cs to select community.css classes
import Material.List as Lists
import Material.Table as Table
import Material.Grid exposing (grid, size, cell, Device (..) )
import PatientPageTypes exposing (Doctype, Importance, Patient, Entry, Drug)
import Routing exposing (Route(..), parseLocation, patientPath, patientsPath)
import Navigation exposing (Location)
import Models exposing (Model, User)
import PatientView exposing (patientView)
import WardView exposing (wardView)
import DrugView exposing (drugView)
import Msgs exposing (Msg(..))

-- Model && Types

import PatientList exposing (..)
import Job exposing (..)
import JobList exposing (..)



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

emptyEntry : Entry
emptyEntry =
  Entry -1 "" "" PatientPageTypes.Inpatient PatientPageTypes.High True

-- initialisation

init : Location -> (Model, Cmd Msg)
init location =
  let currentRoute = parseLocation location
  in (Model patientList testUser JobList.jobList bedList Nothing "" Material.model currentRoute emptyEntry, Material.init Mdl)


-- Msg and Update


rotate : Maybe Table.Order -> Maybe Table.Order
rotate order =
  case order of
    Just Table.Ascending -> Just Table.Descending
    Just Table.Descending -> Nothing
    Nothing -> Just Table.Ascending

bedList : List Int
bedList = List.range 1 24

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

    Text text ->
      ({model | newEntry = text |> asTextInEntry model.newEntry }, Cmd.none)

    Title title ->
      ({model | newEntry = title |> asTitleInEntry model.newEntry}, Cmd.none)

    SubmitEntry id ->
        let entries = Maybe.map (\patient -> patient.entries) (D.get id model.patients)
            entryID = (List.length ((Maybe.withDefault []) entries )) + 1
            newEntry = updateEntryList model.newEntry (Maybe.withDefault [] entries)
        in { model | patients = model.patients |> D.update id (updatePatientEntry newEntry)} ! []

    Mdl msg_ ->
      Material.update Mdl msg_ model

    OnLocationChange location ->
      let newRoute = parseLocation location
      in ({ model | route = newRoute}, Cmd.none)

updatePatientEntry : List Entry -> Maybe Patient -> Maybe Patient
updatePatientEntry entries patient =
  case patient of
    Just patient -> Just { patient | entries = entries }
    Nothing -> Nothing

updateEntryText : String -> Entry -> Entry
updateEntryText str entry =
  { entry | text = str }

updateEntryTitle : String -> Entry -> Entry
updateEntryTitle title entry =
  { entry | title = title }

asTextInEntry : Entry -> String -> Entry
asTextInEntry = flip updateEntryText

asTitleInEntry : Entry -> String -> Entry
asTitleInEntry = flip updateEntryTitle

updateEntryList : Entry -> List Entry -> List Entry
updateEntryList entry entryList =
  entry :: entryList

updateJob : Int -> (Int, Job) -> (Int, Job)
updateJob id (jobID, job) =
  if id == jobID then (jobID, {job | completed = True})
  else (jobID, job)

-- View

view : Model -> Html Msg
view model =
  case model.route of
    WardRoute ->
      Layout.render Mdl
        model.mdl
          [ Layout.fixedHeader
          ]
          { header = [header model]
          , drawer = [myDrawer model]
          , tabs = ([], [])
          , main = [ page model ]
        }
    PatientRoute _ ->
      Layout.render Mdl
        model.mdl
          [ Layout.fixedHeader
          ]
          { header = [header model]
          , drawer = [myDrawer model]
          , tabs = (tabTitles, [])
          , main = [ page model ]
        }
    NotFoundRoute ->
      Layout.render Mdl
        model.mdl
          [ Layout.fixedHeader
          ]
          { header = [header model]
          , drawer = [myDrawer model]
          , tabs = ([], [])
          , main = [ page model ]
        }

getPatientName: Patient->String
getPatientName patient = patient.name

tabTitles : List (Html Msg)
tabTitles =
  [text "Warnings", text "Records", text "Medications", text "Results"]


myDrawer : Model -> Html Msg
myDrawer model =
  span [] [ Layout.title [] [text ("Dev Mode")]
          , Layout.navigation [] [
              Layout.link [href ""] [text "Ward View"]
            , Layout.link [href (patientPath 7)] [text "Patient View"]
          ]]

-- Header layout:
--   Grid is 12 / 8 / 4 on Desktop/Tablet/Phone.
--   So use 4,4,4 / 2,4,2 / 1,2,1

header : Model -> Html Msg
header model =
  let title=case model.currentPatient of
     Just x -> log "patientname" ( getPatientName ((Maybe.withDefault emptyPatient) (D.get x model.patients)))
     Maybe.Nothing -> "CommUnity"
  in
    grid [cs "fullwidth"] [
      cell [size Desktop 4, size Tablet 2,size Phone 1] [],
      cell [cs "title", size Desktop 4, size Tablet 4,size Phone 2] [ text title],
      cell [cs "righttext", size Desktop 4, size Tablet 2,size Phone 1] [ text (model.user.name++" "++model.user.speciality++" "++model.user.grade) ]
    ]

page : Model -> Html Msg
page model =
  case model.route of
    WardRoute ->
      wardView model
    PatientRoute id ->
      patientView model id
    DrugRoute id ->
      drugView model id
    NotFoundRoute ->
      notFoundView





emptyPatient : Patient
emptyPatient = Patient 4000 "" "" "" [] []



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
