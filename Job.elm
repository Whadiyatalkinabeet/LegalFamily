module Job exposing (..)

type alias Job =
  {
  id : Int
  ,  patientID: Int
  , job: String
  , completed: Bool
  }
