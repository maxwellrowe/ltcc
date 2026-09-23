<ouc:editor wysiwyg="no"/>
<link href="https://www.ltcc.edu/_resources/css/main2022.css" rel="stylesheet" />

<script src="https://www.ltcc.edu/_resources/js/head.min.js"></script>

<link href="https://www.ltcc.edu/_resources/css/custom2022.css" rel="stylesheet" />

<link href="/_resources/css/nested-menu.css?v=1.1" rel="stylesheet" />

<!-- Latest compiled and minified Bootstrap CSS -->
<!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous"/> -->


<!--[if lte IE 9]>
<script src="_resources/js/compat.min.js"></script>
<![endif]-->

<!-- Favicons -->
<link rel="shortcut icon" href="https://www.ltcc.edu//_resources/images/ltcc_logo_50_fullcolor.png" />

<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.1/jquery.js"></script>
<script src="https://www.ltcc.edu/_resources/js/google-translate.js"></script>

<!-- Google Tag Manager Updated 5-24-24 MT-->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-MJWSFZN3');</script>
<!-- End Google Tag Manager -->

<style>
	.goog-te-menu-value span:first-child {display:none}
	.goog-te-menu-value:before {content:'Select Language'}	
</style>

<script>
$( document ).ready(function() {

	$(".top-nav > ul").remove();
	$(".site-search").addClass("search-container");
	if ($(".translatetab p.translate").length === 0) {
		$(".translatetab").addClass("translate-container").prepend('<p class="translate">Translate</p>');
	}
	$(".logo-banner > .row > a").first().addClass("columns small-12 large-8");
    
	$.ajax({
        	url: "/_resources/includes/footer.php",
	        type: 'GET',
        	success: function(src) {
			var de_html = $("#directedit").html();
	        	$("#main-footer").replaceWith(src);
			$("#directedit").html(de_html);
	        }
	}); 

	$("#nav-container").append($("#main-nav"));

});
</script>