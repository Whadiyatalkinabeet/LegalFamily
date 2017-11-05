module PatientPageTypes exposing (Doctype(..), Importance(..), Patient, Entry, Drug)

import Dict exposing (Dict)

type Doctype
    = GP
    | Inpatient
    | Letter
    | Results

type Importance
    = High
    | Intermediate
    | Low

type alias Patient = {
  id : Int
  , name : String
  , dob : String
  , age : String
  , entries : List Entry
  , medications : List Drug
}

type alias Entry = {
  id : Int
  , title: String
  , text: String
  , docType: Doctype
  , importance: Importance
  , acute: Bool
  , result: Dict String Float
}

type alias Drug = {
  id: Int
  , name: String
  , dose: String
  , frequency: String
  , repeat: Bool
}
