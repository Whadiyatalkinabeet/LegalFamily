module Msgs exposing (Msg(..))

import PatientPageTypes exposing (Patient, Entry)
import Navigation exposing (Location)
import Material
import Job exposing (Job)

type Msg
  = CreateJob Job
  | ClickPatient Patient
  | CompleteJob Int
  | Mdl (Material.Msg Msg)
  | OnLocationChange Location
  | Text String
  | Title String
  | SubmitEntry Int
  | SelectTab Int
