module PatientPageTypes exposing (Doctype, Importance, Patient, Entries, Drug)

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
  , entries : List Entries
  , medications : List Drug
}

type alias Entries = {
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
