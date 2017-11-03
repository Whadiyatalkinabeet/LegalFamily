function cap(s) {
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
    return cap(randomtext())+' '+cap(randomtext());
}

function mkpatient(n) {

    var year=Math.floor(1918+100*Math.random())
    var month=Math.floor(1+12*Math.random())
    var day=Math.floor(1+31*Math.random())

    
    patient={
	'id':n,
	'name': mkname(),
	'dob': year+'-'+month+'-'+day,
	'age': 2017-year
    };
    return patient;
}

var patients=[]
for (var i=0;i<24;++i) patients.push(mkpatient(i));

console.log(
    JSON.stringify(
	{"patients":patients},
	null,
	2
    )
)
