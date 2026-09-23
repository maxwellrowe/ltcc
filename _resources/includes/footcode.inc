<ouc:editor wysiwyg="no"/>
<script src="https://www.ltcc.edu/_resources/js/main.min.js"></script>
<!-- direct edit -->
<script src="https://www.ltcc.edu/_resources/js/direct-edit.js"></script>
<script src="/_resources/js/nested-menu.js?v=1.1"></script>
<script src="https://www.ltcc.edu/_resources/js/custom.js"></script>
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
