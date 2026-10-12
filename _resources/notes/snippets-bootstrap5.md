# Snippet Bootstrap 5 review

Only `_resources/xsl/_shared/snippets.xsl` was migrated. Existing CMS snippet table names and input fields are unchanged; pages must be republished to receive the new output.

## Updated

- All 20 snippet/supporting templates have numbered comments and a matching index at the top of the stylesheet.
- `ou-ltcc-iframe`: full-width Google Map with a fixed 450px height, descriptive title, and no obsolete `frameborder` attribute. The existing home-page CSS still sets map height to 200px.
- Generic `iframe` handling: recognized YouTube (including privacy-enhanced youtube-nocookie) and Vimeo player embeds receive Bootstrap `ratio ratio-16x9`. Existing direct-parent Bootstrap ratio wrappers are respected. Maps and other embeds retain their supplied dimensions, without the unsupported `responsive-iframe` wrapper.

- `ou-cta-green`: Bootstrap columns and full-width `btn btn-primary` links (the theme's bright green solid button).
- `ou-two-columns-2-1`: `col-12 col-md-8` / `col-12 col-md-4`.
- `ou-faculty-list`: `col-12` wrapper and `visually-hidden` labels; custom faculty layout preserved.
- `ou_accordion_2`: Bootstrap 5 accordion structure, real buttons, `data-bs-toggle`, `data-bs-target`, `data-bs-parent`, and corrected ARIA target relationships. Starts collapsed, with one item open at a time. Valid unique author IDs are retained; blank, invalid, or repeated IDs get generated fallbacks. Item IDs are now scoped and generated, so old deep links to individual collapse panels may need updating.
- `ou-homepage-icon-links`: `col-12` outer wrapper; custom icon arrangement preserved.
- `ou-homepage-factoids`: added the missing `row`; uses `col-12 col-md-4`.
- `ou-homepage-hero-video`: CTA classes changed to `btn btn-primary`; accessibility label uses `visually-hidden`. Custom video markup/behavior remains.
- `ou-homepage-alert-banner`: `col-12` and Bootstrap's `btn-close` / `data-bs-dismiss="alert"`.
- `ltcc-section` and `ltcc-container`: process content cell children so no orphan `td` is emitted into the layout.

The old Foundation medium breakpoint was 640px; these columns now use the Bootstrap theme's md breakpoint (768px with current settings).

## Left unchanged / decisions needed

- Gallery/slideshow and `ou-slider-banner`: keep Slick markup and controls. A Swiper conversion requires coordinated JavaScript and markup changes.
- `ou-homepage-student-types`: custom slider, thumbnail, and rollover behavior retained; no automatic Bootstrap carousel conversion.
- `ou-static-banner`, `ou-chevron-list`, `ou-form-block`: custom structures have no direct Bootstrap replacement. Form output continues to come from the separate form templates.
- Faculty cards, icon links, factoid visuals, and hero video layout remain site-specific.
- Alert color/variant: no `alert-info`, `alert-warning`, etc. selected because the intended meaning/color is unspecified. The obsolete dismiss behavior was updated independently.
- `ltcc-columns`: author-entered class strings remain unchanged. Existing CMS content may still supply Foundation classes; new content should supply Bootstrap `col-*` classes.
- `p-to-br`: text conversion helper retained.

Other accordion templates in `_shared/transformations.xsl` are outside this file's scope and remain legacy markup.

## Validation

XML parsing and structural assertions pass: same template matches, no hardcoded Foundation column classes or legacy button/data attributes, accordion control/target relationships present, and slider templates unchanged. Full XSLT 3 rendering and browser interaction checks still need Modern Campus; its server imports are not available locally.
