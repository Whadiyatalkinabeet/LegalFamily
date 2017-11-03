
patient={
    'id': '1',
    'name': 'Joe Bloggs',
    'dob':'1966-07-27',
    'age':'51'
}

function mkpatient(n) {
    patient={
	'id':n,
	'name':
	'Joe Bloggs',
	'dob':'1966-07-27',
	'age':'51'
    };
    return patient;
}

var patients=[]
for (var i=0;i<10;++i) patients.push(mkpatient(i));

console.log(
    JSON.stringify(
	{"patients":patients},
	null,
	2
    )
)
