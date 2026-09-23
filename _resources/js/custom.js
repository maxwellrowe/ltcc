//This is a custom-made document uploaded to the CMS
jQuery(document).ready(function(){
	
	//Debug Check
	console.log("Ready");
	
	//Appending a Horizontal Rule to all Page Title Elements
	$(".alt-title").append('<hr></hr>');
	
	//Implementing the Map Icon in the Top Global Navigation
	$(".top-nav ul").append('<a class="mapLink" href="http://ltcc.edu/about/location.php" target="_parent" rel="noopener noreferrer"> <img class="mapIcon" src="http://ltcc.edu/_resources/images/ltcc_images/assets/map_icon.png" alt="Map Icon" /> </a>');
	
	//Disable/Remove Caret Dropdown
	$('.expand').remove();
	
	//Show/Hide Mobile Navigation
	/*
	$('.menu-link, .close-nav').click(function(){
		if ($('#nav-container').is(':hidden')) {
			$('#nav-container').show();
		} else {		
		$('#nav-container').hide();
		}
	});	
	*/
	
	//Expand Report Form Function		
	$('#reportAnchor').click(function(){
		$('.reportFormContainer').toggle();
		console.log('Report Anchor Clicked');
	});
	
	$('#clr_202fcfd8-6481-4ad8-871a-cc505597d254, .closeReportForm').click(function(){
		$('.reportFormContainer').hide();
		console.log('Report Form Closed');
	});
	
	$('#btn_202fcfd8-6481-4ad8-871a-cc505597d254').click(function(){
		console.log('totes');
		
	});
	
	/*$('#reportAnchor').click(function(){
		$('.screenshotFull', this).toggle();		
	});*/

	
});
