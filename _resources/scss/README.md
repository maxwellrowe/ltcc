# LTCC Bootstrap theme

Bootstrap 5.3.8 is pinned in the repository package.json and CDN script tags.
Run these commands from the repository root (`ltcc/`, beside this project's README):

```sh
npm ci
npm run build
npm run watch:css
```

The build emits `_resources/css/ltcc-custom.css`, including all Bootstrap CSS and
LTCC overrides. Commit the generated CSS with source changes; Modern Campus does
not need Node or Sass to serve the theme. Do not edit the generated CSS directly.
The parent workspace's older Bootstrap package and customized SCSS are separate.

## Customization

`ltcc-custom.scss` imports settings before Bootstrap so its derived colors,
components, and utilities inherit the custom values. The initial settings files
contain commented examples only and retain upstream defaults.

- `settings/_palette.scss`: brand colors, body and link colors.
- `settings/_typography.scss`: font families, sizing, line height.
- `settings/_containers.scss`: breakpoints, container widths, gutters.
- `settings/_borders.scss`: shared radii and borders.
- `settings/_buttons.scss`: button padding, weight, radius.
- `settings/_options.scss`: other Bootstrap variables and feature flags.
- `theme/`: additional base, layout, component, and utility CSS after Bootstrap.

Bootstrap 5.3 itself uses Sass @import and deprecated Sass functions. Compiler
warnings from these imports are expected; compilation errors are not.

## Loading and migration

New templates can include `/_resources/includes/headcode.inc` in the head and
`/_resources/includes/footcode.inc` before the closing body tag. Templates must
also supply the HTML5 doctype, charset, and responsive viewport meta tag.

The stylesheet already contains Bootstrap: do not add Bootstrap CDN CSS.
The pinned CDN JS bundle includes Popper and every Bootstrap JS component.
`ltcc-custom.js` follows it and initializes opt-in tooltips and popovers.
Other controls use Bootstrap's `data-bs-*` attributes. Toasts can be shown with
`data-ltcc-toggle="toast" data-ltcc-target="toast-element-id"`, or the Bootstrap API.
Call `window.LTCC.init(container)` after inserting new child content dynamically.
Carousel autoplay and Scrollspy use their standard Bootstrap data attributes/API.
Font Awesome is loaded by headcode.inc from the self-hosted fonts/font-awesome directory.

The shared headcode.inc now loads Barlow and ltcc-custom.css in place of
main2022.css and custom2022.css, plus self-hosted Font Awesome. It retains
nested-menu.css, existing scripts, tracking, translation, and footer behavior.
The 2022 and alert templates now share headcode.inc; headcode2022.inc is archived.
Existing footer/XSL loaders still use legacy assets,
including Bootstrap 3 JS; their migration remains outstanding. On migration, replace their legacy
asset loading rather than adding both Bootstrap versions. Preserve necessary
analytics, translation, direct-edit, and site behavior separately. Legacy markup
(e.g. data-toggle/data-target) needs conversion to Bootstrap 5 data-bs-* markup.
The anniversary theme has its own bundle and must not load a second copy.

Open `_dev/bootstrap-theme/index.html` for an isolated component preview (internet
access is needed for the CDN JS). It also works when served with `ltcc/` as the
web root. Palette and other visual customization are intentionally deferred.

When upgrading Bootstrap, update the package pin, lockfile, CDN URL and SRI hash
in the footer include and preview together, then rebuild and check interactions.

## Approved theme direction

Use Figma Presentation as the visual reference. Customize existing Bootstrap
variables and classes without a separate token/utility system. Global primary
is #003E51 and secondary is #007A33. Solid primary/secondary buttons use #20C997 / #00B0FF. Outline primary uses bright blue with blue-800 text; outline secondary uses bright green with green-900 text. Hover and active states use the bright fill and dark border/text. All button sizes use a 3px radius and weight 600, via Bootstrap variables and button mixins.
Default text links inherit surrounding text color, with a #0033A0 underline
and 0.2em underline offset. Hover text changes to #0033A0 and the underline changes to #20C997.
Global dark mode generation is disabled; use dark sections where designed.
Mobile body size target is 14px; responsive sizing/clamp implementation is deferred.

## Bootstrap palette mapping

Figma node 5512:1044 supplies exact gray, blue, and green 100–900 Sass scales.
`$blue` / `--bs-blue` use the main blue swatch (#00A3E0); `$green` uses the
500 midpoint (#198754), and `$teal` remains #20C997. The blue scale is deliberately
not a generated light-to-dark ramp, and green-300/400 intentionally match Figma.
Bootstrap emits gray shades as `--bs-gray-100` through `--bs-gray-900`; blue/green
shade scales remain Sass variables, following Bootstrap's existing structure.
Other hue families retain Bootstrap defaults because this board does not redefine
them. Primary/secondary subtle backgrounds and emphasis text match the explicit
light/dark brand swatches. CTA button overrides and inherited text links remain.

## Palette background utilities

Use bg-gray-100 through bg-gray-900, bg-blue-100 through bg-blue-900,
and bg-green-100 through bg-green-900. These extend Bootstrap's utility map
in settings/_utilities.scss and support bg-opacity-10/25/50/75/100.
Text colors remain independent. See the theme preview for swatches and examples.
The full Bootstrap import stack keeps map customization before utilities/api.

Light buttons use green-100 backgrounds and green-900 text; hover/active backgrounds are bright green (#20C997). Bright accent background utilities are `bg-bright-green` (#20C997) and `bg-bright-blue` (#00B0FF), with Bootstrap `bg-opacity-*` support.

Button padding (vertical / horizontal): small `.375rem .9375rem`, default `.5rem 1.25rem`, large `.75rem 1.875rem`. Each size uses a 2.5:1 horizontal-to-vertical ratio.

Solid primary button hover borders use green-900 (#002911); solid secondary hover borders use blue-900 (#003043).
