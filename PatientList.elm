module PatientList exposing (..)

import Dict as D exposing (..)
import Patient exposing (..)

patientList : Dict Int Patient
patientList = D.fromList [
  (0, Patient "John Smith" "12/04/1993" "24"),
  (1, Patient "Karl Nolland" "19/08/1970" "47"),
  (2, Patient "Pearl Kyza" "25/01/1964" "53")]

