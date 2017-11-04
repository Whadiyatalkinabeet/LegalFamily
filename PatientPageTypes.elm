module PatientPageTypes exposing (Doctype(..), Importance(..), Patient, Entry, Drug)

type Doctype
    = GP
    | Inpatient
    | Letter
    | Vitals
    | Results

type Importance
    = High
    | Intermediate
    | Low

type alias Patient = {
  id : Int
  , name : String
  , age : String
  , dob : String
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
}

type alias Drug = {
  id: Int
  , name: String
  , dose: String
  , frequency: String
  , repeat: Bool
}
