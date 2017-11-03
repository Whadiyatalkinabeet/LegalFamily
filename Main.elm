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


-- Model && Types

patientList : Dict Int Patient
patientList = D.fromList [
  (0, Patient "John Smith" "12/04/1993" "24"),
  (1, Patient "Karl Nolland" "19/08/1970" "47"),
  (2, Patient "Pearl Kyza" "25/01/1964" "53")]

type alias Model =
  { patients : Dict Int Patient
  , jobs : List Job
  , beds : List Int
  , currentPatient : Int
  , error : String
  , mdl : Material.Model
}

type alias Mdl = Material.Model

type alias Patient =
  { name : String
  , dob: String
  , age: String
  }

type alias Job =
  { id: Int
  , patientID: Int
  , job: String
  , completed: Bool
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

init : (Model, Cmd Msg)
init = (Model patientList [] [] 0 "" Material.model, Material.init Mdl)


-- Msg and Update

type Msg
  = CreateJob Job
  | ClickPatient Patient
  | CompleteJob Int
  | Mdl (Material.Msg Msg)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    CreateJob job ->
      ({model | jobs = job :: model.jobs }, Cmd.none)

    ClickPatient patient ->
      ({model | currentPatient = 0 }, Cmd.none)

    CompleteJob jobID ->
      ({model | jobs =
          (List.map (updateJob jobID) model.jobs)}, Cmd.none)

    Mdl msg_ ->
      Material.update Mdl msg_ model


updateJob : Int -> Job -> Job
updateJob id job =
  if id == job.id then {job | completed = True}
  else job


-- View


view : Model -> Html Msg
view model =
  Layout.render Mdl
    model.mdl
      [ Layout.fixedHeader
      ]
      { header = [h1 [ Html.Attributes.style [ ( "padding", "2rem" ) ] ] [ text "CommUnity"] ]
      , drawer = []
      , tabs = ([], [])
      , main = [ viewBody model ]
    }

viewBody : Model -> Html Msg
viewBody model =
  let patientsView = List.map viewPatient (D.toList model.patients)
  in Lists.ul [] patientsView


viewPatient : (Int, Patient) -> Html Msg
viewPatient (id, patient) =
  Lists.li [] [Lists.content [] [text patient.name, text patient.age, text patient.dob]]



-- Firebase interaction

--getPatients : Cmd Msg
--getPatients =
--  Http.send FetchPatients (Http.get (firebaseDB ++"patients.json") patientDecoder)


patientDecoder : JD.Decoder (List Patient)
patientDecoder =
  JD.list (JD.map3 Patient
            (JD.at ["name"] JD.string)
            (JD.at ["dob"] JD.string)
            (JD.at ["age"] JD.string)
          )
