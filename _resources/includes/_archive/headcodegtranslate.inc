<ouc:editor wysiwyg="no"/>
<link href="https://www.ltcc.edu/_resources/css/main.min.css" rel="stylesheet" />

<script src="https://www.ltcc.edu/_resources/js/head.min.js"></script>

<link href="https://www.ltcc.edu/_resources/css/custom.css" rel="stylesheet" />
<style>
	@media screen and (min-width: 71.25em) {
#main-nav > .row > ul {
     display: -webkit-box;  /* OLD - iOS 6-, Safari 3.1-6, BB7 */
  display: -ms-flexbox;  /* TWEENER - IE 10 */
  display: -webkit-flex; /* NEW - Safari 6.1+. iOS 7.1+, BB10 */
  display: flex;         /* NEW, Spec - Firefox, Chrome, Opera */
    flex-direction: row;
}
	 #main-nav > .row > ul li {
	     -webkit-box-flex: 1;   /* OLD - iOS 6-, Safari 3.1-6 */ 
  -webkit-flex: 1;       /* Safari 6.1+. iOS 7.1+, BB10 */
  -ms-flex: 1;           /* IE 10 */
  flex: 1;               /* NEW, Spec - Firefox, Chrome, Opera */
		 }
	#nav-container nav .row > ul > li > a { padding-left:2px; padding-right:2px;}
	}
	
	.goog-te-gadget-simple { 
    background: transparent !important;
    border: 0 !important;
    padding: 0 !important;
    margin: 0 !important;
    font-family: "Tahoma", sans-serif !important;
    font-size: 14px !important;
}

div#google_translate_element {
    padding: 0 !important; 
    margin-top: 0 !important;
}
	
	/* hide dividing line */
	a.goog-te-menu-value span:nth-of-type(3n+2) {
    display: none !important;
}
	a.goog-te-menu-value span:nth-of-type(3n+3) {
    color: #fff !important;
}
	
	.translatetab {
    position: relative;
    display: inline-block;
    top: 2px;
}
</style>

<!-- Latest compiled and minified Bootstrap CSS -->
<!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous"/> -->


<!--[if lte IE 9]>
<script src="_resources/js/compat.min.js"></script>
<![endif]-->

<!-- Favicons -->
<link rel="shortcut icon" href="https://www.ltcc.edu/_resources/img/favicon.png" />


<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.1/jquery.js"></script>
<script>

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



</script>
