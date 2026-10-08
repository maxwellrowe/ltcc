<?php /* Loaded near the end of pages and CMS previews. Provides Bootstrap, legacy site scripts, and direct editing. */ ?>
<ouc:editor wysiwyg="no"/>

<!-- Bootstrap 5 bundle includes Popper and all interactive components. -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
<!-- ltcc-custom.js loads in headcode.inc and initializes at DOM readiness. -->

<!-- Swiper bundle includes all modules; initialize individual sliders as needed. -->
<script src="https://cdn.jsdelivr.net/npm/swiper@12.2.0/swiper-bundle.min.js"></script>
<!-- Motion must load before the LTCC animation presets. -->
<script src="https://cdn.jsdelivr.net/npm/motion@14.0.0/dist/motion.js"></script>
<script src="/_resources/js/ltcc-animations.js"></script>

<!-- Legacy site behavior and CMS editing -->
<script src="/_resources/js/legacy-site.min.js"></script>
<!-- direct edit -->
<script src="https://www.ltcc.edu/_resources/js/direct-edit.js"></script>
<script src="/_resources/js/nested-menu.js?v=1.1"></script>
<script>
// Dismissible Alert Script
document.addEventListener('DOMContentLoaded', () => {
    const closeButton = document.querySelector('.close');
    if (closeButton) {
        closeButton.addEventListener('click', () => {
            const alertBanner = document.querySelector('.alert');
            if (alertBanner) alertBanner.style.display = 'none';
        });
    }
});
</script>
