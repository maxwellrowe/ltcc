function cleartimer() {     
	setTimeout(function(){ 
		window.clearInterval(myVar); 
	}, 1000);			  
}
function myTimer() {
	if ($('.goog-te-menu-value > span:first-child').length) {
		$('.goog-te-menu-value > span:first-child').html('Translate');
		cleartimer();
	}
}
var myVar = setInterval(function(){ myTimer() }, 300); 

