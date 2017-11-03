var numPatients=24;
var numJobs=30;

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

var patients={}
for (var i=0;i<numPatients;++i) patients[i]=mkpatient();

var jobs={}
for (var i=0;i<numJobs;++i) jobs[i]=mkjob();

console.log(
    JSON.stringify(
        {
            "patients":patients,
            "jobs":jobs
        },
        null,
        2
    )
)
