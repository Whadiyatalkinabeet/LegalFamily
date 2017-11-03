-- Unified Patient Records and Doctor View systems

-- Imports

import Html exposing (Html, text, h1, div)
import Html.Events exposing (onClick)
import Http exposing (..)
import Json.Decode as JD
import Dict as D exposing (..)

-- Model && Types

import Patient exposing (..)
import PatientList exposing (..)

type alias Model =
  { patients : Dict Int Patient
  , jobs : List Job
  , beds : List Int
  , currentPatient : Int
  , error : String
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
  , subscriptions = \_ -> Sub.none
  }

-- initialisation

init : (Model, Cmd Msg)
init = (Model patientList [] [] 0 "", Cmd.none)


-- Msg and Update

type Msg
  = CreateJob Job
  | ClickPatient Patient
  | CompleteJob Int


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


updateJob : Int -> Job -> Job
updateJob id job =
  if id == job.id then {job | completed = True}
  else job


-- View


view : Model -> Html Msg
view model =
  let patientsView = List.map viewPatient (D.toList model.patients)
  in div [] [div [] [ Html.h1 [] [text "CommUnity"]], div [] patientsView]


viewPatient : (Int, Patient) -> Html Msg
viewPatient (id, patient) =
  div [] [text patient.name, text patient.age, text patient.dob]



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
