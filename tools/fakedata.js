var numPatients=30;
var numJobs=25;

var PD = require("probability-distributions");

function captext(s) {
    return s.charAt(0).toUpperCase() + s.slice(1);
}

function randomtext(isName) {
    // Use Scrabble letter frequency
    var letters='eeeeeeeeeeeeaaaaaaaaaiiiiiiiiioooooooonnnnnnrrrrrrttttttllllssssuuuuddddgggbbccmmppffhhvvwwyykjxqz'
    var n=(isName ? Math.max(3,Math.round(PD.rnorm(1,5,2)[0])) : Math.max(1,Math.round(PD.rnorm(1,4,1)[0])))
    text=''
    for (var i=0;i<n;i++) {
        text+=letters[Math.floor(Math.random()*letters.length)]
    }
    return text;
}

function randomsentence() {
    var s=captext(randomtext(false))+' '+randomtext(false)+' '+randomtext(false)
    while (Math.random()<0.75) {
        s+=(' '+randomtext(false))
    }
    s+='.'
    return s
}

function randomparagraph() {
    var s=randomsentence()
    while (Math.random()<0.75) {
        s+=('  '+randomsentence())
    }
    return s
}

function mkname() {
    return captext(randomtext(true))+' '+captext(randomtext(true));
}

function randompick(s) {
    return s[Math.floor(Math.random()*s.length)]
}

function mkdrug(n) {
    var name=randomtext(true)
    var dose=Math.round(100*Math.random()).toString()
    var units=randompick(['mg','g','ml'])
    var frequency=randompick(['daily','twice-daily','with meals','per hour','hourly'])
    return {
        'id':n,
        'name':name,
        'dose':dose+units,
        'frequency':frequency,
        'repeat':(Math.random()<0.5)
    }
}

var titles = ["Hypertension", "Coeliac's Disesase", "Multiple Sclerosis",
  "Diabetes", "Huntington's", "Depression", "Angina", "Atrial Fibrillation",
  "Chronic Kidney Disease", "Interstitial Lung Disease", "Asthma", "COPD",
  "IHD", "Hyperthyroidism", "Broken bone", "Lung Cancer", "Dermatitis",
  "Psoriasis", "Abscess", "Gastroentiritis", "Phaeochromocytoma", "Pneumothorax",
  "GORD", "Aortic Stenosis", "Ventricular Tachycardia", "Optic Neuritis", "Migraine"]

function mkentry(n,isResult) {
    var title=randompick(titles)
    var text=randomparagraph()
    var doctype=(isResult ? 'Results' : randompick(['GP','Inpatient','Letter','Results']))
    var importance=randompick(['High','Intermediate','Low'])
    var acute=(Math.random()<0.75)

    var results={}
    if (doctype=='Results') {
        title='Results: U&Es'
        results['Na+']=Math.round(PD.rnorm(1,140,2)[0]);
        results['K+']=Math.round(PD.rnorm(1,4.0,0.25)[0]);
        results['Cl-']=Math.round(PD.rnorm(1,100.0,2.5)[0]);
        results['Urea']=Math.round(PD.rnorm(1,5.0,0.25)[0]);
        results['Creat']=Math.round(10.0*PD.rnorm(1,75.0,7.5)[0])/10.0;
    }

    if (isResult) {
        text='Test results: ';
        for (var key in results) {
            text+=key+': '+(results[key].toString())+' '
        }
    }

    return {
        'id': n,
        'title': title,
        'text': text,
        'docType': doctype,
        'importance': importance,
        'acute': acute,
        'results':results
    }
}

