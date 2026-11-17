# Anniversary components in the shared theme

The new theme supports the existing anniversary component class names without loading anniversary `components.css`, `fiftieth.css`, `utilities.css` or `components.js`.

## Included

- `.ltcc-button-group` / `.ltcc-button` links, event cards, quote blocks and CTA cards.
- `.swiper.ltcc-image-swiper`: automatic-width image slides, image zoom wrappers if supplied, instance-scoped previous/next controls, autoplay and a generated pause/play button.
- `.swiper.ltcc-profile-swiper`: one/two/three slides at mobile/md/lg, instance-scoped controls, autoplay and pause/play.
- `.ltcc-card-profile`, profile modal portrait/tag styles, and profile filters. Existing `bg-green-tree` / `bg-blue-tree` card classes use shared colors and a local copy of the tree artwork.
- Existing `match-height-row` and `match-height-all` classes are supported per containing Bootstrap row or Swiper wrapper, without jQuery matchHeight. New components should favor Bootstrap flex/h-100 layouts.
- Existing `data-aos` attributes continue through `ltcc-animations.js`; no AOS calls remain in the migrated component script.

All typography uses the shared Barlow font. Anniversary Sullivan/Avant font class names are retained as scoped aliases within profile cards/modals, not loaded as separate fonts. Global anniversary utilities/editor styles and header/footer rules were deliberately not imported. Use current theme utilities in new markup.

## Profile filter markup

Existing PHP output works when `.ltcc-profiles-filter` is immediately followed by its card grid. For other layouts, set `aria-controls="grid-id"` on the filter bar to associate an explicit grid. Each button's `data-toggle` contains the category class (`type-alumni`, `type-influential`); omit it for All. Each card column keeps `.ltcc-card-profile-col` and its category class.

Only the first filter group owns the legacy `#alumni` / `#influential` URL state. Additional groups filter independently. All preserves unrelated page hashes. Filters expose their selection with `aria-pressed`.

## Initialization and modal placement

`footcode.inc` loads `ltcc-components.js` after Swiper/Motion. Initializers are safe to call repeatedly. `LTCC.init(container)` moves modal elements directly under body and initializes the migrated components within that container. `LTCC.animations.init(container)` initializes scroll reveals for newly inserted content. The profile filter calls the animation initializer when cards become visible.

For content inserted later, call the appropriate initializer after inserting it. There is no page-wide mutation observer. Existing PHP-generated modal IDs must be unique across instances; the front-end cannot disambiguate duplicate IDs.

Autoplay pauses on pointer hover, focus inside slide content, when offscreen, or when the document is hidden. Reduced-motion preferences disable initial autoplay and set transition speed to zero. Users can explicitly start playback. Rewind is used instead of loop cloning, avoiding duplicate profile links/IDs and small-slide-count loop restrictions.

## Deploy

Publish:

- `_resources/css/ltcc-custom.css`
- `_resources/js/ltcc-components.js`
- `_resources/js/ltcc-custom.js`
- `_resources/js/ltcc-animations.js`
- `_resources/includes/footcode.inc`
- `_resources/img/components/profile-tree.svg`

Keep the anniversary site's original files unchanged. Do not also load its old `components.js` on new-theme pages: its AOS calls and global initializers would duplicate or conflict with the migrated behavior. No PHP feeds or CMS component templates were modified.

## Preview and verification

`/_dev/bootstrap-theme/migrated-components.html` contains buttons, quote, CTA/event cards, two independent image carousels, two profile filter grids, a profile carousel and modal examples. The existing `example-components.html` now loads the new component script and links to this focused demo; its supplied component content is preserved.

The supplied existing example file contained no `.ltcc-image-swiper`/profile instances at inspection time, so the separate demo uses the class structure from the anniversary PHP output. Demonstration profiles are not real biographies.

Validation: Sass build, JavaScript syntax, existing animation tests, and headless Chrome checks at 1440px/600px. Browser checks covered carousel control isolation, profile filtering/isolation, URL state, modal relocation/open/close, equal-height compatibility, idempotent initialization, responsive slide counts, overflow, and (mobile run) visible portrait geometry and pause behavior. Test logic is in `scripts/tests/migrated-components.browser.js` and is not loaded in production.
