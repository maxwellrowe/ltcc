<ouc:editor wysiwyg="no"/>
<link href="https://www.ltcc.edu/_resources/css/main2022.css" rel="stylesheet" />
<script type="text/javascript">
!function(){function t(){var t=r("utm_content");if(t){var e=new Date;e.setDate(e.getDate()+30),document.cookie=t+";expires="+e.toGMTString()+";path=/"}else if(document.cookie)for(var o=document.cookie.split(/; */),n=0;n&lt;o.length;n++)if(0===o[n].toLowerCase().trim().indexOf("utm_content=")){t=o[n];break}return t}function e(t){try{console.log(t)}catch(e){alert(t)}}function r(t){var e=top.location.search?top.location.search.substring(1):null;if(e)for(var r=e.split("&amp;"),o=0;o&lt;r.length;o++)if(0===r[o].toLowerCase().trim().indexOf(t+"="))return r[o];return null}var o="",n=r("mctest");if(n)e("dnr tag version: 20160125"),o="http://localhost:8080/rip/library/dnr/mcDnrTag.debug.js";else{var a=t(),c="";a&amp;&amp;(c=top.location.search?0&lt;=top.location.search.indexOf("utm_content")?top.location.search:top.location.search+"&amp;"+a:"?"+a,o="https://script.advertiserreports.com/redirector/dnr"+c)}if(o){var i=document.createElement("script");i.src=o,i.type="text/javascript",scriptTag=document.getElementsByTagName("script")[0],scriptTag.parentNode.appendChild(i)}}();
</script>
<script src="https://www.ltcc.edu/_resources/js/head.min.js"></script>

<link href="https://www.ltcc.edu/_resources/css/custom2022.css" rel="stylesheet" />

<link href="/_resources/css/nested-menu.css" rel="stylesheet" />

<!-- Latest compiled and minified Bootstrap CSS -->
<!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous"/> -->
<script type="text/javascript">
!function(){function t(){var t=r("utm_content");if(t){var e=new Date;e.setDate(e.getDate()+30),document.cookie=t+";expires="+e.toGMTString()+";path=/"}else if(document.cookie)for(var o=document.cookie.split(/; */),n=0;n<o.length;n++)if(0===o[n].toLowerCase().trim().indexOf("utm_content=")){t=o[n];break}return t}function e(t){try{console.log(t)}catch(e){alert(t)}}function r(t){var e=top.location.search?top.location.search.substring(1):null;if(e)for(var r=e.split("&"),o=0;o<r.length;o++)if(0===r[o].toLowerCase().trim().indexOf(t+"="))return r[o];return null}var o="",n=r("mctest");if(n)e("dnr tag version: 20160125"),o="http://localhost:8080/rip/library/dnr/mcDnrTag.debug.js";else{var a=t(),c="";a&&(c=top.location.search?0<=top.location.search.indexOf("utm_content")?top.location.search:top.location.search+"&"+a:"?"+a,o="https://script.advertiserreports.com/redirector/dnr"+c)}if(o){var i=document.createElement("script");i.src=o,i.type="text/javascript",scriptTag=document.getElementsByTagName("script")[0],scriptTag.parentNode.appendChild(i)}}();
</script>

<!--[if lte IE 9]>
<script src="_resources/js/compat.min.js"></script>
<![endif]-->

<!-- Favicons -->
<link rel="shortcut icon" href="https://www.ltcc.edu/_resources/img/favicon_50.png" />

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