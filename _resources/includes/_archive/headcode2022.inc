<ouc:editor wysiwyg="no"/>

<!-- Site identity -->
<link rel="shortcut icon" href="/_resources/images/ltcc_logo_50_fullcolor.png" />

<!-- Legacy stylesheets: base first, then site and nested-menu overrides. -->
<link href="/_resources/css/main2022.css" rel="stylesheet" />
<link href="/_resources/css/custom2022.css" rel="stylesheet" />
<link href="/_resources/css/nested-menu.css?v=1.1" rel="stylesheet" />

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
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.1/jquery.js"></script>

<!-- Google Tag Manager: asynchronously loads container GTM-MJWSFZN3. -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-MJWSFZN3');</script>

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

    // Replace the footer while retaining the CMS direct-edit markup.
    $.ajax({
      url: "/_resources/includes/footer.php",
      type: "GET",
      success: function (src) {
        var directEditHtml = $("#directedit").html();
        $("#main-footer").replaceWith(src);
        $("#directedit").html(directEditHtml);
      }
    });

    $("#nav-container").append($("#main-nav"));
  });
</script>