function mkpatient(n) {

    var year=Math.floor(1918+100*Math.random())
    var month=Math.floor(1+12*Math.random())
    var day=Math.floor(1+31*Math.random())
    var age=2017-year
    var entries=[]
    var nentries=(n==7 ? 7 : Math.floor(age*Math.random()))
    for (var i=0;i<nentries;i++) entries.push(mkentry(i,false))
    var meds=[]
    var nmeds=(n==7 ? 3 : Math.floor(4*Math.random()))
    for (var i=0;i<nmeds;i++) meds.push(mkdrug(i))
    var appointments=[]
    var nappointments=(n==7 ? 1 : Math.floor(2*Math.random()))

    if (n==7) {

        entries[0]['title']='Cardiology';
        entries[0]['text']='Dear Mr Carter, You were recently referred on to our services. We have made you an appointment on 21/11/17 at 11:00. We look forward to seeing you then. Kind Regards, Dr Bloom';
        entries[0]['docType']='Letter';
        entries[0]['importance']='High';
        entries[0]['acute']=true;

        entries[1]['title']='Angina';
        entries[1]['text']='Chest pain on exertion.  Settles with rest.  Lasts 5-10 minutes.  Take bloods.  Start Aspirin and Atenolol.';
        entries[1]['docType']='GP';
        entries[1]['importance']='High';
        entries[1]['acute']=true;

        entries[2]['title']='Hypertension';
        entries[2]['text']='Monitoring BP = 130/80, continue Amlodipine.  Blood results OK.';
        entries[2]['docType']='GP';
        entries[2]['importance']='Low';
        entries[2]['acute']=false;

        entries[3]=mkentry(2,true)

        entries[4]['title']='Hypertension';
        entries[4]['text']='Monitoring BP = 150/90, increase Amlodipine.  10mg OD, take bloods';
        entries[4]['docType']='GP';
        entries[4]['importance']='Low';
        entries[4]['acute']=true;

        entries[5]['title']='Hypertension';
        entries[5]['text']='Monitoring BP = 170/100, start Amlodipine.  5mg OD';
        entries[5]['docType']='GP';
        entries[5]['importance']='Low';
        entries[5]['acute']=true;

        entries[6]['title']='Welcome';
        entries[6]['text']='Dear James, Thank you for registering at our practice. We recommend that you make an appointment to come see us. Kind Regards, Dr Miller';
        entries[6]['docType']='Letter';
        entries[6]['importance']='Low';
        entries[6]['acute']=true;

        meds[0]['name']='Atenolol';
        meds[0]['dose']='100mg';
        meds[0]['frequency']='OD';
        meds[0]['repeat']=true;

        meds[1]['name']='Aspirin';
        meds[1]['dose']='75mg';
        meds[1]['frequency']='OD';
        meds[1]['repeat']=true;

        meds[2]['name']='Amlodipine';
        meds[2]['dose']='10mg';
        meds[2]['frequency']='OD';
        meds[2]['repeat']=true;

        appointments.push(
          {
            'id': 0
          , 'time': "11:00"
          , 'date': "21/11/17"
          , 'speciality': "Cardiology"
          }
        )

        return {
            'id': n,
            'name': "James Carter",
            'dob': "1960-07-01",
            'age': "57",
            'entries': entries,
            'medications': meds,
            'appointments': appointments
        }
    }

    return {
        'id': n,
        'name': mkname(),
        'dob': year+'-'+month+'-'+day,
        'age': age,
        'entries': entries,
        'medications': meds,
        'appointments': []
    };
}

var jobdesc=['Blood test','Cannula','Ultrasound','CT scan','MRI scan','Biopsy','Referral']
function mkjob(n) {
    return {
        'id':n,
        'patientID':Math.floor(numPatients*Math.random()),
        'job':jobdesc[Math.floor(Math.random()*jobdesc.length)],
        'completed':(Math.random()<0.25),
    }
}

var patients=[]
for (var i=0;i<numPatients;++i) patients.push(mkpatient(i));

var jobs=[]
for (var i=0;i<numJobs;++i) jobs.push(mkjob(i));

function oops(err) {if (err) throw err;}

const fs=require('fs')
fs.writeFileSync('../PatientList.elm','',oops)
fs.writeFileSync('../JobList.elm','',oops)

