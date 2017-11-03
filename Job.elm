module Job exposing (..)

type alias Job =
  { 
    patientID: Int
  , job: String
  , completed: Bool
  }
