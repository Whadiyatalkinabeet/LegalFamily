module PatientPageTypes exposing (Doctype, Importance, Patient, Entries, Drug)

type Doctype
    = GP
    | Inpatient
    | Letter

type Importance
    = High
    | Intermediate
    | Low

type alias Patient = {
  id : Int
  , name : String
  , age : String
  , dob : String
  , entries : List Entries
  , medications : List Drug
}

type alias Entries = {
  title: String
  , text: String
  , docType: Doctype
  , importance: Importance
}

type alias Drug = {
  name: String
  , dose: String
  , frequency: String
  , repeat: Bool
}
