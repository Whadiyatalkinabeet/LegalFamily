module Models exposing (Model, User)
import Routing exposing (Route(..))
import Material
import Dict exposing (Dict)
import Job exposing (Job)
import PatientPageTypes exposing (Patient, Entry)

type alias Model =
  { patients : Dict Int Patient
  , user : User
  , jobs : Dict Int Job
  , beds : List Int
  , currentPatient : Maybe Int
  , error : String
  , mdl : Material.Model
  , route : Route
  , newEntry : Entry
}

type alias User =
  { id: Int
  , name: String
  , speciality: String
  , grade: String
  }
