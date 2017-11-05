module PatientViewOfPatient exposing (patientViewOfPatient)

import Models exposing (Model)
import Html exposing (Html, text, h1, div, span, a, input)
import Html.Attributes exposing (style, type_, placeholder)
import Html.Events exposing (onInput)
import Routing exposing (patientPath)
import Material
import Material.Scheme as Scheme
import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Chip as Chip
import Material.Options as Options
import Material.Options exposing (css, cs, onClick, attribute)  -- NB Avoiding inline css; use cs to select community.css classes
import Material.List as Lists
import Material.Table as Table
import Material.Grid exposing (offset, grid, size, cell, Device (..) )
import Dict as D exposing (get)
import PatientPageTypes exposing (Patient, Entry, Drug)
import Routing exposing (drugPath)
import Msgs exposing (Msg(..))


-- whole view

patientViewOfPatient : Model -> Html Msg
patientViewOfPatient model = div[]


















-- Appointments View




















-- Letter View



















-- Drugs View
