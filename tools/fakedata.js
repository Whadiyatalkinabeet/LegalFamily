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
        results['Na+']=140.0;
        results['K+']=4.0;
        results['Cl-']=100.0;
        results['Urea']=5.0;
        results['Creat']=70.0;
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
    var nentries=(n==7 ? 5 : Math.floor(age*Math.random()))
    for (var i=0;i<nentries;i++) entries.push(mkentry(i,false))
    var meds=[]
    var nmeds=(n==7 ? 3 : Math.floor(4*Math.random()))
    for (var i=0;i<nmeds;i++) meds.push(mkdrug(i))

    if (n==7) {

        entries[0]['title']='Angina';
        entries[0]['text']='Chest pain on exertion.  Settles with rest.  Lasts 5-10 minutes.  Take bloods.  Start Aspirin and Atenolol.';
        entries[0]['docType']='GP';
        entries[0]['importance']='High';
        entries[0]['acute']=true;

        entries[1]['title']='Hypertension';
        entries[1]['text']='Monitoring BP = 130/80, continue Amlodipine.  Blood results OK.';
        entries[1]['docType']='GP';
        entries[1]['importance']='Low';
        entries[1]['acute']=false;

        entries[2]=mkentry(2,true)

        entries[3]['title']='Hypertension';
        entries[3]['text']='Monitoring BP = 150/90, increase Amlodipine.  10mg OD, take bloods';
        entries[3]['docType']='GP';
        entries[3]['importance']='Low';
        entries[3]['acute']=true;

        entries[4]['title']='Hypertension';
        entries[4]['text']='Monitoring BP = 170/100, start Amlodipine.  5mg OD';
        entries[4]['docType']='GP';
        entries[4]['importance']='Low';
        entries[4]['acute']=true;

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
        
        return {
            'id': n,
            'name': "James Carter",
            'dob': "1960-07-01",
            'age': "57",
            'entries': entries,
            'medications': meds
        }
    }

    return {
        'id': n,
        'name': mkname(),
        'dob': year+'-'+month+'-'+day,
        'age': age,
        'entries': entries,
        'medications': meds
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
appendPatientListFile('import PatientPageTypes exposing (Patient,Entry,Drug,Doctype(..),Importance(..))')
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

for (var i=0;i<patients.length;i++) {
    if (i!=0) appendPatientListFile('  ,')
    appendPatientListFile('  ('+i+' , Patient '+patients[i]['id']+' "'+patients[i]['name']+'" "'+patients[i]['dob']+'" "'+patients[i]['age']+'" '+entriesToString(patients[i]['entries'])+' '+medicationsToString(patients[i]['medications'])+' [] )')
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
