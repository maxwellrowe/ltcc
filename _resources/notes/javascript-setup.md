# Shared JavaScript setup

- jQuery 4.0.0 and jQuery Migrate 4.0.2 load synchronously in `includes/headcode.inc` (and the separate anniversary head). Migrate remains as a compatibility bridge for older plugins.
- The gallery XSL templates use that shared copy; they no longer load jQuery 1.9.1 or change `$` with `noConflict()`.
- `js/main.js` retains the legacy Foundation, Slick, and site behavior, with the embedded jQuery 2.1.4 removed. `npm run build:js` generates `js/legacy-site.min.js`, loaded by `footcode.inc` in place of the archived bundle. Slick image events, bxSlider's load trigger, and prettyPhoto's `.size()` calls were updated for current jQuery. Publish the changed gallery JS as well as the XSL.
- Swiper's CDN bundle and stylesheet supply all modules. New sliders still need their own `new Swiper(...)` configuration. The anniversary template reuses the shared assets.
- Motion 14.0.0 loads from CDN before `js/ltcc-animations.js`. There is no Motion npm dependency or animation build step. Edit the animation file directly.

## Scroll animation classes

Use one of `anim-scroll-fade`, `anim-scroll-fade-up`, `anim-scroll-slide-left` (from right to left), or `anim-scroll-slide-right` (from left to right).

Add one delay class such as `anim-delay-200` or `anim-delay-500`. Any nonnegative whole-number millisecond suffix is supported. Default delay is zero. Each animation runs once, when the element first intersects the viewport area ending 80px above its bottom edge, with a 600ms duration. Directional reveals animate clip-path from fully clipped to fully visible, with no fade or sideways movement. Layout width remains fixed. Prefer a wrapper for content that already uses transforms or clip-path.

Reduced-motion preferences skip animation and delay. Once Motion is ready, JavaScript adds `anim-pending` to offscreen elements; theme CSS uses `html:not(.no-js) .anim-pending` to hold their opacity at zero until the reveal finishes. Animation setup is skipped when the HTML element has `no-js`. Elements already visible at initialization stay visible without animating, avoiding a loading flash. Without JavaScript or Motion, no pending class is added and content remains readable. Reduced-motion changes clear pending states; keyboard focus and printing also expose pending content. For inserted content, call `LTCC.animations.init(container)`; repeated initialization is safe.

Working examples and class documentation are in `_dev/bootstrap-theme/index.html#animations`.

## Publishing / verification

Publish changed shared includes, the animation script, generated legacy script, changed gallery scripts, and changed XSL templates together. Package files and `node_modules` are local build tooling. Run `npm run build` to rebuild CSS and the legacy bundle.

Build and scripted animation lifecycle checks pass. Actual legacy galleries, Foundation navigation, Slick sliders, anniversary components, and CMS editing still need browser checks in Modern Campus before production publication; the compatibility bridge does not guarantee every legacy interaction is compatible with jQuery 4.

## Font Awesome v4 compatibility

`headcode.inc` loads `css/fontawesome-v4-shim.css` after the installed Font Awesome stylesheet. The shim maps legacy `.fa` names to Sharp/Brands and aliases the old `FontAwesome` font family for pseudo-elements. It replaces the v4.3 CDN import formerly in `legacy.css`. Run `npm run build:icons` after changing the installed Font Awesome package. Standard CMS icon classes can remain; custom Unicode-based icons should be checked visually.
