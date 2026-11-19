<ouc:editor wysiwyg="no"/>
<div class="modal fade notranslate" id="site-translation" tabindex="-1" aria-labelledby="site-translation-label" aria-hidden="true" translate="no">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title fs-5" id="site-translation-label">Translate LTCC</h2>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <label class="form-label" for="site-translation-language">Choose a language</label>
                <p class="text-body-secondary" data-translation-status="" role="status">Loading languages…</p>
                <?php include($_SERVER['DOCUMENT_ROOT'] . '/_resources/includes/google-translate.inc'); ?>
                <noscript><p>Enable JavaScript to use Google Translate.</p></noscript>
            </div>
        </div>
    </div>
</div>
