<?php /* Loaded in the head by common.xsl and CMS preview templates. Provides fonts, theme CSS, and shared head scripts. */ ?>
<ouc:editor wysiwyg="no"/>

<!-- Site identity -->
<link rel="shortcut icon" href="/_resources/img/favicon_50.png" />

<!-- Google Fonts: connect early, then load Barlow. -->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
<link href="https://fonts.googleapis.com/css2?family=Barlow:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&amp;display=swap" rel="stylesheet" />

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@12.2.0/swiper-bundle.min.css" />

<!-- Stylesheets: legacy base, Bootstrap + LTCC overrides, then Font Awesome. -->
<link href="/_resources/css/legacy.css" rel="stylesheet" />
<link href="/_resources/css/ltcc-custom.css" rel="stylesheet" />
<link href="/_resources/fonts/font-awesome/css/all.min.css" rel="stylesheet" />
<!-- Legacy v4 icon names mapped to the installed Sharp and Brands fonts. -->
<link href="/_resources/css/fontawesome-v4-shim.css" rel="stylesheet" />

<!-- Translation control label styling -->
<style>
  .goog-te-menu-value span:first-child {
    display: none;
  }

  .goog-te-menu-value::before {
    content: 'Select Language';
  }
</style>

<!-- Remove no-js before rendering; component setup waits for DOM readiness. -->
<script src="/_resources/js/ltcc-custom.js"></script>

<!-- jQuery must load synchronously before the inline setup and legacy scripts. -->
<script src="https://code.jquery.com/jquery-4.0.0.min.js"></script>
<!-- Compatibility bridge for legacy plugins during the theme rebuild. -->
<script src="https://code.jquery.com/jquery-migrate-4.0.2.min.js"></script>



<!-- Advertiser Reports: existing snippets retained pending GTM migration.
     These are duplicate variants; the first is HTML-escaped, the second plain JS. -->
<script type="text/javascript">
!function(){function t(){var t=r("utm_content");if(t){var e=new Date;e.setDate(e.getDate()+30),document.cookie=t+";expires="+e.toGMTString()+";path=/"}else if(document.cookie)for(var o=document.cookie.split(/; */),n=0;n&lt;o.length;n++)if(0===o[n].toLowerCase().trim().indexOf("utm_content=")){t=o[n];break}return t}function e(t){try{console.log(t)}catch(e){alert(t)}}function r(t){var e=top.location.search?top.location.search.substring(1):null;if(e)for(var r=e.split("&amp;"),o=0;o&lt;r.length;o++)if(0===r[o].toLowerCase().trim().indexOf(t+"="))return r[o];return null}var o="",n=r("mctest");if(n)e("dnr tag version: 20160125"),o="http://localhost:8080/rip/library/dnr/mcDnrTag.debug.js";else{var a=t(),c="";a&amp;&amp;(c=top.location.search?0&lt;=top.location.search.indexOf("utm_content")?top.location.search:top.location.search+"&amp;"+a:"?"+a,o="https://script.advertiserreports.com/redirector/dnr"+c)}if(o){var i=document.createElement("script");i.src=o,i.type="text/javascript",scriptTag=document.getElementsByTagName("script")[0],scriptTag.parentNode.appendChild(i)}}();
</script>

<script type="text/javascript">
!function(){function t(){var t=r("utm_content");if(t){var e=new Date;e.setDate(e.getDate()+30),document.cookie=t+";expires="+e.toGMTString()+";path=/"}else if(document.cookie)for(var o=document.cookie.split(/; */),n=0;n<o.length;n++)if(0===o[n].toLowerCase().trim().indexOf("utm_content=")){t=o[n];break}return t}function e(t){try{console.log(t)}catch(e){alert(t)}}function r(t){var e=top.location.search?top.location.search.substring(1):null;if(e)for(var r=e.split("&"),o=0;o<r.length;o++)if(0===r[o].toLowerCase().trim().indexOf(t+"="))return r[o];return null}var o="",n=r("mctest");if(n)e("dnr tag version: 20160125"),o="http://localhost:8080/rip/library/dnr/mcDnrTag.debug.js";else{var a=t(),c="";a&&(c=top.location.search?0<=top.location.search.indexOf("utm_content")?top.location.search:top.location.search+"&"+a:"?"+a,o="https://script.advertiserreports.com/redirector/dnr"+c)}if(o){var i=document.createElement("script");i.src=o,i.type="text/javascript",scriptTag=document.getElementsByTagName("script")[0],scriptTag.parentNode.appendChild(i)}}();
</script>

<!-- Legacy page setup: requires jQuery above; runs after the DOM is ready. -->
<script>
  $(document).ready(function () {
    // Navigation, search, and translation layout.
    $(".top-nav > ul").remove();
    $(".site-search").addClass("search-container");

    if ($(".translatetab p.translate").length === 0) {
      $(".translatetab")
        .addClass("translate-container")
        .prepend('<p class="translate">Translate</p>');
    }

    $(".logo-banner > .row > a").first().addClass("columns small-12 large-8");

    $("#nav-container").append($("#main-nav"));
  });
</script>
