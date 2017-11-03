-- Unified Patient Records and Doctor View systems

-- Imports

import Html exposing (Html, text, h1, div)
import Html.Events exposing (onClick)



-- Model && Types

type alias Model =
  { patients : List Patient
  , jobs : List Job
  , beds : List Int
  , currentPatient : Int
  }

type alias Patient =
  { id: Int
  , name : String
  , dob: String
  , age: String
  }

type alias Job =
  { id: Int
  , patientID: Int
  , job: String
  , completed: Bool
  }

-- Main function

main = Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = \_ -> Sub.none
  }

-- initialisation

init : (Model, Cmd Msg)
init = (Model [Patient 0 "John" "12/03/92" "25"] [] [] 0, Cmd.none)


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
      ({model | currentPatient = patient.id }, Cmd.none)

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
  let patientsView = List.map viewPatient model.patients
  in div [] [div [] [ Html.h1 [] [text "HealthMatch"]], div [] patientsView]


viewPatient : Patient -> Html Msg
viewPatient patient =
  div [] [text patient.name, text patient.age, text patient.dob]