function appendPatientListFile(txt) {
    fs.appendFileSync('../PatientList.elm',txt+'\n',oops)
}

function appendJobListFile(txt) {
    fs.appendFileSync('../JobList.elm',txt+'\n',oops)
}

appendPatientListFile('-- AUTOGENERATED FILE PatientList.elm - DO NOT EDIT')
appendPatientListFile('-- Update by running nodejs fakedata.js *in* tools/')
appendPatientListFile('')
appendPatientListFile('module PatientList exposing (..)')
appendPatientListFile('')
appendPatientListFile('import Dict as D exposing (..)')
appendPatientListFile('import PatientPageTypes exposing (Patient,Entry,Drug,Doctype(..),Importance(..),Appointment)')
appendPatientListFile('')
appendPatientListFile('patientList : Dict Int Patient')
appendPatientListFile('patientList = D.fromList [')

function resultsToString(results) {
    var s=' ( D.fromList ['
    var first=true;
    for (var key in results) {
        if (!first) {s+=' , ';}
        s+=' ( '
        s+='"'+key+'"'
        s+=', '
        s+=results[key]
        s+=' ) '
        first=false;
    }
    s+='] )'
    return s
}

function entriesToString(entries) {
    var s='['
    for (var i=0;i<entries.length;i++) {
        if (i!=0) s+=' , '
        s+=('Entry '+entries[i]['id']+' "'+entries[i]['title']+'" '+' "'+entries[i]['text']+'" '+entries[i]['docType']+' '+entries[i]['importance']+' '+(entries[i]['acute'] ? 'True' : 'False') + ' '+resultsToString(entries[i].results))
    }
    s+=']'
    return s
}

function medicationsToString(meds) {
    var s='['
    for (var i=0;i<meds.length;i++) {
        if (i!=0) s+=' , '
        s+=('Drug '+meds[i]['id']+' "'+meds[i]['name']+'" '+' "'+meds[i]['dose']+'" "'+meds[i]['frequency']+'" '+(meds[i]['repeat'] ? 'True' : 'False'))
    }
    s+=']'
    return s
}

function appointmentToString(appointments) {
  var s='['
  for (var i=0;i<appointments.length;i++) {
      if (i!=0) s+=' , '
      s+=('Appointment '+appointments[i]['id']+' "'+appointments[i]['date']+'" '+' "'+appointments[i]['time']+'" "'+appointments[i]['speciality']+'"')
  }
  s+=']'
  return s
}

for (var i=0;i<patients.length;i++) {
    if (i!=0) appendPatientListFile('  ,')
    appendPatientListFile('  ('+i+' , Patient '+patients[i]['id']+' "'+patients[i]['name']+'" "'+patients[i]['dob']+'" "'+patients[i]['age']+'" '+entriesToString(patients[i]['entries'])+' '+medicationsToString(patients[i]['medications'])+' '+appointmentToString(patients[i]['appointments'])+' )')
}
appendPatientListFile('  ]')

console.log('Wrote ../PatientList.elm')

appendJobListFile('-- AUTOGENERATED FILE JobList.elm - DO NOT EDIT')
appendJobListFile('-- Update by running nodejs fakedata.js *in* tools')
appendJobListFile('')
appendJobListFile('module JobList exposing (..)')
appendJobListFile('')
appendJobListFile('import Dict as D exposing (..)')
appendJobListFile('import Job exposing (..)')
appendJobListFile('')
appendJobListFile('jobList : Dict Int Job')
appendJobListFile('jobList = D.fromList [')

for (var i=0;i<jobs.length;i++) {
    if (i!=0) appendJobListFile('  ,')
    appendJobListFile('  ('+i+' , Job '+jobs[i]['id']+' '+jobs[i]['patientID']+' "'+jobs[i]['job']+'" '+(jobs[i]['completed'] ? 'True' : 'False')+' )')
}
appendJobListFile('  ]')

console.log('Wrote ../JobList.elm')
