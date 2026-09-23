// function to get parameters from URL and prepoulate form fields
// www.school.edu/forms/survey.html?first_name=charlie&last_name=mac&institution=school
function getURLvariable(variable)
{
var query = window.location.search.substring(1);
var vars = query.split("&");
for (var i=0;i<vars.length;i++) {
var pair = vars[i].split("=");
	if(pair[0] == variable){return pair[1];}
	}
	return(false);
}

var first_name = getURLvariable('first_name');
var last_name = getURLvariable('last_name');
var institution = getURLvariable('institution');

if( first_name ) {
document.getElementById("id_Name").value = first_name + ' ' + last_name;	
}
if( institution ) {
document.getElementById("id_Institution").value = institution;	
}
	
