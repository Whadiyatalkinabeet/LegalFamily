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

-- Model && Types

import PatientList exposing (..)
import PatientPageTypes exposing (Doctype, Importance, Patient, Entry, Drug)



type alias Model =
  {
      patient : Patient,
      mdl : Material.Model
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
init = (Model (Patient 0 "PAtientZero" "21" "20/10/1950" [] []) Material.model, Material.init Mdl)


-- update

type Msg
    = ChangePatient Patient
      | Mdl (Material.Msg Msg)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      ChangePatient patient ->
        ({ model | patient = patient }, Cmd.none)

      Mdl msg_ ->
      Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
  Layout.render Mdl
    model.mdl
      [ Layout.fixedHeader
      ]
      { header = [Html.h2 [ Html.Attributes.style [ ( "padding", "7px" ), ("text-align", "center"), ("margin", "12px") ] ] [ text "CommUnity"] ]
      , drawer = []
      , tabs = ([], [])
      , main = [ basic model ]
    }

basic : Model -> Html Msg
basic model =
    Lists.ul [ css "margin" "0", css "padding" "0" ]
        [ Lists.li [] [ Lists.content [] [ text model.patient.name ] ]
        , Lists.li [] [ Lists.content [] [ text model.patient.age ] ]
        , Lists.li [] [ Lists.content [] [ text model.patient.dob] ]
        ]
