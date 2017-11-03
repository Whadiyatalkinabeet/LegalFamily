var numPatients=30;
var numJobs=25;

function captext(s) {
    return s.charAt(0).toUpperCase() + s.slice(1);
}

function randomtext() {
    var letters='abcdefghijklmnopqrstuvwxyz'
    var n=3+5*Math.random()
    text=''
    for (var i=0;i<n;i++) {
        text+=letters[Math.floor(Math.random()*letters.length)]
    }
    return text;
}

function mkname() {
    return captext(randomtext())+' '+captext(randomtext());
}

function mkpatient() {
    
    var year=Math.floor(1918+100*Math.random())
    var month=Math.floor(1+12*Math.random())
    var day=Math.floor(1+31*Math.random())
    
    patient={
        'name': mkname(),
        'dob': year+'-'+month+'-'+day,
        'age': 2017-year
    };
    return patient;
}

var jobdesc=['Blood test','Ultrasound','CT scan','MRI scan','Biopsy']
function mkjob() {
    job={
        'patientID':Math.floor(numPatients*Math.random()),
        'job':jobdesc[Math.floor(Math.random()*jobdesc.length)],
        'completed':(Math.random()<0.25)
    }
    return job
}

var patients=[]
for (var i=0;i<numPatients;++i) patients.push(mkpatient());

var jobs=[]
for (var i=0;i<numJobs;++i) jobs.push(mkjob());

function oops(err) {if (err) throw err;}

const fs=require('fs')
fs.writeFileSync('../PatientList.elm','',oops)
//fs.writeFileSync('JobList.elm','',oops)

function appendPatientListFile(txt) {
    fs.appendFileSync('../PatientList.elm',txt+'\n',oops)
}

appendPatientListFile('-- AUTOGENERATED FILE PatientList.elm - DO NOT EDIT')
appendPatientListFile('-- Update by replacing with output of tools/fakedata.js')
appendPatientListFile('')
appendPatientListFile('module PatientList exposing (..)')
appendPatientListFile('')
appendPatientListFile('import Dict as D exposing (..)')
appendPatientListFile('import Patient exposing (..)')
appendPatientListFile('')
appendPatientListFile('patientList : Dict Int Patient')
appendPatientListFile('patientList = D.fromList [')

for (var i=0;i<patients.length;i++) {
    if (i!=0) appendPatientListFile('  ,')
    appendPatientListFile('  ('+i+' , Patient '+'"'+patients[i]['name']+'" "'+patients[i]['dob']+'" "'+patients[i]['age']+'" )')
}
appendPatientListFile('  ]')
